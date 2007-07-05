From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 2/4] Add support for locality group.
Date: Thu,  5 Jul 2007 23:33:21 +0530
Message-ID: <1183658628862-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1183658603788-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <11836586131887-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: aneesh.kumar@linux.vnet.ibm.com, Alex Tomas <alex@clusterfs.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:53622 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759285AbXGESFP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Jul 2007 14:05:15 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp05.au.ibm.com (8.13.8/8.13.8) with ESMTP id l65I6MFv094264
	for <linux-ext4@vger.kernel.org>; Fri, 6 Jul 2007 04:06:25 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.250.237])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l65I8Y6p193070
	for <linux-ext4@vger.kernel.org>; Fri, 6 Jul 2007 04:08:34 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l65I52wE014721
	for <linux-ext4@vger.kernel.org>; Fri, 6 Jul 2007 04:05:02 +1000
In-Reply-To: <11836586131887-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Message-Id: <036b9cd1315aa9fed270b96bfc6e7a8662cb01db.1183658085.git.aneesh.kumar@linux.vnet.ibm.com>
In-Reply-To: <c69d5860cee44bebe28450367491b96c57225402.1183658085.git.aneesh.kumar@linux.vnet.ibm.com>
References: <c69d5860cee44bebe28450367491b96c57225402.1183658085.git.aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Alex Tomas <alex@clusterfs.com>

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/Makefile           |    2 +-
 fs/ext4/lg.c               |  576 ++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/super.c            |    5 +
 fs/fs-writeback.c          |    8 +-
 include/linux/ext4_fs.h    |   37 +++
 include/linux/ext4_fs_i.h  |    2 +
 include/linux/ext4_fs_sb.h |    6 +
 7 files changed, 630 insertions(+), 6 deletions(-)
 create mode 100644 fs/ext4/lg.c

diff --git a/fs/ext4/Makefile b/fs/ext4/Makefile
index 7b24c73..f3d8ba7 100644
--- a/fs/ext4/Makefile
+++ b/fs/ext4/Makefile
@@ -6,7 +6,7 @@ obj-$(CONFIG_EXT4DEV_FS) += ext4dev.o
 
 ext4dev-y	:= balloc.o bitmap.o dir.o file.o fsync.o ialloc.o inode.o \
 		   ioctl.o namei.o super.o symlink.o hash.o resize.o extents.o \
-		   ext4_jbd2.o writeback.o
+		   ext4_jbd2.o writeback.o lg.o
 
 ext4dev-$(CONFIG_EXT4DEV_FS_XATTR)	+= xattr.o xattr_user.o xattr_trusted.o
 ext4dev-$(CONFIG_EXT4DEV_FS_POSIX_ACL)	+= acl.o
