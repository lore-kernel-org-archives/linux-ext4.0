From: Valerie Aurora Henson <vaurora@redhat.com>
Subject: [RFC PATCH 07/17] Convert e2fsck to new bitmap interface
Date: Tue, 11 Nov 2008 19:43:00 -0800
Message-ID: <1226461390-5502-8-git-send-email-vaurora@redhat.com>
References: <1226461390-5502-1-git-send-email-vaurora@redhat.com>
 <1226461390-5502-2-git-send-email-vaurora@redhat.com>
 <1226461390-5502-3-git-send-email-vaurora@redhat.com>
 <1226461390-5502-4-git-send-email-vaurora@redhat.com>
 <1226461390-5502-5-git-send-email-vaurora@redhat.com>
 <1226461390-5502-6-git-send-email-vaurora@redhat.com>
 <1226461390-5502-7-git-send-email-vaurora@redhat.com>
Cc: Valerie Aurora Henson <vaurora@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:42466 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752047AbYKLDn4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Nov 2008 22:43:56 -0500
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id mAC3hucn007437
	for <linux-ext4@vger.kernel.org>; Tue, 11 Nov 2008 22:43:56 -0500
In-Reply-To: <1226461390-5502-7-git-send-email-vaurora@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Valerie Aurora Henson <vaurora@redhat.com>
---
 e2fsck/e2fsck.h  |   20 +++++-----
 e2fsck/journal.c |    2 +-
 e2fsck/pass1.c   |  103 +++++++++++++++++++++++++++++-------------------------
 e2fsck/pass1b.c  |   32 ++++++++--------
 e2fsck/pass2.c   |   30 ++++++++--------
 e2fsck/pass3.c   |   50 +++++++++++++-------------
 e2fsck/pass4.c   |    8 ++--
 e2fsck/pass5.c   |   58 +++++++++++++++---------------
 e2fsck/rehash.c  |    2 +-
 e2fsck/super.c   |    2 +-
 10 files changed, 157 insertions(+), 150 deletions(-)

diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index 53c8f54..28f97d7 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -220,16 +220,16 @@ struct e2fsck_struct {
 	int (*progress)(e2fsck_t ctx, int pass, unsigned long cur,
 			unsigned long max);
 
-	ext2fs_inode_bitmap inode_used_map; /* Inodes which are in use */
-	ext2fs_inode_bitmap inode_bad_map; /* Inodes which are bad somehow */
-	ext2fs_inode_bitmap inode_dir_map; /* Inodes which are directories */
-	ext2fs_inode_bitmap inode_bb_map; /* Inodes which are in bad blocks */
-	ext2fs_inode_bitmap inode_imagic_map; /* AFS inodes */
-	ext2fs_inode_bitmap inode_reg_map; /* Inodes which are regular files*/
-
-	ext2fs_block_bitmap block_found_map; /* Blocks which are in use */
-	ext2fs_block_bitmap block_dup_map; /* Blks referenced more than once */
-	ext2fs_block_bitmap block_ea_map; /* Blocks which are used by EA's */
+	ext2fs_inode_bitmap64 inode_used_map; /* Inodes which are in use */
+	ext2fs_inode_bitmap64 inode_bad_map; /* Inodes which are bad somehow */
+	ext2fs_inode_bitmap64 inode_dir_map; /* Inodes which are directories */
+	ext2fs_inode_bitmap64 inode_bb_map; /* Inodes which are in bad blocks */
+	ext2fs_inode_bitmap64 inode_imagic_map; /* AFS inodes */
+	ext2fs_inode_bitmap64 inode_reg_map; /* Inodes which are regular files*/
+
+	ext2fs_block_bitmap64 block_found_map; /* Blocks which are in use */
+	ext2fs_block_bitmap64 block_dup_map; /* Blks referenced more than once */
+	ext2fs_block_bitmap64 block_ea_map; /* Blocks which are used by EA's */
 
 	/*
 	 * Inode count arrays
diff --git a/e2fsck/journal.c b/e2fsck/journal.c
index 10f5095..4dc8278 100644
--- a/e2fsck/journal.c
+++ b/e2fsck/journal.c
@@ -1000,7 +1000,7 @@ void e2fsck_move_ext3_journal(e2fsck_t ctx)
 		goto err_out;
 
 	group = ext2fs_group_of_ino(fs, ino);
-	ext2fs_unmark_inode_bitmap(fs->inode_map, ino);
+	ext2fs_unmark_inode_bitmap2(fs->inode_map, ino);
 	ext2fs_mark_ib_dirty(fs);
 	fs->group_desc[group].bg_free_inodes_count++;
 	ext2fs_group_desc_csum_set(fs, group);
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 8bbf7fe..605c474 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -87,7 +87,7 @@ struct process_block_struct {
 	blk_t		previous_block;
 	struct ext2_inode *inode;
 	struct problem_context *pctx;
-	ext2fs_block_bitmap fs_meta_blocks;
+	ext2fs_block_bitmap64 fs_meta_blocks;
 	e2fsck_t	ctx;
 };
 
@@ -419,7 +419,7 @@ static void check_is_really_dir(e2fsck_t ctx, struct problem_context *pctx,
 
 		if (blk < ctx->fs->super->s_first_data_block ||
 		    blk >= ctx->fs->super->s_blocks_count ||
-		    ext2fs_fast_test_block_bitmap(ctx->block_found_map, blk))
+		    ext2fs_fast_test_block_bitmap2(ctx->block_found_map, blk))
 			return;	/* Invalid block, can't be dir */
 	}
 
@@ -660,8 +660,8 @@ void e2fsck_pass1(e2fsck_t ctx)
 		if (pctx.errcode == EXT2_ET_BAD_BLOCK_IN_INODE_TABLE) {
 			if (!ctx->inode_bb_map)
 				alloc_bb_map(ctx);
-			ext2fs_mark_inode_bitmap(ctx->inode_bb_map, ino);
-			ext2fs_mark_inode_bitmap(ctx->inode_used_map, ino);
+			ext2fs_mark_inode_bitmap2(ctx->inode_bb_map, ino);
+			ext2fs_mark_inode_bitmap2(ctx->inode_used_map, ino);
 			continue;
 		}
 		if (pctx.errcode) {
@@ -713,7 +713,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 			clear_inode:
 				e2fsck_clear_inode(ctx, ino, inode, 0, "pass1");
 				if (ino == EXT2_BAD_INO)
-					ext2fs_mark_inode_bitmap(ctx->inode_used_map,
+					ext2fs_mark_inode_bitmap2(ctx->inode_used_map,
 								 ino);
 				continue;
 			}
@@ -786,7 +786,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 				ctx->flags |= E2F_FLAG_ABORT;
 				return;
 			}
