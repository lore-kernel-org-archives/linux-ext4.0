From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: patch queue update
Date: Thu, 10 Jan 2008 21:03:58 +0530
Message-ID: <20080110153358.GA9367@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:40244 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755408AbYAJPeJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Jan 2008 10:34:09 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id m0AFXqHl021397
	for <linux-ext4@vger.kernel.org>; Fri, 11 Jan 2008 02:33:52 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m0AFbh3t223348
	for <linux-ext4@vger.kernel.org>; Fri, 11 Jan 2008 02:37:43 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m0AFY6j5029646
	for <linux-ext4@vger.kernel.org>; Fri, 11 Jan 2008 02:34:06 +1100
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Mingming,

New patches for patch queue can be found at
http://www.radian.org/~kvaneesh/ext4/jan-10-2008-ver2/

The changes are
------------
a) mballoc patch got an explanation about regular allocator.
b) mballoc regular allocator we changed the usage of ffs to fls. I guess
it makes sense to use fls because we want to compare it against the
tunable s_mb_order2_reqs. Only request above this order are using
criteria 0 allocation.
c) stripe.patch to use the stripe size set in the super block for block
allocation.

The diff is attached for reference.

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 0d31817..0085fde 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -468,7 +468,6 @@ static void ext4_mb_free_committed_blocks(struct super_block *);
 static void ext4_mb_return_to_preallocation(struct inode *inode,
 					struct ext4_buddy *e4b, sector_t block,
 					int count);
-static void ext4_mb_show_ac(struct ext4_allocation_context *ac);
 static void ext4_mb_put_pa(struct ext4_allocation_context *, struct super_block *,
 						struct ext4_prealloc_space *pa);
 static int ext4_mb_init_per_dev_proc(struct super_block *sb);
@@ -1838,14 +1837,23 @@ static int ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
 	if (unlikely(ac->ac_flags & EXT4_MB_HINT_GOAL_ONLY))
 		goto out;
 
-	i = ffs(ac->ac_g_ex.fe_len);
+	/*
+	 * ac->ac2_order is set only if the fe_len is a power of 2
+	 * if ac2_order is set we also set criteria to 0 so whtat we
+	 * try exact allocation using buddy.
+	 */
+	i = fls(ac->ac_g_ex.fe_len);
 	ac->ac_2order = 0;
-	/* FIXME!!
-	 * What happens if i is still greater than s_mb_order2_reqs
+	/*
+	 * We search using buddy data only if the order of the request
+	 * is greater than equal to the sbi_s_mb_order2_reqs
+	 * You can tune it via /proc/fs/ext4/<partition>/order2_req
 	 */
 	if (i >= sbi->s_mb_order2_reqs) {
-		i--;
-		if ((ac->ac_g_ex.fe_len & (~(1 << i))) == 0)
+		/*
+		 * This should tell if fe_len is exactly power of 2
+		 */
+		if ((ac->ac_g_ex.fe_len & (~(1 << (i - 1)))) == 0)
 			ac->ac_2order = i;
 	}
 
@@ -1865,17 +1873,17 @@ static int ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
 		spin_unlock(&sbi->s_md_lock);
 	}
 
+	/* searching for the right group start from the goal value specified */
 	group = ac->ac_g_ex.fe_group;
 
 	/* Let's just scan groups to find more-less suitable blocks */
 	cr = ac->ac_2order ? 0 : 1;
