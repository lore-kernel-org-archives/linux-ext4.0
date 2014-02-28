From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH] mke2fs: handle flex_bg collision with backup descriptors
Date: Fri, 28 Feb 2014 13:15:45 -0700
Message-ID: <1393618545-29319-1-git-send-email-adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-04.shaw.ca ([64.59.134.12]:58188 "EHLO
	smtp-out-04.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbaB1UZM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Feb 2014 15:25:12 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If a large flex_bg factor is specified and the block allocator was
laying out block or inode bitmaps or inode tables, and collides with
previously allocated metadata (for example the backup superblock or
group descriptors) it would reset the allocator back to the beginning
of the flex_bg instead of continuing past the obstruction.

For example, with "-G 131072" the inode table will hit the backup
descriptors in groups 1, 3, 5, 7, 9 and start interleaving with the
block and inode bitmaps.  That results in poorly allocated bitmaps
and inode tables that are interleaved and not contiguous as was
intended for flex_bg:

 Group 0: (Blocks 0-32767)
   Primary superblock at 0, Group descriptors at 1-2048
   Block bitmap 2049 (+2049), Inode bitmap at 133121 (bg #4+2049)
   Inode table 264193-264200 (bg #8+2049)
   :
   :
 Group 3838: (Blocks 125763584-125796351) [INODE_UNINIT, BLOCK_UNINIT]
   Block bitmap 5887 (bg #0+5887), Inode bitmap 136959 (bg #4+5887)
   Inode table 294897-294904 (bg #8 + 32753)
 Group 3839: (Blocks 125796352-125829119) [INODE_UNINIT, BLOCK_UNINIT]
   Block bitmap 5888 (bg #0+5888), Inode bitmap 136960 (bg #4+5888)
   Inode table 5889-5896 (bg #0 + 5889)
 Group 3840: (Blocks 125829120-125861887) [INODE_UNINIT, BLOCK_UNINIT]
   Block bitmap 5897 (bg #0+5897), Inode bitmap 136961 (bg #4+5889)
   Inode table 5898-5905 (bg #0 + 5898)
   :
   :

Instead, skip the intervening blocks if there aren't too many of them.
That mostly keeps the flex_bg allocations from colliding, though still
not perfect because there is still some overlap with the backups.
This patch addresses the majority of the problem, allowing about 124k
groups to be layed out perfectly, instead of less than 4k groups with
the previous code.

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 lib/ext2fs/alloc_tables.c |   21 ++++++++++++++-------
 1 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/lib/ext2fs/alloc_tables.c b/lib/ext2fs/alloc_tables.c
index fec9003..c7c844e 100644
--- a/lib/ext2fs/alloc_tables.c
+++ b/lib/ext2fs/alloc_tables.c
@@ -47,16 +47,17 @@ static blk64_t flexbg_offset(ext2_filsys fs, dgrp_t group, blk64_t start_blk,
 	flexbg = group / flexbg_size;
 	size = rem_grp * elem_size;
 
-	if (size > (int) (fs->super->s_blocks_per_group / 8))
-		size = (int) fs->super->s_blocks_per_group / 8;
+	if (size > (int) (fs->super->s_blocks_per_group / 4))
+		size = (int) fs->super->s_blocks_per_group / 4;
 
 	/*
-	 * Don't do a long search if the previous block
-	 * search is still valid.
+	 * Don't do a long search if the previous block search is still valid,
+	 * but skip minor obstructions such as group descriptor backups.
 	 */
-	if (start_blk && ext2fs_test_block_bitmap_range2(bmap, start_blk,
-							 elem_size))
-		return start_blk;
+	if (start_blk && ext2fs_get_free_blocks2(fs, start_blk,
+						 start_blk + size, elem_size,
+						 bmap, &first_free) == 0)
+		return first_free;
 
 	start_blk = ext2fs_group_first_block2(fs, flexbg_size * flexbg);
 	last_grp = group | (flexbg_size - 1);
@@ -125,6 +126,8 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 
 		if (group % flexbg_size)
 			prev_block = ext2fs_block_bitmap_loc(fs, group - 1) + 1;
+		/* FIXME: Take backup group descriptor blocks into account
+		 * if the flexbg allocations will grow to overlap them... */
 		start_blk = flexbg_offset(fs, group, prev_block, bmap,
 					  rem_grps, 1);
 		last_blk = ext2fs_group_last_block2(fs, last_grp);
@@ -156,6 +159,8 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 		else
 			prev_block = ext2fs_block_bitmap_loc(fs, group) +
 				flexbg_size;
+		/* FIXME: Take backup group descriptor blocks into account
+		 * if the flexbg allocations will grow to overlap them... */
 		start_blk = flexbg_offset(fs, group, prev_block, bmap,
 					  rem_grps, 1);
 		last_blk = ext2fs_group_last_block2(fs, last_grp);
@@ -193,6 +198,8 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 			prev_block = ext2fs_inode_bitmap_loc(fs, group) +
 				flexbg_size;
 
+		/* FIXME: Take backup group descriptor blocks into account
+		 * if the flexbg allocations will grow to overlap them... */
 		group_blk = flexbg_offset(fs, group, prev_block, bmap,
 					  rem_grps, fs->inode_blocks_per_group);
 		last_blk = ext2fs_group_last_block2(fs, last_grp);
-- 
1.7.3.4

