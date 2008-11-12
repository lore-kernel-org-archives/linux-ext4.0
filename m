From: Valerie Aurora Henson <vaurora@redhat.com>
Subject: [RFC PATCH 14/17] super->s_*_blocks_count -> ext2fs_*_blocks_count()
Date: Tue, 11 Nov 2008 19:43:07 -0800
Message-ID: <1226461390-5502-15-git-send-email-vaurora@redhat.com>
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
Cc: Valerie Aurora Henson <vaurora@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:42475 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069AbYKLDoF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Nov 2008 22:44:05 -0500
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id mAC3i5HP007471
	for <linux-ext4@vger.kernel.org>; Tue, 11 Nov 2008 22:44:05 -0500
In-Reply-To: <1226461390-5502-14-git-send-email-vaurora@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Valerie Aurora Henson <vaurora@redhat.com>
---
 e2fsck/journal.c           |    4 ++--
 e2fsck/pass1.c             |   22 +++++++++++-----------
 e2fsck/pass2.c             |    4 ++--
 e2fsck/pass5.c             |   20 ++++++++++----------
 e2fsck/super.c             |   24 ++++++++++++------------
 e2fsck/unix.c              |   13 +++++++------
 lib/ext2fs/alloc.c         |    6 +++---
 lib/ext2fs/alloc_sb.c      |    4 ++--
 lib/ext2fs/block.c         |    6 +++---
 lib/ext2fs/bmove.c         |    2 +-
 lib/ext2fs/check_desc.c    |    4 ++--
 lib/ext2fs/closefs.c       |    6 +++---
 lib/ext2fs/ext_attr.c      |    2 +-
 lib/ext2fs/icount.c        |    2 +-
 lib/ext2fs/mkjournal.c     |    2 +-
 lib/ext2fs/openfs.c        |    8 ++++----
 lib/ext2fs/rw_bitmaps.c    |    6 +++---
 lib/ext2fs/tst_badblocks.c |    2 +-
 lib/ext2fs/tst_csum.c      |    2 +-
 misc/mke2fs.c              |   10 +++++-----
 20 files changed, 75 insertions(+), 74 deletions(-)

diff --git a/e2fsck/journal.c b/e2fsck/journal.c
index 4dc8278..660b6ca 100644
--- a/e2fsck/journal.c
+++ b/e2fsck/journal.c
@@ -213,7 +213,7 @@ static int process_journal_block(ext2_filsys fs,
 	p = (struct process_block_struct *) priv_data;
 
 	if (blk < fs->super->s_first_data_block ||
-	    blk >= fs->super->s_blocks_count)
+	    blk >= ext2fs_blocks_count(fs->super))
 		return BLOCK_ABORT;
 
 	if (blockcnt >= 0)
@@ -407,7 +407,7 @@ static errcode_t e2fsck_get_journal(e2fsck_t ctx, journal_t **ret_journal)
 			goto errout;
 		}
 
-		journal->j_maxlen = jsuper.s_blocks_count;
+		journal->j_maxlen = ext2fs_blocks_count(&jsuper);
 		start++;
 	}
 
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index ee658d5..ef8b421 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -191,7 +191,7 @@ int e2fsck_pass1_check_symlink(ext2_filsys fs, ext2_ino_t ino,
 		    (extent.e_lblk != 0) ||
 		    (extent.e_len != 1) ||
 		    (extent.e_pblk < fs->super->s_first_data_block) ||
-		    (extent.e_pblk >= fs->super->s_blocks_count))
+		    (extent.e_pblk >= ext2fs_blocks_count(fs->super)))
 			goto exit_extent;
 		i = 1;
 	exit_extent:
@@ -204,7 +204,7 @@ int e2fsck_pass1_check_symlink(ext2_filsys fs, ext2_ino_t ino,
 		if ((inode->i_size >= fs->blocksize) ||
 		    (blocks != fs->blocksize >> 9) ||
 		    (inode->i_block[0] < fs->super->s_first_data_block) ||
-		    (inode->i_block[0] >= fs->super->s_blocks_count))
+		    (inode->i_block[0] >= ext2fs_blocks_count(fs->super)))
 			return 0;
 
 		for (i = 1; i < EXT2_N_BLOCKS; i++)
@@ -418,7 +418,7 @@ static void check_is_really_dir(e2fsck_t ctx, struct problem_context *pctx,
 			not_device++;
 
 		if (blk < ctx->fs->super->s_first_data_block ||
-		    blk >= ctx->fs->super->s_blocks_count ||
+		    blk >= ext2fs_blocks_count(ctx->fs->super) ||
 		    ext2fs_fast_test_block_bitmap2(ctx->block_found_map, blk))
 			return;	/* Invalid block, can't be dir */
 	}
