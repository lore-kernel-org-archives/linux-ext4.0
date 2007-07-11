From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Reserve blocks for delayed allocation
Date: Wed, 11 Jul 2007 16:24:47 +0530
Message-ID: <118415129681-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1184151287237-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: cmm@us.ibm.com, Alex Tomas <alex@clusterfs.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:59185 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760498AbXGKK4S (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Jul 2007 06:56:18 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp04.au.ibm.com (8.13.8/8.13.8) with ESMTP id l6BBIxtn250372
	for <linux-ext4@vger.kernel.org>; Wed, 11 Jul 2007 21:18:59 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.250.244])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l6BAwUYQ071432
	for <linux-ext4@vger.kernel.org>; Wed, 11 Jul 2007 20:58:31 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6BAsvTa012085
	for <linux-ext4@vger.kernel.org>; Wed, 11 Jul 2007 20:54:58 +1000
In-Reply-To: <1184151287237-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Alex Tomas <alex@clusterfs.com>

We need to reserve blocks for delayed allocation,
otherwise we could meet -ENOSPC at flush time

This is scalable free space management. Every time we
delay allocation of some page, a space (including metadata)
should be reserved

Signed-off-by: Alex Tomas <alex@clusterfs.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/balloc.c           |  180 +++++++++++++++++++++++++++++++++++++++++++-
 fs/ext4/super.c            |    2 +
 include/linux/ext4_fs.h    |    5 +
 include/linux/ext4_fs_sb.h |    5 +
 4 files changed, 189 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index edde262..6a7f383 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -630,8 +630,10 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 		return;
 	}
 	ext4_free_blocks_sb(handle, sb, block, count, &dquot_freed_blocks);
-	if (dquot_freed_blocks)
+	if (dquot_freed_blocks) {
+		ext4_release_blocks(sb, dquot_freed_blocks);
 		DQUOT_FREE_BLOCK(inode, dquot_freed_blocks);
+	}
 	return;
 }
 
@@ -1440,7 +1442,7 @@ ext4_fsblk_t ext4_new_blocks(handle_t *handle, struct inode *inode,
 	struct ext4_sb_info *sbi;
 	struct ext4_reserve_window_node *my_rsv = NULL;
 	struct ext4_block_alloc_info *block_i;
-	unsigned short windowsz = 0;
+	unsigned short windowsz = 0, reserved = 0;
 #ifdef EXT4FS_DEBUG
 	static int goal_hits, goal_attempts;
 #endif
@@ -1462,6 +1464,13 @@ ext4_fsblk_t ext4_new_blocks(handle_t *handle, struct inode *inode,
 		return 0;
 	}
 
+	if (!(EXT4_I(inode)->i_state & EXT4_STATE_BLOCKS_RESERVED)) {
+		*errp = ext4_reserve_blocks(sb, num);
+		if (*errp)
+			return 0;
+		reserved = num;
+	}
+
 	sbi = EXT4_SB(sb);
 	es = EXT4_SB(sb)->s_es;
 	ext4_debug("goal=%lu.\n", goal);
@@ -1674,8 +1683,11 @@ out:
 	/*
 	 * Undo the block allocation
 	 */
-	if (!performed_allocation)
+	if (!performed_allocation) {
 		DQUOT_FREE_BLOCK(inode, *count);
+		if (reserved)
+			ext4_release_blocks(sb, reserved);
+	}
 	brelse(bitmap_bh);
 	return 0;
 }
@@ -1834,3 +1846,165 @@ unsigned long ext4_bg_num_gdb(struct super_block *sb, int group)
 	return ext4_bg_num_gdb_meta(sb,group);
 
 }
