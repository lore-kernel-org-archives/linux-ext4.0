From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 21/22] ext4 crypto: enable encryption feature flag
Date: Thu,  2 Apr 2015 18:10:58 -0400
Message-ID: <1428012659-12709-22-git-send-email-tytso@mit.edu>
References: <1428012659-12709-1-git-send-email-tytso@mit.edu>
Cc: jaegeuk@kernel.org, mhalcrow@google.com,
	Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48029 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752564AbbDBWNF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Apr 2015 18:13:05 -0400
In-Reply-To: <1428012659-12709-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Also add the test dummy encryption mode flag so we can more easily
test the encryption patches using xfstests.

Change-Id: I63a7f5b969738eed81b2f12715cfff161a988d84
Signed-off-by: Michael Halcrow <mhalcrow@google.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/crypto_key.c    | 27 +++++++++++++++------------
 fs/ext4/crypto_policy.c | 20 +++++++++++++++++---
 fs/ext4/ext4.h          | 10 ++++++----
 fs/ext4/ialloc.c        |  4 +++-
 fs/ext4/namei.c         | 13 +++++++++++--
 fs/ext4/super.c         | 20 +++++++++++++++++++-
 6 files changed, 71 insertions(+), 23 deletions(-)

diff --git a/fs/ext4/crypto_key.c b/fs/ext4/crypto_key.c
index 3620e16..50c3c1a 100644
--- a/fs/ext4/crypto_key.c
+++ b/fs/ext4/crypto_key.c
@@ -104,6 +104,7 @@ int ext4_generate_encryption_key(struct inode *inode)
 	struct ext4_encryption_key *master_key;
 	struct ext4_encryption_context ctx;
 	struct user_key_payload *ukp;
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	int res = ext4_xattr_get(inode, EXT4_XATTR_INDEX_ENCRYPTION,
 				 EXT4_XATTR_NAME_ENCRYPTION_CONTEXT,
 				 &ctx, sizeof(ctx));
@@ -115,6 +116,20 @@ int ext4_generate_encryption_key(struct inode *inode)
 	}
 	res = 0;
 
+	if (S_ISREG(inode->i_mode))
+		crypt_key->mode = ctx.contents_encryption_mode;
+	else if (S_ISDIR(inode->i_mode) || S_ISLNK(inode->i_mode))
+		crypt_key->mode = ctx.filenames_encryption_mode;
+	else {
+		printk(KERN_ERR "ext4 crypto: Unsupported inode type.\n");
+		BUG();
+	}
+	crypt_key->size = ext4_encryption_key_size(crypt_key->mode);
+	BUG_ON(!crypt_key->size);
+	if (unlikely(sbi->s_mount_flags & EXT4_MF_TEST_DUMMY_ENCRYPTION)) {
+		memset(crypt_key->raw, 0x42, EXT4_AES_256_XTS_KEY_SIZE);
+		goto out;
+	}
 	memcpy(full_key_descriptor, EXT4_KEY_DESC_PREFIX,
 	       EXT4_KEY_DESC_PREFIX_SIZE);
 	ext4_to_hex(&full_key_descriptor[EXT4_KEY_DESC_PREFIX_SIZE],
@@ -134,21 +149,9 @@ int ext4_generate_encryption_key(struct inode *inode)
 		goto out;
 	}
 	master_key = (struct ext4_encryption_key *)ukp->data;
-
-	if (S_ISREG(inode->i_mode))
-		crypt_key->mode = ctx.contents_encryption_mode;
-	else if (S_ISDIR(inode->i_mode) || S_ISLNK(inode->i_mode))
-		crypt_key->mode = ctx.filenames_encryption_mode;
-	else {
-		printk(KERN_ERR "ext4 crypto: Unsupported inode type.\n");
-		BUG();
-	}
-	crypt_key->size = ext4_encryption_key_size(crypt_key->mode);
-	BUG_ON(!crypt_key->size);
 	BUILD_BUG_ON(EXT4_AES_128_ECB_KEY_SIZE !=
 		     EXT4_KEY_DERIVATION_NONCE_SIZE);
 	BUG_ON(master_key->size != EXT4_AES_256_XTS_KEY_SIZE);
-	BUG_ON(crypt_key->size < EXT4_AES_256_CBC_KEY_SIZE);
 	res = ext4_derive_key_aes(ctx.nonce, master_key->raw, crypt_key->raw);
 out:
 	if (keyring_key)
