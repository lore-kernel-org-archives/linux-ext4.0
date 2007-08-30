From: Valerie Clement <valerie.clement@bull.net>
Subject: [PATCH 6/8][e2fsprogs] change access to the filesystem blocks
	counter
Date: Thu, 30 Aug 2007 17:40:52 +0200
Message-ID: <1188488452.15770.55.camel@ext1.frec.bull.fr>
References: <1188487715.15770.35.camel@ext1.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4 <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:43839 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755603AbXH3N0w (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Aug 2007 09:26:52 -0400
In-Reply-To: <1188487715.15770.35.camel@ext1.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


From: Valerie Clement <valerie.clement@bull.net>

This patch replaces all references to super->s_blocks_count by
ext2_blocks_count(super) in preparation for 64-bit support.

Signed-off-by: Valerie Clement <valerie.clement@bull.net>
---

 debugfs/debugfs.c          |    4 +--
 debugfs/logdump.c          |    2 +
 debugfs/lsdel.c            |    2 +
 debugfs/set_fields.c       |    1 +
 debugfs/unused.c           |    2 +
 e2fsck/badblocks.c         |    4 +--
 e2fsck/journal.c           |    4 +--
 e2fsck/pass1.c             |   16 ++++++-----
 e2fsck/pass2.c             |    4 +--
 e2fsck/pass5.c             |   14 +++++-----
 e2fsck/super.c             |   16 ++++++-----
 e2fsck/unix.c              |   10 ++++---
 lib/ext2fs/alloc.c         |    6 ++--
 lib/ext2fs/bb_inode.c      |    2 +
 lib/ext2fs/bitmaps.c       |    2 +
 lib/ext2fs/block.c         |    6 ++--
 lib/ext2fs/bmove.c         |    2 +
 lib/ext2fs/closefs.c       |    2 +
 lib/ext2fs/ext2fs.h        |    2 +
 lib/ext2fs/ext_attr.c      |    2 +
 lib/ext2fs/initialize.c    |   20 +++++++-------
 lib/ext2fs/openfs.c        |    4 +--
 lib/ext2fs/read_bb.c       |    2 +
 lib/ext2fs/read_bb_file.c  |    2 +
 lib/ext2fs/rw_bitmaps.c    |    2 +
 lib/ext2fs/tst_badblocks.c |    2 +
 lib/ext2fs/tst_iscan.c     |    2 +
 misc/e2image.c             |    2 +
 misc/mke2fs.c              |   56 +++++++++++++++++++++-------------------
 misc/tune2fs.c             |    4 +--
 misc/util.c                |    2 +
 resize/main.c              |    2 +
 resize/online.c            |   10 ++++---
 resize/resize2fs.c         |   62 ++++++++++++++++++++++----------------------
 tests/progs/test_icount.c  |    2 +
 35 files changed, 140 insertions(+), 137 deletions(-)

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 190c4b7..4a3aa0e 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -233,8 +233,8 @@ void do_init_filesys(int argc, char **argv)
 		return;
 
 	memset(&param, 0, sizeof(struct ext2_super_block));
-	param.s_blocks_count = parse_ulong(argv[2], argv[0],
-					   "blocks count", &err);
+	ext2_blocks_count_set(&param, parse_ulong(argv[2], argv[0],
+					   "blocks count", &err));
 	if (err)
 		return;
 	retval = ext2fs_initialize(argv[1], 0, &param,
diff --git a/debugfs/logdump.c b/debugfs/logdump.c
index 773d84e..50f6ac5 100644
--- a/debugfs/logdump.c
+++ b/debugfs/logdump.c
@@ -366,7 +366,7 @@ static void dump_journal(char *cmdname, FILE *out_file,
 			fprintf(out_file, "\tuuid=%s\n", jsb_buffer);
 			fprintf(out_file, "\tblocksize=%d\n", blocksize);
 			fprintf(out_file, "\tjournal data size %lu\n",
-				sb->s_blocks_count);
+				ext2_blocks_count(sb));
 		}
 	}
 	
