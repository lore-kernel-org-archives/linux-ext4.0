From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH 10/14] Make e2fsck uninit block group aware.
Date: Sun, 21 Oct 2007 21:04:03 -0500
Message-ID: <20071022020403.23849.79537.stgit@toolssf2>
References: <20071022020308.23849.98773.stgit@toolssf2>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:58807 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbXJVCH3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 21 Oct 2007 22:07:29 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l9M27SAg009485
	for <linux-ext4@vger.kernel.org>; Sun, 21 Oct 2007 22:07:28 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9M27Sme082666
	for <linux-ext4@vger.kernel.org>; Sun, 21 Oct 2007 20:07:28 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9M27SEB008935
	for <linux-ext4@vger.kernel.org>; Sun, 21 Oct 2007 20:07:28 -0600
Received: from [127.0.0.1] (toolssf2.ltc.austin.ibm.com [9.3.190.66])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l9M27RjV008927
	for <linux-ext4@vger.kernel.org>; Sun, 21 Oct 2007 20:07:28 -0600
In-Reply-To: <20071022020308.23849.98773.stgit@toolssf2>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Make e2fsck uninit block group aware.

This patch has all the necesary pieces to open and fix filesystems created
with the uninit block group feature.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
Signed-Off-By: Andreas Dilger <adilger@clusterfs.com>
--

 e2fsck/e2fsck.h  |    2 +
 e2fsck/journal.c |    2 +
 e2fsck/pass2.c   |   77 ++++++++++++++++++++++++++++++++++++++++++++++++------
 e2fsck/pass5.c   |   61 +++++++++++++++++++++++++++++++------------
 e2fsck/problem.c |   42 +++++++++++++++++++++++++++++
 e2fsck/problem.h |   26 ++++++++++++++++++
 e2fsck/super.c   |   40 ++++++++++++++++++++++++++++
 e2fsck/unix.c    |   11 ++++++--
 e2fsck/util.c    |   61 +++++++++++++++++++++++++++++++++++++++++++
 9 files changed, 292 insertions(+), 30 deletions(-)

diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index 9ccffd8..a67322d 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -468,6 +468,8 @@ extern void e2fsck_read_bitmaps(e2fsck_t ctx);
 extern void e2fsck_write_bitmaps(e2fsck_t ctx);
 extern void preenhalt(e2fsck_t ctx);
 extern char *string_copy(e2fsck_t ctx, const char *str, int len);
