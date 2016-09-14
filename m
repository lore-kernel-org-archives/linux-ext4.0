From: Eric Biggers <ebiggers@google.com>
Subject: [PATCH] fscrypto: make filename crypto functions return 0 on success
Date: Wed, 14 Sep 2016 16:00:45 -0700
Message-ID: <1473894045-65215-1-git-send-email-ebiggers@google.com>
Cc: linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        tytso@mit.edu, jaegeuk@kernel.org,
        Eric Biggers <ebiggers@google.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Several filename crypto functions: fname_decrypt(),
fscrypt_fname_disk_to_usr(), and fscrypt_fname_usr_to_disk(), returned
the output length on success or -errno on failure.  However, the output
length was redundant with the value written to 'oname->len'.  It is also
potentially error-prone to make callers have to check for '< 0' instead
of '!= 0'.

Therefore, make these functions return 0 instead of a length, and make
the callers who cared about the return value being a length use
'oname->len' instead.

This change also fixes the inconsistency of fname_encrypt() actually
already returning 0 on success, not a length like the other filename
crypto functions and as documented in its function comment.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/fname.c | 52 ++++++++++++++++++++++++++++++----------------------
 fs/ext4/dir.c     |  5 +++--
 fs/ext4/symlink.c |  5 ++---
 fs/f2fs/namei.c   |  4 ++--
 4 files changed, 37 insertions(+), 29 deletions(-)

diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
index 6bbc3b1..49fd564 100644
--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -35,11 +35,11 @@ static void fname_crypt_complete(struct crypto_async_request *req, int res)
 }
 
 /**
- * fname_encrypt() -
+ * fname_encrypt() - encrypt a filename
  *
- * This function encrypts the input filename, and returns the length of the
- * ciphertext. Errors are returned as negative numbers.  We trust the caller to
- * allocate sufficient memory to oname string.
+ * The caller must have allocated sufficient memory for the @oname string.
+ *
+ * Return: 0 on success, -errno on failure
  */
 static int fname_encrypt(struct inode *inode,
 			const struct qstr *iname, struct fscrypt_str *oname)
@@ -105,20 +105,22 @@ static int fname_encrypt(struct inode *inode,
 	}
 	kfree(alloc_buf);
 	skcipher_request_free(req);
-	if (res < 0)
+	if (res < 0) {
 		printk_ratelimited(KERN_ERR
 				"%s: Error (error code %d)\n", __func__, res);
+		return res;
+	}
 
 	oname->len = ciphertext_len;
-	return res;
+	return 0;
 }
 
-/*
- * fname_decrypt()
- *	This function decrypts the input filename, and returns
- *	the length of the plaintext.
- *	Errors are returned as negative numbers.
- *	We trust the caller to allocate sufficient memory to oname string.
+/**
+ * fname_decrypt() - decrypt a filename
+ *
+ * The caller must have allocated sufficient memory for the @oname string.
+ *
+ * Return: 0 on success, -errno on failure
  */
 static int fname_decrypt(struct inode *inode,
 				const struct fscrypt_str *iname,
@@ -168,7 +170,7 @@ static int fname_decrypt(struct inode *inode,
 	}
 
 	oname->len = strnlen(oname->name, iname->len);
-	return oname->len;
+	return 0;
 }
 
 static const char *lookup_table =