diff --git a/fs/ext4/lg.c b/fs/ext4/lg.c
new file mode 100644
index 0000000..7fcdfe1
--- /dev/null
+++ b/fs/ext4/lg.c
@@ -0,0 +1,576 @@
+/*
+ * Copyright (c) 2006, Cluster File Systems, Inc, info@clusterfs.com
+ * Written by Alex Tomas <alex@clusterfs.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public Licens
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-
+ */
+
+/*
+ * locality groups
+ *
+ */
+
+/*
+ * TODO:
+ *  - too many of tricks
+ *  - mmap'ed files support (we need to link them to some group)
+ *  - too silly grouping policy
+ *  - free non-used groups after some timeout
+ *  - anonymous group for non-regular inodes
+ *
+ */
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/time.h>
+#include <linux/ext4_jbd2.h>
+#include <linux/ext4_fs.h>
+#include <linux/ext4_fs_i.h>
+#include <linux/ext4_fs_sb.h>
+#include <linux/jbd.h>
+#include <linux/smp_lock.h>
+#include <linux/highuid.h>
+#include <linux/pagemap.h>
+#include <linux/quotaops.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+#include <linux/list.h>
+#include <linux/writeback.h>
+
+#ifndef TestClearPageChecked
+#define TestClearPageChecked(page) test_and_clear_bit(PG_checked, &(page)->flags)
+#endif
+#ifndef TestSetPageChecked
+#define TestSetPageChecked(page) test_and_set_bit(PG_checked, &(page)->flags)
+#endif
+
+
+extern struct super_block *blockdev_superblock;
+static inline int sb_is_blkdev_sb(struct super_block *sb)
+{
+	return sb == blockdev_superblock;
+}
+
+extern int __writeback_single_inode(struct inode *, struct writeback_control *);
+
+struct ext4_locality_group *ext4_lg_find_group(struct super_block *sb)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_locality_group *lg = NULL;
+	struct list_head *cur;
+
+	rcu_read_lock();
+	list_for_each_rcu(cur, &sbi->s_locality_groups) {
+		lg = list_entry(cur, struct ext4_locality_group, lg_hash);
+		if (lg->lg_pgid == current->signal->pgrp) {
+			spin_lock(&lg->lg_lock);
+			if (lg->lg_deleted == 0) {
+				atomic_inc(&lg->lg_count);
+				spin_unlock(&lg->lg_lock);
+				break;
+			}
+			spin_unlock(&lg->lg_lock);
+		}
+		lg = NULL;
+	}
+ 	rcu_read_unlock();
+	return lg;
+}
+
+void ext4_lg_put_group(struct ext4_locality_group *lg)
+{
+	atomic_dec(&lg->lg_count);
+}
+
+struct ext4_locality_group *ext4_lg_new_group(struct super_block *sb)
+{
+	struct ext4_locality_group *lg;
+
+	lg = kmalloc(sizeof(struct ext4_locality_group), GFP_NOFS);
+	if (lg == NULL)
+		return NULL;
+
+	lg->lg_pgid = current->signal->pgrp;
+	lg->lg_sid = current->signal->session;
+	spin_lock_init(&lg->lg_lock);
+	lg->lg_deleted = 0;
+	lg->lg_flags = 0;
+	atomic_set(&lg->lg_count, 1);
+	atomic_set(&lg->lg_inodes_nr, 0);
+	INIT_LIST_HEAD(&lg->lg_list);
+	INIT_LIST_HEAD(&lg->lg_inodes);
+	INIT_LIST_HEAD(&lg->lg_dirty);
+	INIT_LIST_HEAD(&lg->lg_io);
+	atomic_set(&lg->lg_dirty_pages, 0);
+	atomic_set(&lg->lg_nonallocated, 0);
+
+	return lg;
+}
+
+struct ext4_locality_group *
+ext4_lg_assign_to_group_nolock(struct inode *inode, struct ext4_locality_group *lg)
+{
+	/*
+	 * XXX locking here?
+	 */
+	if (EXT4_I(inode)->i_locality_group == NULL) {
+		EXT4_I(inode)->i_locality_group = lg;
+		list_add(&EXT4_I(inode)->i_lg_list, &lg->lg_inodes);
+		atomic_inc(&lg->lg_inodes_nr);
+	} else {
+		printk("somebody has already set lg %p (our %p) to inode %lu(%p)\n",
+			EXT4_I(inode)->i_locality_group, lg, inode->i_ino, inode);
+		ext4_lg_put_group(lg);
+		lg = EXT4_I(inode)->i_locality_group;
+	}
+	return lg;
+}
+
+struct ext4_locality_group *
+ext4_lg_assign_to_group(struct inode *inode, struct ext4_locality_group *lg)
+{
+	spin_lock(&inode_lock);
+	ext4_lg_assign_to_group_nolock(inode, lg);
+	spin_unlock(&inode_lock);
+	return lg;
+	
+}
+
+struct ext4_locality_group *ext4_lg_find_or_allocate_group(struct inode *inode)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+	struct ext4_locality_group *lg, *olg;
+
+	lg = ext4_lg_find_group(inode->i_sb);
+	if (lg == NULL) {
+		lg = ext4_lg_new_group(inode->i_sb);
+		if (lg == NULL)
+			return NULL;
+
+		spin_lock(&sbi->s_locality_lock);
+		olg = ext4_lg_find_group(inode->i_sb);
+		if (olg == NULL) {
+			list_add_rcu(&lg->lg_hash, &sbi->s_locality_groups);
+		} else {
+			kfree(lg);
+			lg = olg;
+		}
+		spin_unlock(&sbi->s_locality_lock);
+	}
+
+	lg = ext4_lg_assign_to_group(inode, lg);
+	return lg;
+}
+
+/*
+ * every dirty page should be counted
+ */
+void ext4_lg_page_enter_inode(struct inode *inode,
+				struct page *page, int allocated)
+{
+	struct ext4_locality_group *lg;
+
+	lg = EXT4_I(inode)->i_locality_group;
+	if (lg == NULL) {
+		lg = ext4_lg_find_or_allocate_group(inode);
+		if (lg == NULL)
+			return;
+	}
+
+	if (!TestSetPageChecked(page)) {
+		atomic_inc(&lg->lg_dirty_pages);
+		if (!allocated)
+			atomic_inc(&lg->lg_nonallocated);
+	}
+}
+
+
+/*
+ * 
+ */
+void ext4_lg_page_leave_inode(struct inode *inode,
+				struct page *page, int allocated)
+{
+	struct ext4_locality_group *lg;
+
+	lg = EXT4_I(inode)->i_locality_group;
+	if (lg == NULL) {
+		if (S_ISREG(inode->i_mode))
+			printk("regular file %lu/%u with no locality group?!\n",
+				inode->i_ino, inode->i_generation);
+		return;
+	}
+
+	if (!TestClearPageChecked(page))
+		return;
+
+	atomic_dec(&lg->lg_dirty_pages);
+	if (!allocated)
+		atomic_dec(&lg->lg_nonallocated);
+}
+
+/*
+ * Inode leave group
+ */
+void ext4_lg_inode_leave_group(struct inode *inode)
+{
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	struct ext4_locality_group *lg;
+
+	if (inode->i_nlink != 0 && S_ISREG(inode->i_mode)) {
+		BUG_ON(mapping_tagged(inode->i_mapping, PAGECACHE_TAG_DIRTY));
+	}
+
+	spin_lock(&inode_lock);
+	lg = ei->i_locality_group;
+	ei->i_locality_group = NULL;
+	spin_unlock(&inode_lock);
+
+	if (lg != NULL) {
+		spin_lock(&lg->lg_lock);
+		list_del(&ei->i_lg_list);
+		spin_unlock(&lg->lg_lock);
+		atomic_dec(&lg->lg_inodes_nr);
+		ext4_lg_put_group(lg);
+	}
+}
+
+#define EXT4_LG_DIRTY			0
+
+#define EXT4_CONTINUE_WRITEBACK		1
+#define EXT4_STOP_WRITEBACK		2
+
+static char *__sync_modes[] = { "NONE", "ALL", "HOLD" };
+
+/*
+ * The function syncs a single group like generic_sync_sb_inodes() does
+ * returns:
+ *    0 - continue syncing with a next group
+ *    1 - break syncing
+ */
+int ext4_lg_sync_single_group(struct super_block *sb,
+				struct ext4_locality_group *lg,
+				struct writeback_control *wbc,
+				unsigned long start)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	int nr_to_write = wbc->nr_to_write;
+	int dirty_pages, nonallocated;
+	int rc, code = 0;
+
+	dirty_pages = atomic_read(&lg->lg_dirty_pages);
+	nonallocated = atomic_read(&lg->lg_nonallocated);
+
+	rc = EXT4_CONTINUE_WRITEBACK;
+
+	spin_lock(&inode_lock);
+
+	if (!wbc->for_kupdate || list_empty(&lg->lg_io))
+		list_splice_init(&lg->lg_dirty, &lg->lg_io);
+
+	while (!list_empty(&lg->lg_io)) {
+		struct inode *inode = list_entry(lg->lg_io.prev,
+				struct inode, i_list);
+		struct address_space *mapping = inode->i_mapping;
+		struct backing_dev_info *bdi = mapping->backing_dev_info;
+		long pages_skipped;
+
+		if (wbc->nonblocking && bdi_write_congested(bdi)) {
+			/* underlying device is congested
+			 * break all writeback immediately */
+			wbc->encountered_congestion = 1;
+
+			/* keep this inode on the head so that
+			 * we'll continue writeback with it
+			 * when we return to this locality group */
+
+			/* same for the locality group */
+			set_bit(EXT4_LG_DIRTY, &lg->lg_flags);
+			list_move(&lg->lg_list, &sbi->s_locality_io);
+
+			/* signal to the caller */
+			rc = EXT4_STOP_WRITEBACK;
+			code = 1;
+			break;
+		}
+
+		if (wbc->bdi && bdi != wbc->bdi) {
+			printk("wbc->bdi (%p) != bdi (%p)\n", wbc->bdi, bdi);
+			list_move(&inode->i_list, &inode_in_use);
+			rc = EXT4_CONTINUE_WRITEBACK;
+			code = 2;
+			break;
+		}
+
+		/* Was this inode dirtied after sync_sb_inodes was called? */
+		if (time_after(inode->dirtied_when, start)) {
+			/* keep this inode on the head so that
+			 * we'll continue writeback with it
+			 * when we return to this locality group */
+
+			/* continue with next locality group
+			 * move this one to the dirty tail */
+			set_bit(EXT4_LG_DIRTY, &lg->lg_flags);
+			list_move_tail(&lg->lg_list, &sbi->s_locality_dirty);
+
+			rc = EXT4_CONTINUE_WRITEBACK;
+			code = 3;
+			break;
+		}
+
+		/* Was this inode dirtied too recently? */
+		if (wbc->older_than_this && time_after(inode->dirtied_when,
+					*wbc->older_than_this)) {
+			/* keep this inode on the head so that
+			 * we'll continue writeback with it
+			 * when we return to this locality group */
+
+			/* continue with next locality group
+			 * move this one to the dirty tail */
+			set_bit(EXT4_LG_DIRTY, &lg->lg_flags);
+			list_move_tail(&lg->lg_list, &sbi->s_locality_dirty);
+
+			rc = EXT4_CONTINUE_WRITEBACK;
+			code = 4;
+			break;
+		}
+
+		/* Is another pdflush already flushing this queue? */
+		if (current_is_pdflush() && !writeback_acquire(bdi)) {
+			/* keep this inode on the head so that
+			 * we'll continue writeback with it
+			 * when we return to this locality group */
+
+			/* same for the locality group */
+			list_move(&lg->lg_list, &sbi->s_locality_io);
+
+			rc = EXT4_STOP_WRITEBACK;
+			code = 5;
+			break;
+		}
+
+		BUG_ON(inode->i_state & I_FREEING);
+		__iget(inode);
+		pages_skipped = wbc->pages_skipped;
+		__writeback_single_inode(inode, wbc);
+		if (wbc->sync_mode == WB_SYNC_HOLD) {
+			inode->dirtied_when = jiffies;
+			list_move(&inode->i_list, &lg->lg_dirty);
+			set_bit(EXT4_LG_DIRTY, &lg->lg_flags);
+			list_move(&lg->lg_list, &sbi->s_locality_dirty);
+		}
+		if (current_is_pdflush())
+			writeback_release(bdi);
+		if (wbc->pages_skipped != pages_skipped) {
+			/*
+			 * writeback is not making progress due to locked
+			 * buffers.  Skip this inode for now.
+			 */
+			list_move(&inode->i_list, &lg->lg_dirty);
+
+			set_bit(EXT4_LG_DIRTY, &lg->lg_flags);
+			list_move(&lg->lg_list, &sbi->s_locality_dirty);
+		}
+		spin_unlock(&inode_lock);
+		iput(inode);
+		cond_resched();
+		spin_lock(&inode_lock);
+		if (wbc->nr_to_write <= 0) {
+			rc = EXT4_STOP_WRITEBACK;
+			code = 6;
+			break;
+		}
+	}
+
+	spin_unlock(&inode_lock);
+
+	if (0 && nr_to_write - wbc->nr_to_write) {
+		printk("#%u: %s/%lu/%s%s%s%s%s%s M: %lu/%lu/%lu "
+			"LG:%p/%u/%u[%u/%u] wrote %lu/%d\n",
+			current->pid, __sync_modes[wbc->sync_mode],
+			wbc->nr_to_write,
+			wbc->nonblocking ? "N" : "",
+			wbc->encountered_congestion ? "C" : "",
+			wbc->for_kupdate ? "U" : "",
+			wbc->for_reclaim ? "R" : "",
+			wbc->for_writepages ? "W" : "",
+			wbc->range_cyclic ? "I" : "",
+			global_page_state(NR_FILE_DIRTY),
+			global_page_state(NR_UNSTABLE_NFS),
+			global_page_state(NR_WRITEBACK),
+			lg, atomic_read(&lg->lg_count), lg->lg_pgid,
+			dirty_pages, nonallocated,
+			nr_to_write - wbc->nr_to_write, code);
+	}
+
+	return rc;
+}
+
+/*
+ * the core of inode syncer:
+ *  - loop over locality groups
+ *  - maintain them in order to avoid starvation
+ */
+void ext4_lg_sync_groups(struct super_block *sb, struct writeback_control *wbc)
+{
+	const unsigned long start = jiffies;	/* livelock avoidance */
+	struct ext4_locality_group *lg = NULL, *prev = NULL;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	int rc;
+
+	spin_lock(&inode_lock);
+
+	/*printk("#%u: mode %s, nr2wr %lu, %s%s%s%s%s%s M: %lu/%lu/%lu "
+			"LGs: %sdirty %sio\n", current->pid,
+			__sync_modes[wbc->sync_mode], wbc->nr_to_write,
+			wbc->nonblocking ? "nonblock " : "",
+			wbc->encountered_congestion ? "congested " : "",
+			wbc->for_kupdate ? "kupdate " : "",
+			wbc->for_reclaim ? "reclaim " : "",
+			wbc->for_writepages ? "writepages " : "",
+			wbc->range_cyclic ? "cyclic " : "",
+			global_page_state(NR_FILE_DIRTY),
+			global_page_state(NR_UNSTABLE_NFS),
+			global_page_state(NR_WRITEBACK),
+			list_empty(&sbi->s_locality_dirty) ? "-" : "+",
+			list_empty(&sbi->s_locality_io) ? "-" : "+");*/
+
+	if (!wbc->for_kupdate || list_empty(&sbi->s_locality_io))
+		list_splice_init(&sbi->s_locality_dirty, &sbi->s_locality_io);
+
+	while (!list_empty(&sbi->s_locality_io)) {
+
+		/* we should handle same group twice in a row */
+		WARN_ON(prev && prev == lg);
+		prev = lg;
+
+		lg = list_entry(sbi->s_locality_io.prev,
+				struct ext4_locality_group, lg_list);
+
+		/* protect locality group */
+		atomic_inc(&lg->lg_count);
+
+		/* to avoid two concurrent threads flushing same group */
+		list_del_init(&lg->lg_list);
+
+		spin_unlock(&inode_lock);
+
+		clear_bit(EXT4_LG_DIRTY, &lg->lg_flags);
+		rc = ext4_lg_sync_single_group(sb, lg, wbc, start);
+
+		spin_lock(&inode_lock);
+		ext4_lg_put_group(lg);
+
+		if (rc == EXT4_STOP_WRITEBACK)
+			break;
+	}
+	spin_unlock(&inode_lock);
+}
+
+/*
+ * entry function for inode syncing
+ * it's responsbility is to sort all inode out in their locality groups
+ */
+void ext4_lg_sync_inodes(struct super_block *sb, struct writeback_control *wbc)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_locality_group *lg;
+
+	/* refill pending groups from s_dirty */
+	spin_lock(&inode_lock);
+	while (!list_empty(&sb->s_dirty)) {
+		struct inode *inode = list_entry(sb->s_dirty.prev,
+						struct inode, i_list);
+		struct ext4_inode_info *ei = EXT4_I(inode);
+
+		lg = ei->i_locality_group;
+		if (lg == NULL) {
+			if (S_ISDIR(inode->i_mode) || i_size_read(inode) == 0) {
+				if (atomic_read(&inode->i_count)) {
+					/*
+					 * The inode is clean, inuse
+					 */
+					list_move(&inode->i_list, &inode_in_use);
+				} else {
+					/*
+					 * The inode is clean, unused
+					 */
+					list_move(&inode->i_list, &inode_unused);
+				}
+				continue;
+			}
+			/* XXX: atime changed ? or mmap? 
+			 * anyway, assign the inode to anonymous group */
+			lg = sbi->s_locality_anon;
+			atomic_inc(&lg->lg_count);
+			lg = ext4_lg_assign_to_group_nolock(inode, lg);
+		}
+
+		/* move inode in proper locality group's dirty list */
+		spin_lock(&lg->lg_lock);
+		list_move_tail(&inode->i_list, &lg->lg_dirty);
+		spin_unlock(&lg->lg_lock);
+
+		if (!test_and_set_bit(EXT4_LG_DIRTY, &lg->lg_flags))
+			list_move(&lg->lg_list, &sbi->s_locality_dirty);
+	}
+	spin_unlock(&inode_lock);
+
+	ext4_lg_sync_groups(sb, wbc);
+}
+
+void ext4_lg_init(struct super_block *sb)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_locality_group *lg;
+
+	sb->s_flags |= 2048; /* XXX: i'll fix this, i promise */
+	spin_lock_init(&sbi->s_locality_lock);
+	INIT_LIST_HEAD(&sbi->s_locality_groups);
+	INIT_LIST_HEAD(&sbi->s_locality_dirty);
+	INIT_LIST_HEAD(&sbi->s_locality_io);
+
+	lg = ext4_lg_new_group(sb);
+	if (lg != NULL)
+		sbi->s_locality_anon = lg;
+}
+
+void ext4_lg_release(struct super_block *sb)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_locality_group *lg;
+	struct list_head *cur, *tmp;
+
+	list_for_each_safe_rcu(cur, tmp, &sbi->s_locality_groups) {
+		lg = list_entry(cur, struct ext4_locality_group, lg_hash);
+		if (atomic_read(&lg->lg_count))
+			printk("LG %p/%d (pgid %u), %u inodes, dirty %d, non-allocated %d\n",
+				lg, atomic_read(&lg->lg_count),
+				atomic_read(&lg->lg_inodes_nr), lg->lg_pgid,
+				atomic_read(&lg->lg_dirty_pages),
+				atomic_read(&lg->lg_nonallocated));
+		list_del(&lg->lg_hash);
+		kfree(lg);
+	}
+	lg = sbi->s_locality_anon;
+	if (lg) {
+		if (atomic_read(&lg->lg_count) > 1)
+			printk("LG anon/%d, %u inodes, dirty %d, non-allocated %d\n",
+				atomic_read(&lg->lg_count),
+				atomic_read(&lg->lg_inodes_nr),
+				atomic_read(&lg->lg_dirty_pages),
+				atomic_read(&lg->lg_nonallocated));
+		kfree(lg);
+	}
+}
+
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 5bd2762..efc9270 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -452,6 +452,7 @@ static void ext4_put_super (struct super_block * sb)
 		mark_buffer_dirty(sbi->s_sbh);
 		ext4_commit_super(sb, es, 1);
 	}
