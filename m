From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH v3 1/3] ext4 crypto: add ciphertext_access mount option
Date: Thu, 10 Dec 2015 10:04:37 -0500
Message-ID: <1449759879-2166-2-git-send-email-tytso@mit.edu>
References: <1449759879-2166-1-git-send-email-tytso@mit.edu>
Cc: mhalcrow@google.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50533 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753869AbbLJPEo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Dec 2015 10:04:44 -0500
In-Reply-To: <1449759879-2166-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add a mount option which allows root to be able to access the
ciphertext of a file by reading it using O_DIRECT.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/ext4.h     |  3 +++
 fs/ext4/file.c     |  5 ++++-
 fs/ext4/indirect.c | 24 +++++++++++++++++++-----
 fs/ext4/inode.c    | 17 ++++++++++-------
 fs/ext4/super.c    | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 84 insertions(+), 13 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 1e20fa9..cf7a885 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1052,6 +1052,7 @@ struct ext4_inode_info {
 #define EXT4_MOUNT_DIOREAD_NOLOCK	0x400000 /* Enable support for dio read nolocking */
 #define EXT4_MOUNT_JOURNAL_CHECKSUM	0x800000 /* Journal checksums */
 #define EXT4_MOUNT_JOURNAL_ASYNC_COMMIT	0x1000000 /* Journal Async Commit */
+#define EXT4_MOUNT_CIPHERTEXT_ACCESS	0x2000000 /* Direct I/O to ciphertext */
 #define EXT4_MOUNT_DELALLOC		0x8000000 /* Delalloc support */
 #define EXT4_MOUNT_DATA_ERR_ABORT	0x10000000 /* Abort on file data write */
 #define EXT4_MOUNT_BLOCK_VALIDITY	0x20000000 /* Block validity checking */
@@ -2564,6 +2565,8 @@ extern int ext4_alloc_flex_bg_array(struct super_block *sb,
 				    ext4_group_t ngroup);
 extern const char *ext4_decode_error(struct super_block *sb, int errno,
 				     char nbuf[16]);
+extern struct inode *ext4_alloc_shadow_inode(struct inode *inode);
+extern void ext4_free_shadow_inode(struct inode *shadow);
 
 extern __printf(4, 5)
 void __ext4_error(struct super_block *, const char *, unsigned int,
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 749b222..60683ab 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -388,7 +388,10 @@ static int ext4_file_open(struct inode * inode, struct file * filp)
 		ret = ext4_get_encryption_info(inode);
 		if (ret)
 			return -EACCES;
-		if (ext4_encryption_info(inode) == NULL)
+		if ((ext4_encryption_info(inode) == NULL) &&
+		    !(test_opt(inode->i_sb, CIPHERTEXT_ACCESS) &&
+		      ((filp->f_flags & O_ACCMODE) == O_RDONLY) &&
+		      capable(CAP_SYS_ADMIN)))
 			return -ENOKEY;
 	}
 	/*
diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index 355ef9c..e685736 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -649,17 +649,17 @@ ssize_t ext4_ind_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
+	struct inode *shadow = inode;
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	handle_t *handle;
 	ssize_t ret;
 	int orphan = 0;
 	size_t count = iov_iter_count(iter);
 	int retries = 0;
+	loff_t final_size = offset + count;
 
 	if (iov_iter_rw(iter) == WRITE) {
-		loff_t final_size = offset + count;
-
-		if (final_size > inode->i_size) {
+		if (final_size > i_size_read(inode)) {
 			/* Credits for sb + inode write */
 			handle = ext4_journal_start(inode, EXT4_HT_INODE, 2);
 			if (IS_ERR(handle)) {
@@ -676,6 +676,18 @@ ssize_t ext4_ind_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 			ext4_journal_stop(handle);
 		}
 	}
