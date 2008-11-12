From: Valerie Aurora Henson <vaurora@redhat.com>
Subject: [RFC PATCH 15/17] Convert to inode/block/bitmap/table loc()/loc_set() functions
Date: Tue, 11 Nov 2008 19:43:08 -0800
Message-ID: <1226461390-5502-16-git-send-email-vaurora@redhat.com>
References: <1226461390-5502-1-git-send-email-vaurora@redhat.com>
 <1226461390-5502-2-git-send-email-vaurora@redhat.com>
 <1226461390-5502-3-git-send-email-vaurora@redhat.com>
 <1226461390-5502-4-git-send-email-vaurora@redhat.com>
 <1226461390-5502-5-git-send-email-vaurora@redhat.com>
 <1226461390-5502-6-git-send-email-vaurora@redhat.com>
 <1226461390-5502-7-git-send-email-vaurora@redhat.com>
 <1226461390-5502-8-git-send-email-vaurora@redhat.com>
 <1226461390-5502-9-git-send-email-vaurora@redhat.com>
 <1226461390-5502-10-git-send-email-vaurora@redhat.com>
 <1226461390-5502-11-git-send-email-vaurora@redhat.com>
 <1226461390-5502-12-git-send-email-vaurora@redhat.com>
 <1226461390-5502-13-git-send-email-vaurora@redhat.com>
 <1226461390-5502-14-git-send-email-vaurora@redhat.com>
 <1226461390-5502-15-git-send-email-vaurora@redhat.com>
Cc: Valerie Aurora Henson <vaurora@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:42476 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752093AbYKLDoG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Nov 2008 22:44:06 -0500
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id mAC3i6u2007475
	for <linux-ext4@vger.kernel.org>; Tue, 11 Nov 2008 22:44:06 -0500
In-Reply-To: <1226461390-5502-15-git-send-email-vaurora@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Valerie Aurora Henson <vaurora@redhat.com>
---
 e2fsck/pass1.c          |   36 ++++++++++++++++++------------------
 e2fsck/pass1b.c         |   10 +++++-----
 e2fsck/pass5.c          |    8 ++++----
 e2fsck/super.c          |   30 +++++++++++++++---------------
 lib/ext2fs/alloc.c      |    8 ++++----
 lib/ext2fs/check_desc.c |    6 +++---
 lib/ext2fs/inode.c      |   16 ++++++++--------
 lib/ext2fs/rw_bitmaps.c |   10 +++++-----
 lib/ext2fs/tst_csum.c   |    6 +++---
 lib/ext2fs/tst_iscan.c  |    2 +-
 10 files changed, 66 insertions(+), 66 deletions(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index ef8b421..2d29988 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -2003,16 +2003,16 @@ static char *describe_illegal_block(ext2_filsys fs, blk_t block)
 				"of group %d", i);
 			break;
 		}