+extern errcode_t e2fsck_zero_blocks(ext2_filsys fs, blk_t blk, int num,
+				    blk_t *ret_blk, int *ret_count);
 #ifdef RESOURCE_TRACK
 extern void print_resource_track(const char *desc,
 				 struct resource_track *track,
diff --git a/e2fsck/journal.c b/e2fsck/journal.c
index f5f4647..ceade93 100644
--- a/e2fsck/journal.c
+++ b/e2fsck/journal.c
@@ -988,6 +988,8 @@ void e2fsck_move_ext3_journal(e2fsck_t ctx)
 	ext2fs_unmark_inode_bitmap(fs->inode_map, ino);
 	ext2fs_mark_ib_dirty(fs);
 	fs->group_desc[group].bg_free_inodes_count++;
+	fs->group_desc[group].bg_checksum =
+		ext2fs_group_desc_csum(fs->super, group,&fs->group_desc[group]);
 	fs->super->s_free_inodes_count++;
 	return;
 
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 27f7136..047b5ca 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -151,7 +151,7 @@ void e2fsck_pass2(e2fsck_t ctx)
 	
 	cd.pctx.errcode = ext2fs_dblist_iterate(fs->dblist, check_dir_block,
 						&cd);
-	if (ctx->flags & E2F_FLAG_SIGNAL_MASK)
+	if (ctx->flags & E2F_FLAG_SIGNAL_MASK || ctx->flags & E2F_FLAG_RESTART)
 		return;
 	if (cd.pctx.errcode) {
 		fix_problem(ctx, PR_2_DBLIST_ITERATE, &cd.pctx);
@@ -736,7 +736,7 @@ static int check_dir_block(ext2_filsys fs,
 	buf = cd->buf;
 	ctx = cd->ctx;
 
-	if (ctx->flags & E2F_FLAG_SIGNAL_MASK)
+	if (ctx->flags & E2F_FLAG_SIGNAL_MASK || ctx->flags & E2F_FLAG_RESTART)
 		return DIRENT_ABORT;
 	
 	if (ctx->progress && (ctx->progress)(ctx, 2, cd->count++, cd->max))
@@ -833,6 +833,9 @@ static int check_dir_block(ext2_filsys fs,
 	dict_init(&de_dict, DICTCOUNT_T_MAX, dict_de_cmp);
 	prev = 0;
 	do {
+		int group;
+		ext2_ino_t first_unused_inode;
+
 		problem = 0;
 		dirent = (struct ext2_dir_entry *) (buf + offset);
 		cd->pctx.dirent = dirent;
@@ -882,12 +885,6 @@ static int check_dir_block(ext2_filsys fs,
 		     (dirent->inode < EXT2_FIRST_INODE(fs->super))) ||
 		    (dirent->inode > fs->super->s_inodes_count)) {
 			problem = PR_2_BAD_INO;
-		} else if (!(ext2fs_test_inode_bitmap(ctx->inode_used_map,
-					       dirent->inode))) {
-			/*
-			 * If the inode is unused, offer to clear it.
-			 */
-			problem = PR_2_UNUSED_INODE;
 		} else if (ctx->inode_bb_map &&
 			   (ext2fs_test_inode_bitmap(ctx->inode_bb_map,
 						     dirent->inode))) {
@@ -964,6 +961,67 @@ static int check_dir_block(ext2_filsys fs,
 				return DIRENT_ABORT;
 		}
 
+		group = ext2fs_group_of_ino(fs, dirent->inode);
+		first_unused_inode = group * fs->super->s_inodes_per_group +
+					1 + fs->super->s_inodes_per_group -
+					fs->group_desc[group].bg_itable_unused;
+		cd->pctx.group = group;
+
+		/*
+		 * Check if the inode was missed out because _INODE_UNINIT
+		 * flag was set or bg_itable_unused was incorrect.
+		 * If that is the case restart e2fsck.
+		 * XXX Optimisations TODO:
+		 * 1. only restart e2fsck once
+		 * 2. only exposed inodes are checked again.
+		 */
+		if (fs->group_desc[group].bg_flags & EXT2_BG_INODE_UNINIT) {
+			if (fix_problem(ctx, PR_2_INOREF_BG_INO_UNINIT,
+					&cd->pctx)){
+				fs->group_desc[group].bg_flags &=
+					~EXT2_BG_INODE_UNINIT;
+				ctx->flags |= E2F_FLAG_RESTART |
+					E2F_FLAG_SIGNAL_MASK;
+			} else {
+				ext2fs_unmark_valid(fs);
+				if (problem == PR_2_BAD_INO)
+					goto next;
+			}
+		} else if (dirent->inode >= first_unused_inode) {
+			if (fix_problem(ctx, PR_2_INOREF_IN_UNUSED, &cd->pctx)){
+				fs->group_desc[group].bg_itable_unused = 0;
+				fs->group_desc[group].bg_flags &=
+					~EXT2_BG_INODE_UNINIT;
+				ext2fs_mark_super_dirty(fs);
+				ctx->flags |= E2F_FLAG_RESTART;
+				goto restart_fsck;
+			} else {
+				ext2fs_unmark_valid(fs);
+				if (problem == PR_2_BAD_INO)
+					goto next;
+			}
+		}
+
+		if (!(ext2fs_test_inode_bitmap(ctx->inode_used_map,
+					       dirent->inode))) {
+			/*
+			 * If the inode is unused, offer to clear it.
+			 */
+			problem = PR_2_UNUSED_INODE;
+		}
+
+		if (problem) {
+			if (fix_problem(ctx, problem, &cd->pctx)) {
+				dirent->inode = 0;
+				dir_modified++;
+				goto next;
+			} else {
+				ext2fs_unmark_valid(fs);
+				if (problem == PR_2_BAD_INO)
+					goto next;
+			}
+		}
+
 		if (check_name(ctx, dirent, ino, &cd->pctx))
 			dir_modified++;
 
@@ -1073,8 +1131,9 @@ static int check_dir_block(ext2_filsys fs,
 	dict_free_nodes(&de_dict);
 	return 0;
 abort_free_dict:
-	dict_free_nodes(&de_dict);
 	ctx->flags |= E2F_FLAG_ABORT;
+restart_fsck:
+	dict_free_nodes(&de_dict);
 	return DIRENT_ABORT;
 }
 
diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index 53248b0..1f1536b 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -121,7 +121,7 @@ static void check_block_bitmaps(e2fsck_t ctx)
 	struct problem_context	pctx;
 	int	problem, save_problem, fixit, had_problem;
 	errcode_t	retval;
-	int		lazy_bg = 0;
+	int		lazy_flag, csum_flag;
 	int		skip_group = 0;
 
 	clear_problem_context(&pctx);
@@ -158,15 +158,16 @@ static void check_block_bitmaps(e2fsck_t ctx)
 		goto errout;
 	}
 
-	if (EXT2_HAS_COMPAT_FEATURE(fs->super, EXT2_FEATURE_COMPAT_LAZY_BG))
-		lazy_bg++;
-
+	lazy_flag = EXT2_HAS_COMPAT_FEATURE(fs->super,
+					    EXT2_FEATURE_COMPAT_LAZY_BG);
+	csum_flag = EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					       EXT4_FEATURE_RO_COMPAT_GDT_CSUM);
 redo_counts:
 	had_problem = 0;
 	save_problem = 0;
 	pctx.blk = pctx.blk2 = NO_BLK;
-	if (lazy_bg && (fs->group_desc[group].bg_flags &
-			EXT2_BG_BLOCK_UNINIT))
+	if ((lazy_flag || csum_flag) &&
+	    (fs->group_desc[group].bg_flags & EXT2_BG_BLOCK_UNINIT))
 		skip_group++;
 	super = fs->super->s_first_data_block;
 	for (i = fs->super->s_first_data_block;
@@ -206,6 +207,17 @@ redo_counts:
 			 * Block used, but not marked in use in the bitmap.
 			 */
 			problem = PR_5_BLOCK_USED;
+
+			if (skip_group) {
+				struct problem_context pctx2;
+				pctx2.blk = i;
+				pctx2.group = group;
+				if (fix_problem(ctx, PR_5_BLOCK_UNINIT,&pctx2)){
+					fs->group_desc[group].bg_flags &=
+						~EXT2_BG_BLOCK_UNINIT;
+					skip_group = 0;
+				}
+			}
 		}
 		if (pctx.blk == NO_BLK) {
 			pctx.blk = pctx.blk2 = i;
@@ -224,7 +236,7 @@ redo_counts:
 		had_problem++;
 
 	do_counts:
-		if (!bitmap && !skip_group) {
+		if (!bitmap && (!skip_group || csum_flag)) {
 			group_free++;
 			free_blocks++;
 		}
@@ -241,7 +253,7 @@ redo_counts:
 				if ((ctx->progress)(ctx, 5, group,
 						    fs->group_desc_count*2))
 					goto errout;
-			if (lazy_bg &&
+			if ((lazy_flag || csum_flag) &&
 			    (i != fs->super->s_blocks_count-1) &&
 			    (fs->group_desc[group].bg_flags &
 			     EXT2_BG_BLOCK_UNINIT))
@@ -321,7 +333,7 @@ static void check_inode_bitmaps(e2fsck_t ctx)
 	errcode_t	retval;
 	struct problem_context	pctx;
 	int		problem, save_problem, fixit, had_problem;
-	int		lazy_bg = 0;
+	int		lazy_flag, csum_flag;
 	int		skip_group = 0;
 
 	clear_problem_context(&pctx);
@@ -358,16 +370,16 @@ static void check_inode_bitmaps(e2fsck_t ctx)
 		goto errout;
 	}
 
-	if (EXT2_HAS_COMPAT_FEATURE(fs->super,
-				    EXT2_FEATURE_COMPAT_LAZY_BG))
-		lazy_bg++;
-
+	lazy_flag = EXT2_HAS_COMPAT_FEATURE(fs->super,
+					    EXT2_FEATURE_COMPAT_LAZY_BG);
+	csum_flag = EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					       EXT4_FEATURE_RO_COMPAT_GDT_CSUM);
 redo_counts:
 	had_problem = 0;
 	save_problem = 0;
 	pctx.ino = pctx.ino2 = 0;
-	if (lazy_bg && (fs->group_desc[group].bg_flags &
-			EXT2_BG_INODE_UNINIT))
+	if ((lazy_flag || csum_flag) &&
+	    (fs->group_desc[group].bg_flags & EXT2_BG_INODE_UNINIT))
 		skip_group++;
 
 	/* Protect loop from wrap-around if inodes_count is maxed */
@@ -390,6 +402,21 @@ redo_counts:
 			 * Inode used, but not in bitmap
 			 */
 			problem = PR_5_INODE_USED;
+
+			/* We should never hit this, because it means that
+			 * inodes were marked in use that weren't noticed
+			 * in pass1 or pass 2. It is easier to fix the problem
+			 * than to kill e2fsck and leave the user stuck. */
+			if (skip_group) {
+				struct problem_context pctx2;
+				pctx2.blk = i;
+				pctx2.group = group;
+				if (fix_problem(ctx, PR_5_INODE_UNINIT,&pctx2)){
+					fs->group_desc[group].bg_flags &=
+						~EXT2_BG_INODE_UNINIT;
+					skip_group = 0;
+				}
+			}
 		}
 		if (pctx.ino == 0) {
 			pctx.ino = pctx.ino2 = i;
@@ -411,7 +438,7 @@ do_counts:
 		if (bitmap) {
 			if (ext2fs_test_inode_bitmap(ctx->inode_dir_map, i))
 				dirs_count++;
-		} else if (!skip_group) {
+		} else if (!skip_group || csum_flag) {
 			group_free++;
 			free_inodes++;
 		}
@@ -430,7 +457,7 @@ do_counts:
 					    group + fs->group_desc_count,
 					    fs->group_desc_count*2))
 					goto errout;
-			if (lazy_bg &&
+			if ((lazy_flag || csum_flag) &&
 			    (i != fs->super->s_inodes_count) &&
 			    (fs->group_desc[group].bg_flags &
 			     EXT2_BG_INODE_UNINIT))
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 7c3ebea..6fc811c 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -351,8 +351,28 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("Adding dirhash hint to @f.\n\n"),
 	  PROMPT_NONE, 0 },
 
+	/* group descriptor N checksum is invalid. */
+	{ PR_0_GDT_CSUM,
+	  N_("@g descriptor %g checksum is invalid.  "),
+	     PROMPT_FIX, PR_PREEN_OK },
+
+	/* group descriptor N marked uninitialized without feature set. */
+	{ PR_0_GDT_UNINIT,
+	  N_("@g descriptor %g marked uninitialized without feature set.\n"),
+	     PROMPT_FIX, PR_PREEN_OK },
+
+	/* group N block bitmap uninitialized but inode bitmap in use. */
+	{ PR_0_BB_UNINIT_IB_INIT,
+	  N_("@g %g @b @B uninitialized but @i @B in use.\n"),
+	     PROMPT_FIX, PR_PREEN_OK },
+
+	/* Group descriptor N has invalid unused inodes count. */
+	{ PR_0_GDT_ITABLE_UNUSED,
+	  N_("@g descriptor %g has invalid unused inodes count %b.  "),
+	     PROMPT_FIX, PR_PREEN_OK },
+
 	/* Pass 1 errors */
-	
+
 	/* Pass 1: Checking inodes, blocks, and sizes */
 	{ PR_1_PASS_HEADER,
 	  N_("Pass 1: Checking @is, @bs, and sizes\n"),
@@ -1188,6 +1208,16 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("i_blocks_hi @F %N, @s zero.\n"),
 	  PROMPT_CLEAR, 0 },
 
+	/* Inode found in group where _INODE_UNINIT is set */
+	{ PR_2_INOREF_BG_INO_UNINIT,
+	  N_("@i %i found in @g %g where _INODE_UNINIT is set.  "),
+	  PROMPT_FIX, PR_PREEN_OK },
+
+	/* Inode found in group unused inodes area */
+	{ PR_2_INOREF_IN_UNUSED,
+	  N_("@i %i found in @g %g unused inodes area.  "),
+	  PROMPT_FIX, PR_PREEN_OK },
+
 	/* Pass 3 errors */
 
 	/* Pass 3: Checking directory connectivity */
@@ -1499,6 +1529,16 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("Recreate journal to make the filesystem ext3 again?\n"),
 	  PROMPT_FIX, PR_PREEN_OK | PR_NO_OK },
 
+	/* Group N block(s) in use but group is marked BLOCK_UNINIT */
+	{ PR_5_BLOCK_UNINIT,
+	  N_("@g %g @b(s) in use but @g is marked BLOCK_UNINIT\n"),
+	  PROMPT_FIX, PR_PREEN_OK },
+
+	/* Group N inode(s) in use but group is marked INODE_UNINIT */
+	{ PR_5_INODE_UNINIT,
+	  N_("@g %g @i(s) in use but @g is marked INODE_UNINIT\n"),
+	  PROMPT_FIX, PR_PREEN_OK },
+
 	{ 0 }
 };
 
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index f5f7212..8ec9ee5 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -196,6 +196,18 @@ struct problem_context {
 /* Superblock hint for external journal incorrect */
 #define PR_0_DIRHASH_HINT			0x000034
 
+/* Group descriptor N checksum is invalid */
+#define PR_0_GDT_CSUM				0x000035
+
+/* Group descriptor N marked uninitialized without feature set. */
+#define PR_0_GDT_UNINIT				0x000036
+
+/* Block bitmap is not initialised and Inode bitmap is */
+#define PR_0_BB_UNINIT_IB_INIT			0x000037
+
+/* Group descriptor N has invalid unused inodes count. */
+#define PR_0_GDT_ITABLE_UNUSED			0x000038
+
 /*
  * Pass 1 errors
  */
@@ -708,6 +720,12 @@ struct problem_context {
 /* i_blocks_hi should be zero */
 #define PR_2_BLOCKS_HI_ZERO	0x020044
 
+/* Inode found in group where _INODE_UNINIT is set */
+#define PR_2_INOREF_BG_INO_UNINIT	0x020045
+
+/* Inode found in group unused inodes area */
+#define PR_2_INOREF_IN_UNUSED		0x020046
+
 /*
  * Pass 3 errors
  */
@@ -896,10 +914,16 @@ struct problem_context {
 
 /* Inode range not used, but marked in bitmap */
 #define PR_5_INODE_RANGE_UNUSED		0x050016
-	  
+
 /* Inode rangeused, but not marked used in bitmap */
 #define PR_5_INODE_RANGE_USED		0x050017
 
+/* Block in use but group is marked BLOCK_UNINIT */
+#define PR_5_BLOCK_UNINIT		0x050018
+
+/* Inode in use but group is marked INODE_UNINIT */
+#define PR_5_INODE_UNINIT		0x050019
+
 /*
  * Post-Pass 5 errors
  */
diff --git a/e2fsck/super.c b/e2fsck/super.c
index a4835f7..6b39a65 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -468,6 +468,7 @@ void check_super_block(e2fsck_t ctx)
 	blk_t	should_be;
 	struct problem_context	pctx;
 	__u32	free_blocks = 0, free_inodes = 0;
+	int     lazy_flag, csum_flag;
 
 	inodes_per_block = EXT2_INODES_PER_BLOCK(fs->super);
 	ipg_max = inodes_per_block * (blocks_per_group - 4);
@@ -576,6 +577,10 @@ void check_super_block(e2fsck_t ctx)
 	 */
 	first_block =  sb->s_first_data_block;
 
+	lazy_flag = EXT2_HAS_COMPAT_FEATURE(fs->super,
+					    EXT2_FEATURE_COMPAT_LAZY_BG);
+	csum_flag = EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					       EXT4_FEATURE_RO_COMPAT_GDT_CSUM);
 	for (i = 0, gd=fs->group_desc; i < fs->group_desc_count; i++, gd++) {
 		pctx.group = i;
 
@@ -621,6 +626,41 @@ void check_super_block(e2fsck_t ctx)
 		    (gd->bg_used_dirs_count > sb->s_inodes_per_group))
 			ext2fs_unmark_valid(fs);
 
+		if (!ext2fs_group_desc_csum_verify(sb, i, gd)) {
+			if (fix_problem(ctx, PR_0_GDT_CSUM, &pctx)) {
+				gd->bg_flags &=	~(EXT2_BG_BLOCK_UNINIT |
+				                  EXT2_BG_INODE_UNINIT);
+				gd->bg_itable_unused = 0;
+			}
+			ext2fs_unmark_valid(fs);
+		}
+
+		if (!lazy_flag && !csum_flag &&
+		    (gd->bg_flags &(EXT2_BG_BLOCK_UNINIT|EXT2_BG_INODE_UNINIT)||
+		     gd->bg_itable_unused != 0)){
+			if (fix_problem(ctx, PR_0_GDT_UNINIT, &pctx)) {
+				gd->bg_flags &= ~(EXT2_BG_BLOCK_UNINIT |
+						  EXT2_BG_INODE_UNINIT);
+				gd->bg_itable_unused = 0;
+			}
+			ext2fs_unmark_valid(fs);
+		}
+		if (gd->bg_flags & EXT2_BG_BLOCK_UNINIT &&
+		    !(gd->bg_flags & EXT2_BG_INODE_UNINIT)) {
+			if (fix_problem(ctx, PR_0_BB_UNINIT_IB_INIT, &pctx))
+				gd->bg_flags &= ~EXT2_BG_BLOCK_UNINIT;
+			ext2fs_unmark_valid(fs);
+		}
+		if (csum_flag &&
+		    (gd->bg_itable_unused > gd->bg_free_inodes_count ||
+		     gd->bg_itable_unused > sb->s_inodes_per_group)) {
+			pctx.blk = gd->bg_itable_unused;
+			if (fix_problem(ctx, PR_0_GDT_ITABLE_UNUSED, &pctx))
+				gd->bg_itable_unused = 0;
+			ext2fs_unmark_valid(fs);
+		}
+
+		gd->bg_checksum = ext2fs_group_desc_csum(fs->super, i, gd);
 	}
 
 	/*
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 291ff85..596c650 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -558,7 +558,9 @@ static void parse_extended_opts(e2fsck_t ctx, const char *opts)
 		       "and may take an argument which\n"
 		       "is set off by an equals ('=') sign.  "
 			"Valid extended options are:\n"
-		       "\tea_ver=<ea_version (1 or 2)>\n\n"), stderr);
+			"\tea_ver=<ea_version (1 or 2)>\n"
+			"\tuninit_groups\n"
+			"\tinit_groups\n\n"), stderr);
 		exit(1);
 	}
 }
@@ -745,6 +747,7 @@ static errcode_t PRS(int argc, char *argv[], e2fsck_t *ret_ctx)
 	if ((ctx->options & E2F_OPT_NO) && !bad_blocks_file &&
 	    !cflag && !(ctx->options & E2F_OPT_COMPRESS_DIRS))
 		ctx->options |= E2F_OPT_READONLY;
+
 	ctx->io_options = strchr(argv[optind], '?');
 	if (ctx->io_options) 
 		*ctx->io_options++ = 0;
@@ -842,7 +845,7 @@ sscanf_err:
 
 static const char *my_ver_string = E2FSPROGS_VERSION;
 static const char *my_ver_date = E2FSPROGS_DATE;
-					
+
 int main (int argc, char *argv[])
 {
 	errcode_t	retval = 0, orig_retval = 0;
@@ -1306,6 +1309,10 @@ no_journal:
 		}
 	}
 
+	if (sb->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_GDT_CSUM &&
+	    !(ctx->options & E2F_OPT_READONLY))
+		ext2fs_set_gdt_csum(ctx->fs);
+
 	e2fsck_write_bitmaps(ctx);
 #ifdef RESOURCE_TRACK
 	io_channel_flush(ctx->fs->io);
diff --git a/e2fsck/util.c b/e2fsck/util.c
index ba7ef4a..751ad78 100644
--- a/e2fsck/util.c
+++ b/e2fsck/util.c
@@ -29,6 +29,10 @@
 #include <malloc.h>
 #endif
 
+#ifdef HAVE_ERRNO_H
+#include <errno.h>
+#endif
+
 #include "e2fsck.h"
 
 extern e2fsck_t e2fsck_global_ctx;   /* Try your very best not to use this! */
@@ -532,3 +536,60 @@ int ext2_file_type(unsigned int mode)
 	
 	return 0;
 }
