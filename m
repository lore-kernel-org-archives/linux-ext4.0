From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 3/4] vfs: don't let the dirty time inodes get more than a day
	stale
Date: Fri, 21 Nov 2014 14:59:23 -0500
Message-ID: <1416599964-21892-4-git-send-email-tytso@mit.edu>
References: <1416599964-21892-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
To: linux-fsdevel@vger.kernel.org
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <1416599964-21892-1-git-send-email-tytso@mit.edu>
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

Guarantee that the on-disk timestamps will be no more than 24 hours
stale.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/fs-writeback.c  | 1 +
 fs/inode.c         | 7 ++++++-
 include/linux/fs.h | 1 +
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index ce7de22..eb04277 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1141,6 +1141,7 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 	if (flags & (I_DIRTY_SYNC | I_DIRTY_DATASYNC)) {
 		trace_writeback_dirty_inode_start(inode, flags);
 
+		inode->i_ts_dirty_day = 0;
 		if (sb->s_op->dirty_inode)
 			sb->s_op->dirty_inode(inode, flags);
 
diff --git a/fs/inode.c b/fs/inode.c
index 6e91aca..f0d6232 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1511,6 +1511,7 @@ static int relatime_need_update(struct vfsmount *mnt, struct inode *inode,
  */
 static int update_time(struct inode *inode, struct timespec *time, int flags)
 {
+	int days_since_boot = jiffies / (HZ * 86400);
 	int ret;
 
 	if (inode->i_op->update_time) {
@@ -1527,12 +1528,16 @@ static int update_time(struct inode *inode, struct timespec *time, int flags)
 		if (flags & S_MTIME)
 			inode->i_mtime = *time;
 	}
-	if (inode->i_sb->s_flags & MS_LAZYTIME) {
+	if ((inode->i_sb->s_flags & MS_LAZYTIME) &&
+	    (!inode->i_ts_dirty_day ||
+	     inode->i_ts_dirty_day == days_since_boot)) {
 		spin_lock(&inode->i_lock);
 		inode->i_state |= I_DIRTY_TIME;
 		spin_unlock(&inode->i_lock);
+		inode->i_ts_dirty_day = days_since_boot;
 		return 0;
 	}
+	inode->i_ts_dirty_day = 0;
 	if (inode->i_op->write_time)
 		return inode->i_op->write_time(inode);
 	mark_inode_dirty_sync(inode);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 489b2f2..e3574cd 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -575,6 +575,7 @@ struct inode {
 	struct timespec		i_ctime;
 	spinlock_t		i_lock;	/* i_blocks, i_bytes, maybe i_size */
 	unsigned short          i_bytes;
+	unsigned short		i_ts_dirty_day;
 	unsigned int		i_blkbits;
 	blkcnt_t		i_blocks;
 
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