diff --git a/debugfs/lsdel.c b/debugfs/lsdel.c
index 3dc32a7..f320331 100644
--- a/debugfs/lsdel.c
+++ b/debugfs/lsdel.c
@@ -57,7 +57,7 @@ static int lsdel_proc(ext2_filsys fs,
 	lsd->num_blocks++;
 
 	if (*block_nr < fs->super->s_first_data_block ||
-	    *block_nr >= fs->super->s_blocks_count) {
+	    *block_nr >= ext2_blocks_count(fs->super)) {
 		lsd->bad_blocks++;
 		return BLOCK_ABORT;
 	}
diff --git a/debugfs/set_fields.c b/debugfs/set_fields.c
index 9ff7f8c..9c23524 100644
--- a/debugfs/set_fields.c
+++ b/debugfs/set_fields.c
@@ -114,6 +114,7 @@ static struct field_set_info super_fields[] = {
 	{ "mkfs_time", &set_sb.s_mkfs_time, 4, parse_time },
 	{ "jnl_blocks", &set_sb.s_jnl_blocks[0], 4, parse_uint, FLAG_ARRAY, 
 	  17 },
+	{ "blocks_count_hi", &set_sb.s_blocks_count_hi, 4, parse_uint },
 	{ "flags", &set_sb.s_flags, 4, parse_uint },
 	{ 0, 0, 0, 0 }
 };
diff --git a/debugfs/unused.c b/debugfs/unused.c
index 0eee8e6..d94e528 100644
--- a/debugfs/unused.c
+++ b/debugfs/unused.c
@@ -36,7 +36,7 @@ void do_dump_unused(int argc EXT2FS_ATTR((unused)), char **argv)
 		return;
 
 	for (blk=current_fs->super->s_first_data_block;
-	     blk < current_fs->super->s_blocks_count; blk++) {
+	     blk < ext2_blocks_count(current_fs->super); blk++) {
 		if (ext2fs_test_block_bitmap(current_fs->block_map,blk))
 			continue;
 		retval = io_channel_read_blk(current_fs->io, blk, 1, buf);
diff --git a/e2fsck/badblocks.c b/e2fsck/badblocks.c
index 36dc208..49fde35 100644
--- a/e2fsck/badblocks.c
+++ b/e2fsck/badblocks.c
@@ -75,7 +75,7 @@ void read_bad_blocks_file(e2fsck_t ctx, const char *bad_blocks_file,
 		sprintf(buf, "badblocks -b %d -X %s%s%s %d", fs->blocksize,
 			(ctx->options & E2F_OPT_PREEN) ? "" : "-s ",
 			(ctx->options & E2F_OPT_WRITECHECK) ? "-n " : "",
-			fs->device_name, fs->super->s_blocks_count-1);
+			fs->device_name, ext2_blocks_count(fs->super) - 1);
 		f = popen(buf, "r");
 		if (!f) {
 			com_err("read_bad_blocks_file", errno,
@@ -124,7 +124,7 @@ static int check_bb_inode_blocks(ext2_filsys fs,
 	/*
 	 * If the block number is outrageous, clear it and ignore it.
 	 */
-	if (*block_nr >= fs->super->s_blocks_count ||
+	if (*block_nr >= ext2_blocks_count(fs->super) ||
 	    *block_nr < fs->super->s_first_data_block) {
 		printf(_("Warning: illegal block %u found in bad block inode.  "
 			 "Cleared.\n"), *block_nr);
diff --git a/e2fsck/journal.c b/e2fsck/journal.c
index 756bbcb..8b2b2a9 100644
--- a/e2fsck/journal.c
+++ b/e2fsck/journal.c
@@ -209,7 +209,7 @@ static int process_journal_block(ext2_filsys fs,
 	p = (struct process_block_struct *) priv_data;
 
 	if (blk < fs->super->s_first_data_block ||
-	    blk >= fs->super->s_blocks_count)
+	    blk >= ext2_blocks_count(fs->super))
 		return BLOCK_ABORT;
 
 	if (blockcnt >= 0)
@@ -403,7 +403,7 @@ static errcode_t e2fsck_get_journal(e2fsck_t ctx, journal_t **ret_journal)
 			goto errout;
 		}
 
-		journal->j_maxlen = jsuper.s_blocks_count;
+		journal->j_maxlen = ext2_blocks_count(&jsuper);
 		start++;
 	}
 
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index ceb9c7f..e053630 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -179,7 +179,7 @@ int e2fsck_pass1_check_symlink(ext2_filsys fs, struct ext2_inode *inode,
 		if ((inode->i_size >= fs->blocksize) ||
 		    (blocks != fs->blocksize >> 9) ||
 		    (inode->i_block[0] < fs->super->s_first_data_block) ||
-		    (inode->i_block[0] >= fs->super->s_blocks_count))
+		    (inode->i_block[0] >= ext2_blocks_count(fs->super)))
 			return 0;
 
 		for (i = 1; i < EXT2_N_BLOCKS; i++)
@@ -392,7 +392,7 @@ static void check_is_really_dir(e2fsck_t ctx, struct problem_context *pctx,
 			not_device++;
 
 		if (blk < ctx->fs->super->s_first_data_block ||
-		    blk >= ctx->fs->super->s_blocks_count ||
+		    blk >= ext2_blocks_count(ctx->fs->super) ||
 		    ext2fs_fast_test_block_bitmap(ctx->block_found_map, blk))
 			return;	/* Invalid block, can't be dir */
 	}
@@ -1274,7 +1274,7 @@ static int check_ext_attr(e2fsck_t ctx, struct problem_context *pctx,
 	 */
 	if (!(fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_EXT_ATTR) ||
 	    (blk < fs->super->s_first_data_block) ||
-	    (blk >= fs->super->s_blocks_count)) {
+	    (blk >= ext2_blocks_count(fs->super))) {
 		mark_inode_bad(ctx, ino);
 		return 0;
 	}
@@ -1434,7 +1434,7 @@ static int handle_htree(e2fsck_t ctx, struct problem_context *pctx,
 	blk = inode->i_block[0];
 	if (((blk == 0) ||
 	     (blk < fs->super->s_first_data_block) ||
-	     (blk >= fs->super->s_blocks_count)) &&
+	     (blk >= ext2_blocks_count(fs->super))) &&
 	    fix_problem(ctx, PR_1_HTREE_BADROOT, pctx))
 		return 1;
 
@@ -1646,8 +1646,8 @@ static char *describe_illegal_block(ext2_filsys fs, blk_t block)
 	if (block < super) {
 		sprintf(problem, "< FIRSTBLOCK (%u)", super);
 		return(problem);
-	} else if (block >= fs->super->s_blocks_count) {
-		sprintf(problem, "> BLOCKS (%u)", fs->super->s_blocks_count);
+	} else if (block >= ext2_blocks_count(fs->super)) {
+		sprintf(problem, "> BLOCKS (%u)", ext2_blocks_count(fs->super));
 		return(problem);
 	}
 	for (i = 0; i < fs->group_desc_count; i++) {
@@ -1774,7 +1774,7 @@ static int process_block(ext2_filsys fs,
 		problem = PR_1_TOOBIG_SYMLINK;
 	    
 	if (blk < fs->super->s_first_data_block ||
-	    blk >= fs->super->s_blocks_count)
+	    blk >= ext2_blocks_count(fs->super))
 		problem = PR_1_ILLEGAL_BLOCK_NUM;
 
 	if (problem) {
@@ -1862,7 +1862,7 @@ static int process_bad_block(ext2_filsys fs,
 	pctx->blkcount = blockcnt;
 
 	if ((blk < fs->super->s_first_data_block) ||
-	    (blk >= fs->super->s_blocks_count)) {
+	    (blk >= ext2_blocks_count(fs->super))) {
 		if (fix_problem(ctx, PR_1_BB_ILLEGAL_BLOCK_NUM, pctx)) {
 			*block_nr = 0;
 			return BLOCK_CHANGED;
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 7f7635f..3343d9e 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -1092,7 +1092,7 @@ static int deallocate_inode_block(ext2_filsys fs,
 	if (HOLE_BLKADDR(*block_nr))
 		return 0;
 	if ((*block_nr < fs->super->s_first_data_block) ||
-	    (*block_nr >= fs->super->s_blocks_count))
+	    (*block_nr >= ext2_blocks_count(fs->super)))
 		return 0;
 	ext2fs_unmark_block_bitmap(ctx->block_found_map, *block_nr);
 	ext2fs_block_alloc_stats(fs, *block_nr, -1);
@@ -1292,7 +1292,7 @@ extern int e2fsck_process_bad_inode(e2fsck_t ctx, ext2_ino_t dir,
 
 	if (inode.i_file_acl &&
 	    ((inode.i_file_acl < fs->super->s_first_data_block) ||
-	     (inode.i_file_acl >= fs->super->s_blocks_count))) {
+	     (inode.i_file_acl >= ext2_blocks_count(fs->super)))) {
 		if (fix_problem(ctx, PR_2_FILE_ACL_BAD, &pctx)) {
 			inode.i_file_acl = 0;
 			inode_modified++;
diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index 8e3794d..7e3f5ee 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -130,11 +130,11 @@ static void check_block_bitmaps(e2fsck_t ctx)
 
 	if ((fs->super->s_first_data_block <
 	     ext2fs_get_block_bitmap_start(ctx->block_found_map)) ||
-	    (fs->super->s_blocks_count-1 >
+	    (ext2_blocks_count(fs->super) - 1 >
 	     ext2fs_get_block_bitmap_end(ctx->block_found_map))) {
 		pctx.num = 1;
 		pctx.blk = fs->super->s_first_data_block;
-		pctx.blk2 = fs->super->s_blocks_count -1;
+		pctx.blk2 = ext2_blocks_count(fs->super) -1;
 		pctx.ino = ext2fs_get_block_bitmap_start(ctx->block_found_map);
 		pctx.ino2 = ext2fs_get_block_bitmap_end(ctx->block_found_map);
 		fix_problem(ctx, PR_5_BMAP_ENDPOINTS, &pctx);
@@ -145,11 +145,11 @@ static void check_block_bitmaps(e2fsck_t ctx)
 
 	if ((fs->super->s_first_data_block <
 	     ext2fs_get_block_bitmap_start(fs->block_map)) ||
-	    (fs->super->s_blocks_count-1 >
+	    (ext2_blocks_count(fs->super) - 1 >
 	     ext2fs_get_block_bitmap_end(fs->block_map))) {
 		pctx.num = 2;
 		pctx.blk = fs->super->s_first_data_block;
-		pctx.blk2 = fs->super->s_blocks_count -1;
+		pctx.blk2 = ext2_blocks_count(fs->super) - 1;
 		pctx.ino = ext2fs_get_block_bitmap_start(fs->block_map);
 		pctx.ino2 = ext2fs_get_block_bitmap_end(fs->block_map);
 		fix_problem(ctx, PR_5_BMAP_ENDPOINTS, &pctx);
@@ -170,7 +170,7 @@ redo_counts:
 		skip_group++;
 	super = fs->super->s_first_data_block;
 	for (i = fs->super->s_first_data_block;
-	     i < fs->super->s_blocks_count;
+	     i < ext2_blocks_count(fs->super);
 	     i++) {
 		actual = ext2fs_fast_test_block_bitmap(ctx->block_found_map, i);
 
@@ -230,7 +230,7 @@ redo_counts:
 		}
 		blocks ++;
 		if ((blocks == fs->super->s_blocks_per_group) ||
-		    (i == fs->super->s_blocks_count-1)) {
+		    (i == ext2_blocks_count(fs->super) - 1)) {
 			free_array[group] = group_free;
 			group ++;
 			blocks = 0;
@@ -242,7 +242,7 @@ redo_counts:
 						    fs->group_desc_count*2))
 					goto errout;
 			if (lazy_bg &&
-			    (i != fs->super->s_blocks_count-1) &&
+			    (i != ext2_blocks_count(fs->super) - 1) &&
 			    (fs->group_desc[group].bg_flags &
 			     EXT2_BG_BLOCK_UNINIT))
 				skip_group++;
diff --git a/e2fsck/super.c b/e2fsck/super.c
index a91f37e..d2693db 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -77,7 +77,7 @@ static int release_inode_block(ext2_filsys fs,
 		return 0;
 
 	if ((blk < fs->super->s_first_data_block) ||
-	    (blk >= fs->super->s_blocks_count)) {
+	    (blk >= ext2_blocks_count(fs->super))) {
 		fix_problem(ctx, PR_0_ORPHAN_ILLEGAL_BLOCK_NUM, pctx);
 	return_abort:
 		pb->abort = 1;
@@ -375,7 +375,7 @@ static void check_resize_inode(e2fsck_t ctx)
 	if ((i < EXT2_N_BLOCKS) || !blk || !inode.i_links_count ||
 	    !(inode.i_mode & LINUX_S_IFREG) ||
 	    (blk < fs->super->s_first_data_block ||
-	     blk >= fs->super->s_blocks_count)) {
+	     blk >= ext2_blocks_count(fs->super))) {
 	resize_inode_invalid:
 		if (fix_problem(ctx, PR_0_RESIZE_INODE_INVALID, &pctx)) {
 			memset(&inode, 0, sizeof(inode));
@@ -491,10 +491,10 @@ void check_super_block(e2fsck_t ctx)
 	 */
 	check_super_value(ctx, "inodes_count", sb->s_inodes_count,
 			  MIN_CHECK, 1, 0);
-	check_super_value(ctx, "blocks_count", sb->s_blocks_count,
+	check_super_value(ctx, "blocks_count", ext2_blocks_count(sb),
 			  MIN_CHECK, 1, 0);
 	check_super_value(ctx, "first_data_block", sb->s_first_data_block,
-			  MAX_CHECK, 0, sb->s_blocks_count);
+			  MAX_CHECK, 0, ext2_blocks_count(sb));
 	check_super_value(ctx, "log_block_size", sb->s_log_block_size,
 			  MIN_CHECK | MAX_CHECK, 0,
 			  EXT2_MAX_BLOCK_LOG_SIZE - EXT2_MIN_BLOCK_LOG_SIZE);
@@ -508,7 +508,7 @@ void check_super_block(e2fsck_t ctx)
 	check_super_value(ctx, "inodes_per_group", sb->s_inodes_per_group,
 			  MIN_CHECK | MAX_CHECK, inodes_per_block, ipg_max);
 	check_super_value(ctx, "r_blocks_count", sb->s_r_blocks_count,
-			  MAX_CHECK, 0, sb->s_blocks_count / 2);
+			  MAX_CHECK, 0, ext2_blocks_count(sb) / 2);
 	check_super_value(ctx, "reserved_gdt_blocks", 
 			  sb->s_reserved_gdt_blocks, MAX_CHECK, 0,
 			  fs->blocksize/4);
@@ -525,8 +525,8 @@ void check_super_block(e2fsck_t ctx)
 	}
 		
 	if ((ctx->flags & E2F_FLAG_GOT_DEVSIZE) &&
-	    (ctx->num_blocks < sb->s_blocks_count)) {
-		pctx.blk = sb->s_blocks_count;
+	    (ctx->num_blocks < ext2_blocks_count(sb))) {
+		pctx.blk = ext2_blocks_count(sb);
 		pctx.blk2 = ctx->num_blocks;
 		if (fix_problem(ctx, PR_0_FS_SIZE_WRONG, &pctx)) {
 			ctx->flags |= E2F_FLAG_ABORT;
@@ -641,7 +641,7 @@ void check_super_block(e2fsck_t ctx)
 		}
 	}
 	
-	if ((sb->s_free_blocks_count > sb->s_blocks_count) ||
+	if ((sb->s_free_blocks_count > ext2_blocks_count(sb)) ||
 	    (sb->s_free_inodes_count > sb->s_inodes_count))
 		ext2fs_unmark_valid(fs);
 
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index ad68c4b..610712f 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -110,8 +110,8 @@ static void show_stats(e2fsck_t	ctx)
 	inodes = fs->super->s_inodes_count;
 	inodes_used = (fs->super->s_inodes_count -
 		       fs->super->s_free_inodes_count);
-	blocks = fs->super->s_blocks_count;
-	blocks_used = (fs->super->s_blocks_count -
+	blocks = ext2_blocks_count(fs->super);
+	blocks_used = (ext2_blocks_count(fs->super) -
 		       fs->super->s_free_blocks_count);
 
 	frag_percent = (10000 * ctx->fs_fragmented) / inodes_used;
@@ -302,8 +302,8 @@ static void check_if_skip(e2fsck_t ctx)
 	printf(_("%s: clean, %u/%u files, %u/%u blocks"), ctx->device_name,
 	       fs->super->s_inodes_count - fs->super->s_free_inodes_count,
 	       fs->super->s_inodes_count,
-	       fs->super->s_blocks_count - fs->super->s_free_blocks_count,
-	       fs->super->s_blocks_count);
+	       ext2_blocks_count(fs->super) - fs->super->s_free_blocks_count,
+	       ext2_blocks_count(fs->super));
 	next_check = 100000;
 	if (fs->super->s_max_mnt_count > 0) {
 		next_check = fs->super->s_max_mnt_count - fs->super->s_mnt_count;
@@ -1215,7 +1215,7 @@ restart:
 	if (ctx->flags & E2F_FLAG_JOURNAL_INODE) {
 		if (fix_problem(ctx, PR_6_RECREATE_JOURNAL, &pctx)) {
 			if (journal_size < 1024)
-				journal_size = ext2fs_default_journal_size(fs->super->s_blocks_count);
+				journal_size = ext2fs_default_journal_size(ext2_blocks_count(fs->super));
 			if (journal_size < 0) {
 				fs->super->s_feature_compat &=
 					~EXT3_FEATURE_COMPAT_HAS_JOURNAL;
diff --git a/lib/ext2fs/alloc.c b/lib/ext2fs/alloc.c
index 7385123..e3ea8e0 100644
--- a/lib/ext2fs/alloc.c
+++ b/lib/ext2fs/alloc.c
@@ -84,7 +84,7 @@ errcode_t ext2fs_new_block(ext2_filsys fs, blk_t goal,
 		map = fs->block_map;
 	if (!map)
 		return EXT2_ET_NO_BLOCK_BITMAP;
-	if (!goal || (goal >= fs->super->s_blocks_count))
+	if (!goal || (goal >= ext2_blocks_count(fs->super)))
 		goal = fs->super->s_first_data_block;
 	i = goal;
 	do {
@@ -93,7 +93,7 @@ errcode_t ext2fs_new_block(ext2_filsys fs, blk_t goal,
 			return 0;
 		}
 		i++;
-		if (i >= fs->super->s_blocks_count)
+		if (i >= ext2_blocks_count(fs->super))
 			i = fs->super->s_first_data_block;
 	} while (i != goal);
 	return EXT2_ET_BLOCK_ALLOC_FAIL;
@@ -160,7 +160,7 @@ errcode_t ext2fs_get_free_blocks(ext2_filsys fs, blk_t start, blk_t finish,
 	if (!num)
 		num = 1;
 	do {
-		if (b+num-1 > fs->super->s_blocks_count)
+		if (b+num-1 > ext2_blocks_count(fs->super))
 			b = fs->super->s_first_data_block;
 		if (ext2fs_fast_test_block_bitmap_range(map, b, num)) {
 			*ret = b;
diff --git a/lib/ext2fs/bb_inode.c b/lib/ext2fs/bb_inode.c
index 97a5608..0d252ea 100644
--- a/lib/ext2fs/bb_inode.c
+++ b/lib/ext2fs/bb_inode.c
@@ -166,7 +166,7 @@ static int clear_bad_block_proc(ext2_filsys fs, blk_t *block_nr,
 	/*
 	 * If the block number is outrageous, clear it and ignore it.
 	 */
-	if (*block_nr >= fs->super->s_blocks_count ||
+	if (*block_nr >= ext2_blocks_count(fs->super) ||
 	    *block_nr < fs->super->s_first_data_block) {
 		*block_nr = 0;
 		return BLOCK_CHANGED;
diff --git a/lib/ext2fs/bitmaps.c b/lib/ext2fs/bitmaps.c
index b033fa3..0427225 100644
--- a/lib/ext2fs/bitmaps.c
+++ b/lib/ext2fs/bitmaps.c
@@ -78,7 +78,7 @@ errcode_t ext2fs_allocate_block_bitmap(ext2_filsys fs,
 	fs->write_bitmaps = ext2fs_write_bitmaps;
 
 	start = fs->super->s_first_data_block;
-	end = fs->super->s_blocks_count-1;
+	end = ext2_blocks_count(fs->super) - 1;
 	real_end = (EXT2_BLOCKS_PER_GROUP(fs->super)  
 		    * fs->group_desc_count)-1 + start;
 	
diff --git a/lib/ext2fs/block.c b/lib/ext2fs/block.c
index 7685680..91cdd28 100644
--- a/lib/ext2fs/block.c
+++ b/lib/ext2fs/block.c
@@ -53,7 +53,7 @@ static int block_iterate_ind(blk_t *ind_block, blk_t ref_block,
 		ctx->bcount += limit;
 		return ret;
 	}
-	if (*ind_block >= ctx->fs->super->s_blocks_count ||
+	if (*ind_block >= ext2_blocks_count(ctx->fs->super) ||
 	    *ind_block < ctx->fs->super->s_first_data_block) {
 		ctx->errcode = EXT2_ET_BAD_IND_BLOCK;
 		ret |= BLOCK_ERROR;
@@ -127,7 +127,7 @@ static int block_iterate_dind(blk_t *dind_block, blk_t ref_block,
 		ctx->bcount += limit*limit;
 		return ret;
 	}
-	if (*dind_block >= ctx->fs->super->s_blocks_count ||
+	if (*dind_block >= ext2_blocks_count(ctx->fs->super) ||
 	    *dind_block < ctx->fs->super->s_first_data_block) {
 		ctx->errcode = EXT2_ET_BAD_DIND_BLOCK;
 		ret |= BLOCK_ERROR;
@@ -203,7 +203,7 @@ static int block_iterate_tind(blk_t *tind_block, blk_t ref_block,
 		ctx->bcount += limit*limit*limit;
 		return ret;
 	}
-	if (*tind_block >= ctx->fs->super->s_blocks_count ||
+	if (*tind_block >= ext2_blocks_count(ctx->fs->super) ||
 	    *tind_block < ctx->fs->super->s_first_data_block) {
 		ctx->errcode = EXT2_ET_BAD_TIND_BLOCK;
 		ret |= BLOCK_ERROR;
diff --git a/lib/ext2fs/bmove.c b/lib/ext2fs/bmove.c
index 9946c46..ec200f8 100644
--- a/lib/ext2fs/bmove.c
+++ b/lib/ext2fs/bmove.c
@@ -50,7 +50,7 @@ static int process_block(ext2_filsys fs, blk_t	*block_nr,
 	 */
 	if (ext2fs_test_block_bitmap(pb->reserve, block)) {
 		do {
-			if (++block >= fs->super->s_blocks_count)
+			if (++block >= ext2_blocks_count(fs->super))
 				block = fs->super->s_first_data_block;
 			if (block == orig) {
 				pb->error = EXT2_ET_BLOCK_ALLOC_FAIL;
diff --git a/lib/ext2fs/closefs.c b/lib/ext2fs/closefs.c
index da95b54..f1cbe4e 100644
--- a/lib/ext2fs/closefs.c
+++ b/lib/ext2fs/closefs.c
@@ -66,7 +66,7 @@ int ext2fs_super_and_bgd_loc(ext2_filsys fs,
 			fs->desc_blocks + fs->super->s_reserved_gdt_blocks;
 
 	if (group == fs->group_desc_count-1) {
-		numblocks = (fs->super->s_blocks_count -
+		numblocks = (ext2_blocks_count(fs->super) -
 			     fs->super->s_first_data_block) %
 			fs->super->s_blocks_per_group;
 		if (!numblocks)
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index b60318c..6c4ec69 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1257,7 +1257,7 @@ _INLINE_ void ext2_free_blocks_count_set(struct ext2_super_block *super,
 _INLINE_ blk_t ext2fs_group_last_block(ext2_filsys fs, dgrp_t group)
 {
 	return (group == fs->group_desc_count - 1 ?
-		fs->super->s_blocks_count - 1 :
+		ext2_blocks_count(fs->super) - 1 :
 		ext2fs_group_first_block(fs, group) +
 			(fs->super->s_blocks_per_group - 1));
 }
diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
index 08211c3..5bced12 100644
--- a/lib/ext2fs/ext_attr.c
+++ b/lib/ext2fs/ext_attr.c
@@ -74,7 +74,7 @@ errcode_t ext2fs_adjust_ea_refcount(ext2_filsys fs, blk_t blk,
 	struct ext2_ext_attr_header *header;
 	char	*buf = 0;
 
-	if ((blk >= fs->super->s_blocks_count) ||
+	if ((blk >= ext2_blocks_count(fs->super)) ||
 	    (blk < fs->super->s_first_data_block))
 		return EXT2_ET_BAD_EA_BLOCK_NUM;
 
diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
index f5bff1e..cb68191 100644
--- a/lib/ext2fs/initialize.c
+++ b/lib/ext2fs/initialize.c
@@ -75,8 +75,8 @@ static unsigned int calc_reserved_gdt_blocks(ext2_filsys fs)
 	/* We set it at 1024x the current filesystem size, or
 	 * the upper block count limit (2^32), whichever is lower.
 	 */
-	if (sb->s_blocks_count < max_blocks / 1024)
-		max_blocks = sb->s_blocks_count * 1024;
+	if (ext2_blocks_count(sb) < max_blocks / 1024)
+		max_blocks = ext2_blocks_count(sb) * 1024;
 	rsv_groups = ext2fs_div_ceil(max_blocks - sb->s_first_data_block, bpg);
 	rsv_gdb = ext2fs_div_ceil(rsv_groups, gdpb) - fs->desc_blocks;
 	if (rsv_gdb > EXT2_ADDR_PER_BLOCK(sb))
@@ -107,7 +107,7 @@ errcode_t ext2fs_initialize(const char *name, int flags,
 	char		*buf;
 	char		c;
 
-	if (!param || !param->s_blocks_count)
+	if (!param || !ext2_blocks_count(param))
 		return EXT2_ET_INVALID_ARGUMENT;
 	
 	retval = ext2fs_get_mem(sizeof(struct struct_ext2_filsys), &fs);
@@ -187,9 +187,9 @@ errcode_t ext2fs_initialize(const char *name, int flags,
 		super->s_blocks_per_group = EXT2_MAX_BLOCKS_PER_GROUP(super);
 	super->s_frags_per_group = super->s_blocks_per_group * frags_per_block;
 	
-	super->s_blocks_count = param->s_blocks_count;
+	ext2_blocks_count_set(super, ext2_blocks_count(param));
 	super->s_r_blocks_count = param->s_r_blocks_count;
-	if (super->s_r_blocks_count >= param->s_blocks_count) {
+	if (super->s_r_blocks_count >= ext2_blocks_count(param)) {
 		retval = EXT2_ET_INVALID_ARGUMENT;
 		goto cleanup;
 	}
@@ -206,7 +206,7 @@ errcode_t ext2fs_initialize(const char *name, int flags,
 	}
 
 retry:
-	fs->group_desc_count = ext2fs_div_ceil(super->s_blocks_count -
+	fs->group_desc_count = ext2fs_div_ceil(ext2_blocks_count(super) -
 					       super->s_first_data_block,
 					       EXT2_BLOCKS_PER_GROUP(super));
 	if (fs->group_desc_count == 0) {
@@ -217,7 +217,7 @@ retry:
 					  EXT2_DESC_PER_BLOCK(super));
 
 	i = fs->blocksize >= 4096 ? 1 : 4096 / fs->blocksize;
-	set_field(s_inodes_count, super->s_blocks_count / i);
+	set_field(s_inodes_count, ext2_blocks_count(super) / i);
 
 	/*
 	 * Make sure we have at least EXT2_FIRST_INO + 1 inodes, so
@@ -237,7 +237,7 @@ retry:
 		if (super->s_blocks_per_group >= 256) {
 			/* Try again with slightly different parameters */
 			super->s_blocks_per_group -= 8;
-			super->s_blocks_count = param->s_blocks_count;
+			ext2_blocks_count_set(super, ext2_blocks_count(param));
 			super->s_frags_per_group = super->s_blocks_per_group *
 				frags_per_block;
 			goto retry;
@@ -321,12 +321,12 @@ ipg_retry:
 	overhead = (int) (2 + fs->inode_blocks_per_group);
 	if (ext2fs_bg_has_super(fs, fs->group_desc_count - 1))
 		overhead += 1 + fs->desc_blocks + super->s_reserved_gdt_blocks;
-	rem = ((super->s_blocks_count - super->s_first_data_block) %
+	rem = ((ext2_blocks_count(super) - super->s_first_data_block) %
 	       super->s_blocks_per_group);
 	if ((fs->group_desc_count == 1) && rem && (rem < overhead))
 		return EXT2_ET_TOOSMALL;
 	if (rem && (rem < overhead+50)) {
-		super->s_blocks_count -= rem;
+		ext2_blocks_count_set(super, ext2_blocks_count(super) - rem);
 		goto retry;
 	}
 
diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index 73ab088..4f2585b 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -53,7 +53,7 @@ blk_t ext2fs_descriptor_block_loc(ext2_filsys fs, blk_t group_block, dgrp_t i)
 	 */
 	if (group_block != fs->super->s_first_data_block &&
 	    ((ret_blk + fs->super->s_blocks_per_group) <
-	     fs->super->s_blocks_count))
+	     ext2_blocks_count(fs->super)))
 		ret_blk += fs->super->s_blocks_per_group;
 	return ret_blk;
 }
@@ -270,7 +270,7 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 		retval = EXT2_ET_CORRUPT_SUPERBLOCK;
 		goto cleanup;
 	}
-	fs->group_desc_count = ext2fs_div_ceil(fs->super->s_blocks_count -
+	fs->group_desc_count = ext2fs_div_ceil(ext2_blocks_count(fs->super) -
 					       fs->super->s_first_data_block,
 					       blocks_per_group);
 	fs->desc_blocks = ext2fs_div_ceil(fs->group_desc_count,
diff --git a/lib/ext2fs/read_bb.c b/lib/ext2fs/read_bb.c
index c717adc..0841232 100644
--- a/lib/ext2fs/read_bb.c
+++ b/lib/ext2fs/read_bb.c
@@ -49,7 +49,7 @@ static int mark_bad_block(ext2_filsys fs, blk_t *block_nr,
 		return 0;
 	
 	if ((*block_nr < fs->super->s_first_data_block) ||
-	    (*block_nr >= fs->super->s_blocks_count))
+	    (*block_nr >= ext2_blocks_count(fs->super)))
 		return 0;	/* Ignore illegal blocks */
 
 	rb->err = ext2fs_badblocks_list_add(rb->bb_list, *block_nr);
diff --git a/lib/ext2fs/read_bb_file.c b/lib/ext2fs/read_bb_file.c
index 2ac71f4..b2cb5d3 100644
--- a/lib/ext2fs/read_bb_file.c
+++ b/lib/ext2fs/read_bb_file.c
@@ -59,7 +59,7 @@ errcode_t ext2fs_read_bb_FILE2(ext2_filsys fs, FILE *f,
 			continue;
 		if (fs &&
 		    ((blockno < fs->super->s_first_data_block) ||
-		    (blockno >= fs->super->s_blocks_count))) {
+		    (blockno >= ext2_blocks_count(fs->super)))) {
 			if (invalid)
 				(invalid)(fs, blockno, buf, priv_data);
 			continue;
diff --git a/lib/ext2fs/rw_bitmaps.c b/lib/ext2fs/rw_bitmaps.c
index 603b590..1c2c756 100644
--- a/lib/ext2fs/rw_bitmaps.c
+++ b/lib/ext2fs/rw_bitmaps.c
@@ -103,7 +103,7 @@ static errcode_t write_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 
 		if (i == fs->group_desc_count - 1) {
 			/* Force bitmap padding for the last group */
-			nbits = ((fs->super->s_blocks_count
+			nbits = ((ext2_blocks_count(fs->super)
 				  - fs->super->s_first_data_block)
 				 % EXT2_BLOCKS_PER_GROUP(fs->super));
 			if (nbits)
diff --git a/lib/ext2fs/tst_badblocks.c b/lib/ext2fs/tst_badblocks.c
index 2453f47..abb5dc8 100644
--- a/lib/ext2fs/tst_badblocks.c
+++ b/lib/ext2fs/tst_badblocks.c
@@ -227,7 +227,7 @@ int file_test_invalid(badblocks_list bb)
 	fs->super = malloc(SUPERBLOCK_SIZE);
 	memset(fs->super, 0, SUPERBLOCK_SIZE);
 	fs->super->s_first_data_block = 1;
-	fs->super->s_blocks_count = 100;
+	ext2_blocks_count_set(fs->super, 100);
 
 	f = tmpfile();
 	if (!f) {
diff --git a/lib/ext2fs/tst_iscan.c b/lib/ext2fs/tst_iscan.c
index d7fdc12..df16355 100644
--- a/lib/ext2fs/tst_iscan.c
+++ b/lib/ext2fs/tst_iscan.c
@@ -71,7 +71,7 @@ static void setup(void)
 	initialize_ext2_error_table();
 
 	memset(&param, 0, sizeof(param));
-	param.s_blocks_count = 12000;
+	ext2_blocks_count_set(&param, 12000);
 
 
 	test_io_cb_read_blk = test_read_blk;
diff --git a/misc/e2image.c b/misc/e2image.c
index dd13cea..74772c7 100644
--- a/misc/e2image.c
+++ b/misc/e2image.c
@@ -411,7 +411,7 @@ static void output_meta_data_blocks(ext2_filsys fs, int fd)
 		exit(1);
 	}
 	memset(zero_buf, 0, fs->blocksize);
-	for (blk = 0; blk < fs->super->s_blocks_count; blk++) {
+	for (blk = 0; blk < ext2_blocks_count(fs->super); blk++) {
 		if ((blk >= fs->super->s_first_data_block) &&
 		    ext2fs_test_block_bitmap(meta_block_map, blk)) {
 			retval = io_channel_read_blk(fs->io, blk, 1, buf);
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 3dc5e18..021625a 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -192,7 +192,7 @@ static void test_disk(ext2_filsys fs, badblocks_list *bb_list)
 
 	sprintf(buf, "badblocks -b %d -X %s%s%s %u", fs->blocksize,
 		quiet ? "" : "-s ", (cflag > 1) ? "-w " : "",
-		fs->device_name, fs->super->s_blocks_count-1);
+		fs->device_name, ext2_blocks_count(fs->super) - 1);
 	if (verbose)
 		printf(_("Running command: %s\n"), buf);
 	f = popen(buf, "r");
@@ -626,7 +626,7 @@ static void create_journal_dev(ext2_filsys fs)
 	int			count;
 
 	retval = ext2fs_create_journal_superblock(fs,
-				  fs->super->s_blocks_count, 0, &buf);
+				  ext2_blocks_count(fs->super), 0, &buf);
 	if (retval) {
 		com_err("create_journal_dev", retval,
 			_("while initializing journal superblock"));
@@ -636,9 +636,9 @@ static void create_journal_dev(ext2_filsys fs)
 		memset(&progress, 0, sizeof(progress));
 	else
 		progress_init(&progress, _("Zeroing journal device: "),
-			      fs->super->s_blocks_count);
+			      ext2_blocks_count(fs->super));
 
-	retval = zero_blocks(fs, 0, fs->super->s_blocks_count,
+	retval = zero_blocks(fs, 0, ext2_blocks_count(fs->super),
 			     &progress, &blk, &count);
 	if (retval) {
 		com_err("create_journal_dev", retval,
@@ -668,9 +668,9 @@ static void show_stats(ext2_filsys fs)
 	dgrp_t			i;
 	int			need, col_left;
 	
-	if (fs_param.s_blocks_count != s->s_blocks_count)
+	if (ext2_blocks_count(&fs_param) != ext2_blocks_count(s))
 		fprintf(stderr, _("warning: %u blocks unused.\n\n"),
-		       fs_param.s_blocks_count - s->s_blocks_count);
+		       ext2_blocks_count(&fs_param) - ext2_blocks_count(s));
 
 	memset(buf, 0, sizeof(buf));
 	strncpy(buf, s->s_volume_name, sizeof(s->s_volume_name));
@@ -685,10 +685,10 @@ static void show_stats(ext2_filsys fs)
 	printf(_("Fragment size=%u (log=%u)\n"), fs->fragsize,
 		s->s_log_frag_size);
 	printf(_("%u inodes, %u blocks\n"), s->s_inodes_count,
-	       s->s_blocks_count);
+	       ext2_blocks_count(s));
 	printf(_("%u blocks (%2.2f%%) reserved for the super user\n"),
 		s->s_r_blocks_count,
-	       100.0 * s->s_r_blocks_count / s->s_blocks_count);
+	       100.0 * s->s_r_blocks_count / ext2_blocks_count(s));
 	printf(_("First data block=%u\n"), s->s_first_data_block);
 	if (s->s_reserved_gdt_blocks)
 		printf(_("Maximum filesystem blocks=%lu\n"),
@@ -813,7 +813,7 @@ static void parse_extended_opts(struct ext2_super_block *param,
 				r_usage++;
 				continue;
 			}
-			if (resize <= param->s_blocks_count) {
+			if (resize <= ext2_blocks_count(param)) {
 				fprintf(stderr, 
 					_("The resize maximum must be greater "
 					  "than the filesystem size.\n"));
@@ -827,7 +827,7 @@ static void parse_extended_opts(struct ext2_super_block *param,
 				bpg = blocksize * 8;
 			gdpb = EXT2_DESC_PER_BLOCK(param);
 			group_desc_count = 
-				ext2fs_div_ceil(param->s_blocks_count, bpg);
+				ext2fs_div_ceil(ext2_blocks_count(param), bpg);
 			desc_blocks = (group_desc_count +
 				       gdpb - 1) / gdpb;
 			rsv_groups = ext2fs_div_ceil(resize, bpg);
@@ -1221,9 +1221,10 @@ static void PRS(int argc, char *argv[])
 			blocksize, sys_page_size);
 	}
 	if (optind < argc) {
-		fs_param.s_blocks_count = parse_num_blocks(argv[optind++], 
-				fs_param.s_log_block_size);
-		if (!fs_param.s_blocks_count) {
+		ext2_blocks_count_set(&fs_param,
+				parse_num_blocks(argv[optind++],
+				fs_param.s_log_block_size));
+		if (!ext2_blocks_count(&fs_param)) {
 			com_err(program_name, 0, _("invalid blocks count - %s"),
 				argv[optind - 1]);
 			exit(1);
@@ -1238,8 +1239,8 @@ static void PRS(int argc, char *argv[])
 
 	fs_param.s_log_frag_size = fs_param.s_log_block_size;
 
-	if (noaction && fs_param.s_blocks_count) {
-		dev_size = fs_param.s_blocks_count;
+	if (noaction && ext2_blocks_count(&fs_param)) {
+		dev_size = ext2_blocks_count(&fs_param);
 		retval = 0;
 	} else {
 	retry:
@@ -1260,7 +1261,7 @@ static void PRS(int argc, char *argv[])
 			_("while trying to determine filesystem size"));
 		exit(1);
 	}
-	if (!fs_param.s_blocks_count) {
+	if (!ext2_blocks_count(&fs_param)) {
 		if (retval == EXT2_ET_UNIMPLEMENTED) {
 			com_err(program_name, 0,
 				_("Couldn't determine device size; you "
@@ -1280,20 +1281,20 @@ static void PRS(int argc, char *argv[])
 				  ));
 				exit(1);
 			}
-			fs_param.s_blocks_count = dev_size;
+			ext2_blocks_count_set(&fs_param, dev_size);
 			if (sys_page_size > EXT2_BLOCK_SIZE(&fs_param))
 				fs_param.s_blocks_count &= ~((sys_page_size /
 					   EXT2_BLOCK_SIZE(&fs_param))-1);
 		}
 		
-	} else if (!force && (fs_param.s_blocks_count > dev_size)) {
+	} else if (!force && (ext2_blocks_count(&fs_param) > dev_size)) {
 		com_err(program_name, 0,
 			_("Filesystem larger than apparent device size."));
 		proceed_question();
 	}
 
 	if (!fs_type) {
-		int megs = (__u64)fs_param.s_blocks_count *
+		int megs = ext2_blocks_count(&fs_param) *
 			(EXT2_BLOCK_SIZE(&fs_param) / 1024) / 1024;
 
 		if (fs_param.s_feature_incompat & 
@@ -1405,7 +1406,8 @@ static void PRS(int argc, char *argv[])
 		if ((blocksize < 0) && (use_bsize < (-blocksize)))
 			use_bsize = -blocksize;
 		blocksize = use_bsize;
-		fs_param.s_blocks_count /= blocksize / 1024;
+		ext2_blocks_count_set(&fs_param,
+				ext2_blocks_count(&fs_param) / (blocksize / 1024));
 	}
 
 	if (inode_ratio == 0) {
@@ -1467,7 +1469,7 @@ static void PRS(int argc, char *argv[])
 	}
 
 
-	if (!force && fs_param.s_blocks_count >= ((unsigned) 1 << 31)) {
+	if (!force && ext2_blocks_count(&fs_param) >= ((unsigned) 1 << 31)) {
 		com_err(program_name, 0,
 			_("Filesystem too large.  No more than 2**31-1 blocks\n"
 			  "\t (8TB using a blocksize of 4k) are currently supported."));
@@ -1508,7 +1510,7 @@ static void PRS(int argc, char *argv[])
 	/* Make sure number of inodes specified will fit in 32 bits */
 	if (num_inodes == 0) {
 		unsigned long long n;
-		n = (unsigned long long) fs_param.s_blocks_count * blocksize / inode_ratio;
+		n = (unsigned long long) ext2_blocks_count(&fs_param) * blocksize / inode_ratio;
 		if (n > ~0U) {
 			com_err(program_name, 0,
 			    _("too many inodes (%llu), raise inode ratio?"), n);
@@ -1524,12 +1526,12 @@ static void PRS(int argc, char *argv[])
 	 * Calculate number of inodes based on the inode ratio
 	 */
 	fs_param.s_inodes_count = num_inodes ? num_inodes : 
-		((__u64) fs_param.s_blocks_count * blocksize)
+		((__u64) ext2_blocks_count(&fs_param) * blocksize)
 			/ inode_ratio;
 
 	if ((((long long)fs_param.s_inodes_count) *
 	     (inode_size ? inode_size : EXT2_GOOD_OLD_INODE_SIZE)) >=
-	    (((long long)fs_param.s_blocks_count) * 
+	    (((long long)ext2_blocks_count(&fs_param)) *
 	     EXT2_BLOCK_SIZE(&fs_param))) {
 		com_err(program_name, 0, _("inode_size (%u) * inodes_count "
 					  "(%u) too big for a\n\t"
@@ -1538,7 +1540,7 @@ static void PRS(int argc, char *argv[])
 					  "or lower inode count (-N).\n"),
 			inode_size ? inode_size : EXT2_GOOD_OLD_INODE_SIZE,
 			fs_param.s_inodes_count, 
-			(unsigned long) fs_param.s_blocks_count);
+			(unsigned long) ext2_blocks_count(&fs_param));
 		exit(1);
 	}
 
@@ -1546,7 +1548,7 @@ static void PRS(int argc, char *argv[])
 	 * Calculate number of blocks to reserve
 	 */
 	fs_param.s_r_blocks_count = e2p_percent(reserved_ratio, 
-						fs_param.s_blocks_count);
+						ext2_blocks_count(&fs_param));
 }
 
 int main (int argc, char *argv[])
@@ -1677,7 +1679,7 @@ int main (int argc, char *argv[])
 	} else {
 		/* rsv must be a power of two (64kB is MD RAID sb alignment) */
 		unsigned int rsv = 65536 / fs->blocksize;
-		unsigned long blocks = fs->super->s_blocks_count;
+		unsigned long blocks = ext2_blocks_count(fs->super);
 		unsigned long start;
 		blk_t ret_blk;
 
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 833b994..5eaa252 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -826,13 +826,13 @@ int main (int argc, char ** argv)
 	}
 	if (m_flag) {
 		sb->s_r_blocks_count = e2p_percent(reserved_ratio,
-						   sb->s_blocks_count);
+						   ext2_blocks_count(sb));
 		ext2fs_mark_super_dirty(fs);
 		printf (_("Setting reserved blocks percentage to %g%% (%u blocks)\n"),
 			reserved_ratio, sb->s_r_blocks_count);
 	}
 	if (r_flag) {
-		if (reserved_blocks >= sb->s_blocks_count/2) {
+		if (reserved_blocks >= ext2_blocks_count(sb) / 2) {
 			com_err (program_name, 0,
 				 _("reserved blocks count is too big (%lu)"),
 				 reserved_blocks);
diff --git a/misc/util.c b/misc/util.c
index 6a4c40c..8fe505a 100644
--- a/misc/util.c
+++ b/misc/util.c
@@ -253,7 +253,7 @@ unsigned int figure_journal_size(int size, ext2_filsys fs)
 {
 	int j_blocks;
 
-	j_blocks = ext2fs_default_journal_size(fs->super->s_blocks_count);
+	j_blocks = ext2fs_default_journal_size(ext2_blocks_count(fs->super));
 	if (j_blocks < 0) {
 		fputs(_("\nFilesystem too small for a journal\n"), stderr);
 		return 0;
diff --git a/resize/main.c b/resize/main.c
index 7db4ebc..a7e0190 100644
--- a/resize/main.c
+++ b/resize/main.c
@@ -380,7 +380,7 @@ int main (int argc, char ** argv)
 			fs->blocksize / 1024, new_size);
 		exit(1);
 	}
-	if (new_size == fs->super->s_blocks_count) {
+	if (new_size == ext2_blocks_count(fs->super)) {
 		fprintf(stderr, _("The filesystem is already %u blocks "
 			"long.  Nothing to do!\n\n"), new_size);
 		exit(0);
diff --git a/resize/online.c b/resize/online.c
index 36b3185..ebc4ff9 100644
--- a/resize/online.c
+++ b/resize/online.c
@@ -33,9 +33,9 @@ errcode_t online_resize_fs(ext2_filsys fs, const char *mtpt,
 	printf(_("Filesystem at %s is mounted on %s; "
 		 "on-line resizing required\n"), fs->device_name, mtpt);
 
-	if (*new_size < sb->s_blocks_count) {
+	if (*new_size < ext2_blocks_count(sb)) {
 		printf(_("On-line shrinking from %u to %u not supported.\n"),
-		       sb->s_blocks_count, *new_size);
+		       ext2_blocks_count(sb), *new_size);
 		exit(1);
 	}
 
@@ -65,7 +65,7 @@ errcode_t online_resize_fs(ext2_filsys fs, const char *mtpt,
 		exit(1);
 	}
 
-	size=sb->s_blocks_count;
+	size = ext2_blocks_count(sb);
 	if (ioctl(fd, EXT2_IOC_GROUP_EXTEND, &size)) {
 		if (errno == EPERM)
 			com_err(program_name, 0, 
@@ -79,7 +79,7 @@ errcode_t online_resize_fs(ext2_filsys fs, const char *mtpt,
 		exit(1);
 	}
 
-	r_frac = ext2fs_div_ceil(100 * sb->s_r_blocks_count, sb->s_blocks_count);
+	r_frac = ext2fs_div_ceil(100 * sb->s_r_blocks_count, ext2_blocks_count(sb));
 
 	retval = ext2fs_read_bitmaps(fs);
 	if (retval)
@@ -122,7 +122,7 @@ errcode_t online_resize_fs(ext2_filsys fs, const char *mtpt,
 		input.inode_table = new_fs->group_desc[i].bg_inode_table;
 		input.blocks_count = sb->s_blocks_per_group;
 		if (i == new_fs->group_desc_count-1) {
-			input.blocks_count = new_fs->super->s_blocks_count -
+			input.blocks_count = ext2_blocks_count(new_fs->super) -
 				sb->s_first_data_block - 
 				(i * sb->s_blocks_per_group);
 		}
diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 12bdd89..6c37f77 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -100,7 +100,7 @@ errcode_t resize_fs(ext2_filsys fs, blk_t *new_size, int flags,
 	if (retval)
 		goto errout;
 
-	*new_size = rfs->new_fs->super->s_blocks_count;
+	*new_size = ext2_blocks_count(rfs->new_fs->super);
 
 	retval = blocks_to_move(rfs);
 	if (retval)
@@ -189,10 +189,10 @@ errcode_t adjust_fs_info(ext2_filsys fs, ext2_filsys old_fs, blk_t new_size)
 	int		has_super;
 	unsigned long long new_inodes;	/* u64 to check for overflow */
 
-	fs->super->s_blocks_count = new_size;
+	ext2_blocks_count_set(fs->super, new_size);
 
 retry:
-	fs->group_desc_count = ext2fs_div_ceil(fs->super->s_blocks_count -
+	fs->group_desc_count = ext2fs_div_ceil(ext2_blocks_count(fs->super) -
 				       fs->super->s_first_data_block,
 				       EXT2_BLOCKS_PER_GROUP(fs->super));
 	if (fs->group_desc_count == 0)
@@ -217,12 +217,12 @@ retry:
 	 * necessary data structures.  If not, we need to get rid of
 	 * it.
 	 */
-	rem = (fs->super->s_blocks_count - fs->super->s_first_data_block) %
+	rem = (ext2_blocks_count(fs->super) - fs->super->s_first_data_block) %
 		fs->super->s_blocks_per_group;
 	if ((fs->group_desc_count == 1) && rem && (rem < overhead))
 		return EXT2_ET_TOOSMALL;
 	if (rem && (rem < overhead+50)) {
-		fs->super->s_blocks_count -= rem;
+		ext2_blocks_count_set(fs->super, ext2_blocks_count(fs->super) - rem);
 		goto retry;
 	}
 	/*
@@ -240,21 +240,21 @@ retry:
 	/*
 	 * Adjust the number of free blocks
 	 */
-	blk = old_fs->super->s_blocks_count;
-	if (blk > fs->super->s_blocks_count)
+	blk = ext2_blocks_count(old_fs->super);
+	if (blk > ext2_blocks_count(fs->super))
 		fs->super->s_free_blocks_count -=
-			(blk - fs->super->s_blocks_count);
+			(blk - ext2_blocks_count(fs->super));
 	else
 		fs->super->s_free_blocks_count +=
-			(fs->super->s_blocks_count - blk);
+			(ext2_blocks_count(fs->super) - blk);
 
 	/*
 	 * Adjust the number of reserved blocks
 	 */
 	blk = (__u64)old_fs->super->s_r_blocks_count * 100 /
-		old_fs->super->s_blocks_count;
+		ext2_blocks_count(old_fs->super);
 	fs->super->s_r_blocks_count = e2p_percent(blk, 
-						  fs->super->s_blocks_count);
+						  ext2_blocks_count(fs->super));
 
 	/*
 	 * Adjust the bitmaps for size
@@ -267,7 +267,7 @@ retry:
 	real_end = ((EXT2_BLOCKS_PER_GROUP(fs->super)
 		     * fs->group_desc_count)) - 1 +
 			     fs->super->s_first_data_block;
-	retval = ext2fs_resize_block_bitmap(fs->super->s_blocks_count-1,
+	retval = ext2fs_resize_block_bitmap(ext2_blocks_count(fs->super) - 1,
 					    real_end, fs->block_map);
 
 	if (retval) goto errout;
@@ -324,13 +324,13 @@ retry:
 	/*
 	 * Fix the count of the last (old) block group
 	 */
-	old_numblocks = (old_fs->super->s_blocks_count -
+	old_numblocks = (ext2_blocks_count(old_fs->super) -
 			 old_fs->super->s_first_data_block) %
 				 old_fs->super->s_blocks_per_group;
 	if (!old_numblocks)
 		old_numblocks = old_fs->super->s_blocks_per_group;
 	if (old_fs->group_desc_count == fs->group_desc_count) {
-		numblocks = (fs->super->s_blocks_count -
+		numblocks = (ext2_blocks_count(fs->super) -
 			     fs->super->s_first_data_block) %
 			fs->super->s_blocks_per_group;
 		if (!numblocks)
@@ -370,7 +370,7 @@ retry:
 		adjblocks = 0;
 
 		if (i == fs->group_desc_count-1) {
-			numblocks = (fs->super->s_blocks_count -
+			numblocks = (ext2_blocks_count(fs->super) -
 				     fs->super->s_first_data_block) %
 					     fs->super->s_blocks_per_group;
 			if (!numblocks)
@@ -635,7 +635,7 @@ static errcode_t blocks_to_move(ext2_resize_t rfs)
 
 	fs = rfs->new_fs;
 	old_fs = rfs->old_fs;
-	if (old_fs->super->s_blocks_count > fs->super->s_blocks_count)
+	if (ext2_blocks_count(old_fs->super) > ext2_blocks_count(fs->super))
 		fs = rfs->old_fs;
 	
 	retval = ext2fs_allocate_block_bitmap(fs, _("reserved blocks"),
@@ -663,8 +663,8 @@ static errcode_t blocks_to_move(ext2_resize_t rfs)
 	 * If we're shrinking the filesystem, we need to move all of
 	 * the blocks that don't fit any more
 	 */
-	for (blk = fs->super->s_blocks_count;
-	     blk < old_fs->super->s_blocks_count; blk++) {
+	for (blk = ext2_blocks_count(fs->super);
+	     blk < ext2_blocks_count(old_fs->super); blk++) {
 		if (ext2fs_test_block_bitmap(old_fs->block_map, blk) &&
 		    !ext2fs_test_block_bitmap(meta_bmap, blk)) {
 			ext2fs_mark_block_bitmap(rfs->move_blocks, blk);
@@ -861,9 +861,9 @@ static void init_block_alloc(ext2_resize_t rfs)
 	rfs->new_blk = rfs->new_fs->super->s_first_data_block;
 #if 0
 	/* HACK for testing */
-	if (rfs->new_fs->super->s_blocks_count >
-	    rfs->old_fs->super->s_blocks_count)
-		rfs->new_blk = rfs->old_fs->super->s_blocks_count;
+	if (ext2_blocks_count(rfs->new_fs->super) >
+	    ext2_blocks_count(rfs->old_fs->super))
+		rfs->new_blk = ext2_blocks_count(rfs->old_fs->super);
 #endif
 }
 
@@ -872,7 +872,7 @@ static blk_t get_new_block(ext2_resize_t rfs)
 	ext2_filsys	fs = rfs->new_fs;
 	
 	while (1) {
-		if (rfs->new_blk >= fs->super->s_blocks_count) {
+		if (rfs->new_blk >= ext2_blocks_count(fs->super)) {
 			if (rfs->alloc_state == DESPERATION)
 				return 0;
 
@@ -889,7 +889,7 @@ static blk_t get_new_block(ext2_resize_t rfs)
 		    ext2fs_test_block_bitmap(rfs->reserve_blocks,
 					     rfs->new_blk) ||
 		    ((rfs->alloc_state == AVOID_OLD) &&
-		     (rfs->new_blk < rfs->old_fs->super->s_blocks_count) &&
+		     (rfs->new_blk < ext2_blocks_count(rfs->old_fs->super)) &&
 		     ext2fs_test_block_bitmap(rfs->old_fs->block_map,
 					      rfs->new_blk))) {
 			rfs->new_blk++;
@@ -933,7 +933,7 @@ static errcode_t block_mover(ext2_resize_t rfs)
 	to_move = moved = 0;
 	init_block_alloc(rfs);
 	for (blk = old_fs->super->s_first_data_block;
-	     blk < old_fs->super->s_blocks_count; blk++) {
+	     blk < ext2_blocks_count(old_fs->super); blk++) {
 		if (!ext2fs_test_block_bitmap(old_fs->block_map, blk))
 			continue;
 		if (!ext2fs_test_block_bitmap(rfs->move_blocks, blk))
@@ -1127,10 +1127,10 @@ static errcode_t inode_scan_and_fix(ext2_resize_t rfs)
 	 * is larger.  We need to do this to avoid catching an error
 	 * by the block iterator routines
 	 */
-	orig_size = rfs->old_fs->super->s_blocks_count;
-	if (orig_size < rfs->new_fs->super->s_blocks_count)
-		rfs->old_fs->super->s_blocks_count =
-			rfs->new_fs->super->s_blocks_count;
+	orig_size = ext2_blocks_count(rfs->old_fs->super);
+	if (orig_size < ext2_blocks_count(rfs->new_fs->super))
+		ext2_blocks_count_set(rfs->old_fs->super,
+				ext2_blocks_count(rfs->new_fs->super));
 
 	retval = ext2fs_open_inode_scan(rfs->old_fs, 0, &scan);
 	if (retval) goto errout;
@@ -1239,7 +1239,7 @@ static errcode_t inode_scan_and_fix(ext2_resize_t rfs)
 	io_channel_flush(rfs->old_fs->io);
 
 errout:
-	rfs->old_fs->super->s_blocks_count = orig_size;
+	ext2_blocks_count_set(rfs->old_fs->super, orig_size);
 	if (rfs->bmap) {
 		ext2fs_free_extent_table(rfs->bmap);
 		rfs->bmap = 0;
@@ -1566,14 +1566,14 @@ static errcode_t ext2fs_calculate_summary_stats(ext2_filsys fs)
 	 * First calculate the block statistics
 	 */
 	for (blk = fs->super->s_first_data_block;
-	     blk < fs->super->s_blocks_count; blk++) {
+	     blk < ext2_blocks_count(fs->super); blk++) {
 		if (!ext2fs_fast_test_block_bitmap(fs->block_map, blk)) {
 			group_free++;
 			total_free++;
 		}
 		count++;
 		if ((count == fs->super->s_blocks_per_group) ||
-		    (blk == fs->super->s_blocks_count-1)) {
+		    (blk == ext2_blocks_count(fs->super) - 1)) {
 			fs->group_desc[group++].bg_free_blocks_count =
 				group_free;
 			count = 0;
diff --git a/tests/progs/test_icount.c b/tests/progs/test_icount.c
index 026779f..21efe4f 100644
--- a/tests/progs/test_icount.c
+++ b/tests/progs/test_icount.c
@@ -307,7 +307,7 @@ int main(int argc, char **argv)
 	 * Create a sample filesystem structure
 	 */
 	memset(&param, 0, sizeof(struct ext2_super_block));
-	param.s_blocks_count = 80000;
+	ext2_blocks_count_set(&param, 80000);
 	param.s_inodes_count = 20000;
 	retval = ext2fs_initialize("/dev/null", 0, &param,
 				   unix_io_manager, &test_fs);
