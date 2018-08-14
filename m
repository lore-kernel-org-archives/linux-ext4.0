From: Chengguang Xu <cgxu519@gmx.com>
Subject: [PATCH 4/5] jfs: cache NULL when both default_acl and
 acl are NULL
Date: Tue, 14 Aug 2018 22:16:33 +0800
Message-ID: <20180814141634.5471-4-cgxu519@gmx.com>
References: <20180814141634.5471-1-cgxu519@gmx.com>
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
In-Reply-To: <20180814141634.5471-1-cgxu519@gmx.com>
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
 fs/jfs/acl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/jfs/acl.c b/fs/jfs/acl.c
index 2e71b6e7e646..15b9a9b74d72 100644
--- a/fs/jfs/acl.c
+++ b/fs/jfs/acl.c
@@ -154,6 +154,9 @@ int jfs_init_acl(tid_t tid, struct inode *inode, struct inode *dir)
 		posix_acl_release(acl);
 	}
 
+	if (!default_acl && !acl)
+		cache_no_acl(inode);
+
 	JFS_IP(inode)->mode2 = (JFS_IP(inode)->mode2 & 0xffff0000) |
 			       inode->i_mode;
 
-- 
2.17.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
