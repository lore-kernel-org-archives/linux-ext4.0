From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Don't panic in case of corrupt bitmap
Date: Fri,  8 Feb 2008 12:09:53 +0530
Message-ID: <1202452793-9867-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: tytso@mit.edu, cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:32839 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483AbYBHGj7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Feb 2008 01:39:59 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id m186dlSk026276
	for <linux-ext4@vger.kernel.org>; Fri, 8 Feb 2008 17:39:47 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m186hYBu219860
	for <linux-ext4@vger.kernel.org>; Fri, 8 Feb 2008 17:43:34 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m186duEb009615
	for <linux-ext4@vger.kernel.org>; Fri, 8 Feb 2008 17:39:56 +1100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Multiblock allocator calls BUG_ON in many case if the free and used
blocks count obtained looking at the bitmap is different from what
the allocator internally accounted for. Use ext4_error in such case
and don't panic the system.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/mballoc.c |   35 +++++++++++++++++++++--------------
 1 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 06d1f52..656729b 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -680,7 +680,6 @@ static void *mb_find_buddy(struct ext4_buddy *e4b, int order, int *max)
 {
 	char *bb;
 
-	/* FIXME!! is this needed */
 	BUG_ON(EXT4_MB_BITMAP(e4b) == EXT4_MB_BUDDY(e4b));
 	BUG_ON(max == NULL);
 
@@ -964,7 +963,7 @@ static void ext4_mb_generate_buddy(struct super_block *sb,
 	grp->bb_fragments = fragments;
 
 	if (free != grp->bb_free) {
-		printk(KERN_DEBUG
+		ext4_error(sb, __FUNCTION__,
 			"EXT4-fs: group %lu: %u blocks in bitmap, %u in gd\n",
 			group, free, grp->bb_free);
 		grp->bb_free = free;
@@ -1821,13 +1820,24 @@ static void ext4_mb_complex_scan_group(struct ext4_allocation_context *ac,
 		i = ext4_find_next_zero_bit(bitmap,
 						EXT4_BLOCKS_PER_GROUP(sb), i);
 		if (i >= EXT4_BLOCKS_PER_GROUP(sb)) {
-			BUG_ON(free != 0);
+			/*
+			 * IF we corrupt the bitmap  we won't find any
+			 * free blocks even though group info says we
+			 * we have free blocks
+			 */
+			ext4_error(sb, __FUNCTION__, "%d free blocks as per "
+					"group info. But bitmap says 0\n",
+					free);
 			break;
 		}
 
 		mb_find_extent(e4b, 0, i, ac->ac_g_ex.fe_len, &ex);
 		BUG_ON(ex.fe_len <= 0);
-		BUG_ON(free < ex.fe_len);
+		if (free < ex.fe_len) {
+			ext4_error(sb, __FUNCTION__, "%d free blocks as per "
+					"group info. But got %d blocks\n",
+					free, ex.fe_len);
+		}
 
 		ext4_mb_measure_extent(ac, &ex, e4b);
 
@@ -3354,13 +3364,10 @@ static void ext4_mb_use_group_pa(struct ext4_allocation_context *ac,
 	ac->ac_pa = pa;
 
 	/* we don't correct pa_pstart or pa_plen here to avoid
-	 * possible race when tte group is being loaded concurrently
+	 * possible race when the group is being loaded concurrently
 	 * instead we correct pa later, after blocks are marked
-	 * in on-disk bitmap -- see ext4_mb_release_context() */
-	/*
-	 * FIXME!! but the other CPUs can look at this particular
-	 * pa and think that it have enought free blocks if we
-	 * don't update pa_free here right ?
+	 * in on-disk bitmap -- see ext4_mb_release_context()
+	 * Other CPUs are prevented from allocating from this pa by lg_mutex
 	 */
 	mb_debug("use %u/%u from group pa %p\n", pa->pa_lstart-len, len, pa);
 }
@@ -3743,13 +3750,13 @@ static int ext4_mb_release_inode_pa(struct ext4_buddy *e4b,
 		bit = next + 1;
 	}
 	if (free != pa->pa_free) {
-		printk(KERN_ERR "pa %p: logic %lu, phys. %lu, len %lu\n",
+		printk(KERN_CRIT "pa %p: logic %lu, phys. %lu, len %lu\n",
 			pa, (unsigned long) pa->pa_lstart,
 			(unsigned long) pa->pa_pstart,
 			(unsigned long) pa->pa_len);
-		printk(KERN_ERR "free %u, pa_free %u\n", free, pa->pa_free);
+		ext4_error(sb, __FUNCTION__, "free %u, pa_free %u\n",
+						free, pa->pa_free);
 	}
-	BUG_ON(free != pa->pa_free);
 	atomic_add(free, &sbi->s_mb_discarded);
 
 	return err;
@@ -4405,7 +4412,7 @@ void ext4_mb_free_blocks(handle_t *handle, struct inode *inode,
 			unsigned long block, unsigned long count,
 			int metadata, unsigned long *freed)
 {
-	struct buffer_head *bitmap_bh = 0;
+	struct buffer_head *bitmap_bh = NULL;
 	struct super_block *sb = inode->i_sb;
 	struct ext4_allocation_context ac;
 	struct ext4_group_desc *gdp;
-- 
1.5.4.23.gef5b9-dirty
