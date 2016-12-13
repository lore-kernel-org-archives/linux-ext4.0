From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH] fscrypt / ext4: make test_dummy_encryption require a keyring key
Date: Mon, 12 Dec 2016 22:52:10 -0800
Message-ID: <1481611930-65173-1-git-send-email-ebiggers3@gmail.com>
Cc: "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-fsdevel@vger.kernel.org, Eric Biggers <ebiggers@google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Currently, the test_dummy_encryption ext4 mount option, which exists
only to test encrypted I/O paths with xfstests, overrides all per-inode
encryption keys with a fixed key.  This skips both keyring lookup and
key derivation, which is not ideal because that code doesn't get tested.
The fixed keys are also incompatible with a crypto change slated for
4.10 which enables stricter key checks for XTS.  Finally, it would be
nice to eliminate the risk that dummy keys could be used accidentally.

Until we can replace test_dummy_encryption completely, avoid these
problems by making it *only* cause a default encryption context to be
assigned when an inode is created in an unencrypted directory.  The
responsibility of providing the key is therefore shifted to userspace,
which to access inodes with these default encryption contexts will need
to add a keyring key with description "fscrypt:4242424242424242".

To go along with this I'm also proposing a patch to xfstests-bld which
makes it add the required key to the keyring before starting xfstests.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/keyinfo.c | 19 ++++---------------
 fs/crypto/policy.c  | 40 ++++++++++++++++++++++------------------
 fs/ext4/ialloc.c    | 12 +++++++-----
 fs/ext4/namei.c     | 12 +++++++-----
 4 files changed, 40 insertions(+), 43 deletions(-)

diff --git a/fs/crypto/keyinfo.c b/fs/crypto/keyinfo.c
index 6eeea1d..4a606cf 100644
--- a/fs/crypto/keyinfo.c
+++ b/fs/crypto/keyinfo.c
@@ -205,16 +205,11 @@ int fscrypt_get_crypt_info(struct inode *inode)
 	}
 
 	res = inode->i_sb->s_cop->get_context(inode, &ctx, sizeof(ctx));
-	if (res < 0) {
-		if (!fscrypt_dummy_context_enabled(inode))
-			return res;
-		ctx.format = FS_ENCRYPTION_CONTEXT_FORMAT_V1;
-		ctx.contents_encryption_mode = FS_ENCRYPTION_MODE_AES_256_XTS;
-		ctx.filenames_encryption_mode = FS_ENCRYPTION_MODE_AES_256_CTS;
-		ctx.flags = 0;
-	} else if (res != sizeof(ctx)) {
+	if (res < 0)
+		return res;
+
+	if (res != sizeof(ctx))
 		return -EINVAL;
-	}
 
 	if (ctx.format != FS_ENCRYPTION_CONTEXT_FORMAT_V1)
 		return -EINVAL;
@@ -247,11 +242,6 @@ int fscrypt_get_crypt_info(struct inode *inode)
 	if (!raw_key)
 		goto out;
 
-	if (fscrypt_dummy_context_enabled(inode)) {
-		memset(raw_key, 0x42, FS_AES_256_XTS_KEY_SIZE);
-		goto got_key;
-	}
-
 	res = validate_user_key(crypt_info, &ctx, raw_key,
 			FS_KEY_DESC_PREFIX, FS_KEY_DESC_PREFIX_SIZE);
 	if (res && inode->i_sb->s_cop->key_prefix) {
@@ -269,7 +259,6 @@ int fscrypt_get_crypt_info(struct inode *inode)
 	} else if (res) {
 		goto out;
 	}
