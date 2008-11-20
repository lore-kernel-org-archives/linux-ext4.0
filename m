From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 1/5] ext4: unlock group before ext4_error
Date: Thu, 20 Nov 2008 23:56:18 +0530
Message-ID: <1227205580-27596-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:54532 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038AbYKTSaN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Nov 2008 13:30:13 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id mAKITNAs018886
	for <linux-ext4@vger.kernel.org>; Fri, 21 Nov 2008 05:29:23 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mAKIQQRh141848
	for <linux-ext4@vger.kernel.org>; Fri, 21 Nov 2008 05:26:26 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mAKIQPRr015876
	for <linux-ext4@vger.kernel.org>; Fri, 21 Nov 2008 05:26:26 +1100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Otherwise ext4_error will cause BUG because of
scheduling in atomic context.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/mballoc.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 772e05b..039a5a6 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -460,10 +460,12 @@ static void mb_free_blocks_double(struct inode *inode, struct ext4_buddy *e4b,
 			blocknr +=
 			    le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block);
 
+			ext4_unlock_group(sb, e4b->bd_group);
 			ext4_error(sb, __func__, "double-free of inode"
 				   " %lu's block %llu(bit %u in group %u)\n",
 				   inode ? inode->i_ino : 0, blocknr,
 				   first + i, e4b->bd_group);
+			ext4_unlock_group(sb, e4b->bd_group);
 		}
 		mb_clear_bit(first + i, e4b->bd_info->bb_bitmap);
 	}
@@ -704,6 +706,7 @@ static void ext4_mb_generate_buddy(struct super_block *sb,
 	grp->bb_fragments = fragments;
 
 	if (free != grp->bb_free) {
+		ext4_unlock_group(sb, group);
 		ext4_error(sb, __func__,
 			"EXT4-fs: group %u: %u blocks in bitmap, %u in gd\n",
 			group, free, grp->bb_free);
@@ -711,6 +714,7 @@ static void ext4_mb_generate_buddy(struct super_block *sb,
 		 * If we intent to continue, we consider group descritor
 		 * corrupt and update bb_free using bitmap value
 		 */
+		ext4_lock_group(sb, group);
 		grp->bb_free = free;
 	}
 
@@ -1625,15 +1629,18 @@ static void ext4_mb_complex_scan_group(struct ext4_allocation_context *ac,
 			 * free blocks even though group info says we
 			 * we have free blocks
 			 */
+			ext4_unlock_group(sb, e4b->bd_group);
 			ext4_error(sb, __func__, "%d free blocks as per "
 					"group info. But bitmap says 0\n",
 					free);
+			ext4_lock_group(sb, e4b->bd_group);
 			break;
 		}
 
 		mb_find_extent(e4b, 0, i, ac->ac_g_ex.fe_len, &ex);
 		BUG_ON(ex.fe_len <= 0);
 		if (free < ex.fe_len) {
+			ext4_unlock_group(sb, e4b->bd_group);
 			ext4_error(sb, __func__, "%d free blocks as per "
 					"group info. But got %d blocks\n",
 					free, ex.fe_len);
@@ -1642,6 +1649,7 @@ static void ext4_mb_complex_scan_group(struct ext4_allocation_context *ac,
 			 * indicate that the bitmap is corrupt. So exit
 			 * without claiming the space.
 			 */
+			ext4_lock_group(sb, e4b->bd_group);
 			break;
 		}
 
@@ -3789,6 +3797,7 @@ ext4_mb_release_inode_pa(struct ext4_buddy *e4b, struct buffer_head *bitmap_bh,
 		bit = next + 1;
 	}
 	if (free != pa->pa_free) {
+		ext4_unlock_group(sb, group);
 		printk(KERN_CRIT "pa %p: logic %lu, phys. %lu, len %lu\n",
 			pa, (unsigned long) pa->pa_lstart,
 			(unsigned long) pa->pa_pstart,
@@ -3799,6 +3808,7 @@ ext4_mb_release_inode_pa(struct ext4_buddy *e4b, struct buffer_head *bitmap_bh,
 		 * pa is already deleted so we use the value obtained
 		 * from the bitmap and continue.
 		 */
+		ext4_lock_group(sb, group);
 	}
 	atomic_add(free, &sbi->s_mb_discarded);
 
@@ -4607,9 +4617,11 @@ ext4_mb_free_metadata(handle_t *handle, struct ext4_buddy *e4b,
 		else if (block >= (entry->start_blk + entry->count))
 			n = &(*n)->rb_right;
 		else {
+			ext4_unlock_group(sb, e4b->bd_group);
 			ext4_error(sb, __func__,
 			    "Double free of blocks %d (%d %d)\n",
 			    block, entry->start_blk, entry->count);
+			ext4_unlock_group(sb, e4b->bd_group);
 			return 0;
 		}
 	}
-- 
1.6.0.4.735.gea4f

