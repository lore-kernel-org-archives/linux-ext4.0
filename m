From: akpm@linux-foundation.org
Subject: - ext4-use-ext4_group_first_block_no.patch removed from -mm tree
Date: Wed, 27 Feb 2008 14:17:12 -0800
Message-ID: <200802272217.m1RMHCRV000794@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
To: akinobu.mita@gmail.com, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext4: use ext4_group_first_block_no()
has been removed from the -mm tree.  Its filename was
     ext4-use-ext4_group_first_block_no.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext4: use ext4_group_first_block_no()
From: Akinobu Mita <akinobu.mita@gmail.com>

Use ext4_group_first_block_no() and assign the return values to
ext2_fsblk_t variables.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/balloc.c |    6 +++---
 fs/ext4/xattr.c  |    6 ++----
 2 files changed, 5 insertions(+), 7 deletions(-)

diff -puN fs/ext4/balloc.c~ext4-use-ext4_group_first_block_no fs/ext4/balloc.c
--- a/fs/ext4/balloc.c~ext4-use-ext4_group_first_block_no
+++ a/fs/ext4/balloc.c
@@ -48,7 +48,6 @@ void ext4_get_group_no_and_offset(struct
 unsigned ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
 		 ext4_group_t block_group, struct ext4_group_desc *gdp)
 {
-	unsigned long start;
 	int bit, bit_max;
 	unsigned free_blocks, group_blocks;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
@@ -106,11 +105,12 @@ unsigned ext4_init_block_bitmap(struct s
 	free_blocks = group_blocks - bit_max;
 
 	if (bh) {
+		ext4_fsblk_t start;
+
 		for (bit = 0; bit < bit_max; bit++)
 			ext4_set_bit(bit, bh->b_data);
 
-		start = block_group * EXT4_BLOCKS_PER_GROUP(sb) +
-			le32_to_cpu(sbi->s_es->s_first_data_block);
+		start = ext4_group_first_block_no(sb, block_group);
 
 		/* Set bits for block and inode bitmaps, and inode table */
 		ext4_set_bit(ext4_block_bitmap(sb, gdp) - start, bh->b_data);
diff -puN fs/ext4/xattr.c~ext4-use-ext4_group_first_block_no fs/ext4/xattr.c
--- a/fs/ext4/xattr.c~ext4-use-ext4_group_first_block_no
+++ a/fs/ext4/xattr.c
@@ -808,10 +808,8 @@ inserted:
 			get_bh(new_bh);
 		} else {
 			/* We need to allocate a new block */
-			ext4_fsblk_t goal = le32_to_cpu(
-					EXT4_SB(sb)->s_es->s_first_data_block) +
-				(ext4_fsblk_t)EXT4_I(inode)->i_block_group *
-				EXT4_BLOCKS_PER_GROUP(sb);
+			ext4_fsblk_t goal = ext4_group_first_block_no(sb,
+						EXT4_I(inode)->i_block_group);
 			ext4_fsblk_t block = ext4_new_block(handle, inode,
 							goal, &error);
 			if (error)
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
ext2-improve-ext2_readdir-return-value.patch
ext2-use-ext2_group_first_block_no.patch
ext2-use-ext2_fsblk_t-type.patch
ext3-use-ext3_group_first_block_no.patch
ext3-add-missing-ext3_journal_stop.patch
ext3-use-ext3_get_group_desc.patch
ext3-check-ext3_journal_get_write_access-errors.patch
