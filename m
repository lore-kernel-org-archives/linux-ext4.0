From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: ext4-block-reservation.patch
Date: Tue, 19 Jun 2007 22:38:06 +0530
Message-ID: <46780D76.9040706@linux.vnet.ibm.com>
References: <4677B00A.3010600@linux.vnet.ibm.com> <4677F0B3.4050805@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000301040802040601080309"
Cc: alex@clusterfs.com, linux-ext4 <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:50944 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760593AbXFSRIS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Jun 2007 13:08:18 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp06.au.ibm.com (8.13.8/8.13.8) with ESMTP id l5JH9MQI8872112
	for <linux-ext4@vger.kernel.org>; Wed, 20 Jun 2007 03:09:22 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.250.244])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5JHBlRe194146
	for <linux-ext4@vger.kernel.org>; Wed, 20 Jun 2007 03:11:47 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5JH8FcO014140
	for <linux-ext4@vger.kernel.org>; Wed, 20 Jun 2007 03:08:15 +1000
In-Reply-To: <4677F0B3.4050805@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is a multi-part message in MIME format.
--------------000301040802040601080309
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit



Eric Sandeen wrote:
> Aneesh Kumar K.V wrote:
>> Hi,
>>
>> In block reservation code while rebalancing the free blocks why are we not 
>> looking at the reservation slots that have no free blocks left.  Rebalancing
>> the free blocks equally across all the reservation slots will make sure
>> we have less chances of failure later when we try to reserve blocks. 
>>
>>
>> I understand that we consider the CPU slot on which reservation failed while
>> rebalancing. But what is preventing considering other CPU slot that might have
>> zero blocks left ?
>>
>>
>>
>>
>> +void ext4_rebalance_reservation(struct ext4_reservation_slot *rs, __u64 free)
>> +{
>> +       int i, used_slots = 0;
>> +       __u64 chunk;
>> +
>> +       /* let's know what slots have been used */
>> +       for (i = 0; i < NR_CPUS; i++)
> 
> BTW... I think you really want:
> 
>   +       for_each_possible_cpu(i) {
> 
> in this and other similar places.
> 
> NR_CPUS is a config-time option that may be much more than your actual
> count of runtime possible CPUs... on ia64 it's 512 by default, for
> example.  That's a lot of pointlessness on a 2, 4 or 8 cpu box :)
> 
> I can whip up a proper patch for current code to send (again)...
> 

This is what i have modified. I am yet to build test it. I am looking at forward porting the
mballoc patches and was planning to send it together.

-aneesh

--------------000301040802040601080309
Content-Type: text/x-patch;
 name="0001-RFC-delayed-allocation-for-ext4.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0001-RFC-delayed-allocation-for-ext4.patch"

>From 12a6e86df40b258c91883b4436a2e2e0d588cda7 Mon Sep 17 00:00:00 2001
From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date: Tue, 19 Jun 2007 22:25:45 +0530
Subject: [PATCH] [RFC] delayed allocation for ext4

ext4-block-reservation.patch

this is scalable free space management. every time we
delay allocation of some page, a space (including metadata)
should be reserved

From: Alex Tomas <alex@clusterfs.com>
---
 fs/ext4/balloc.c           |  178 +++++++++++++++++++++++++++++++++++++++++++-
 fs/ext4/super.c            |    2 +
 include/linux/ext4_fs.h    |    5 +
 include/linux/ext4_fs_sb.h |    5 +
 4 files changed, 187 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index edde262..ad3f57c 100644
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
@@ -1834,3 +1846,163 @@ unsigned long ext4_bg_num_gdb(struct super_block *sb, int group)
 	return ext4_bg_num_gdb_meta(sb,group);
 
 }
+
+/*
+ * reservation.c contains routines to reserve blocks.
+ * we need this for delayed allocation, otherwise we
+ * could meet -ENOSPC at flush time
+ */
+
+/*
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
+	int i, used_slots = 0;
+	__u64 chunk;
+
+	/* let's know what slots have been used */
+	for_each_possible_cpu(i) {
+		if (rs[i].rs_reserved || i == smp_processor_id())
+			used_slots++;
+	}
+
+	/* chunk is a number of block every used
+	 * slot will get. make sure it isn't 0 */
+	chunk = free + used_slots - 1;
+	do_div(chunk, used_slots);
+
+	for_each_possible_cpu(i) {
+		if (free < chunk)
+			chunk = free;
+		if (rs[i].rs_reserved || i == smp_processor_id()) {
+			rs[i].rs_reserved = chunk;
+			free -= chunk;
+			BUG_ON(free < 0);
+		}
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
+	/* lock all slots */
+	for_each_possible_cpu(i) {
+		spin_lock(&rs[i].rs_lock);
+		free += rs[i].rs_reserved;
+	}
+
+	if (free >= blocks) {
+		free -= blocks;
+		ext4_rebalance_reservation(rs, free);
+		rc = 0;
+	}
+
+	for_each_possible_cpu(i) {
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
+	int i;
+
+	rs = percpu_alloc(sizeof(struct ext4_reservation_slot), GFP_KERNEL);
+	if (rs == NULL)
+		return -ENOMEM;
+	sbi->s_reservation_slots = rs;
+
+	for_each_possible_cpu(i) {
+		spin_lock_init(&rs[i].rs_lock);
+		rs[i].rs_reserved = 0;
+	}
+	rs[0].rs_reserved = percpu_counter_sum(&sbi->s_freeblocks_counter);
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
index 9013018..8abd919 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -439,6 +439,7 @@ static void ext4_put_super (struct super_block * sb)
 	struct ext4_super_block *es = sbi->s_es;
 	int i;
 
+	ext4_reserve_release(sb);
 	ext4_ext_release(sb);
 	ext4_xattr_put_super(sb);
 	jbd2_journal_destroy(sbi->s_journal);
@@ -1917,6 +1918,7 @@ static int ext4_fill_super (struct super_block *sb, void *data, int silent)
 		"writeback");
 
 	ext4_ext_init(sb);
+	ext4_reserve_init(sb);
 
 	lock_kernel();
 	return 0;
diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
index 009dccf..fac942a 100644
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
1.5.2.2.238.g7cbf2f2-dirty


--------------000301040802040601080309--
