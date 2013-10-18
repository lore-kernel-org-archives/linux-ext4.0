From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 20/25] resize2fs: don't free in-use clusters when moving blocks
Date: Thu, 17 Oct 2013 21:51:09 -0700
Message-ID: <20131018045109.7339.7178.stgit@birch.djwong.org>
References: <20131018044854.7339.48457.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47770 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab3JREvO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Oct 2013 00:51:14 -0400
In-Reply-To: <20131018044854.7339.48457.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we're moving blocks around the filesystem, ensure that freeing
the old blocks only frees the clusters if they're not in use by other
metadata.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 resize/resize2fs.c |   70 +++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 61 insertions(+), 9 deletions(-)


diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 12f6d16..b351cc6 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -1196,12 +1196,12 @@ static errcode_t blocks_to_move(ext2_resize_t rfs)
 	int		j, has_super;
 	dgrp_t		i, max_groups, g;
 	blk64_t		blk, group_blk;
-	blk64_t		old_blocks, new_blocks;
+	blk64_t		old_blocks, new_blocks, group_end, cluster_freed;
 	blk64_t		new_size;
 	unsigned int	meta_bg, meta_bg_size;
 	errcode_t	retval;
 	ext2_filsys 	fs, old_fs;
-	ext2fs_block_bitmap	meta_bmap;
+	ext2fs_block_bitmap	meta_bmap, new_meta_bmap = NULL;
 	int		flex_bg;
 
 	fs = rfs->new_fs;
@@ -1310,15 +1310,40 @@ static errcode_t blocks_to_move(ext2_resize_t rfs)
 	 * blocks as free.
 	 */
 	if (old_blocks > new_blocks) {
+		if (EXT2FS_CLUSTER_RATIO(fs) > 1) {
+			retval = ext2fs_allocate_block_bitmap(fs,
+							      _("new meta blocks"),
+							      &new_meta_bmap);
+			if (retval)
+				goto errout;
+
+			retval = mark_table_blocks(fs, new_meta_bmap);
+			if (retval)
+				goto errout;
+		}
+
 		for (i = 0; i < max_groups; i++) {
 			if (!ext2fs_bg_has_super(fs, i)) {
 				group_blk += fs->super->s_blocks_per_group;
 				continue;
 			}
-			for (blk = group_blk+1+new_blocks;
-			     blk < group_blk+1+old_blocks; blk++) {
-				ext2fs_block_alloc_stats2(fs, blk, -1);
+			group_end = group_blk + 1 + old_blocks;
+			for (blk = group_blk + 1 + new_blocks;
+			     blk < group_end;) {
+				if (new_meta_bmap == NULL ||
+				    !ext2fs_test_block_bitmap2(new_meta_bmap,
+							       blk)) {
+					cluster_freed = EXT2FS_CLUSTER_RATIO(fs) -
+							(blk & EXT2FS_CLUSTER_MASK(fs));
+					if (cluster_freed > group_end - blk)
+						cluster_freed = group_end - blk;
+					ext2fs_block_alloc_stats2(fs, blk, -1);
+					blk += EXT2FS_CLUSTER_RATIO(fs);
+					rfs->needed_blocks -= cluster_freed;
+					continue;
+				}
 				rfs->needed_blocks--;
+				blk++;
 			}
 			group_blk += fs->super->s_blocks_per_group;
 		}
@@ -1464,6 +1489,8 @@ static errcode_t blocks_to_move(ext2_resize_t rfs)
 	retval = 0;
 
 errout:
+	if (new_meta_bmap)
+		ext2fs_free_block_bitmap(new_meta_bmap);
 	if (meta_bmap)
 		ext2fs_free_block_bitmap(meta_bmap);
 
@@ -2063,9 +2090,10 @@ static errcode_t move_itables(ext2_resize_t rfs)
 	dgrp_t		i, max_groups;
 	ext2_filsys	fs = rfs->new_fs;
 	char		*cp;
-	blk64_t		old_blk, new_blk, blk;
+	blk64_t		old_blk, new_blk, blk, cluster_freed;
 	errcode_t	retval;
 	int		j, to_move, moved;
+	ext2fs_block_bitmap	new_bmap = NULL;
 
 	max_groups = fs->group_desc_count;
 	if (max_groups > rfs->old_fs->group_desc_count)
@@ -2078,6 +2106,17 @@ static errcode_t move_itables(ext2_resize_t rfs)
 			return retval;
 	}
 
+	if (EXT2FS_CLUSTER_RATIO(fs) > 1) {
+		retval = ext2fs_allocate_block_bitmap(fs, _("new meta blocks"),
+						      &new_bmap);
+		if (retval)
+			return retval;
+
+		retval = mark_table_blocks(fs, new_bmap);
+		if (retval)
+			goto errout;
+	}
+
 	/*
 	 * Figure out how many inode tables we need to move
 	 */
@@ -2155,8 +2194,19 @@ static errcode_t move_itables(ext2_resize_t rfs)
 		}
 
 		for (blk = ext2fs_inode_table_loc(rfs->old_fs, i), j=0;
-		     j < fs->inode_blocks_per_group ; j++, blk++)
-			ext2fs_block_alloc_stats2(fs, blk, -1);
+		     j < fs->inode_blocks_per_group;) {
+			if (new_bmap == NULL ||
+			    !ext2fs_test_block_bitmap2(new_bmap, blk)) {
+				ext2fs_block_alloc_stats2(fs, blk, -1);
+				cluster_freed = EXT2FS_CLUSTER_RATIO(fs) -
+						(blk & EXT2FS_CLUSTER_MASK(fs));
+				blk += cluster_freed;
+				j += cluster_freed;
+				continue;
+			}
+			blk++;
+			j++;
+		}
 
 		ext2fs_inode_table_loc_set(rfs->old_fs, i, new_blk);
 		ext2fs_group_desc_csum_set(rfs->old_fs, i);
@@ -2176,9 +2226,11 @@ static errcode_t move_itables(ext2_resize_t rfs)
 	if (rfs->flags & RESIZE_DEBUG_ITABLEMOVE)
 		printf("Inode table move finished.\n");
 #endif
-	return 0;
+	retval = 0;
 
 errout:
+	if (new_bmap)
+		ext2fs_free_block_bitmap(new_bmap);
 	return retval;
 }
 

