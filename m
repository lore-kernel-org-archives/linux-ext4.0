From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH RFC v2 2/2] ext4 crypto: add ioctls to allow backup of encryption metadata
Date: Tue,  8 Dec 2015 17:02:54 -0500
Message-ID: <1449612174-32127-2-git-send-email-tytso@mit.edu>
References: <1449612174-32127-1-git-send-email-tytso@mit.edu>
Cc: mhalcrow@google.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46537 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781AbbLHWDH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Dec 2015 17:03:07 -0500
In-Reply-To: <1449612174-32127-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add new ioctls which allow for the metadata of encrypted files (the
filename and the crypto policy) to be backed up.  We can restore the
crypto policy, but for now we can't restore the encrypted filename
because messing with encrypted directories directly while bypassing
the VFS would get fairly tricky/nasty.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/crypto_key.c  | 57 ++++++++++++++++++++++++++++++++++++++++++++-
 fs/ext4/ext4.h        |  9 ++++++++
 fs/ext4/ext4_crypto.h |  8 +++++++
 fs/ext4/ioctl.c       | 64 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/namei.c       | 22 ++++++++++++++++++
 5 files changed, 159 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/crypto_key.c b/fs/ext4/crypto_key.c
index c5882b3..039b22d 100644
--- a/fs/ext4/crypto_key.c
+++ b/fs/ext4/crypto_key.c
@@ -14,7 +14,7 @@
 #include <linux/scatterlist.h>
 #include <uapi/linux/keyctl.h>
 
-#include "ext4.h"
+#include "ext4_jbd2.h"
 #include "xattr.h"
 
 static void derive_crypt_complete(struct crypto_async_request *req, int rc)
@@ -270,3 +270,58 @@ int ext4_has_encryption_key(struct inode *inode)
 
 	return (ei->i_crypt_info != NULL);
 }
+
+int ext4_get_encryption_metadata(struct inode *inode,
+				 struct ext4_encrypted_metadata *mdata)
+{
+	int res;
+
+	if (mdata->len < sizeof(struct ext4_encryption_context))
+		return -EINVAL;
+
+	res = ext4_xattr_get(inode, EXT4_XATTR_INDEX_ENCRYPTION,
+			     EXT4_XATTR_NAME_ENCRYPTION_CONTEXT,
+			     &mdata->metadata, mdata->len);
+	if (res < 0)
+		return res;
+	mdata->len = res;
+	return 0;
+}
+
+int ext4_set_encryption_metadata(struct inode *inode,
+				 struct ext4_encrypted_metadata *mdata)
+{
+	struct ext4_encryption_context *ctx;
+	handle_t *handle;
+	int res;
+
+	if (mdata->len != sizeof(struct ext4_encryption_context))
+		return -EINVAL;
+	ctx = (struct ext4_encryption_context *) &mdata->metadata;
+	if (ctx->format != EXT4_ENCRYPTION_CONTEXT_FORMAT_V1)
+		return -EINVAL;
+
+	res = ext4_convert_inline_data(inode);
+	if (res)
+		return res;
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
+	res = ext4_mark_inode_dirty(handle, inode);
+	if (res)
+		EXT4_ERROR_INODE(inode, "Failed to mark inode dirty");
+	else
+		res = ext4_get_encryption_info(inode);
+errout:
+	ext4_journal_stop(handle);
+	return res;
+}
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 44278aa7..d8b2fb5 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -617,6 +617,9 @@ enum {
 #define EXT4_IOC_SET_ENCRYPTION_POLICY	_IOR('f', 19, struct ext4_encryption_policy)
 #define EXT4_IOC_GET_ENCRYPTION_PWSALT	_IOW('f', 20, __u8[16])
 #define EXT4_IOC_GET_ENCRYPTION_POLICY	_IOW('f', 21, struct ext4_encryption_policy)
+#define EXT4_IOC_GET_ENCRYPTION_METADATA _IOW('f', 22, struct ext4_encrypted_metadata)
+#define EXT4_IOC_SET_ENCRYPTION_METADATA _IOW('f', 23, struct ext4_encrypted_metadata)
+#define EXT4_IOC_GET_ENCRYPTED_FILENAME	_IOW('f', 24, struct ext4_encrypted_metadata)
 
 #if defined(__KERNEL__) && defined(CONFIG_COMPAT)
 /*
@@ -2311,6 +2314,10 @@ static inline void ext4_fname_free_filename(struct ext4_filename *fname) { }
 void ext4_free_crypt_info(struct ext4_crypt_info *ci);
 void ext4_free_encryption_info(struct inode *inode, struct ext4_crypt_info *ci);
 int _ext4_get_encryption_info(struct inode *inode);
+int ext4_set_encryption_metadata(struct inode *inode,
+				 struct ext4_encrypted_metadata *mdata);
+int ext4_get_encryption_metadata(struct inode *inode,
+				 struct ext4_encrypted_metadata *mdata);
 
 #ifdef CONFIG_EXT4_FS_ENCRYPTION
 int ext4_has_encryption_key(struct inode *inode);
@@ -2546,6 +2553,8 @@ extern int ext4_generic_delete_entry(handle_t *handle,
 				     int buf_size,
 				     int csum_size);
 extern int ext4_empty_dir(struct inode *inode);
+extern int ext4_get_encrypted_filename(struct file *filp,
+				       struct ext4_encrypted_metadata *mdata);
 
 /* resize.c */
 extern int ext4_group_add(struct super_block *sb,
diff --git a/fs/ext4/ext4_crypto.h b/fs/ext4/ext4_crypto.h
index ac7d4e8..f267cd3 100644
--- a/fs/ext4/ext4_crypto.h
+++ b/fs/ext4/ext4_crypto.h
@@ -156,4 +156,12 @@ static inline u32 encrypted_symlink_data_len(u32 l)
 	return (l + sizeof(struct ext4_encrypted_symlink_data) - 1);
 }
 
+/**
+ * Structure used for communicating encrypted metadata with userspace
+ */
+struct ext4_encrypted_metadata {
+	u32 len;
+	char metadata[288];
+};
+
 #endif	/* _EXT4_CRYPTO_H */
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 5e872fd..afb51f5 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -689,6 +689,67 @@ encryption_policy_out:
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
+		err = ext4_set_encryption_metadata(inode, &mdata);
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
 	default:
 		return -ENOTTY;
 	}
@@ -755,6 +816,9 @@ long ext4_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
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
index a969ab3..81b43ca 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3861,3 +3861,25 @@ const struct inode_operations ext4_special_inode_operations = {
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
+	bh = ext4_find_entry(dir, &dentry->d_name, &de, NULL);
+	if (IS_ERR(bh))
+		return PTR_ERR(bh);
+
+	if (mdata->len < de->name_len)
+		return -ENOSPC;
+	mdata->len = de->name_len;
+	memcpy(mdata->metadata, de->name, de->name_len);
+	return 0;
+}
-- 
2.5.0