diff --git a/fs/ext4/crypto_policy.c b/fs/ext4/crypto_policy.c
index 3ff4c75..7debb55 100644
--- a/fs/ext4/crypto_policy.c
+++ b/fs/ext4/crypto_policy.c
@@ -155,17 +155,31 @@ int ext4_is_child_context_consistent_with_parent(struct inode *parent,
 int ext4_inherit_context(struct inode *parent, struct inode *child)
 {
 	struct ext4_encryption_context ctx;
+	struct ext4_sb_info *sbi = EXT4_SB(parent->i_sb);
 	int res = ext4_xattr_get(parent, EXT4_XATTR_INDEX_ENCRYPTION,
 				 EXT4_XATTR_NAME_ENCRYPTION_CONTEXT,
 				 &ctx, sizeof(ctx));
 
-	if (res != sizeof(ctx))
-		return -ENOENT;
-
+	if (res != sizeof(ctx)) {
+		if (unlikely(sbi->s_mount_flags &
+			     EXT4_MF_TEST_DUMMY_ENCRYPTION)) {
+			ctx.format = EXT4_ENCRYPTION_CONTEXT_FORMAT_V0;
+			ctx.contents_encryption_mode =
+				EXT4_ENCRYPTION_MODE_AES_256_XTS;
+			ctx.filenames_encryption_mode =
+				EXT4_ENCRYPTION_MODE_AES_256_CBC;
+			memset(ctx.master_key_descriptor, 0x42,
+			       EXT4_KEY_DESCRIPTOR_SIZE);
+			res = 0;
+		} else {
+			goto out;
+		}
+	}
 	get_random_bytes(ctx.nonce, EXT4_KEY_DERIVATION_NONCE_SIZE);
 	res = ext4_xattr_set(child, EXT4_XATTR_INDEX_ENCRYPTION,
 			     EXT4_XATTR_NAME_ENCRYPTION_CONTEXT, &ctx,
 			     sizeof(ctx), 0);
+out:
 	if (!res)
 		ext4_set_inode_flag(child, EXT4_INODE_ENCRYPT);
 	return res;
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 421c065..de3b1e4 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1183,8 +1183,9 @@ struct ext4_super_block {
 /*
  * run-time mount flags
  */
-#define EXT4_MF_MNTDIR_SAMPLED	0x0001
-#define EXT4_MF_FS_ABORTED	0x0002	/* Fatal error detected */
+#define EXT4_MF_MNTDIR_SAMPLED		0x0001
+#define EXT4_MF_FS_ABORTED		0x0002	/* Fatal error detected */
+#define EXT4_MF_TEST_DUMMY_ENCRYPTION	0x0004
 
 /* Number of quota types we support */
 #define EXT4_MAXQUOTAS 2
@@ -1595,8 +1596,9 @@ static inline int ext4_encrypted_inode(struct inode *inode)
 					 EXT4_FEATURE_INCOMPAT_EXTENTS| \
 					 EXT4_FEATURE_INCOMPAT_64BIT| \
 					 EXT4_FEATURE_INCOMPAT_FLEX_BG| \
-					 EXT4_FEATURE_INCOMPAT_MMP |	\
-					 EXT4_FEATURE_INCOMPAT_INLINE_DATA)
+					 EXT4_FEATURE_INCOMPAT_MMP | \
+					 EXT4_FEATURE_INCOMPAT_INLINE_DATA | \
+					 EXT4_FEATURE_INCOMPAT_ENCRYPT)
 #define EXT4_FEATURE_RO_COMPAT_SUPP	(EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER| \
 					 EXT4_FEATURE_RO_COMPAT_LARGE_FILE| \
 					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM| \
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 8f37c9e..68d0142 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -999,7 +999,9 @@ got:
 
 	/* If the directory encrypted, then we should encrypt the inode. */
 	if ((S_ISDIR(mode) || S_ISREG(mode) || S_ISLNK(mode)) &&
-	    ext4_encrypted_inode(dir))
+	    (ext4_encrypted_inode(dir) ||
+	     unlikely(sbi->s_mount_flags &
+		      EXT4_MF_TEST_DUMMY_ENCRYPTION)))
 		ext4_set_inode_flag(inode, EXT4_INODE_ENCRYPT);
 
 	ext4_set_inode_flags(inode);
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 57db793..ae61416 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2577,6 +2577,9 @@ static int ext4_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 	handle_t *handle;
 	struct inode *inode;
 	int err, credits, retries = 0;
+#ifdef CONFIG_EXT4_FS_ENCRYPTION
+	struct ext4_sb_info *sbi = EXT4_SB(dir->i_sb);
+#endif
 
 	dquot_initialize(dir);
 
