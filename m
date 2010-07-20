From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 07/12] e2fsprogs: Check Next3 exclude bitmap on fsck
Date: Tue, 20 Jul 2010 18:16:08 +0300
Message-ID: <1279638973-14561-8-git-send-email-amir73il@users.sf.net>
References: <1279638973-14561-1-git-send-email-amir73il@users.sf.net>
Cc: linux-ext4@vger.kernel.org, Amir Goldstein <amir73il@users.sf.net>
To: tytso@mit.edu, andreas.dilger@oracle.com, jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42770 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932328Ab0GTPRf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Jul 2010 11:17:35 -0400
Received: by mail-ww0-f44.google.com with SMTP id 40so968910wwj.1
        for <linux-ext4@vger.kernel.org>; Tue, 20 Jul 2010 08:17:34 -0700 (PDT)
In-Reply-To: <1279638973-14561-1-git-send-email-amir73il@users.sf.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Excluding blocks is done by setting their bit in the exclude bitmap.
There is one exclude bitmap block per block group.  The exclude
bitmap blocks are owned by the special exclude inode.
Fsck checks that all (and only) snapshot file blocks are excluded.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
---
 e2fsck/e2fsck.h         |    1 +
 e2fsck/pass1.c          |   16 +++++-
 e2fsck/pass5.c          |  144 +++++++++++++++++++++++++++++++++++++++++++++++
 e2fsck/problem.c        |   31 ++++++++++
 e2fsck/problem.h        |   19 ++++++
 lib/ext2fs/ext2fs.h     |   20 +++++++
 lib/ext2fs/rw_bitmaps.c |  138 ++++++++++++++++++++++++++++++++++++++------
 7 files changed, 349 insertions(+), 20 deletions(-)

diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index 13d4161..bc938e0 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -234,6 +234,7 @@ struct e2fsck_struct {
 	ext2fs_inode_bitmap inode_reg_map; /* Inodes which are regular files*/
 
 	ext2fs_block_bitmap block_found_map; /* Blocks which are in use */
+	ext2fs_block_bitmap block_excluded_map; /* Blocks which are excluded */
 	ext2fs_block_bitmap block_dup_map; /* Blks referenced more than once */
 	ext2fs_block_bitmap block_ea_map; /* Blocks which are used by EA's */
 
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 43ca2e6..d7d51c1 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -79,7 +79,7 @@ static void adjust_extattr_refcount(e2fsck_t ctx, ext2_refcount_t refcount,
 struct process_block_struct {
 	ext2_ino_t	ino;
 	unsigned	is_dir:1, is_reg:1, clear:1, suppress:1,
-				fragmented:1, compressed:1, bbcheck:1;
+			fragmented:1, compressed:1, bbcheck:1, snapfile:1;
 	blk64_t		num_blocks;
 	blk64_t		max_blocks;
 	e2_blkcnt_t	last_block;
@@ -625,6 +625,16 @@ void e2fsck_pass1(e2fsck_t ctx)
 		ctx->flags |= E2F_FLAG_ABORT;
 		return;
 	}
+	if (sb->s_feature_compat & EXT2_FEATURE_COMPAT_EXCLUDE_INODE)
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
@@ -1913,6 +1923,7 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 	pb.previous_block = 0;
 	pb.is_dir = LINUX_S_ISDIR(inode->i_mode);
 	pb.is_reg = LINUX_S_ISREG(inode->i_mode);
+	pb.snapfile = (pb.is_reg && (inode->i_flags & EXT4_SNAPFILE_FL));
 	pb.max_blocks = 1 << (31 - fs->super->s_log_block_size);
 	pb.inode = inode;
 	pb.pctx = pctx;
@@ -2258,6 +2269,9 @@ static int process_block(ext2_filsys fs,
 			mark_block_used(ctx, blk);
 	} else
 		mark_block_used(ctx, blk);
+	/* mark snapshot file blocks excluded */
+	if (p->snapfile && ctx->block_excluded_map)
+		ext2fs_fast_mark_block_bitmap2(ctx->block_excluded_map, blk);
 	p->num_blocks++;
 	if (blockcnt >= 0)
 		p->last_block = blockcnt;
diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index fa14b19..9167cfb 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -14,6 +14,7 @@
 #include "problem.h"
 
 static void check_block_bitmaps(e2fsck_t ctx);
+static void check_exclude_bitmaps(e2fsck_t ctx);
 static void check_inode_bitmaps(e2fsck_t ctx);
 static void check_inode_end(e2fsck_t ctx);
 static void check_block_end(e2fsck_t ctx);
@@ -44,6 +45,9 @@ void e2fsck_pass5(e2fsck_t ctx)
 	check_block_bitmaps(ctx);
 	if (ctx->flags & E2F_FLAG_SIGNAL_MASK)
 		return;
+	check_exclude_bitmaps(ctx);
+	if (ctx->flags & E2F_FLAG_SIGNAL_MASK)
+		return;
 	check_inode_bitmaps(ctx);
 	if (ctx->flags & E2F_FLAG_SIGNAL_MASK)
 		return;
@@ -60,6 +64,9 @@ void e2fsck_pass5(e2fsck_t ctx)
 	ctx->inode_dir_map = 0;
 	ext2fs_free_block_bitmap(ctx->block_found_map);
 	ctx->block_found_map = 0;
+	if (ctx->block_excluded_map)
+		ext2fs_free_block_bitmap(ctx->block_excluded_map);
+	ctx->block_excluded_map = 0;
 
 	print_resource_track(ctx, _("Pass 5"), &rtrack, ctx->fs->io);
 }
@@ -82,6 +89,18 @@ static void print_bitmap_problem(e2fsck_t ctx, int problem,
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
@@ -367,6 +386,131 @@ errout:
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
+				EXT2_FEATURE_COMPAT_EXCLUDE_INODE))
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
+				    		EXT2_BG_BLOCK_UNINIT))
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
+		ext2fs_mark_exclude_dirty(fs);
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
index 199fe5e..0a2d31d 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1548,6 +1548,26 @@ static struct e2fsck_problem problem_table[] = {
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
@@ -1624,6 +1644,16 @@ static struct e2fsck_problem problem_table[] = {
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
@@ -1665,6 +1695,7 @@ static struct latch_descr pr_latch_info[] = {
 	{ PR_LATCH_BBLOCK, PR_1_INODE_BBLOCK_LATCH, 0 },
 	{ PR_LATCH_IBITMAP, PR_5_INODE_BITMAP_HEADER, PR_5_INODE_BITMAP_END },
 	{ PR_LATCH_BBITMAP, PR_5_BLOCK_BITMAP_HEADER, PR_5_BLOCK_BITMAP_END },
+	{ PR_LATCH_XBITMAP, PR_5_EXCLUDE_BITMAP_HEADER, PR_5_EXCLUDE_BITMAP_END },
 	{ PR_LATCH_RELOC, PR_0_RELOCATE_HINT, 0 },
 	{ PR_LATCH_DBLOCK, PR_1B_DUP_BLOCK_HEADER, PR_1B_DUP_BLOCK_END },
 	{ PR_LATCH_LOW_DTIME, PR_1_ORPHAN_LIST_REFUGEES, 0 },
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index dba3a23..da52597 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -39,6 +39,7 @@ struct problem_context {
 #define PR_LATCH_TOOBIG	0x0080	/* Latch for file to big errors */
 #define PR_LATCH_OPTIMIZE_DIR 0x0090 /* Latch for optimize directories */
 #define PR_LATCH_BG_CHECKSUM 0x00A0  /* Latch for block group checksums */
+#define PR_LATCH_XBITMAP 0x00B0 /* Latch for pass 5 exclude bitmap proc. */
 
 #define PR_LATCH(x)	((((x) & PR_LATCH_MASK) >> 4) - 1)
 
@@ -992,6 +993,24 @@ struct problem_context {
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
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index c8a8dbc..53c7a55 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -182,6 +182,7 @@ typedef struct ext2_file *ext2_file_t;
 #define EXT2_FLAG_NOFREE_ON_ERROR	0x10000
 #define EXT2_FLAG_64BITS		0x20000
 #define EXT2_FLAG_PRINT_PROGRESS	0x40000
+#define EXT2_FLAG_EXCLUDE_DIRTY		0x100000
 
 /*
  * Special flag in the ext2 inode i_flag field that means that this is
@@ -213,6 +214,7 @@ struct struct_ext2_filsys {
 	int				inode_blocks_per_group;
 	ext2fs_inode_bitmap		inode_map;
 	ext2fs_block_bitmap		block_map;
+	ext2fs_block_bitmap		exclude_map;
 	/* XXX FIXME-64: not 64-bit safe, but not used? */
 	errcode_t (*get_blocks)(ext2_filsys fs, ext2_ino_t ino, blk_t *blocks);
 	errcode_t (*check_directory)(ext2_filsys fs, ext2_ino_t ino);
@@ -671,8 +673,10 @@ extern errcode_t ext2fs_copy_bitmap(ext2fs_generic_bitmap src,
 				    ext2fs_generic_bitmap *dest);
 extern errcode_t ext2fs_write_inode_bitmap(ext2_filsys fs);
 extern errcode_t ext2fs_write_block_bitmap (ext2_filsys fs);
+extern errcode_t ext2fs_write_exclude_bitmap (ext2_filsys fs);
 extern errcode_t ext2fs_read_inode_bitmap (ext2_filsys fs);
 extern errcode_t ext2fs_read_block_bitmap(ext2_filsys fs);
+extern errcode_t ext2fs_read_exclude_bitmap (ext2_filsys fs);
 extern errcode_t ext2fs_allocate_block_bitmap(ext2_filsys fs,
 					      const char *descr,
 					      ext2fs_block_bitmap *ret);
@@ -1495,6 +1499,14 @@ _INLINE_ void ext2fs_mark_bb_dirty(ext2_filsys fs)
 }
 
 /*
+ * Mark the exclude bitmap as dirty
+ */
+_INLINE_ void ext2fs_mark_exclude_dirty(ext2_filsys fs)
+{
+	fs->flags |= EXT2_FLAG_EXCLUDE_DIRTY | EXT2_FLAG_CHANGED;
+}
+
+/*
  * Check to see if a filesystem's inode bitmap is dirty
  */
 _INLINE_ int ext2fs_test_ib_dirty(ext2_filsys fs)
@@ -1511,6 +1523,14 @@ _INLINE_ int ext2fs_test_bb_dirty(ext2_filsys fs)
 }
 
 /*
+ * Check to see if a filesystem's exclude bitmap is dirty
+ */
+_INLINE_ int ext2fs_test_exclude_dirty(ext2_filsys fs)
+{
+	return (fs->flags & EXT2_FLAG_EXCLUDE_DIRTY);
+}
+
+/*
  * Return the group # of a block
  */
 _INLINE_ int ext2fs_group_of_blk(ext2_filsys fs, blk_t blk)
diff --git a/lib/ext2fs/rw_bitmaps.c b/lib/ext2fs/rw_bitmaps.c
index 89416ca..b70605a 100644
--- a/lib/ext2fs/rw_bitmaps.c
+++ b/lib/ext2fs/rw_bitmaps.c
@@ -27,14 +27,15 @@
 #include "ext2fs.h"
 #include "e2image.h"
 
-static errcode_t write_bitmaps(ext2_filsys fs, int do_inode, int do_block)
+static errcode_t write_bitmaps(ext2_filsys fs, int do_inode, int do_block,
+		int do_exclude)
 {
 	dgrp_t 		i;
 	unsigned int	j;
 	int		block_nbytes, inode_nbytes;
 	unsigned int	nbits;
 	errcode_t	retval;
-	char 		*block_buf, *inode_buf;
+	char 		*block_buf, *inode_buf, *exclude_buf;
 	int		csum_flag = 0;
 	blk64_t		blk;
 	blk64_t		blk_itr = fs->super->s_first_data_block;
@@ -45,6 +46,17 @@ static errcode_t write_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 	if (!(fs->flags & EXT2_FLAG_RW))
 		return EXT2_ET_RO_FILSYS;
 
+	if (!EXT2_HAS_COMPAT_FEATURE(fs->super,
+				EXT2_FEATURE_COMPAT_EXCLUDE_INODE))
+		do_exclude = 0;
+
+	if (do_exclude && !fs->exclude_blks) {
+		/* read exclude_blks from exclude inode */
+		retval = ext2fs_create_exclude_inode(fs, 0);
+		if (retval)
+			return retval;
+	}
+
 	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
 				       EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
 		csum_flag = 1;
@@ -57,6 +69,13 @@ static errcode_t write_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 			return retval;
 		memset(block_buf, 0xff, fs->blocksize);
 	}
+	if (do_exclude) {
+		block_nbytes = EXT2_BLOCKS_PER_GROUP(fs->super) / 8;
+		retval = ext2fs_get_mem(fs->blocksize, &exclude_buf);
+		if (retval)
+			return retval;
+		memset(exclude_buf, 0xff, fs->blocksize);
+	}
 	if (do_inode) {
 		inode_nbytes = (size_t)
 			((EXT2_INODES_PER_GROUP(fs->super)+7) / 8);
@@ -67,19 +86,26 @@ static errcode_t write_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 	}
 
 	for (i = 0; i < fs->group_desc_count; i++) {
-		if (!do_block)
+		if (!do_block && !do_exclude)
 			goto skip_block_bitmap;
 
 		if (csum_flag && ext2fs_bg_flags_test(fs, i, EXT2_BG_BLOCK_UNINIT)
 		    )
 			goto skip_this_block_bitmap;
 
-		retval = ext2fs_get_block_bitmap_range2(fs->block_map,
-				blk_itr, block_nbytes << 3, block_buf);
+		if (do_block)
+			retval = ext2fs_get_block_bitmap_range2(fs->block_map,
+					blk_itr, block_nbytes << 3, block_buf);
 		if (retval)
 			return retval;
 
-		if (i == fs->group_desc_count - 1) {
+		if (do_exclude)
+			retval = ext2fs_get_block_bitmap_range2(fs->exclude_map,
+					blk_itr, block_nbytes << 3, exclude_buf);
+		if (retval)
+			return retval;
+
+		if (do_block && i == fs->group_desc_count - 1) {
 			/* Force bitmap padding for the last group */
 			nbits = ((ext2fs_blocks_count(fs->super)
 				  - (__u64) fs->super->s_first_data_block)
@@ -89,12 +115,18 @@ static errcode_t write_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 					ext2fs_set_bit(j, block_buf);
 		}
 		blk = ext2fs_block_bitmap_loc(fs, i);
-		if (blk) {
+		if (do_block && blk) {
 			retval = io_channel_write_blk64(fs->io, blk, 1,
 							block_buf);
 			if (retval)
 				return EXT2_ET_BLOCK_BITMAP_WRITE;
 		}
+		if (do_exclude && (blk = fs->exclude_blks[i])) {
+			retval = io_channel_write_blk64(fs->io, blk, 1,
+						      exclude_buf);
+			if (retval)
+				return EXT2_ET_BLOCK_BITMAP_WRITE;
+		}
 	skip_this_block_bitmap:
 		blk_itr += block_nbytes << 3;
 	skip_block_bitmap:
@@ -133,10 +165,11 @@ static errcode_t write_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 	return 0;
 }
 
-static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
+static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block,
+		int do_exclude)
 {
 	dgrp_t i;
-	char *block_bitmap = 0, *inode_bitmap = 0;
+	char *block_bitmap = 0, *inode_bitmap = 0, *exclude_bitmap = 0;
 	char *buf;
 	errcode_t retval;
 	int block_nbytes = EXT2_BLOCKS_PER_GROUP(fs->super) / 8;
@@ -154,6 +187,17 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 
 	fs->write_bitmaps = ext2fs_write_bitmaps;
 
+	if (!EXT2_HAS_COMPAT_FEATURE(fs->super,
+				EXT2_FEATURE_COMPAT_EXCLUDE_INODE))
+		do_exclude = 0;
+
+	if (do_exclude && !fs->exclude_blks) {
+		/* read exclude_blks from exclude inode */
+		retval = ext2fs_create_exclude_inode(fs, 0);
+		if (retval)
+			return retval;
+	}
+
 	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
 				       EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
 		csum_flag = 1;
@@ -173,7 +217,21 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 					(unsigned) block_nbytes, &block_bitmap);
 		if (retval)
 			goto cleanup;
-	} else
+	}
+	if (do_exclude) {
+		if (fs->exclude_map)
+			ext2fs_free_block_bitmap(fs->exclude_map);
+		strcpy(buf, "exclude bitmap for ");
+		strcat(buf, fs->device_name);
+		retval = ext2fs_allocate_block_bitmap(fs, buf, &fs->exclude_map);
+		if (retval)
+			goto cleanup;
+		retval = ext2fs_get_mem(do_image ? fs->blocksize :
+					(unsigned) block_nbytes, &exclude_bitmap);
+		if (retval)
+			goto cleanup;
+	}
+	if (!do_block && !do_exclude)
 		block_nbytes = 0;
 	if (do_inode) {
 		if (fs->inode_map)
@@ -215,6 +273,11 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 		blk_cnt = (blk64_t)EXT2_BLOCKS_PER_GROUP(fs->super) *
 			fs->group_desc_count;
 		while (block_nbytes > 0) {
+			if (do_exclude) {
+				retval = EXT2_ET_BLOCK_BITMAP_READ;
+				goto cleanup;
+			}
+
 			retval = io_channel_read_blk64(fs->image_io, blk++,
 						     1, block_bitmap);
 			if (retval)
@@ -254,8 +317,30 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 					       blk_itr, cnt, block_bitmap);
 			if (retval)
 				goto cleanup;
-			blk_itr += block_nbytes << 3;
 		}
+		if (exclude_bitmap) {
+			blk = fs->exclude_blks[i];
+			if (csum_flag &&
+			    ext2fs_bg_flags_test(fs, i, EXT2_BG_BLOCK_UNINIT) &&
+			    ext2fs_group_desc_csum_verify(fs, i))
+				blk = 0;
+			if (blk) {
+				retval = io_channel_read_blk64(fs->io, blk,
+					     -block_nbytes, exclude_bitmap);
+				if (retval) {
+					retval = EXT2_ET_BLOCK_BITMAP_READ;
+					goto cleanup;
+				}
+			} else
+				memset(exclude_bitmap, 0, block_nbytes);
+			cnt = block_nbytes << 3;
+			retval = ext2fs_set_block_bitmap_range2(fs->exclude_map,
+					       blk_itr, cnt, exclude_bitmap);
+			if (retval)
+				goto cleanup;
+		}
+		if (block_nbytes)
+			blk_itr += block_nbytes << 3;
 		if (inode_bitmap) {
 			blk = ext2fs_inode_bitmap_loc(fs, i);
 			if (csum_flag &&
@@ -284,6 +369,8 @@ success_cleanup:
 		ext2fs_free_mem(&inode_bitmap);
 	if (block_bitmap)
 		ext2fs_free_mem(&block_bitmap);
+	if (exclude_bitmap)
+		ext2fs_free_mem(&exclude_bitmap);
 	return 0;
 
 cleanup:
@@ -299,6 +386,8 @@ cleanup:
 		ext2fs_free_mem(&inode_bitmap);
 	if (block_bitmap)
 		ext2fs_free_mem(&block_bitmap);
+	if (exclude_bitmap)
+		ext2fs_free_mem(&exclude_bitmap);
 	if (buf)
 		ext2fs_free_mem(&buf);
 	return retval;
@@ -306,39 +395,50 @@ cleanup:
 
 errcode_t ext2fs_read_inode_bitmap(ext2_filsys fs)
 {
-	return read_bitmaps(fs, 1, 0);
+	return read_bitmaps(fs, 1, 0, 0);
 }
 
 errcode_t ext2fs_read_block_bitmap(ext2_filsys fs)
 {
-	return read_bitmaps(fs, 0, 1);
+	return read_bitmaps(fs, 0, 1, 0);
+}
+
+errcode_t ext2fs_read_exclude_bitmap (ext2_filsys fs)
+{
+	return read_bitmaps(fs, 0, 0, 1);
 }
 
 errcode_t ext2fs_write_inode_bitmap(ext2_filsys fs)
 {
-	return write_bitmaps(fs, 1, 0);
+	return write_bitmaps(fs, 1, 0, 0);
 }
 
 errcode_t ext2fs_write_block_bitmap (ext2_filsys fs)
 {
-	return write_bitmaps(fs, 0, 1);
+	return write_bitmaps(fs, 0, 1, 0);
+}
+
+errcode_t ext2fs_write_exclude_bitmap (ext2_filsys fs)
+{
+	return write_bitmaps(fs, 0, 0, 1);
 }
 
 errcode_t ext2fs_read_bitmaps(ext2_filsys fs)
 {
-	if (fs->inode_map && fs->block_map)
+	if (fs->inode_map && fs->block_map && fs->exclude_map)
 		return 0;
 
-	return read_bitmaps(fs, !fs->inode_map, !fs->block_map);
+	return read_bitmaps(fs, !fs->inode_map, !fs->block_map, !fs->exclude_map);
 }
 
 errcode_t ext2fs_write_bitmaps(ext2_filsys fs)
 {
 	int do_inode = fs->inode_map && ext2fs_test_ib_dirty(fs);
 	int do_block = fs->block_map && ext2fs_test_bb_dirty(fs);
+	int do_exclude = fs->exclude_map && ext2fs_test_exclude_dirty(fs);
 
-	if (!do_inode && !do_block)
+	if (!do_inode && !do_block && !do_exclude)
 		return 0;
 
-	return write_bitmaps(fs, do_inode, do_block);
+	return write_bitmaps(fs, do_inode, do_block, do_exclude);
 }
-- 
1.6.6

