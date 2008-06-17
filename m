From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] resize2fs: Fix support for the uninit_bg feature
Date: Tue, 17 Jun 2008 02:06:30 -0400
Message-ID: <1213682792-4878-2-git-send-email-tytso@mit.edu>
References: <1213682792-4878-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:33398 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751829AbYFQGGe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Jun 2008 02:06:34 -0400
In-Reply-To: <1213682792-4878-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 resize/main.c      |    6 ----
 resize/resize2fs.c |   83 ++++++++++++++++++++++++++++++++++++++++-----------
 2 files changed, 65 insertions(+), 24 deletions(-)

diff --git a/resize/main.c b/resize/main.c
index e26cd8b..d7097ad 100644
--- a/resize/main.c
+++ b/resize/main.c
@@ -307,12 +307,6 @@ int main (int argc, char ** argv)
 		exit (1);
 	}
 
-	if (fs->super->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_GDT_CSUM) {
-		com_err(program_name, EXT2_ET_RO_UNSUPP_FEATURE,
-			":- uninit_bg");
-		exit(1);
-	}
-
 	/*
 	 * Check for compatibility with the feature sets.  We need to
 	 * be more stringent than ext2fs_open().
diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 2d53873..027315c 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -188,7 +188,7 @@ errcode_t adjust_fs_info(ext2_filsys fs, ext2_filsys old_fs, blk_t new_size)
 	int		adj, old_numblocks, numblocks, adjblocks;
 	unsigned long	i, j, old_desc_blocks, max_group;
 	unsigned int	meta_bg, meta_bg_size;
-	int		has_super;
+	int		has_super, csum_flag;
 	unsigned long long new_inodes;	/* u64 to check for overflow */
 
 	fs->super->s_blocks_count = new_size;
@@ -359,6 +359,8 @@ retry:
 	group_block = fs->super->s_first_data_block +
 		old_fs->group_desc_count * fs->super->s_blocks_per_group;
 
+	csum_flag = EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					       EXT4_FEATURE_RO_COMPAT_GDT_CSUM);
 	adj = old_fs->group_desc_count;
 	max_group = fs->group_desc_count - adj;
 	if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG)
@@ -372,18 +374,26 @@ retry:
 		       sizeof(struct ext2_group_desc));
 		adjblocks = 0;
 
+		fs->group_desc[i].bg_flags = 0;
+		if (csum_flag)
+			fs->group_desc[i].bg_flags |= EXT2_BG_INODE_UNINIT |
+				EXT2_BG_INODE_ZEROED;
 		if (i == fs->group_desc_count-1) {
 			numblocks = (fs->super->s_blocks_count -
 				     fs->super->s_first_data_block) %
 					     fs->super->s_blocks_per_group;
 			if (!numblocks)
 				numblocks = fs->super->s_blocks_per_group;
-		} else
+		} else {
 			numblocks = fs->super->s_blocks_per_group;
+			if (csum_flag)
+				fs->group_desc[i].bg_flags |=
+					EXT2_BG_BLOCK_UNINIT;
+		}
 
 		has_super = ext2fs_bg_has_super(fs, i);
 		if (has_super) {
-			ext2fs_mark_block_bitmap(fs->block_map, group_block);
+			ext2fs_block_alloc_stats(fs, group_block, +1);
 			adjblocks++;
 		}
 		meta_bg_size = EXT2_DESC_PER_BLOCK(fs->super);
@@ -393,8 +403,8 @@ retry:
 		    (meta_bg < fs->super->s_first_meta_bg)) {
 			if (has_super) {
 				for (j=0; j < old_desc_blocks; j++)
-					ext2fs_mark_block_bitmap(fs->block_map,
-							 group_block + 1 + j);
+					ext2fs_block_alloc_stats(fs,
+						 group_block + 1 + j, +1);
 				adjblocks += old_desc_blocks;
 			}
 		} else {
@@ -403,8 +413,8 @@ retry:
 			if (((i % meta_bg_size) == 0) ||
 			    ((i % meta_bg_size) == 1) ||
 			    ((i % meta_bg_size) == (meta_bg_size-1)))
-				ext2fs_mark_block_bitmap(fs->block_map,
-						 group_block + has_super);
+				ext2fs_block_alloc_stats(fs,
+						 group_block + has_super, +1);
 		}
 		
 		adjblocks += 2 + fs->inode_blocks_per_group;