@@ -2595,7 +2598,9 @@ retry:
 		if (!err && IS_DIRSYNC(dir))
 			ext4_handle_sync(handle);
 #ifdef CONFIG_EXT4_FS_ENCRYPTION
-		if (!err && ext4_encrypted_inode(dir)) {
+		if (!err && (ext4_encrypted_inode(dir) ||
+			     unlikely(sbi->s_mount_flags &
+				      EXT4_MF_TEST_DUMMY_ENCRYPTION))) {
 			err = ext4_inherit_context(dir, inode);
 			if (err)
 				ext4_unlink(dir, dentry);
@@ -2757,6 +2762,9 @@ static int ext4_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 	handle_t *handle;
 	struct inode *inode;
 	int err, credits, retries = 0;
+#ifdef CONFIG_EXT4_FS_ENCRYPTION
+	struct ext4_sb_info *sbi = EXT4_SB(dir->i_sb);
+#endif
 
 	if (EXT4_DIR_LINK_MAX(dir))
 		return -EMLINK;
@@ -2800,7 +2808,8 @@ out_clear_inode:
 	if (IS_DIRSYNC(dir))
 		ext4_handle_sync(handle);
 #ifdef CONFIG_EXT4_FS_ENCRYPTION
-	if (ext4_encrypted_inode(dir)) {
+	if (ext4_encrypted_inode(dir) ||
+	    unlikely(sbi->s_mount_flags & EXT4_MF_TEST_DUMMY_ENCRYPTION)) {
 		err = ext4_inherit_context(dir, inode);
 		if (err)
 			ext4_unlink(dir, dentry);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 3dcafe9..d904e0a 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1136,7 +1136,7 @@ enum {
 	Opt_commit, Opt_min_batch_time, Opt_max_batch_time, Opt_journal_dev,
 	Opt_journal_path, Opt_journal_checksum, Opt_journal_async_commit,
 	Opt_abort, Opt_data_journal, Opt_data_ordered, Opt_data_writeback,
-	Opt_data_err_abort, Opt_data_err_ignore,
+	Opt_data_err_abort, Opt_data_err_ignore, Opt_test_dummy_encryption,
 	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
 	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_jqfmt_vfsv1, Opt_quota,
 	Opt_noquota, Opt_barrier, Opt_nobarrier, Opt_err,
@@ -1223,6 +1223,7 @@ static const match_table_t tokens = {
 	{Opt_init_itable, "init_itable"},
 	{Opt_noinit_itable, "noinit_itable"},
 	{Opt_max_dir_size_kb, "max_dir_size_kb=%u"},
+	{Opt_test_dummy_encryption, "test_dummy_encryption"},
 	{Opt_removed, "check=none"},	/* mount option from ext2/3 */
 	{Opt_removed, "nocheck"},	/* mount option from ext2/3 */
 	{Opt_removed, "reservation"},	/* mount option from ext2/3 */
@@ -1423,6 +1424,7 @@ static const struct mount_opts {
 	{Opt_jqfmt_vfsv0, QFMT_VFS_V0, MOPT_QFMT},
 	{Opt_jqfmt_vfsv1, QFMT_VFS_V1, MOPT_QFMT},
 	{Opt_max_dir_size_kb, 0, MOPT_GTE0},
+	{Opt_test_dummy_encryption, 0, MOPT_GTE0},
 	{Opt_err, 0, 0}
 };
 
@@ -1593,6 +1595,15 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 		}
 		*journal_ioprio =
 			IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE, arg);
+	} else if (token == Opt_test_dummy_encryption) {
+#ifdef CONFIG_EXT4_FS_ENCRYPTION
+		sbi->s_mount_flags |= EXT4_MF_TEST_DUMMY_ENCRYPTION;
+		ext4_msg(sb, KERN_WARNING,
+			 "Test dummy encryption mode enabled");
+#else
+		ext4_msg(sb, KERN_WARNING,
+			 "Test dummy encryption mount option ignored");
+#endif
 	} else if (m->flags & MOPT_DATAJ) {
 		if (is_remount) {
 			if (!sbi->s_journal)
@@ -4036,6 +4047,13 @@ no_journal:
 		}
 	}
 
+	if (unlikely(sbi->s_mount_flags & EXT4_MF_TEST_DUMMY_ENCRYPTION) &&
+	    !(sb->s_flags & MS_RDONLY) &&
+	    !EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_ENCRYPT)) {
+		EXT4_SET_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_ENCRYPT);
+		ext4_commit_super(sb, 1);
+	}
+
 	/*
 	 * Get the # of file system overhead blocks from the
 	 * superblock if present.
-- 
2.3.0

