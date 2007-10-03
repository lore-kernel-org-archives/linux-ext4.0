From: Avantika Mathur <mathur@linux.vnet.ibm.com>
Subject: [PATCH, RFC 3/3] ext4_grpnum_t: mballoc changes
Date: Tue, 02 Oct 2007 17:33:15 -0700
Message-ID: <4702E34B.6020500@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:37640 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbXJCAce (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Oct 2007 20:32:34 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l930WDMj032716
	for <linux-ext4@vger.kernel.org>; Tue, 2 Oct 2007 20:32:13 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l930WDW6352478
	for <linux-ext4@vger.kernel.org>; Tue, 2 Oct 2007 18:32:13 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l930WDEL024761
	for <linux-ext4@vger.kernel.org>; Tue, 2 Oct 2007 18:32:13 -0600
Received: from [9.47.16.62] (dyn9047016062.beaverton.ibm.com [9.47.16.62])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l930WCDJ024702
	for <linux-ext4@vger.kernel.org>; Tue, 2 Oct 2007 18:32:13 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Ext4: ext4_grpnum_t mballoc.c change
from: mathur@us.ibm.com

Change block group variables to type ext4_grpnum_t in mballoc.c

Signed-off-by: Avantika Mathur <mathur@us.ibm.com>
---
 fs/ext4/mballoc.c |   72 +++++++++++++++++++++++++++---------------------------
 1 file changed, 37 insertions(+), 35 deletions(-)

Index: linux-2.6.23-rc8-new/fs/ext4/mballoc.c
===================================================================
--- linux-2.6.23-rc8-new.orig/fs/ext4/mballoc.c	2007-10-01 15:17:36.000000000 -0700
+++ linux-2.6.23-rc8-new/fs/ext4/mballoc.c	2007-10-01 15:18:04.000000000 -0700
@@ -310,7 +310,7 @@
 #define EXT4_BB_MAX_BLOCKS	30
 
 struct ext4_free_metadata {
-	unsigned short group;
+	ext4_grpnum_t group;
 	unsigned short num;
 	unsigned short blocks[EXT4_BB_MAX_BLOCKS];
 	struct list_head list;
@@ -361,7 +361,7 @@
 struct ext4_free_extent {
 	unsigned long fe_logical;
 	ext4_grpblk_t fe_start;
-	unsigned long fe_group;
+	ext4_grpnum_t fe_group;
 	unsigned long fe_len;
 };
 
@@ -440,7 +440,7 @@
 	struct ext4_group_info *bd_info;
 	struct super_block *bd_sb;
 	__u16 bd_blkbits;
-	__u16 bd_group;
+	ext4_grpnum_t bd_group;
 };
 #define EXT4_MB_BITMAP(e4b)	((e4b)->bd_bitmap)
 #define EXT4_MB_BUDDY(e4b)	((e4b)->bd_buddy)
@@ -462,7 +462,8 @@
 void ext4_mb_release_blocks(struct super_block *, int);
 void ext4_mb_poll_new_transaction(struct super_block *, handle_t *);
 void ext4_mb_free_committed_blocks(struct super_block *);
-void ext4_mb_generate_from_pa(struct super_block *sb, void *bitmap, int group);
+void ext4_mb_generate_from_pa(struct super_block *sb, void *bitmap,
+					ext4_grpnum_t group);
 void ext4_mb_free_consumed_preallocations(struct ext4_allocation_context *ac);
 void ext4_mb_return_to_preallocation(struct inode *inode,
 					struct ext4_buddy *e4b, sector_t block,
@@ -476,21 +477,21 @@
 
 
 static inline void
-ext4_lock_group(struct super_block *sb, int group)
+ext4_lock_group(struct super_block *sb, ext4_grpnum_t group)
 {
 	bit_spin_lock(EXT4_GROUP_INFO_LOCKED_BIT,
 		      &EXT4_GROUP_INFO(sb, group)->bb_state);
 }
 
 static inline void
-ext4_unlock_group(struct super_block *sb, int group)
+ext4_unlock_group(struct super_block *sb, ext4_grpnum_t group)
 {
 	bit_spin_unlock(EXT4_GROUP_INFO_LOCKED_BIT,
 			&EXT4_GROUP_INFO(sb, group)->bb_state);
 }
 
 static inline int
-ext4_is_group_locked(struct super_block *sb, int group)
+ext4_is_group_locked(struct super_block *sb, ext4_grpnum_t group)
 {
 	return bit_spin_is_locked(EXT4_GROUP_INFO_LOCKED_BIT,
 					&EXT4_GROUP_INFO(sb, group)->bb_state);
@@ -630,7 +631,7 @@
 			    le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block);
 
 			ext4_error(sb, __FUNCTION__, "double-free of inode"
-				   " %lu's block %lu(bit %u in group %u)\n",
+				   " %lu's block %lu(bit %u in group %lu)\n",
 				   inode ? inode->i_ino : 0, blocknr,
 				   first + i, e4b->bd_group);
 		}
@@ -660,8 +661,8 @@
 		b2 = (unsigned char *) bitmap;
 		for (i = 0; i < e4b->bd_sb->s_blocksize; i++) {
 			if (b1[i] != b2[i]) {
-				printk("corruption in group %u at byte %u(%u): "
-				       "%x in copy != %x on disk/prealloc\n",
+				printk("corruption in group %lu at byte %u(%u):"
+				       " %x in copy != %x on disk/prealloc\n",
 					e4b->bd_group, i, i * 8, b1[i], b2[i]);
 				BUG();
 			}
@@ -778,7 +779,7 @@
 	grp = EXT4_GROUP_INFO(sb, e4b->bd_group);
 	buddy = mb_find_buddy(e4b, 0, &max);
 	list_for_each(cur, &grp->bb_prealloc_list) {
-		unsigned long groupnr;
+		ext4_grpnum_t groupnr;
 		struct ext4_prealloc_space *pa;
 		pa = list_entry(cur, struct ext4_prealloc_space, group_list);
 		ext4_get_group_no_and_offset(sb, pa->pstart, &groupnr, &k);
@@ -852,7 +853,7 @@
 
 static void
 ext4_mb_generate_buddy(struct super_block *sb, void *buddy, void *bitmap,
-			int group)
+			ext4_grpnum_t group)
 {
 	struct ext4_group_info *grp = EXT4_GROUP_INFO(sb, group);
 	unsigned short max = EXT4_BLOCKS_PER_GROUP(sb);
@@ -883,7 +884,7 @@
 	grp->bb_fragments = fragments;
 
 	if (free != grp->bb_free) {
-		printk("EXT4-fs: group %u: %u blocks in bitmap, %u in gd\n",
+		printk("EXT4-fs: group %lu: %u blocks in bitmap, %u in gd\n",
 			group, free, grp->bb_free);
 		grp->bb_free = free;
 	}
@@ -921,7 +922,7 @@
 	int groups_per_page;
 	int err = 0;
 	int i;
-	int first_group;
+	ext4_grpnum_t first_group;
 	int first_block;
 	struct super_block *sb;
 	struct buffer_head *bhs;
@@ -1062,7 +1063,7 @@
 	return err;
 }
 
-static int ext4_mb_load_buddy(struct super_block *sb, int group,
+static int ext4_mb_load_buddy(struct super_block *sb, ext4_grpnum_t group,
 		struct ext4_buddy *e4b)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
@@ -1073,7 +1074,7 @@
 	int poff;
 	struct page *page;
 
-	mb_debug("load group %u\n", group);
+	mb_debug("load group %lu\n", group);
 
 	blocks_per_page = PAGE_CACHE_SIZE / sb->s_blocksize;
 
@@ -1262,7 +1263,7 @@
 			    le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block);
 
 			ext4_error(sb, __FUNCTION__, "double-free of inode"
-				   " %lu's block %lu(bit %u in group %u)\n",
+				   " %lu's block %lu(bit %u in group %lu)\n",
 				   inode ? inode->i_ino : 0, blocknr, block,
 				   e4b->bd_group);
 		}
@@ -1590,7 +1591,7 @@
 					struct ext4_buddy *e4b)
 {
 	struct ext4_free_extent ex = ac->ac_b_ex;
-	int group = ex.fe_group;
+	ext4_grpnum_t group = ex.fe_group;
 	int max;
 	int err;
 
@@ -1616,7 +1617,7 @@
 static int ext4_mb_find_by_goal(struct ext4_allocation_context *ac,
 				struct ext4_buddy *e4b)
 {
-	int group = ac->ac_g_ex.fe_group;
+	ext4_grpnum_t group = ac->ac_g_ex.fe_group;
 	int max;
 	int err;
 	struct ext4_sb_info *sbi = EXT4_SB(ac->ac_sb);
@@ -1785,7 +1786,7 @@
 }
 
 static int ext4_mb_good_group(struct ext4_allocation_context *ac,
-				int group, int cr)
+				ext4_grpnum_t group, int cr)
 {
 	struct ext4_group_info *grp = EXT4_GROUP_INFO(ac->ac_sb, group);
 	unsigned free;
@@ -1830,8 +1831,8 @@
 
 int ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
 {
-	int group;
-	int i;
+	ext4_grpnum_t group;
+	ext4_grpnum_t i;
 	int cr;
 	int err = 0;
 	struct ext4_sb_info *sbi;
@@ -2176,7 +2177,7 @@
 {
 	struct super_block *sb = seq->private;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
-	long group;
+	ext4_grpnum_t group;
 
 	if (*pos < 0 || *pos >= sbi->s_groups_count)
 		return NULL;
@@ -2189,7 +2190,7 @@
 {
 	struct super_block *sb = seq->private;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
-	long group;
+	ext4_grpnum_t group;
 
 	++*pos;
 	if (*pos < 0 || *pos >= sbi->s_groups_count)
@@ -3355,12 +3356,13 @@
  * the function goes through all preallocation in this group and marks them
  * used in in-core bitmap. buddy must be generated from this bitmap
  */
-void ext4_mb_generate_from_pa(struct super_block *sb, void *bitmap, int group)
+void ext4_mb_generate_from_pa(struct super_block *sb, void *bitmap,
+			      ext4_grpnum_t group)
 {
 	struct ext4_group_info *grp = EXT4_GROUP_INFO(sb, group);
 	struct ext4_prealloc_space *pa;
 	struct list_head *cur;
-	unsigned long groupnr;
+	ext4_grpnum_t groupnr;
 	ext4_grpblk_t start;
 	int preallocated = 0;
 	int count = 0;
@@ -3386,7 +3388,7 @@
 		preallocated += len;
 		count++;
 	}
-	mb_debug("prellocated %u for group %u\n", preallocated, group);
+	mb_debug("prellocated %u for group %lu\n", preallocated, group);
 }
 
 #if LINUX_VERSION_CODE > KERNEL_VERSION(2, 6, 5)
@@ -3627,7 +3629,7 @@
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	unsigned long end;
 	unsigned long next;
-	unsigned long group;
+	ext4_grpnum_t group;
 	ext4_grpblk_t bit;
 	sector_t start;
 	int err = 0;
@@ -3683,7 +3685,7 @@
 {
 	struct ext4_allocation_context ac;
 	struct super_block *sb = e4b->bd_sb;
-	unsigned long group;
+	ext4_grpnum_t group;
 	ext4_grpblk_t bit;
 
 	ac.ac_op = EXT4_MB_HISTORY_DISCARD;
@@ -3715,7 +3717,7 @@
  *   1) how many requested
  */
 int ext4_mb_discard_group_preallocations(struct super_block *sb,
-						int group, int needed)
+					 ext4_grpnum_t group, int needed)
 {
 	struct ext4_group_info *grp = EXT4_GROUP_INFO(sb, group);
 	struct buffer_head *bitmap_bh = NULL;
@@ -3827,7 +3829,7 @@
 	struct super_block *sb = inode->i_sb;
 	struct buffer_head *bitmap_bh = NULL;
 	struct ext4_prealloc_space *pa, *tmp;
-	unsigned long group = 0;
+	ext4_grpnum_t group = 0;
 	struct list_head list;
 	struct ext4_buddy e4b;
 	int err;
@@ -4021,7 +4023,7 @@
 	struct super_block *sb = ar->inode->i_sb;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_super_block *es = sbi->s_es;
-	unsigned long group;
+	ext4_grpnum_t group;
 	unsigned long len;
 	unsigned long goal;
 	ext4_grpblk_t block;
@@ -4112,7 +4114,7 @@
 
 int ext4_mb_discard_preallocations(struct super_block *sb, int needed)
 {
-	int i;
+	ext4_grpnum_t i;
 	int ret;
 	int freed = 0;
 
@@ -4248,7 +4250,7 @@
 }
 
 int ext4_mb_free_metadata(handle_t *handle, struct ext4_buddy *e4b,
-			  int group, int block, int count)
+			  ext4_grpnum_t group, int block, int count)
 {
 	struct ext4_group_info *db = e4b->bd_info;
 	struct super_block *sb = e4b->bd_sb;
@@ -4323,7 +4325,7 @@
 	unsigned long overflow;
 	ext4_grpblk_t bit;
 	struct buffer_head *gd_bh;
-	unsigned long block_group;
+	ext4_grpnum_t block_group;
 	struct ext4_sb_info *sbi;
 	struct ext4_buddy e4b;
 	int err = 0;