-got_key:
 	ctfm = crypto_alloc_skcipher(cipher_str, 0, 0);
 	if (!ctfm || IS_ERR(ctfm)) {
 		res = ctfm ? PTR_ERR(ctfm) : -ENOMEM;
diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index 6ed7c2e..d29ead8 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -212,42 +212,46 @@ EXPORT_SYMBOL(fscrypt_has_permitted_context);
  * @parent: Parent inode from which the context is inherited.
  * @child:  Child inode that inherits the context from @parent.
  * @fs_data:  private data given by FS.
- * @preload:  preload child i_crypt_info
+ * @preload:  preload child i_crypt_info?
  *
- * Return: Zero on success, non-zero otherwise
+ * Return: 0 on success, -errno on failure
  */
 int fscrypt_inherit_context(struct inode *parent, struct inode *child,
-						void *fs_data, bool preload)
+			    void *fs_data, bool preload)
 {
 	struct fscrypt_context ctx;
-	struct fscrypt_info *ci;
 	int res;
 
 	if (!parent->i_sb->s_cop->set_context)
 		return -EOPNOTSUPP;
 
-	res = fscrypt_get_encryption_info(parent);
-	if (res < 0)
-		return res;
+	ctx.format = FS_ENCRYPTION_CONTEXT_FORMAT_V1;
 
-	ci = parent->i_crypt_info;
-	if (ci == NULL)
-		return -ENOKEY;
+	res = fscrypt_get_encryption_info(parent);
+	if (res == 0) {
+		const struct fscrypt_info *ci = parent->i_crypt_info;
 
-	ctx.format = FS_ENCRYPTION_CONTEXT_FORMAT_V1;
-	if (fscrypt_dummy_context_enabled(parent)) {
-		ctx.contents_encryption_mode = FS_ENCRYPTION_MODE_AES_256_XTS;
-		ctx.filenames_encryption_mode = FS_ENCRYPTION_MODE_AES_256_CTS;
-		ctx.flags = 0;
-		memset(ctx.master_key_descriptor, 0x42, FS_KEY_DESCRIPTOR_SIZE);
-		res = 0;
-	} else {
+		if (!ci)
+			return -ENOKEY;
 		ctx.contents_encryption_mode = ci->ci_data_mode;
 		ctx.filenames_encryption_mode = ci->ci_filename_mode;
 		ctx.flags = ci->ci_flags;
 		memcpy(ctx.master_key_descriptor, ci->ci_master_key,
 				FS_KEY_DESCRIPTOR_SIZE);
+	} else if (unlikely(res == -ENODATA &&
+			    fscrypt_dummy_context_enabled(parent))) {
+		/*
+		 * For testing only (-o test_dummy_encryption): assign default
+		 * encryption context to inode created in unencrypted directory.
+		 */
+		ctx.contents_encryption_mode = FS_ENCRYPTION_MODE_AES_256_XTS;
+		ctx.filenames_encryption_mode = FS_ENCRYPTION_MODE_AES_256_CTS;
+		ctx.flags = 0;
+		memset(ctx.master_key_descriptor, 0x42, FS_KEY_DESCRIPTOR_SIZE);
+	} else {
+		return res;
 	}
+
 	get_random_bytes(ctx.nonce, FS_KEY_DERIVATION_NONCE_SIZE);
 	res = parent->i_sb->s_cop->set_context(child, &ctx,
 						sizeof(ctx), fs_data);
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index e57e8d9..b26d225 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -767,11 +767,13 @@ struct inode *__ext4_new_inode(handle_t *handle, struct inode *dir,
 	if ((ext4_encrypted_inode(dir) ||
 	     DUMMY_ENCRYPTION_ENABLED(EXT4_SB(dir->i_sb))) &&
 	    (S_ISREG(mode) || S_ISDIR(mode) || S_ISLNK(mode))) {
-		err = fscrypt_get_encryption_info(dir);
-		if (err)
-			return ERR_PTR(err);
-		if (!fscrypt_has_encryption_key(dir))
-			return ERR_PTR(-EPERM);
+		if (ext4_encrypted_inode(dir)) {
+			err = fscrypt_get_encryption_info(dir);
+			if (err)
+				return ERR_PTR(err);
+			if (!fscrypt_has_encryption_key(dir))
+				return ERR_PTR(-EPERM);
+		}
 		if (!handle)
 			nblocks += EXT4_DATA_TRANS_BLOCKS(dir->i_sb);
 		encrypt = 1;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index eadba91..98592b6 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3084,11 +3084,13 @@ static int ext4_symlink(struct inode *dir,
 	encryption_required = (ext4_encrypted_inode(dir) ||
 			       DUMMY_ENCRYPTION_ENABLED(EXT4_SB(dir->i_sb)));
 	if (encryption_required) {
-		err = fscrypt_get_encryption_info(dir);
-		if (err)
-			return err;
-		if (!fscrypt_has_encryption_key(dir))
-			return -EPERM;
+		if (ext4_encrypted_inode(dir)) {
+			err = fscrypt_get_encryption_info(dir);
+			if (err)
+				return err;
+			if (!fscrypt_has_encryption_key(dir))
+				return -EPERM;
+		}
 		disk_link.len = (fscrypt_fname_encrypted_size(dir, len) +
 				 sizeof(struct fscrypt_symlink_data));
 		sd = kzalloc(disk_link.len, GFP_KERNEL);
-- 
2.8.0.rc3.226.g39d4020