+
+/*
+ * we need reserve blocs for delayed allocation, otherwise we
+ * could meet -ENOSPC at flush time
+ * as ->commit_write() where we're going to reserve
+ * non-allocated-yet blocks is well known hotpath,
+ * we have to make it scalable and avoid global
+ * data as much as possible
+ *
+ * there is per-sb array
+ */
+
+struct ext4_reservation_slot {
+	__u64		rs_reserved;
+	spinlock_t	rs_lock;
+} ____cacheline_aligned;
+
+
+int ext4_reserve_local(struct super_block *sb, int blocks)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_reservation_slot *rs;
+	int rc = -ENOSPC;
+
+	preempt_disable();
+	rs = sbi->s_reservation_slots + smp_processor_id();
+
+	spin_lock(&rs->rs_lock);
+	if (likely(rs->rs_reserved >= blocks)) {
+		rs->rs_reserved -= blocks;
+		rc = 0;
+	}
+	spin_unlock(&rs->rs_lock);
+
+	preempt_enable();
+	return rc;
+}
+
+
+void ext4_rebalance_reservation(struct ext4_reservation_slot *rs, __u64 free)
+{
+	int i, total_cpus;
+	__u64 chunk;
+
+	total_cpus = num_online_cpus();
+
+	/*
+	 * Calculate each cpu chunk rounding
+	 * to upper value
+	 */
+	chunk = free + total_cpus -1;
+	do_div(chunk, total_cpus);
+
+	for_each_online_cpu(i) {
+
+		if (free < chunk)
+			chunk = free;
+
+		rs[i].rs_reserved = chunk;
+		free -= chunk;
+		BUG_ON(free < 0);
+	}
+	BUG_ON(free);
+}
+
+int ext4_reserve_global(struct super_block *sb, int blocks)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_reservation_slot *rs;
+	int i, rc = -ENOENT;
+	__u64 free = 0;
+
+	rs = sbi->s_reservation_slots;
+
+	for_each_online_cpu(i) {
+		spin_lock(&rs[i].rs_lock);
+		free += rs[i].rs_reserved;
+	}
+
+	if (free >= blocks) {
+		free -= blocks;
+		/* rebalance the free blocks */
+		ext4_rebalance_reservation(rs, free);
+		rc = 0;
+	}
+
+	for_each_online_cpu(i) {
+		spin_unlock(&rs[i].rs_lock);
+	}
+
+	return rc;
+}
+
+int ext4_reserve_blocks(struct super_block *sb, int blocks)
+{
+	int ret;
+
+	BUG_ON(blocks <= 0);
+
+	ret = ext4_reserve_local(sb, blocks);
+	if (likely(ret == 0))
+		return 0;
+
+	return ext4_reserve_global(sb, blocks);
+}
+
+void ext4_release_blocks(struct super_block *sb, int blocks)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_reservation_slot *rs;
+
+	BUG_ON(blocks <= 0);
+
+	preempt_disable();
+	rs = sbi->s_reservation_slots + smp_processor_id();
+
+	spin_lock(&rs->rs_lock);
+	rs->rs_reserved += blocks;
+	spin_unlock(&rs->rs_lock);
+
+	preempt_enable();
+}
+
+int ext4_reserve_init(struct super_block *sb)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_reservation_slot *rs;
+	__u64  reserved
+	int i;
+
+	/* Allocate for all the possible CPUs */
+	rs = alloc_percpu(struct ext4_reservation_slot);
+	if (rs == NULL)
+		return -ENOMEM;
+
+	for_each_possible_cpu(i) {
+		spin_lock_init(&rs[i].rs_lock);
+		rs[i].rs_reserved = 0;
+	}
+
+	/*
+	 * The first miss on other CPUs
+	 * will rebalance this
+	 */
+	rs[0].rs_reserved = percpu_counter_sum(&sbi->s_freeblocks_counter);
+
+	sbi->s_reservation_slots = rs;
+
+	return 0;
+}
+
+void ext4_reserve_release(struct super_block *sb)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_reservation_slot *rs;
+
+	rs = sbi->s_reservation_slots;
+	BUG_ON(sbi->s_reservation_slots == NULL);
+	kfree(sbi->s_reservation_slots);
+	sbi->s_reservation_slots = NULL;
+}
+
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 44505a5..843603f 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -440,6 +440,7 @@ static void ext4_put_super (struct super_block * sb)
 	struct ext4_super_block *es = sbi->s_es;
 	int i;
 
+	ext4_reserve_release(sb);
 	ext4_ext_release(sb);
 	ext4_xattr_put_super(sb);
 	jbd2_journal_destroy(sbi->s_journal);
@@ -1939,6 +1940,7 @@ static int ext4_fill_super (struct super_block *sb, void *data, int silent)
 		"writeback");
 
 	ext4_ext_init(sb);
+	ext4_reserve_init(sb);
 
 	lock_kernel();
 	return 0;
diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
index 5d717ed..4a7fcad 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -203,6 +203,7 @@ struct ext4_group_desc
 #define EXT4_STATE_NEW			0x00000002 /* inode is newly created */
 #define EXT4_STATE_XATTR		0x00000004 /* has in-inode xattrs */
 #define EXT4_STATE_NO_EXPAND		0x00000008 /* No space for expansion */
+#define EXT4_STATE_BLOCKS_RESERVED	0x00000010 /* blocks reserved */
 
 /* Used to pass group descriptor data when online resize is done */
 struct ext4_new_group_input {
@@ -901,6 +902,10 @@ extern struct ext4_group_desc * ext4_get_group_desc(struct super_block * sb,
 extern int ext4_should_retry_alloc(struct super_block *sb, int *retries);
 extern void ext4_init_block_alloc_info(struct inode *);
 extern void ext4_rsv_window_add(struct super_block *sb, struct ext4_reserve_window_node *rsv);
+int ext4_reserve_init(struct super_block *sb);
+void ext4_reserve_release(struct super_block *sb);
+void ext4_release_blocks(struct super_block *sb, int blocks);
+int ext4_reserve_blocks(struct super_block *sb, int blocks);
 
 /* dir.c */
 extern int ext4_check_dir_entry(const char *, struct inode *,
diff --git a/include/linux/ext4_fs_sb.h b/include/linux/ext4_fs_sb.h
index c9dc1d7..6923f65 100644
--- a/include/linux/ext4_fs_sb.h
+++ b/include/linux/ext4_fs_sb.h
@@ -24,6 +24,8 @@
 #endif
 #include <linux/rbtree.h>
 
+struct ext4_reservation_slot;
+
 /*
  * third extended-fs super-block data in memory
  */
@@ -65,6 +67,9 @@ struct ext4_sb_info {
 	struct rb_root s_rsv_window_root;
 	struct ext4_reserve_window_node s_rsv_window_head;
 
+	/* global reservation structures */
+	struct ext4_reservation_slot *s_reservation_slots;
+
 	/* Journaling */
 	struct inode * s_journal_inode;
 	struct journal_s * s_journal;
-- 
1.5.3.rc0.63.gc956-dirty
