From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH v4 4/4] ext4 crypto: add ioctls to allow backup of encryption metadata
Date: Wed, 16 Dec 2015 17:46:08 -0500
Message-ID: <1450305968-21785-5-git-send-email-tytso@mit.edu>
References: <1450305968-21785-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50777 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755067AbbLPWqW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Dec 2015 17:46:22 -0500
In-Reply-To: <1450305968-21785-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add new ioctls which allow for the metadata of encrypted files (both
the filename and the crypto policy) to be backed up and restored.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/crypto_key.c  | 124 ++++++++++++++++++++++++++++++++++++-
 fs/ext4/ext4.h        |  12 ++++
 fs/ext4/ext4_crypto.h |  16 +++++
 fs/ext4/ioctl.c       |  87 ++++++++++++++++++++++++++
 fs/ext4/namei.c       | 165 ++++++++++++++++++++++++++++++++++++++++++--------
 5 files changed, 379 insertions(+), 25 deletions(-)

diff --git a/fs/ext4/crypto_key.c b/fs/ext4/crypto_key.c
index 9a16d1e..4f4b2c8 100644
--- a/fs/ext4/crypto_key.c
+++ b/fs/ext4/crypto_key.c
@@ -10,11 +10,12 @@
 
 #include <keys/encrypted-type.h>
 #include <keys/user-type.h>
+#include <linux/crc16.h>
 #include <linux/random.h>
 #include <linux/scatterlist.h>
 #include <uapi/linux/keyctl.h>
 
-#include "ext4.h"
+#include "ext4_jbd2.h"
 #include "xattr.h"
 
 static void derive_crypt_complete(struct crypto_async_request *req, int rc)
@@ -274,3 +275,124 @@ int ext4_has_encryption_key(struct inode *inode)
 
 	return (ei->i_crypt_info != NULL);
 }
