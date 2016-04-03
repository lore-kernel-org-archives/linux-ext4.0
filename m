From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 05/13] fscrypto: comment improvements and fixes
Date: Sun,  3 Apr 2016 00:21:56 -0500
Message-ID: <1459660924-2960-6-git-send-email-ebiggers3@gmail.com>
References: <1459660924-2960-1-git-send-email-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, Eric Biggers <ebiggers3@gmail.com>, mhalcrow@google.com,
	linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, jaegeuk@kernel.org,
	linux-ext4@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <1459660924-2960-1-git-send-email-ebiggers3@gmail.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

Signed-off-by: Eric Biggers <ebiggers3@gmail.com>
---
 fs/crypto/crypto.c       | 13 ++++++------
 fs/crypto/fname.c        | 33 ++++++++++++++++++++++++++----
 fs/crypto/keyinfo.c      |  8 ++++++++
 include/linux/fscrypto.h | 53 ++++++++++++++++++++++++++++++++++++++++++------
 4 files changed, 90 insertions(+), 17 deletions(-)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index 6e550ec..836c0f2 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -83,8 +83,8 @@ EXPORT_SYMBOL(fscrypt_release_ctx);
  *
  * Allocates and initializes an encryption context.
  *
- * Return: An allocated and initialized encryption context on success; error
- * value or NULL otherwise.
+ * Return: An allocated and initialized encryption context on success; an error
+ * value otherwise.
  */
 struct fscrypt_ctx *fscrypt_get_ctx(struct inode *inode)
 {
@@ -222,7 +222,7 @@ static struct page *alloc_bounce_page(struct fscrypt_ctx *ctx)
  * release the bounce buffer and the encryption context.
  *
  * Return: An allocated page with the encrypted content on success. Else, an
- * error value or NULL.
+ * error value.
  */
 struct page *fscrypt_encrypt_page(struct inode *inode,
 				struct page *plaintext_page)
@@ -261,10 +261,10 @@ errout:
 EXPORT_SYMBOL(fscrypt_encrypt_page);
 
 /**
- * f2crypt_decrypt_page() - Decrypts a page in-place
+ * fscrypt_decrypt_page() - Decrypts a page in-place
  * @page: The page to decrypt. Must be locked.
  *
- * Decrypts page in-place using the ctx encryption context.
+ * Decrypts a page in-place using the host inode's encryption context.
  *
  * Called from the read completion callback.
  *
@@ -358,7 +358,6 @@ static int fscrypt_d_revalidate(struct dentry *dentry, unsigned int flags)
 					  (1 << KEY_FLAG_DEAD))))
 		ci = NULL;
 
-	/* this should eventually be an flag in d_flags */
 	spin_lock(&dentry->d_lock);
 	cached_with_key = dentry->d_flags & DCACHE_ENCRYPTED_WITH_KEY;
 	spin_unlock(&dentry->d_lock);
@@ -368,7 +367,7 @@ static int fscrypt_d_revalidate(struct dentry *dentry, unsigned int flags)
 	 * If the dentry was cached without the key, and it is a
 	 * negative dentry, it might be a valid name.  We can't check
 	 * if the key has since been made available due to locking
-	 * reasons, so we fail the validation so ext4_lookup() can do
+	 * reasons, so we fail the validation so ->lookup() can do
 	 * this check.
 	 *
 	 * We also fail the validation if the dentry was created with
diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
index ceaa815..cd0eae8 100644
--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -178,8 +178,11 @@ static const char *lookup_table =
 /**
  * digest_encode() -
  *
- * Encodes the input digest using characters from the set [a-zA-Z0-9_+].
+ * Encodes the input digest using characters from the set [A-Za-z0-9+,].
  * The encoded string is roughly 4/3 times the size of the input string.
+ *
+ * Note that the result of this encoding is for presentation purposes only; it
+ * is not persisted in the filesystem.
  */
 static int digest_encode(const char *src, int len, char *dst)
 {
@@ -239,7 +242,7 @@ u32 fscrypt_fname_encrypted_size(struct inode *inode, u32 ilen)
 EXPORT_SYMBOL(fscrypt_fname_encrypted_size);
 
 /**
- * fscrypt_fname_crypto_alloc_obuff() -
+ * fscrypt_fname_alloc_buffer() -
  *
  * Allocates an output buffer that is sufficient for the crypto operation
  * specified by the context and the direction.
@@ -264,7 +267,7 @@ int fscrypt_fname_alloc_buffer(struct inode *inode,
 EXPORT_SYMBOL(fscrypt_fname_alloc_buffer);
 
 /**
- * fscrypt_fname_crypto_free_buffer() -
+ * fscrypt_fname_free_buffer() -
  *
  * Frees the buffer allocated for crypto operation.
  */
@@ -280,6 +283,12 @@ EXPORT_SYMBOL(fscrypt_fname_free_buffer);
 /**
  * fscrypt_fname_disk_to_usr() - converts a filename from disk space to user
  * space
+ *
+ * The caller must have used fscrypt_fname_alloc_buffer() to allocate sufficient
+ * memory for the @oname string.  Also, fscrypt_load_encryption_info() must have
+ * been already called on the inode.
+ *
+ * Return: the length of the user space name or a negative errno value.
  */
 int fscrypt_fname_disk_to_usr(struct inode *inode,
 			u32 hash, u32 minor_hash,
@@ -290,6 +299,7 @@ int fscrypt_fname_disk_to_usr(struct inode *inode,
 	char buf[24];
 	int ret;
 
+	/* Leave . and .. alone. */
 	if (fscrypt_is_dot_dotdot(&qname)) {
 		oname->name[0] = '.';
 		oname->name[iname->len - 1] = '.';
@@ -300,14 +310,19 @@ int fscrypt_fname_disk_to_usr(struct inode *inode,
 	if (iname->len < FS_CRYPTO_BLOCK_SIZE)
 		return -EUCLEAN;
 
+	/* Decrypt the name if we have the key. */
 	if (inode->i_crypt_info)
 		return fname_decrypt(inode, iname, oname);
 
 	if (iname->len <= FS_FNAME_CRYPTO_DIGEST_SIZE) {
+		/* Short name: encode the encrypted name. */
 		ret = digest_encode(iname->name, iname->len, oname->name);
 		oname->len = ret;
 		return ret;
 	}
+
+	/* Long name: encode the name hash (if a directory entry, not a symlink)
+	 * concatenated with the last 16 bytes of the encrypted name. */
 	if (hash) {
 		memcpy(buf, &hash, 4);
 		memcpy(buf + 4, &minor_hash, 4);
@@ -325,23 +340,33 @@ EXPORT_SYMBOL(fscrypt_fname_disk_to_usr);
 /**
  * fscrypt_fname_usr_to_disk() - converts a filename from user space to disk
  * space
+ *
+ * The caller must have used fscrypt_fname_alloc_buffer() to allocate sufficient
+ * memory for the @oname string.  Also, fscrypt_load_encryption_info() must have
+ * been already called on the inode.
+ *
+ * Return: the length of the disk space name or a negative errno value.
  */
 int fscrypt_fname_usr_to_disk(struct inode *inode,
 			const struct qstr *iname,
 			struct fscrypt_str *oname)
 {
+	/* Leave . and .. alone. */
 	if (fscrypt_is_dot_dotdot(iname)) {
 		oname->name[0] = '.';
 		oname->name[iname->len - 1] = '.';
 		oname->len = iname->len;
 		return oname->len;
 	}
+
+	/* Encrypt the name if we have the key. */
 	if (inode->i_crypt_info)
 		return fname_encrypt(inode, iname, oname);
+
 	/*
 	 * Without a proper key, a user is not allowed to modify the filenames
 	 * in a directory. Consequently, a user space name cannot be mapped to
-	 * a disk-space name
+	 * a disk-space name.
 	 */
 	return -EACCES;
 }
diff --git a/fs/crypto/keyinfo.c b/fs/crypto/keyinfo.c
index e0b3281..33296c0 100644
--- a/fs/crypto/keyinfo.c
+++ b/fs/crypto/keyinfo.c
@@ -255,6 +255,14 @@ void fscrypt_unload_encryption_info(struct inode *inode,
 }
 EXPORT_SYMBOL(fscrypt_unload_encryption_info);
 
+/*
+ * Try to load the fscrypt_info for an encrypted inode into memory.
+ *
+ * Return: 0 if the fscrypt_info was loaded or was already loaded, or also 0 if
+ * the master encryption key is not available (use fscrypt_has_encryption_key()
+ * to distingush the two cases); or a negative errno value if another error
+ * occurred.
+ */
 int fscrypt_load_encryption_info(struct inode *inode)
 {
 	struct fscrypt_info *ci = inode->i_crypt_info;
diff --git a/include/linux/fscrypto.h b/include/linux/fscrypto.h
index 9a32d7e..f29dc8c 100644
--- a/include/linux/fscrypto.h
+++ b/include/linux/fscrypto.h
@@ -36,9 +36,8 @@
 #define FS_ENCRYPTION_MODE_AES_256_CTS		4
 
 /**
- * Encryption context for inode
+ * struct fscrypt_context: the on-disk format of an inode's encryption metadata
  *
- * Protector format:
  *  1 byte: Protector format (1 = this version)
  *  1 byte: File contents encryption mode
  *  1 byte: File names encryption mode
@@ -67,13 +66,36 @@ struct fscrypt_context {
 #define FS_KEY_DESC_PREFIX		"fscrypt:"
 #define FS_KEY_DESC_PREFIX_SIZE		8
 
-/* This is passed in from userspace into the kernel keyring */
+/**
+ * struct fscrypt_key - payload of a master encryption key, as passed into a
+ *			kernel keyring from userspace
+ *
+ * @mode: Currently unused
+ * @raw: Raw bytes of the key
+ * @size: Length of the key (number of bytes in @raw actually used)
+ */
 struct fscrypt_key {
 	u32 mode;
 	u8 raw[FS_MAX_KEY_SIZE];
 	u32 size;
 } __packed;
 
+/**
+ * struct fscrypt_info - the cipher, encryption modes, and master key reference
+ *			 for an inode
+ *
+ * @ci_data_mode: Encryption mode to use for the contents of regular files
+ * @ci_filename_mode: Encryption mode to use for filenames and symlink targets
+ * @ci_flags: See FS_POLICY_FLAGS_*.
+ * @ci_ctfm: Allocated symmetric cipher for this inode, using the inode's
+ *	     unique encryption key which is derived from the master key and the
+ *	     per-inode nonce.  If the inode is a regular file, this cipher uses
+ *	     the data encryption mode, whereas if the inode is a directory or
+ *	     symlink, this cipher uses the filename encryption mode.
+ * @ci_keyring_key: Reference to the master key in a kernel keyring, or NULL if
+ *		    the test-only "dummy" encryption mode is in effect
+ * @ci_master_key: The descriptor of the master key, in binary form
+ */
 struct fscrypt_info {
 	u8 ci_data_mode;
 	u8 ci_filename_mode;
@@ -86,13 +108,19 @@ struct fscrypt_info {
 #define FS_CTX_REQUIRES_FREE_ENCRYPT_FL		0x00000001
 #define FS_WRITE_PATH_FL			0x00000002
 
+/**
+ * struct fscrypt_ctx - holds pages being decrypted or encrypted
+ *
+ * This is a reusable structure, not tied to any particular inode.
+ */
 struct fscrypt_ctx {
 	union {
-		struct {
+		struct { /* Writing (encryption) */
 			struct page *bounce_page;	/* Ciphertext page */
 			struct page *control_page;	/* Original page  */
 		} w;
-		struct {
+
+		struct { /* Reading (decryption) */
 			struct bio *bio;
 			struct work_struct work;
 		} r;
@@ -171,7 +199,20 @@ struct fscrypt_name {
 #define fname_len(p)		((p)->disk_name.len)
 
 /*
- * crypto opertions for filesystems
+ * struct fscrypt_operations - crypto operations for filesystems
+ *
+ * @get_context - Retrieve the inode's persistent encryption metadata into the
+ *		  provided buffer.  Semantics are like getxattr().
+ * @set_context - Set the inode's persistent encryption metadata.  Return 0 or a
+ *		  negative errno value.
+ * @dummy_context - Test whether the inode uses the test-only "dummy" encryption
+ *		    mode
+ * @is_encrypted - Test whether the inode is encrypted
+ * @empty_dir - Test whether the directory inode is empty
+ * @max_namelen - Return the maximum length of an unencrypted name we might have
+ *		  to encrypt for the inode.  Note that for symlinks, we encrypt
+ *		  the symlink *target* which typically can be longer than a
+ *		  single filename.
  */
 struct fscrypt_operations {
 	int (*get_context)(struct inode *, void *, size_t);
-- 
2.7.4


------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785471&iu=/4140
