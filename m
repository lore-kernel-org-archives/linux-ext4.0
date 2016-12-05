From: Eric Biggers <ebiggers@google.com>
Subject: [RFC PATCH 5/5] fscrypt: pass up error codes from ->get_context()
Date: Mon,  5 Dec 2016 11:12:48 -0800
Message-ID: <1480965168-38747-6-git-send-email-ebiggers@google.com>
References: <1480965168-38747-1-git-send-email-ebiggers@google.com>
Cc: linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Richard Weinberger <richard@nod.at>,
        David Gstir <david@sigma-star.at>,
        Eric Biggers <ebiggers@google.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1480965168-38747-1-git-send-email-ebiggers@google.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

It was possible for the ->get_context() operation to fail with a
specific error code, which was then not returned to the caller of
FS_IOC_SET_ENCRYPTION_POLICY or FS_IOC_GET_ENCRYPTION_POLICY.  Make sure
to pass through these error codes.  Also reorganize the code so that
->get_context() only needs to be called one time when setting an
encryption policy, and handle contexts of unrecognized sizes more
appropriately.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/policy.c | 54 +++++++++++++++++++++++-------------------------------
 1 file changed, 23 insertions(+), 31 deletions(-)

diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index a9f11b3..d64ec95 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -13,37 +13,20 @@
 #include <linux/fscrypto.h>
 #include <linux/mount.h>
 
-static int inode_has_encryption_context(struct inode *inode)
-{
-	if (!inode->i_sb->s_cop->get_context)
-		return 0;
-	return (inode->i_sb->s_cop->get_context(inode, NULL, 0L) > 0);
-}
-
 /*
- * check whether the policy is consistent with the encryption context
- * for the inode
+ * check whether an encryption policy is consistent with an encryption context
  */
-static int is_encryption_context_consistent_with_policy(struct inode *inode,
+static bool is_encryption_context_consistent_with_policy(
+				const struct fscrypt_context *ctx,
 				const struct fscrypt_policy *policy)
 {
-	struct fscrypt_context ctx;
-	int res;
-
-	if (!inode->i_sb->s_cop->get_context)
-		return 0;
-
-	res = inode->i_sb->s_cop->get_context(inode, &ctx, sizeof(ctx));
-	if (res != sizeof(ctx))
-		return 0;
-
-	return (memcmp(ctx.master_key_descriptor, policy->master_key_descriptor,
-			FS_KEY_DESCRIPTOR_SIZE) == 0 &&
-			(ctx.flags == policy->flags) &&
-			(ctx.contents_encryption_mode ==
-			 policy->contents_encryption_mode) &&
-			(ctx.filenames_encryption_mode ==
-			 policy->filenames_encryption_mode));
+	return memcmp(ctx->master_key_descriptor, policy->master_key_descriptor,
+		      FS_KEY_DESCRIPTOR_SIZE) == 0 &&
+		(ctx->flags == policy->flags) &&
+		(ctx->contents_encryption_mode ==
+		 policy->contents_encryption_mode) &&
+		(ctx->filenames_encryption_mode ==
+		 policy->filenames_encryption_mode);
 }
 
 static int create_encryption_context_from_policy(struct inode *inode,
@@ -90,6 +73,7 @@ int fscrypt_ioctl_set_policy(struct file *filp, const void __user *arg)
 	struct fscrypt_policy policy;
 	struct inode *inode = file_inode(filp);
 	int ret;
+	struct fscrypt_context ctx;
 
 	if (copy_from_user(&policy, arg, sizeof(policy)))
 		return -EFAULT;
@@ -106,7 +90,8 @@ int fscrypt_ioctl_set_policy(struct file *filp, const void __user *arg)
 
 	inode_lock(inode);
 
-	if (!inode_has_encryption_context(inode)) {
+	ret = inode->i_sb->s_cop->get_context(inode, &ctx, sizeof(ctx));
+	if (ret == -ENODATA) {
 		if (!S_ISDIR(inode->i_mode))
 			ret = -ENOTDIR;
 		else if (!inode->i_sb->s_cop->empty_dir)
@@ -116,8 +101,13 @@ int fscrypt_ioctl_set_policy(struct file *filp, const void __user *arg)
 		else
 			ret = create_encryption_context_from_policy(inode,
 								    &policy);
-	} else if (!is_encryption_context_consistent_with_policy(inode,
-								 &policy)) {
+	} else if (ret == sizeof(ctx) &&
+		   is_encryption_context_consistent_with_policy(&ctx,
+								&policy)) {
+		/* The file already uses the same encryption policy. */
+		ret = 0;
+	} else if (ret >= 0 || ret == -ERANGE) {
+		/* The file already uses a different encryption policy. */
 		ret = -EEXIST;
 	}
 
@@ -140,8 +130,10 @@ int fscrypt_ioctl_get_policy(struct file *filp, void __user *arg)
 		return -ENODATA;
 
 	res = inode->i_sb->s_cop->get_context(inode, &ctx, sizeof(ctx));
+	if (res < 0 && res != -ERANGE)
+		return res;
 	if (res != sizeof(ctx))
-		return -ENODATA;
+		return -EINVAL;
 	if (ctx.format != FS_ENCRYPTION_CONTEXT_FORMAT_V1)
 		return -EINVAL;
 
-- 
2.8.0.rc3.226.g39d4020

