From: Eric Biggers <ebiggers@google.com>
Subject: [PATCH] fscrypto: move ioctl processing more fully into
	common code
Date: Mon, 17 Oct 2016 09:54:06 -0700
Message-ID: <1476723246-47420-1-git-send-email-ebiggers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: jaegeuk@kernel.org, linux-ext4@vger.kernel.org, tytso@mit.edu,
	Eric Biggers <ebiggers@google.com>, linux-f2fs-devel@lists.sourceforge.net
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

Multiple bugs were recently fixed in the "set encryption policy" ioctl.
To make it clear that fscrypt_process_policy() and fscrypt_get_policy()
implement ioctls and therefore their implementations must take standard
security and correctness precautions, rename them to
fscrypt_ioctl_set_policy() and fscrypt_ioctl_get_policy().  Make the
latter take in a struct file * to make it consistent with the former.

In addition, make the common functions do the copies to and from
userspace rather than duplicating this code within each filesystem, and
memset the policy to 0 to make it clear there is no stack leak.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/policy.c       | 36 +++++++++++++++++++++++-------------
 fs/ext4/ext4.h           |  4 ++--
 fs/ext4/ioctl.c          | 34 +++++-----------------------------
 fs/f2fs/f2fs.h           |  4 ++--
 fs/f2fs/file.c           | 19 ++-----------------
 include/linux/fscrypto.h | 12 ++++++------
 6 files changed, 40 insertions(+), 69 deletions(-)

diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index 6865663..fa30618 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -93,16 +93,19 @@ static int create_encryption_context_from_policy(struct inode *inode,
 	return inode->i_sb->s_cop->set_context(inode, &ctx, sizeof(ctx), NULL);
 }
 
