From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 1/3] fscrypt: fix loophole in
	one-encryption-policy-per-tree enforcement
Date: Thu, 15 Dec 2016 11:19:42 -0800
Message-ID: <1481829584-50218-1-git-send-email-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: David Gstir <david@sigma-star.at>, "Theodore Y . Ts'o" <tytso@mit.edu>,
	Eric Biggers <ebiggers@google.com>, Richard Weinberger <richard@nod.at>,
	linux-f2fs-devel@lists.sourceforge.net,
	Jaegeuk Kim <jaegeuk@kernel.org>, linux-ext4@vger.kernel.org
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

From: Eric Biggers <ebiggers@google.com>

Filesystem encryption is designed to enforce that all files in an
encrypted directory tree use the same encryption policy.  Operations
that violate this constraint are supposed to fail with EPERM.  There was
one case that was missed, however: the cross-rename operation (i.e.
renameat2 with RENAME_EXCHANGE) allowed two files with different
encryption policies to be exchanged, provided that neither encryption
key was available.

To fix this, when we can't compare the fscrypt_info structs because the
key is unavailable, compare the fscrypt_context structs instead.

This will be covered by a test in my encryption xfstests patchset.

Fixes: b7236e21d55f ("ext4 crypto: reorganize how we store keys in the inode")
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/policy.c | 76 ++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 57 insertions(+), 19 deletions(-)

diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index 6ed7c2e..5de0633 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -169,22 +169,46 @@ int fscrypt_ioctl_get_policy(struct file *filp, void __user *arg)
 }
 EXPORT_SYMBOL(fscrypt_ioctl_get_policy);
 
+/**
+ * fscrypt_has_permitted_context() - is a file's encryption policy permitted
+ *				     within its parent directory?
+ *
+ * @parent: inode for parent directory
+ * @child: inode for file being looked up or linked into the directory
+ *
+ * Filesystems must call this function during lookup in an encrypted directory
+ * and before any operation that involves linking a file into an encrypted
+ * directory, including link, rename, and cross rename.  It enforces the
+ * constraint that within a given encrypted directory tree, all files use the
+ * same encryption policy.  The lookup check is needed to detect offline
+ * violations of this constraint, whereas the other checks are needed to prevent
+ * online violations of this constraint.
+ *
+ * Return: 1 if permitted, 0 if forbidden.  If forbidden, the caller must fail
+ * the filesystem operation with EPERM.
+ */
 int fscrypt_has_permitted_context(struct inode *parent, struct inode *child)
 {
-	struct fscrypt_info *parent_ci, *child_ci;
+	const struct fscrypt_operations *cops = parent->i_sb->s_cop;
+	const struct fscrypt_info *parent_ci, *child_ci;
+	struct fscrypt_context parent_ctx, child_ctx;
 	int res;
 
-	if ((parent == NULL) || (child == NULL)) {
-		printk(KERN_ERR	"parent %p child %p\n", parent, child);
-		BUG_ON(1);
-	}
-
-	/* no restrictions if the parent directory is not encrypted */
-	if (!parent->i_sb->s_cop->is_encrypted(parent))
+	/* No restrictions if the parent directory is unencrypted */
+	if (!cops->is_encrypted(parent))
 		return 1;
-	/* if the child directory is not encrypted, this is always a problem */
-	if (!parent->i_sb->s_cop->is_encrypted(child))
+
+	/* Encrypted directories must not contain unencrypted files */
+	if (!cops->is_encrypted(child))
 		return 0;
+
+	/*
+	 * Both parent and child are encrypted, so verify they use the same
+	 * encryption policy.  Compare the fscrypt_info structs if the keys are
+	 * available, otherwise compare the fscrypt_context structs directly.
+	 * In any case, if an unexpected error occurs, fall back to "forbidden".
+	 */
+
 	res = fscrypt_get_encryption_info(parent);
 	if (res)
 		return 0;
@@ -193,17 +217,31 @@ int fscrypt_has_permitted_context(struct inode *parent, struct inode *child)
 		return 0;
 	parent_ci = parent->i_crypt_info;
 	child_ci = child->i_crypt_info;
-	if (!parent_ci && !child_ci)
-		return 1;
-	if (!parent_ci || !child_ci)
+	if (parent_ci && child_ci) {
+		return memcmp(parent_ci->ci_master_key, child_ci->ci_master_key,
+			      FS_KEY_DESCRIPTOR_SIZE) == 0 &&
+			(parent_ci->ci_data_mode == child_ci->ci_data_mode) &&
+			(parent_ci->ci_filename_mode ==
+			 child_ci->ci_filename_mode) &&
+			(parent_ci->ci_flags == child_ci->ci_flags);
+	}
+
+	res = cops->get_context(parent, &parent_ctx, sizeof(parent_ctx));
+	if (res != sizeof(parent_ctx))
 		return 0;
 
-	return (memcmp(parent_ci->ci_master_key,
-			child_ci->ci_master_key,
-			FS_KEY_DESCRIPTOR_SIZE) == 0 &&
-		(parent_ci->ci_data_mode == child_ci->ci_data_mode) &&
-		(parent_ci->ci_filename_mode == child_ci->ci_filename_mode) &&
-		(parent_ci->ci_flags == child_ci->ci_flags));
+	res = cops->get_context(child, &child_ctx, sizeof(child_ctx));
+	if (res != sizeof(child_ctx))
+		return 0;
+
+	return memcmp(parent_ctx.master_key_descriptor,
+		      child_ctx.master_key_descriptor,
+		      FS_KEY_DESCRIPTOR_SIZE) == 0 &&
+		(parent_ctx.contents_encryption_mode ==
+		 child_ctx.contents_encryption_mode) &&
+		(parent_ctx.filenames_encryption_mode ==
+		 child_ctx.filenames_encryption_mode) &&
+		(parent_ctx.flags == child_ctx.flags);
 }
 EXPORT_SYMBOL(fscrypt_has_permitted_context);
 
-- 
2.8.0.rc3.226.g39d4020


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
