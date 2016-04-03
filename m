From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 13/13] fscrypto: improve error handling in
	fscrypt_set_policy()
Date: Sun,  3 Apr 2016 00:22:04 -0500
Message-ID: <1459660924-2960-14-git-send-email-ebiggers3@gmail.com>
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

In some cases, the previous code did not correctly propagate errors to
the caller.  Also, only one call to ->get_context() is required.

Signed-off-by: Eric Biggers <ebiggers3@gmail.com>
---
 fs/crypto/policy.c | 64 +++++++++++++++++++++++++-----------------------------
 1 file changed, 29 insertions(+), 35 deletions(-)

diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index 6a767e6..83421fe 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -13,37 +13,17 @@
 #include <linux/fscrypto.h>
 #include <linux/mount.h>
 
-static bool inode_has_encryption_context(struct inode *inode)
-{
-	if (!inode->i_sb->s_cop->get_context)
-		return false;
-	return (inode->i_sb->s_cop->get_context(inode, NULL, 0L) > 0);
-}
-
-/*
- * check whether the policy is consistent with the encryption context
- * for the inode
- */
-static bool is_encryption_context_consistent_with_policy(struct inode *inode,
+static bool is_encryption_context_consistent_with_policy(
+				const struct fscrypt_context *ctx,
 				const struct fscrypt_policy *policy)
 {
-	struct fscrypt_context ctx;
-	int res;
-
-	if (!inode->i_sb->s_cop->get_context)
-		return false;
-
-	res = inode->i_sb->s_cop->get_context(inode, &ctx, sizeof(ctx));
-	if (res != sizeof(ctx))
-		return false;
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
@@ -96,6 +76,7 @@ static int create_encryption_context_from_policy(struct inode *inode,
 int fscrypt_set_policy(struct file *file, const struct fscrypt_policy *policy)
 {
 	struct inode *inode = file_inode(file);
+	struct fscrypt_context existing;
 	int ret;
 
 	if (!inode_owner_or_capable(inode))
@@ -110,7 +91,25 @@ int fscrypt_set_policy(struct file *file, const struct fscrypt_policy *policy)
 
 	inode_lock(inode);
 
-	if (!inode_has_encryption_context(inode)) {
+	ret = -ENODATA;
+	if (inode->i_sb->s_cop->get_context) {
+		ret = inode->i_sb->s_cop->get_context(inode, &existing,
+						      sizeof(existing));
+	}
+	if (ret != -ENODATA) {
+		/* An existing policy cannot be changed.  However, an attempt to
+		 * set an identical policy will succeed. */
+		if (ret == sizeof(existing) &&
+		    is_encryption_context_consistent_with_policy(&existing,
+								 policy)) {
+			ret = 0;
+		} else if (ret >= 0 || ret == -ERANGE) {
+			printk(KERN_WARNING
+			       "%s: Policy inconsistent with encryption context\n",
+			       __func__);
+			ret = -EINVAL;
+		}
+	} else {
 		/* A new policy may only be set on an empty directory or an
 		 * empty regular file. */
 		ret = -EINVAL;
@@ -130,11 +129,6 @@ int fscrypt_set_policy(struct file *file, const struct fscrypt_policy *policy)
 			ret = create_encryption_context_from_policy(inode,
 								    policy);
 		}
-	} else if (!is_encryption_context_consistent_with_policy(inode, policy)) {
-		printk(KERN_WARNING
-		       "%s: Policy inconsistent with encryption context\n",
-		       __func__);
-		ret = -EINVAL;
 	}
 	inode_unlock(inode);
 	mnt_drop_write_file(file);
-- 
2.7.4


------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785471&iu=/4140
