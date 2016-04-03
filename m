From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 12/13] fscrypto: require write access to mount to
	set encryption policy
Date: Sun,  3 Apr 2016 00:22:03 -0500
Message-ID: <1459660924-2960-13-git-send-email-ebiggers3@gmail.com>
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

Since setting an encryption policy requires writing data to the
filesystem, it should be guarded by mnt_want_write/mnt_drop_write.
Otherwise, a user could cause a write to a readonly or frozen filesystem.

Signed-off-by: Eric Biggers <ebiggers3@gmail.com>
---
 fs/crypto/policy.c       | 11 +++++++++--
 fs/f2fs/file.c           |  2 +-
 include/linux/fscrypto.h |  4 ++--
 3 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index 3f5c275..6a767e6 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -11,6 +11,7 @@
 #include <linux/random.h>
 #include <linux/string.h>
 #include <linux/fscrypto.h>
+#include <linux/mount.h>
 
 static bool inode_has_encryption_context(struct inode *inode)
 {
@@ -92,9 +93,10 @@ static int create_encryption_context_from_policy(struct inode *inode,
 	return inode->i_sb->s_cop->set_context(inode, &ctx, sizeof(ctx), NULL);
 }
 
-int fscrypt_set_policy(struct inode *inode, const struct fscrypt_policy *policy)
+int fscrypt_set_policy(struct file *file, const struct fscrypt_policy *policy)
 {
-	int ret = 0;
+	struct inode *inode = file_inode(file);
+	int ret;
 
 	if (!inode_owner_or_capable(inode))
 		return -EACCES;
@@ -102,6 +104,10 @@ int fscrypt_set_policy(struct inode *inode, const struct fscrypt_policy *policy)
 	if (policy->version != 0)
 		return -EINVAL;
 
+	ret = mnt_want_write_file(file);
+	if (ret)
+		return ret;
+
 	inode_lock(inode);
 
 	if (!inode_has_encryption_context(inode)) {
@@ -131,6 +137,7 @@ int fscrypt_set_policy(struct inode *inode, const struct fscrypt_policy *policy)
 		ret = -EINVAL;
 	}
 	inode_unlock(inode);
+	mnt_drop_write_file(file);
 	return ret;
 }
 EXPORT_SYMBOL(fscrypt_set_policy);
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index cf691ae..d4837280 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1542,7 +1542,7 @@ static int f2fs_ioc_set_encryption_policy(struct file *filp, unsigned long arg)
 		return -EFAULT;
 
 	f2fs_update_time(F2FS_I_SB(inode), REQ_TIME);
-	return fscrypt_set_policy(inode, &policy);
+	return fscrypt_set_policy(filp, &policy);
 }
 
 static int f2fs_ioc_get_encryption_policy(struct file *filp, unsigned long arg)
diff --git a/include/linux/fscrypto.h b/include/linux/fscrypto.h
index f29dc8c..130bf23 100644
--- a/include/linux/fscrypto.h
+++ b/include/linux/fscrypto.h
@@ -314,7 +314,7 @@ extern void fscrypt_restore_control_page(struct page *);
 extern int fscrypt_zeroout_range(struct inode *, pgoff_t, sector_t,
 						unsigned int);
 /* policy.c */
-extern int fscrypt_set_policy(struct inode *, const struct fscrypt_policy *);
+extern int fscrypt_set_policy(struct file *, const struct fscrypt_policy *);
 extern int fscrypt_get_policy(struct inode *, struct fscrypt_policy *);
 extern bool fscrypt_has_permitted_context(struct inode *, struct inode *);
 extern int fscrypt_inherit_context(struct inode *, struct inode *,
@@ -384,7 +384,7 @@ static inline int fscrypt_notsupp_zeroout_range(struct inode *i, pgoff_t p,
 }
 
 /* policy.c */
-static inline int fscrypt_notsupp_set_policy(struct inode *i,
+static inline int fscrypt_notsupp_set_policy(struct file *f,
 				const struct fscrypt_policy *p)
 {
 	return -EOPNOTSUPP;
-- 
2.7.4


------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785471&iu=/4140
