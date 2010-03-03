From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 1/3] ext4: use ext4_group_first_block_no()
Date: Wed,  3 Mar 2010 23:40:44 +0900
Message-ID: <1267627246-12863-1-git-send-email-akinobu.mita@gmail.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
	Andreas Dilger <adilger@sun.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:55030 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754293Ab0CCOlk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Mar 2010 09:41:40 -0500
Received: by bwz1 with SMTP id 1so57421bwz.21
        for <linux-ext4@vger.kernel.org>; Wed, 03 Mar 2010 06:41:39 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use ext4_group_first_block_no() to calculate the first block number of
the group.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Andreas Dilger <adilger@sun.com>
Cc: linux-ext4@vger.kernel.org
Cc: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/balloc.c  |    3 +--
 fs/ext4/extents.c |    3 +--
 fs/ext4/mballoc.c |   29 +++++++++++------------------
 fs/ext4/mballoc.h |    7 +------
 4 files changed, 14 insertions(+), 28 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 22bc743..89733a5 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -130,8 +130,7 @@ unsigned ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
 		 * to make sure we calculate the right free blocks
 		 */
 		group_blocks = ext4_blocks_count(sbi->s_es) -
-			le32_to_cpu(sbi->s_es->s_first_data_block) -
-			(EXT4_BLOCKS_PER_GROUP(sb) * (ngroups - 1));
+			ext4_group_first_block_no(sb, ngroups - 1);
 	} else {
 		group_blocks = EXT4_BLOCKS_PER_GROUP(sb);
 	}
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 765a482..11eaaa9 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -195,8 +195,7 @@ static ext4_fsblk_t ext4_ext_find_goal(struct inode *inode,
 		if (S_ISREG(inode->i_mode))
 			block_group++;
 	}
-	bg_start = (block_group * EXT4_BLOCKS_PER_GROUP(inode->i_sb)) +
-		le32_to_cpu(EXT4_SB(inode->i_sb)->s_es->s_first_data_block);
+	bg_start = ext4_group_first_block_no(inode->i_sb, block_group);
 	last_block = ext4_blocks_count(EXT4_SB(inode->i_sb)->s_es) - 1;
 
 	/*
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index d34afad..0babffd 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -441,10 +441,9 @@ static void mb_free_blocks_double(struct inode *inode, struct ext4_buddy *e4b,
 	for (i = 0; i < count; i++) {
 		if (!mb_test_bit(first + i, e4b->bd_info->bb_bitmap)) {
 			ext4_fsblk_t blocknr;
-			blocknr = e4b->bd_group * EXT4_BLOCKS_PER_GROUP(sb);
+
+			blocknr = ext4_group_first_block_no(sb, e4b->bd_group);
 			blocknr += first + i;
-			blocknr +=
-			    le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block);
 			ext4_grp_locked_error(sb, e4b->bd_group,
 				   __func__, "double-free of inode"
 				   " %lu's block %llu(bit %u in group %u)",
@@ -1255,10 +1254,9 @@ static void mb_free_blocks(struct inode *inode, struct ext4_buddy *e4b,
 
 		if (!mb_test_bit(block, EXT4_MB_BITMAP(e4b))) {
 			ext4_fsblk_t blocknr;
-			blocknr = e4b->bd_group * EXT4_BLOCKS_PER_GROUP(sb);
+
+			blocknr = ext4_group_first_block_no(sb, e4b->bd_group);
 			blocknr += block;
-			blocknr +=
-			    le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block);
 			ext4_grp_locked_error(sb, e4b->bd_group,
 				   __func__, "double-free of inode"
 				   " %lu's block %llu(bit %u in group %u)",
@@ -1631,7 +1629,6 @@ int ext4_mb_find_by_goal(struct ext4_allocation_context *ac,
 	int max;
 	int err;
 	struct ext4_sb_info *sbi = EXT4_SB(ac->ac_sb);
-	struct ext4_super_block *es = sbi->s_es;
 	struct ext4_free_extent ex;
 
 	if (!(ac->ac_flags & EXT4_MB_HINT_TRY_GOAL))
@@ -1648,8 +1645,8 @@ int ext4_mb_find_by_goal(struct ext4_allocation_context *ac,
 	if (max >= ac->ac_g_ex.fe_len && ac->ac_g_ex.fe_len == sbi->s_stripe) {
 		ext4_fsblk_t start;
 
-		start = (e4b->bd_group * EXT4_BLOCKS_PER_GROUP(ac->ac_sb)) +
-			ex.fe_start + le32_to_cpu(es->s_first_data_block);
+		start = ext4_group_first_block_no(ac->ac_sb, e4b->bd_group) +
+			ex.fe_start;
 		/* use do_div to get remainder (would be 64-bit modulo) */
 		if (do_div(start, sbi->s_stripe) == 0) {
 			ac->ac_found++;
@@ -1803,8 +1800,8 @@ void ext4_mb_scan_aligned(struct ext4_allocation_context *ac,
 	BUG_ON(sbi->s_stripe == 0);
 
 	/* find first stripe-aligned block in group */
-	first_group_block = e4b->bd_group * EXT4_BLOCKS_PER_GROUP(sb)
-		+ le32_to_cpu(sbi->s_es->s_first_data_block);
+	first_group_block = ext4_group_first_block_no(sb, e4b->bd_group);
+
 	a = first_group_block + sbi->s_stripe - 1;
 	do_div(a, sbi->s_stripe);
 	i = (a * sbi->s_stripe) - first_group_block;
@@ -2560,12 +2557,9 @@ static void release_blocks_on_commit(journal_t *journal, transaction_t *txn)
 		ext4_unlock_group(sb, entry->group);
 		if (test_opt(sb, DISCARD)) {
 			ext4_fsblk_t discard_block;
-			struct ext4_super_block *es = EXT4_SB(sb)->s_es;
 
-			discard_block = (ext4_fsblk_t)entry->group *
-						EXT4_BLOCKS_PER_GROUP(sb)
-					+ entry->start_blk
-					+ le32_to_cpu(es->s_first_data_block);
+			discard_block = entry->start_blk +
+				ext4_group_first_block_no(sb, entry->group);
 			trace_ext4_discard_blocks(sb,
 					(unsigned long long)discard_block,
 					entry->count);
@@ -3526,8 +3520,7 @@ ext4_mb_release_inode_pa(struct ext4_buddy *e4b, struct buffer_head *bitmap_bh,
 		if (bit >= end)
 			break;
 		next = mb_find_next_bit(bitmap_bh->b_data, end, bit);
-		start = group * EXT4_BLOCKS_PER_GROUP(sb) + bit +
-				le32_to_cpu(sbi->s_es->s_first_data_block);
+		start = ext4_group_first_block_no(sb, group) + bit;
 		mb_debug(1, "    free preallocated %u/%u in group %u\n",
 				(unsigned) start, (unsigned) next - bit,
 				(unsigned) group);
diff --git a/fs/ext4/mballoc.h b/fs/ext4/mballoc.h
index 436521c..9b2deed 100644
--- a/fs/ext4/mballoc.h
+++ b/fs/ext4/mballoc.h
@@ -225,11 +225,6 @@ struct ext4_buddy {
 static inline ext4_fsblk_t ext4_grp_offs_to_block(struct super_block *sb,
 					struct ext4_free_extent *fex)
 {
-	ext4_fsblk_t block;
