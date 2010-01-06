From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext3: Use bitops to read/modify EXT3_I(inode)->i_state
Date: Wed,  6 Jan 2010 22:27:35 +0100
Message-ID: <1262813255-4755-1-git-send-email-jack@suse.cz>
Cc: tytso@mit.edu, Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43611 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756024Ab0AFV1h (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Jan 2010 16:27:37 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

At several places we modify EXT3_I(inode)->i_state without holding i_mutex
(ext3_release_file, ext3_bmap, ext3_journalled_writepage, ext3_do_update_inode,
...). These modifications are racy and we can lose updates to i_state. So
convert handling of i_state to use bitops which are atomic.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/file.c            |    4 ++--
 fs/ext3/inode.c           |   18 +++++++++---------
 fs/ext3/xattr.c           |   14 +++++++-------
 include/linux/ext3_fs.h   |   33 +++++++++++++++++++++++++--------
 include/linux/ext3_fs_i.h |    2 +-
 5 files changed, 44 insertions(+), 27 deletions(-)

 Ted, I can create a similar patch for ext4 if you wish...

diff --git a/fs/ext3/file.c b/fs/ext3/file.c
index 388bbdf..a86d330 100644
--- a/fs/ext3/file.c
+++ b/fs/ext3/file.c
@@ -33,9 +33,9 @@
  */
 static int ext3_release_file (struct inode * inode, struct file * filp)
 {
-	if (EXT3_I(inode)->i_state & EXT3_STATE_FLUSH_ON_CLOSE) {
+	if (ext3_test_inode_state(inode, EXT3_STATE_FLUSH_ON_CLOSE)) {
 		filemap_flush(inode->i_mapping);
-		EXT3_I(inode)->i_state &= ~EXT3_STATE_FLUSH_ON_CLOSE;
+		ext3_clear_inode_state(inode, EXT3_STATE_FLUSH_ON_CLOSE);
 	}
 	/* if we are the last writer on the inode, drop the block reservation */
 	if ((filp->f_mode & FMODE_WRITE) &&
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 455e6e6..44b5338 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1378,7 +1378,7 @@ static int ext3_journalled_write_end(struct file *file,
 	 */
 	if (pos + len > inode->i_size && ext3_can_truncate(inode))
 		ext3_orphan_add(handle, inode);
-	EXT3_I(inode)->i_state |= EXT3_STATE_JDATA;
+	ext3_set_inode_state(inode, EXT3_STATE_JDATA);
 	if (inode->i_size > EXT3_I(inode)->i_disksize) {
 		EXT3_I(inode)->i_disksize = inode->i_size;
 		ret2 = ext3_mark_inode_dirty(handle, inode);
@@ -1417,7 +1417,7 @@ static sector_t ext3_bmap(struct address_space *mapping, sector_t block)
 	journal_t *journal;
 	int err;
 
-	if (EXT3_I(inode)->i_state & EXT3_STATE_JDATA) {
+	if (ext3_test_inode_state(inode, EXT3_STATE_JDATA)) {
 		/*
 		 * This is a REALLY heavyweight approach, but the use of
 		 * bmap on dirty files is expected to be extremely rare:
@@ -1436,7 +1436,7 @@ static sector_t ext3_bmap(struct address_space *mapping, sector_t block)
 		 * everything they get.
 		 */
 
-		EXT3_I(inode)->i_state &= ~EXT3_STATE_JDATA;
+		ext3_clear_inode_state(inode, EXT3_STATE_JDATA);
 		journal = EXT3_JOURNAL(inode);
 		journal_lock_updates(journal);
 		err = journal_flush(journal);
@@ -1670,7 +1670,7 @@ static int ext3_journalled_writepage(struct page *page,
 				PAGE_CACHE_SIZE, NULL, write_end_fn);
 		if (ret == 0)
 			ret = err;
-		EXT3_I(inode)->i_state |= EXT3_STATE_JDATA;
+		ext3_set_inode_state(inode, EXT3_STATE_JDATA);
 		unlock_page(page);
 	} else {
 		/*
@@ -2402,7 +2402,7 @@ void ext3_truncate(struct inode *inode)
 		goto out_notrans;
 
 	if (inode->i_size == 0 && ext3_should_writeback_data(inode))
-		ei->i_state |= EXT3_STATE_FLUSH_ON_CLOSE;
+		ext3_set_inode_state(inode, EXT3_STATE_FLUSH_ON_CLOSE);
 
 	/*
 	 * We have to lock the EOF page here, because lock_page() nests
@@ -2721,7 +2721,7 @@ int ext3_get_inode_loc(struct inode *inode, struct ext3_iloc *iloc)
 {
 	/* We have all inode data except xattrs in memory here. */
 	return __ext3_get_inode_loc(inode, iloc,
-		!(EXT3_I(inode)->i_state & EXT3_STATE_XATTR));
+		!ext3_test_inode_state(inode, EXT3_STATE_XATTR));
 }
 
 void ext3_set_inode_flags(struct inode *inode)
@@ -2893,7 +2893,7 @@ struct inode *ext3_iget(struct super_block *sb, unsigned long ino)
 					EXT3_GOOD_OLD_INODE_SIZE +
 					ei->i_extra_isize;
 			if (*magic == cpu_to_le32(EXT3_XATTR_MAGIC))
-				 ei->i_state |= EXT3_STATE_XATTR;
+				 ext3_set_inode_state(inode, EXT3_STATE_XATTR);
 		}
 	} else
 		ei->i_extra_isize = 0;
@@ -2955,7 +2955,7 @@ again:
 
 	/* For fields not not tracking in the in-memory inode,
 	 * initialise them to zero for new inodes. */
-	if (ei->i_state & EXT3_STATE_NEW)
+	if (ext3_test_inode_state(inode, EXT3_STATE_NEW))
 		memset(raw_inode, 0, EXT3_SB(inode->i_sb)->s_inode_size);
 
 	ext3_get_inode_flags(ei);
@@ -3052,7 +3052,7 @@ again:
 	rc = ext3_journal_dirty_metadata(handle, bh);
 	if (!err)
 		err = rc;
-	ei->i_state &= ~EXT3_STATE_NEW;
+	ext3_clear_inode_state(inode, EXT3_STATE_NEW);
 
 	atomic_set(&ei->i_sync_tid, handle->h_transaction->t_tid);
 out_brelse:
diff --git a/fs/ext3/xattr.c b/fs/ext3/xattr.c
index 66895cc..2d2fb2a 100644
--- a/fs/ext3/xattr.c
+++ b/fs/ext3/xattr.c
@@ -274,7 +274,7 @@ ext3_xattr_ibody_get(struct inode *inode, int name_index, const char *name,
 	void *end;
 	int error;
 
-	if (!(EXT3_I(inode)->i_state & EXT3_STATE_XATTR))
+	if (!ext3_test_inode_state(inode, EXT3_STATE_XATTR))
 		return -ENODATA;
 	error = ext3_get_inode_loc(inode, &iloc);
 	if (error)
@@ -403,7 +403,7 @@ ext3_xattr_ibody_list(struct dentry *dentry, char *buffer, size_t buffer_size)
 	void *end;
 	int error;
 
-	if (!(EXT3_I(inode)->i_state & EXT3_STATE_XATTR))
+	if (!ext3_test_inode_state(inode, EXT3_STATE_XATTR))
 		return 0;
 	error = ext3_get_inode_loc(inode, &iloc);
 	if (error)
@@ -882,7 +882,7 @@ ext3_xattr_ibody_find(struct inode *inode, struct ext3_xattr_info *i,
 	is->s.base = is->s.first = IFIRST(header);
 	is->s.here = is->s.first;
 	is->s.end = (void *)raw_inode + EXT3_SB(inode->i_sb)->s_inode_size;
-	if (EXT3_I(inode)->i_state & EXT3_STATE_XATTR) {
+	if (ext3_test_inode_state(inode, EXT3_STATE_XATTR)) {
 		error = ext3_xattr_check_names(IFIRST(header), is->s.end);
 		if (error)
 			return error;
@@ -914,10 +914,10 @@ ext3_xattr_ibody_set(handle_t *handle, struct inode *inode,
 	header = IHDR(inode, ext3_raw_inode(&is->iloc));
 	if (!IS_LAST_ENTRY(s->first)) {
 		header->h_magic = cpu_to_le32(EXT3_XATTR_MAGIC);
-		EXT3_I(inode)->i_state |= EXT3_STATE_XATTR;
+		ext3_set_inode_state(inode, EXT3_STATE_XATTR);
 	} else {
 		header->h_magic = cpu_to_le32(0);
-		EXT3_I(inode)->i_state &= ~EXT3_STATE_XATTR;
+		ext3_clear_inode_state(inode, EXT3_STATE_XATTR);
 	}
 	return 0;
 }
@@ -967,10 +967,10 @@ ext3_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
 	if (error)
 		goto cleanup;
 
-	if (EXT3_I(inode)->i_state & EXT3_STATE_NEW) {
+	if (ext3_test_inode_state(inode, EXT3_STATE_NEW)) {
 		struct ext3_inode *raw_inode = ext3_raw_inode(&is.iloc);
 		memset(raw_inode, 0, EXT3_SB(inode->i_sb)->s_inode_size);
-		EXT3_I(inode)->i_state &= ~EXT3_STATE_NEW;
+		ext3_clear_inode_state(inode, EXT3_STATE_NEW);
 	}
 
 	error = ext3_xattr_ibody_find(inode, &i, &is);
diff --git a/include/linux/ext3_fs.h b/include/linux/ext3_fs.h
index 6b04903..e6590f8 100644
--- a/include/linux/ext3_fs.h
+++ b/include/linux/ext3_fs.h
@@ -202,14 +202,6 @@ static inline __u32 ext3_mask_flags(umode_t mode, __u32 flags)
 		return flags & EXT3_OTHER_FLMASK;
 }
 
-/*
- * Inode dynamic state flags
- */
-#define EXT3_STATE_JDATA		0x00000001 /* journaled data exists */
-#define EXT3_STATE_NEW			0x00000002 /* inode is newly created */
-#define EXT3_STATE_XATTR		0x00000004 /* has in-inode xattrs */
-#define EXT3_STATE_FLUSH_ON_CLOSE	0x00000008
-
 /* Used to pass group descriptor data when online resize is done */
 struct ext3_new_group_input {
 	__u32 group;            /* Group number for this data */
@@ -560,6 +552,31 @@ static inline int ext3_valid_inum(struct super_block *sb, unsigned long ino)
 		(ino >= EXT3_FIRST_INO(sb) &&
 		 ino <= le32_to_cpu(EXT3_SB(sb)->s_es->s_inodes_count));
 }
+
+/*
+ * Inode dynamic state flags
+ */
+enum {
+	EXT3_STATE_JDATA,		/* journaled data exists */
+	EXT3_STATE_NEW,			/* inode is newly created */
+	EXT3_STATE_XATTR,		/* has in-inode xattrs */
+	EXT3_STATE_FLUSH_ON_CLOSE,	/* flush dirty pages on close */
+};
+
+static inline int ext3_test_inode_state(struct inode *inode, int bit)
+{
+	return test_bit(bit, &EXT3_I(inode)->i_state);
+}
+
+static inline void ext3_set_inode_state(struct inode *inode, int bit)
+{
+	set_bit(bit, &EXT3_I(inode)->i_state);
+}
+
+static inline void ext3_clear_inode_state(struct inode *inode, int bit)
+{
+	clear_bit(bit, &EXT3_I(inode)->i_state);
+}
 #else
 /* Assume that user mode programs are passing in an ext3fs superblock, not
  * a kernel struct super_block.  This will allow us to call the feature-test
diff --git a/include/linux/ext3_fs_i.h b/include/linux/ext3_fs_i.h
index 93e7428..7679acd 100644
--- a/include/linux/ext3_fs_i.h
+++ b/include/linux/ext3_fs_i.h
@@ -87,7 +87,7 @@ struct ext3_inode_info {
 	 * near to their parent directory's inode.
 	 */
 	__u32	i_block_group;
-	__u32	i_state;		/* Dynamic state flags for ext3 */
+	unsigned long	i_state;	/* Dynamic state flags for ext3 */
 
 	/* block reservation info */
 	struct ext3_block_alloc_info *i_block_alloc_info;
-- 
1.6.4.2

