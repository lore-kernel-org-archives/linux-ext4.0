From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH-v4 3/7] vfs: don't let the dirty time inodes get more than a day stale
Date: Wed, 26 Nov 2014 05:23:53 -0500
Message-ID: <1416997437-26092-4-git-send-email-tytso@mit.edu>
References: <1416997437-26092-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux btrfs Developers List <linux-btrfs@vger.kernel.org>,
	XFS Developers <xfs@oss.sgi.com>, Theodore Ts'o <tytso@mit.edu>
To: Linux Filesystem Development List <linux-fsdevel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52546 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951AbaKZKYF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Nov 2014 05:24:05 -0500
In-Reply-To: <1416997437-26092-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Guarantee that the on-disk timestamps will be no more than 24 hours
stale.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/fs-writeback.c  |  1 +
 fs/inode.c         | 18 ++++++++++++++++++
 include/linux/fs.h |  1 +
 3 files changed, 20 insertions(+)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index ef8c5d8..529480a 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1143,6 +1143,7 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 	if (flags & (I_DIRTY_SYNC | I_DIRTY_DATASYNC)) {
 		trace_writeback_dirty_inode_start(inode, flags);
 
+		inode->i_ts_dirty_day = 0;
 		if (sb->s_op->dirty_inode)
 			sb->s_op->dirty_inode(inode, flags);
 
diff --git a/fs/inode.c b/fs/inode.c
index 9e464cc..37c0429 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1510,6 +1510,8 @@ static int relatime_need_update(struct vfsmount *mnt, struct inode *inode,
  */
 static int update_time(struct inode *inode, struct timespec *time, int flags)
 {
+	struct timespec uptime;
+	unsigned short days_since_boot;
 	int ret;
 
 	if (inode->i_op->update_time) {
@@ -1526,11 +1528,26 @@ static int update_time(struct inode *inode, struct timespec *time, int flags)
 		if (flags & S_MTIME)
 			inode->i_mtime = *time;
 	}
+	/*
+	 * If i_ts_dirty_day is zero, then either we have not deferred
+	 * timestamp updates, or the system has been up for less than
+	 * a day (so days_since_boot is zero), so we defer timestamp
+	 * updates in that case and set the I_DIRTY_TIME flag.  If a
+	 * day or more has passed, then i_ts_dirty_day will be
+	 * different from days_since_boot, and then we should update
+	 * the on-disk inode and then we can clear i_ts_dirty_day.
+	 */
 	if ((inode->i_sb->s_flags & MS_LAZYTIME) &&
 	    !(flags & S_VERSION) &&
 	    !(inode->i_state & (I_DIRTY_SYNC | I_DIRTY_DATASYNC))) {
 		if (inode->i_state & I_DIRTY_TIME)
 			return 0;
+		get_monotonic_boottime(&uptime);
+		days_since_boot = div_u64(uptime.tv_sec, 86400);
+		if (inode->i_ts_dirty_day &&
+		    (inode->i_ts_dirty_day != days_since_boot))
+			goto force_dirty;
+
 		spin_lock(&inode->i_lock);
 		if (inode->i_state & (I_DIRTY_SYNC | I_DIRTY_DATASYNC)) {
 			spin_unlock(&inode->i_lock);
@@ -1541,6 +1558,7 @@ static int update_time(struct inode *inode, struct timespec *time, int flags)
 			return 0;
 		}
 		inode->i_state |= I_DIRTY_TIME;
+		inode->i_ts_dirty_day = days_since_boot;
 		spin_unlock(&inode->i_lock);
 		inode_requeue_dirtytime(inode);
 		return 0;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 55cf34d..d0a2181 100644
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