+
+int ext4_get_encryption_metadata(struct inode *inode,
+				 struct ext4_encrypted_metadata *mdata)
+{
+	unsigned char *cp = &mdata->metadata[0];
+	size_t size = mdata->len;
+	loff_t isize;
+	int res;
+
+	if (size < sizeof(struct ext4_encryption_context) + 12)
+		return -EINVAL;
+
+	if (!inode_owner_or_capable(inode) && !capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	*cp++ = 'e';
+	*cp++ = '5';
+	*cp++ = 0;
+	*cp++ = 0;
+	isize = i_size_read(inode);
+	*((u32 *)cp) = cpu_to_le32(isize & 0xFFFFFFFF);
+	cp += 4;
+	*((u32 *)cp) = cpu_to_le32(isize >> 32);
+	cp += 4;
+	size -= 12;
+
+	res = ext4_xattr_get(inode, EXT4_XATTR_INDEX_ENCRYPTION,
+			     EXT4_XATTR_NAME_ENCRYPTION_CONTEXT,
+			     cp, size);
+
+	if (res < 0)
+		return res;
+	if (res > size)
+		return -ENOSPC;
+
+	mdata->len = res + 12;
+
+	*((u16 *) &mdata->metadata[2]) = cpu_to_le16(crc16(~0, mdata->metadata, mdata->len));
+	return 0;
+}
+
+int ext4_set_encryption_metadata(struct inode *inode,
+				 struct ext4_encrypted_metadata *mdata)
+{
+	struct ext4_encryption_context *ctx;
+	unsigned char *cp = &mdata->metadata[0];
+	handle_t *handle = NULL;
+	loff_t size;
+	unsigned bs = inode->i_sb->s_blocksize;
+	int res;
+	u16 crc;
+
+	if (!inode_owner_or_capable(inode) && !capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	if (!S_ISREG(inode->i_mode) && !S_ISDIR(inode->i_mode))
+		return -EINVAL;
+
+	if (mdata->len != sizeof(struct ext4_encryption_context) + 12)
+		return -EINVAL;
+
+	if (cp[0] != 'e' || cp[1] != '5')
+		return -EINVAL;
+	crc = le16_to_cpu(*(u16 *)(cp+2));
+	cp[2] = cp[3] = 0;
+	cp += 4;
+
+	if (crc != crc16(~0, mdata->metadata, mdata->len))
+		return -EINVAL;
+
+	size = le32_to_cpu(*(u32 *) cp);
+	cp += 4;
+	size += ((u64) le32_to_cpu(*(u32 *) cp)) << 32;
+	cp += 4;
+
+	ctx = (struct ext4_encryption_context *) cp;
+	if ((ctx->format != EXT4_ENCRYPTION_CONTEXT_FORMAT_V1) ||
+	    !ext4_valid_contents_enc_mode(ctx->contents_encryption_mode) ||
+	    !ext4_valid_filenames_enc_mode(ctx->filenames_encryption_mode) ||
+	    (ctx->flags & ~EXT4_POLICY_FLAGS_VALID))
+		return -EINVAL;
+
+	res = ext4_convert_inline_data(inode);
+	if (res)
+		return res;
+
+	res = filemap_write_and_wait(&inode->i_data);
+	if (res)
+		return res;
+
+	mutex_lock(&inode->i_mutex);
+	if (round_up(size, bs) != round_up(i_size_read(inode), bs)) {
+		res = -EINVAL;
+		goto errout;
+	}
+
+	handle = ext4_journal_start(inode, EXT4_HT_MISC,
+				    ext4_jbd2_credits_xattr(inode));
+	if (IS_ERR(handle))
+		return PTR_ERR(handle);
+	res = ext4_xattr_set(inode, EXT4_XATTR_INDEX_ENCRYPTION,
+			     EXT4_XATTR_NAME_ENCRYPTION_CONTEXT, ctx,
+			     sizeof(struct ext4_encryption_context), 0);
+	if (res < 0)
+		goto errout;
+	ext4_set_inode_flag(inode, EXT4_INODE_ENCRYPT);
+	ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
+
+	i_size_write(inode, size);
+	EXT4_I(inode)->i_disksize = size;
+	res = ext4_mark_inode_dirty(handle, inode);
+	if (res)
+		EXT4_ERROR_INODE(inode, "Failed to mark inode dirty");
+	else
+		res = ext4_get_encryption_info(inode);
+errout:
+	mutex_unlock(&inode->i_mutex);
+	if (handle)
+		ext4_journal_stop(handle);
+	return res;
+}
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 9fdbd06..1136f03 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -617,6 +617,10 @@ enum {
 #define EXT4_IOC_SET_ENCRYPTION_POLICY	_IOR('f', 19, struct ext4_encryption_policy)
 #define EXT4_IOC_GET_ENCRYPTION_PWSALT	_IOW('f', 20, __u8[16])
 #define EXT4_IOC_GET_ENCRYPTION_POLICY	_IOW('f', 21, struct ext4_encryption_policy)
+#define EXT4_IOC_GET_ENCRYPTION_METADATA _IOWR('f', 22, struct ext4_encrypted_metadata)
+#define EXT4_IOC_SET_ENCRYPTION_METADATA _IOR('f', 23, struct ext4_encrypted_metadata)
+#define EXT4_IOC_GET_ENCRYPTED_FILENAME	_IOWR('f', 24, struct ext4_encrypted_metadata)
+#define EXT4_IOC_SET_ENCRYPTED_FILENAME	_IOR('f', 25, struct ext4_set_encrypted_fname)
 
 #if defined(__KERNEL__) && defined(CONFIG_COMPAT)
 /*
@@ -2311,6 +2315,10 @@ static inline void ext4_fname_free_filename(struct ext4_filename *fname) { }
 void ext4_free_crypt_info(struct ext4_crypt_info *ci);
 void ext4_free_encryption_info(struct inode *inode, struct ext4_crypt_info *ci);
 int _ext4_get_encryption_info(struct inode *inode);
+int ext4_set_encryption_metadata(struct inode *inode,
+				 struct ext4_encrypted_metadata *mdata);
+int ext4_get_encryption_metadata(struct inode *inode,
+				 struct ext4_encrypted_metadata *mdata);
 
 #ifdef CONFIG_EXT4_FS_ENCRYPTION
 int ext4_has_encryption_key(struct inode *inode);
@@ -2546,6 +2554,10 @@ extern int ext4_generic_delete_entry(handle_t *handle,
 				     int buf_size,
 				     int csum_size);
 extern int ext4_empty_dir(struct inode *inode);
+extern int ext4_get_encrypted_filename(struct file *filp,
+				       struct ext4_encrypted_metadata *mdata);
+extern int ext4_set_encrypted_filename(struct inode *dir,
+				       struct ext4_set_encrypted_fname *efn);
 
 /* resize.c */
 extern int ext4_group_add(struct super_block *sb,
diff --git a/fs/ext4/ext4_crypto.h b/fs/ext4/ext4_crypto.h
index ac7d4e8..eb7088a 100644
--- a/fs/ext4/ext4_crypto.h
+++ b/fs/ext4/ext4_crypto.h
@@ -156,4 +156,20 @@ static inline u32 encrypted_symlink_data_len(u32 l)
 	return (l + sizeof(struct ext4_encrypted_symlink_data) - 1);
 }
 
+/**
+ * Structure used for communicating encrypted metadata with userspace
+ */
+struct ext4_encrypted_metadata {
+	u32 len;
+	unsigned char metadata[288];
+};
+
+/**
+ * Structured used for setting an encrypted file name
+ */
+struct ext4_set_encrypted_fname {
+	s32 fd;
+	u32 len;
+	unsigned char enc_fname[256];
+};
 #endif	/* _EXT4_CRYPTO_H */
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 5e872fd..e86a39e 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -689,6 +689,90 @@ encryption_policy_out:
 		return -EOPNOTSUPP;
 #endif
 	}
+	case EXT4_IOC_GET_ENCRYPTION_METADATA: {
+#ifdef CONFIG_EXT4_FS_ENCRYPTION
+		struct ext4_encrypted_metadata mdata;
+		int err = 0;
+
+		if (get_user(mdata.len, (u32 __user *) arg))
+			return -EFAULT;
+		if (mdata.len > sizeof(mdata.metadata))
+			return -EINVAL;
+
+		if (!ext4_encrypted_inode(inode))
+			return -ENOENT;
+		err = ext4_get_encryption_metadata(inode, &mdata);
+		if (err)
+			return err;
+		if (copy_to_user((void __user *)arg, &mdata, sizeof(mdata)))
+			return -EFAULT;
+		return 0;
+#else
+		return -EOPNOTSUPP;
+#endif
+	}
+	case EXT4_IOC_SET_ENCRYPTION_METADATA: {
+#ifdef CONFIG_EXT4_FS_ENCRYPTION
+		struct ext4_encrypted_metadata mdata;
+		int err = 0;
+
+		if (ext4_encrypted_inode(inode))
+			return -EINVAL;
+		if (copy_from_user(&mdata,
+				   (struct ext4_encrypted_metadata __user *)arg,
+				   sizeof(mdata)))
+			return -EFAULT;
+		err = mnt_want_write_file(filp);
+		if (err)
+			return err;
+		err = ext4_set_encryption_metadata(inode, &mdata);
+		mnt_drop_write_file(filp);
+		return err;
+#else
+		return -EOPNOTSUPP;
+#endif
+	}
+	case EXT4_IOC_GET_ENCRYPTED_FILENAME: {
+#ifdef CONFIG_EXT4_FS_ENCRYPTION
+		struct ext4_encrypted_metadata mdata;
+		int err = 0;
+
+		if (get_user(mdata.len, (u32 __user *) arg))
+			return -EFAULT;
+		if (mdata.len > sizeof(mdata.metadata))
+			return -EINVAL;
+
+		if (!ext4_encrypted_inode(inode))
+			return -ENOENT;
+		err = ext4_get_encrypted_filename(filp, &mdata);
+		if (err)
+			return err;
+		if (copy_to_user((void __user *)arg, &mdata, sizeof(mdata)))
+			return -EFAULT;
+		return 0;
+#else
+		return -EOPNOTSUPP;
+#endif
+	}
+	case EXT4_IOC_SET_ENCRYPTED_FILENAME: {
+#ifdef CONFIG_EXT4_FS_ENCRYPTION
+		struct ext4_set_encrypted_fname enc_fname;
+		int err = 0;
+
+		if (copy_from_user(&enc_fname,
+				   (struct ext4_set_encrypted_fname __user *)arg,
+				   sizeof(enc_fname)))
+			return -EFAULT;
+		err = mnt_want_write_file(filp);
+		if (err)
+			return err;
+		err = ext4_set_encrypted_filename(inode, &enc_fname);
+		mnt_drop_write_file(filp);
+		return err;
+#else
+		return -EOPNOTSUPP;
+#endif
+	}
 	default:
 		return -ENOTTY;
 	}
@@ -755,6 +839,9 @@ long ext4_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case EXT4_IOC_SET_ENCRYPTION_POLICY:
 	case EXT4_IOC_GET_ENCRYPTION_PWSALT:
 	case EXT4_IOC_GET_ENCRYPTION_POLICY:
+	case EXT4_IOC_GET_ENCRYPTION_METADATA:
+	case EXT4_IOC_SET_ENCRYPTION_METADATA:
+	case EXT4_IOC_GET_ENCRYPTED_FILENAME:
 		break;
 	default:
 		return -ENOIOCTLCMD;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 06c3afc..9e4d983 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -33,6 +33,7 @@
 #include <linux/quotaops.h>
 #include <linux/buffer_head.h>
 #include <linux/bio.h>
+#include <linux/file.h>
 #include "ext4.h"
 #include "ext4_jbd2.h"
 
@@ -2048,24 +2049,16 @@ out_frames:
 }
 
 /*
- *	ext4_add_entry()
- *
- * adds a file entry to the specified directory, using the same
- * semantics as ext4_find_entry(). It returns NULL if it failed.
- *
- * NOTE!! The inode part of 'de' is left at 0 - which means you
- * may not sleep between calling this and putting something into
- * the entry, as someone else might have used it while you slept.
+ * Add a directory entry to a directory, given the filename and the
+ * inode it will point to.
  */