-			ext2fs_mark_inode_bitmap(ctx->inode_used_map, ino);
+			ext2fs_mark_inode_bitmap2(ctx->inode_used_map, ino);
 			clear_problem_context(&pctx);
 			continue;
 		} else if (ino == EXT2_ROOT_INO) {
@@ -816,7 +816,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 				}
 			}
 		} else if (ino == EXT2_JOURNAL_INO) {
-			ext2fs_mark_inode_bitmap(ctx->inode_used_map, ino);
+			ext2fs_mark_inode_bitmap2(ctx->inode_used_map, ino);
 			if (fs->super->s_journal_inum == EXT2_JOURNAL_INO) {
 				if (!LINUX_S_ISREG(inode->i_mode) &&
 				    fix_problem(ctx, PR_1_JOURNAL_BAD_MODE,
@@ -841,7 +841,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 		} else if (ino < EXT2_FIRST_INODE(fs->super)) {
 			int	problem = 0;
 
-			ext2fs_mark_inode_bitmap(ctx->inode_used_map, ino);
+			ext2fs_mark_inode_bitmap2(ctx->inode_used_map, ino);
 			if (ino == EXT2_BOOT_LOADER_INO) {
 				if (LINUX_S_ISDIR(inode->i_mode))
 					problem = PR_1_RESERVED_BAD_MODE;
@@ -922,7 +922,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 			}
 		}
 
-		ext2fs_mark_inode_bitmap(ctx->inode_used_map, ino);
+		ext2fs_mark_inode_bitmap2(ctx->inode_used_map, ino);
 		switch (fs->super->s_creator_os) {
 		    case EXT2_OS_HURD:
 			frag = inode->osd2.hurd2.h_i_frag;
@@ -944,7 +944,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 			if (imagic_fs) {
 				if (!ctx->inode_imagic_map)
 					alloc_imagic_map(ctx);
-				ext2fs_mark_inode_bitmap(ctx->inode_imagic_map,
+				ext2fs_mark_inode_bitmap2(ctx->inode_imagic_map,
 							 ino);
 			} else {
 				if (fix_problem(ctx, PR_1_SET_IMAGIC, &pctx)) {
@@ -971,11 +971,11 @@ void e2fsck_pass1(e2fsck_t ctx)
 		}
 
 		if (LINUX_S_ISDIR(inode->i_mode)) {
-			ext2fs_mark_inode_bitmap(ctx->inode_dir_map, ino);
+			ext2fs_mark_inode_bitmap2(ctx->inode_dir_map, ino);
 			e2fsck_add_dir_info(ctx, ino, 0);
 			ctx->fs_directory_count++;
 		} else if (LINUX_S_ISREG (inode->i_mode)) {
-			ext2fs_mark_inode_bitmap(ctx->inode_reg_map, ino);
+			ext2fs_mark_inode_bitmap2(ctx->inode_reg_map, ino);
 			ctx->fs_regular_count++;
 		} else if (LINUX_S_ISCHR (inode->i_mode) &&
 			   e2fsck_pass1_check_device_inode(fs, inode)) {
@@ -1069,7 +1069,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 	}
 
 	if (ctx->flags & E2F_FLAG_RESIZE_INODE) {
-		ext2fs_block_bitmap save_bmap;
+		ext2fs_block_bitmap64 save_bmap;
 
 		save_bmap = fs->block_map;
 		fs->block_map = ctx->block_found_map;
@@ -1229,7 +1229,7 @@ static void mark_inode_bad(e2fsck_t ctx, ino_t ino)
 			return;
 		}
 	}
-	ext2fs_mark_inode_bitmap(ctx->inode_bad_map, ino);
+	ext2fs_mark_inode_bitmap2(ctx->inode_bad_map, ino);
 }
 
 
@@ -1286,7 +1286,7 @@ static _INLINE_ void mark_block_used(e2fsck_t ctx, blk_t block)
 
 	clear_problem_context(&pctx);
 
-	if (ext2fs_fast_test_block_bitmap(ctx->block_found_map, block)) {
+	if (ext2fs_fast_test_block_bitmap2(ctx->block_found_map, block)) {
 		if (!ctx->block_dup_map) {
 			pctx.errcode = ext2fs_allocate_block_bitmap(ctx->fs,
 			      _("multiply claimed block map"),
@@ -1300,9 +1300,9 @@ static _INLINE_ void mark_block_used(e2fsck_t ctx, blk_t block)
 				return;
 			}
 		}
-		ext2fs_fast_mark_block_bitmap(ctx->block_dup_map, block);
+		ext2fs_fast_mark_block_bitmap2(ctx->block_dup_map, block);
 	} else {
-		ext2fs_fast_mark_block_bitmap(ctx->block_found_map, block);
+		ext2fs_fast_mark_block_bitmap2(ctx->block_found_map, block);
 	}
 }
 
@@ -1415,7 +1415,7 @@ static int check_ext_attr(e2fsck_t ctx, struct problem_context *pctx,
 #endif
 
 	/* Have we seen this EA block before? */
-	if (ext2fs_fast_test_block_bitmap(ctx->block_ea_map, blk)) {
+	if (ext2fs_fast_test_block_bitmap2(ctx->block_ea_map, blk)) {
 		if (ea_refcount_decrement(ctx->refcount, blk, 0) == 0)
 			return 1;
 		/* Ooops, this EA was referenced more than it stated */
@@ -1524,7 +1524,7 @@ static int check_ext_attr(e2fsck_t ctx, struct problem_context *pctx,
 	if (count)
 		ea_refcount_store(ctx->refcount, blk, count);
 	mark_block_used(ctx, blk);
-	ext2fs_fast_mark_block_bitmap(ctx->block_ea_map, blk);
+	ext2fs_fast_mark_block_bitmap2(ctx->block_ea_map, blk);
 	return 1;
 
 clear_extattr:
@@ -1602,12 +1602,12 @@ void e2fsck_clear_inode(e2fsck_t ctx, ext2_ino_t ino,
 	ext2fs_icount_store(ctx->inode_link_info, ino, 0);
 	inode->i_dtime = ctx->now;
 
-	ext2fs_unmark_inode_bitmap(ctx->inode_dir_map, ino);
-	ext2fs_unmark_inode_bitmap(ctx->inode_used_map, ino);
+	ext2fs_unmark_inode_bitmap2(ctx->inode_dir_map, ino);
+	ext2fs_unmark_inode_bitmap2(ctx->inode_used_map, ino);
 	if (ctx->inode_reg_map)
-		ext2fs_unmark_inode_bitmap(ctx->inode_reg_map, ino);
+		ext2fs_unmark_inode_bitmap2(ctx->inode_reg_map, ino);
 	if (ctx->inode_bad_map)
-		ext2fs_unmark_inode_bitmap(ctx->inode_bad_map, ino);
+		ext2fs_unmark_inode_bitmap2(ctx->inode_bad_map, ino);
 
 	/*
 	 * If the inode was partially accounted for before processing
@@ -2219,13 +2219,13 @@ static int process_bad_block(ext2_filsys fs,
 	}
 
 	if (blockcnt < 0) {
-		if (ext2fs_test_block_bitmap(p->fs_meta_blocks, blk)) {
+		if (ext2fs_test_block_bitmap2(p->fs_meta_blocks, blk)) {
 			p->bbcheck = 1;
 			if (fix_problem(ctx, PR_1_BB_FS_BLOCK, pctx)) {
 				*block_nr = 0;
 				return BLOCK_CHANGED;
 			}
-		} else if (ext2fs_test_block_bitmap(ctx->block_found_map,
+		} else if (ext2fs_test_block_bitmap2(ctx->block_found_map,
 						    blk)) {
 			p->bbcheck = 1;
 			if (fix_problem(ctx, PR_1_BBINODE_BAD_METABLOCK,
@@ -2249,8 +2249,8 @@ static int process_bad_block(ext2_filsys fs,
 	 * there's an overlap between the filesystem table blocks
 	 * (bitmaps and inode table) and the bad block list.
 	 */
-	if (!ext2fs_test_block_bitmap(ctx->block_found_map, blk)) {
-		ext2fs_mark_block_bitmap(ctx->block_found_map, blk);
+	if (!ext2fs_test_block_bitmap2(ctx->block_found_map, blk)) {
+		ext2fs_mark_block_bitmap2(ctx->block_found_map, blk);
 		return 0;
 	}
 	/*
@@ -2343,12 +2343,12 @@ static int process_bad_block(ext2_filsys fs,
 	return 0;
 }
 
-static void new_table_block(e2fsck_t ctx, blk_t first_block, int group,
-			    const char *name, int num, blk_t *new_block)
+static void new_table_block(e2fsck_t ctx, blk64_t first_block, int group,
+			    const char *name, int num, blk64_t *new_block)
 {
 	ext2_filsys fs = ctx->fs;
-	blk_t		old_block = *new_block;
-	blk_t		last_block;
+	blk64_t		old_block = *new_block;
+	blk64_t		last_block;
 	int		i;
 	char		*buf;
 	struct problem_context	pctx;
@@ -2360,7 +2360,7 @@ static void new_table_block(e2fsck_t ctx, blk_t first_block, int group,
 	pctx.str = name;
 
 	last_block = ext2fs_group_last_block(fs, group);
-	pctx.errcode = ext2fs_get_free_blocks(fs, first_block, last_block,
+	pctx.errcode = ext2fs_get_free_blocks2(fs, first_block, last_block,
 					num, ctx->block_found_map, new_block);
 	if (pctx.errcode) {
 		pctx.num = num;
@@ -2382,7 +2382,7 @@ static void new_table_block(e2fsck_t ctx, blk_t first_block, int group,
 	pctx.blk2 = 0;
 	for (i = 0; i < num; i++) {
 		pctx.blk = i;
-		ext2fs_mark_block_bitmap(ctx->block_found_map, (*new_block)+i);
+		ext2fs_mark_block_bitmap2(ctx->block_found_map, (*new_block)+i);
 		if (old_block) {
 			pctx.errcode = io_channel_read_blk(fs->io,
 				   old_block + i, 1, buf);
@@ -2411,23 +2411,30 @@ static void handle_fs_bad_blocks(e2fsck_t ctx)
 {
 	ext2_filsys fs = ctx->fs;
 	dgrp_t		i;
-	blk_t		first_block;
+	blk64_t		first_block;
+	blk64_t		new_blk;
 
 	for (i = 0; i < fs->group_desc_count; i++) {
 		first_block = ext2fs_group_first_block(fs, i);
 
 		if (ctx->invalid_block_bitmap_flag[i]) {
+			new_blk = ext2fs_block_bitmap_loc(fs, i);
 			new_table_block(ctx, first_block, i, _("block bitmap"),
-					1, &fs->group_desc[i].bg_block_bitmap);
+					1, &new_blk);
+			ext2fs_block_bitmap_loc_set(fs, i, new_blk);
 		}
 		if (ctx->invalid_inode_bitmap_flag[i]) {
+			new_blk = ext2fs_inode_bitmap_loc(fs, i);
 			new_table_block(ctx, first_block, i, _("inode bitmap"),
-					1, &fs->group_desc[i].bg_inode_bitmap);
+					1, &new_blk);
+			ext2fs_inode_bitmap_loc_set(fs, i, new_blk);
 		}
 		if (ctx->invalid_inode_table_flag[i]) {
+			new_blk = ext2fs_inode_table_loc(fs, i);
 			new_table_block(ctx, first_block, i, _("inode table"),
 					fs->inode_blocks_per_group,
-					&fs->group_desc[i].bg_inode_table);
+					&new_blk);
+			ext2fs_inode_table_loc_set(fs, i, new_blk);
 			ctx->flags |= E2F_FLAG_RESTART;
 		}
 	}
@@ -2460,7 +2467,7 @@ static void mark_table_blocks(e2fsck_t ctx)
 			for (j = 0, b = fs->group_desc[i].bg_inode_table;
 			     j < fs->inode_blocks_per_group;
 			     j++, b++) {
-				if (ext2fs_test_block_bitmap(ctx->block_found_map,
+				if (ext2fs_test_block_bitmap2(ctx->block_found_map,
 							     b)) {
 					pctx.blk = b;
 					if (fix_problem(ctx,
@@ -2469,7 +2476,7 @@ static void mark_table_blocks(e2fsck_t ctx)
 						ctx->invalid_bitmaps++;
 					}
 				} else {
-				    ext2fs_mark_block_bitmap(ctx->block_found_map,
+				    ext2fs_mark_block_bitmap2(ctx->block_found_map,
 							     b);
 			    	}
 			}
@@ -2479,7 +2486,7 @@ static void mark_table_blocks(e2fsck_t ctx)
 		 * Mark block used for the block bitmap
 		 */
 		if (fs->group_desc[i].bg_block_bitmap) {
-			if (ext2fs_test_block_bitmap(ctx->block_found_map,
+			if (ext2fs_test_block_bitmap2(ctx->block_found_map,
 				     fs->group_desc[i].bg_block_bitmap)) {
 				pctx.blk = fs->group_desc[i].bg_block_bitmap;
 				if (fix_problem(ctx, PR_1_BB_CONFLICT, &pctx)) {
@@ -2487,7 +2494,7 @@ static void mark_table_blocks(e2fsck_t ctx)
 					ctx->invalid_bitmaps++;
 				}
 			} else {
-			    ext2fs_mark_block_bitmap(ctx->block_found_map,
+			    ext2fs_mark_block_bitmap2(ctx->block_found_map,
 				     fs->group_desc[i].bg_block_bitmap);
 		    }
 
@@ -2496,7 +2503,7 @@ static void mark_table_blocks(e2fsck_t ctx)
 		 * Mark block used for the inode bitmap
 		 */
 		if (fs->group_desc[i].bg_inode_bitmap) {
-			if (ext2fs_test_block_bitmap(ctx->block_found_map,
+			if (ext2fs_test_block_bitmap2(ctx->block_found_map,
 				     fs->group_desc[i].bg_inode_bitmap)) {
 				pctx.blk = fs->group_desc[i].bg_inode_bitmap;
 				if (fix_problem(ctx, PR_1_IB_CONFLICT, &pctx)) {
@@ -2504,7 +2511,7 @@ static void mark_table_blocks(e2fsck_t ctx)
 					ctx->invalid_bitmaps++;
 				}
 			} else {
-			    ext2fs_mark_block_bitmap(ctx->block_found_map,
+			    ext2fs_mark_block_bitmap2(ctx->block_found_map,
 				     fs->group_desc[i].bg_inode_bitmap);
 			}
 		}
@@ -2570,10 +2577,10 @@ static errcode_t e2fsck_get_alloc_block(ext2_filsys fs, blk64_t goal,
 {
 	e2fsck_t ctx = (e2fsck_t) fs->priv_data;
 	errcode_t	retval;
-	blk_t		new_block;
+	blk64_t		new_block;
 
 	if (ctx->block_found_map) {
-		retval = ext2fs_new_block(fs, (blk_t) goal,
+		retval = ext2fs_new_block2(fs, (blk_t) goal,
 					  ctx->block_found_map, &new_block);
 		if (retval)
 			return retval;
@@ -2584,7 +2591,7 @@ static errcode_t e2fsck_get_alloc_block(ext2_filsys fs, blk64_t goal,
 				return retval;
 		}
 
-		retval = ext2fs_new_block(fs, (blk_t) goal, 0, &new_block);
+		retval = ext2fs_new_block2(fs, (blk_t) goal, 0, &new_block);
 		if (retval)
 			return retval;
 	}
@@ -2599,10 +2606,10 @@ static void e2fsck_block_alloc_stats(ext2_filsys fs, blk64_t blk, int inuse)
 
 	if (ctx->block_found_map) {
 		if (inuse > 0)
-			ext2fs_mark_block_bitmap(ctx->block_found_map,
+			ext2fs_mark_block_bitmap2(ctx->block_found_map,
 						 (blk_t) blk);
 		else
-			ext2fs_unmark_block_bitmap(ctx->block_found_map,
+			ext2fs_unmark_block_bitmap2(ctx->block_found_map,
 						   (blk_t) blk);
 	}
 }
diff --git a/e2fsck/pass1b.c b/e2fsck/pass1b.c
index 809bd7f..922cbcf 100644
--- a/e2fsck/pass1b.c
+++ b/e2fsck/pass1b.c
@@ -100,7 +100,7 @@ static int dup_inode_founddir = 0;
 
 static dict_t blk_dict, ino_dict;
 
-static ext2fs_inode_bitmap inode_dup_map;
+static ext2fs_inode_bitmap64 inode_dup_map;
 
 static int dict_int_cmp(const void *a, const void *b)
 {
@@ -284,7 +284,7 @@ static void pass1b(e2fsck_t ctx, char *block_buf)
 			break;
 		pctx.ino = ctx->stashed_ino = ino;
 		if ((ino != EXT2_BAD_INO) &&
-		    !ext2fs_test_inode_bitmap(ctx->inode_used_map, ino))
+		    !ext2fs_test_inode_bitmap2(ctx->inode_used_map, ino))
 			continue;
 
 		pb.ino = ino;
@@ -327,7 +327,7 @@ static int process_pass1b_block(ext2_filsys fs EXT2FS_ATTR((unused)),
 	p = (struct process_block_struct *) priv_data;
 	ctx = p->ctx;
 
-	if (!ext2fs_test_block_bitmap(ctx->block_dup_map, *block_nr))
+	if (!ext2fs_test_block_bitmap2(ctx->block_dup_map, *block_nr))
 		return 0;
 
 	/* OK, this is a duplicate block */
@@ -336,7 +336,7 @@ static int process_pass1b_block(ext2_filsys fs EXT2FS_ATTR((unused)),
 		fix_problem(ctx, PR_1B_DUP_BLOCK, p->pctx);
 	}
 	p->dup_blocks++;
-	ext2fs_mark_inode_bitmap(inode_dup_map, p->ino);
+	ext2fs_mark_inode_bitmap2(inode_dup_map, p->ino);
 
 	add_dupe(ctx, p->ino, *block_nr, p->inode);
 
@@ -372,7 +372,7 @@ static int search_dirent_proc(ext2_ino_t dir, int entry,
 		return 0;
 
 	if ((dirent->inode < sd->first_inode) || (entry < DIRENT_OTHER_FILE) ||
-	    !ext2fs_test_inode_bitmap(inode_dup_map, dirent->inode))
+	    !ext2fs_test_inode_bitmap2(inode_dup_map, dirent->inode))
 		return 0;
 
 	n = dict_lookup(&ino_dict, INT_TO_VOIDPTR(dirent->inode));
@@ -536,7 +536,7 @@ static void decrement_badcount(e2fsck_t ctx, blk_t block, struct dup_block *p)
 	p->num_bad--;
 	if (p->num_bad <= 0 ||
 	    (p->num_bad == 1 && !check_if_fs_block(ctx, block)))
-		ext2fs_unmark_block_bitmap(ctx->block_dup_map, block);
+		ext2fs_unmark_block_bitmap2(ctx->block_dup_map, block);
 }
 
 static int delete_file_block(ext2_filsys fs,
@@ -557,7 +557,7 @@ static int delete_file_block(ext2_filsys fs,
 	if (HOLE_BLKADDR(*block_nr))
 		return 0;
 
-	if (ext2fs_test_block_bitmap(ctx->block_dup_map, *block_nr)) {
+	if (ext2fs_test_block_bitmap2(ctx->block_dup_map, *block_nr)) {
 		n = dict_lookup(&blk_dict, INT_TO_VOIDPTR(*block_nr));
 		if (n) {
 			p = (struct dup_block *) dnode_get(n);
@@ -567,7 +567,7 @@ static int delete_file_block(ext2_filsys fs,
 			    _("internal error: can't find dup_blk for %u\n"),
 				*block_nr);
 	} else {
-		ext2fs_unmark_block_bitmap(ctx->block_found_map, *block_nr);
+		ext2fs_unmark_block_bitmap2(ctx->block_found_map, *block_nr);
 		ext2fs_block_alloc_stats(fs, *block_nr, -1);
 	}
 
@@ -596,7 +596,7 @@ static void delete_file(e2fsck_t ctx, ext2_ino_t ino,
 	if (pctx.errcode)
 		fix_problem(ctx, PR_1B_BLOCK_ITERATE, &pctx);
 	if (ctx->inode_bad_map)
-		ext2fs_unmark_inode_bitmap(ctx->inode_bad_map, ino);
+		ext2fs_unmark_inode_bitmap2(ctx->inode_bad_map, ino);
 	ext2fs_inode_alloc_stats2(fs, ino, -1, LINUX_S_ISDIR(inode.i_mode));
 
 	/* Inode may have changed by block_iterate, so reread it */
@@ -622,7 +622,7 @@ static void delete_file(e2fsck_t ctx, ext2_ino_t ino,
 		 * of keeping the accounting straight.
 		 */
 		if ((count == 0) ||
-		    ext2fs_test_block_bitmap(ctx->block_dup_map,
+		    ext2fs_test_block_bitmap2(ctx->block_dup_map,
 					     inode.i_file_acl))
 			delete_file_block(fs, &inode.i_file_acl,
 					  BLOCK_COUNT_EXTATTR, 0, 0, &pb);
@@ -644,7 +644,7 @@ static int clone_file_block(ext2_filsys fs,
 			    void *priv_data)
 {
 	struct dup_block *p;
-	blk_t	new_block;
+	blk64_t	new_block;
 	errcode_t	retval;
 	struct clone_struct *cs = (struct clone_struct *) priv_data;
 	dnode_t *n;
@@ -655,11 +655,11 @@ static int clone_file_block(ext2_filsys fs,
 	if (HOLE_BLKADDR(*block_nr))
 		return 0;
 
-	if (ext2fs_test_block_bitmap(ctx->block_dup_map, *block_nr)) {
+	if (ext2fs_test_block_bitmap2(ctx->block_dup_map, *block_nr)) {
 		n = dict_lookup(&blk_dict, INT_TO_VOIDPTR(*block_nr));
 		if (n) {
 			p = (struct dup_block *) dnode_get(n);
-			retval = ext2fs_new_block(fs, 0, ctx->block_found_map,
+			retval = ext2fs_new_block2(fs, 0, ctx->block_found_map,
 						  &new_block);
 			if (retval) {
 				cs->errcode = retval;
@@ -691,9 +691,9 @@ static int clone_file_block(ext2_filsys fs,
 			}
 			decrement_badcount(ctx, *block_nr, p);
 			*block_nr = new_block;
-			ext2fs_mark_block_bitmap(ctx->block_found_map,
+			ext2fs_mark_block_bitmap2(ctx->block_found_map,
 						 new_block);
-			ext2fs_mark_block_bitmap(fs->block_map, new_block);
+			ext2fs_mark_block_bitmap2(fs->block_map, new_block);
 			return BLOCK_CHANGED;
 		} else
 			com_err("clone_file_block", 0,
@@ -724,7 +724,7 @@ static int clone_file(e2fsck_t ctx, ext2_ino_t ino,
 	if (retval)
 		return retval;
 
-	if (ext2fs_test_inode_bitmap(ctx->inode_dir_map, ino))
+	if (ext2fs_test_inode_bitmap2(ctx->inode_dir_map, ino))
 		cs.dir = ino;
 
 	pctx.ino = ino;
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index c36bfcf..afe4be9 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -499,13 +499,13 @@ static _INLINE_ int check_filetype(e2fsck_t ctx,
 		return 1;
 	}
 
-	if (ext2fs_test_inode_bitmap(ctx->inode_dir_map, dirent->inode)) {
+	if (ext2fs_test_inode_bitmap2(ctx->inode_dir_map, dirent->inode)) {
 		should_be = EXT2_FT_DIR;
-	} else if (ext2fs_test_inode_bitmap(ctx->inode_reg_map,
+	} else if (ext2fs_test_inode_bitmap2(ctx->inode_reg_map,
 					    dirent->inode)) {
 		should_be = EXT2_FT_REG_FILE;
 	} else if (ctx->inode_bad_map &&
-		   ext2fs_test_inode_bitmap(ctx->inode_bad_map,
+		   ext2fs_test_inode_bitmap2(ctx->inode_bad_map,
 					    dirent->inode))
 		should_be = 0;
 	else {
@@ -747,7 +747,7 @@ static int check_dir_block(ext2_filsys fs,
 	 * Make sure the inode is still in use (could have been
 	 * deleted in the duplicate/bad blocks pass.
 	 */
-	if (!(ext2fs_test_inode_bitmap(ctx->inode_used_map, ino)))
+	if (!(ext2fs_test_inode_bitmap2(ctx->inode_used_map, ino)))
 		return 0;
 
 	cd->pctx.ino = ino;
@@ -898,7 +898,7 @@ out_htree:
 		    (dirent->inode > fs->super->s_inodes_count)) {
 			problem = PR_2_BAD_INO;
 		} else if (ctx->inode_bb_map &&
-			   (ext2fs_test_inode_bitmap(ctx->inode_bb_map,
+			   (ext2fs_test_inode_bitmap2(ctx->inode_bb_map,
 						     dirent->inode))) {
 			/*
 			 * If the inode is in a bad block, offer to
@@ -960,7 +960,7 @@ out_htree:
 		 * pathname to the user.)
 		 */
 		if (ctx->inode_bad_map &&
-		    ext2fs_test_inode_bitmap(ctx->inode_bad_map,
+		    ext2fs_test_inode_bitmap2(ctx->inode_bad_map,
 					     dirent->inode)) {
 			if (e2fsck_process_bad_inode(ctx, ino,
 						     dirent->inode,
@@ -1014,7 +1014,7 @@ out_htree:
 			}
 		}
 
-		if (!(ext2fs_test_inode_bitmap(ctx->inode_used_map,
+		if (!(ext2fs_test_inode_bitmap2(ctx->inode_used_map,
 					       dirent->inode))) {
 			/*
 			 * If the inode is unused, offer to clear it.
@@ -1060,7 +1060,7 @@ out_htree:
 		 * and ask the user if he/she wants to clear this one.
 		 */
 		if ((dot_state > 1) &&
-		    (ext2fs_test_inode_bitmap(ctx->inode_dir_map,
+		    (ext2fs_test_inode_bitmap2(ctx->inode_dir_map,
 					      dirent->inode))) {
 			if (e2fsck_dir_info_get_parent(ctx, dirent->inode,
 						       &subdir_parent)) {
@@ -1170,7 +1170,7 @@ static int deallocate_inode_block(ext2_filsys fs,
 	if ((*block_nr < fs->super->s_first_data_block) ||
 	    (*block_nr >= fs->super->s_blocks_count))
 		return 0;
-	ext2fs_unmark_block_bitmap(ctx->block_found_map, *block_nr);
+	ext2fs_unmark_block_bitmap2(ctx->block_found_map, *block_nr);
 	ext2fs_block_alloc_stats(fs, *block_nr, -1);
 	return 0;
 }
@@ -1211,7 +1211,7 @@ static void deallocate_inode(e2fsck_t ctx, ext2_ino_t ino, char* block_buf)
 			return;
 		}
 		if (count == 0) {
-			ext2fs_unmark_block_bitmap(ctx->block_found_map,
+			ext2fs_unmark_block_bitmap2(ctx->block_found_map,
 						   inode.i_file_acl);
 			ext2fs_block_alloc_stats(fs, inode.i_file_acl, -1);
 		}
@@ -1376,7 +1376,7 @@ extern int e2fsck_process_bad_inode(e2fsck_t ctx, ext2_ino_t dir,
 	if (inode_modified)
 		e2fsck_write_inode(ctx, ino, &inode, "process_bad_inode");
 	if (!not_fixed && ctx->inode_bad_map)
-		ext2fs_unmark_inode_bitmap(ctx->inode_bad_map, ino);
+		ext2fs_unmark_inode_bitmap2(ctx->inode_bad_map, ino);
 	return 0;
 }
 
@@ -1393,7 +1393,7 @@ static int allocate_dir_block(e2fsck_t ctx,
 			      struct problem_context *pctx)
 {
 	ext2_filsys fs = ctx->fs;
-	blk_t			blk;
+	blk64_t			blk;
 	char			*block;
 	struct ext2_inode	inode;
 
@@ -1409,14 +1409,14 @@ static int allocate_dir_block(e2fsck_t ctx,
 	/*
 	 * First, find a free block
 	 */
-	pctx->errcode = ext2fs_new_block(fs, 0, ctx->block_found_map, &blk);
+	pctx->errcode = ext2fs_new_block2(fs, 0, ctx->block_found_map, &blk);
 	if (pctx->errcode) {
 		pctx->str = "ext2fs_new_block";
 		fix_problem(ctx, PR_2_ALLOC_DIRBOCK, pctx);
 		return 1;
 	}
-	ext2fs_mark_block_bitmap(ctx->block_found_map, blk);
-	ext2fs_mark_block_bitmap(fs->block_map, blk);
+	ext2fs_mark_block_bitmap2(ctx->block_found_map, blk);
+	ext2fs_mark_block_bitmap2(fs->block_map, blk);
 	ext2fs_mark_bb_dirty(fs);
 
 	/*
diff --git a/e2fsck/pass3.c b/e2fsck/pass3.c
index a14bc5d..5102438 100644
--- a/e2fsck/pass3.c
+++ b/e2fsck/pass3.c
@@ -46,8 +46,8 @@ static int check_directory(e2fsck_t ctx, ext2_ino_t ino,
 			   struct problem_context *pctx);
 static void fix_dotdot(e2fsck_t ctx, ext2_ino_t ino, ext2_ino_t parent);
 
-static ext2fs_inode_bitmap inode_loop_detect = 0;
-static ext2fs_inode_bitmap inode_done_map = 0;
+static ext2fs_inode_bitmap64 inode_loop_detect = 0;
+static ext2fs_inode_bitmap64 inode_done_map = 0;
 
 void e2fsck_pass3(e2fsck_t ctx)
 {
@@ -96,7 +96,7 @@ void e2fsck_pass3(e2fsck_t ctx)
 	if (ctx->flags & E2F_FLAG_SIGNAL_MASK)
 		goto abort_exit;
 
-	ext2fs_mark_inode_bitmap(inode_done_map, EXT2_ROOT_INO);
+	ext2fs_mark_inode_bitmap2(inode_done_map, EXT2_ROOT_INO);
 
 	maxdirs = e2fsck_get_num_dirinfo(ctx);
 	count = 1;
@@ -111,7 +111,7 @@ void e2fsck_pass3(e2fsck_t ctx)
 			goto abort_exit;
 		if (ctx->progress && (ctx->progress)(ctx, 3, count++, maxdirs))
 			goto abort_exit;
-		if (ext2fs_test_inode_bitmap(ctx->inode_dir_map, dir->ino))
+		if (ext2fs_test_inode_bitmap2(ctx->inode_dir_map, dir->ino))
 			if (check_directory(ctx, dir->ino, &pctx))
 				goto abort_exit;
 	}
@@ -155,20 +155,20 @@ abort_exit:
 static void check_root(e2fsck_t ctx)
 {
 	ext2_filsys fs = ctx->fs;
-	blk_t			blk;
+	blk64_t			blk;
 	struct ext2_inode	inode;
 	char *			block;
 	struct problem_context	pctx;
 
 	clear_problem_context(&pctx);
 
-	if (ext2fs_test_inode_bitmap(ctx->inode_used_map, EXT2_ROOT_INO)) {
+	if (ext2fs_test_inode_bitmap2(ctx->inode_used_map, EXT2_ROOT_INO)) {
 		/*
 		 * If the root inode is not a directory, die here.  The
 		 * user must have answered 'no' in pass1 when we
 		 * offered to clear it.
 		 */
-		if (!(ext2fs_test_inode_bitmap(ctx->inode_dir_map,
+		if (!(ext2fs_test_inode_bitmap2(ctx->inode_dir_map,
 					       EXT2_ROOT_INO))) {
 			fix_problem(ctx, PR_3_ROOT_NOT_DIR_ABORT, &pctx);
 			ctx->flags |= E2F_FLAG_ABORT;
@@ -187,15 +187,15 @@ static void check_root(e2fsck_t ctx)
 	/*
 	 * First, find a free block
 	 */
-	pctx.errcode = ext2fs_new_block(fs, 0, ctx->block_found_map, &blk);
+	pctx.errcode = ext2fs_new_block2(fs, 0, ctx->block_found_map, &blk);
 	if (pctx.errcode) {
 		pctx.str = "ext2fs_new_block";
 		fix_problem(ctx, PR_3_CREATE_ROOT_ERROR, &pctx);
 		ctx->flags |= E2F_FLAG_ABORT;
 		return;
 	}
-	ext2fs_mark_block_bitmap(ctx->block_found_map, blk);
-	ext2fs_mark_block_bitmap(fs->block_map, blk);
+	ext2fs_mark_block_bitmap2(ctx->block_found_map, blk);
+	ext2fs_mark_block_bitmap2(fs->block_map, blk);
 	ext2fs_mark_bb_dirty(fs);
 
 	/*
@@ -248,9 +248,9 @@ static void check_root(e2fsck_t ctx)
 	ext2fs_icount_store(ctx->inode_count, EXT2_ROOT_INO, 2);
 	ext2fs_icount_store(ctx->inode_link_info, EXT2_ROOT_INO, 2);
 
-	ext2fs_mark_inode_bitmap(ctx->inode_used_map, EXT2_ROOT_INO);
-	ext2fs_mark_inode_bitmap(ctx->inode_dir_map, EXT2_ROOT_INO);
-	ext2fs_mark_inode_bitmap(fs->inode_map, EXT2_ROOT_INO);
+	ext2fs_mark_inode_bitmap2(ctx->inode_used_map, EXT2_ROOT_INO);
+	ext2fs_mark_inode_bitmap2(ctx->inode_dir_map, EXT2_ROOT_INO);
+	ext2fs_mark_inode_bitmap2(fs->inode_map, EXT2_ROOT_INO);
 	ext2fs_mark_ib_dirty(fs);
 }
 
@@ -288,7 +288,7 @@ static int check_directory(e2fsck_t ctx, ext2_ino_t dir,
 		 * If it was marked done already, then we've reached a
 		 * parent we've already checked.
 		 */
-	  	if (ext2fs_mark_inode_bitmap(inode_done_map, ino))
+	  	if (ext2fs_mark_inode_bitmap2(inode_done_map, ino))
 			break;
 
 		if (e2fsck_dir_info_get_parent(ctx, ino, &parent)) {
@@ -303,7 +303,7 @@ static int check_directory(e2fsck_t ctx, ext2_ino_t dir,
 		 */
 		if (!parent ||
 		    (loop_pass &&
-		     (ext2fs_test_inode_bitmap(inode_loop_detect,
+		     (ext2fs_test_inode_bitmap2(inode_loop_detect,
 					       parent)))) {
 			pctx->ino = ino;
 			if (fix_problem(ctx, PR_3_UNCONNECTED_DIR, pctx)) {
@@ -319,7 +319,7 @@ static int check_directory(e2fsck_t ctx, ext2_ino_t dir,
 		}
 		ino = parent;
 		if (loop_pass) {
-			ext2fs_mark_inode_bitmap(inode_loop_detect, ino);
+			ext2fs_mark_inode_bitmap2(inode_loop_detect, ino);
 		} else if (parent_count++ > 2048) {
 			/*
 			 * If we've run into a path depth that's
@@ -369,7 +369,7 @@ ext2_ino_t e2fsck_get_lost_and_found(e2fsck_t ctx, int fix)
 {
 	ext2_filsys fs = ctx->fs;
 	ext2_ino_t			ino;
-	blk_t			blk;
+	blk64_t			blk;
 	errcode_t		retval;
 	struct ext2_inode	inode;
 	char *			block;
@@ -386,7 +386,7 @@ ext2_ino_t e2fsck_get_lost_and_found(e2fsck_t ctx, int fix)
 	if (retval && !fix)
 		return 0;
 	if (!retval) {
-		if (ext2fs_test_inode_bitmap(ctx->inode_dir_map, ino)) {
+		if (ext2fs_test_inode_bitmap2(ctx->inode_dir_map, ino)) {
 			ctx->lost_and_found = ino;
 			return ino;
 		}
@@ -423,13 +423,13 @@ ext2_ino_t e2fsck_get_lost_and_found(e2fsck_t ctx, int fix)
 	/*
 	 * First, find a free block
 	 */
-	retval = ext2fs_new_block(fs, 0, ctx->block_found_map, &blk);
+	retval = ext2fs_new_block2(fs, 0, ctx->block_found_map, &blk);
 	if (retval) {
 		pctx.errcode = retval;
 		fix_problem(ctx, PR_3_ERR_LPF_NEW_BLOCK, &pctx);
 		return 0;
 	}
-	ext2fs_mark_block_bitmap(ctx->block_found_map, blk);
+	ext2fs_mark_block_bitmap2(ctx->block_found_map, blk);
 	ext2fs_block_alloc_stats(fs, blk, +1);
 
 	/*
@@ -442,8 +442,8 @@ ext2_ino_t e2fsck_get_lost_and_found(e2fsck_t ctx, int fix)
 		fix_problem(ctx, PR_3_ERR_LPF_NEW_INODE, &pctx);
 		return 0;
 	}
-	ext2fs_mark_inode_bitmap(ctx->inode_used_map, ino);
-	ext2fs_mark_inode_bitmap(ctx->inode_dir_map, ino);
+	ext2fs_mark_inode_bitmap2(ctx->inode_used_map, ino);
+	ext2fs_mark_inode_bitmap2(ctx->inode_dir_map, ino);
 	ext2fs_inode_alloc_stats2(fs, ino, +1, 1);
 
 	/*
@@ -705,7 +705,7 @@ static int expand_dir_proc(ext2_filsys fs,
 			   void	*priv_data)
 {
 	struct expand_dir_struct *es = (struct expand_dir_struct *) priv_data;
-	blk_t	new_blk;
+	blk64_t	new_blk;
 	static blk_t	last_blk = 0;
 	char		*block;
 	errcode_t	retval;
@@ -722,7 +722,7 @@ static int expand_dir_proc(ext2_filsys fs,
 		last_blk = *blocknr;
 		return 0;
 	}
-	retval = ext2fs_new_block(fs, last_blk, ctx->block_found_map,
+	retval = ext2fs_new_block2(fs, last_blk, ctx->block_found_map,
 				  &new_blk);
 	if (retval) {
 		es->err = retval;
@@ -751,7 +751,7 @@ static int expand_dir_proc(ext2_filsys fs,
 	}
 	ext2fs_free_mem(&block);
 	*blocknr = new_blk;
-	ext2fs_mark_block_bitmap(ctx->block_found_map, new_blk);
+	ext2fs_mark_block_bitmap2(ctx->block_found_map, new_blk);
 	ext2fs_block_alloc_stats(fs, new_blk, +1);
 	es->newblocks++;
 
diff --git a/e2fsck/pass4.c b/e2fsck/pass4.c
index 7248483..b950cf3 100644
--- a/e2fsck/pass4.c
+++ b/e2fsck/pass4.c
@@ -134,11 +134,11 @@ void e2fsck_pass4(e2fsck_t ctx)
 		if (i == EXT2_BAD_INO ||
 		    (i > EXT2_ROOT_INO && i < EXT2_FIRST_INODE(fs->super)))
 			continue;
-		if (!(ext2fs_test_inode_bitmap(ctx->inode_used_map, i)) ||
+		if (!(ext2fs_test_inode_bitmap2(ctx->inode_used_map, i)) ||
 		    (ctx->inode_imagic_map &&
-		     ext2fs_test_inode_bitmap(ctx->inode_imagic_map, i)) ||
+		     ext2fs_test_inode_bitmap2(ctx->inode_imagic_map, i)) ||
 		    (ctx->inode_bb_map &&
-		     ext2fs_test_inode_bitmap(ctx->inode_bb_map, i)))
+		     ext2fs_test_inode_bitmap2(ctx->inode_bb_map, i)))
 			continue;
 		ext2fs_icount_fetch(ctx->inode_link_info, i, &link_count);
 		ext2fs_icount_fetch(ctx->inode_count, i, &link_counted);
@@ -155,7 +155,7 @@ void e2fsck_pass4(e2fsck_t ctx)
 			ext2fs_icount_fetch(ctx->inode_count, i,
 					    &link_counted);
 		}
-		if (ext2fs_test_inode_bitmap(ctx->inode_dir_map, i) &&
+		if (ext2fs_test_inode_bitmap2(ctx->inode_dir_map, i) &&
 		    (link_counted > EXT2_LINK_MAX))
 			link_counted = 1;
 		if (link_counted != link_count) {
diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index 9959b3f..811fb2a 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -130,14 +130,14 @@ static void check_block_bitmaps(e2fsck_t ctx)
 	    fs->group_desc_count * sizeof(int), "free block count array");
 
 	if ((fs->super->s_first_data_block <
-	     ext2fs_get_block_bitmap_start(ctx->block_found_map)) ||
+	     ext2fs_get_block_bitmap_start2(ctx->block_found_map)) ||
 	    (fs->super->s_blocks_count-1 >
-	     ext2fs_get_block_bitmap_end(ctx->block_found_map))) {
+	     ext2fs_get_block_bitmap_end2(ctx->block_found_map))) {
 		pctx.num = 1;
 		pctx.blk = fs->super->s_first_data_block;
 		pctx.blk2 = fs->super->s_blocks_count -1;
-		pctx.ino = ext2fs_get_block_bitmap_start(ctx->block_found_map);
-		pctx.ino2 = ext2fs_get_block_bitmap_end(ctx->block_found_map);
+		pctx.ino = ext2fs_get_block_bitmap_start2(ctx->block_found_map);
+		pctx.ino2 = ext2fs_get_block_bitmap_end2(ctx->block_found_map);
 		fix_problem(ctx, PR_5_BMAP_ENDPOINTS, &pctx);
 
 		ctx->flags |= E2F_FLAG_ABORT; /* fatal */
@@ -145,14 +145,14 @@ static void check_block_bitmaps(e2fsck_t ctx)
 	}
 
 	if ((fs->super->s_first_data_block <
-	     ext2fs_get_block_bitmap_start(fs->block_map)) ||
+	     ext2fs_get_block_bitmap_start2(fs->block_map)) ||
 	    (fs->super->s_blocks_count-1 >
-	     ext2fs_get_block_bitmap_end(fs->block_map))) {
+	     ext2fs_get_block_bitmap_end2(fs->block_map))) {
 		pctx.num = 2;
 		pctx.blk = fs->super->s_first_data_block;
 		pctx.blk2 = fs->super->s_blocks_count -1;
-		pctx.ino = ext2fs_get_block_bitmap_start(fs->block_map);
-		pctx.ino2 = ext2fs_get_block_bitmap_end(fs->block_map);
+		pctx.ino = ext2fs_get_block_bitmap_start2(fs->block_map);
+		pctx.ino2 = ext2fs_get_block_bitmap_end2(fs->block_map);
 		fix_problem(ctx, PR_5_BMAP_ENDPOINTS, &pctx);
 
 		ctx->flags |= E2F_FLAG_ABORT; /* fatal */
@@ -172,7 +172,7 @@ redo_counts:
 	for (i = fs->super->s_first_data_block;
 	     i < fs->super->s_blocks_count;
 	     i++) {
-		actual = ext2fs_fast_test_block_bitmap(ctx->block_found_map, i);
+		actual = ext2fs_fast_test_block_bitmap2(ctx->block_found_map, i);
 
 		if (skip_group) {
 			blk64_t	super_blk, old_desc_blk, new_desc_blk;
@@ -208,7 +208,7 @@ redo_counts:
 				bitmap = 1;
 			actual = (actual != 0);
 		} else
-			bitmap = ext2fs_fast_test_block_bitmap(fs->block_map, i);
+			bitmap = ext2fs_fast_test_block_bitmap2(fs->block_map, i);
 
 		if (actual == bitmap)
 			goto do_counts;
@@ -359,27 +359,27 @@ static void check_inode_bitmaps(e2fsck_t ctx)
 	dir_array = (int *) e2fsck_allocate_memory(ctx,
 	   fs->group_desc_count * sizeof(int), "directory count array");
 
-	if ((1 < ext2fs_get_inode_bitmap_start(ctx->inode_used_map)) ||
+	if ((1 < ext2fs_get_inode_bitmap_start2(ctx->inode_used_map)) ||
 	    (fs->super->s_inodes_count >
-	     ext2fs_get_inode_bitmap_end(ctx->inode_used_map))) {
+	     ext2fs_get_inode_bitmap_end2(ctx->inode_used_map))) {
 		pctx.num = 3;
 		pctx.blk = 1;
 		pctx.blk2 = fs->super->s_inodes_count;
-		pctx.ino = ext2fs_get_inode_bitmap_start(ctx->inode_used_map);
-		pctx.ino2 = ext2fs_get_inode_bitmap_end(ctx->inode_used_map);
+		pctx.ino = ext2fs_get_inode_bitmap_start2(ctx->inode_used_map);
+		pctx.ino2 = ext2fs_get_inode_bitmap_end2(ctx->inode_used_map);
 		fix_problem(ctx, PR_5_BMAP_ENDPOINTS, &pctx);
 
 		ctx->flags |= E2F_FLAG_ABORT; /* fatal */
 		goto errout;
 	}
-	if ((1 < ext2fs_get_inode_bitmap_start(fs->inode_map)) ||
+	if ((1 < ext2fs_get_inode_bitmap_start2(fs->inode_map)) ||
 	    (fs->super->s_inodes_count >
-	     ext2fs_get_inode_bitmap_end(fs->inode_map))) {
+	     ext2fs_get_inode_bitmap_end2(fs->inode_map))) {
 		pctx.num = 4;
 		pctx.blk = 1;
 		pctx.blk2 = fs->super->s_inodes_count;
-		pctx.ino = ext2fs_get_inode_bitmap_start(fs->inode_map);
-		pctx.ino2 = ext2fs_get_inode_bitmap_end(fs->inode_map);
+		pctx.ino = ext2fs_get_inode_bitmap_start2(fs->inode_map);
+		pctx.ino2 = ext2fs_get_inode_bitmap_end2(fs->inode_map);
 		fix_problem(ctx, PR_5_BMAP_ENDPOINTS, &pctx);
 
 		ctx->flags |= E2F_FLAG_ABORT; /* fatal */
@@ -398,11 +398,11 @@ redo_counts:
 
 	/* Protect loop from wrap-around if inodes_count is maxed */
 	for (i = 1; i <= fs->super->s_inodes_count && i > 0; i++) {
-		actual = ext2fs_fast_test_inode_bitmap(ctx->inode_used_map, i);
+		actual = ext2fs_fast_test_inode_bitmap2(ctx->inode_used_map, i);
 		if (skip_group)
 			bitmap = 0;
 		else
-			bitmap = ext2fs_fast_test_inode_bitmap(fs->inode_map, i);
+			bitmap = ext2fs_fast_test_inode_bitmap2(fs->inode_map, i);
 		if (actual == bitmap)
 			goto do_counts;
 
@@ -450,7 +450,7 @@ redo_counts:
 
 do_counts:
 		if (bitmap) {
-			if (ext2fs_test_inode_bitmap(ctx->inode_dir_map, i))
+			if (ext2fs_test_inode_bitmap2(ctx->inode_dir_map, i))
 				dirs_count++;
 		} else if (!skip_group || csum_flag) {
 			group_free++;
@@ -574,10 +574,10 @@ static void check_inode_end(e2fsck_t ctx)
 
 	/* protect loop from wrap-around if end is maxed */
 	for (i = save_inodes_count + 1; i <= end && i > save_inodes_count; i++) {
-		if (!ext2fs_test_inode_bitmap(fs->inode_map, i)) {
+		if (!ext2fs_test_inode_bitmap2(fs->inode_map, i)) {
 			if (fix_problem(ctx, PR_5_INODE_BMAP_PADDING, &pctx)) {
 				for (i = save_inodes_count + 1; i <= end; i++)
-					ext2fs_mark_inode_bitmap(fs->inode_map,
+					ext2fs_mark_inode_bitmap2(fs->inode_map,
 								 i);
 				ext2fs_mark_ib_dirty(fs);
 			} else
@@ -599,14 +599,14 @@ static void check_inode_end(e2fsck_t ctx)
 static void check_block_end(e2fsck_t ctx)
 {
 	ext2_filsys fs = ctx->fs;
-	blk_t	end, save_blocks_count, i;
+	blk64_t	end, save_blocks_count, i;
 	struct problem_context	pctx;
 
 	clear_problem_context(&pctx);
 
-	end = ext2fs_get_block_bitmap_start(fs->block_map) +
+	end = ext2fs_get_block_bitmap_start2(fs->block_map) +
 		(EXT2_BLOCKS_PER_GROUP(fs->super) * fs->group_desc_count) - 1;
-	pctx.errcode = ext2fs_fudge_block_bitmap_end(fs->block_map, end,
+	pctx.errcode = ext2fs_fudge_block_bitmap_end2(fs->block_map, end,
 						     &save_blocks_count);
 	if (pctx.errcode) {
 		pctx.num = 3;
@@ -619,10 +619,10 @@ static void check_block_end(e2fsck_t ctx)
 
 	/* Protect loop from wrap-around if end is maxed */
 	for (i = save_blocks_count + 1; i <= end && i > save_blocks_count; i++) {
-		if (!ext2fs_test_block_bitmap(fs->block_map, i)) {
+		if (!ext2fs_test_block_bitmap2(fs->block_map, i)) {
 			if (fix_problem(ctx, PR_5_BLOCK_BMAP_PADDING, &pctx)) {
 				for (i = save_blocks_count + 1; i <= end; i++)
-					ext2fs_mark_block_bitmap(fs->block_map,
+					ext2fs_mark_block_bitmap2(fs->block_map,
 								 i);
 				ext2fs_mark_bb_dirty(fs);
 			} else
@@ -631,7 +631,7 @@ static void check_block_end(e2fsck_t ctx)
 		}
 	}
 
-	pctx.errcode = ext2fs_fudge_block_bitmap_end(fs->block_map,
+	pctx.errcode = ext2fs_fudge_block_bitmap_end2(fs->block_map,
 						     save_blocks_count, 0);
 	if (pctx.errcode) {
 		pctx.num = 4;
diff --git a/e2fsck/rehash.c b/e2fsck/rehash.c
index 6c24bdd..857f4f4 100644
--- a/e2fsck/rehash.c
+++ b/e2fsck/rehash.c
@@ -624,7 +624,7 @@ static int write_dir_block(ext2_filsys fs,
 	if (blockcnt >= wd->outdir->num) {
 		e2fsck_read_bitmaps(wd->ctx);
 		blk = *block_nr;
-		ext2fs_unmark_block_bitmap(wd->ctx->block_found_map, blk);
+		ext2fs_unmark_block_bitmap2(wd->ctx->block_found_map, blk);
 		ext2fs_block_alloc_stats(fs, blk, -1);
 		*block_nr = 0;
 		wd->cleared++;
diff --git a/e2fsck/super.c b/e2fsck/super.c
index 1bacbc7..0b55809 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -84,7 +84,7 @@ static int release_inode_block(ext2_filsys fs,
 		return BLOCK_ABORT;
 	}
 
-	if (!ext2fs_test_block_bitmap(fs->block_map, blk)) {
+	if (!ext2fs_test_block_bitmap2(fs->block_map, blk)) {
 		fix_problem(ctx, PR_0_ORPHAN_ALREADY_CLEARED_BLOCK, pctx);
 		goto return_abort;
 	}
-- 
1.5.6.5

