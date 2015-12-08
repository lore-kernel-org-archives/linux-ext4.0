From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH RFC v2 1/2] ext4 crypto: add ciphertext_access mount option
Date: Tue,  8 Dec 2015 17:02:53 -0500
Message-ID: <1449612174-32127-1-git-send-email-tytso@mit.edu>
Cc: mhalcrow@google.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46536 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbbLHWDH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Dec 2015 17:03:07 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add a mount option which allows root to be able to access the
ciphertext of a file by reading it using O_DIRECT.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/ext4.h  |  1 +
 fs/ext4/file.c  |  5 ++++-
 fs/ext4/inode.c | 15 ++++++++-------
 fs/ext4/super.c |  5 +++++
 4 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 1e20fa9..44278aa7 100644
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
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index ff2f3cd..4b21bff 100644
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
@@ -3344,10 +3341,14 @@ static ssize_t ext4_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 	size_t count = iov_iter_count(iter);
 	ssize_t ret;
 
-#ifdef CONFIG_EXT4_FS_ENCRYPTION
-	if (ext4_encrypted_inode(inode) && S_ISREG(inode->i_mode))
-		return 0;
-#endif
+	if (ext4_encrypted_inode(inode) && S_ISREG(inode->i_mode)) {
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
index 486e869..de875b4 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1182,6 +1182,7 @@ enum {
 	Opt_journal_path, Opt_journal_checksum, Opt_journal_async_commit,
 	Opt_abort, Opt_data_journal, Opt_data_ordered, Opt_data_writeback,
 	Opt_data_err_abort, Opt_data_err_ignore, Opt_test_dummy_encryption,
+	Opt_ciphertext_access, Opt_nociphertext_access,
 	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
 	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_jqfmt_vfsv1, Opt_quota,
 	Opt_noquota, Opt_barrier, Opt_nobarrier, Opt_err,
@@ -1273,6 +1274,8 @@ static const match_table_t tokens = {
 	{Opt_noinit_itable, "noinit_itable"},
 	{Opt_max_dir_size_kb, "max_dir_size_kb=%u"},
 	{Opt_test_dummy_encryption, "test_dummy_encryption"},
+	{Opt_ciphertext_access, "ciphertext_access"},
+	{Opt_nociphertext_access, "nociphertext_access"},
 	{Opt_removed, "check=none"},	/* mount option from ext2/3 */
 	{Opt_removed, "nocheck"},	/* mount option from ext2/3 */
 	{Opt_removed, "reservation"},	/* mount option from ext2/3 */
@@ -1475,6 +1478,8 @@ static const struct mount_opts {
 	{Opt_jqfmt_vfsv1, QFMT_VFS_V1, MOPT_QFMT},
 	{Opt_max_dir_size_kb, 0, MOPT_GTE0},
 	{Opt_test_dummy_encryption, 0, MOPT_GTE0},
+	{Opt_ciphertext_access, EXT4_MOUNT_CIPHERTEXT_ACCESS, MOPT_SET},
+	{Opt_nociphertext_access, EXT4_MOUNT_CIPHERTEXT_ACCESS, MOPT_CLEAR},
 	{Opt_err, 0, 0}
 };
 
-- 
2.5.0

