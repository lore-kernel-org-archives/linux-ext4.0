From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 42/52] ext4: Add basic delayed allocation support
Date: Sat,  5 Jul 2008 13:36:08 -0400
Message-ID: <1215279378-30504-43-git-send-email-tytso@mit.edu>
References: <1215279378-30504-1-git-send-email-tytso@mit.edu>
 <1215279378-30504-2-git-send-email-tytso@mit.edu>
 <1215279378-30504-3-git-send-email-tytso@mit.edu>
 <1215279378-30504-4-git-send-email-tytso@mit.edu>
 <1215279378-30504-5-git-send-email-tytso@mit.edu>
 <1215279378-30504-6-git-send-email-tytso@mit.edu>
 <1215279378-30504-7-git-send-email-tytso@mit.edu>
 <1215279378-30504-8-git-send-email-tytso@mit.edu>
 <1215279378-30504-9-git-send-email-tytso@mit.edu>
 <1215279378-30504-10-git-send-email-tytso@mit.edu>
 <1215279378-30504-11-git-send-email-tytso@mit.edu>
 <1215279378-30504-12-git-send-email-tytso@mit.edu>
 <1215279378-30504-13-git-send-email-tytso@mit.edu>
 <1215279378-30504-14-git-send-email-tytso@mit.edu>
 <1215279378-30504-15-git-send-email-tytso@mit.edu>
 <1215279378-30504-16-git-send-email-tytso@mit.edu>
 <1215279378-30504-17-git-send-email-tytso@mit.edu>
 <1215279378-30504-18-git-send-email-tytso@mit.edu>
 <1215279378-30504-19-git-send-email-tytso@mit.edu>
 <1215279378-30504-20-git-send-email-tytso@mit.edu>
 <1215279378-30504-21-git-send-email-tytso@mit.edu>
 <1215279378-30504-22-git-send-email-tytso@mit.edu>
 <1215279378-30504-23-git-send-email-tytso@mit.edu>
 <1215279378-30504-24-git-send-email-tytso@mit.edu>
 <1215279378-30504-25-git-send-email-tytso@mit.edu>
 <1215279378-30504-26-git-send-email-tytso@mit.edu>
 <1215279378-30504-27-git-send-email-tytso@mit.edu>
 <1215279378-30504-28-git-send-email-tytso@mit.edu>
 <1215279378-30504-29-git-send-email-tytso@mit.edu>
 <1215279378-30504-30-git-send-email-tytso@mit.edu>
 <1215279378-30504-31-git-send-email-tytso@mit.edu>
 <1215279378-30504-32-git-send-email-tytso@mit.edu>
 <1215279378-30504-33-git-send-email-tytso@mit.edu>
 <1215279378-30504-34-git-send-email-tytso@mit.edu>
 <1215279378-30504-35-git-send-email-tytso@mit.edu>
 <1215279378-30504-36-git-send-email-tytso@mit.edu>
 <1215279378-30504-37-git-send-email-tytso@mit.edu>
 <1215279378-30504-38-git-send-email-tytso@mit.edu>
 <1215279378-30504-39-git-send-email-tytso@mit.edu>
 <1215279378-30504-40-git-send-email-tytso@mit.edu>
 <1215279378-30504-41-git-send-email-tytso@mit.edu>
 <1215279378-30504-42-git-send-email-tytso@mit.edu>
Cc: Alex Tomas <alex@clusterfs.com>, Mingming Cao <cmm@us.ibm.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	" Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:33160 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756365AbYGERgo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Jul 2008 13:36:44 -0400
In-Reply-To: <1215279378-30504-42-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Alex Tomas <alex@clusterfs.com>

Two special ->get_block() methods are introduced:

 * ext4_da_get_block_prep()
   to be used with ->write_begin(), defers allocation till flush
 * ext4_da_get_block_write()
   to be used with mpage_da_writepages(), allocate blocks and correct
   on-disk size

This patch supports data=writeback mode, to enable delalloc, need to
mount filesystem with delalloc,data=writeback options.

Updated fixes from Mingming cao <cmm@us.ibm.com> to unlock and release
the page from page cache if the delalloc write_begin failed, and properly
handle preallocated blocks.

Updated fixes from  Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
to update i_disksize properly with delayed allocation,
and add bmap support for delalloc.

