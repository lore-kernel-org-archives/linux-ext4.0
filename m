From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 3/8] e2fsprogs: check the exclude bitmap
Date: Sun, 23 Oct 2011 15:21:23 +0800
Message-ID: <1319354488-6050-4-git-send-email-xiaoqiangnk@gmail.com>
References: <1319354488-6050-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: amir73il@users.sf.net, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58496 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818Ab1JWJK7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 23 Oct 2011 05:10:59 -0400
Received: by mail-iy0-f174.google.com with SMTP id y12so71200iab.19
        for <linux-ext4@vger.kernel.org>; Sun, 23 Oct 2011 02:10:59 -0700 (PDT)
In-Reply-To: <1319354488-6050-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Amir Goldstein <amir73il@users.sf.net>

Excluding snapshot blocks from COW is done by setting their bit in
the exclude bitmap. There is one exclude bitmap block per block group.
Fsck checks that all (and only) snapshot file blocks are excluded.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 e2fsck/e2fsck.h  |    1 +
 e2fsck/pass1.c   |   17 ++++++-
 e2fsck/pass5.c   |  144 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 e2fsck/problem.c |   31 ++++++++++++
 e2fsck/problem.h |   19 +++++++
 5 files changed, 211 insertions(+), 1 deletions(-)

diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index d225d89..44909c3 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -241,6 +241,7 @@ struct e2fsck_struct {
 	ext2fs_inode_bitmap inode_reg_map; /* Inodes which are regular files*/
 
 	ext2fs_block_bitmap block_found_map; /* Blocks which are in use */
+	ext2fs_block_bitmap block_excluded_map; /* Blocks which are excluded */
 	ext2fs_block_bitmap block_dup_map; /* Blks referenced more than once */
 	ext2fs_block_bitmap block_ea_map; /* Blocks which are used by EA's */
 
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index f45831f..3587dff 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -80,7 +80,7 @@ static void adjust_extattr_refcount(e2fsck_t ctx, ext2_refcount_t refcount,
 struct process_block_struct {
 	ext2_ino_t	ino;
 	unsigned	is_dir:1, is_reg:1, clear:1, suppress:1,
-				fragmented:1, compressed:1, bbcheck:1;
+			fragmented:1, compressed:1, bbcheck:1, snapfile:1;
 	blk64_t		num_blocks;
 	blk64_t		max_blocks;
 	e2_blkcnt_t	last_block;
@@ -627,6 +627,16 @@ void e2fsck_pass1(e2fsck_t ctx)
 		ctx->flags |= E2F_FLAG_ABORT;
 		return;
 	}
+	if (sb->s_feature_compat & EXT2_FEATURE_COMPAT_EXCLUDE_BITMAP)
+		pctx.errcode = ext2fs_allocate_block_bitmap(fs,
+				_("excluded block map"),
+				&ctx->block_excluded_map);
+	if (pctx.errcode) {
+		pctx.num = 1;
+		fix_problem(ctx, PR_1_ALLOCATE_BBITMAP_ERROR, &pctx);
+		ctx->flags |= E2F_FLAG_ABORT;
+		return;
+	}
 	e2fsck_setup_tdb_icount(ctx, 0, &ctx->inode_link_info);
 	if (!ctx->inode_link_info)
 		pctx.errcode = ext2fs_create_icount2(fs, 0, 0, 0,
@@ -1940,6 +1950,7 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 	pb.previous_block = 0;
 	pb.is_dir = LINUX_S_ISDIR(inode->i_mode);
 	pb.is_reg = LINUX_S_ISREG(inode->i_mode);
+	pb.snapfile = (pb.is_reg && (inode->i_flags & EXT4_SNAPFILE_FL));
 	pb.max_blocks = 1 << (31 - fs->super->s_log_block_size);
 	pb.inode = inode;
 	pb.pctx = pctx;
@@ -2296,6 +2307,10 @@ static int process_block(ext2_filsys fs,
 		     (blk & EXT2FS_CLUSTER_MASK(ctx->fs)) ==
 		     (blockcnt & EXT2FS_CLUSTER_MASK(ctx->fs)))) {
 		mark_block_used(ctx, blk);
+		/* mark snapshot file blocks excluded */
+		if (p->snapfile && ctx->block_excluded_map)
+			ext2fs_fast_mark_block_bitmap2(ctx->block_excluded_map,
+					blk);
 		p->num_blocks++;
 	}
 	if (blockcnt >= 0)
diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index a60e84a..0dda1b3 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -24,6 +24,7 @@
 #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
 
 static void check_block_bitmaps(e2fsck_t ctx);
+static void check_exclude_bitmaps(e2fsck_t ctx);
 static void check_inode_bitmaps(e2fsck_t ctx);
 static void check_inode_end(e2fsck_t ctx);
 static void check_block_end(e2fsck_t ctx);
@@ -54,6 +55,9 @@ void e2fsck_pass5(e2fsck_t ctx)
 	check_block_bitmaps(ctx);
 	if (ctx->flags & E2F_FLAG_SIGNAL_MASK)
 		return;
+	check_exclude_bitmaps(ctx);
+	if (ctx->flags & E2F_FLAG_SIGNAL_MASK)
+		return;
 	check_inode_bitmaps(ctx);
 	if (ctx->flags & E2F_FLAG_SIGNAL_MASK)
 		return;
@@ -70,6 +74,9 @@ void e2fsck_pass5(e2fsck_t ctx)
 	ctx->inode_dir_map = 0;
 	ext2fs_free_block_bitmap(ctx->block_found_map);
 	ctx->block_found_map = 0;
+	if (ctx->block_excluded_map)
+		ext2fs_free_block_bitmap(ctx->block_excluded_map);
+	ctx->block_excluded_map = 0;
 
 	print_resource_track(ctx, _("Pass 5"), &rtrack, ctx->fs->io);
 }
@@ -112,6 +119,18 @@ static void print_bitmap_problem(e2fsck_t ctx, int problem,
 		else
 			problem = PR_5_BLOCK_RANGE_USED;
 		break;
+	case PR_5_BLOCK_NOTEXCLUDED:
+		if (pctx->blk == pctx->blk2)
+			pctx->blk2 = 0;
+		else
+			problem = PR_5_BLOCK_RANGE_NOTEXCLUDED;
+		break;
+	case PR_5_BLOCK_EXCLUDED:
+		if (pctx->blk == pctx->blk2)
+			pctx->blk2 = 0;
+		else
+			problem = PR_5_BLOCK_RANGE_EXCLUDED;
+		break;
 	case PR_5_INODE_UNUSED:
 		if (pctx->ino == pctx->ino2)
 			pctx->ino2 = 0;
@@ -416,6 +435,131 @@ errout:
 	ext2fs_free_mem(&free_array);
 }
 
+static void check_exclude_bitmaps(e2fsck_t ctx)
+{
+	ext2_filsys fs = ctx->fs;
+	blk64_t	i;
+	int	group = 0;
+	int	blocks = 0;
+	int	actual, bitmap;
+	struct problem_context	pctx;
+	int	problem, save_problem, fixit, had_problem;
+	errcode_t	retval;
+	int		csum_flag;
+	int		skip_group = 0;
+
+	clear_problem_context(&pctx);
+
+	if (!(fs->super->s_feature_compat &
+				EXT2_FEATURE_COMPAT_EXCLUDE_BITMAP))
+		return;
+
+	csum_flag = EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					       EXT4_FEATURE_RO_COMPAT_GDT_CSUM);
+redo_counts:
+	had_problem = 0;
+	save_problem = 0;
+	pctx.blk = pctx.blk2 = NO_BLK;
+	if (csum_flag &&
+	    (ext2fs_bg_flags_test(fs, group, EXT2_BG_BLOCK_UNINIT)))
+		skip_group++;
+	for (i = fs->super->s_first_data_block;
+	     i < ext2fs_blocks_count(fs->super);
+	     i++) {
+		actual = ext2fs_fast_test_block_bitmap2(ctx->block_excluded_map, i);
+
+		if (skip_group) {
+			bitmap = 0;
+			actual = (actual != 0);
+		} else
+			bitmap = ext2fs_fast_test_block_bitmap2(fs->exclude_map, i);
+
+		if (actual == bitmap)
+			goto do_counts;
+
+		if (!actual && bitmap) {
+			/*
+			 * Block not excluded, but marked in exclude bitmap.
+			 */
+			problem = PR_5_BLOCK_NOTEXCLUDED;
+		} else {
+			/*
+			 * Block excluded, but not marked in exclude bitmap.
+			 */
+			problem = PR_5_BLOCK_EXCLUDED;
+
+			if (skip_group) {
+				struct problem_context pctx2;
+				pctx2.blk = i;
+				pctx2.group = group;
+				if (fix_problem(ctx, PR_5_BLOCK_UNINIT,&pctx2)){
+					ext2fs_bg_flags_clear(fs, group, EXT2_BG_BLOCK_UNINIT);
+					skip_group = 0;
+				}
+			}
+		}
+		if (pctx.blk == NO_BLK) {
+			pctx.blk = pctx.blk2 = i;
+			save_problem = problem;
+		} else {
+			if ((problem == save_problem) &&
+			    (pctx.blk2 == i-1))
+				pctx.blk2++;
+			else {
+				print_bitmap_problem(ctx, save_problem, &pctx);
+				pctx.blk = pctx.blk2 = i;
+				save_problem = problem;
+			}
+		}
+		ctx->flags |= E2F_FLAG_PROG_SUPPRESS;
+		had_problem++;
+
+	do_counts:
+		blocks ++;
+		if ((blocks == fs->super->s_blocks_per_group) ||
+		    (i == fs->super->s_blocks_count-1)) {
+			group ++;
+			blocks = 0;
+			skip_group = 0;
+			if (ctx->progress)
+				if ((ctx->progress)(ctx, 5, group,
+						    fs->group_desc_count*2))
+					return;
+			if (csum_flag &&
+			    (i != ext2fs_blocks_count(fs->super)-1) &&
+			    ext2fs_bg_flags_test(fs, group,
+						EXT2_BG_BLOCK_UNINIT))
+				skip_group++;
+		}
+	}
+	if (pctx.blk != NO_BLK)
+		print_bitmap_problem(ctx, save_problem, &pctx);
+	if (had_problem)
+		fixit = end_problem_latch(ctx, PR_LATCH_XBITMAP);
+	else
+		fixit = -1;
+	ctx->flags &= ~E2F_FLAG_PROG_SUPPRESS;
+
+	if (fixit == 1) {
+		ext2fs_free_block_bitmap(fs->exclude_map);
+		retval = ext2fs_copy_bitmap(ctx->block_excluded_map,
+						  &fs->exclude_map);
+		if (retval) {
+			clear_problem_context(&pctx);
+			fix_problem(ctx, PR_5_COPY_BBITMAP_ERROR, &pctx);
+			ctx->flags |= E2F_FLAG_ABORT;
+			return;
+		}
+		ext2fs_mark_eb_dirty(fs);
+		/* clear fix_exclude flag */
+		if (fs->super->s_flags & EXT2_FLAGS_FIX_EXCLUDE) {
+			fs->super->s_flags &= ~EXT2_FLAGS_FIX_EXCLUDE;
+			ext2fs_mark_super_dirty(fs);
+		}
+	} else if (fixit == 0)
+		ext2fs_unmark_valid(fs);
+}
+
 static void check_inode_bitmaps(e2fsck_t ctx)
 {
 	ext2_filsys fs = ctx->fs;
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index cf4a270..ad703c7 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1578,6 +1578,26 @@ static struct e2fsck_problem problem_table[] = {
 	  "\n",
 	  PROMPT_FIX, PR_PREEN_OK | PR_PREEN_NOMSG },
 
+	/* Exclude bitmap differences header */
+	{ PR_5_EXCLUDE_BITMAP_HEADER,
+	  N_("Exclude @B differences: "),
+	  PROMPT_NONE, PR_PREEN_OK | PR_PREEN_NOMSG},
+
+	/* Block not excluded, but marked in exclude bitmap */
+	{ PR_5_BLOCK_NOTEXCLUDED,
+	  " -%b",
+	  PROMPT_NONE, PR_LATCH_XBITMAP | PR_PREEN_OK | PR_PREEN_NOMSG },
+
+	/* Block excluded, but not marked in exclude bitmap */
+	{ PR_5_BLOCK_EXCLUDED,
+	  " +%b",
+	  PROMPT_NONE, PR_LATCH_XBITMAP | PR_PREEN_OK | PR_PREEN_NOMSG },
+
+	/* Exclude bitmap differences end */
+	{ PR_5_EXCLUDE_BITMAP_END,
+	  "\n",
+	  PROMPT_FIX, PR_PREEN_OK | PR_PREEN_NOMSG },
+
 	/* Inode bitmap differences header */
 	{ PR_5_INODE_BITMAP_HEADER,
 	  N_("@i @B differences: "),
@@ -1654,6 +1674,16 @@ static struct e2fsck_problem problem_table[] = {
 	  " +(%b--%c)",
 	  PROMPT_NONE, PR_LATCH_BBITMAP | PR_PREEN_OK | PR_PREEN_NOMSG },
 
+	/* Block range not excluded, but marked in exclude bitmap */
+	{ PR_5_BLOCK_RANGE_NOTEXCLUDED,
+	  " -(%b--%c)",
+	  PROMPT_NONE, PR_LATCH_XBITMAP | PR_PREEN_OK | PR_PREEN_NOMSG },
+
+	/* Block range excluded, but not marked in exclude bitmap */
+	{ PR_5_BLOCK_RANGE_EXCLUDED,
+	  " +(%b--%c)",
+	  PROMPT_NONE, PR_LATCH_XBITMAP | PR_PREEN_OK | PR_PREEN_NOMSG },
+
 	/* Inode range not used, but marked in bitmap */
 	{ PR_5_INODE_RANGE_UNUSED,
 	  " -(%i--%j)",
@@ -1695,6 +1725,7 @@ static struct latch_descr pr_latch_info[] = {
 	{ PR_LATCH_BBLOCK, PR_1_INODE_BBLOCK_LATCH, 0 },
 	{ PR_LATCH_IBITMAP, PR_5_INODE_BITMAP_HEADER, PR_5_INODE_BITMAP_END },
 	{ PR_LATCH_BBITMAP, PR_5_BLOCK_BITMAP_HEADER, PR_5_BLOCK_BITMAP_END },
+	{ PR_LATCH_XBITMAP, PR_5_EXCLUDE_BITMAP_HEADER, PR_5_EXCLUDE_BITMAP_END },
 	{ PR_LATCH_RELOC, PR_0_RELOCATE_HINT, 0 },
 	{ PR_LATCH_DBLOCK, PR_1B_DUP_BLOCK_HEADER, PR_1B_DUP_BLOCK_END },
 	{ PR_LATCH_LOW_DTIME, PR_1_ORPHAN_LIST_REFUGEES, 0 },
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 17b0c10..3647f6e 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -39,6 +39,7 @@ struct problem_context {
 #define PR_LATCH_TOOBIG	0x0080	/* Latch for file to big errors */
 #define PR_LATCH_OPTIMIZE_DIR 0x0090 /* Latch for optimize directories */
 #define PR_LATCH_BG_CHECKSUM 0x00A0  /* Latch for block group checksums */
+#define PR_LATCH_XBITMAP 0x00B0 /* Latch for pass 5 exclude bitmap proc. */
 
 #define PR_LATCH(x)	((((x) & PR_LATCH_MASK) >> 4) - 1)
 
@@ -1010,6 +1011,24 @@ struct problem_context {
 /* Inode in use but group is marked INODE_UNINIT */
 #define PR_5_INODE_UNINIT		0x050019
 
+/* Exclude bitmap differences header */
+#define PR_5_EXCLUDE_BITMAP_HEADER	0x050100
+
+/* Block not excluded, but marked in exclude bitmap */
+#define PR_5_BLOCK_NOTEXCLUDED		0x050101
+
+/* Block excluded, but not marked in exclude bitmap */
+#define PR_5_BLOCK_EXCLUDED		0x050102
+
+/* Block range not excluded, but marked in exclude bitmap */
+#define PR_5_BLOCK_RANGE_NOTEXCLUDED	0x050103
+
+/* Block range excluded, but not marked in exclude bitmap */
+#define PR_5_BLOCK_RANGE_EXCLUDED	0x050104
+
+/* Exclude bitmap differences end */
+#define PR_5_EXCLUDE_BITMAP_END		0x050105
+
 /*
  * Post-Pass 5 errors
  */
-- 
1.7.5.1

