From: Eric Biggers <ebiggers@google.com>
Subject: [PATCH] fscrypto: require write access to mount to set
	encryption policy
Date: Thu,  8 Sep 2016 14:20:38 -0700
Message-ID: <1473369638-19995-1-git-send-email-ebiggers@google.com>
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

[To apply cleanly, my other two patches must be applied before this one]

Since setting an encryption policy requires writing metadata to the
filesystem, it should be guarded by mnt_want_write/mnt_drop_write.
Otherwise, a user could cause a write to a frozen or readonly
filesystem.  This was handled correctly by f2fs but not by ext4.  Make
fscrypt_process_policy() handle it rather than relying on the filesystem
to get it right.

Signed-off-by: Eric Biggers <ebiggers@google.com>
Cc: stable@vger.kernel.org # 4.1+; check fs/{ext4,f2fs}
---
 fs/crypto/policy.c       | 36 +++++++++++++++++++++++-------------
 fs/ext4/ioctl.c          |  2 +-
 fs/f2fs/file.c           |  9 +--------
 include/linux/fscrypto.h |  5 ++---
 4 files changed, 27 insertions(+), 25 deletions(-)

diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index f96547f..e2ada8f 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -11,6 +11,7 @@
 #include <linux/random.h>
 #include <linux/string.h>
 #include <linux/fscrypto.h>
+#include <linux/mount.h>
 
 static int inode_has_encryption_context(struct inode *inode)
 {
@@ -92,31 +93,40 @@ static int create_encryption_context_from_policy(struct inode *inode,
 	return inode->i_sb->s_cop->set_context(inode, &ctx, sizeof(ctx), NULL);
 }
 
-int fscrypt_process_policy(struct inode *inode,
+int fscrypt_process_policy(struct file *filp,
 				const struct fscrypt_policy *policy)
 {
+	struct inode *inode = file_inode(filp);
+	int ret;
+
 	if (!inode_owner_or_capable(inode))
 		return -EACCES;
 
 	if (policy->version != 0)
 		return -EINVAL;
 
+	ret = mnt_want_write_file(filp);
+	if (ret)
+		return ret;
+
 	if (!inode_has_encryption_context(inode)) {
 		if (!S_ISDIR(inode->i_mode))
-			return -EINVAL;
-		if (!inode->i_sb->s_cop->empty_dir)
-			return -EOPNOTSUPP;
-		if (!inode->i_sb->s_cop->empty_dir(inode))
-			return -ENOTEMPTY;
-		return create_encryption_context_from_policy(inode, policy);
+			ret = -EINVAL;
+		else if (!inode->i_sb->s_cop->empty_dir)
+			ret = -EOPNOTSUPP;
+		else if (!inode->i_sb->s_cop->empty_dir(inode))
+			ret = -ENOTEMPTY;
+		else
+			ret = create_encryption_context_from_policy(inode, policy);
+	} else if (!is_encryption_context_consistent_with_policy(inode, policy)) {
+		printk(KERN_WARNING
+		       "%s: Policy inconsistent with encryption context\n",
+		       __func__);
+		ret = -EINVAL;
 	}
 
-	if (is_encryption_context_consistent_with_policy(inode, policy))
-		return 0;
-
-	printk(KERN_WARNING "%s: Policy inconsistent with encryption context\n",
-	       __func__);
-	return -EINVAL;
+	mnt_drop_write_file(filp);
+	return ret;
 }
 EXPORT_SYMBOL(fscrypt_process_policy);
 
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 10686fd..1bb7df5 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -776,7 +776,7 @@ resizefs_out:
 				   (struct fscrypt_policy __user *)arg,
 				   sizeof(policy)))
 			return -EFAULT;
-		return fscrypt_process_policy(inode, &policy);
+		return fscrypt_process_policy(filp, &policy);
 #else
 		return -EOPNOTSUPP;
 #endif
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 47abb96..28f4f4c 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1757,21 +1757,14 @@ static int f2fs_ioc_set_encryption_policy(struct file *filp, unsigned long arg)
 {
 	struct fscrypt_policy policy;
 	struct inode *inode = file_inode(filp);
-	int ret;
 
 	if (copy_from_user(&policy, (struct fscrypt_policy __user *)arg,
 							sizeof(policy)))
 		return -EFAULT;
 
-	ret = mnt_want_write_file(filp);
-	if (ret)
-		return ret;
-
 	f2fs_update_time(F2FS_I_SB(inode), REQ_TIME);
-	ret = fscrypt_process_policy(inode, &policy);
 
-	mnt_drop_write_file(filp);
-	return ret;
+	return fscrypt_process_policy(filp, &policy);
 }
 
 static int f2fs_ioc_get_encryption_policy(struct file *filp, unsigned long arg)
diff --git a/include/linux/fscrypto.h b/include/linux/fscrypto.h
index cfa6cde..76cff18 100644
--- a/include/linux/fscrypto.h
+++ b/include/linux/fscrypto.h
@@ -274,8 +274,7 @@ extern void fscrypt_restore_control_page(struct page *);
 extern int fscrypt_zeroout_range(struct inode *, pgoff_t, sector_t,
 						unsigned int);
 /* policy.c */
-extern int fscrypt_process_policy(struct inode *,
-					const struct fscrypt_policy *);
+extern int fscrypt_process_policy(struct file *, const struct fscrypt_policy *);
 extern int fscrypt_get_policy(struct inode *, struct fscrypt_policy *);
 extern int fscrypt_has_permitted_context(struct inode *, struct inode *);
 extern int fscrypt_inherit_context(struct inode *, struct inode *,
@@ -345,7 +344,7 @@ static inline int fscrypt_notsupp_zeroout_range(struct inode *i, pgoff_t p,
 }
 
 /* policy.c */
-static inline int fscrypt_notsupp_process_policy(struct inode *i,
+static inline int fscrypt_notsupp_process_policy(struct file *f,
 				const struct fscrypt_policy *p)
 {
 	return -EOPNOTSUPP;
-- 
2.8.0.rc3.226.g39d4020


------------------------------------------------------------------------------