Signed-off-by: Alex Tomas <alex@clusterfs.com>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by:  Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/ext4.h  |    1 +
 fs/ext4/inode.c |  296 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/ext4/super.c |    6 +-
 3 files changed, 297 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 2c0519a..0307d53 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -536,6 +536,7 @@ do {									       \
 #define EXT4_MOUNT_JOURNAL_ASYNC_COMMIT	0x1000000 /* Journal Async Commit */
 #define EXT4_MOUNT_I_VERSION            0x2000000 /* i_version support */
 #define EXT4_MOUNT_MBALLOC		0x4000000 /* Buddy allocation support */
+#define EXT4_MOUNT_DELALLOC		0x8000000 /* Delalloc support */
 /* Compatibility, for having both ext2_fs.h and ext4_fs.h included at once */
 #ifndef _LINUX_EXT2_FS_H
 #define clear_opt(o, opt)		o &= ~EXT4_MOUNT_##opt
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 3af9cd7..2857ef3 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -46,6 +46,8 @@ static inline int ext4_begin_ordered_truncate(struct inode *inode,
 						   new_size);
 }
 
+static void ext4_invalidatepage(struct page *page, unsigned long offset);
+
 /*
  * Test whether an inode is a fast symlink.
  */
@@ -1408,6 +1410,267 @@ static int ext4_journalled_write_end(struct file *file,
 }
 
 /*
+ * this is a special callback for ->write_begin() only
+ * it's intention is to return mapped block or reserve space
+ */
+static int ext4_da_get_block_prep(struct inode *inode, sector_t iblock,
+				  struct buffer_head *bh_result, int create)
+{
+	int ret = 0;
+
+	BUG_ON(create == 0);
+	BUG_ON(bh_result->b_size != inode->i_sb->s_blocksize);
+
+	/*
+	 * first, we need to know whether the block is allocated already
+	 * preallocated blocks are unmapped but should treated
+	 * the same as allocated blocks.
+	 */
+	ret = ext4_get_blocks_wrap(NULL, inode, iblock, 1,  bh_result, 0, 0);
+	if (ret == 0) {
+		/* the block isn't allocated yet, let's reserve space */
+		/* XXX: call reservation here */
+		/*
+		 * XXX: __block_prepare_write() unmaps passed block,
+		 * is it OK?
+		 */
+		map_bh(bh_result, inode->i_sb, 0);
+		set_buffer_new(bh_result);
+		set_buffer_delay(bh_result);
+	} else if (ret > 0) {
+		bh_result->b_size = (ret << inode->i_blkbits);
+		ret = 0;
+	}
+
+	return ret;
+}
+
+static int ext4_da_get_block_write(struct inode *inode, sector_t iblock,
+				   struct buffer_head *bh_result, int create)
+{
+	int ret, needed_blocks = ext4_writepage_trans_blocks(inode);
+	unsigned max_blocks = bh_result->b_size >> inode->i_blkbits;
+	loff_t disksize = EXT4_I(inode)->i_disksize;
+	handle_t *handle = NULL;
+
+	if (create) {
+		handle = ext4_journal_start(inode, needed_blocks);
+		if (IS_ERR(handle)) {
+			ret = PTR_ERR(handle);
+			goto out;
+		}
+	}
+
+	ret = ext4_get_blocks_wrap(handle, inode, iblock, max_blocks,
+				   bh_result, create, 0);
+	if (ret > 0) {
+		bh_result->b_size = (ret << inode->i_blkbits);
+
+		/*
+		 * Update on-disk size along with block allocation
+		 * we don't use 'extend_disksize' as size may change
+		 * within already allocated block -bzzz
+		 */
+		disksize = ((loff_t) iblock + ret) << inode->i_blkbits;
+		if (disksize > i_size_read(inode))
+			disksize = i_size_read(inode);
+		if (disksize > EXT4_I(inode)->i_disksize) {
+			/*
+			 * XXX: replace with spinlock if seen contended -bzzz
+			 */
+			down_write(&EXT4_I(inode)->i_data_sem);
+			if (disksize > EXT4_I(inode)->i_disksize)
+				EXT4_I(inode)->i_disksize = disksize;
+			up_write(&EXT4_I(inode)->i_data_sem);
+
+			if (EXT4_I(inode)->i_disksize == disksize) {
+				if (handle == NULL)
+					handle = ext4_journal_start(inode, 1);
+				if (!IS_ERR(handle))
+					ext4_mark_inode_dirty(handle, inode);
+			}
+		}
+
+		ret = 0;
+	}
+
+out:
+	if (handle && !IS_ERR(handle))
+		ext4_journal_stop(handle);
+
+	return ret;
+}
+/* FIXME!! only support data=writeback mode */
+static int ext4_da_writepage(struct page *page,
+				struct writeback_control *wbc)
+{
+	struct inode *inode = page->mapping->host;
+	handle_t *handle = NULL;
+	int ret = 0;
+	int err;
+
+	if (ext4_journal_current_handle())
+		goto out_fail;
+
+	handle = ext4_journal_start(inode, ext4_writepage_trans_blocks(inode));
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		goto out_fail;
+	}
+
+	if (test_opt(inode->i_sb, NOBH) && ext4_should_writeback_data(inode))
+		ret = nobh_writepage(page, ext4_get_block, wbc);
+	else
+		ret = block_write_full_page(page, ext4_get_block, wbc);
+
+	if (!ret && inode->i_size > EXT4_I(inode)->i_disksize) {
+		EXT4_I(inode)->i_disksize = inode->i_size;
+		ext4_mark_inode_dirty(handle, inode);
+	}
+
+	err = ext4_journal_stop(handle);
+	if (!ret)
+		ret = err;
+	return ret;
+
+out_fail:
+	redirty_page_for_writepage(wbc, page);
+	unlock_page(page);
+	return ret;
+}
+
+static int ext4_da_writepages(struct address_space *mapping,
+				struct writeback_control *wbc)
+{
+	return mpage_da_writepages(mapping, wbc, ext4_da_get_block_write);
+}
+
+static int ext4_da_write_begin(struct file *file, struct address_space *mapping,
+				loff_t pos, unsigned len, unsigned flags,
+				struct page **pagep, void **fsdata)
+{
+	int ret;
+	struct page *page;
+	pgoff_t index;
+	unsigned from, to;
+	struct inode *inode = mapping->host;
+	handle_t *handle;
+
+	index = pos >> PAGE_CACHE_SHIFT;
+	from = pos & (PAGE_CACHE_SIZE - 1);
+	to = from + len;
+
+	/*
+	 * With delayed allocation, we don't log the i_disksize update
+	 * if there is delayed block allocation. But we still need
+	 * to journalling the i_disksize update if writes to the end
+	 * of file which has an already mapped buffer.
+	 */
+	handle = ext4_journal_start(inode, 1);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		goto out;
+	}
+
+	page = __grab_cache_page(mapping, index);
+	if (!page)
+		return -ENOMEM;
+	*pagep = page;
+
+	ret = block_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
+							ext4_da_get_block_prep);
+	if (ret < 0) {
+		unlock_page(page);
+		ext4_journal_stop(handle);
+		page_cache_release(page);
+	}
+
+out:
+	return ret;
+}
+
+static int ext4_bh_unmapped_or_delay(handle_t *handle, struct buffer_head *bh)
+{
+	return !buffer_mapped(bh) || buffer_delay(bh);
+}
+
+static int ext4_da_write_end(struct file *file,
+				struct address_space *mapping,
+				loff_t pos, unsigned len, unsigned copied,
+				struct page *page, void *fsdata)
+{
+	struct inode *inode = mapping->host;
+	int ret = 0, ret2;
+	handle_t *handle = ext4_journal_current_handle();
+	loff_t new_i_size;
+
+	/*
+	 * generic_write_end() will run mark_inode_dirty() if i_size
+	 * changes.  So let's piggyback the i_disksize mark_inode_dirty
+	 * into that.
+	 */
+
+	new_i_size = pos + copied;
+	if (new_i_size > EXT4_I(inode)->i_disksize)
+		if (!walk_page_buffers(NULL, page_buffers(page),
+				       0, len, NULL, ext4_bh_unmapped_or_delay)){
+			/*
+			 * Updating i_disksize when extending file without
+			 * needing block allocation
+			 */
+			if (ext4_should_order_data(inode))
+				ret = ext4_jbd2_file_inode(handle, inode);
+
+			EXT4_I(inode)->i_disksize = new_i_size;
+		}
+	ret2 = generic_write_end(file, mapping, pos, len, copied,
+							page, fsdata);
+	copied = ret2;
+	if (ret2 < 0)
+		ret = ret2;
+	ret2 = ext4_journal_stop(handle);
+	if (!ret)
+		ret = ret2;
+
+	return ret ? ret : copied;
+}
+
+static void ext4_da_invalidatepage(struct page *page, unsigned long offset)
+{
+	struct buffer_head *head, *bh;
+	unsigned int curr_off = 0;
+
+	/*
+	 * Drop reserved blocks
+	 */
+	BUG_ON(!PageLocked(page));
+	if (!page_has_buffers(page))
+		goto out;
+
+	head = page_buffers(page);
+	bh = head;
+	do {
+		unsigned int next_off = curr_off + bh->b_size;
+
+		/*
+		 * is this block fully invalidated?
+		 */
+		if (offset <= curr_off && buffer_delay(bh)) {
+			clear_buffer_delay(bh);
+			/* XXX: add real stuff here */
+		}
+		curr_off = next_off;
+		bh = bh->b_this_page;
+	} while (bh != head);
+
+out:
+	ext4_invalidatepage(page, offset);
+
+	return;
+}
+
+
+/*
  * bmap() is special.  It gets used by applications such as lilo and by
  * the swapper to find the on-disk block of a specific piece of data.
  *
@@ -1427,6 +1690,16 @@ static sector_t ext4_bmap(struct address_space *mapping, sector_t block)
 	journal_t *journal;
 	int err;
 
+	if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY) &&
+			test_opt(inode->i_sb, DELALLOC)) {
+		/*
+		 * With delalloc we want to sync the file
+		 * so that we can make sure we allocate
+		 * blocks for file
+		 */
+		filemap_write_and_wait(mapping);
+	}
+
 	if (EXT4_I(inode)->i_state & EXT4_STATE_JDATA) {
 		/*
 		 * This is a REALLY heavyweight approach, but the use of
@@ -1471,11 +1744,6 @@ static int bput_one(handle_t *handle, struct buffer_head *bh)
 	return 0;
 }
 
-static int ext4_bh_unmapped_or_delay(handle_t *handle, struct buffer_head *bh)
-{
-	return !buffer_mapped(bh) || buffer_delay(bh);
-}
-
 /*
  * Note that we don't need to start a transaction unless we're journaling data
  * because we should have holes filled from ext4_page_mkwrite(). We even don't
@@ -1832,10 +2100,28 @@ static const struct address_space_operations ext4_journalled_aops = {
 	.releasepage	= ext4_releasepage,
 };
 
+static const struct address_space_operations ext4_da_aops = {
+	.readpage	= ext4_readpage,
+	.readpages	= ext4_readpages,
+	.writepage	= ext4_da_writepage,
+	.writepages	= ext4_da_writepages,
+	.sync_page	= block_sync_page,
+	.write_begin	= ext4_da_write_begin,
+	.write_end	= ext4_da_write_end,
+	.bmap		= ext4_bmap,
+	.invalidatepage	= ext4_da_invalidatepage,
+	.releasepage	= ext4_releasepage,
+	.direct_IO	= ext4_direct_IO,
+	.migratepage	= buffer_migrate_page,
+};
+
 void ext4_set_aops(struct inode *inode)
 {
 	if (ext4_should_order_data(inode))
 		inode->i_mapping->a_ops = &ext4_ordered_aops;
+	else if (ext4_should_writeback_data(inode) &&
+		 test_opt(inode->i_sb, DELALLOC))
+		inode->i_mapping->a_ops = &ext4_da_aops;
 	else if (ext4_should_writeback_data(inode))
 		inode->i_mapping->a_ops = &ext4_writeback_aops;
 	else
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 629d0fa..de9d3d0 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -898,7 +898,7 @@ enum {
 	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_quota, Opt_noquota,
 	Opt_ignore, Opt_barrier, Opt_err, Opt_resize, Opt_usrquota,
 	Opt_grpquota, Opt_extents, Opt_noextents, Opt_i_version,
-	Opt_mballoc, Opt_nomballoc, Opt_stripe,
+	Opt_mballoc, Opt_nomballoc, Opt_stripe, Opt_delalloc,
 };
 
 static match_table_t tokens = {
@@ -957,6 +957,7 @@ static match_table_t tokens = {
 	{Opt_nomballoc, "nomballoc"},
 	{Opt_stripe, "stripe=%u"},
 	{Opt_resize, "resize"},
+	{Opt_delalloc, "delalloc"},
 	{Opt_err, NULL},
 };
 
@@ -1335,6 +1336,9 @@ set_qf_format:
 				return 0;
 			sbi->s_stripe = option;
 			break;
+		case Opt_delalloc:
+			set_opt(sbi->s_mount_opt, DELALLOC);
+			break;
 		default:
 			printk (KERN_ERR
 				"EXT4-fs: Unrecognized mount option \"%s\" "
-- 
1.5.6.rc3.1.g36b7.dirty

