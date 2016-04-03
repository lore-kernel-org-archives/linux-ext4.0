From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 11/13] fscrypto: restrict setting encryption
	policy to inode owner
Date: Sun,  3 Apr 2016 00:22:02 -0500
Message-ID: <1459660924-2960-12-git-send-email-ebiggers3@gmail.com>
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

On a filesystem with encryption enabled, a user could set an encryption
policy on any empty directory to which they have readonly access.  This
is a potential security issue since such a directory might be owned by
another user, and the new encryption policy may prevent that user from
creating files in their own directory.

Fix this by requiring inode_owner_or_capable() permission to set an
encryption policy.

Signed-off-by: Eric Biggers <ebiggers3@gmail.com>
---
 fs/crypto/policy.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index cb5ba27..3f5c275 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -96,6 +96,9 @@ int fscrypt_set_policy(struct inode *inode, const struct fscrypt_policy *policy)
 {
 	int ret = 0;
 
+	if (!inode_owner_or_capable(inode))
+		return -EACCES;
+
 	if (policy->version != 0)
 		return -EINVAL;
 
-- 
2.7.4


------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785471&iu=/4140