+
+#define STRIDE_LENGTH 8
+/*
+ * Helper function which zeros out _num_ blocks starting at _blk_.  In
+ * case of an error, the details of the error is returned via _ret_blk_
+ * and _ret_count_ if they are non-NULL pointers.  Returns 0 on
+ * success, and an error code on an error.
+ *
+ * As a special case, if the first argument is NULL, then it will
+ * attempt to free the static zeroizing buffer.  (This is to keep
+ * programs that check for memory leaks happy.)
+ */
+errcode_t e2fsck_zero_blocks(ext2_filsys fs, blk_t blk, int num,
+			     blk_t *ret_blk, int *ret_count)
+{
+	int		j, count, next_update, next_update_incr;
+	static char	*buf;
+	errcode_t	retval;
+
+	/* If fs is null, clean up the static buffer and return */
+	if (!fs) {
+		if (buf) {
+			free(buf);
+			buf = 0;
+		}
+		return 0;
+	}
+	/* Allocate the zeroizing buffer if necessary */
+	if (!buf) {
+		buf = malloc(fs->blocksize * STRIDE_LENGTH);
+		if (!buf) {
+			com_err("malloc", ENOMEM,
+				_("while allocating zeroizing buffer"));
+			exit(1);
+		}
+		memset(buf, 0, fs->blocksize * STRIDE_LENGTH);
+	}
+	/* OK, do the write loop */
+	next_update = 0;
+	next_update_incr = num / 100;
+	if (next_update_incr < 1)
+		next_update_incr = 1;
+	for (j = 0; j < num; j += STRIDE_LENGTH, blk += STRIDE_LENGTH) {
+		count = num - j;
+		if (count > STRIDE_LENGTH)
+			count = STRIDE_LENGTH;
+		retval = io_channel_write_blk(fs->io, blk, count, buf);
+		if (retval) {
+			if (ret_count)
+				*ret_count = count;
+			if (ret_blk)
+				*ret_blk = blk;
+			return retval;
+		}
+	}
+	return 0;
+}
