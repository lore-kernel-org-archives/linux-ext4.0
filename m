From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 39/74] e2fsck: remove uninit block bitmap calculation
Date: Tue, 10 Dec 2013 17:22:39 -0800
Message-ID: <20131211012239.30655.16666.stgit@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26840 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab3LKBWp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 20:22:45 -0500
In-Reply-To: <20131211011813.30655.39624.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Since libext2fs now detects a BLOCK_UNINIT group and calculates the
group's block bitmap, we no longer need to emulate this behavior in
e2fsck.  We can simply compare the found block map against the
filesystem's, and proceed from there.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass5.c |  103 +++++++-------------------------------------------------
 1 file changed, 12 insertions(+), 91 deletions(-)


diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index 498c041..6d7b968 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -326,7 +326,6 @@ static void check_block_bitmaps(e2fsck_t ctx)
 	int		fixit, had_problem;
 	errcode_t	retval;
 	int		csum_flag;
-	int		skip_group = 0;
 	int	old_desc_blocks = 0;
 	int	count = 0;
 	int	cmp_block = 0;
@@ -378,9 +377,6 @@ redo_counts:
 	had_problem = 0;
 	save_problem = 0;
 	pctx.blk = pctx.blk2 = NO_BLK;
-	if (csum_flag &&
-	    (ext2fs_bg_flags_test(fs, group, EXT2_BG_BLOCK_UNINIT)))
-		skip_group++;
 	for (i = B2C(fs->super->s_first_data_block);
 	     i < ext2fs_blocks_count(fs->super);
 	     i += EXT2FS_CLUSTER_RATIO(fs)) {
@@ -411,15 +407,11 @@ redo_counts:
 				actual_buf);
 		if (retval)
 			goto no_optimize;
-		if (ext2fs_bg_flags_test(fs, group, EXT2_BG_BLOCK_UNINIT))
-			memset(bitmap_buf, 0, nbytes);
-		else {
-			retval = ext2fs_get_block_bitmap_range2(fs->block_map,
-					B2C(i), fs->super->s_clusters_per_group,
-					bitmap_buf);
-			if (retval)
-				goto no_optimize;
-		}
+		retval = ext2fs_get_block_bitmap_range2(fs->block_map,
+				B2C(i), fs->super->s_clusters_per_group,
+				bitmap_buf);
+		if (retval)
+			goto no_optimize;
 		if (memcmp(actual_buf, bitmap_buf, nbytes) != 0)
 			goto no_optimize;
 		n = ext2fs_bitcount(actual_buf, nbytes);
@@ -429,73 +421,7 @@ redo_counts:
 		goto next_group;
 	no_optimize:
 
-		if (skip_group) {
-			if (first_block_in_bg) {
-				super_blk = 0;
-				old_desc_blk = 0;
-				new_desc_blk = 0;
-				ext2fs_super_and_bgd_loc2(fs, group, &super_blk,
-					 &old_desc_blk, &new_desc_blk, 0);
-
-				if (fs->super->s_feature_incompat &
-						EXT2_FEATURE_INCOMPAT_META_BG)
-					old_desc_blocks =
-						fs->super->s_first_meta_bg;
-				else
-					old_desc_blocks = fs->desc_blocks +
-					fs->super->s_reserved_gdt_blocks;
-
-				count = 0;
-				cmp_block = fs->super->s_clusters_per_group;
-				if (group == (int)fs->group_desc_count - 1)
-					cmp_block = EXT2FS_NUM_B2C(fs,
-						    ext2fs_group_blocks_count(fs, group));
-			}
-
-			bitmap = 0;
-			if (EQ_CLSTR(i, super_blk) ||
-			    (old_desc_blk && old_desc_blocks &&
-			     GE_CLSTR(i, old_desc_blk) &&
-			     LE_CLSTR(i, old_desc_blk + old_desc_blocks-1)) ||
-			    (new_desc_blk && EQ_CLSTR(i, new_desc_blk)) ||
-			    EQ_CLSTR(i, ext2fs_block_bitmap_loc(fs, group)) ||
-			    EQ_CLSTR(i, ext2fs_inode_bitmap_loc(fs, group)) ||
-			    (GE_CLSTR(i, ext2fs_inode_table_loc(fs, group)) &&
-			     LE_CLSTR(i, (ext2fs_inode_table_loc(fs, group) +
-					  fs->inode_blocks_per_group - 1)))) {
-				bitmap = 1;
-				actual = (actual != 0);
-				count++;
-				cmp_block--;
-			} else if ((EXT2FS_B2C(fs, i) - count -
-				    EXT2FS_B2C(fs, fs->super->s_first_data_block)) %
-				   fs->super->s_clusters_per_group == 0) {
-				/*
-				 * When the compare data blocks in block bitmap
-				 * are 0, count the free block,
-				 * skip the current block group.
-				 */
-				if (ext2fs_test_block_bitmap_range2(
-					    ctx->block_found_map,
-					    EXT2FS_B2C(fs, i),
-					    cmp_block)) {
-					/*
-					 * -1 means to skip the current block
-					 * group.
-					 */
-					blocks = fs->super->s_clusters_per_group - 1;
-					group_free = cmp_block;
-					free_blocks += cmp_block;
-					/*
-					 * The current block group's last block
-					 * is set to i.
-					 */
-					i += EXT2FS_C2B(fs, cmp_block - 1);
-					bitmap = 1;
-					goto do_counts;
-				}
-			}
-		} else if (redo_flag)
+		if (redo_flag)
 			bitmap = actual;
 		else
 			bitmap = ext2fs_fast_test_block_bitmap2(fs->block_map, i);
@@ -514,14 +440,15 @@ redo_counts:
 			 */
 			problem = PR_5_BLOCK_USED;
 
-			if (skip_group) {
+			if (ext2fs_bg_flags_test(fs, group,
+						 EXT2_BG_BLOCK_UNINIT)) {
 				struct problem_context pctx2;
 				pctx2.blk = i;
 				pctx2.group = group;
-				if (fix_problem(ctx, PR_5_BLOCK_UNINIT,&pctx2)){
-					ext2fs_bg_flags_clear(fs, group, EXT2_BG_BLOCK_UNINIT);
-					skip_group = 0;
-				}
+				if (fix_problem(ctx, PR_5_BLOCK_UNINIT,
+						&pctx2))
+					ext2fs_bg_flags_clear(fs, group,
+							EXT2_BG_BLOCK_UNINIT);
 			}
 		}
 		if (pctx.blk == NO_BLK) {
@@ -575,16 +502,10 @@ redo_counts:
 			group ++;
 			blocks = 0;
 			group_free = 0;
-			skip_group = 0;
 			if (ctx->progress)
 				if ((ctx->progress)(ctx, 5, group,
 						    fs->group_desc_count*2))
 					goto errout;
-			if (csum_flag &&
-			    (i != ext2fs_blocks_count(fs->super)-1) &&
-			    ext2fs_bg_flags_test(fs, group, 
-						EXT2_BG_BLOCK_UNINIT))
-				skip_group++;
 		}
 	}
 	if (pctx.blk != NO_BLK)

