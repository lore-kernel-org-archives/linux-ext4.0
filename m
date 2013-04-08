From: Jan Kara <jack@suse.cz>
Subject: [PATCH 20/29] ext4: Use transaction reservation for extent conversion in ext4_end_io
Date: Mon,  8 Apr 2013 23:32:25 +0200
Message-ID: <1365456754-29373-21-git-send-email-jack@suse.cz>
References: <1365456754-29373-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53393 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936327Ab3DHVdG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Apr 2013 17:33:06 -0400
In-Reply-To: <1365456754-29373-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Later we would like to clear PageWriteback bit only after extent conversion
from unwritten to written extents is performed. However it is not possible
to start a transaction after PageWriteback is set because that violates
lock ordering (and is easy to deadlock). So we have to reserve a transaction
before locking pages and sending them for IO and later we use the transaction
for extent conversion from ext4_end_io().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4.h      |   12 +++++++++---
 fs/ext4/ext4_jbd2.h |    3 ++-
 fs/ext4/extents.c   |   39 ++++++++++++++++++++++++++++-----------
 fs/ext4/inode.c     |   32 ++++++++++++++++++++++++++++++--
 fs/ext4/page-io.c   |   11 ++++++++---
 5 files changed, 77 insertions(+), 20 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 3c3827a..65adf0d 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -182,10 +182,13 @@ struct ext4_map_blocks {
 #define EXT4_IO_END_DIRECT	0x0004
 
 /*
- * For converting uninitialized extents on a work queue.
+ * For converting uninitialized extents on a work queue. 'handle' is used for
+ * buffered writeback.
  */
 typedef struct ext4_io_end {
 	struct list_head	list;		/* per-file finished IO list */
+	handle_t		*handle;	/* handle reserved for extent
+						 * conversion */
 	struct inode		*inode;		/* file being written to */
 	unsigned int		flag;		/* unwritten or not */
 	loff_t			offset;		/* offset in the file */
@@ -1314,6 +1317,9 @@ static inline void ext4_set_io_unwritten_flag(struct inode *inode,
 					      struct ext4_io_end *io_end)
 {
 	if (!(io_end->flag & EXT4_IO_END_UNWRITTEN)) {
+		/* Writeback has to have coversion transaction reserved */
+		WARN_ON(!io_end->handle &&
+			!(io_end->flag & EXT4_IO_END_DIRECT));
 		io_end->flag |= EXT4_IO_END_UNWRITTEN;
 		atomic_inc(&EXT4_I(inode)->i_unwritten);
 	}
@@ -2550,8 +2556,8 @@ extern void ext4_ext_init(struct super_block *);
 extern void ext4_ext_release(struct super_block *);
 extern long ext4_fallocate(struct file *file, int mode, loff_t offset,
 			  loff_t len);
-extern int ext4_convert_unwritten_extents(struct inode *inode, loff_t offset,
-			  ssize_t len);
+extern int ext4_convert_unwritten_extents(handle_t *handle, struct inode *inode,
+					  loff_t offset, ssize_t len);
 extern int ext4_map_blocks(handle_t *handle, struct inode *inode,
 			   struct ext4_map_blocks *map, int flags);
 extern int ext4_ext_calc_metadata_amount(struct inode *inode,
diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index bb17931..88e95d7 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -132,7 +132,8 @@ static inline int ext4_jbd2_credits_xattr(struct inode *inode)
 #define EXT4_HT_MIGRATE          8
 #define EXT4_HT_MOVE_EXTENTS     9
 #define EXT4_HT_XATTR           10
-#define EXT4_HT_MAX             11
+#define EXT4_HT_EXT_CONVERT     11
+#define EXT4_HT_MAX             12
 
 /**
  *   struct ext4_journal_cb_entry - Base structure for callback information.
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 8064b71..ae22735 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4484,10 +4484,9 @@ retry:
  * function, to convert the fallocated extents after IO is completed.
  * Returns 0 on success.
  */
-int ext4_convert_unwritten_extents(struct inode *inode, loff_t offset,
-				    ssize_t len)
+int ext4_convert_unwritten_extents(handle_t *handle, struct inode *inode,
+				   loff_t offset, ssize_t len)
 {
-	handle_t *handle;
 	unsigned int max_blocks;
 	int ret = 0;
 	int ret2 = 0;
@@ -4502,16 +4501,31 @@ int ext4_convert_unwritten_extents(struct inode *inode, loff_t offset,
 	max_blocks = ((EXT4_BLOCK_ALIGN(len + offset, blkbits) >> blkbits) -
 		      map.m_lblk);
 	/*
-	 * credits to insert 1 extent into extent tree
+	 * This is somewhat ugly but the idea is clear: When transaction is
+	 * reserved, everything goes into it. Otherwise we rather start several
+	 * smaller transactions for conversion of each extent separately.
 	 */
-	credits = ext4_chunk_trans_blocks(inode, max_blocks);
+	if (handle) {
+		handle = ext4_journal_start_reserved(handle);
+		if (IS_ERR(handle))
+			return PTR_ERR(handle);
+		credits = 0;
+	} else {
+		/*
+		 * credits to insert 1 extent into extent tree
+		 */
+		credits = ext4_chunk_trans_blocks(inode, max_blocks);
+	}
 	while (ret >= 0 && ret < max_blocks) {
 		map.m_lblk += ret;
 		map.m_len = (max_blocks -= ret);
-		handle = ext4_journal_start(inode, EXT4_HT_MAP_BLOCKS, credits);
-		if (IS_ERR(handle)) {
-			ret = PTR_ERR(handle);
-			break;
+		if (credits) {
+			handle = ext4_journal_start(inode, EXT4_HT_MAP_BLOCKS,
+						    credits);
+			if (IS_ERR(handle)) {
+				ret = PTR_ERR(handle);
+				break;
+			}
 		}
 		ret = ext4_map_blocks(handle, inode, &map,
 				      EXT4_GET_BLOCKS_IO_CONVERT_EXT);
@@ -4522,10 +4536,13 @@ int ext4_convert_unwritten_extents(struct inode *inode, loff_t offset,
 				     inode->i_ino, map.m_lblk,
 				     map.m_len, ret);
 		ext4_mark_inode_dirty(handle, inode);
-		ret2 = ext4_journal_stop(handle);
-		if (ret <= 0 || ret2 )
+		if (credits)
+			ret2 = ext4_journal_stop(handle);
+		if (ret <= 0 || ret2)
 			break;
 	}
+	if (!credits)
+		ret2 = ext4_journal_stop(handle);
 	return ret > 0 ? ret2 : ret;
 }
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 0602a09..f8e78ce 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1327,6 +1327,8 @@ static void ext4_da_page_release_reservation(struct page *page,
 struct mpage_da_data {
 	struct inode *inode;
 	struct writeback_control *wbc;
+	handle_t *reserved_handle;	/* Handle reserved for conversion */
+
 	pgoff_t first_page;	/* The first page to write */
 	pgoff_t next_page;	/* Current page to examine */
 	pgoff_t last_page;	/* Last page to examine */
@@ -1973,8 +1975,13 @@ static int mpage_map_one_extent(handle_t *handle, struct mpage_da_data *mpd)
 	err = ext4_map_blocks(handle, inode, map, get_blocks_flags);
 	if (err < 0)
 		return err;
-	if (map->m_flags & EXT4_MAP_UNINIT)
+	if (map->m_flags & EXT4_MAP_UNINIT) {
+		if (!mpd->io_submit.io_end->handle) {
+			mpd->io_submit.io_end->handle = mpd->reserved_handle;
+			mpd->reserved_handle = NULL;
+		}
 		ext4_set_io_unwritten_flag(inode, mpd->io_submit.io_end);
+	}
 
 	BUG_ON(map->m_len == 0);
 	if (map->m_flags & EXT4_MAP_NEW) {
@@ -2274,6 +2281,7 @@ static int ext4_da_writepages(struct address_space *mapping,
 
 	mpd.inode = inode;
 	mpd.wbc = wbc;
+	mpd.reserved_handle = NULL;
 	ext4_io_submit_init(&mpd.io_submit, wbc);
 retry:
 	if (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_writepages)
@@ -2288,6 +2296,23 @@ retry:
 			break;
 		}
 
+		/* Reserve handle if it may be needed for extent conversion */
+		if (ext4_should_dioread_nolock(inode) && !mpd.reserved_handle) {
+			/*
+			 * We may need to convert upto one extent per block in
+			 * the page and we may dirty the inode.
+			 */
+			mpd.reserved_handle = ext4_journal_reserve(inode,
+				EXT4_HT_EXT_CONVERT,
+				1 + (PAGE_CACHE_SIZE >> inode->i_blkbits));
+			if (IS_ERR(mpd.reserved_handle)) {
+				ret = PTR_ERR(mpd.reserved_handle);
+				mpd.reserved_handle = NULL;
+				ext4_put_io_end(mpd.io_submit.io_end);
+				break;
+			}
+		}
+
 		/*
 		 * We have two constraints: We find one extent to map and we
 		 * must always write out whole page (makes a difference when
@@ -2364,6 +2389,9 @@ retry:
 		 */
 		mapping->writeback_index = mpd.first_page;
 
+	if (mpd.reserved_handle)
+		ext4_journal_free_reserved(mpd.reserved_handle);
+
 out_writepages:
 	trace_ext4_da_writepages_result(inode, wbc, ret,
 					nr_to_write - wbc->nr_to_write);
@@ -2977,7 +3005,7 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
 		 * for non AIO case, since the IO is already
 		 * completed, we could do the conversion right here
 		 */
-		err = ext4_convert_unwritten_extents(inode,
+		err = ext4_convert_unwritten_extents(NULL, inode,
 						     offset, ret);
 		if (err < 0)
 			ret = err;
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index cc59cd9..e8ee4da 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -55,6 +55,7 @@ static void ext4_release_io_end(ext4_io_end_t *io_end)
 {
 	BUG_ON(!list_empty(&io_end->list));
 	BUG_ON(io_end->flag & EXT4_IO_END_UNWRITTEN);
+	WARN_ON(io_end->handle);
 
 	if (atomic_dec_and_test(&EXT4_I(io_end->inode)->i_ioend_count))
 		wake_up_all(ext4_ioend_wq(io_end->inode));
@@ -81,13 +82,15 @@ static int ext4_end_io(ext4_io_end_t *io)
 	struct inode *inode = io->inode;
 	loff_t offset = io->offset;
 	ssize_t size = io->size;
+	handle_t *handle = io->handle;
 	int ret = 0;
 
 	ext4_debug("ext4_end_io_nolock: io 0x%p from inode %lu,list->next 0x%p,"
 		   "list->prev 0x%p\n",
 		   io, inode->i_ino, io->list.next, io->list.prev);
 
-	ret = ext4_convert_unwritten_extents(inode, offset, size);
+	io->handle = NULL;	/* Following call will use up the handle */
+	ret = ext4_convert_unwritten_extents(handle, inode, offset, size);
 	if (ret < 0) {
 		ext4_msg(inode->i_sb, KERN_EMERG,
 			 "failed to convert unwritten extents to written "
@@ -217,8 +220,10 @@ int ext4_put_io_end(ext4_io_end_t *io_end)
 
 	if (atomic_dec_and_test(&io_end->count)) {
 		if (io_end->flag & EXT4_IO_END_UNWRITTEN) {
-			err = ext4_convert_unwritten_extents(io_end->inode,
-						io_end->offset, io_end->size);
+			err = ext4_convert_unwritten_extents(io_end->handle,
+						io_end->inode, io_end->offset,
+						io_end->size);
+			io_end->handle = NULL;
 			ext4_clear_io_unwritten_flag(io_end);
 		}
 		ext4_release_io_end(io_end);
-- 
1.7.1