-int fscrypt_process_policy(struct file *filp,
-				const struct fscrypt_policy *policy)
+int fscrypt_ioctl_set_policy(struct file *filp, const void __user *arg)
 {
+	struct fscrypt_policy policy;
 	struct inode *inode = file_inode(filp);
 	int ret;
 
+	if (copy_from_user(&policy, arg, sizeof(policy)))
+		return -EFAULT;
+
 	if (!inode_owner_or_capable(inode))
 		return -EACCES;
 
-	if (policy->version != 0)
+	if (policy.version != 0)
 		return -EINVAL;
 
 	ret = mnt_want_write_file(filp);
@@ -120,9 +123,9 @@ int fscrypt_process_policy(struct file *filp,
 			ret = -ENOTEMPTY;
 		else
 			ret = create_encryption_context_from_policy(inode,
-								    policy);
+								    &policy);
 	} else if (!is_encryption_context_consistent_with_policy(inode,
-								 policy)) {
+								 &policy)) {
 		printk(KERN_WARNING
 		       "%s: Policy inconsistent with encryption context\n",
 		       __func__);
@@ -134,11 +137,13 @@ int fscrypt_process_policy(struct file *filp,
 	mnt_drop_write_file(filp);
 	return ret;
 }
-EXPORT_SYMBOL(fscrypt_process_policy);
+EXPORT_SYMBOL(fscrypt_ioctl_set_policy);
 
-int fscrypt_get_policy(struct inode *inode, struct fscrypt_policy *policy)
+int fscrypt_ioctl_get_policy(struct file *filp, void __user *arg)
 {
+	struct inode *inode = file_inode(filp);
 	struct fscrypt_context ctx;
+	struct fscrypt_policy policy;
 	int res;
 
 	if (!inode->i_sb->s_cop->get_context ||
@@ -151,15 +156,20 @@ int fscrypt_get_policy(struct inode *inode, struct fscrypt_policy *policy)
 	if (ctx.format != FS_ENCRYPTION_CONTEXT_FORMAT_V1)
 		return -EINVAL;
 
-	policy->version = 0;
-	policy->contents_encryption_mode = ctx.contents_encryption_mode;
-	policy->filenames_encryption_mode = ctx.filenames_encryption_mode;
-	policy->flags = ctx.flags;
-	memcpy(&policy->master_key_descriptor, ctx.master_key_descriptor,
+	memset(&policy, 0, sizeof(policy));
+
+	policy.version = 0;
+	policy.contents_encryption_mode = ctx.contents_encryption_mode;
+	policy.filenames_encryption_mode = ctx.filenames_encryption_mode;
+	policy.flags = ctx.flags;
+	memcpy(policy.master_key_descriptor, ctx.master_key_descriptor,
 				FS_KEY_DESCRIPTOR_SIZE);
+
+	if (copy_to_user(arg, &policy, sizeof(policy)))
+		return -EFAULT;
 	return 0;
 }
-EXPORT_SYMBOL(fscrypt_get_policy);
+EXPORT_SYMBOL(fscrypt_ioctl_get_policy);
 
 int fscrypt_has_permitted_context(struct inode *parent, struct inode *child)
 {
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 282a51b..bd8bc3b 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2338,8 +2338,8 @@ static inline void ext4_fname_free_filename(struct ext4_filename *fname) { }
 #define fscrypt_pullback_bio_page	fscrypt_notsupp_pullback_bio_page
 #define fscrypt_restore_control_page	fscrypt_notsupp_restore_control_page
 #define fscrypt_zeroout_range		fscrypt_notsupp_zeroout_range
-#define fscrypt_process_policy		fscrypt_notsupp_process_policy
-#define fscrypt_get_policy		fscrypt_notsupp_get_policy
+#define fscrypt_ioctl_set_policy	fscrypt_notsupp_ioctl_set_policy
+#define fscrypt_ioctl_get_policy	fscrypt_notsupp_ioctl_get_policy
 #define fscrypt_has_permitted_context	fscrypt_notsupp_has_permitted_context
 #define fscrypt_inherit_context		fscrypt_notsupp_inherit_context
 #define fscrypt_get_encryption_info	fscrypt_notsupp_get_encryption_info
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index bf5ae8e..7008386 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -765,22 +765,12 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	}
 	case EXT4_IOC_PRECACHE_EXTENTS:
 		return ext4_ext_precache(inode);
-	case EXT4_IOC_SET_ENCRYPTION_POLICY: {
-#ifdef CONFIG_EXT4_FS_ENCRYPTION
-		struct fscrypt_policy policy;
 
+	case EXT4_IOC_SET_ENCRYPTION_POLICY:
 		if (!ext4_has_feature_encrypt(sb))
 			return -EOPNOTSUPP;
+		return fscrypt_ioctl_set_policy(filp, (const void __user *)arg);
 
-		if (copy_from_user(&policy,
-				   (struct fscrypt_policy __user *)arg,
-				   sizeof(policy)))
-			return -EFAULT;
-		return fscrypt_process_policy(filp, &policy);
-#else
-		return -EOPNOTSUPP;
-#endif
-	}
 	case EXT4_IOC_GET_ENCRYPTION_PWSALT: {
 		int err, err2;
 		struct ext4_sb_info *sbi = EXT4_SB(sb);
@@ -817,23 +807,9 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			return -EFAULT;
 		return 0;
 	}
-	case EXT4_IOC_GET_ENCRYPTION_POLICY: {
-#ifdef CONFIG_EXT4_FS_ENCRYPTION
-		struct fscrypt_policy policy;
-		int err = 0;
-
-		if (!ext4_encrypted_inode(inode))
-			return -ENOENT;
-		err = fscrypt_get_policy(inode, &policy);
-		if (err)
-			return err;
-		if (copy_to_user((void __user *)arg, &policy, sizeof(policy)))
-			return -EFAULT;
-		return 0;
-#else
-		return -EOPNOTSUPP;
-#endif
-	}
+	case EXT4_IOC_GET_ENCRYPTION_POLICY:
+		return fscrypt_ioctl_get_policy(filp, (void __user *)arg);
+
 	case EXT4_IOC_FSGETXATTR:
 	{
 		struct fsxattr fa;
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 9e8de18..8e94b7b 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -2453,8 +2453,8 @@ static inline bool f2fs_may_encrypt(struct inode *inode)
 #define fscrypt_pullback_bio_page	fscrypt_notsupp_pullback_bio_page
 #define fscrypt_restore_control_page	fscrypt_notsupp_restore_control_page
 #define fscrypt_zeroout_range		fscrypt_notsupp_zeroout_range
-#define fscrypt_process_policy		fscrypt_notsupp_process_policy
-#define fscrypt_get_policy		fscrypt_notsupp_get_policy
+#define fscrypt_ioctl_set_policy	fscrypt_notsupp_ioctl_set_policy
+#define fscrypt_ioctl_get_policy	fscrypt_notsupp_ioctl_get_policy
 #define fscrypt_has_permitted_context	fscrypt_notsupp_has_permitted_context
 #define fscrypt_inherit_context		fscrypt_notsupp_inherit_context
 #define fscrypt_get_encryption_info	fscrypt_notsupp_get_encryption_info
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index c786507..f0c83f7 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1752,31 +1752,16 @@ static bool uuid_is_nonzero(__u8 u[16])
 
 static int f2fs_ioc_set_encryption_policy(struct file *filp, unsigned long arg)
 {
-	struct fscrypt_policy policy;
 	struct inode *inode = file_inode(filp);
 
-	if (copy_from_user(&policy, (struct fscrypt_policy __user *)arg,
-							sizeof(policy)))
-		return -EFAULT;
-
 	f2fs_update_time(F2FS_I_SB(inode), REQ_TIME);
 
-	return fscrypt_process_policy(filp, &policy);
+	return fscrypt_ioctl_set_policy(filp, (const void __user *)arg);
 }
 
 static int f2fs_ioc_get_encryption_policy(struct file *filp, unsigned long arg)
 {
-	struct fscrypt_policy policy;
-	struct inode *inode = file_inode(filp);
-	int err;
-
-	err = fscrypt_get_policy(inode, &policy);
-	if (err)
-		return err;
-
-	if (copy_to_user((struct fscrypt_policy __user *)arg, &policy, sizeof(policy)))
-		return -EFAULT;
-	return 0;
+	return fscrypt_ioctl_get_policy(filp, (void __user *)arg);
 }
 
 static int f2fs_ioc_get_encryption_pwsalt(struct file *filp, unsigned long arg)
diff --git a/include/linux/fscrypto.h b/include/linux/fscrypto.h
index ff8b11b..e6e53a3 100644
--- a/include/linux/fscrypto.h
+++ b/include/linux/fscrypto.h
@@ -250,8 +250,8 @@ extern void fscrypt_restore_control_page(struct page *);
 extern int fscrypt_zeroout_range(struct inode *, pgoff_t, sector_t,
 						unsigned int);
 /* policy.c */
-extern int fscrypt_process_policy(struct file *, const struct fscrypt_policy *);
-extern int fscrypt_get_policy(struct inode *, struct fscrypt_policy *);
+extern int fscrypt_ioctl_set_policy(struct file *, const void __user *);
+extern int fscrypt_ioctl_get_policy(struct file *, void __user *);
 extern int fscrypt_has_permitted_context(struct inode *, struct inode *);
 extern int fscrypt_inherit_context(struct inode *, struct inode *,
 					void *, bool);
@@ -320,14 +320,14 @@ static inline int fscrypt_notsupp_zeroout_range(struct inode *i, pgoff_t p,
 }
 
 /* policy.c */
-static inline int fscrypt_notsupp_process_policy(struct file *f,
-				const struct fscrypt_policy *p)
+static inline int fscrypt_notsupp_ioctl_set_policy(struct file *f,
+				const void __user *arg)
 {
 	return -EOPNOTSUPP;
 }
 
-static inline int fscrypt_notsupp_get_policy(struct inode *i,
-				struct fscrypt_policy *p)
+static inline int fscrypt_notsupp_ioctl_get_policy(struct file *f,
+				void __user *arg)
 {
 	return -EOPNOTSUPP;
 }
-- 
2.8.0.rc3.226.g39d4020


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