@@ -1381,7 +1381,7 @@ static int check_ext_attr(e2fsck_t ctx, struct problem_context *pctx,
 	 */
 	if (!(fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_EXT_ATTR) ||
 	    (blk < fs->super->s_first_data_block) ||
-	    (blk >= fs->super->s_blocks_count)) {
+	    (blk >= ext2fs_blocks_count(fs->super))) {
 		mark_inode_bad(ctx, ino);
 		return 0;
 	}
@@ -1557,7 +1557,7 @@ static int handle_htree(e2fsck_t ctx, struct problem_context *pctx,
 	if ((pctx->errcode) ||
 	    (blk == 0) ||
 	    (blk < fs->super->s_first_data_block) ||
-	    (blk >= fs->super->s_blocks_count)) {
+	    (blk >= ext2fs_blocks_count(fs->super))) {
 		if (fix_problem(ctx, PR_1_HTREE_BADROOT, pctx))
 			return 1;
 		else
@@ -1644,13 +1644,13 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 
 		problem = 0;
 		if (extent.e_pblk < ctx->fs->super->s_first_data_block ||
-		    extent.e_pblk >= ctx->fs->super->s_blocks_count)
+		    extent.e_pblk >= ext2fs_blocks_count(ctx->fs->super))
 			problem = PR_1_EXTENT_BAD_START_BLK;
 		else if (extent.e_lblk < start_block)
 			problem = PR_1_OUT_OF_ORDER_EXTENTS;
 		else if (is_leaf &&
 			 (extent.e_pblk + extent.e_len) >
-			 ctx->fs->super->s_blocks_count)
+			 ext2fs_blocks_count(ctx->fs->super))
 			problem = PR_1_EXTENT_ENDS_BEYOND;
 
 		if (problem) {
@@ -1988,8 +1988,8 @@ static char *describe_illegal_block(ext2_filsys fs, blk_t block)
 	if (block < super) {
 		sprintf(problem, "< FIRSTBLOCK (%u)", super);
 		return(problem);
-	} else if (block >= fs->super->s_blocks_count) {
-		sprintf(problem, "> BLOCKS (%u)", fs->super->s_blocks_count);
+	} else if (block >= ext2fs_blocks_count(fs->super)) {
+		sprintf(problem, "> BLOCKS (%u)", ext2fs_blocks_count(fs->super));
 		return(problem);
 	}
 	for (i = 0; i < fs->group_desc_count; i++) {
@@ -2124,7 +2124,7 @@ static int process_block(ext2_filsys fs,
 		problem = PR_1_TOOBIG_SYMLINK;
 
 	if (blk < fs->super->s_first_data_block ||
-	    blk >= fs->super->s_blocks_count)
+	    blk >= ext2fs_blocks_count(fs->super))
 		problem = PR_1_ILLEGAL_BLOCK_NUM;
 
 	if (problem) {
@@ -2212,7 +2212,7 @@ static int process_bad_block(ext2_filsys fs,
 	pctx->blkcount = blockcnt;
 
 	if ((blk < fs->super->s_first_data_block) ||
-	    (blk >= fs->super->s_blocks_count)) {
+	    (blk >= ext2fs_blocks_count(fs->super))) {
 		if (fix_problem(ctx, PR_1_BB_ILLEGAL_BLOCK_NUM, pctx)) {
 			*block_nr = 0;
 			return BLOCK_CHANGED;
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 2ee000e..da868a8 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -1168,7 +1168,7 @@ static int deallocate_inode_block(ext2_filsys fs,
 	if (HOLE_BLKADDR(*block_nr))
 		return 0;
 	if ((*block_nr < fs->super->s_first_data_block) ||
-	    (*block_nr >= fs->super->s_blocks_count))
+	    (*block_nr >= ext2fs_blocks_count(fs->super)))
 		return 0;
 	ext2fs_unmark_block_bitmap2(ctx->block_found_map, *block_nr);
 	ext2fs_block_alloc_stats(fs, *block_nr, -1);
@@ -1357,7 +1357,7 @@ extern int e2fsck_process_bad_inode(e2fsck_t ctx, ext2_ino_t dir,
 
 	if (ext2fs_file_acl_block(&inode) &&
 	    ((ext2fs_file_acl_block(&inode) < fs->super->s_first_data_block) ||
-	     (ext2fs_file_acl_block(&inode) >= fs->super->s_blocks_count))) {
+	     (ext2fs_file_acl_block(&inode) >= ext2fs_blocks_count(fs->super)))) {
 		if (fix_problem(ctx, PR_2_FILE_ACL_BAD, &pctx)) {
 			ext2fs_file_acl_block_set(&inode, 0);
 			inode_modified++;
diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index 811fb2a..23dd5a4 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -131,11 +131,11 @@ static void check_block_bitmaps(e2fsck_t ctx)
 
 	if ((fs->super->s_first_data_block <
 	     ext2fs_get_block_bitmap_start2(ctx->block_found_map)) ||
-	    (fs->super->s_blocks_count-1 >
+	    (ext2fs_blocks_count(fs->super)-1 >
 	     ext2fs_get_block_bitmap_end2(ctx->block_found_map))) {
 		pctx.num = 1;
 		pctx.blk = fs->super->s_first_data_block;
-		pctx.blk2 = fs->super->s_blocks_count -1;
+		pctx.blk2 = ext2fs_blocks_count(fs->super) -1;
 		pctx.ino = ext2fs_get_block_bitmap_start2(ctx->block_found_map);
 		pctx.ino2 = ext2fs_get_block_bitmap_end2(ctx->block_found_map);
 		fix_problem(ctx, PR_5_BMAP_ENDPOINTS, &pctx);
@@ -146,11 +146,11 @@ static void check_block_bitmaps(e2fsck_t ctx)
 
 	if ((fs->super->s_first_data_block <
 	     ext2fs_get_block_bitmap_start2(fs->block_map)) ||
-	    (fs->super->s_blocks_count-1 >
+	    (ext2fs_blocks_count(fs->super)-1 >
 	     ext2fs_get_block_bitmap_end2(fs->block_map))) {
 		pctx.num = 2;
 		pctx.blk = fs->super->s_first_data_block;
-		pctx.blk2 = fs->super->s_blocks_count -1;
+		pctx.blk2 = ext2fs_blocks_count(fs->super) -1;
 		pctx.ino = ext2fs_get_block_bitmap_start2(fs->block_map);
 		pctx.ino2 = ext2fs_get_block_bitmap_end2(fs->block_map);
 		fix_problem(ctx, PR_5_BMAP_ENDPOINTS, &pctx);
@@ -170,7 +170,7 @@ redo_counts:
 		skip_group++;
 	super = fs->super->s_first_data_block;
 	for (i = fs->super->s_first_data_block;
-	     i < fs->super->s_blocks_count;
+	     i < ext2fs_blocks_count(fs->super);
 	     i++) {
 		actual = ext2fs_fast_test_block_bitmap2(ctx->block_found_map, i);
 
@@ -258,7 +258,7 @@ redo_counts:
 		}
 		blocks ++;
 		if ((blocks == fs->super->s_blocks_per_group) ||
-		    (i == fs->super->s_blocks_count-1)) {
+		    (i == ext2fs_blocks_count(fs->super)-1)) {
 			free_array[group] = group_free;
 			group ++;
 			blocks = 0;
@@ -270,7 +270,7 @@ redo_counts:
 						    fs->group_desc_count*2))
 					goto errout;
 			if (csum_flag &&
-			    (i != fs->super->s_blocks_count-1) &&
+			    (i != ext2fs_blocks_count(fs->super)-1) &&
 			    (fs->group_desc[group].bg_flags &
 			     EXT2_BG_BLOCK_UNINIT))
 				skip_group++;
@@ -319,13 +319,13 @@ redo_counts:
 				ext2fs_unmark_valid(fs);
 		}
 	}
-	if (free_blocks != fs->super->s_free_blocks_count) {
+	if (free_blocks != ext2fs_free_blocks_count(fs->super)) {
 		pctx.group = 0;
-		pctx.blk = fs->super->s_free_blocks_count;
+		pctx.blk = ext2fs_free_blocks_count(fs->super);
 		pctx.blk2 = free_blocks;
 
 		if (fix_problem(ctx, PR_5_FREE_BLOCK_COUNT, &pctx)) {
-			fs->super->s_free_blocks_count = free_blocks;
+			ext2fs_free_blocks_count_set(fs->super, free_blocks);
 			ext2fs_mark_super_dirty(fs);
 		} else
 			ext2fs_unmark_valid(fs);
diff --git a/e2fsck/super.c b/e2fsck/super.c
index 40a5882..cfa9a13 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -77,7 +77,7 @@ static int release_inode_block(ext2_filsys fs,
 		return 0;
 
 	if ((blk < fs->super->s_first_data_block) ||
-	    (blk >= fs->super->s_blocks_count)) {
+	    (blk >= ext2fs_blocks_count(fs->super))) {
 		fix_problem(ctx, PR_0_ORPHAN_ILLEGAL_BLOCK_NUM, pctx);
 	return_abort:
 		pb->abort = 1;
@@ -376,7 +376,7 @@ static void check_resize_inode(e2fsck_t ctx)
 	if ((i < EXT2_N_BLOCKS) || !blk || !inode.i_links_count ||
 	    !(inode.i_mode & LINUX_S_IFREG) ||
 	    (blk < fs->super->s_first_data_block ||
-	     blk >= fs->super->s_blocks_count)) {
+	     blk >= ext2fs_blocks_count(fs->super))) {
 	resize_inode_invalid:
 		if (fix_problem(ctx, PR_0_RESIZE_INODE_INVALID, &pctx)) {
 			memset(&inode, 0, sizeof(inode));
@@ -494,10 +494,10 @@ void check_super_block(e2fsck_t ctx)
 	 */
 	check_super_value(ctx, "inodes_count", sb->s_inodes_count,
 			  MIN_CHECK, 1, 0);
-	check_super_value(ctx, "blocks_count", sb->s_blocks_count,
+	check_super_value(ctx, "blocks_count", ext2fs_blocks_count(sb),
 			  MIN_CHECK, 1, 0);
 	check_super_value(ctx, "first_data_block", sb->s_first_data_block,
-			  MAX_CHECK, 0, sb->s_blocks_count);
+			  MAX_CHECK, 0, ext2fs_blocks_count(sb));
 	check_super_value(ctx, "log_block_size", sb->s_log_block_size,
 			  MIN_CHECK | MAX_CHECK, 0,
 			  EXT2_MAX_BLOCK_LOG_SIZE - EXT2_MIN_BLOCK_LOG_SIZE);
@@ -510,8 +510,8 @@ void check_super_block(e2fsck_t ctx)
 			  MIN_CHECK | MAX_CHECK, 8, bpg_max);
 	check_super_value(ctx, "inodes_per_group", sb->s_inodes_per_group,
 			  MIN_CHECK | MAX_CHECK, inodes_per_block, ipg_max);
-	check_super_value(ctx, "r_blocks_count", sb->s_r_blocks_count,
-			  MAX_CHECK, 0, sb->s_blocks_count / 2);
+	check_super_value(ctx, "r_blocks_count", ext2fs_r_blocks_count(sb),
+			  MAX_CHECK, 0, ext2fs_blocks_count(sb) / 2);
 	check_super_value(ctx, "reserved_gdt_blocks",
 			  sb->s_reserved_gdt_blocks, MAX_CHECK, 0,
 			  fs->blocksize/4);
@@ -528,8 +528,8 @@ void check_super_block(e2fsck_t ctx)
 	}
 
 	if ((ctx->flags & E2F_FLAG_GOT_DEVSIZE) &&
-	    (ctx->num_blocks < sb->s_blocks_count)) {
-		pctx.blk = sb->s_blocks_count;
+	    (ctx->num_blocks < ext2fs_blocks_count(sb))) {
+		pctx.blk = ext2fs_blocks_count(sb);
 		pctx.blk2 = ctx->num_blocks;
 		if (fix_problem(ctx, PR_0_FS_SIZE_WRONG, &pctx)) {
 			ctx->flags |= E2F_FLAG_ABORT;
@@ -578,7 +578,7 @@ void check_super_block(e2fsck_t ctx)
 	 * Verify the group descriptors....
 	 */
 	first_block = sb->s_first_data_block;
-	last_block = sb->s_blocks_count-1;
+	last_block = ext2fs_blocks_count(sb)-1;
 
 	csum_flag = EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
 					       EXT4_FEATURE_RO_COMPAT_GDT_CSUM);
@@ -693,18 +693,18 @@ void check_super_block(e2fsck_t ctx)
 	 * inodes; if the filesystem is not unmounted cleanly, the
 	 * global counts may not be accurate.
 	 */
-	if ((free_blocks != sb->s_free_blocks_count) ||
+	if ((free_blocks != ext2fs_free_blocks_count(sb)) ||
 	    (free_inodes != sb->s_free_inodes_count)) {
 		if (ctx->options & E2F_OPT_READONLY)
 			ext2fs_unmark_valid(fs);
 		else {
-			sb->s_free_blocks_count = free_blocks;
+			ext2fs_free_blocks_count_set(sb, free_blocks);
 			sb->s_free_inodes_count = free_inodes;
 			ext2fs_mark_super_dirty(fs);
 		}
 	}
 
-	if ((sb->s_free_blocks_count > sb->s_blocks_count) ||
+	if ((ext2fs_free_blocks_count(sb) > ext2fs_blocks_count(sb)) ||
 	    (sb->s_free_inodes_count > sb->s_inodes_count))
 		ext2fs_unmark_valid(fs);
 
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index bb379f3..ae14460 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -113,9 +113,9 @@ static void show_stats(e2fsck_t	ctx)
 	inodes = fs->super->s_inodes_count;
 	inodes_used = (fs->super->s_inodes_count -
 		       fs->super->s_free_inodes_count);
-	blocks = fs->super->s_blocks_count;
-	blocks_used = (fs->super->s_blocks_count -
-		       fs->super->s_free_blocks_count);
+	blocks = ext2fs_blocks_count(fs->super);
+	blocks_used = (ext2fs_blocks_count(fs->super) -
+		       ext2fs_free_blocks_count(fs->super));
 
 	frag_percent = (10000 * ctx->fs_fragmented) / inodes_used;
 	frag_percent = (frag_percent + 5) / 10;
@@ -328,8 +328,9 @@ static void check_if_skip(e2fsck_t ctx)
 	printf(_("%s: clean, %u/%u files, %u/%u blocks"), ctx->device_name,
 	       fs->super->s_inodes_count - fs->super->s_free_inodes_count,
 	       fs->super->s_inodes_count,
-	       fs->super->s_blocks_count - fs->super->s_free_blocks_count,
-	       fs->super->s_blocks_count);
+	       ext2fs_blocks_count(fs->super) -
+	       ext2fs_free_blocks_count(fs->super),
+	       ext2fs_blocks_count(fs->super));
 	next_check = 100000;
 	if (fs->super->s_max_mnt_count > 0) {
 		next_check = fs->super->s_max_mnt_count - fs->super->s_mnt_count;
@@ -1278,7 +1279,7 @@ print_unsupp_features:
 	if (ctx->flags & E2F_FLAG_JOURNAL_INODE) {
 		if (fix_problem(ctx, PR_6_RECREATE_JOURNAL, &pctx)) {
 			if (journal_size < 1024)
-				journal_size = ext2fs_default_journal_size(fs->super->s_blocks_count);
+				journal_size = ext2fs_default_journal_size(ext2fs_blocks_count(fs->super));
 			if (journal_size < 0) {
 				fs->super->s_feature_compat &=
 					~EXT3_FEATURE_COMPAT_HAS_JOURNAL;
diff --git a/lib/ext2fs/alloc.c b/lib/ext2fs/alloc.c
index 90599b8..2ceab96 100644
--- a/lib/ext2fs/alloc.c
+++ b/lib/ext2fs/alloc.c
@@ -156,7 +156,7 @@ errcode_t ext2fs_new_block2(ext2_filsys fs, blk64_t goal,
 		map = fs->block_map;
 	if (!map)
 		return EXT2_ET_NO_BLOCK_BITMAP;
-	if (!goal || (goal >= fs->super->s_blocks_count))
+	if (!goal || (goal >= ext2fs_blocks_count(fs->super)))
 		goal = fs->super->s_first_data_block;
 	i = goal;
 	check_block_uninit(fs, map,
@@ -174,7 +174,7 @@ errcode_t ext2fs_new_block2(ext2_filsys fs, blk64_t goal,
 			return 0;
 		}
 		i++;
-		if (i >= fs->super->s_blocks_count)
+		if (i >= ext2fs_blocks_count(fs->super))
 			i = fs->super->s_first_data_block;
 	} while (i != goal);
 	return EXT2_ET_BLOCK_ALLOC_FAIL;
@@ -269,7 +269,7 @@ errcode_t ext2fs_get_free_blocks2(ext2_filsys fs, blk64_t start, blk64_t finish,
 	if (!num)
 		num = 1;
 	do {
-		if (b+num-1 > fs->super->s_blocks_count)
+		if (b+num-1 > ext2fs_blocks_count(fs->super))
 			b = fs->super->s_first_data_block;
 		if (ext2fs_fast_test_block_bitmap_range2(map, (blk_t) b,
 							(blk_t) num)) {
diff --git a/lib/ext2fs/alloc_sb.c b/lib/ext2fs/alloc_sb.c
index ddf4644..14c8a25 100644
--- a/lib/ext2fs/alloc_sb.c
+++ b/lib/ext2fs/alloc_sb.c
@@ -64,7 +64,7 @@ int ext2fs_reserve_super_and_bgd(ext2_filsys fs,
 		if (fs->super->s_reserved_gdt_blocks && fs->block_map == bmap)
 			fs->group_desc[group].bg_flags &= ~EXT2_BG_BLOCK_UNINIT;
 		for (j=0; j < old_desc_blocks; j++)
-			if (old_desc_blk + j < fs->super->s_blocks_count)
+			if (old_desc_blk + j < ext2fs_blocks_count(fs->super))
 				ext2fs_mark_block_bitmap2(bmap,
 							 old_desc_blk + j);
 	}
@@ -72,7 +72,7 @@ int ext2fs_reserve_super_and_bgd(ext2_filsys fs,
 		ext2fs_mark_block_bitmap2(bmap, new_desc_blk);
 
 	if (group == fs->group_desc_count-1) {
-		num_blocks = (fs->super->s_blocks_count -
+		num_blocks = (ext2fs_blocks_count(fs->super) -
 			     fs->super->s_first_data_block) %
 			fs->super->s_blocks_per_group;
 		if (!num_blocks)
diff --git a/lib/ext2fs/block.c b/lib/ext2fs/block.c
index eafb4cb..686a036 100644
--- a/lib/ext2fs/block.c
+++ b/lib/ext2fs/block.c
@@ -78,7 +78,7 @@ static int block_iterate_ind(blk_t *ind_block, blk_t ref_block,
 		ctx->bcount += limit;
 		return ret;
 	}
-	if (*ind_block >= ctx->fs->super->s_blocks_count ||
+	if (*ind_block >= ext2fs_blocks_count(ctx->fs->super) ||
 	    *ind_block < ctx->fs->super->s_first_data_block) {
 		ctx->errcode = EXT2_ET_BAD_IND_BLOCK;
 		ret |= BLOCK_ERROR;
@@ -166,7 +166,7 @@ static int block_iterate_dind(blk_t *dind_block, blk_t ref_block,
 		ctx->bcount += limit*limit;
 		return ret;
 	}
-	if (*dind_block >= ctx->fs->super->s_blocks_count ||
+	if (*dind_block >= ext2fs_blocks_count(ctx->fs->super) ||
 	    *dind_block < ctx->fs->super->s_first_data_block) {
 		ctx->errcode = EXT2_ET_BAD_DIND_BLOCK;
 		ret |= BLOCK_ERROR;
@@ -252,7 +252,7 @@ static int block_iterate_tind(blk_t *tind_block, blk_t ref_block,
 		ctx->bcount += limit*limit*limit;
 		return ret;
 	}
-	if (*tind_block >= ctx->fs->super->s_blocks_count ||
+	if (*tind_block >= ext2fs_blocks_count(ctx->fs->super) ||
 	    *tind_block < ctx->fs->super->s_first_data_block) {
 		ctx->errcode = EXT2_ET_BAD_TIND_BLOCK;
 		ret |= BLOCK_ERROR;
diff --git a/lib/ext2fs/bmove.c b/lib/ext2fs/bmove.c
index f685f9d..32fbbcb 100644
--- a/lib/ext2fs/bmove.c
+++ b/lib/ext2fs/bmove.c
@@ -50,7 +50,7 @@ static int process_block(ext2_filsys fs, blk_t	*block_nr,
 	 */
 	if (ext2fs_test_block_bitmap2(pb->reserve, block)) {
 		do {
-			if (++block >= fs->super->s_blocks_count)
+			if (++block >= ext2fs_blocks_count(fs->super))
 				block = fs->super->s_first_data_block;
 			if (block == orig) {
 				pb->error = EXT2_ET_BLOCK_ALLOC_FAIL;
diff --git a/lib/ext2fs/check_desc.c b/lib/ext2fs/check_desc.c
index f863c77..c3f0f7a 100644
--- a/lib/ext2fs/check_desc.c
+++ b/lib/ext2fs/check_desc.c
@@ -35,7 +35,7 @@ errcode_t ext2fs_check_desc(ext2_filsys fs)
 	errcode_t retval;
 	dgrp_t i;
 	blk_t first_block = fs->super->s_first_data_block;
-	blk_t last_block = fs->super->s_blocks_count-1;
+	blk_t last_block = ext2fs_blocks_count(fs->super)-1;
 	blk_t blk, b;
 	int j;
 
@@ -54,7 +54,7 @@ errcode_t ext2fs_check_desc(ext2_filsys fs)
 			first_block = ext2fs_group_first_block(fs, i);
 			last_block = ext2fs_group_last_block(fs, i);
 			if (i == (fs->group_desc_count - 1))
-				last_block = fs->super->s_blocks_count-1;
+				last_block = ext2fs_blocks_count(fs->super)-1;
 		}
 
 		/*
diff --git a/lib/ext2fs/closefs.c b/lib/ext2fs/closefs.c
index 226d04e..b5b32b2 100644
--- a/lib/ext2fs/closefs.c
+++ b/lib/ext2fs/closefs.c
@@ -151,9 +151,9 @@ int ext2fs_super_and_bgd_loc(ext2_filsys fs,
 					&ret_used_blks);
 
 	if (group == fs->group_desc_count-1) {
-		numblocks = (fs->super->s_blocks_count -
-			     fs->super->s_first_data_block) %
-			fs->super->s_blocks_per_group;
+		numblocks = (ext2fs_blocks_count(fs->super) -
+			     (blk64_t) fs->super->s_first_data_block) %
+			(blk64_t) fs->super->s_blocks_per_group;
 		if (!numblocks)
 			numblocks = fs->super->s_blocks_per_group;
 	} else
diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
index b1025e2..9ba37b2 100644
--- a/lib/ext2fs/ext_attr.c
+++ b/lib/ext2fs/ext_attr.c
@@ -117,7 +117,7 @@ errcode_t ext2fs_adjust_ea_refcount2(ext2_filsys fs, blk64_t blk,
 	struct ext2_ext_attr_header *header;
 	char	*buf = 0;
 
-	if ((blk >= fs->super->s_blocks_count) ||
+	if ((blk >= ext2fs_blocks_count(fs->super)) ||
 	    (blk < fs->super->s_first_data_block))
 		return EXT2_ET_BAD_EA_BLOCK_NUM;
 
diff --git a/lib/ext2fs/icount.c b/lib/ext2fs/icount.c
index fe24e56..465f183 100644
--- a/lib/ext2fs/icount.c
+++ b/lib/ext2fs/icount.c
@@ -744,7 +744,7 @@ static void setup(void)
 	initialize_ext2_error_table();
 
 	memset(&param, 0, sizeof(param));
-	param.s_blocks_count = 12000;
+	ext2fs_blocks_count_set(&param, 12000);
 
 	retval = ext2fs_initialize("test fs", EXT2_FLAG_NEW_BITMAPS, &param,
 				   test_io_manager, &test_fs);
diff --git a/lib/ext2fs/mkjournal.c b/lib/ext2fs/mkjournal.c
index 10dac51..5222fd1 100644
--- a/lib/ext2fs/mkjournal.c
+++ b/lib/ext2fs/mkjournal.c
@@ -321,7 +321,7 @@ static errcode_t write_journal_inode(ext2_filsys fs, ext2_ino_t journal_ino,
 	 * the filesystem.  Pick a group that has the largest number
 	 * of free blocks.
 	 */
-	group = ext2fs_group_of_blk(fs, (fs->super->s_blocks_count -
+	group = ext2fs_group_of_blk(fs, (ext2fs_blocks_count(fs->super) -
 					 fs->super->s_first_data_block) / 2);
 	log_flex = 1 << fs->super->s_log_groups_per_flex;
 	if (fs->super->s_log_groups_per_flex && (group > log_flex)) {
diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index 9607cde..c1617f3 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -54,7 +54,7 @@ blk64_t ext2fs_descriptor_block_loc2(ext2_filsys fs, blk64_t group_block,
 	 */
 	if (group_block != fs->super->s_first_data_block &&
 	    ((ret_blk + fs->super->s_blocks_per_group) <
-	     fs->super->s_blocks_count))
+	     ext2fs_blocks_count(fs->super)))
 		ret_blk += fs->super->s_blocks_per_group;
 	return ret_blk;
 }
@@ -285,9 +285,9 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 		retval = EXT2_ET_CORRUPT_SUPERBLOCK;
 		goto cleanup;
 	}
-	fs->group_desc_count = ext2fs_div_ceil(fs->super->s_blocks_count -
-					       fs->super->s_first_data_block,
-					       blocks_per_group);
+	fs->group_desc_count = ext2fs_div64_ceil(ext2fs_blocks_count(fs->super) -
+						 fs->super->s_first_data_block,
+						 blocks_per_group);
 	fs->desc_blocks = ext2fs_div_ceil(fs->group_desc_count,
 					  EXT2_DESC_PER_BLOCK(fs->super));
 	retval = ext2fs_get_array(fs->desc_blocks, fs->blocksize,
diff --git a/lib/ext2fs/rw_bitmaps.c b/lib/ext2fs/rw_bitmaps.c
index c859cca..d994fe3 100644
--- a/lib/ext2fs/rw_bitmaps.c
+++ b/lib/ext2fs/rw_bitmaps.c
@@ -81,9 +81,9 @@ static errcode_t write_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 
 		if (i == fs->group_desc_count - 1) {
 			/* Force bitmap padding for the last group */
-			nbits = ((fs->super->s_blocks_count
-				  - fs->super->s_first_data_block)
-				 % EXT2_BLOCKS_PER_GROUP(fs->super));
+			nbits = ((ext2fs_blocks_count(fs->super)
+				  - (__u64) fs->super->s_first_data_block)
+				 % (__u64) EXT2_BLOCKS_PER_GROUP(fs->super));
 			if (nbits)
 				for (j = nbits; j < fs->blocksize * 8; j++)
 					ext2fs_set_bit(j, block_buf);
diff --git a/lib/ext2fs/tst_badblocks.c b/lib/ext2fs/tst_badblocks.c
index 358da20..72b14b7 100644
--- a/lib/ext2fs/tst_badblocks.c
+++ b/lib/ext2fs/tst_badblocks.c
@@ -227,7 +227,7 @@ int file_test_invalid(badblocks_list bb)
 	fs->super = malloc(SUPERBLOCK_SIZE);
 	memset(fs->super, 0, SUPERBLOCK_SIZE);
 	fs->super->s_first_data_block = 1;
-	fs->super->s_blocks_count = 100;
+	ext2fs_blocks_count_set(fs->super, 100);
 
 	f = tmpfile();
 	if (!f) {
diff --git a/lib/ext2fs/tst_csum.c b/lib/ext2fs/tst_csum.c
index 0ffd92b..56148b8 100644
--- a/lib/ext2fs/tst_csum.c
+++ b/lib/ext2fs/tst_csum.c
@@ -57,7 +57,7 @@ int main(int argc, char **argv)
 	__u16 csum1, csum2, csum_known = 0xd3a4;
 
 	memset(&param, 0, sizeof(param));
-	param.s_blocks_count = 32768;
+	ext2fs_blocks_count_set(&param, 32768);
 
 	retval = ext2fs_initialize("test fs", EXT2_FLAG_NEW_BITMAPS, &param,
 				   test_io_manager, &fs);
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index a3388f6..9870cfd 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -199,9 +199,9 @@ static void test_disk(ext2_filsys fs, badblocks_list *bb_list)
 	errcode_t	retval;
 	char		buf[1024];
 
-	sprintf(buf, "badblocks -b %d -X %s%s%s %u", fs->blocksize,
+	sprintf(buf, "badblocks -b %d -X %s%s%s %llu", fs->blocksize,
 		quiet ? "" : "-s ", (cflag > 1) ? "-w " : "",
-		fs->device_name, fs->super->s_blocks_count-1);
+		fs->device_name, ext2fs_blocks_count(fs->super)-1);
 	if (verbose)
 		printf(_("Running command: %s\n"), buf);
 	f = popen(buf, "r");
@@ -544,7 +544,7 @@ static void create_journal_dev(ext2_filsys fs)
 	int			c, count, err_count;
 
 	retval = ext2fs_create_journal_superblock(fs,
-				  fs->super->s_blocks_count, 0, &buf);
+				  ext2fs_blocks_count(fs->super), 0, &buf);
 	if (retval) {
 		com_err("create_journal_dev", retval,
 			_("while initializing journal superblock"));
@@ -554,10 +554,10 @@ static void create_journal_dev(ext2_filsys fs)
 		memset(&progress, 0, sizeof(progress));
 	else
 		progress_init(&progress, _("Zeroing journal device: "),
-			      fs->super->s_blocks_count);
+			      ext2fs_blocks_count(fs->super));
 
 	blk = 0;
-	count = fs->super->s_blocks_count;
+	count = ext2fs_blocks_count(fs->super);
 	while (count > 0) {
 		if (count > 1024)
 			c = 1024;
-- 
1.5.6.5

