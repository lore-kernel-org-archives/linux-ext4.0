From: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 2/3] ext4 crypto: initialize crypto memory in early stage
Date: Tue, 12 May 2015 14:21:04 -0700
Message-ID: <1431465665-36803-1-git-send-email-jaegeuk@kernel.org>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:38462 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933116AbbELVVM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 May 2015 17:21:12 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Previously, crypto initialization was done at the first readpage time.
It'd need to avoid large memory allocation at run time.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/ext4/crypto.c     | 2 +-
 fs/ext4/crypto_key.c | 6 ------
 fs/ext4/ext4.h       | 4 ++--
 fs/ext4/super.c      | 8 ++++++++
 4 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/crypto.c b/fs/ext4/crypto.c
index 04c620f..f265c08 100644
--- a/fs/ext4/crypto.c
+++ b/fs/ext4/crypto.c
@@ -256,7 +256,7 @@ void ext4_exit_crypto(void)
  *
  * Return: Zero on success, non-zero otherwise.
  */
-int ext4_init_crypto(void)
+int __init ext4_init_crypto(void)
 {
 	int i, res = -ENOMEM;
 
diff --git a/fs/ext4/crypto_key.c b/fs/ext4/crypto_key.c
index 858d7d6..fb957ab 100644
--- a/fs/ext4/crypto_key.c
+++ b/fs/ext4/crypto_key.c
@@ -113,12 +113,6 @@ int _ext4_get_encryption_info(struct inode *inode)
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	int res;
 
-	if (!ext4_read_workqueue) {
-		res = ext4_init_crypto();
-		if (res)
-			return res;
-	}
-
 	if (ei->i_crypt_info) {
 		if (!ei->i_crypt_info->ci_keyring_key ||
 		    key_validate(ei->i_crypt_info->ci_keyring_key) == 0)
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 505bc66..3b5dd12 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2073,14 +2073,14 @@ int ext4_decrypt_one(struct inode *inode, struct page *page);
 int ext4_encrypted_zeroout(struct inode *inode, struct ext4_extent *ex);
 
 #ifdef CONFIG_EXT4_FS_ENCRYPTION
-int ext4_init_crypto(void);
+int __init ext4_init_crypto(void);
 void ext4_exit_crypto(void);
 static inline int ext4_sb_has_crypto(struct super_block *sb)
 {
 	return EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_ENCRYPT);
 }
 #else
-static inline int ext4_init_crypto(void) { return 0; }
+static inline int __init ext4_init_crypto(void) { return 0; }
 static inline void ext4_exit_crypto(void) { }
 static inline int ext4_sb_has_crypto(struct super_block *sb)
 {
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 79311e0..411a8a3 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5611,6 +5611,11 @@ static int __init ext4_init_fs(void)
 	err = init_inodecache();
 	if (err)
 		goto out1;
+
+	err = ext4_init_crypto();
+	if (err)
+		goto out0;
+
 	register_as_ext3();
 	register_as_ext2();
 	err = register_filesystem(&ext4_fs_type);
@@ -5621,6 +5626,8 @@ static int __init ext4_init_fs(void)
 out:
 	unregister_as_ext2();
 	unregister_as_ext3();
+	ext4_exit_crypto();
+out0:
 	destroy_inodecache();
 out1:
 	ext4_mballoc_ready = 0;
@@ -5646,6 +5653,7 @@ static void __exit ext4_exit_fs(void)
 	ext4_destroy_lazyinit_thread();
 	unregister_as_ext2();
 	unregister_as_ext3();
+	ext4_exit_crypto();
 	unregister_filesystem(&ext4_fs_type);
 	destroy_inodecache();
 	ext4_exit_mballoc();
-- 
2.1.1

