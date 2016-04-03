From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 04/13] fscrypto: return bool instead of int where
	appropriate
Date: Sun,  3 Apr 2016 00:21:55 -0500
Message-ID: <1459660924-2960-5-git-send-email-ebiggers3@gmail.com>
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
 fs/crypto/policy.c       | 24 ++++++++++++------------
 include/linux/fscrypto.h | 12 ++++++------
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index 03a2f50..93244b5 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -12,10 +12,10 @@
 #include <linux/string.h>
 #include <linux/fscrypto.h>
 
-static int inode_has_encryption_context(struct inode *inode)
+static bool inode_has_encryption_context(struct inode *inode)
 {
 	if (!inode->i_sb->s_cop->get_context)
-		return 0;
+		return false;
 	return (inode->i_sb->s_cop->get_context(inode, NULL, 0L) > 0);
 }
 
@@ -23,18 +23,18 @@ static int inode_has_encryption_context(struct inode *inode)
  * check whether the policy is consistent with the encryption context
  * for the inode
  */
-static int is_encryption_context_consistent_with_policy(struct inode *inode,
+static bool is_encryption_context_consistent_with_policy(struct inode *inode,
 				const struct fscrypt_policy *policy)
 {
 	struct fscrypt_context ctx;
 	int res;
 
 	if (!inode->i_sb->s_cop->get_context)
-		return 0;
+		return false;
 
 	res = inode->i_sb->s_cop->get_context(inode, &ctx, sizeof(ctx));
 	if (res != sizeof(ctx))
-		return 0;
+		return false;
 
 	return (memcmp(ctx.master_key_descriptor, policy->master_key_descriptor,
 			FS_KEY_DESCRIPTOR_SIZE) == 0 &&
@@ -139,7 +139,7 @@ int fscrypt_get_policy(struct inode *inode, struct fscrypt_policy *policy)
 }
 EXPORT_SYMBOL(fscrypt_get_policy);
 
-int fscrypt_has_permitted_context(struct inode *parent, struct inode *child)
+bool fscrypt_has_permitted_context(struct inode *parent, struct inode *child)
 {
 	struct fscrypt_info *parent_ci, *child_ci;
 	int res;
@@ -151,22 +151,22 @@ int fscrypt_has_permitted_context(struct inode *parent, struct inode *child)
 
 	/* no restrictions if the parent directory is not encrypted */
 	if (!parent->i_sb->s_cop->is_encrypted(parent))
-		return 1;
+		return true;
 	/* if the child directory is not encrypted, this is always a problem */
 	if (!parent->i_sb->s_cop->is_encrypted(child))
-		return 0;
+		return false;
 	res = fscrypt_load_encryption_info(parent);
 	if (res)
-		return 0;
+		return false;
 	res = fscrypt_load_encryption_info(child);
 	if (res)
-		return 0;
+		return false;
 	parent_ci = parent->i_crypt_info;
 	child_ci = child->i_crypt_info;
 	if (!parent_ci && !child_ci)
-		return 1;
+		return true;
 	if (!parent_ci || !child_ci)
-		return 0;
+		return false;
 
 	return (memcmp(parent_ci->ci_master_key,
 			child_ci->ci_master_key,
diff --git a/include/linux/fscrypto.h b/include/linux/fscrypto.h
index 1bf00a5..9a32d7e 100644
--- a/include/linux/fscrypto.h
+++ b/include/linux/fscrypto.h
@@ -177,7 +177,7 @@ struct fscrypt_operations {
 	int (*get_context)(struct inode *, void *, size_t);
 	int (*prepare_context)(struct inode *);
 	int (*set_context)(struct inode *, const void *, size_t, void *);
-	int (*dummy_context)(struct inode *);
+	bool (*dummy_context)(struct inode *);
 	bool (*is_encrypted)(struct inode *);
 	bool (*empty_dir)(struct inode *);
 	unsigned (*max_namelen)(struct inode *);
@@ -229,12 +229,12 @@ static inline struct page *fscrypt_control_page(struct page *page)
 #endif
 }
 
-static inline int fscrypt_has_encryption_key(struct inode *inode)
+static inline bool fscrypt_has_encryption_key(struct inode *inode)
 {
 #if IS_ENABLED(CONFIG_FS_ENCRYPTION)
 	return (inode->i_crypt_info != NULL);
 #else
-	return 0;
+	return false;
 #endif
 }
 
@@ -275,7 +275,7 @@ extern int fscrypt_zeroout_range(struct inode *, pgoff_t, sector_t,
 /* policy.c */
 extern int fscrypt_set_policy(struct inode *, const struct fscrypt_policy *);
 extern int fscrypt_get_policy(struct inode *, struct fscrypt_policy *);
-extern int fscrypt_has_permitted_context(struct inode *, struct inode *);
+extern bool fscrypt_has_permitted_context(struct inode *, struct inode *);
 extern int fscrypt_inherit_context(struct inode *, struct inode *,
 					void *, bool);
 /* keyinfo.c */
@@ -355,10 +355,10 @@ static inline int fscrypt_notsupp_get_policy(struct inode *i,
 	return -EOPNOTSUPP;
 }
 
-static inline int fscrypt_notsupp_has_permitted_context(struct inode *p,
+static inline bool fscrypt_notsupp_has_permitted_context(struct inode *p,
 				struct inode *i)
 {
-	return 0;
+	return false;
 }
 
 static inline int fscrypt_notsupp_inherit_context(struct inode *p,
-- 
2.7.4


------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785471&iu=/4140