+	/*
+	 * cr == 0 try to get exact allocation,
+	 * cr == 3  try to get anything
+	 */
 repeat:
 	for (; cr < 4 && ac->ac_status == AC_STATUS_CONTINUE; cr++) {
-		/* FIXME!!
-		 * We need to explain what criteria is and also
-		 * need to define the number 0 to 4 for criteria
-		 * What they actually means.
-		 */
 		ac->ac_criteria = cr;
 		for (i = 0; i < EXT4_SB(sb)->s_groups_count; group++, i++) {
 			struct ext4_group_info *grp;
@@ -1889,23 +1897,28 @@ repeat:
 			if (grp->bb_free == 0)
 				continue;
 
+			/*
+			 * if the group is already init we check whether it is
+			 * a good group and if not we don't load the buddy
+			 */
 			if (EXT4_MB_GRP_NEED_INIT(EXT4_GROUP_INFO(sb, group))) {
-				/* we need full data about the group
-				 * to make a good selection */
+				/*
+				 * we need full data about the group
+				 * to make a good selection
+				 */
 				err = ext4_mb_load_buddy(sb, group, &e4b);
 				if (err)
 					goto out;
 				ext4_mb_release_desc(&e4b);
 			}
 
-			/* check is group good for our criteries */
+			/*
+			 * If the particular group doesn't satisfy our
+			 * criteria we continue with the next group
+			 */
 			if (!ext4_mb_good_group(ac, group, cr))
 				continue;
 
-			/* FIXME!!
-			 * here also we are loading the buddy. so what difference
-			 * does EXT4_MB_GRP_NEED_INIT actually make
-			 */
 			err = ext4_mb_load_buddy(sb, group, &e4b);
 			if (err)
 				goto out;
@@ -3726,10 +3739,9 @@ repeat:
 		busy = 0;
 		ext4_unlock_group(sb, group);
 		/*
-		 * We see this quiet rare. But if a particular workload is
-		 * effected by this we may need to add a waitqueue
+		 * Yield the CPU here so that we don't get soft lockup
 		 */
-		schedule_timeout(HZ);
+		schedule();
 		goto repeat;
 	}
 
@@ -3808,7 +3820,7 @@ repeat:
 			printk(KERN_ERR "uh-oh! used pa while discarding\n");
 			dump_stack();
 			current->state = TASK_UNINTERRUPTIBLE;
-			schedule();
+			schedule_timeout(HZ);
 			goto repeat;
 
 		}
@@ -3832,8 +3844,12 @@ repeat:
 		 * pa from inode's list may access already
 		 * freed memory, bad-bad-bad */
 
+		/* XXX: if this happens too often, we can
+		 * add a flag to force wait only in case
+		 * of ->clear_inode(), but not in case of
+		 * regular truncate */
 		current->state = TASK_UNINTERRUPTIBLE;
-		schedule();
+		schedule_timeout(HZ);
 		goto repeat;
 	}
 	spin_unlock(&ei->i_prealloc_lock);
@@ -3878,7 +3894,7 @@ static void ext4_mb_return_to_preallocation(struct inode *inode,
 {
 	BUG_ON(!list_empty(&EXT4_I(inode)->i_prealloc_list));
 }
-
+#ifdef MB_DEBUG
 static void ext4_mb_show_ac(struct ext4_allocation_context *ac)
 {
 	struct super_block *sb = ac->ac_sb;
@@ -3928,6 +3944,9 @@ static void ext4_mb_show_ac(struct ext4_allocation_context *ac)
 	}
 	printk(KERN_ERR "\n");
 }
+#else
+#define ext4_mb_show_ac(x)
+#endif
 
 /*
  * We use locality group preallocation for small size file. The size of the
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index c69f4e5..9d91c60 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1775,6 +1775,21 @@ static ext4_fsblk_t descriptor_loc(struct super_block *sb,
 	return (has_super + ext4_group_first_block_no(sb, bg));
 }
 
+static unsigned long ext4_get_stripe_size(struct ext4_sb_info *sbi)
+{
+	unsigned long stride = le16_to_cpu(sbi->s_es->s_raid_stride);
+	unsigned long stripe_width = le32_to_cpu(sbi->s_es->s_raid_stripe_width);
+
+	if (sbi->s_stripe && sbi->s_stripe <= sbi->s_blocks_per_group) {
+		return sbi->s_stripe;
+	} else if (stripe_width <= sbi->s_blocks_per_group) {
+		return stripe_width;
+	} else if (stride <= sbi->s_blocks_per_group) {
+		return stride;
+	}
+
+	return 0;
+}
 
 static int ext4_fill_super (struct super_block *sb, void *data, int silent)
 				__releases(kernel_sem)
@@ -2131,6 +2146,13 @@ static int ext4_fill_super (struct super_block *sb, void *data, int silent)
 	sbi->s_rsv_window_head.rsv_alloc_hit = 0;
 	sbi->s_rsv_window_head.rsv_goal_size = 0;
 	ext4_rsv_window_add(sb, &sbi->s_rsv_window_head);
+	/*
+	 * set the stripe size. If we have specified it via mount option, then
+	 * use the mount option value. If the value specified at mount time is
+	 * greater than the blocks per group use the super block value.
+	 * Allocator needs it be less than blocks per group.
+	 */
+	sbi->s_stripe = ext4_get_stripe_size(sbi);
 
 	/*
 	 * set up enough so that it can read an inode