+	ext4_lg_release(sb);
 
 	for (i = 0; i < sbi->s_gdb_count; i++)
 		brelse(sbi->s_group_desc[i]);
@@ -501,6 +502,7 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	ei = kmem_cache_alloc(ext4_inode_cachep, GFP_NOFS);
 	if (!ei)
 		return NULL;
+	ei->i_locality_group = NULL;
 #ifdef CONFIG_EXT4DEV_FS_POSIX_ACL
 	ei->i_acl = EXT4_ACL_NOT_CACHED;
 	ei->i_default_acl = EXT4_ACL_NOT_CACHED;
@@ -571,6 +573,7 @@ static void ext4_clear_inode(struct inode *inode)
 	EXT4_I(inode)->i_block_alloc_info = NULL;
 	if (unlikely(rsv))
 		kfree(rsv);
+	ext4_lg_inode_leave_group(inode);
 }
 
 static inline void ext4_show_quota_options(struct seq_file *seq, struct super_block *sb)
@@ -713,6 +716,7 @@ static const struct super_operations ext4_sops = {
 	.remount_fs	= ext4_remount,
 	.clear_inode	= ext4_clear_inode,
 	.show_options	= ext4_show_options,
+	.sync_inodes	= ext4_lg_sync_inodes,
 #ifdef CONFIG_QUOTA
 	.quota_read	= ext4_quota_read,
 	.quota_write	= ext4_quota_write,
@@ -1960,6 +1964,7 @@ static int ext4_fill_super (struct super_block *sb, void *data, int silent)
 		test_opt(sb,DATA_FLAGS) == EXT4_MOUNT_ORDERED_DATA ? "ordered":
 		"writeback");
 