+	if (iov_iter_rw(iter) == READ &&
+	    ext4_encrypted_inode(inode) &&
+	    is_sync_kiocb(iocb) &&
+	    final_size > i_size_read(inode)) {
+		shadow = ext4_alloc_shadow_inode(inode);
+		if (shadow)
+			i_size_write(shadow,
+				     round_up(i_size_read(inode),
+					      inode->i_sb->s_blocksize));
+		else
+			shadow = inode;
+	}
 
 retry:
 	if (iov_iter_rw(iter) == READ && ext4_should_dioread_nolock(inode)) {
@@ -695,7 +707,7 @@ retry:
 			ret = dax_do_io(iocb, inode, iter, offset,
 					ext4_get_block, NULL, 0);
 		else
-			ret = __blockdev_direct_IO(iocb, inode,
+			ret = __blockdev_direct_IO(iocb, shadow,
 						   inode->i_sb->s_bdev, iter,
 						   offset, ext4_get_block, NULL,
 						   NULL, 0);
@@ -706,7 +718,7 @@ locked:
 			ret = dax_do_io(iocb, inode, iter, offset,
 					ext4_get_block, NULL, DIO_LOCKING);
 		else
-			ret = blockdev_direct_IO(iocb, inode, iter, offset,
+			ret = blockdev_direct_IO(iocb, shadow, iter, offset,
 						 ext4_get_block);
 
 		if (unlikely(iov_iter_rw(iter) == WRITE && ret < 0)) {
@@ -757,6 +769,8 @@ locked:
 			ret = err;
 	}
 out:
+	if (shadow != inode)
+		ext4_free_shadow_inode(shadow);
 	return ret;
 }
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index ff2f3cd..16f6537 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3279,9 +3279,6 @@ static ssize_t ext4_ext_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 		get_block_func = ext4_get_block_write;
 		dio_flags = DIO_LOCKING;
 	}
-#ifdef CONFIG_EXT4_FS_ENCRYPTION
-	BUG_ON(ext4_encrypted_inode(inode) && S_ISREG(inode->i_mode));
-#endif
 	if (IS_DAX(inode))
 		ret = dax_do_io(iocb, inode, iter, offset, get_block_func,
 				ext4_end_io_dio, dio_flags);
@@ -3344,10 +3341,16 @@ static ssize_t ext4_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 	size_t count = iov_iter_count(iter);
 	ssize_t ret;
 
-#ifdef CONFIG_EXT4_FS_ENCRYPTION
-	if (ext4_encrypted_inode(inode) && S_ISREG(inode->i_mode))
-		return 0;
-#endif
+	if (ext4_encrypted_inode(inode) && S_ISREG(inode->i_mode)) {
+		if (iov_iter_rw(iter) == WRITE)
+			return 0;
+		if (test_opt(inode->i_sb, CIPHERTEXT_ACCESS) &&
+		    capable(CAP_SYS_ADMIN)) {
+			if (iov_iter_rw(iter) == WRITE)
+				return -EPERM;
+		} else
+			return 0;
+	}
 
 	/*
 	 * If we are doing data journalling we don't support O_DIRECT
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 486e869..6173b46 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1033,6 +1033,49 @@ void ext4_clear_inode(struct inode *inode)
 #endif
 }
 
+/*
+ * Create a copy of the inode structure so when we are reading the
+ * last block of an encrypted inode using direct I/O to get the
+ * ciphertext, we can futz with the i_size in the shadow inode.  This
+ * is necessary so that we can make a copy of the full AES block when
+ * i_size is not a multiple of the AES block size.
+ */
+struct inode *ext4_alloc_shadow_inode(struct inode *inode)
+{
+	struct ext4_inode_info *shadow_ei, *ei = EXT4_I(inode);
+	struct inode *shadow;
+
+	shadow_ei = kmem_cache_alloc(ext4_inode_cachep, GFP_NOFS);
+	if (!shadow_ei)
+		return NULL;
+
+	memcpy(shadow_ei, ei, sizeof(struct ext4_inode_info));
+	shadow = &shadow_ei->vfs_inode;
+
+	init_rwsem(&shadow_ei->xattr_sem);
+	init_rwsem(&shadow_ei->i_data_sem);
+	init_rwsem(&shadow_ei->i_mmap_sem);
+	i_size_ordered_init(shadow);
+	mutex_init(&shadow->i_mutex);
+	spin_lock_init(&shadow_ei->i_raw_lock);
+	spin_lock_init(&shadow_ei->i_prealloc_lock);
+	spin_lock_init(&(shadow_ei->i_block_reservation_lock));
+	spin_lock_init(&shadow_ei->i_completed_io_lock);
+	rwlock_init(&shadow_ei->i_es_lock);
+	ext4_es_init_tree(&shadow_ei->i_es_tree);
+	INIT_LIST_HEAD(&shadow_ei->i_es_list);
+	shadow_ei->i_es_all_nr = 0;
+	shadow_ei->i_es_shk_nr = 0;
+
+	return shadow;
+}
+
+void ext4_free_shadow_inode(struct inode *shadow)
+{
+	ext4_es_remove_extent(shadow, 0, EXT_MAX_BLOCKS);
+	kmem_cache_free(ext4_inode_cachep, EXT4_I(shadow));
+}
+
 static struct inode *ext4_nfs_get_inode(struct super_block *sb,
 					u64 ino, u32 generation)
 {
@@ -1182,6 +1225,7 @@ enum {
 	Opt_journal_path, Opt_journal_checksum, Opt_journal_async_commit,
 	Opt_abort, Opt_data_journal, Opt_data_ordered, Opt_data_writeback,
 	Opt_data_err_abort, Opt_data_err_ignore, Opt_test_dummy_encryption,
+	Opt_ciphertext_access, Opt_nociphertext_access,
 	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
 	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_jqfmt_vfsv1, Opt_quota,
 	Opt_noquota, Opt_barrier, Opt_nobarrier, Opt_err,
@@ -1273,6 +1317,8 @@ static const match_table_t tokens = {
 	{Opt_noinit_itable, "noinit_itable"},
 	{Opt_max_dir_size_kb, "max_dir_size_kb=%u"},
 	{Opt_test_dummy_encryption, "test_dummy_encryption"},
+	{Opt_ciphertext_access, "ciphertext_access"},
+	{Opt_nociphertext_access, "nociphertext_access"},
 	{Opt_removed, "check=none"},	/* mount option from ext2/3 */
 	{Opt_removed, "nocheck"},	/* mount option from ext2/3 */
 	{Opt_removed, "reservation"},	/* mount option from ext2/3 */
@@ -1475,6 +1521,8 @@ static const struct mount_opts {
 	{Opt_jqfmt_vfsv1, QFMT_VFS_V1, MOPT_QFMT},
 	{Opt_max_dir_size_kb, 0, MOPT_GTE0},
 	{Opt_test_dummy_encryption, 0, MOPT_GTE0},
+	{Opt_ciphertext_access, EXT4_MOUNT_CIPHERTEXT_ACCESS, MOPT_SET},
+	{Opt_nociphertext_access, EXT4_MOUNT_CIPHERTEXT_ACCESS, MOPT_CLEAR},
 	{Opt_err, 0, 0}
 };
 
-- 
2.5.0

