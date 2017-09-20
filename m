From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 03/25] fscrypt: remove ->is_encrypted()
Date: Wed, 20 Sep 2017 15:45:43 -0700
Message-ID: <20170920224605.22030-4-ebiggers3@gmail.com>
References: <20170920224605.22030-1-ebiggers3@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Michael Halcrow <mhalcrow@google.com>,
        Eric Biggers <ebiggers@google.com>
To: linux-fscrypt@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36333 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751872AbdITWqz (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Sep 2017 18:46:55 -0400
In-Reply-To: <20170920224605.22030-1-ebiggers3@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

Now that all callers of fscrypt_operations.is_encrypted() have been
switched to IS_ENCRYPTED(), remove ->is_encrypted().

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/super.c                | 2 --
 fs/f2fs/super.c                | 2 --
 fs/ubifs/crypto.c              | 1 -
 fs/ubifs/super.c               | 1 -
 fs/ubifs/ubifs.h               | 9 ++-------
 include/linux/fscrypt_common.h | 1 -
 6 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index dcfb19539871..bc63cdf194e3 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1241,13 +1241,11 @@ static const struct fscrypt_operations ext4_cryptops = {
 	.get_context		= ext4_get_context,
 	.set_context		= ext4_set_context,
 	.dummy_context		= ext4_dummy_context,
-	.is_encrypted		= ext4_encrypted_inode,
 	.empty_dir		= ext4_empty_dir,
 	.max_namelen		= ext4_max_namelen,
 };
 #else
 static const struct fscrypt_operations ext4_cryptops = {
-	.is_encrypted		= ext4_encrypted_inode,
 };
 #endif
 
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 89f61eb3d167..1cb41f711ab8 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1594,13 +1594,11 @@ static const struct fscrypt_operations f2fs_cryptops = {
 	.key_prefix	= "f2fs:",
 	.get_context	= f2fs_get_context,
 	.set_context	= f2fs_set_context,
-	.is_encrypted	= f2fs_encrypted_inode,
 	.empty_dir	= f2fs_empty_dir,
 	.max_namelen	= f2fs_max_namelen,
 };
 #else
 static const struct fscrypt_operations f2fs_cryptops = {
-	.is_encrypted	= f2fs_encrypted_inode,
 };
 #endif
 
diff --git a/fs/ubifs/crypto.c b/fs/ubifs/crypto.c
index 114ba455bac3..8880fa7733d8 100644
--- a/fs/ubifs/crypto.c
+++ b/fs/ubifs/crypto.c
@@ -87,7 +87,6 @@ const struct fscrypt_operations ubifs_crypt_operations = {
 	.key_prefix		= "ubifs:",
 	.get_context		= ubifs_crypt_get_context,
 	.set_context		= ubifs_crypt_set_context,
-	.is_encrypted		= __ubifs_crypt_is_encrypted,
 	.empty_dir		= ubifs_crypt_empty_dir,
 	.max_namelen		= ubifs_crypt_max_namelen,
 };
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 5496b17b959c..adaca6088836 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -2009,7 +2009,6 @@ static struct ubifs_info *alloc_ubifs_info(struct ubi_volume_desc *ubi)
 
 #ifndef CONFIG_UBIFS_FS_ENCRYPTION
 const struct fscrypt_operations ubifs_crypt_operations = {
-	.is_encrypted		= __ubifs_crypt_is_encrypted,
 };
 #endif
 
diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
index cd43651f1731..7b17b70cbf33 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -1835,18 +1835,13 @@ int ubifs_decrypt(const struct inode *inode, struct ubifs_data_node *dn,
 
 extern const struct fscrypt_operations ubifs_crypt_operations;
 
-static inline bool __ubifs_crypt_is_encrypted(struct inode *inode)
+static inline bool ubifs_crypt_is_encrypted(const struct inode *inode)
 {
-	struct ubifs_inode *ui = ubifs_inode(inode);
+	const struct ubifs_inode *ui = ubifs_inode(inode);
 
 	return ui->flags & UBIFS_CRYPT_FL;
 }
 
-static inline bool ubifs_crypt_is_encrypted(const struct inode *inode)
-{
-	return __ubifs_crypt_is_encrypted((struct inode *)inode);
-}