-		if (block == fs->group_desc[i].bg_block_bitmap) {
+		if (block == ext2fs_block_bitmap_loc(fs, i)) {
 			sprintf(problem, "is the block bitmap of group %d", i);
 			break;
 		}
-		if (block == fs->group_desc[i].bg_inode_bitmap) {
+		if (block == ext2fs_inode_bitmap_loc(fs, i)) {
 			sprintf(problem, "is the inode bitmap of group %d", i);
 			break;
 		}
-		if (block >= fs->group_desc[i].bg_inode_table &&
-		    (block < fs->group_desc[i].bg_inode_table
+		if (block >= ext2fs_inode_table_loc(fs, i) &&
+		    (block < ext2fs_inode_table_loc(fs, i)
 		     + fs->inode_blocks_per_group)) {
 			sprintf(problem, "is in the inode table of group %d",
 				i);
@@ -2293,22 +2293,22 @@ static int process_bad_block(ext2_filsys fs,
 			return 0;
 		}
 	skip_super:
-		if (blk == fs->group_desc[i].bg_block_bitmap) {
+		if (blk == ext2fs_block_bitmap_loc(fs, i)) {
 			if (fix_problem(ctx, PR_1_BB_BAD_BLOCK, pctx)) {
 				ctx->invalid_block_bitmap_flag[i]++;
 				ctx->invalid_bitmaps++;
 			}
 			return 0;
 		}
-		if (blk == fs->group_desc[i].bg_inode_bitmap) {
+		if (blk == ext2fs_inode_bitmap_loc(fs, i)) {
 			if (fix_problem(ctx, PR_1_IB_BAD_BLOCK, pctx)) {
 				ctx->invalid_inode_bitmap_flag[i]++;
 				ctx->invalid_bitmaps++;
 			}
 			return 0;
 		}
-		if ((blk >= fs->group_desc[i].bg_inode_table) &&
-		    (blk < (fs->group_desc[i].bg_inode_table +
+		if ((blk >= ext2fs_inode_table_loc(fs, i)) &&
+		    (blk < (ext2fs_inode_table_loc(fs, i) +
 			    fs->inode_blocks_per_group))) {
 			/*
 			 * If there are bad blocks in the inode table,
@@ -2465,8 +2465,8 @@ static void mark_table_blocks(e2fsck_t ctx)
 		/*
 		 * Mark the blocks used for the inode table
 		 */
-		if (fs->group_desc[i].bg_inode_table) {
-			for (j = 0, b = fs->group_desc[i].bg_inode_table;
+		if (ext2fs_inode_table_loc(fs, i)) {
+			for (j = 0, b = ext2fs_inode_table_loc(fs, i);
 			     j < fs->inode_blocks_per_group;
 			     j++, b++) {
 				if (ext2fs_test_block_bitmap2(ctx->block_found_map,
@@ -2487,34 +2487,34 @@ static void mark_table_blocks(e2fsck_t ctx)
 		/*
 		 * Mark block used for the block bitmap
 		 */
-		if (fs->group_desc[i].bg_block_bitmap) {
+		if (ext2fs_block_bitmap_loc(fs, i)) {
 			if (ext2fs_test_block_bitmap2(ctx->block_found_map,
-				     fs->group_desc[i].bg_block_bitmap)) {
-				pctx.blk = fs->group_desc[i].bg_block_bitmap;
+				     ext2fs_block_bitmap_loc(fs, i))) {
+				pctx.blk = ext2fs_block_bitmap_loc(fs, i);
 				if (fix_problem(ctx, PR_1_BB_CONFLICT, &pctx)) {
 					ctx->invalid_block_bitmap_flag[i]++;
 					ctx->invalid_bitmaps++;
 				}
 			} else {
 			    ext2fs_mark_block_bitmap2(ctx->block_found_map,
-				     fs->group_desc[i].bg_block_bitmap);
+				     ext2fs_block_bitmap_loc(fs, i));
 		    }
 
 		}
 		/*
 		 * Mark block used for the inode bitmap
 		 */
-		if (fs->group_desc[i].bg_inode_bitmap) {
+		if (ext2fs_inode_bitmap_loc(fs, i)) {
 			if (ext2fs_test_block_bitmap2(ctx->block_found_map,
-				     fs->group_desc[i].bg_inode_bitmap)) {
-				pctx.blk = fs->group_desc[i].bg_inode_bitmap;
+				     ext2fs_inode_bitmap_loc(fs, i))) {
+				pctx.blk = ext2fs_inode_bitmap_loc(fs, i);
 				if (fix_problem(ctx, PR_1_IB_CONFLICT, &pctx)) {
 					ctx->invalid_inode_bitmap_flag[i]++;
 					ctx->invalid_bitmaps++;
 				}
 			} else {
 			    ext2fs_mark_block_bitmap2(ctx->block_found_map,
-				     fs->group_desc[i].bg_inode_bitmap);
+				     ext2fs_inode_bitmap_loc(fs, i));
 			}
 		}
 	}
diff --git a/e2fsck/pass1b.c b/e2fsck/pass1b.c
index fc2bb7e..f6695bd 100644
--- a/e2fsck/pass1b.c
+++ b/e2fsck/pass1b.c
@@ -823,15 +823,15 @@ static int check_if_fs_block(e2fsck_t ctx, blk_t test_block)
 		}
 
 		/* Check the inode table */
-		if ((fs->group_desc[i].bg_inode_table) &&
-		    (test_block >= fs->group_desc[i].bg_inode_table) &&
-		    (test_block < (fs->group_desc[i].bg_inode_table +
+		if ((ext2fs_inode_table_loc(fs, i)) &&
+		    (test_block >= ext2fs_inode_table_loc(fs, i)) &&
+		    (test_block < (ext2fs_inode_table_loc(fs, i) +
 				   fs->inode_blocks_per_group)))
 			return 1;
 
 		/* Check the bitmap blocks */
-		if ((test_block == fs->group_desc[i].bg_block_bitmap) ||
-		    (test_block == fs->group_desc[i].bg_inode_bitmap))
+		if ((test_block == ext2fs_block_bitmap_loc(fs, i)) ||
+		    (test_block == ext2fs_inode_bitmap_loc(fs, i)))
 			return 1;
 
 		first_block += fs->super->s_blocks_per_group;
diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index 23dd5a4..1bb4b6b 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -198,12 +198,12 @@ redo_counts:
 			if (new_desc_blk &&
 			    (i == new_desc_blk))
 				bitmap = 1;
-			if (i == fs->group_desc[group].bg_block_bitmap)
+			if (i == ext2fs_block_bitmap_loc(fs, group))
 				bitmap = 1;
-			else if (i == fs->group_desc[group].bg_inode_bitmap)
+			else if (i == ext2fs_inode_bitmap_loc(fs, group))
 				bitmap = 1;
-			else if (i >= fs->group_desc[group].bg_inode_table &&
-				 (i < fs->group_desc[group].bg_inode_table
+			else if (i >= ext2fs_inode_table_loc(fs, group) &&
+				 (i < ext2fs_inode_table_loc(fs, group)
 				  + fs->inode_blocks_per_group))
 				bitmap = 1;
 			actual = (actual != 0);
diff --git a/e2fsck/super.c b/e2fsck/super.c
index cfa9a13..bbcc3b9 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -591,34 +591,34 @@ void check_super_block(e2fsck_t ctx)
 			last_block = ext2fs_group_last_block(fs, i);
 		}
 
-		if ((gd->bg_block_bitmap < first_block) ||
-		    (gd->bg_block_bitmap > last_block)) {
-			pctx.blk = gd->bg_block_bitmap;
+		if ((ext2fs_block_bitmap_loc(fs, i) < first_block) ||
+		    (ext2fs_block_bitmap_loc(fs, i) > last_block)) {
+			pctx.blk = ext2fs_block_bitmap_loc(fs, i);
 			if (fix_problem(ctx, PR_0_BB_NOT_GROUP, &pctx))
-				gd->bg_block_bitmap = 0;
+				ext2fs_block_bitmap_loc_set(fs, i, 0);
 		}
-		if (gd->bg_block_bitmap == 0) {
+		if (ext2fs_block_bitmap_loc(fs, i) == 0) {
 			ctx->invalid_block_bitmap_flag[i]++;
 			ctx->invalid_bitmaps++;
 		}
-		if ((gd->bg_inode_bitmap < first_block) ||
-		    (gd->bg_inode_bitmap > last_block)) {
-			pctx.blk = gd->bg_inode_bitmap;
+		if ((ext2fs_inode_bitmap_loc(fs, i) < first_block) ||
+		    (ext2fs_inode_bitmap_loc(fs, i) > last_block)) {
+			pctx.blk = ext2fs_inode_bitmap_loc(fs, i);
 			if (fix_problem(ctx, PR_0_IB_NOT_GROUP, &pctx))
-				gd->bg_inode_bitmap = 0;
+				ext2fs_inode_bitmap_loc_set(fs, i, 0);
 		}
-		if (gd->bg_inode_bitmap == 0) {
+		if (ext2fs_inode_bitmap_loc(fs, i) == 0) {
 			ctx->invalid_inode_bitmap_flag[i]++;
 			ctx->invalid_bitmaps++;
 		}
-		if ((gd->bg_inode_table < first_block) ||
-		    ((gd->bg_inode_table +
+		if ((ext2fs_inode_table_loc(fs, i) < first_block) ||
+		    ((ext2fs_inode_table_loc(fs, i) +
 		      fs->inode_blocks_per_group - 1) > last_block)) {
-			pctx.blk = gd->bg_inode_table;
+			pctx.blk = ext2fs_inode_table_loc(fs, i);
 			if (fix_problem(ctx, PR_0_ITABLE_NOT_GROUP, &pctx))
-				gd->bg_inode_table = 0;
+				ext2fs_inode_table_loc_set(fs, i, 0);
 		}
-		if (gd->bg_inode_table == 0) {
+		if (ext2fs_inode_table_loc(fs, i) == 0) {
 			ctx->invalid_inode_table_flag[i]++;
 			ctx->invalid_bitmaps++;
 		}
diff --git a/lib/ext2fs/alloc.c b/lib/ext2fs/alloc.c
index 2ceab96..6d614af 100644
--- a/lib/ext2fs/alloc.c
+++ b/lib/ext2fs/alloc.c
@@ -59,10 +59,10 @@ static void check_block_uninit(ext2_filsys fs, ext2fs_block_bitmap64 map,
 		     (blk >= old_desc_blk) &&
 		     (blk < old_desc_blk + old_desc_blocks)) ||
 		    (new_desc_blk && (blk == new_desc_blk)) ||
-		    (blk == fs->group_desc[group].bg_block_bitmap) ||
-		    (blk == fs->group_desc[group].bg_inode_bitmap) ||
-		    (blk >= fs->group_desc[group].bg_inode_table &&
-		     (blk < fs->group_desc[group].bg_inode_table
+		    (blk == ext2fs_block_bitmap_loc(fs, group)) ||
+		    (blk == ext2fs_inode_bitmap_loc(fs, group)) ||
+		    (blk >= ext2fs_inode_table_loc(fs, group) &&
+		     (blk < ext2fs_inode_table_loc(fs, group)
 		      + fs->inode_blocks_per_group)))
 			ext2fs_fast_mark_block_bitmap2(map, blk);
 		else
diff --git a/lib/ext2fs/check_desc.c b/lib/ext2fs/check_desc.c
index c3f0f7a..bf32dd0 100644
--- a/lib/ext2fs/check_desc.c
+++ b/lib/ext2fs/check_desc.c
@@ -60,7 +60,7 @@ errcode_t ext2fs_check_desc(ext2_filsys fs)
 		/*
 		 * Check to make sure the block bitmap for group is sane
 		 */
-		blk = fs->group_desc[i].bg_block_bitmap;
+		blk = ext2fs_block_bitmap_loc(fs, i);
 		if (blk < first_block || blk > last_block ||
 		    ext2fs_test_block_bitmap2(bmap, blk)) {
 			retval = EXT2_ET_GDESC_BAD_BLOCK_MAP;
@@ -71,7 +71,7 @@ errcode_t ext2fs_check_desc(ext2_filsys fs)
 		/*
 		 * Check to make sure the inode bitmap for group is sane
 		 */
-		blk = fs->group_desc[i].bg_inode_bitmap;
+		blk = ext2fs_inode_bitmap_loc(fs, i);
 		if (blk < first_block || blk > last_block ||
 		    ext2fs_test_block_bitmap2(bmap, blk)) {
 			retval = EXT2_ET_GDESC_BAD_INODE_MAP;
@@ -82,7 +82,7 @@ errcode_t ext2fs_check_desc(ext2_filsys fs)
 		/*
 		 * Check to make sure the inode table for group is sane
 		 */
-		blk = fs->group_desc[i].bg_inode_table;
+		blk = ext2fs_inode_table_loc(fs, i);
 		if (blk < first_block ||
 		    ((blk + fs->inode_blocks_per_group - 1) > last_block)) {
 			retval = EXT2_ET_GDESC_BAD_INODE_TABLE;
diff --git a/lib/ext2fs/inode.c b/lib/ext2fs/inode.c
index 667f3c6..cdfa19b 100644
--- a/lib/ext2fs/inode.c
+++ b/lib/ext2fs/inode.c
@@ -143,8 +143,8 @@ errcode_t ext2fs_open_inode_scan(ext2_filsys fs, int buffer_blocks,
 	scan->current_group = 0;
 	scan->groups_left = fs->group_desc_count - 1;
 	scan->inode_buffer_blocks = buffer_blocks ? buffer_blocks : 8;
-	scan->current_block = scan->fs->
-		group_desc[scan->current_group].bg_inode_table;
+	scan->current_block = ext2fs_inode_table_loc(scan->fs,
+						     scan->current_group);
 	scan->inodes_left = EXT2_INODES_PER_GROUP(scan->fs->super);
 	scan->blocks_left = scan->fs->inode_blocks_per_group;
 	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
@@ -233,8 +233,8 @@ static errcode_t get_next_blockgroup(ext2_inode_scan scan)
 	scan->current_group++;
 	scan->groups_left--;
 
-	scan->current_block =fs->group_desc[scan->current_group].bg_inode_table;
-
+	scan->current_block = ext2fs_inode_table_loc(scan->fs,
+						     scan->current_group);
 	scan->current_inode = scan->current_group *
 		EXT2_INODES_PER_GROUP(fs->super);
 
@@ -567,9 +567,9 @@ errcode_t ext2fs_read_inode_full(ext2_filsys fs, ext2_ino_t ino,
 		offset = ((ino - 1) % EXT2_INODES_PER_GROUP(fs->super)) *
 			EXT2_INODE_SIZE(fs->super);
 		block = offset >> EXT2_BLOCK_SIZE_BITS(fs->super);
-		if (!fs->group_desc[(unsigned)group].bg_inode_table)
+		if (!ext2fs_inode_table_loc(fs, (unsigned) group))
 			return EXT2_ET_MISSING_INODE_TABLE;
-		block_nr = fs->group_desc[(unsigned)group].bg_inode_table +
+		block_nr = ext2fs_inode_table_loc(fs, group) +
 			block;
 		io = fs->io;
 	}
@@ -686,11 +686,11 @@ errcode_t ext2fs_write_inode_full(ext2_filsys fs, ext2_ino_t ino,
 	offset = ((ino - 1) % EXT2_INODES_PER_GROUP(fs->super)) *
 		EXT2_INODE_SIZE(fs->super);
 	block = offset >> EXT2_BLOCK_SIZE_BITS(fs->super);
-	if (!fs->group_desc[(unsigned) group].bg_inode_table) {
+	if (!ext2fs_inode_table_loc(fs, (unsigned) group)) {
 		retval = EXT2_ET_MISSING_INODE_TABLE;
 		goto errout;
 	}
-	block_nr = fs->group_desc[(unsigned) group].bg_inode_table + block;
+	block_nr = ext2fs_inode_table_loc(fs, (unsigned) group) + block;
 
 	offset &= (EXT2_BLOCK_SIZE(fs->super) - 1);
 
diff --git a/lib/ext2fs/rw_bitmaps.c b/lib/ext2fs/rw_bitmaps.c
index d994fe3..ff56dcd 100644
--- a/lib/ext2fs/rw_bitmaps.c
+++ b/lib/ext2fs/rw_bitmaps.c
@@ -88,9 +88,9 @@ static errcode_t write_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 				for (j = nbits; j < fs->blocksize * 8; j++)
 					ext2fs_set_bit(j, block_buf);
 		}
-		blk = fs->group_desc[i].bg_block_bitmap;
+		blk = ext2fs_block_bitmap_loc(fs, i);
 		if (blk) {
-			retval = io_channel_write_blk(fs->io, blk, 1,
+			retval = io_channel_write_blk64(fs->io, blk, 1,
 						      block_buf);
 			if (retval)
 				return EXT2_ET_BLOCK_BITMAP_WRITE;
@@ -111,7 +111,7 @@ static errcode_t write_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 		if (retval)
 			return retval;
 
-		blk = fs->group_desc[i].bg_inode_bitmap;
+		blk = ext2fs_inode_bitmap_loc(fs, i);
 		if (blk) {
 			retval = io_channel_write_blk(fs->io, blk, 1,
 						      inode_buf);
@@ -235,7 +235,7 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 
 	for (i = 0; i < fs->group_desc_count; i++) {
 		if (block_bitmap) {
-			blk = fs->group_desc[i].bg_block_bitmap;
+			blk = ext2fs_block_bitmap_loc(fs, i);
 			if (csum_flag && fs->group_desc[i].bg_flags &
 			    EXT2_BG_BLOCK_UNINIT &&
 			    ext2fs_group_desc_csum_verify(fs, i))
@@ -257,7 +257,7 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 			blk_itr += block_nbytes << 3;
 		}
 		if (inode_bitmap) {
-			blk = fs->group_desc[i].bg_inode_bitmap;
+			blk = ext2fs_inode_bitmap_loc(fs, i);
 			if (csum_flag && fs->group_desc[i].bg_flags &
 			    EXT2_BG_INODE_UNINIT &&
 			    ext2fs_group_desc_csum_verify(fs, i))
diff --git a/lib/ext2fs/tst_csum.c b/lib/ext2fs/tst_csum.c
index 56148b8..4009437 100644
--- a/lib/ext2fs/tst_csum.c
+++ b/lib/ext2fs/tst_csum.c
@@ -70,9 +70,9 @@ int main(int argc, char **argv)
 	fs->super->s_feature_ro_compat = EXT4_FEATURE_RO_COMPAT_GDT_CSUM;
 
 	for (i=0; i < fs->group_desc_count; i++) {
-		fs->group_desc[i].bg_block_bitmap = 124;
-		fs->group_desc[i].bg_inode_bitmap = 125;
-		fs->group_desc[i].bg_inode_table = 126;
+		ext2fs_block_bitmap_loc_set(fs, i, 124);
+		ext2fs_inode_bitmap_loc_set(fs, i, 125);
+		ext2fs_inode_table_loc_set(fs, i, 126);
 		fs->group_desc[i].bg_free_blocks_count = 31119;
 		fs->group_desc[i].bg_free_inodes_count = 15701;
 		fs->group_desc[i].bg_used_dirs_count = 2;
diff --git a/lib/ext2fs/tst_iscan.c b/lib/ext2fs/tst_iscan.c
index 89d66db..7c89ae5 100644
--- a/lib/ext2fs/tst_iscan.c
+++ b/lib/ext2fs/tst_iscan.c
@@ -188,7 +188,7 @@ static void check_map(void)
 		ext2fs_mark_block_bitmap2(touched_map, test_vec[i]);
 	}
 	for (i = 0; i < test_fs->group_desc_count; i++) {
-		for (j=0, blk = test_fs->group_desc[i].bg_inode_table;
+		for (j=0, blk = ext2fs_inode_table_loc(test_fs, i);
 		     j < test_fs->inode_blocks_per_group;
 		     j++, blk++) {
 			if (!ext2fs_test_block_bitmap2(touched_map, blk) &&
-- 
1.5.6.5