@@ -597,7 +607,7 @@ static void mark_fs_metablock(ext2_resize_t rfs,
 	ext2_filsys 	fs = rfs->new_fs;
 	
 	ext2fs_mark_block_bitmap(rfs->reserve_blocks, blk);
-	ext2fs_mark_block_bitmap(fs->block_map, blk);
+	ext2fs_block_alloc_stats(fs, blk, +1);
 
 	/*
 	 * Check to see if we overlap with the inode or block bitmap,
@@ -707,8 +717,7 @@ static errcode_t blocks_to_move(ext2_resize_t rfs)
 			}
 			for (blk = group_blk+1+new_blocks;
 			     blk < group_blk+1+old_blocks; blk++) {
-				ext2fs_unmark_block_bitmap(fs->block_map,
-							   blk);
+				ext2fs_block_alloc_stats(fs, blk, -1);
 				rfs->needed_blocks--;
 			}
 			group_blk += fs->super->s_blocks_per_group;
@@ -781,7 +790,7 @@ static errcode_t blocks_to_move(ext2_resize_t rfs)
 		 */
 		if (FS_BLOCK_BM(old_fs, i) !=
 		    (blk = FS_BLOCK_BM(fs, i))) {
-			ext2fs_mark_block_bitmap(fs->block_map, blk);
+			ext2fs_block_alloc_stats(fs, blk, +1);
 			if (ext2fs_test_block_bitmap(old_fs->block_map, blk) &&
 			    !ext2fs_test_block_bitmap(meta_bmap, blk))
 				ext2fs_mark_block_bitmap(rfs->move_blocks,
@@ -789,7 +798,7 @@ static errcode_t blocks_to_move(ext2_resize_t rfs)
 		}
 		if (FS_INODE_BM(old_fs, i) !=
 		    (blk = FS_INODE_BM(fs, i))) {
-			ext2fs_mark_block_bitmap(fs->block_map, blk);
+			ext2fs_block_alloc_stats(fs, blk, +1);
 			if (ext2fs_test_block_bitmap(old_fs->block_map, blk) &&
 			    !ext2fs_test_block_bitmap(meta_bmap, blk))
 				ext2fs_mark_block_bitmap(rfs->move_blocks,
@@ -815,7 +824,7 @@ static errcode_t blocks_to_move(ext2_resize_t rfs)
 		 */
 		for (blk = fs->group_desc[i].bg_inode_table, j=0;
 		     j < fs->inode_blocks_per_group ; j++, blk++) {
-			ext2fs_mark_block_bitmap(fs->block_map, blk);
+			ext2fs_block_alloc_stats(fs, blk, +1);
 			if (ext2fs_test_block_bitmap(old_fs->block_map, blk) &&
 			    !ext2fs_test_block_bitmap(meta_bmap, blk))
 				ext2fs_mark_block_bitmap(rfs->move_blocks,
@@ -953,7 +962,7 @@ static errcode_t block_mover(ext2_resize_t rfs)
 			retval = ENOSPC;
 			goto errout;
 		}
-		ext2fs_mark_block_bitmap(fs->block_map, new_blk);
+		ext2fs_block_alloc_stats(fs, new_blk, +1);
 		ext2fs_add_extent_entry(rfs->bmap, blk, new_blk);
 		to_move++;
 	}
@@ -1222,7 +1231,8 @@ static errcode_t inode_scan_and_fix(ext2_resize_t rfs)
 				goto errout;
 			}
 		}
-		ext2fs_mark_inode_bitmap(rfs->new_fs->inode_map, new_inode);
+		ext2fs_inode_alloc_stats2(rfs->new_fs, new_inode, +1,
+					  pb.is_dir);
 		if (pb.changed) {
 			/* Get the new version of the inode */
 			retval = ext2fs_read_inode_full(rfs->old_fs, ino,
@@ -1491,7 +1501,7 @@ static errcode_t move_itables(ext2_resize_t rfs)
 
 		for (blk = rfs->old_fs->group_desc[i].bg_inode_table, j=0;
 		     j < fs->inode_blocks_per_group ; j++, blk++)
-			ext2fs_unmark_block_bitmap(fs->block_map, blk);
+			ext2fs_block_alloc_stats(fs, blk, -1);
 
 		rfs->old_fs->group_desc[i].bg_inode_table = new_blk;
 		ext2fs_group_desc_csum_set(rfs->old_fs, i);
@@ -1579,13 +1589,35 @@ static errcode_t ext2fs_calculate_summary_stats(ext2_filsys fs)
 	unsigned int	count = 0;
 	int		total_free = 0;
 	int		group_free = 0;
+	int		uninit = 0;
+	blk_t		super_blk, old_desc_blk, new_desc_blk;
+	int		old_desc_blocks;
 
 	/*
 	 * First calculate the block statistics
 	 */
+	uninit = fs->group_desc[group].bg_flags & EXT2_BG_BLOCK_UNINIT;
+	ext2fs_super_and_bgd_loc(fs, group, &super_blk, &old_desc_blk,
+				 &new_desc_blk, 0);
+	if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG)
+		old_desc_blocks = fs->super->s_first_meta_bg;
+	else
+		old_desc_blocks = fs->desc_blocks +
+			fs->super->s_reserved_gdt_blocks;
 	for (blk = fs->super->s_first_data_block;
 	     blk < fs->super->s_blocks_count; blk++) {
-		if (!ext2fs_fast_test_block_bitmap(fs->block_map, blk)) {
+		if ((uninit &&
+		     !((blk == super_blk) ||
+		       ((old_desc_blk && old_desc_blocks &&
+			 (blk >= old_desc_blk) &&
+			 (blk < old_desc_blk + old_desc_blocks))) ||
+		       ((new_desc_blk && (blk == new_desc_blk))) ||
+		       (blk == fs->group_desc[group].bg_block_bitmap) ||
+		       (blk == fs->group_desc[group].bg_inode_bitmap) ||
+		       ((blk >= fs->group_desc[group].bg_inode_table &&
+			 (blk < fs->group_desc[group].bg_inode_table
+			  + fs->inode_blocks_per_group))))) ||
+		    (!ext2fs_fast_test_block_bitmap(fs->block_map, blk))) {
 			group_free++;
 			total_free++;
 		}
@@ -1598,6 +1630,17 @@ static errcode_t ext2fs_calculate_summary_stats(ext2_filsys fs)
 			group++;
 			count = 0;
 			group_free = 0;
+			uninit = (fs->group_desc[group].bg_flags &
+				  EXT2_BG_BLOCK_UNINIT);
+			ext2fs_super_and_bgd_loc(fs, group, &super_blk,
+						 &old_desc_blk,
+						 &new_desc_blk, 0);
+			if (fs->super->s_feature_incompat &
+			    EXT2_FEATURE_INCOMPAT_META_BG)
+				old_desc_blocks = fs->super->s_first_meta_bg;
+			else
+				old_desc_blocks = fs->desc_blocks +
+					fs->super->s_reserved_gdt_blocks;
 		}
 	}
 	fs->super->s_free_blocks_count = total_free;
@@ -1611,8 +1654,10 @@ static errcode_t ext2fs_calculate_summary_stats(ext2_filsys fs)
 	group = 0;
 
 	/* Protect loop from wrap-around if s_inodes_count maxed */
+	uninit = fs->group_desc[group].bg_flags & EXT2_BG_INODE_UNINIT;
 	for (ino = 1; ino <= fs->super->s_inodes_count && ino > 0; ino++) {
-		if (!ext2fs_fast_test_inode_bitmap(fs->inode_map, ino)) {
+		if (uninit ||
+		    !ext2fs_fast_test_inode_bitmap(fs->inode_map, ino)) {
 			group_free++;
 			total_free++;
 		}
@@ -1625,6 +1670,8 @@ static errcode_t ext2fs_calculate_summary_stats(ext2_filsys fs)
 			group++;
 			count = 0;
 			group_free = 0;
+			uninit = (fs->group_desc[group].bg_flags &
+				  EXT2_BG_INODE_UNINIT);
 		}
 	}
 	fs->super->s_free_inodes_count = total_free;
-- 
1.5.6.rc3.1.g36b7.dirty