@@ -279,6 +281,10 @@ EXPORT_SYMBOL(fscrypt_fname_free_buffer);
 /**
  * fscrypt_fname_disk_to_usr() - converts a filename from disk space to user
  * space
+ *
+ * The caller must have allocated sufficient memory for the @oname string.
+ *
+ * Return: 0 on success, -errno on failure
  */
 int fscrypt_fname_disk_to_usr(struct inode *inode,
 			u32 hash, u32 minor_hash,
@@ -287,13 +293,12 @@ int fscrypt_fname_disk_to_usr(struct inode *inode,
 {
 	const struct qstr qname = FSTR_TO_QSTR(iname);
 	char buf[24];
-	int ret;
 
 	if (fscrypt_is_dot_dotdot(&qname)) {
 		oname->name[0] = '.';
 		oname->name[iname->len - 1] = '.';
 		oname->len = iname->len;
-		return oname->len;
+		return 0;
 	}
 
 	if (iname->len < FS_CRYPTO_BLOCK_SIZE)
@@ -303,9 +308,9 @@ int fscrypt_fname_disk_to_usr(struct inode *inode,
 		return fname_decrypt(inode, iname, oname);
 
 	if (iname->len <= FS_FNAME_CRYPTO_DIGEST_SIZE) {
-		ret = digest_encode(iname->name, iname->len, oname->name);
-		oname->len = ret;
-		return ret;
+		oname->len = digest_encode(iname->name, iname->len,
+					   oname->name);
+		return 0;
 	}
 	if (hash) {
 		memcpy(buf, &hash, 4);
@@ -315,15 +320,18 @@ int fscrypt_fname_disk_to_usr(struct inode *inode,
 	}
 	memcpy(buf + 8, iname->name + iname->len - 16, 16);
 	oname->name[0] = '_';
-	ret = digest_encode(buf, 24, oname->name + 1);
-	oname->len = ret + 1;
-	return ret + 1;
+	oname->len = 1 + digest_encode(buf, 24, oname->name + 1);
+	return 0;
 }
 EXPORT_SYMBOL(fscrypt_fname_disk_to_usr);
 
 /**
  * fscrypt_fname_usr_to_disk() - converts a filename from user space to disk
  * space
+ *
+ * The caller must have allocated sufficient memory for the @oname string.
+ *
+ * Return: 0 on success, -errno on failure
  */
 int fscrypt_fname_usr_to_disk(struct inode *inode,
 			const struct qstr *iname,
@@ -333,7 +341,7 @@ int fscrypt_fname_usr_to_disk(struct inode *inode,
 		oname->name[0] = '.';
 		oname->name[iname->len - 1] = '.';
 		oname->len = iname->len;
-		return oname->len;
+		return 0;
 	}
 	if (inode->i_crypt_info)
 		return fname_encrypt(inode, iname, oname);
diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 67415e0..4d4b910 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -260,11 +260,12 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
 					/* Directory is encrypted */
 					err = fscrypt_fname_disk_to_usr(inode,
 						0, 0, &de_name, &fstr);
+					de_name = fstr;
 					fstr.len = save_len;
-					if (err < 0)
+					if (err)
 						goto errout;
 					if (!dir_emit(ctx,
-					    fstr.name, err,
+					    de_name.name, de_name.len,
 					    le32_to_cpu(de->inode),
 					    get_dtype(sb, de->file_type)))
 						goto done;
diff --git a/fs/ext4/symlink.c b/fs/ext4/symlink.c
index 4d83d9e..55aaf30 100644
--- a/fs/ext4/symlink.c
+++ b/fs/ext4/symlink.c
@@ -67,14 +67,13 @@ static const char *ext4_encrypted_get_link(struct dentry *dentry,
 		goto errout;
 
 	res = fscrypt_fname_disk_to_usr(inode, 0, 0, &cstr, &pstr);
-	if (res < 0)
+	if (res)
 		goto errout;
 
 	paddr = pstr.name;
 
 	/* Null-terminate the name */
-	if (res <= pstr.len)
-		paddr[res] = '\0';
+	paddr[pstr.len] = '\0';
 	if (cpage)
 		put_page(cpage);
 	set_delayed_call(done, kfree_link, paddr);
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 73fa356..a5468c2 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -1048,7 +1048,7 @@ static const char *f2fs_encrypted_get_link(struct dentry *dentry,
 		goto errout;
 
 	res = fscrypt_fname_disk_to_usr(inode, 0, 0, &cstr, &pstr);
-	if (res < 0)
+	if (res)
 		goto errout;
 
 	/* this is broken symlink case */
@@ -1060,7 +1060,7 @@ static const char *f2fs_encrypted_get_link(struct dentry *dentry,
 	paddr = pstr.name;
 
 	/* Null-terminate the name */
-	paddr[res] = '\0';
+	paddr[pstr.len] = '\0';
 
 	put_page(cpage);
 	set_delayed_call(done, kfree_link, paddr);
-- 
2.8.0.rc3.226.g39d4020