-static int ext4_add_entry(handle_t *handle, struct dentry *dentry,
-			  struct inode *inode)
+static int ext4_add_fname(handle_t *handle, struct inode *dir,
+			  struct ext4_filename *fname, struct inode *inode)
 {
-	struct inode *dir = d_inode(dentry->d_parent);
 	struct buffer_head *bh = NULL;
 	struct ext4_dir_entry_2 *de;
 	struct ext4_dir_entry_tail *t;
 	struct super_block *sb;
-	struct ext4_filename fname;
 	int	retval;
 	int	dx_fallback=0;
 	unsigned blocksize;
@@ -2077,15 +2070,9 @@ static int ext4_add_entry(handle_t *handle, struct dentry *dentry,
 
 	sb = dir->i_sb;
 	blocksize = sb->s_blocksize;
-	if (!dentry->d_name.len)
-		return -EINVAL;
-
-	retval = ext4_fname_setup_filename(dir, &dentry->d_name, 0, &fname);
-	if (retval)
-		return retval;
 
 	if (ext4_has_inline_data(dir)) {
-		retval = ext4_try_add_inline_entry(handle, &fname, dir, inode);
+		retval = ext4_try_add_inline_entry(handle, fname, dir, inode);
 		if (retval < 0)
 			goto out;
 		if (retval == 1) {
@@ -2095,7 +2082,7 @@ static int ext4_add_entry(handle_t *handle, struct dentry *dentry,
 	}
 
 	if (is_dx(dir)) {
-		retval = ext4_dx_add_entry(handle, &fname, dir, inode);
+		retval = ext4_dx_add_entry(handle, fname, dir, inode);
 		if (!retval || (retval != ERR_BAD_DX_DIR))
 			goto out;
 		ext4_clear_inode_flag(dir, EXT4_INODE_INDEX);
@@ -2110,14 +2097,14 @@ static int ext4_add_entry(handle_t *handle, struct dentry *dentry,
 			bh = NULL;
 			goto out;
 		}
-		retval = add_dirent_to_buf(handle, &fname, dir, inode,
+		retval = add_dirent_to_buf(handle, fname, dir, inode,
 					   NULL, bh);
 		if (retval != -ENOSPC)
 			goto out;
 
 		if (blocks == 1 && !dx_fallback &&
 		    ext4_has_feature_dir_index(sb)) {
-			retval = make_indexed_dir(handle, &fname, dir,
+			retval = make_indexed_dir(handle, fname, dir,
 						  inode, bh);
 			bh = NULL; /* make_indexed_dir releases bh */
 			goto out;
@@ -2139,9 +2126,8 @@ static int ext4_add_entry(handle_t *handle, struct dentry *dentry,
 		initialize_dirent_tail(t, blocksize);
 	}
 
-	retval = add_dirent_to_buf(handle, &fname, dir, inode, de, bh);
+	retval = add_dirent_to_buf(handle, fname, dir, inode, de, bh);
 out:
-	ext4_fname_free_filename(&fname);
 	brelse(bh);
 	if (retval == 0)
 		ext4_set_inode_state(inode, EXT4_STATE_NEWENTRY);
@@ -2149,6 +2135,29 @@ out:
 }
 
 /*
+ * Create a directory entry associated with the specified dentry and
+ * inode.
+ */
+static int ext4_add_entry(handle_t *handle, struct dentry *dentry,
+			  struct inode *inode)
+{
+	struct inode *dir = d_inode(dentry->d_parent);
+	struct ext4_filename fname;
+	int	retval;
+
+	if (!dentry->d_name.len)
+		return -EINVAL;
+
+	retval = ext4_fname_setup_filename(dir, &dentry->d_name, 0, &fname);
+	if (retval)
+		return retval;
+
+	retval = ext4_add_fname(handle, dir, &fname, inode);
+	ext4_fname_free_filename(&fname);
+	return retval;
+}
+
+/*
  * Returns 0 for success, or a negative error value
  */
 static int ext4_dx_add_entry(handle_t *handle, struct ext4_filename *fname,
@@ -3858,3 +3867,111 @@ const struct inode_operations ext4_special_inode_operations = {
 	.get_acl	= ext4_get_acl,
 	.set_acl	= ext4_set_acl,
 };
+
+int ext4_get_encrypted_filename(struct file *filp,
+				struct ext4_encrypted_metadata *mdata)
+{
+	struct dentry *dentry = filp->f_path.dentry;
+	struct inode *dir = dentry->d_parent->d_inode;
+	struct buffer_head *bh;
+	struct ext4_dir_entry_2 *de;
+
+	if (!dir || !ext4_encrypted_inode(dir))
+		return -EINVAL;
+
+	if (!inode_owner_or_capable(dir) && !capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	bh = ext4_find_entry(dir, &dentry->d_name, &de, NULL);
+	if (IS_ERR(bh))
+		return PTR_ERR(bh);
+	if (de == NULL)
+		return -ENOENT;
+
+	if (mdata->len < de->name_len)
+		return -ENOSPC;
+	mdata->len = de->name_len;
+	memcpy(mdata->metadata, de->name, de->name_len);
+	return 0;
+}
+
+int ext4_set_encrypted_filename(struct inode *dir,
+				struct ext4_set_encrypted_fname *efn)
+{
+	handle_t *handle = NULL;
+	struct ext4_filename fname;
+	struct fd fd;
+	struct inode *inode;
+	umode_t mode;
+	int retval = 0;
+
+	retval = inode_permission(dir, MAY_WRITE | MAY_EXEC);
+	if (retval)
+		return retval;
+
+	if (efn->len >= sizeof(efn->enc_fname))
+		return -EINVAL;
+
+	fd = fdget(efn->fd);
+	if (!fd.file)
+		return -EBADF;
+	inode = file_inode(fd.file);
+	mode = inode->i_mode;
+
+	retval = -EPERM;
+	if (!S_ISREG(mode))
+		goto out;
+
+	if ((mode & S_ISUID) ||
+	    ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP))) {
+		/*
+		 * root or the inode owner can link even in the case
+		 * of "unsafe" hard link sources.  See
+		 * safe_hardlink_sources() in fs/namei.c
+		 */
+		if (!inode_owner_or_capable(inode) && !capable(CAP_SYS_ADMIN)) {
+			retval = -EACCES;
+			goto out;
+		}
+	}
+
+	retval = inode_permission(inode, MAY_READ | MAY_WRITE);
+	if (!retval && !inode_owner_or_capable(inode) &&
+	    !capable(CAP_SYS_ADMIN))
+		goto out;
+
+	if (!ext4_is_child_context_consistent_with_parent(dir, inode)) {
+		retval = -EPERM;
+		goto out;
+	}
+
+	memset(&fname, 0, sizeof(fname));
+	fname.disk_name.name = efn->enc_fname;
+	fname.disk_name.len = efn->len;
+
+	handle = ext4_journal_start(dir, EXT4_HT_DIR,
+		(EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +
+		 EXT4_INDEX_EXTRA_TRANS_BLOCKS) + 2);
+	if (IS_ERR(handle)) {
+		retval = PTR_ERR(handle);
+		goto out;
+	}
+
+	pr_err("ext4_add_fname\n");
+	retval = ext4_add_fname(handle, dir, &fname, file_inode(fd.file));
+	if (retval)
+		goto out;
+
+	ext4_inc_count(handle, inode);
+	ext4_mark_inode_dirty(handle, inode);
+	if (S_ISDIR(inode->i_mode))
+		ext4_inc_count(handle, dir);
+	ext4_update_dx_flag(dir);
+	ext4_mark_inode_dirty(handle, dir);
+
+out:
+	fdput(fd);
+	if (handle)
+		ext4_journal_stop(handle);
+	return retval;
+}
-- 
2.5.0

