From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 4/4] resize2fs: use [un]mark_block_range bitmap functions to reduce CPU usage
Date: Thu,  3 Jan 2013 09:13:28 -0500
Message-ID: <1357222408-7310-4-git-send-email-tytso@mit.edu>
References: <1357222408-7310-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:41494 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753426Ab3ACONa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 Jan 2013 09:13:30 -0500
In-Reply-To: <1357222408-7310-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use ext2fs_[un]mark_block_range2() functions to reduce the CPU
overhead of resizing large file systems by 45%, primarily by
reducing the time spent in fix_uninit_block_bitmaps().

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/alloc_sb.c |  9 ++++---
 resize/resize2fs.c    | 67 ++++++++++++++++++---------------------------------
 2 files changed, 29 insertions(+), 47 deletions(-)

diff --git a/lib/ext2fs/alloc_sb.c b/lib/ext2fs/alloc_sb.c
index 0d1c000..868d724 100644
--- a/lib/ext2fs/alloc_sb.c
+++ b/lib/ext2fs/alloc_sb.c
@@ -67,10 +67,11 @@ int ext2fs_reserve_super_and_bgd(ext2_filsys fs,
 	if (old_desc_blk) {
 		if (fs->super->s_reserved_gdt_blocks && fs->block_map == bmap)
 			ext2fs_bg_flags_clear(fs, group, EXT2_BG_BLOCK_UNINIT);
-		for (j=0; j < old_desc_blocks; j++)
-			if (old_desc_blk + j < ext2fs_blocks_count(fs->super))
-				ext2fs_mark_block_bitmap2(bmap,
-							 old_desc_blk + j);
+		num_blocks = old_desc_blocks;
+		if (old_desc_blk + num_blocks >= ext2fs_blocks_count(fs->super))
+			num_blocks = ext2fs_blocks_count(fs->super) -
+				old_desc_blk;
+		ext2fs_mark_block_bitmap_range2(bmap, old_desc_blk, num_blocks);
 	}
 	if (new_desc_blk)
 		ext2fs_mark_block_bitmap2(bmap, new_desc_blk);
diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index f6a52e5..ac965ee 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -215,9 +215,9 @@ errout:
  */
 static void fix_uninit_block_bitmaps(ext2_filsys fs)
 {
-	blk64_t		i, blk, super_blk, old_desc_blk, new_desc_blk;
-	int		old_desc_blocks;
+	blk64_t		blk, lblk;
 	dgrp_t		g;
+	int		i;
 
 	if (!(EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
 					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM)))
@@ -228,33 +228,19 @@ static void fix_uninit_block_bitmaps(ext2_filsys fs)
 			continue;
 
 		blk = ext2fs_group_first_block2(fs, g);
-
-		ext2fs_super_and_bgd_loc2(fs, g, &super_blk,
-					  &old_desc_blk, &new_desc_blk, 0);
-
-		if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG)
-			old_desc_blocks = fs->super->s_first_meta_bg;
-		else
-			old_desc_blocks = fs->desc_blocks +
-				fs->super->s_reserved_gdt_blocks;
-
-		for (i=0; i < fs->super->s_blocks_per_group; i++, blk++) {
-			if (blk >= ext2fs_blocks_count(fs->super))
-				break;
-			if ((blk == super_blk) ||
-			    (old_desc_blk && old_desc_blocks &&
-			     (blk >= old_desc_blk) &&
-			     (blk < old_desc_blk + old_desc_blocks)) ||
-			    (new_desc_blk && (blk == new_desc_blk)) ||
-			    (blk == ext2fs_block_bitmap_loc(fs, g)) ||
-			    (blk == ext2fs_inode_bitmap_loc(fs, g)) ||
-			    (blk >= ext2fs_inode_table_loc(fs, g) &&
-			     (blk < ext2fs_inode_table_loc(fs, g)
-			      + fs->inode_blocks_per_group)))
-				ext2fs_fast_mark_block_bitmap2(fs->block_map, blk);
-			else
-				ext2fs_fast_unmark_block_bitmap2(fs->block_map, blk);
-		}
+		lblk = ext2fs_group_last_block2(fs, g);
+		ext2fs_unmark_block_bitmap_range2(fs->block_map, blk,
+						  lblk - blk + 1);
+
+		ext2fs_reserve_super_and_bgd(fs, g, fs->block_map);
+		ext2fs_mark_block_bitmap2(fs->block_map,
+					  ext2fs_block_bitmap_loc(fs, g));
+		ext2fs_mark_block_bitmap2(fs->block_map,
+					  ext2fs_inode_bitmap_loc(fs, g));
+		for (i = 0, blk = ext2fs_inode_table_loc(fs, g);
+		     i < (unsigned int) fs->inode_blocks_per_group;
+		     i++, blk++)
+			ext2fs_mark_block_bitmap2(fs->block_map, blk);
 	}
 }
 
@@ -722,8 +708,6 @@ errout:
 static errcode_t mark_table_blocks(ext2_filsys fs,
 				   ext2fs_block_bitmap bmap)
 {
-	blk64_t			b;
-	unsigned int		j;
 	dgrp_t			i;
 
 	for (i = 0; i < fs->group_desc_count; i++) {
@@ -732,10 +716,9 @@ static errcode_t mark_table_blocks(ext2_filsys fs,
 		/*
 		 * Mark the blocks used for the inode table
 		 */
-		for (j = 0, b = ext2fs_inode_table_loc(fs, i);
-		     j < (unsigned int) fs->inode_blocks_per_group;
-		     j++, b++)
-			ext2fs_mark_block_bitmap2(bmap, b);
+		ext2fs_mark_block_bitmap_range2(bmap,
+					  ext2fs_inode_table_loc(fs, i),
+					  fs->inode_blocks_per_group);
 
 		/*
 		 * Mark block used for the block bitmap
@@ -982,15 +965,13 @@ static errcode_t blocks_to_move(ext2_resize_t rfs)
 				 ext2fs_inode_bitmap_loc(old_fs, i));
 
 		if (ext2fs_inode_table_loc(fs, i))
-			for (blk = ext2fs_inode_table_loc(fs, i), j=0;
-			     j < fs->inode_blocks_per_group ; j++, blk++)
-				ext2fs_mark_block_bitmap2(rfs->reserve_blocks,
-							 blk);
+			ext2fs_mark_block_bitmap_range2(rfs->reserve_blocks,
+					ext2fs_inode_table_loc(fs, i),
+					fs->inode_blocks_per_group);
 		else if (flex_bg && i < old_fs->group_desc_count)
-			for (blk = ext2fs_inode_table_loc(old_fs, i), j=0;
-			     j < old_fs->inode_blocks_per_group ; j++, blk++)
-				ext2fs_mark_block_bitmap2(rfs->reserve_blocks,
-							  blk);
+			ext2fs_mark_block_bitmap_range2(rfs->reserve_blocks,
+					ext2fs_inode_table_loc(old_fs, i),
+					old_fs->inode_blocks_per_group);
 
 		group_blk += rfs->new_fs->super->s_blocks_per_group;
 	}
-- 
1.7.12.rc0.22.gcdd159b

