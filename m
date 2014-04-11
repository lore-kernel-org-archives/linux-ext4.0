From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 1/4] ext4: Remove unnecessary check for APPEND and IMMUTABLE
Date: Fri, 11 Apr 2014 20:57:42 +0200
Message-ID: <1397242665-2183-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Lukas Czerner <lczerner@redhat.com>, ceph-devel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com
To: linux-fsdevel@vger.kernel.org
Return-path: <xfs-bounces@oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

All the checks IS_APPEND and IS_IMMUTABLE for the fallocate operation on
the inode are done in vfs. No need to do this again in ext4. Remove it.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/extents.c | 6 ------
 fs/ext4/inode.c   | 6 +-----
 2 files changed, 1 insertion(+), 11 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 89f2227..0177150 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5387,12 +5387,6 @@ int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
 	/* Take mutex lock */
 	mutex_lock(&inode->i_mutex);
 
-	/* It's not possible punch hole on append only file */
-	if (IS_APPEND(inode) || IS_IMMUTABLE(inode)) {
-		ret = -EPERM;
-		goto out_mutex;
-	}
-
 	if (IS_SWAPFILE(inode)) {
 		ret = -ETXTBSY;
 		goto out_mutex;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 1922f48..56f1ff4 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3528,11 +3528,7 @@ int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length)
 	}
 
 	mutex_lock(&inode->i_mutex);
-	/* It's not possible punch hole on append only file */
-	if (IS_APPEND(inode) || IS_IMMUTABLE(inode)) {
-		ret = -EPERM;
-		goto out_mutex;
-	}
+
 	if (IS_SWAPFILE(inode)) {
 		ret = -ETXTBSY;
 		goto out_mutex;
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
