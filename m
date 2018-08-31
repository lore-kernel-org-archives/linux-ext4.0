From: Chengguang Xu <cgxu519@gmx.com>
Subject: [PATCH v2 1/5] ext2: cache NULL when both default_acl
 and acl are NULL
Date: Fri, 31 Aug 2018 22:33:48 +0800
Message-ID: <20180831143352.22970-1-cgxu519@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: jfs-discussion@lists.sourceforge.net, Chengguang Xu <cgxu519@gmx.com>,
 linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-ext4@vger.kernel.org, devel@lists.orangefs.org
To: jack@suse.com, tytso@mit.edu, adilger.kernel@dilger.ca, jaegeuk@kernel.org,
 yuchao0@huawei.com, shaggy@kernel.org, hubcap@omnibond.com,
 martin@omnibond.com
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

default_acl and acl of newly created inode will be initiated
as ACL_NOT_CACHED in vfs function inode_init_always() and later
will be updated by calling xxx_init_acl() in specific filesystems.
Howerver, when default_acl and acl are NULL then they keep the value
of ACL_NOT_CACHED, this patch tries to cache NULL for acl/default_acl
in this case.

Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
---
v1->v2:
- Coding style change.

 fs/ext2/acl.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ext2/acl.c b/fs/ext2/acl.c
index 224c04abb2e5..cf4c77f8dd08 100644
--- a/fs/ext2/acl.c
+++ b/fs/ext2/acl.c
@@ -256,11 +256,15 @@ ext2_init_acl(struct inode *inode, struct inode *dir)
 	if (default_acl) {
 		error = __ext2_set_acl(inode, default_acl, ACL_TYPE_DEFAULT);
 		posix_acl_release(default_acl);
+	} else {
+		inode->i_default_acl = NULL;
 	}
 	if (acl) {
 		if (!error)
 			error = __ext2_set_acl(inode, acl, ACL_TYPE_ACCESS);
 		posix_acl_release(acl);
+	} else {
+		inode->i_acl = NULL;
 	}
 	return error;
 }
-- 
2.17.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
