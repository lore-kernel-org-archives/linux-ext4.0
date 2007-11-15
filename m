From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] types fixup for mballoc
Date: Thu, 15 Nov 2007 16:56:56 -0600
Message-ID: <473CCEB8.5060201@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Alex Tomas <alex@clusterfs.com>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:41463 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756519AbXKOW5B (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Nov 2007 17:57:01 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I ran into a potential overflow in ext4_mb_scan_aligned, 
and went looking for others in mballoc.  This patch hits a 
few spots, compile-tested only at this point, comments welcome.

This patch:

changes fe_len to an int, I don't think we need it to be a long,
looking at how it's used (should it be a grpblk_t?)  Also change
anything assigned to return value of mb_find_extent, since it returns
fe_len.

changes anything that does groupno * EXT4_BLOCKS_PER_GROUP
or pa->pa_pstart + <whatever> to an ext4_fsblk_t

fixes up any related formats

The change to ext4_mb_scan_aligned to add a modulo to avoid an overflow
may be too clever... it could use an extra look I think.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

---

Index: linux-2.6.24-rc1/fs/ext4/mballoc.c
===================================================================
--- linux-2.6.23.orig/fs/ext4/mballoc.c
+++ linux-2.6.23/fs/ext4/mballoc.c
@@ -363,7 +363,7 @@ struct ext4_free_extent {
 	ext4_lblk_t fe_logical;
 	ext4_grpblk_t fe_start;
 	ext4_grpnum_t fe_group;
-	unsigned long fe_len;
+	int fe_len;
 };
 
 /*
@@ -586,14 +586,14 @@ static void mb_free_blocks_double(struct
 	BUG_ON(!ext4_is_group_locked(sb, e4b->bd_group));
 	for (i = 0; i < count; i++) {
 		if (!mb_test_bit(first + i, e4b->bd_info->bb_bitmap)) {
-			unsigned long blocknr;
+			ext4_fsblk_t blocknr;
 			blocknr = e4b->bd_group * EXT4_BLOCKS_PER_GROUP(sb);
 			blocknr += first + i;
 			blocknr +=
 			    le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block);
 
 			ext4_error(sb, __FUNCTION__, "double-free of inode"
-				   " %lu's block %lu(bit %u in group %lu)\n",
+				   " %lu's block %llu(bit %u in group %lu)\n",
 				   inode ? inode->i_ino : 0, blocknr,
 				   first + i, e4b->bd_group);
 		}
@@ -1226,14 +1226,14 @@ static int mb_free_blocks(struct inode *
 		order = 0;
 
 		if (!mb_test_bit(block, EXT4_MB_BITMAP(e4b))) {
-			unsigned long blocknr;
+			ext4_fsblk_t blocknr;
 			blocknr = e4b->bd_group * EXT4_BLOCKS_PER_GROUP(sb);
 			blocknr += block;
 			blocknr +=
 			    le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block);
 
 			ext4_error(sb, __FUNCTION__, "double-free of inode"
-				   " %lu's block %lu(bit %u in group %lu)\n",
+				   " %lu's block %llu(bit %u in group %lu)\n",
 				   inode ? inode->i_ino : 0, blocknr, block,
 				   e4b->bd_group);
 		}
@@ -1416,7 +1416,7 @@ static void ext4_mb_use_best_found(struc
 					struct ext4_buddy *e4b)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(ac->ac_sb);
-	unsigned long ret;
+	int ret;
 
 	BUG_ON(ac->ac_b_ex.fe_group != e4b->bd_group);
 	BUG_ON(ac->ac_status == AC_STATUS_FOUND);
@@ -1609,7 +1609,7 @@ static int ext4_mb_find_by_goal(struct e
 			     ac->ac_g_ex.fe_len, &ex);
 
 	if (max >= ac->ac_g_ex.fe_len && ac->ac_g_ex.fe_len == sbi->s_stripe) {
-		unsigned long start;
+		ext4_fsblk_t start;
 		start = (e4b->bd_group * EXT4_BLOCKS_PER_GROUP(ac->ac_sb) +
 			ex.fe_start + le32_to_cpu(es->s_first_data_block));
 		if (start % sbi->s_stripe == 0) {
@@ -1732,13 +1732,14 @@ static void ext4_mb_scan_aligned(struct 
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	void *bitmap = EXT4_MB_BITMAP(e4b);
 	struct ext4_free_extent ex;
-	unsigned long i;
-	unsigned long max;
+	ext4_grpblk_t i;
+	int max;
 
 	BUG_ON(sbi->s_stripe == 0);
 
-	/* find first stripe-aligned block */
-	i = e4b->bd_group * EXT4_BLOCKS_PER_GROUP(sb)
+	/* find first stripe-aligned block in group */
+	/* early modulo here to avoid 32-bit overflow */
+	i = (e4b->bd_group % sbi->s_stripe)  * EXT4_BLOCKS_PER_GROUP(sb)
 		+ le32_to_cpu(sbi->s_es->s_first_data_block);
 	i = ((i + sbi->s_stripe - 1) / sbi->s_stripe) * sbi->s_stripe;
 	i = (i - le32_to_cpu(sbi->s_es->s_first_data_block))
@@ -2026,35 +2027,35 @@ static int ext4_mb_seq_history_show(stru
 	if (hs->op == EXT4_MB_HISTORY_ALLOC) {
 		fmt = "%-5u %-8u %-23s %-23s %-23s %-5u %-5u %-2u "
 			"%-5u %-5s %-5u %-6u\n";
-		sprintf(buf2, "%lu/%d/%lu@%lu", hs->result.fe_group,
+		sprintf(buf2, "%lu/%d/%u@%u", hs->result.fe_group,
 			hs->result.fe_start, hs->result.fe_len,
-			(unsigned long)hs->result.fe_logical);
-		sprintf(buf, "%lu/%d/%lu@%lu", hs->orig.fe_group,
+			hs->result.fe_logical);
+		sprintf(buf, "%lu/%d/%u@%u", hs->orig.fe_group,
 			hs->orig.fe_start, hs->orig.fe_len,
-			(unsigned long)hs->orig.fe_logical);
-		sprintf(buf3, "%lu/%d/%lu@%lu", hs->goal.fe_group,
+			hs->orig.fe_logical);
+		sprintf(buf3, "%lu/%d/%u@%u", hs->goal.fe_group,
 			hs->goal.fe_start, hs->goal.fe_len,
-			(unsigned long)hs->goal.fe_logical);
+			hs->goal.fe_logical);
 		seq_printf(seq, fmt, hs->pid, hs->ino, buf, buf3, buf2,
 				hs->found, hs->groups, hs->cr, hs->flags,
 				hs->merged ? "M" : "", hs->tail,
 				hs->buddy ? 1 << hs->buddy : 0);
 	} else if (hs->op == EXT4_MB_HISTORY_PREALLOC) {
 		fmt = "%-5u %-8u %-23s %-23s %-23s\n";
-		sprintf(buf2, "%lu/%d/%lu@%lu", hs->result.fe_group,
+		sprintf(buf2, "%lu/%d/%u@%u", hs->result.fe_group,
 			hs->result.fe_start, hs->result.fe_len,
-			(unsigned long)hs->result.fe_logical);
-		sprintf(buf, "%lu/%d/%lu@%lu", hs->orig.fe_group,
+			hs->result.fe_logical);
+		sprintf(buf, "%lu/%d/%u@%u", hs->orig.fe_group,
 			hs->orig.fe_start, hs->orig.fe_len,
-			(unsigned long)hs->orig.fe_logical);
+			hs->orig.fe_logical);
 		seq_printf(seq, fmt, hs->pid, hs->ino, buf, "", buf2);
 	} else if (hs->op == EXT4_MB_HISTORY_DISCARD) {
-		sprintf(buf2, "%lu/%d/%lu", hs->result.fe_group,
+		sprintf(buf2, "%lu/%d/%u", hs->result.fe_group,
 			hs->result.fe_start, hs->result.fe_len);
 		seq_printf(seq, "%-5u %-8u %-23s discard\n",
 				hs->pid, hs->ino, buf2);
 	} else if (hs->op == EXT4_MB_HISTORY_FREE) {
-		sprintf(buf2, "%lu/%d/%lu", hs->result.fe_group,
+		sprintf(buf2, "%lu/%d/%u", hs->result.fe_group,
 			hs->result.fe_start, hs->result.fe_len);
 		seq_printf(seq, "%-5u %-8u %-23s free\n",
 				hs->pid, hs->ino, buf2);
@@ -2942,7 +2943,7 @@ static int ext4_mb_mark_diskspace_used(s
 	struct buffer_head *gdp_bh;
 	struct ext4_sb_info *sbi;
 	struct super_block *sb;
-	sector_t block;
+	ext4_fsblk_t block;
 	int err;
 
 	BUG_ON(ac->ac_status != AC_STATUS_FOUND);
@@ -2983,8 +2984,8 @@ static int ext4_mb_mark_diskspace_used(s
 				EXT4_SB(sb)->s_itb_per_group)) {
 
 		ext4_error(sb, __FUNCTION__,
-			   "Allocating block in system zone - block = %lu",
-			   (unsigned long) block);
+			   "Allocating block in system zone - block = %llu",
+			   block);
 	}
 #ifdef AGGRESSIVE_CHECK
 	{
@@ -3249,12 +3250,13 @@ static void ext4_mb_use_inode_pa(struct 
 				struct ext4_prealloc_space *pa)
 {
 	ext4_fsblk_t start;
-	unsigned long len;
+	ext4_fsblk_t end;
+	int len;
 
 	/* found preallocated blocks, use them */
 	start = pa->pa_pstart + (ac->ac_o_ex.fe_logical - pa->pa_lstart);
-	len = min(pa->pa_pstart + pa->pa_len, start + ac->ac_o_ex.fe_len);
-	len = len - start;
+	end = min(pa->pa_pstart + pa->pa_len, start + ac->ac_o_ex.fe_len);
+	len = end - start;
 	ext4_get_group_no_and_offset(ac->ac_sb, start, &ac->ac_b_ex.fe_group,
 					&ac->ac_b_ex.fe_start);
 	ac->ac_b_ex.fe_len = len;
@@ -3953,8 +3955,8 @@ static void ext4_mb_show_ac(struct ext4_
 
 	printk(KERN_ERR "EXT4-fs: can't allocate: status %d flags %d\n",
 			ac->ac_status, ac->ac_flags);
-	printk(KERN_ERR "EXT4-fs: orig %lu/%lu/%lu@%lu, goal %lu/%lu/%lu@%lu, "
-			"best %lu/%lu/%lu@%lu cr %d\n",
+	printk(KERN_ERR "EXT4-fs: orig %lu/%lu/%u@%u, goal %lu/%lu/%u@%u, "
+			"best %lu/%lu/%u@%u cr %d\n",
 			ac->ac_o_ex.fe_group, ac->ac_o_ex.fe_start,
 			ac->ac_o_ex.fe_len, ac->ac_o_ex.fe_logical,
 			ac->ac_g_ex.fe_group, ac->ac_g_ex.fe_start,
