From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 1/4] This patch adds new operation to struct super_operations - sync_inodes,
Date: Thu,  5 Jul 2007 23:33:20 +0530
Message-ID: <11836586131887-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1183658603788-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: aneesh.kumar@linux.vnet.ibm.com, Hans Reiser <reiser@namesys.com>,
	Andrew Morton <akpm@osdl.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:32895 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758144AbXGESEU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Jul 2007 14:04:20 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp04.au.ibm.com (8.13.8/8.13.8) with ESMTP id l65IQIHe290958
	for <linux-ext4@vger.kernel.org>; Fri, 6 Jul 2007 04:26:37 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.250.237])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l65I7LkY199306
	for <linux-ext4@vger.kernel.org>; Fri, 6 Jul 2007 04:07:21 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l65I3mps013418
	for <linux-ext4@vger.kernel.org>; Fri, 6 Jul 2007 04:03:48 +1000
In-Reply-To: <1183658603788-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Message-Id: <c69d5860cee44bebe28450367491b96c57225402.1183658085.git.aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Hans Reiser <reiser@namesys.com>

Reiser4 flushes dirty pages on basic of atoms, not of inodes.  sync_sb_inodes
used to call address space flushing method (writepages) for every dirty inode.
 For reiser4 it caused having to commit atoms unnecessarily often.  This
turned into substantial slowdown.  Having this method helped to fix that
problem.

Also, make generic_sync_sb_inodes spin lock itself.  It helps reiser4 to
get rid of some oddities.

sync_sb_inodes is always called like:
	spin_lock(&inode_lock);
	sync_sb_inodes(sb, wbc);
	spin_unlock(&inode_lock);
This patch moves spin_lock/spin_unlock down to sync_sb_inodes.

Signed-off-by: Andrew Morton <akpm@osdl.org>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/fs-writeback.c  |   26 ++++++++++++++++----------
 include/linux/fs.h |    3 +++
 2 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index a4b142a..cdcff8c 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -296,8 +296,6 @@ __writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
  * WB_SYNC_HOLD is a hack for sys_sync(): reattach the inode to sb->s_dirty so
  * that it can be located for waiting on in __writeback_single_inode().
  *
- * Called under inode_lock.
- *
  * If `bdi' is non-zero then we're being asked to writeback a specific queue.
  * This function assumes that the blockdev superblock's inodes are backed by
  * a variety of queues, so all inodes are searched.  For other superblocks,
@@ -313,11 +311,13 @@ __writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
  * on the writer throttling path, and we get decent balancing between many
  * throttled threads: we don't want them all piling up on __wait_on_inode.
  */
-static void
-sync_sb_inodes(struct super_block *sb, struct writeback_control *wbc)
+void
+generic_sync_sb_inodes(struct super_block *sb, struct writeback_control *wbc)
 {
 	const unsigned long start = jiffies;	/* livelock avoidance */
 
+	spin_lock(&inode_lock);
+
 	if (!wbc->for_kupdate || list_empty(&sb->s_io))
 		list_splice_init(&sb->s_dirty, &sb->s_io);
 
@@ -397,8 +397,19 @@ sync_sb_inodes(struct super_block *sb, struct writeback_control *wbc)
 		if (wbc->nr_to_write <= 0)
 			break;
 	}
+	spin_unlock(&inode_lock);
 	return;		/* Leave any unwritten inodes on s_io */
 }
+EXPORT_SYMBOL(generic_sync_sb_inodes);
+
+static void
+sync_sb_inodes(struct super_block *sb, struct writeback_control *wbc)
+{
+	if (sb->s_op->sync_inodes)
+		sb->s_op->sync_inodes(sb, wbc);
+	else
+		generic_sync_sb_inodes(sb, wbc);
+}
 
 /*
  * Start writeback of dirty pagecache data against all unlocked inodes.
@@ -439,11 +450,8 @@ restart:
 			 * be unmounted by the time it is released.
 			 */
 			if (down_read_trylock(&sb->s_umount)) {
-				if (sb->s_root) {
-					spin_lock(&inode_lock);
+				if (sb->s_root)
 					sync_sb_inodes(sb, wbc);
-					spin_unlock(&inode_lock);
-				}
 				up_read(&sb->s_umount);
 			}
 			spin_lock(&sb_lock);
@@ -481,9 +489,7 @@ void sync_inodes_sb(struct super_block *sb, int wait)
 			(inodes_stat.nr_inodes - inodes_stat.nr_unused) +
 			nr_dirty + nr_unstable;
 	wbc.nr_to_write += wbc.nr_to_write / 2;		/* Bit more for luck */
-	spin_lock(&inode_lock);
 	sync_sb_inodes(sb, &wbc);
-	spin_unlock(&inode_lock);
 }
 
 /*
diff --git a/include/linux/fs.h b/include/linux/fs.h
index c90a212..12546d0 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1193,6 +1193,8 @@ struct super_operations {
 	void (*clear_inode) (struct inode *);
 	void (*umount_begin) (struct vfsmount *, int);
 
+	void (*sync_inodes) (struct super_block *sb,
+				struct writeback_control *wbc);
 	int (*show_options)(struct seq_file *, struct vfsmount *);
 	int (*show_stats)(struct seq_file *, struct vfsmount *);
 #ifdef CONFIG_QUOTA
@@ -1644,6 +1646,7 @@ extern int invalidate_inode_pages2(struct address_space *mapping);
 extern int invalidate_inode_pages2_range(struct address_space *mapping,
 					 pgoff_t start, pgoff_t end);
 extern int write_inode_now(struct inode *, int);
+extern void generic_sync_sb_inodes(struct super_block *, struct writeback_control *);
 extern int filemap_fdatawrite(struct address_space *);
 extern int filemap_flush(struct address_space *);
 extern int filemap_fdatawait(struct address_space *);
-- 
1.5.3.rc0.30.g114fd-dirty