+	ext4_lg_init(sb);
 	ext4_ext_init(sb);
 	ext4_reserve_init(sb);
 	ext4_wb_init(sb);
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index cdcff8c..7806778 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -149,8 +149,7 @@ static int write_inode(struct inode *inode, int sync)
  *
  * Called under inode_lock.
  */
-static int
-__sync_single_inode(struct inode *inode, struct writeback_control *wbc)
+int __sync_single_inode(struct inode *inode, struct writeback_control *wbc)
 {
 	unsigned dirty;
 	struct address_space *mapping = inode->i_mapping;
@@ -240,8 +239,7 @@ __sync_single_inode(struct inode *inode, struct writeback_control *wbc)
  * caller has ref on the inode (either via __iget or via syscall against an fd)
  * or the inode has I_WILL_FREE set (via generic_forget_inode)
  */
-static int
-__writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
+int __writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 {
 	wait_queue_head_t *wqh;
 
@@ -440,7 +438,7 @@ writeback_inodes(struct writeback_control *wbc)
 restart:
 	sb = sb_entry(super_blocks.prev);
 	for (; sb != sb_entry(&super_blocks); sb = sb_entry(sb->s_list.prev)) {
-		if (!list_empty(&sb->s_dirty) || !list_empty(&sb->s_io)) {
+		if (!list_empty(&sb->s_dirty) || !list_empty(&sb->s_io) || (sb->s_flags & 2048)) {
 			/* we're making our own get_super here */
 			sb->s_count++;
 			spin_unlock(&sb_lock);
diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
index 138fcbc..cd477e2 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -824,6 +824,34 @@ struct dx_hash_info
 
 
 /*
+ * Locality group:
+ *   we try to group all related changes together
+ *   so that writeback can flush/allocate them together as well
+ */
+struct ext4_locality_group {
+	int			lg_parent;
+	int			lg_pgid;
+	int			lg_sid;
+	struct list_head	lg_hash;
+	spinlock_t		lg_lock;
+	int			lg_deleted;
+	atomic_t		lg_count;
+	atomic_t		lg_inodes_nr;
+
+	/* */
+	unsigned long		lg_flags;
+	struct list_head	lg_list;
+
+	/* inode lists for the group */
+	struct list_head	lg_inodes;	/* inodes in the group */
+	struct list_head	lg_dirty;	/* dirty inodes from s_dirty */
+	struct list_head	lg_io;		/* inodes scheduled for flush */
+
+	atomic_t		lg_dirty_pages;	/* pages to write */
+	atomic_t		lg_nonallocated;/* non-allocated pages */
+};
+
+/*
  * Describe an inode's exact location on disk and in memory
  */
 struct ext4_iloc
@@ -881,6 +909,15 @@ void ext4_get_group_no_and_offset(struct super_block *sb, ext4_fsblk_t blocknr,
 # define ATTRIB_NORET	__attribute__((noreturn))
 # define NORET_AND	noreturn,
 
+/* lg.c */
+extern void ext4_lg_init(struct super_block *sb);
+extern void ext4_lg_release(struct super_block *sb);
+extern void ext4_lg_inode_leave_group(struct inode *inode);
+extern void ext4_lg_page_enter_inode(struct inode *inode, struct page *page, int allocated);
+extern void ext4_lg_page_leave_inode(struct inode *inode, struct page *page, int allocated);
+extern void ext4_lg_sync_inodes(struct super_block *, struct writeback_control *);
+
+
 /* balloc.c */
 extern unsigned int ext4_block_group(struct super_block *sb,
 			ext4_fsblk_t blocknr);
diff --git a/include/linux/ext4_fs_i.h b/include/linux/ext4_fs_i.h
index 9dea1f7..6d9f9db 100644
--- a/include/linux/ext4_fs_i.h
+++ b/include/linux/ext4_fs_i.h
@@ -150,6 +150,8 @@ struct ext4_inode_info {
 	 */
 	struct mutex truncate_mutex;
 	struct inode vfs_inode;
+	struct list_head i_lg_list;
+	struct ext4_locality_group *i_locality_group;
 
 	unsigned long i_ext_generation;
 	struct ext4_ext_cache i_cached_extent;
diff --git a/include/linux/ext4_fs_sb.h b/include/linux/ext4_fs_sb.h
index 9768b32..08b0645 100644
--- a/include/linux/ext4_fs_sb.h
+++ b/include/linux/ext4_fs_sb.h
@@ -86,6 +86,12 @@ struct ext4_sb_info {
 #endif
 	unsigned int s_want_extra_isize; /* New inodes should reserve # bytes */
 
+	struct ext4_locality_group *s_locality_anon;
+	struct list_head s_locality_dirty;
+	struct list_head s_locality_io;
+	struct list_head s_locality_groups;
+	spinlock_t s_locality_lock;
+
 #ifdef EXTENTS_STATS
 	/* ext4 extents stats */
 	unsigned long s_ext_min;
-- 
1.5.3.rc0.30.g114fd-dirty
