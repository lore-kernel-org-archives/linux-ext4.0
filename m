From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 10/13] fscrypto: restrict setting new policy to
	empty files and directories only
Date: Sun,  3 Apr 2016 00:22:01 -0500
Message-ID: <1459660924-2960-11-git-send-email-ebiggers3@gmail.com>
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

On f2fs, a user could create a regular file of small positive size and
issue FS_IOC_SET_ENCRYPTION_POLICY to set its encryption policy.
However, this did not behave as expected because the existing data was
not actually encrypted by the ioctl.

Fix this by only permitting an encryption policy to be created for empty
regular files and directories.

For a correct solution, it is necessary to conduct the operation under
the inode lock; otherwise the inode's size might be changed concurrently.

Signed-off-by: Eric Biggers <ebiggers3@gmail.com>
---
 fs/crypto/policy.c | 42 ++++++++++++++++++++++++++++++------------
 1 file changed, 30 insertions(+), 12 deletions(-)

diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index 93244b5..cb5ba27 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -94,23 +94,41 @@ static int create_encryption_context_from_policy(struct inode *inode,
 
 int fscrypt_set_policy(struct inode *inode, const struct fscrypt_policy *policy)
 {
+	int ret = 0;
+
 	if (policy->version != 0)
 		return -EINVAL;
 
+	inode_lock(inode);
+
 	if (!inode_has_encryption_context(inode)) {
-		if (!inode->i_sb->s_cop->empty_dir)
-			return -EOPNOTSUPP;
-		if (!inode->i_sb->s_cop->empty_dir(inode))
-			return -ENOTEMPTY;
-		return create_encryption_context_from_policy(inode, policy);
+		/* A new policy may only be set on an empty directory or an
+		 * empty regular file. */
+		ret = -EINVAL;
+		if (S_ISDIR(inode->i_mode)) {
+			if (!inode->i_sb->s_cop->empty_dir)
+				ret = -EOPNOTSUPP;
+			else if (inode->i_sb->s_cop->empty_dir(inode))
+				ret = 0;
+			else
+				ret = -ENOTEMPTY;
+		} else if (S_ISREG(inode->i_mode)) {
+			ret = -ENOTEMPTY;
+			if (inode->i_size == 0)
+				ret = 0;
+		}
+		if (!ret) {
+			ret = create_encryption_context_from_policy(inode,
+								    policy);
+		}
+	} else if (!is_encryption_context_consistent_with_policy(inode, policy)) {
+		printk(KERN_WARNING
+		       "%s: Policy inconsistent with encryption context\n",
+		       __func__);
+		ret = -EINVAL;
 	}
-
-	if (is_encryption_context_consistent_with_policy(inode, policy))
-		return 0;
-
-	printk(KERN_WARNING "%s: Policy inconsistent with encryption context\n",
-	       __func__);
-	return -EINVAL;
+	inode_unlock(inode);
+	return ret;
 }
 EXPORT_SYMBOL(fscrypt_set_policy);
 
-- 
2.7.4


------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785471&iu=/4140
