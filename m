From: Valerie Clement <valerie.clement@bull.net>
Subject: [RFC][PATCH 6/11][take 2] handling of 64-bit block counts in e2fsprofs
Date: Thu, 21 Jun 2007 17:25:51 +0200
Message-ID: <467A987F.3050802@bull.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010708000909080208020201"
To: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:37099 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757517AbXFUPzk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Jun 2007 11:55:40 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is a multi-part message in MIME format.
--------------010708000909080208020201
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed

This patch allows to handle 64-bit block counts.
It introduces new macros to access block counts stored in the superblock.

Changes from the previous version:
remove '_EXT4FS_' conditional compilation and use instead INCOMPAT_64BIT 
tests.

  debugfs/debugfs.c          |    4 +-
  debugfs/logdump.c          |    2 -
  debugfs/lsdel.c            |    2 -
  debugfs/set_fields.c       |    3 +
  debugfs/unused.c           |    2 -
  e2fsck/badblocks.c         |    4 +-
  e2fsck/journal.c           |    4 +-
  e2fsck/pass1.c             |   16 ++++----
  e2fsck/pass2.c             |    4 +-
  e2fsck/pass5.c             |   24 ++++++-------
  e2fsck/super.c             |   22 ++++++------
  e2fsck/unix.c              |   10 ++---
  lib/e2p/ls.c               |    8 ++--
  lib/ext2fs/alloc.c         |    6 +--
  lib/ext2fs/alloc_stats.c   |    2 -
  lib/ext2fs/bb_inode.c      |    2 -
  lib/ext2fs/bitmaps.c       |    4 +-
  lib/ext2fs/block.c         |    6 +--
  lib/ext2fs/bmove.c         |    2 -
  lib/ext2fs/closefs.c       |    2 -
  lib/ext2fs/ext2_fs.h       |   36 ++++++++++++++++++++
  lib/ext2fs/ext2fs.h        |    6 +--
  lib/ext2fs/ext_attr.c      |    2 -
  lib/ext2fs/extent.c        |    4 +-
  lib/ext2fs/initialize.c    |   26 +++++++-------
  lib/ext2fs/openfs.c        |    4 +-
  lib/ext2fs/read_bb.c       |    2 -
  lib/ext2fs/read_bb_file.c  |    2 -
  lib/ext2fs/rw_bitmaps.c    |    2 -
  lib/ext2fs/swapfs.c        |    3 +
  lib/ext2fs/tst_badblocks.c |    2 -
  lib/ext2fs/tst_iscan.c     |    2 -
  misc/e2image.c             |    2 -
  misc/mke2fs.c              |   62 ++++++++++++++++++----------------
  misc/tune2fs.c             |   12 +++---
  misc/util.c                |   12 +++---
  resize/main.c              |    2 -
  resize/online.c            |   11 +++---
  resize/resize2fs.c         |   81 
+++++++++++++++++++++++----------------------
  tests/progs/test_icount.c  |    2 -
  40 files changed, 228 insertions(+), 176 deletions(-)




--------------010708000909080208020201
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
 name="06-handle-s_blocks_count_hi-in-superblock"
Content-Disposition: inline;
 filename="06-handle-s_blocks_count_hi-in-superblock"

Index: e2fsprogs-1.39-tyt3-v7/debugfs/debugfs.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/debugfs/debugfs.c	2007-06-21 13:12:03.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/debugfs/debugfs.c	2007-06-21 13:13:05.000000000 +0200
@@ -232,8 +232,8 @@ void do_init_filesys(int argc, char **ar
 		return;
 
 	memset(&param, 0, sizeof(struct ext2_super_block));
-	param.s_blocks_count = parse_ulong(argv[2], argv[0],
-					   "blocks count", &err);
+	EXT2_BLOCKS_COUNT_SET(&param, parse_ulong(argv[2], argv[0],
+					   "blocks count", &err));
 	if (err)
 		return;
 	retval = ext2fs_initialize(argv[1], 0, &param,
Index: e2fsprogs-1.39-tyt3-v7/debugfs/logdump.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/debugfs/logdump.c	2007-06-21 13:12:03.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/debugfs/logdump.c	2007-06-21 13:13:05.000000000 +0200
@@ -366,7 +366,7 @@ static void dump_journal(char *cmdname, 
 			fprintf(out_file, "\tuuid=%s\n", jsb_buffer);
 			fprintf(out_file, "\tblocksize=%d\n", blocksize);
 			fprintf(out_file, "\tjournal data size %lu\n",
-				sb->s_blocks_count);
+				EXT2_BLOCKS_COUNT(sb));
 		}
 	}
 	
Index: e2fsprogs-1.39-tyt3-v7/debugfs/lsdel.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/debugfs/lsdel.c	2007-06-21 13:12:03.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/debugfs/lsdel.c	2007-06-21 13:13:05.000000000 +0200
@@ -57,7 +57,7 @@ static int lsdel_proc(ext2_filsys fs,
 	lsd->num_blocks++;
 
 	if (*block_nr < fs->super->s_first_data_block ||
-	    *block_nr >= fs->super->s_blocks_count) {
+	    *block_nr >= EXT2_BLOCKS_COUNT(fs->super)) {
 		lsd->bad_blocks++;
 		return BLOCK_ABORT;
 	}
Index: e2fsprogs-1.39-tyt3-v7/debugfs/set_fields.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/debugfs/set_fields.c	2007-06-21 13:12:03.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/debugfs/set_fields.c	2007-06-21 13:13:05.000000000 +0200
@@ -57,8 +57,11 @@ static errcode_t parse_bmap(struct field
 static struct field_set_info super_fields[] = {
 	{ "inodes_count", &set_sb.s_inodes_count, 4, parse_uint },
 	{ "blocks_count", &set_sb.s_blocks_count, 4, parse_uint },
+	{ "blocks_count_hi", &set_sb.s_blocks_count_hi, 4, parse_uint },
 	{ "r_blocks_count", &set_sb.s_r_blocks_count, 4, parse_uint },
+	{ "r_blocks_count_hi", &set_sb.s_r_blocks_count_hi, 4, parse_uint },
 	{ "free_blocks_count", &set_sb.s_free_blocks_count, 4, parse_uint },
+	{ "free_blocks_hi", &set_sb.s_free_blocks_hi, 4, parse_uint },
 	{ "free_inodes_count", &set_sb.s_free_inodes_count, 4, parse_uint },
 	{ "first_data_block", &set_sb.s_first_data_block, 4, parse_uint },
 	{ "log_block_size", &set_sb.s_log_block_size, 4, parse_uint },
Index: e2fsprogs-1.39-tyt3-v7/debugfs/unused.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/debugfs/unused.c	2007-06-21 13:12:03.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/debugfs/unused.c	2007-06-21 13:13:05.000000000 +0200
@@ -36,7 +36,7 @@ void do_dump_unused(int argc EXT2FS_ATTR
 		return;
 
 	for (blk=current_fs->super->s_first_data_block;
-	     blk < current_fs->super->s_blocks_count; blk++) {
+	     blk < EXT2_BLOCKS_COUNT(current_fs->super); blk++) {
 		if (ext2fs_test_block_bitmap(current_fs->block_map,blk))
 			continue;
 		retval = io_channel_read_blk(current_fs->io, blk, 1, buf);
Index: e2fsprogs-1.39-tyt3-v7/e2fsck/badblocks.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/e2fsck/badblocks.c	2007-06-21 13:12:03.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/e2fsck/badblocks.c	2007-06-21 13:13:05.000000000 +0200
@@ -75,7 +75,7 @@ void read_bad_blocks_file(e2fsck_t ctx, 
 		sprintf(buf, "badblocks -b %d -X %s%s%s %d", fs->blocksize,
 			(ctx->options & E2F_OPT_PREEN) ? "" : "-s ",
 			(ctx->options & E2F_OPT_WRITECHECK) ? "-n " : "",
-			fs->device_name, fs->super->s_blocks_count-1);
+			fs->device_name, EXT2_BLOCKS_COUNT(fs->super) - 1);
 		f = popen(buf, "r");
 		if (!f) {
 			com_err("read_bad_blocks_file", errno,
@@ -124,7 +124,7 @@ static int check_bb_inode_blocks(ext2_fi
 	/*
 	 * If the block number is outrageous, clear it and ignore it.
 	 */
-	if (*block_nr >= fs->super->s_blocks_count ||
+	if (*block_nr >= EXT2_BLOCKS_COUNT(fs->super)||
 	    *block_nr < fs->super->s_first_data_block) {
 		printf(_("Warning: illegal block %u found in bad block inode.  "
 			 "Cleared.\n"), *block_nr);
Index: e2fsprogs-1.39-tyt3-v7/e2fsck/journal.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/e2fsck/journal.c	2007-06-21 13:12:03.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/e2fsck/journal.c	2007-06-21 13:13:05.000000000 +0200
@@ -280,7 +280,7 @@ static errcode_t e2fsck_get_journal(e2fs
 				continue;
 			}
 			if (blk < sb->s_first_data_block ||
-			    blk >= sb->s_blocks_count) {
+			    blk >= EXT2_BLOCKS_COUNT(sb)) {
 				retval = EXT2_ET_BAD_BLOCK_NUM;
 				goto try_backup_journal;
 			}
@@ -372,7 +372,7 @@ static errcode_t e2fsck_get_journal(e2fs
 			goto errout;
 		}
 
-		journal->j_maxlen = jsuper.s_blocks_count;
+		journal->j_maxlen = EXT2_BLOCKS_COUNT(&jsuper);
 		start++;
 	}
 
Index: e2fsprogs-1.39-tyt3-v7/e2fsck/pass1.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/e2fsck/pass1.c	2007-06-21 13:12:03.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/e2fsck/pass1.c	2007-06-21 13:13:05.000000000 +0200
@@ -182,7 +182,7 @@ int e2fsck_pass1_check_symlink(ext2_fils
 		if ((inode->i_size >= fs->blocksize) ||
 		    (blocks != fs->blocksize >> 9) ||
 		    (inode->i_block[0] < fs->super->s_first_data_block) ||
-		    (inode->i_block[0] >= fs->super->s_blocks_count))
+		    (inode->i_block[0] >= EXT2_BLOCKS_COUNT(fs->super)))
 			return 0;
 
 		for (i = 1; i < EXT2_N_BLOCKS; i++)
@@ -406,7 +406,7 @@ static void check_is_really_dir(e2fsck_t
 			not_device++;
 
 		if (blk < ctx->fs->super->s_first_data_block ||
-		    blk >= ctx->fs->super->s_blocks_count ||
+		    blk >= EXT2_BLOCKS_COUNT(ctx->fs->super) ||
 		    ext2fs_fast_test_block_bitmap(ctx->block_found_map, blk))
 			return;	/* Invalid block, can't be dir */
 	}
@@ -1342,7 +1342,7 @@ static int check_ext_attr(e2fsck_t ctx, 
 	 */
 	if (!(fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_EXT_ATTR) ||
 	    (blk < fs->super->s_first_data_block) ||
-	    (blk >= fs->super->s_blocks_count)) {
+	    (blk >= EXT2_BLOCKS_COUNT(fs->super))) {
 		mark_inode_bad(ctx, ino);
 		return 0;
 	}
@@ -1511,7 +1511,7 @@ static int handle_htree(e2fsck_t ctx, st
 			      block_buf, htree_blk_iter_cb, &blk);
 	if (((blk == 0) ||
 	     (blk < fs->super->s_first_data_block) ||
-	     (blk >= fs->super->s_blocks_count)) &&
+	     (blk >= EXT2_BLOCKS_COUNT(fs->super))) &&
 	    fix_problem(ctx, PR_1_HTREE_BADROOT, pctx))
 		return 1;
 
@@ -1867,8 +1867,8 @@ static char *describe_illegal_block(ext2
 	if (block < super) {
 		sprintf(problem, "< FIRSTBLOCK (%u)", super);
 		return(problem);
-	} else if (block >= fs->super->s_blocks_count) {
-		sprintf(problem, "> BLOCKS (%u)", fs->super->s_blocks_count);
+	} else if (block >= EXT2_BLOCKS_COUNT(fs->super)) {
+		sprintf(problem, "> BLOCKS (%u)", EXT2_BLOCKS_COUNT(fs->super));
 		return(problem);
 	}
 	for (i = 0; i < fs->group_desc_count; i++) {
@@ -1999,7 +1999,7 @@ static int process_block(ext2_filsys fs,
 		problem = PR_1_TOOBIG_SYMLINK;
 	    
 	if (blk < fs->super->s_first_data_block ||
-	    blk >= fs->super->s_blocks_count)
+	    blk >= EXT2_BLOCKS_COUNT(fs->super))
 		problem = PR_1_ILLEGAL_BLOCK_NUM;
 
 	if (!problem && IND_BLKCNT(blockcnt) && p->ino != EXT2_RESIZE_INO) {
@@ -2116,7 +2116,7 @@ static int process_bad_block(ext2_filsys
 	pctx->blkcount = blockcnt;
 
 	if ((blk < fs->super->s_first_data_block) ||
-	    (blk >= fs->super->s_blocks_count)) {
+	    (blk >= EXT2_BLOCKS_COUNT(fs->super))) {
 		if (fix_problem(ctx, PR_1_BB_ILLEGAL_BLOCK_NUM, pctx)) {
 			*block_nr = 0;
 			return BLOCK_CHANGED;
Index: e2fsprogs-1.39-tyt3-v7/e2fsck/pass2.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/e2fsck/pass2.c	2007-06-21 13:12:03.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/e2fsck/pass2.c	2007-06-21 13:13:05.000000000 +0200
@@ -1100,7 +1100,7 @@ static int deallocate_inode_block(ext2_f
 	if (HOLE_BLKADDR(*block_nr))
 		return 0;
 	if ((*block_nr < fs->super->s_first_data_block) ||
-	    (*block_nr >= fs->super->s_blocks_count))
+	    (*block_nr >= EXT2_BLOCKS_COUNT(fs->super)))
 		return 0;
 	ext2fs_unmark_block_bitmap(ctx->block_found_map, *block_nr);
 	ext2fs_block_alloc_stats(fs, *block_nr, -1);
@@ -1300,7 +1300,7 @@ extern int e2fsck_process_bad_inode(e2fs
 
 	if (inode.i_file_acl &&
 	    ((inode.i_file_acl < fs->super->s_first_data_block) ||
-	     (inode.i_file_acl >= fs->super->s_blocks_count))) {
+	     (inode.i_file_acl >= EXT2_BLOCKS_COUNT(fs->super)))) {
 		if (fix_problem(ctx, PR_2_FILE_ACL_BAD, &pctx)) {
 			inode.i_file_acl = 0;
 			inode_modified++;
Index: e2fsprogs-1.39-tyt3-v7/e2fsck/pass5.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/e2fsck/pass5.c	2007-06-21 13:12:03.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/e2fsck/pass5.c	2007-06-21 13:13:05.000000000 +0200
@@ -114,8 +114,8 @@ static void check_block_bitmaps(e2fsck_t
 	blk_t	i, super;
 	int	*free_array;
 	int	group = 0;
-	unsigned int	blocks = 0;
-	unsigned int	free_blocks = 0;
+	blk_t	blocks = 0;
+	blk_t	free_blocks = 0;
 	int	group_free = 0;
 	int	actual, bitmap;
 	struct problem_context	pctx;
@@ -130,11 +130,11 @@ static void check_block_bitmaps(e2fsck_t
 
 	if ((fs->super->s_first_data_block <
 	     ext2fs_get_block_bitmap_start(ctx->block_found_map)) ||
-	    (fs->super->s_blocks_count-1 >
+	    (EXT2_BLOCKS_COUNT(fs->super)-1 >
 	     ext2fs_get_block_bitmap_end(ctx->block_found_map))) {
 		pctx.num = 1;
 		pctx.blk = fs->super->s_first_data_block;
-		pctx.blk2 = fs->super->s_blocks_count -1;
+		pctx.blk2 = EXT2_BLOCKS_COUNT(fs->super) -1;
 		pctx.ino = ext2fs_get_block_bitmap_start(ctx->block_found_map);
 		pctx.ino2 = ext2fs_get_block_bitmap_end(ctx->block_found_map);
 		fix_problem(ctx, PR_5_BMAP_ENDPOINTS, &pctx);
@@ -145,11 +145,11 @@ static void check_block_bitmaps(e2fsck_t
 
 	if ((fs->super->s_first_data_block <
 	     ext2fs_get_block_bitmap_start(fs->block_map)) ||
-	    (fs->super->s_blocks_count-1 >
+	    (EXT2_BLOCKS_COUNT(fs->super)-1 >
 	     ext2fs_get_block_bitmap_end(fs->block_map))) {
 		pctx.num = 2;
 		pctx.blk = fs->super->s_first_data_block;
-		pctx.blk2 = fs->super->s_blocks_count -1;
+		pctx.blk2 = EXT2_BLOCKS_COUNT(fs->super) -1;
 		pctx.ino = ext2fs_get_block_bitmap_start(fs->block_map);
 		pctx.ino2 = ext2fs_get_block_bitmap_end(fs->block_map);
 		fix_problem(ctx, PR_5_BMAP_ENDPOINTS, &pctx);
@@ -170,7 +170,7 @@ redo_counts:
 		skip_group++;
 	super = fs->super->s_first_data_block;
 	for (i = fs->super->s_first_data_block;
-	     i < fs->super->s_blocks_count;
+	     i < EXT2_BLOCKS_COUNT(fs->super);
 	     i++) {
 		actual = ext2fs_fast_test_block_bitmap(ctx->block_found_map, i);
 
@@ -230,7 +230,7 @@ redo_counts:
 		}
 		blocks ++;
 		if ((blocks == fs->super->s_blocks_per_group) ||
-		    (i == fs->super->s_blocks_count-1)) {
+		    (i == EXT2_BLOCKS_COUNT(fs->super)-1)) {
 			free_array[group] = group_free;
 			group ++;
 			blocks = 0;
@@ -242,7 +242,7 @@ redo_counts:
 						    fs->group_desc_count*2))
 					goto errout;
 			if (lazy_bg &&
-			    (i != fs->super->s_blocks_count-1) &&
+			    (i != EXT2_BLOCKS_COUNT(fs->super)-1) &&
 			    (fs->group_desc[group].bg_flags &
 			     EXT2_BG_BLOCK_UNINIT))
 				skip_group++;
@@ -291,13 +291,13 @@ redo_counts:
 				ext2fs_unmark_valid(fs);
 		}
 	}
-	if (free_blocks != fs->super->s_free_blocks_count) {
+	if (free_blocks != EXT2_FREE_BLOCKS_COUNT(fs->super)) {
 		pctx.group = 0;
-		pctx.blk = fs->super->s_free_blocks_count;
+		pctx.blk = EXT2_FREE_BLOCKS_COUNT(fs->super);
 		pctx.blk2 = free_blocks;
 
 		if (fix_problem(ctx, PR_5_FREE_BLOCK_COUNT, &pctx)) {
-			fs->super->s_free_blocks_count = free_blocks;
+			EXT2_FREE_BLOCKS_COUNT_SET(fs->super, free_blocks);
 			ext2fs_mark_super_dirty(fs);
 		} else
 			ext2fs_unmark_valid(fs);
Index: e2fsprogs-1.39-tyt3-v7/e2fsck/super.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/e2fsck/super.c	2007-06-21 13:12:03.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/e2fsck/super.c	2007-06-21 13:13:05.000000000 +0200
@@ -90,7 +90,7 @@ static int release_inode_block(ext2_fils
 		return 0;
 
 	if ((blk < fs->super->s_first_data_block) ||
-	    (blk >= fs->super->s_blocks_count)) {
+	    (blk >= EXT2_BLOCKS_COUNT(fs->super))) {
 		fix_problem(ctx, PR_0_ORPHAN_ILLEGAL_BLOCK_NUM, pctx);
 	return_abort:
 		pb->abort = 1;
@@ -388,7 +388,7 @@ static void check_resize_inode(e2fsck_t 
 	if ((i < EXT2_N_BLOCKS) || !blk || !inode.i_links_count ||
 	    !(inode.i_mode & LINUX_S_IFREG) ||
 	    (blk < fs->super->s_first_data_block ||
-	     blk >= fs->super->s_blocks_count)) {
+	     blk >= EXT2_BLOCKS_COUNT(fs->super))) {
 	resize_inode_invalid:
 		if (fix_problem(ctx, PR_0_RESIZE_INODE_INVALID, &pctx)) {
 			memset(&inode, 0, sizeof(inode));
@@ -505,10 +505,10 @@ void check_super_block(e2fsck_t ctx)
 	 */
 	check_super_value(ctx, "inodes_count", sb->s_inodes_count,
 			  MIN_CHECK, 1, 0);
-	check_super_value(ctx, "blocks_count", sb->s_blocks_count,
+	check_super_value(ctx, "blocks_count", EXT2_BLOCKS_COUNT(sb),
 			  MIN_CHECK, 1, 0);
 	check_super_value(ctx, "first_data_block", sb->s_first_data_block,
-			  MAX_CHECK, 0, sb->s_blocks_count);
+			  MAX_CHECK, 0, EXT2_BLOCKS_COUNT(sb));
 	check_super_value(ctx, "log_block_size", sb->s_log_block_size,
 			  MIN_CHECK | MAX_CHECK, 0,
 			  EXT2_MAX_BLOCK_LOG_SIZE - EXT2_MIN_BLOCK_LOG_SIZE);
@@ -521,8 +521,8 @@ void check_super_block(e2fsck_t ctx)
 			  MIN_CHECK | MAX_CHECK, 8, bpg_max);
 	check_super_value(ctx, "inodes_per_group", sb->s_inodes_per_group,
 			  MIN_CHECK | MAX_CHECK, inodes_per_block, ipg_max);
-	check_super_value(ctx, "r_blocks_count", sb->s_r_blocks_count,
-			  MAX_CHECK, 0, sb->s_blocks_count / 2);
+	check_super_value(ctx, "r_blocks_count", EXT2_R_BLOCKS_COUNT(sb),
+			  MAX_CHECK, 0, EXT2_BLOCKS_COUNT(sb) / 2);
 	check_super_value(ctx, "reserved_gdt_blocks", 
 			  sb->s_reserved_gdt_blocks, MAX_CHECK, 0,
 			  fs->blocksize/4);
@@ -546,8 +546,8 @@ void check_super_block(e2fsck_t ctx)
 			return;
 		}
 		if ((pctx.errcode != EXT2_ET_UNIMPLEMENTED) &&
-		    (ctx->num_blocks < sb->s_blocks_count)) {
-			pctx.blk = sb->s_blocks_count;
+		    (ctx->num_blocks < EXT2_BLOCKS_COUNT(sb))) {
+			pctx.blk = EXT2_BLOCKS_COUNT(sb);
 			pctx.blk2 = ctx->num_blocks;
 			if (fix_problem(ctx, PR_0_FS_SIZE_WRONG, &pctx)) {
 				ctx->flags |= E2F_FLAG_ABORT;
@@ -652,18 +652,18 @@ void check_super_block(e2fsck_t ctx)
 	 * inodes; if the filesystem is not unmounted cleanly, the
 	 * global counts may not be accurate.
 	 */
-	if ((free_blocks != sb->s_free_blocks_count) ||
+	if ((free_blocks != EXT2_FREE_BLOCKS_COUNT(sb)) ||
 	    (free_inodes != sb->s_free_inodes_count)) {
 		if (ctx->options & E2F_OPT_READONLY)
 			ext2fs_unmark_valid(fs);
 		else {
-			sb->s_free_blocks_count = free_blocks;
+			EXT2_FREE_BLOCKS_COUNT_SET(sb, free_blocks);
 			sb->s_free_inodes_count = free_inodes;
 			ext2fs_mark_super_dirty(fs);
 		}
 	}
 	
-	if ((sb->s_free_blocks_count > sb->s_blocks_count) ||
+	if ((EXT2_FREE_BLOCKS_COUNT(sb) > EXT2_BLOCKS_COUNT(sb)) ||
 	    (sb->s_free_inodes_count > sb->s_inodes_count))
 		ext2fs_unmark_valid(fs);
 
Index: e2fsprogs-1.39-tyt3-v7/e2fsck/unix.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/e2fsck/unix.c	2007-06-21 13:12:03.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/e2fsck/unix.c	2007-06-21 13:13:05.000000000 +0200
@@ -110,9 +110,9 @@ static void show_stats(e2fsck_t	ctx)
 	inodes = fs->super->s_inodes_count;
 	inodes_used = (fs->super->s_inodes_count -
 		       fs->super->s_free_inodes_count);
-	blocks = fs->super->s_blocks_count;
-	blocks_used = (fs->super->s_blocks_count -
-		       fs->super->s_free_blocks_count);
+	blocks = EXT2_BLOCKS_COUNT(fs->super);
+	blocks_used = (EXT2_BLOCKS_COUNT(fs->super) -
+		       EXT2_FREE_BLOCKS_COUNT(fs->super));
 
 	frag_percent = (10000 * ctx->fs_fragmented) / inodes_used;
 	frag_percent = (frag_percent + 5) / 10;
@@ -302,8 +302,8 @@ static void check_if_skip(e2fsck_t ctx)
 	printf(_("%s: clean, %u/%u files, %u/%u blocks"), ctx->device_name,
 	       fs->super->s_inodes_count - fs->super->s_free_inodes_count,
 	       fs->super->s_inodes_count,
-	       fs->super->s_blocks_count - fs->super->s_free_blocks_count,
-	       fs->super->s_blocks_count);
+	       EXT2_BLOCKS_COUNT(fs->super) - EXT2_FREE_BLOCKS_COUNT(fs->super),
+	       EXT2_BLOCKS_COUNT(fs->super));
 	next_check = 100000;
 	if (fs->super->s_max_mnt_count > 0) {
 		next_check = fs->super->s_max_mnt_count - fs->super->s_mnt_count;
Index: e2fsprogs-1.39-tyt3-v7/lib/e2p/ls.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/lib/e2p/ls.c	2007-06-21 13:12:03.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/lib/e2p/ls.c	2007-06-21 13:13:05.000000000 +0200
@@ -215,9 +215,11 @@ void list_super2(struct ext2_super_block
 	fprintf(f, "Filesystem OS type:       %s\n", str);
 	free(str);
 	fprintf(f, "Inode count:              %u\n", sb->s_inodes_count);
-	fprintf(f, "Block count:              %u\n", sb->s_blocks_count);
-	fprintf(f, "Reserved block count:     %u\n", sb->s_r_blocks_count);
-	fprintf(f, "Free blocks:              %u\n", sb->s_free_blocks_count);
+	fprintf(f, "Block count:              %u\n", EXT2_BLOCKS_COUNT(sb));
+	fprintf(f, "Reserved block count:     %u\n", 
+		EXT2_R_BLOCKS_COUNT(sb));
+	fprintf(f, "Free blocks:              %u\n", 
+		EXT2_FREE_BLOCKS_COUNT(sb));
 	fprintf(f, "Free inodes:              %u\n", sb->s_free_inodes_count);
 	fprintf(f, "First block:              %u\n", sb->s_first_data_block);
 	fprintf(f, "Block size:               %u\n", EXT2_BLOCK_SIZE(sb));
Index: e2fsprogs-1.39-tyt3-v7/lib/ext2fs/alloc.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/lib/ext2fs/alloc.c	2007-06-21 13:12:03.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/lib/ext2fs/alloc.c	2007-06-21 13:13:05.000000000 +0200
@@ -84,7 +84,7 @@ errcode_t ext2fs_new_block(ext2_filsys f
 		map = fs->block_map;
 	if (!map)
 		return EXT2_ET_NO_BLOCK_BITMAP;
-	if (!goal || (goal >= fs->super->s_blocks_count))
+	if (!goal || (goal >= EXT2_BLOCKS_COUNT(fs->super)))
 		goal = fs->super->s_first_data_block;
 	i = goal;
 	do {
@@ -93,7 +93,7 @@ errcode_t ext2fs_new_block(ext2_filsys f
 			return 0;
 		}
 		i++;
-		if (i >= fs->super->s_blocks_count)
+		if (i >= EXT2_BLOCKS_COUNT(fs->super))
 			i = fs->super->s_first_data_block;
 	} while (i != goal);
 	return EXT2_ET_BLOCK_ALLOC_FAIL;
@@ -160,7 +160,7 @@ errcode_t ext2fs_get_free_blocks(ext2_fi
 	if (!num)
 		num = 1;
 	do {
-		if (b+num-1 > fs->super->s_blocks_count)
+		if (b+num-1 > EXT2_BLOCKS_COUNT(fs->super))
 			b = fs->super->s_first_data_block;
 		if (ext2fs_fast_test_block_bitmap_range(map, b, num)) {
 			*ret = b;
Index: e2fsprogs-1.39-tyt3-v7/lib/ext2fs/alloc_stats.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/lib/ext2fs/alloc_stats.c	2007-06-21 13:12:03.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/lib/ext2fs/alloc_stats.c	2007-06-21 13:13:05.000000000 +0200
@@ -46,7 +46,7 @@ void ext2fs_block_alloc_stats(ext2_filsy
 	else
 		ext2fs_unmark_block_bitmap(fs->block_map, blk);
 	fs->group_desc[group].bg_free_blocks_count -= inuse;
-	fs->super->s_free_blocks_count -= inuse;
+	EXT2_FREE_BLOCKS_COUNT_SET(fs->super, EXT2_FREE_BLOCKS_COUNT(fs->super) - inuse);
 	ext2fs_mark_super_dirty(fs);
 	ext2fs_mark_bb_dirty(fs);
 }
Index: e2fsprogs-1.39-tyt3-v7/lib/ext2fs/bb_inode.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/lib/ext2fs/bb_inode.c	2007-06-21 13:12:03.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/lib/ext2fs/bb_inode.c	2007-06-21 13:13:05.000000000 +0200
@@ -166,7 +166,7 @@ static int clear_bad_block_proc(ext2_fil
 	/*
 	 * If the block number is outrageous, clear it and ignore it.
 	 */
-	if (*block_nr >= fs->super->s_blocks_count ||
+	if (*block_nr >= EXT2_BLOCKS_COUNT(fs->super) ||
 	    *block_nr < fs->super->s_first_data_block) {
 		*block_nr = 0;
 		return BLOCK_CHANGED;
Index: e2fsprogs-1.39-tyt3-v7/lib/ext2fs/bitmaps.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/lib/ext2fs/bitmaps.c	2007-06-21 13:13:03.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/lib/ext2fs/bitmaps.c	2007-06-21 13:13:05.000000000 +0200
@@ -137,7 +137,7 @@ errcode_t ext2fs_allocate_block_bitmap(e
 	fs->write_bitmaps = ext2fs_write_bitmaps;
 
 	start = fs->super->s_first_data_block;
-	end = fs->super->s_blocks_count-1;
+	end = EXT2_BLOCKS_COUNT(fs->super) - 1;
 	real_end = (EXT2_BLOCKS_PER_GROUP(fs->super)  
 		    * fs->group_desc_count)-1 + start;
 	
@@ -263,7 +263,7 @@ errcode_t ext2fs_allocate_block_bitmap(e
 	fs->write_bitmaps = ext2fs_write_bitmaps;
 
 	start = fs->super->s_first_data_block;
-	end = fs->super->s_blocks_count-1;
+	end = EXT2_BLOCKS_COUNT(fs->super) - 1;
 	real_end = ((blk64_t) EXT2_BLOCKS_PER_GROUP(fs->super)  
 		    * fs->group_desc_count)-1 + start;
 	
Index: e2fsprogs-1.39-tyt3-v7/lib/ext2fs/block.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/lib/ext2fs/block.c	2007-06-21 13:12:03.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/lib/ext2fs/block.c	2007-06-21 13:13:05.000000000 +0200
@@ -317,7 +317,7 @@ static int block_iterate_ind(blk_t *ind_
 		ctx->bcount += limit;
 		return ret;
 	}
-	if (*ind_block >= ctx->fs->super->s_blocks_count ||
+	if (*ind_block >= EXT2_BLOCKS_COUNT(ctx->fs->super) ||
 	    *ind_block < ctx->fs->super->s_first_data_block) {
 		ctx->errcode = EXT2_ET_BAD_IND_BLOCK;
 		ret |= BLOCK_ERROR;
@@ -391,7 +391,7 @@ static int block_iterate_dind(blk_t *din
 		ctx->bcount += limit*limit;
 		return ret;
 	}
-	if (*dind_block >= ctx->fs->super->s_blocks_count ||
+	if (*dind_block >= EXT2_BLOCKS_COUNT(ctx->fs->super) ||
 	    *dind_block < ctx->fs->super->s_first_data_block) {
 		ctx->errcode = EXT2_ET_BAD_DIND_BLOCK;
 		ret |= BLOCK_ERROR;
@@ -467,7 +467,7 @@ static int block_iterate_tind(blk_t *tin
 		ctx->bcount += limit*limit*limit;
 		return ret;
 	}
-	if (*tind_block >= ctx->fs->super->s_blocks_count ||
+	if (*tind_block >= EXT2_BLOCKS_COUNT(ctx->fs->super) ||
 	    *tind_block < ctx->fs->super->s_first_data_block) {
 		ctx->errcode = EXT2_ET_BAD_TIND_BLOCK;
 		ret |= BLOCK_ERROR;
Index: e2fsprogs-1.39-tyt3-v7/lib/ext2fs/bmove.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/lib/ext2fs/bmove.c	2007-06-21 13:12:03.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/lib/ext2fs/bmove.c	2007-06-21 13:13:05.000000000 +0200
@@ -50,7 +50,7 @@ static int process_block(ext2_filsys fs,
 	 */
 	if (ext2fs_test_block_bitmap(pb->reserve, block)) {
 		do {
-			if (++block >= fs->super->s_blocks_count)
+			if (++block >= EXT2_BLOCKS_COUNT(fs->super))
 				block = fs->super->s_first_data_block;
 			if (block == orig) {
 				pb->error = EXT2_ET_BLOCK_ALLOC_FAIL;
Index: e2fsprogs-1.39-tyt3-v7/lib/ext2fs/closefs.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/lib/ext2fs/closefs.c	2007-06-21 13:12:03.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/lib/ext2fs/closefs.c	2007-06-21 13:13:05.000000000 +0200
@@ -66,7 +66,7 @@ int ext2fs_super_and_bgd_loc(ext2_filsys
 			fs->desc_blocks + fs->super->s_reserved_gdt_blocks;
 
 	if (group == fs->group_desc_count-1) {
-		numblocks = (fs->super->s_blocks_count -
+		numblocks = (EXT2_BLOCKS_COUNT(fs->super) -
 			     fs->super->s_first_data_block) %
 			fs->super->s_blocks_per_group;
 		if (!numblocks)
Index: e2fsprogs-1.39-tyt3-v7/lib/ext2fs/ext2_fs.h
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/lib/ext2fs/ext2_fs.h	2007-06-21 13:12:03.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/lib/ext2fs/ext2_fs.h	2007-06-21 13:13:05.000000000 +0200
@@ -580,6 +580,42 @@ struct ext2_super_block {
 	__u32	s_reserved[167];	/* Padding to the end of the block */
 };
 
+#define EXT2_BLOCKS_COUNT(s)						   \
+	((s)->s_blocks_count +						   \
+		((s)->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT ?   \
+		 (__u64)(s)->s_blocks_count_hi << 32 : 0))
+
+#define EXT2_BLOCKS_COUNT_SET(s, v)					   \
+	do {								   \
+		(s)->s_blocks_count = (v);				   \
+		if ((s)->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT) \
+			(s)->s_blocks_count_hi = (__u64)(v) >> 32;	   \
+	} while (0)
+
+#define EXT2_R_BLOCKS_COUNT(s)						   \
+	((s)->s_r_blocks_count +					   \
+		((s)->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT ?   \
+		(__u64)(s)->s_r_blocks_count_hi << 32 : 0))
+
+#define EXT2_R_BLOCKS_COUNT_SET(s, v)					   \
+	do {								   \
+		(s)->s_r_blocks_count = (v);				   \
+		if ((s)->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT) \
+			(s)->s_r_blocks_count_hi = (__u64)(v) >> 32;	   \
+	} while (0)
+
+#define EXT2_FREE_BLOCKS_COUNT(s)					   \
+	((s)->s_free_blocks_count +					   \
+		((s)->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT ?   \
+		(__u64)(s)->s_free_blocks_hi << 32 : 0))
+
+#define EXT2_FREE_BLOCKS_COUNT_SET(s, v)				   \
+	do {								   \
+		(s)->s_free_blocks_count = (v);				   \
+		if ((s)->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT) \
+			(s)->s_free_blocks_hi = (__u64)(v) >> 32;	   \
+	} while (0)
+
 /*
  * Codes for operating systems
  */
Index: e2fsprogs-1.39-tyt3-v7/lib/ext2fs/ext2fs.h
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/lib/ext2fs/ext2fs.h	2007-06-21 13:13:03.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/lib/ext2fs/ext2fs.h	2007-06-21 13:13:05.000000000 +0200
@@ -1083,7 +1083,7 @@ extern blk_t ext2fs_group_first_block(ex
 extern blk_t ext2fs_group_last_block(ext2_filsys fs, dgrp_t group);
 extern blk_t ext2fs_inode_data_blocks(ext2_filsys fs,
 				      struct ext2_inode *inode);
-extern unsigned int ext2fs_div_ceil(unsigned int a, unsigned int b);
+extern unsigned long ext2fs_div_ceil(unsigned long a, unsigned long b);
 
 /*
  * The actual inlined functions definitions themselves...
@@ -1263,7 +1263,7 @@ _INLINE_ blk_t ext2fs_group_first_block(
 _INLINE_ blk_t ext2fs_group_last_block(ext2_filsys fs, dgrp_t group)
 {
 	return (group == fs->group_desc_count - 1 ?
-		fs->super->s_blocks_count - 1 :
+		EXT2_BLOCKS_COUNT(fs->super) - 1 :
 		ext2fs_group_first_block(fs, group) +
 			(fs->super->s_blocks_per_group - 1));
 }
@@ -1278,7 +1278,7 @@ _INLINE_ blk_t ext2fs_inode_data_blocks(
 /*
  * This is an efficient, overflow safe way of calculating ceil((1.0 * a) / b)
  */
-_INLINE_ unsigned int ext2fs_div_ceil(unsigned int a, unsigned int b)
+_INLINE_ unsigned long ext2fs_div_ceil(unsigned long a, unsigned long b)
 {
 	if (!a)
 		return 0;
Index: e2fsprogs-1.39-tyt3-v7/lib/ext2fs/ext_attr.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/lib/ext2fs/ext_attr.c	2007-06-21 13:12:03.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/lib/ext2fs/ext_attr.c	2007-06-21 13:13:05.000000000 +0200
@@ -74,7 +74,7 @@ errcode_t ext2fs_adjust_ea_refcount(ext2
 	struct ext2_ext_attr_header *header;
 	char	*buf = 0;
 
-	if ((blk >= fs->super->s_blocks_count) ||
+	if ((blk >= EXT2_BLOCKS_COUNT(fs->super)) ||
 	    (blk < fs->super->s_first_data_block))
 		return EXT2_ET_BAD_EA_BLOCK_NUM;
 
Index: e2fsprogs-1.39-tyt3-v7/lib/ext2fs/initialize.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/lib/ext2fs/initialize.c	2007-06-21 13:12:03.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/lib/ext2fs/initialize.c	2007-06-21 13:13:05.000000000 +0200
@@ -75,8 +75,8 @@ static unsigned int calc_reserved_gdt_bl
 	/* We set it at 1024x the current filesystem size, or
 	 * the upper block count limit (2^32), whichever is lower.
 	 */
-	if (sb->s_blocks_count < max_blocks / 1024)
-		max_blocks = sb->s_blocks_count * 1024;
+	if (EXT2_BLOCKS_COUNT(sb) < max_blocks / 1024)
+		max_blocks = EXT2_BLOCKS_COUNT(sb) * 1024;
 	rsv_groups = ext2fs_div_ceil(max_blocks - sb->s_first_data_block, bpg);
 	rsv_gdb = ext2fs_div_ceil(rsv_groups, gdpb) - fs->desc_blocks;
 	if (rsv_gdb > EXT2_ADDR_PER_BLOCK(sb))
@@ -107,7 +107,7 @@ errcode_t ext2fs_initialize(const char *
 	char		*buf;
 	char		c;
 
-	if (!param || !param->s_blocks_count)
+	if (!param || !EXT2_BLOCKS_COUNT(param))
 		return EXT2_ET_INVALID_ARGUMENT;
 	
 	retval = ext2fs_get_mem(sizeof(struct struct_ext2_filsys), &fs);
@@ -187,9 +187,9 @@ errcode_t ext2fs_initialize(const char *
 		super->s_blocks_per_group = EXT2_MAX_BLOCKS_PER_GROUP(super);
 	super->s_frags_per_group = super->s_blocks_per_group * frags_per_block;
 	
-	super->s_blocks_count = param->s_blocks_count;
-	super->s_r_blocks_count = param->s_r_blocks_count;
-	if (super->s_r_blocks_count >= param->s_blocks_count) {
+	EXT2_BLOCKS_COUNT_SET(super, EXT2_BLOCKS_COUNT(param));
+	EXT2_R_BLOCKS_COUNT_SET(super, EXT2_R_BLOCKS_COUNT(param));
+	if (EXT2_R_BLOCKS_COUNT(super) >= EXT2_BLOCKS_COUNT(param)) {
 		retval = EXT2_ET_INVALID_ARGUMENT;
 		goto cleanup;
 	}
@@ -206,7 +206,7 @@ errcode_t ext2fs_initialize(const char *
 	}
 
 retry:
-	fs->group_desc_count = ext2fs_div_ceil(super->s_blocks_count -
+	fs->group_desc_count = ext2fs_div_ceil(EXT2_BLOCKS_COUNT(super) -
 					       super->s_first_data_block,
 					       EXT2_BLOCKS_PER_GROUP(super));
 	if (fs->group_desc_count == 0) {
@@ -217,7 +217,7 @@ retry:
 					  EXT2_DESC_PER_BLOCK(super));
 
 	i = fs->blocksize >= 4096 ? 1 : 4096 / fs->blocksize;
-	set_field(s_inodes_count, super->s_blocks_count / i);
+	set_field(s_inodes_count, EXT2_BLOCKS_COUNT(super) / i);
 
 	/*
 	 * Make sure we have at least EXT2_FIRST_INO + 1 inodes, so
@@ -237,7 +237,7 @@ retry:
 		if (super->s_blocks_per_group >= 256) {
 			/* Try again with slightly different parameters */
 			super->s_blocks_per_group -= 8;
-			super->s_blocks_count = param->s_blocks_count;
+			EXT2_BLOCKS_COUNT_SET(super, EXT2_BLOCKS_COUNT(param));
 			super->s_frags_per_group = super->s_blocks_per_group *
 				frags_per_block;
 			goto retry;
@@ -319,12 +319,12 @@ ipg_retry:
 	 * necessary data structures.  If not, we need to get rid of
 	 * it.
 	 */
-	rem = ((super->s_blocks_count - super->s_first_data_block) %
+	rem = ((EXT2_BLOCKS_COUNT(super) - super->s_first_data_block) %
 	       super->s_blocks_per_group);
 	if ((fs->group_desc_count == 1) && rem && (rem < overhead))
 		return EXT2_ET_TOOSMALL;
 	if (rem && (rem < overhead+50)) {
-		super->s_blocks_count -= rem;
+		EXT2_BLOCKS_COUNT_SET(super, EXT2_BLOCKS_COUNT(super) - rem);
 		goto retry;
 	}
 
@@ -364,11 +364,11 @@ ipg_retry:
 	 * inode table have not been allocated (and in fact won't be
 	 * by this routine), they are accounted for nevertheless.
 	 */
-	super->s_free_blocks_count = 0;
+	EXT2_FREE_BLOCKS_COUNT_SET(super, 0ULL);
 	for (i = 0; i < fs->group_desc_count; i++) {
 		numblocks = ext2fs_reserve_super_and_bgd(fs, i, fs->block_map);
 
-		super->s_free_blocks_count += numblocks;
+		EXT2_FREE_BLOCKS_COUNT_SET(super, EXT2_FREE_BLOCKS_COUNT(super) + numblocks);
 		fs->group_desc[i].bg_free_blocks_count = numblocks;
 		fs->group_desc[i].bg_free_inodes_count =
 			fs->super->s_inodes_per_group;
Index: e2fsprogs-1.39-tyt3-v7/lib/ext2fs/openfs.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/lib/ext2fs/openfs.c	2007-06-21 13:12:03.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/lib/ext2fs/openfs.c	2007-06-21 13:13:05.000000000 +0200
@@ -53,7 +53,7 @@ blk_t ext2fs_descriptor_block_loc(ext2_f
 	 */
 	if (group_block != fs->super->s_first_data_block &&
 	    ((ret_blk + fs->super->s_blocks_per_group) <
-	     fs->super->s_blocks_count))
+	     EXT2_BLOCKS_COUNT(fs->super)))
 		ret_blk += fs->super->s_blocks_per_group;
 	return ret_blk;
 }
@@ -268,7 +268,7 @@ errcode_t ext2fs_open2(const char *name,
 		retval = EXT2_ET_CORRUPT_SUPERBLOCK;
 		goto cleanup;
 	}
-	fs->group_desc_count = ext2fs_div_ceil(fs->super->s_blocks_count -
+	fs->group_desc_count = ext2fs_div_ceil(EXT2_BLOCKS_COUNT(fs->super) -
 					       fs->super->s_first_data_block,
 					       blocks_per_group);
 	fs->desc_blocks = ext2fs_div_ceil(fs->group_desc_count,
Index: e2fsprogs-1.39-tyt3-v7/lib/ext2fs/read_bb.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/lib/ext2fs/read_bb.c	2007-06-21 13:12:03.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/lib/ext2fs/read_bb.c	2007-06-21 13:13:05.000000000 +0200
@@ -49,7 +49,7 @@ static int mark_bad_block(ext2_filsys fs
 		return 0;
 	
 	if ((*block_nr < fs->super->s_first_data_block) ||
-	    (*block_nr >= fs->super->s_blocks_count))
+	    (*block_nr >= EXT2_BLOCKS_COUNT(fs->super)))
 		return 0;	/* Ignore illegal blocks */
 
 	rb->err = ext2fs_badblocks_list_add(rb->bb_list, *block_nr);
Index: e2fsprogs-1.39-tyt3-v7/lib/ext2fs/read_bb_file.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/lib/ext2fs/read_bb_file.c	2007-06-21 13:12:03.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/lib/ext2fs/read_bb_file.c	2007-06-21 13:13:05.000000000 +0200
@@ -59,7 +59,7 @@ errcode_t ext2fs_read_bb_FILE2(ext2_fils
 			continue;
 		if (fs &&
 		    ((blockno < fs->super->s_first_data_block) ||
-		    (blockno >= fs->super->s_blocks_count))) {
+		    (blockno >= EXT2_BLOCKS_COUNT(fs->super)))) {
 			if (invalid)
 				(invalid)(fs, blockno, buf, priv_data);
 			continue;
Index: e2fsprogs-1.39-tyt3-v7/lib/ext2fs/rw_bitmaps.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/lib/ext2fs/rw_bitmaps.c	2007-06-21 13:12:03.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/lib/ext2fs/rw_bitmaps.c	2007-06-21 13:13:05.000000000 +0200
@@ -101,7 +101,7 @@ static errcode_t write_bitmaps(ext2_fils
 		memcpy(block_buf, block_bitmap, block_nbytes);
 		if (i == fs->group_desc_count - 1) {
 			/* Force bitmap padding for the last group */
-			nbits = ((fs->super->s_blocks_count
+			nbits = ((EXT2_BLOCKS_COUNT(fs->super)
 				  - fs->super->s_first_data_block)
 				 % EXT2_BLOCKS_PER_GROUP(fs->super));
 			if (nbits)
Index: e2fsprogs-1.39-tyt3-v7/lib/ext2fs/swapfs.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/lib/ext2fs/swapfs.c	2007-06-21 13:12:03.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/lib/ext2fs/swapfs.c	2007-06-21 13:13:05.000000000 +0200
@@ -26,8 +26,11 @@ void ext2fs_swap_super(struct ext2_super
   	int i;
 	sb->s_inodes_count = ext2fs_swab32(sb->s_inodes_count);
 	sb->s_blocks_count = ext2fs_swab32(sb->s_blocks_count);
+	sb->s_blocks_count_hi = ext2fs_swab32(sb->s_blocks_count_hi);
 	sb->s_r_blocks_count = ext2fs_swab32(sb->s_r_blocks_count);
+	sb->s_r_blocks_count_hi = ext2fs_swab32(sb->s_r_blocks_count_hi);
 	sb->s_free_blocks_count = ext2fs_swab32(sb->s_free_blocks_count);
+	sb->s_free_blocks_hi = ext2fs_swab32(sb->s_free_blocks_hi);
 	sb->s_free_inodes_count = ext2fs_swab32(sb->s_free_inodes_count);
 	sb->s_first_data_block = ext2fs_swab32(sb->s_first_data_block);
 	sb->s_log_block_size = ext2fs_swab32(sb->s_log_block_size);
Index: e2fsprogs-1.39-tyt3-v7/lib/ext2fs/tst_badblocks.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/lib/ext2fs/tst_badblocks.c	2007-06-21 13:12:03.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/lib/ext2fs/tst_badblocks.c	2007-06-21 13:13:05.000000000 +0200
@@ -227,7 +227,7 @@ int file_test_invalid(badblocks_list bb)
 	fs->super = malloc(SUPERBLOCK_SIZE);
 	memset(fs->super, 0, SUPERBLOCK_SIZE);
 	fs->super->s_first_data_block = 1;
-	fs->super->s_blocks_count = 100;
+	EXT2_BLOCKS_COUNT_SET(fs->super, 100);
 
 	f = tmpfile();
 	if (!f) {
Index: e2fsprogs-1.39-tyt3-v7/lib/ext2fs/tst_iscan.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/lib/ext2fs/tst_iscan.c	2007-06-21 13:12:03.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/lib/ext2fs/tst_iscan.c	2007-06-21 13:13:05.000000000 +0200
@@ -71,7 +71,7 @@ static void setup(void)
 	initialize_ext2_error_table();
 
 	memset(&param, 0, sizeof(param));
-	param.s_blocks_count = 12000;
+	EXT2_BLOCKS_COUNT_SET(&param, 12000);
 
 
 	test_io_cb_read_blk = test_read_blk;
Index: e2fsprogs-1.39-tyt3-v7/misc/e2image.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/misc/e2image.c	2007-06-21 13:12:03.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/misc/e2image.c	2007-06-21 13:13:05.000000000 +0200
@@ -411,7 +411,7 @@ static void output_meta_data_blocks(ext2
 		exit(1);
 	}
 	memset(zero_buf, 0, fs->blocksize);
-	for (blk = 0; blk < fs->super->s_blocks_count; blk++) {
+	for (blk = 0; blk < EXT2_BLOCKS_COUNT(fs->super); blk++) {
 		if ((blk >= fs->super->s_first_data_block) &&
 		    ext2fs_test_block_bitmap(meta_block_map, blk)) {
 			retval = io_channel_read_blk(fs->io, blk, 1, buf);
Index: e2fsprogs-1.39-tyt3-v7/misc/mke2fs.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/misc/mke2fs.c	2007-06-21 13:12:03.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/misc/mke2fs.c	2007-06-21 13:13:05.000000000 +0200
@@ -192,7 +192,7 @@ static void test_disk(ext2_filsys fs, ba
 
 	sprintf(buf, "badblocks -b %d -X %s%s%s %u", fs->blocksize,
 		quiet ? "" : "-s ", (cflag > 1) ? "-w " : "",
-		fs->device_name, fs->super->s_blocks_count-1);
+		fs->device_name, EXT2_BLOCKS_COUNT(fs->super) - 1);
 	if (verbose)
 		printf(_("Running command: %s\n"), buf);
 	f = popen(buf, "r");
@@ -263,7 +263,7 @@ _("Warning: the backup superblock/group 
 				group_bad++;
 				group = ext2fs_group_of_blk(fs, group_block+j);
 				fs->group_desc[group].bg_free_blocks_count++;
-				fs->super->s_free_blocks_count++;
+				EXT2_FREE_BLOCKS_COUNT_SET(fs->super, EXT2_FREE_BLOCKS_COUNT(fs->super) + 1);
 			}
 		}
 		group_block += fs->super->s_blocks_per_group;
@@ -468,7 +468,8 @@ static void setup_lazy_bg(ext2_filsys fs
 			if (bg->bg_free_blocks_count == blks) {
 				bg->bg_free_blocks_count = 0;
 				bg->bg_flags |= EXT2_BG_BLOCK_UNINIT;
-				sb->s_free_blocks_count -= blks;
+				EXT2_FREE_BLOCKS_COUNT_SET(sb, 
+						EXT2_FREE_BLOCKS_COUNT(sb) - blks);
 			}
 		}
 	}
@@ -620,7 +621,7 @@ static void create_journal_dev(ext2_fils
 	int			count;
 
 	retval = ext2fs_create_journal_superblock(fs,
-				  fs->super->s_blocks_count, 0, &buf);
+				  EXT2_BLOCKS_COUNT(fs->super), 0, &buf);
 	if (retval) {
 		com_err("create_journal_dev", retval,
 			_("while initializing journal superblock"));
@@ -630,9 +631,9 @@ static void create_journal_dev(ext2_fils
 		memset(&progress, 0, sizeof(progress));
 	else
 		progress_init(&progress, _("Zeroing journal device: "),
-			      fs->super->s_blocks_count);
+			      EXT2_BLOCKS_COUNT(fs->super));
 
-	retval = zero_blocks(fs, 0, fs->super->s_blocks_count,
+	retval = zero_blocks(fs, 0, EXT2_BLOCKS_COUNT(fs->super),
 			     &progress, &blk, &count);
 	if (retval) {
 		com_err("create_journal_dev", retval,
@@ -662,9 +663,9 @@ static void show_stats(ext2_filsys fs)
 	dgrp_t			i;
 	int			need, col_left;
 	
-	if (fs_param.s_blocks_count != s->s_blocks_count)
+	if (EXT2_BLOCKS_COUNT(&fs_param) != EXT2_BLOCKS_COUNT(s))
 		fprintf(stderr, _("warning: %u blocks unused.\n\n"),
-		       fs_param.s_blocks_count - s->s_blocks_count);
+		       EXT2_BLOCKS_COUNT(&fs_param) - EXT2_BLOCKS_COUNT(s));
 
 	memset(buf, 0, sizeof(buf));
 	strncpy(buf, s->s_volume_name, sizeof(s->s_volume_name));
@@ -679,10 +680,10 @@ static void show_stats(ext2_filsys fs)
 	printf(_("Fragment size=%u (log=%u)\n"), fs->fragsize,
 		s->s_log_frag_size);
 	printf(_("%u inodes, %u blocks\n"), s->s_inodes_count,
-	       s->s_blocks_count);
+	        EXT2_BLOCKS_COUNT(s));
 	printf(_("%u blocks (%2.2f%%) reserved for the super user\n"),
-		s->s_r_blocks_count,
-	       100.0 * s->s_r_blocks_count / s->s_blocks_count);
+		 EXT2_R_BLOCKS_COUNT(s),
+	       100.0 *  EXT2_R_BLOCKS_COUNT(s) / EXT2_BLOCKS_COUNT(s));
 	printf(_("First data block=%u\n"), s->s_first_data_block);
 	if (s->s_reserved_gdt_blocks)
 		printf(_("Maximum filesystem blocks=%lu\n"),
@@ -807,7 +808,7 @@ static void parse_extended_opts(struct e
 				r_usage++;
 				continue;
 			}
-			if (resize <= param->s_blocks_count) {
+			if (resize <= EXT2_BLOCKS_COUNT(param)) {
 				fprintf(stderr, 
 					_("The resize maximum must be greater "
 					  "than the filesystem size.\n"));
@@ -821,7 +822,7 @@ static void parse_extended_opts(struct e
 				bpg = blocksize * 8;
 			gdpb = EXT2_DESC_PER_BLOCK(param);
 			group_desc_count = 
-				ext2fs_div_ceil(param->s_blocks_count, bpg);
+				ext2fs_div_ceil(EXT2_BLOCKS_COUNT(param), bpg);
 			desc_blocks = (group_desc_count +
 				       gdpb - 1) / gdpb;
 			rsv_groups = ext2fs_div_ceil(resize, bpg);
@@ -1205,9 +1206,10 @@ static void PRS(int argc, char *argv[])
 			blocksize, sys_page_size);
 	}
 	if (optind < argc) {
-		fs_param.s_blocks_count = parse_num_blocks(argv[optind++], 
-				fs_param.s_log_block_size);
-		if (!fs_param.s_blocks_count) {
+		EXT2_BLOCKS_COUNT_SET(&fs_param,
+				parse_num_blocks(argv[optind++], 
+				fs_param.s_log_block_size));
+		if (!EXT2_BLOCKS_COUNT(&fs_param)) {
 			com_err(program_name, 0, _("invalid blocks count - %s"),
 				argv[optind - 1]);
 			exit(1);
@@ -1222,8 +1224,8 @@ static void PRS(int argc, char *argv[])
 
 	fs_param.s_log_frag_size = fs_param.s_log_block_size;
 
-	if (noaction && fs_param.s_blocks_count) {
-		dev_size = fs_param.s_blocks_count;
+	if (noaction && (EXT2_BLOCKS_COUNT(&fs_param))) {
+		dev_size = EXT2_BLOCKS_COUNT(&fs_param);
 		retval = 0;
 	} else {
 	retry:
@@ -1244,7 +1246,7 @@ static void PRS(int argc, char *argv[])
 			_("while trying to determine filesystem size"));
 		exit(1);
 	}
-	if (!fs_param.s_blocks_count) {
+	if (!EXT2_BLOCKS_COUNT(&fs_param)) {
 		if (retval == EXT2_ET_UNIMPLEMENTED) {
 			com_err(program_name, 0,
 				_("Couldn't determine device size; you "
@@ -1264,20 +1266,20 @@ static void PRS(int argc, char *argv[])
 				  ));
 				exit(1);
 			}
-			fs_param.s_blocks_count = dev_size;
+			EXT2_BLOCKS_COUNT_SET(&fs_param, dev_size);
 			if (sys_page_size > EXT2_BLOCK_SIZE(&fs_param))
 				fs_param.s_blocks_count &= ~((sys_page_size /
 					   EXT2_BLOCK_SIZE(&fs_param))-1);
 		}
 		
-	} else if (!force && (fs_param.s_blocks_count > dev_size)) {
+	} else if (!force && (EXT2_BLOCKS_COUNT(&fs_param) > dev_size)) {
 		com_err(program_name, 0,
 			_("Filesystem larger than apparent device size."));
 		proceed_question();
 	}
 
 	if (!fs_type) {
-		int megs = (__u64)fs_param.s_blocks_count *
+		int megs = EXT2_BLOCKS_COUNT(&fs_param) *
 			(EXT2_BLOCK_SIZE(&fs_param) / 1024) / 1024;
 
 		if (fs_param.s_feature_incompat & 
@@ -1388,7 +1390,8 @@ static void PRS(int argc, char *argv[])
 		if ((blocksize < 0) && (use_bsize < (-blocksize)))
 			use_bsize = -blocksize;
 		blocksize = use_bsize;
-		fs_param.s_blocks_count /= blocksize / 1024;
+		EXT2_BLOCKS_COUNT_SET(&fs_param,
+			EXT2_BLOCKS_COUNT(&fs_param) / (blocksize / 1024));
 	}
 
 	if (inode_ratio == 0) {
@@ -1435,7 +1438,7 @@ static void PRS(int argc, char *argv[])
 		fs_param.s_desc_size = EXT2_MIN_DESC_SIZE_64BIT;
 	}
 
-	if (!force && fs_param.s_blocks_count >= ((unsigned) 1 << 31)) {
+	if (!force && EXT2_BLOCKS_COUNT(&fs_param) >= ((unsigned) 1 << 31)) {
 		com_err(program_name, 0,
 			_("Filesystem too large.  No more than 2**31-1 blocks\n"
 			  "\t (8TB using a blocksize of 4k) are currently supported."));
@@ -1476,7 +1479,7 @@ static void PRS(int argc, char *argv[])
 	/* Make sure number of inodes specified will fit in 32 bits */
 	if (num_inodes == 0) {
 		__u64 n;
-		n = (__u64) fs_param.s_blocks_count * blocksize / inode_ratio;
+		n = EXT2_BLOCKS_COUNT(&fs_param) * blocksize / inode_ratio;
 		if (n > ~0U) {
 			com_err(program_name, 0,
 			    _("too many inodes (%llu), raise inode ratio?"), n);
@@ -1492,14 +1495,15 @@ static void PRS(int argc, char *argv[])
 	 * Calculate number of inodes based on the inode ratio
 	 */
 	fs_param.s_inodes_count = num_inodes ? num_inodes : 
-		((__u64) fs_param.s_blocks_count * blocksize)
+		((__u64) EXT2_BLOCKS_COUNT(&fs_param) * blocksize)
 			/ inode_ratio;
 
 	/*
 	 * Calculate number of blocks to reserve
 	 */
-	fs_param.s_r_blocks_count = e2p_percent(reserved_ratio, 
-						fs_param.s_blocks_count);
+	EXT2_R_BLOCKS_COUNT_SET(
+		&fs_param, e2p_percent(
+			reserved_ratio, EXT2_BLOCKS_COUNT(&fs_param)));
 }
 
 int main (int argc, char *argv[])
@@ -1630,7 +1634,7 @@ int main (int argc, char *argv[])
 	} else {
 		/* rsv must be a power of two (64kB is MD RAID sb alignment) */
 		unsigned int rsv = 65536 / fs->blocksize;
-		unsigned long blocks = fs->super->s_blocks_count;
+		unsigned long blocks = EXT2_BLOCKS_COUNT(fs->super);
 		unsigned long start;
 		blk_t ret_blk;
 
Index: e2fsprogs-1.39-tyt3-v7/misc/tune2fs.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/misc/tune2fs.c	2007-06-21 13:12:03.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/misc/tune2fs.c	2007-06-21 13:13:05.000000000 +0200
@@ -213,7 +213,7 @@ static int release_blocks_proc(ext2_fils
 	ext2fs_unmark_block_bitmap(fs->block_map,block);
 	group = ext2fs_group_of_blk(fs, block);
 	fs->group_desc[group].bg_free_blocks_count++;
-	fs->super->s_free_blocks_count++;
+	EXT2_FREE_BLOCKS_COUNT_SET(fs->super, EXT2_FREE_BLOCKS_COUNT(fs->super) + 1);
 	return 0;
 }
 
@@ -824,20 +824,20 @@ int main (int argc, char ** argv)
 		printf (_("Setting interval between checks to %lu seconds\n"), interval);
 	}
 	if (m_flag) {
-		sb->s_r_blocks_count = e2p_percent(reserved_ratio,
-						   sb->s_blocks_count);
+		EXT2_R_BLOCKS_COUNT_SET(sb,
+			e2p_percent(reserved_ratio, EXT2_BLOCKS_COUNT(sb)));
 		ext2fs_mark_super_dirty(fs);
 		printf (_("Setting reserved blocks percentage to %g%% (%u blocks)\n"),
-			reserved_ratio, sb->s_r_blocks_count);
+			reserved_ratio, EXT2_R_BLOCKS_COUNT(sb));
 	}
 	if (r_flag) {
-		if (reserved_blocks >= sb->s_blocks_count/2) {
+		if (reserved_blocks >= EXT2_BLOCKS_COUNT(sb)/2) {
 			com_err (program_name, 0,
 				 _("reserved blocks count is too big (%lu)"),
 				 reserved_blocks);
 			exit (1);
 		}
-		sb->s_r_blocks_count = reserved_blocks;
+		EXT2_R_BLOCKS_COUNT_SET(sb, reserved_blocks);
 		ext2fs_mark_super_dirty(fs);
 		printf (_("Setting reserved blocks count to %lu\n"),
 			reserved_blocks);
Index: e2fsprogs-1.39-tyt3-v7/misc/util.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/misc/util.c	2007-06-21 13:12:03.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/misc/util.c	2007-06-21 13:13:05.000000000 +0200
@@ -253,7 +253,7 @@ int figure_journal_size(int size, ext2_f
 {
 	blk_t j_blocks;
 
-	if (fs->super->s_blocks_count < 2048) {
+	if (EXT2_BLOCKS_COUNT(fs->super) < 2048) {
 		fputs(_("\nFilesystem too small for a journal\n"), stderr);
 		return 0;
 	}
@@ -268,7 +268,7 @@ int figure_journal_size(int size, ext2_f
 				j_blocks);
 			exit(1);
 		}
-		if (j_blocks > fs->super->s_free_blocks_count / 2) {
+		if (j_blocks > EXT2_FREE_BLOCKS_COUNT(fs->super) / 2) {
 			fputs(_("\nJournal size too big for filesystem.\n"),
 			      stderr);
 			exit(1);
@@ -276,13 +276,13 @@ int figure_journal_size(int size, ext2_f
 		return j_blocks;
 	}
 
-	if (fs->super->s_blocks_count < 32768)
+	if (EXT2_FREE_BLOCKS_COUNT(fs->super) < 32768)
 		j_blocks = 1400;
-	else if (fs->super->s_blocks_count < 256*1024)
+	else if (EXT2_FREE_BLOCKS_COUNT(fs->super) < 256*1024)
 		j_blocks = 4096;
-	else if (fs->super->s_blocks_count < 512*1024)
+	else if (EXT2_FREE_BLOCKS_COUNT(fs->super) < 512*1024)
 		j_blocks = 8192;
-	else if (fs->super->s_blocks_count < 1024*1024)
+	else if (EXT2_FREE_BLOCKS_COUNT(fs->super) < 1024*1024)
 		j_blocks = 16384;
 	else
 		j_blocks = 32768;
Index: e2fsprogs-1.39-tyt3-v7/resize/main.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/resize/main.c	2007-06-21 13:12:03.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/resize/main.c	2007-06-21 13:13:05.000000000 +0200
@@ -374,7 +374,7 @@ int main (int argc, char ** argv)
 			fs->blocksize / 1024, new_size);
 		exit(1);
 	}
-	if (new_size == fs->super->s_blocks_count) {
+	if (new_size ==  EXT2_BLOCKS_COUNT(fs->super)) {
 		fprintf(stderr, _("The filesystem is already %u blocks "
 			"long.  Nothing to do!\n\n"), new_size);
 		exit(0);
Index: e2fsprogs-1.39-tyt3-v7/resize/online.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/resize/online.c	2007-06-21 13:12:03.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/resize/online.c	2007-06-21 13:13:05.000000000 +0200
@@ -32,9 +32,9 @@ errcode_t online_resize_fs(ext2_filsys f
 	printf(_("Filesystem at %s is mounted on %s; "
 		 "on-line resizing required\n"), fs->device_name, mtpt);
 
-	if (*new_size < sb->s_blocks_count) {
+	if (*new_size < EXT2_BLOCKS_COUNT(sb)) {
 		printf(_("On-line shrinking from %u to %u not supported.\n"),
-		       sb->s_blocks_count, *new_size);
+		       EXT2_BLOCKS_COUNT(sb), *new_size);
 		exit(1);
 	}
 
@@ -64,7 +64,7 @@ errcode_t online_resize_fs(ext2_filsys f
 		exit(1);
 	}
 
-	size=sb->s_blocks_count;
+	size=EXT2_BLOCKS_COUNT(sb);
 	if (ioctl(fd, EXT2_IOC_GROUP_EXTEND, &size)) {
 		if (errno == EPERM)
 			com_err(program_name, 0, 
@@ -78,7 +78,8 @@ errcode_t online_resize_fs(ext2_filsys f
 		exit(1);
 	}
 
-	r_frac = ext2fs_div_ceil(100 * sb->s_r_blocks_count, sb->s_blocks_count);
+	r_frac = ext2fs_div_ceil(100 * EXT2_R_BLOCKS_COUNT(sb), 
+				 EXT2_BLOCKS_COUNT(sb));
 
 	retval = ext2fs_read_bitmaps(fs);
 	if (retval)
@@ -121,7 +122,7 @@ errcode_t online_resize_fs(ext2_filsys f
 		input.inode_table = new_fs->group_desc[i].bg_inode_table;
 		input.blocks_count = sb->s_blocks_per_group;
 		if (i == new_fs->group_desc_count-1) {
-			input.blocks_count = new_fs->super->s_blocks_count -
+			input.blocks_count = EXT2_BLOCKS_COUNT(new_fs->super) -
 				sb->s_first_data_block - 
 				(i * sb->s_blocks_per_group);
 		}
Index: e2fsprogs-1.39-tyt3-v7/resize/resize2fs.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/resize/resize2fs.c	2007-06-21 13:12:03.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/resize/resize2fs.c	2007-06-21 13:13:05.000000000 +0200
@@ -34,6 +34,7 @@
  */
 
 #include "resize2fs.h"
+#include "e2p/e2p.h"
 #include <time.h>
 
 #ifdef __linux__			/* Kludge for debugging */
@@ -100,7 +101,7 @@ errcode_t resize_fs(ext2_filsys fs, blk_
 	if (retval)
 		goto errout;
 
-	*new_size = rfs->new_fs->super->s_blocks_count;
+	*new_size = EXT2_BLOCKS_COUNT(rfs->new_fs->super);
 
 	retval = blocks_to_move(rfs);
 	if (retval)
@@ -109,8 +110,8 @@ errcode_t resize_fs(ext2_filsys fs, blk_
 #ifdef RESIZE2FS_DEBUG
 	if (rfs->flags & RESIZE_DEBUG_BMOVE)
 		printf("Number of free blocks: %u/%u, Needed: %d\n",
-		       rfs->old_fs->super->s_free_blocks_count,
-		       rfs->new_fs->super->s_free_blocks_count,
+		       EXT2_FREE_BLOCKS_COUNT(rfs->old_fs->super),
+		       EXT2_FREE_BLOCKS_COUNT(rfs->new_fs->super),
 		       rfs->needed_blocks);
 #endif
 	
@@ -188,10 +189,10 @@ errcode_t adjust_fs_info(ext2_filsys fs,
 	int		has_super;
 	__u64		new_inodes;	/* u64 to check for overflow */
 
-	fs->super->s_blocks_count = new_size;
+	EXT2_BLOCKS_COUNT_SET(fs->super, new_size);
 
 retry:
-	fs->group_desc_count = ext2fs_div_ceil(fs->super->s_blocks_count -
+	fs->group_desc_count = ext2fs_div_ceil(EXT2_BLOCKS_COUNT(fs->super) -
 				       fs->super->s_first_data_block,
 				       EXT2_BLOCKS_PER_GROUP(fs->super));
 	if (fs->group_desc_count == 0)
@@ -216,12 +217,12 @@ retry:
 	 * necessary data structures.  If not, we need to get rid of
 	 * it.
 	 */
-	rem = (fs->super->s_blocks_count - fs->super->s_first_data_block) %
+	rem = (EXT2_BLOCKS_COUNT(fs->super) - fs->super->s_first_data_block) %
 		fs->super->s_blocks_per_group;
 	if ((fs->group_desc_count == 1) && rem && (rem < overhead))
 		return EXT2_ET_TOOSMALL;
 	if (rem && (rem < overhead+50)) {
-		fs->super->s_blocks_count -= rem;
+		EXT2_BLOCKS_COUNT_SET(fs->super, EXT2_BLOCKS_COUNT(fs->super) - rem);
 		goto retry;
 	}
 	/*
@@ -239,21 +240,23 @@ retry:
 	/*
 	 * Adjust the number of free blocks
 	 */
-	blk = old_fs->super->s_blocks_count;
-	if (blk > fs->super->s_blocks_count)
-		fs->super->s_free_blocks_count -=
-			(blk - fs->super->s_blocks_count);
+	blk =  EXT2_BLOCKS_COUNT(old_fs->super);
+	if (blk > EXT2_BLOCKS_COUNT(fs->super))
+		EXT2_FREE_BLOCKS_COUNT_SET(fs->super,
+				EXT2_FREE_BLOCKS_COUNT(fs->super) -
+				(blk - EXT2_BLOCKS_COUNT(fs->super)));
 	else
-		fs->super->s_free_blocks_count +=
-			(fs->super->s_blocks_count - blk);
+		EXT2_FREE_BLOCKS_COUNT_SET(fs->super,
+				EXT2_FREE_BLOCKS_COUNT(fs->super) +
+				(EXT2_BLOCKS_COUNT(fs->super) - blk));
 
 	/*
 	 * Adjust the number of reserved blocks
 	 */
-	blk = (__u64)old_fs->super->s_r_blocks_count * 100 /
-		old_fs->super->s_blocks_count;
-	fs->super->s_r_blocks_count = e2p_percent(blk, 
-						  fs->super->s_blocks_count);
+	blk = EXT2_R_BLOCKS_COUNT(old_fs->super) * 100 /
+		EXT2_BLOCKS_COUNT(old_fs->super);
+	EXT2_R_BLOCKS_COUNT_SET(
+		fs->super, e2p_percent(blk, EXT2_BLOCKS_COUNT(fs->super)));
 
 	/*
 	 * Adjust the bitmaps for size
@@ -266,7 +269,7 @@ retry:
 	real_end = ((EXT2_BLOCKS_PER_GROUP(fs->super)
 		     * fs->group_desc_count)) - 1 +
 			     fs->super->s_first_data_block;
-	retval = ext2fs_resize_block_bitmap(fs->super->s_blocks_count-1,
+	retval = ext2fs_resize_block_bitmap(EXT2_BLOCKS_COUNT(fs->super)-1,
 					    real_end, fs->block_map);
 
 	if (retval) goto errout;
@@ -323,13 +326,13 @@ retry:
 	/*
 	 * Fix the count of the last (old) block group
 	 */
-	old_numblocks = (old_fs->super->s_blocks_count -
+	old_numblocks = (EXT2_BLOCKS_COUNT(old_fs->super) -
 			 old_fs->super->s_first_data_block) %
 				 old_fs->super->s_blocks_per_group;
 	if (!old_numblocks)
 		old_numblocks = old_fs->super->s_blocks_per_group;
 	if (old_fs->group_desc_count == fs->group_desc_count) {
-		numblocks = (fs->super->s_blocks_count -
+		numblocks = (EXT2_BLOCKS_COUNT(fs->super) -
 			     fs->super->s_first_data_block) %
 			fs->super->s_blocks_per_group;
 		if (!numblocks)
@@ -369,7 +372,7 @@ retry:
 		adjblocks = 0;
 
 		if (i == fs->group_desc_count-1) {
-			numblocks = (fs->super->s_blocks_count -
+			numblocks = (EXT2_BLOCKS_COUNT(fs->super) -
 				     fs->super->s_first_data_block) %
 					     fs->super->s_blocks_per_group;
 			if (!numblocks)
@@ -406,7 +409,7 @@ retry:
 		adjblocks += 2 + fs->inode_blocks_per_group;
 		
 		numblocks -= adjblocks;
-		fs->super->s_free_blocks_count -= adjblocks;
+		EXT2_FREE_BLOCKS_COUNT_SET(fs->super, EXT2_FREE_BLOCKS_COUNT(fs->super) - adjblocks);
 		fs->super->s_free_inodes_count +=
 			fs->super->s_inodes_per_group;
 		fs->group_desc[i].bg_free_blocks_count = numblocks;
@@ -634,7 +637,7 @@ static errcode_t blocks_to_move(ext2_res
 
 	fs = rfs->new_fs;
 	old_fs = rfs->old_fs;
-	if (old_fs->super->s_blocks_count > fs->super->s_blocks_count)
+	if (EXT2_BLOCKS_COUNT(old_fs->super) > EXT2_BLOCKS_COUNT(fs->super))
 		fs = rfs->old_fs;
 	
 	retval = ext2fs_allocate_block_bitmap(fs, _("reserved blocks"),
@@ -662,8 +665,8 @@ static errcode_t blocks_to_move(ext2_res
 	 * If we're shrinking the filesystem, we need to move all of
 	 * the blocks that don't fit any more
 	 */
-	for (blk = fs->super->s_blocks_count;
-	     blk < old_fs->super->s_blocks_count; blk++) {
+	for (blk = EXT2_BLOCKS_COUNT(fs->super);
+	     blk < EXT2_BLOCKS_COUNT(old_fs->super); blk++) {
 		if (ext2fs_test_block_bitmap(old_fs->block_map, blk) &&
 		    !ext2fs_test_block_bitmap(meta_bmap, blk)) {
 			ext2fs_mark_block_bitmap(rfs->move_blocks, blk);
@@ -860,9 +863,9 @@ static void init_block_alloc(ext2_resize
 	rfs->new_blk = rfs->new_fs->super->s_first_data_block;
 #if 0
 	/* HACK for testing */
-	if (rfs->new_fs->super->s_blocks_count >
-	    rfs->old_fs->super->s_blocks_count)
-		rfs->new_blk = rfs->old_fs->super->s_blocks_count;
+	if (EXT2_BLOCKS_COUNT(rfs->new_fs->super) >
+	    EXT2_BLOCKS_COUNT(rfs->old_fs->super))
+		rfs->new_blk = EXT2_BLOCKS_COUNT(rfs->old_fs->super);
 #endif
 }
 
@@ -871,7 +874,7 @@ static blk_t get_new_block(ext2_resize_t
 	ext2_filsys	fs = rfs->new_fs;
 	
 	while (1) {
-		if (rfs->new_blk >= fs->super->s_blocks_count) {
+		if (rfs->new_blk >= EXT2_BLOCKS_COUNT(fs->super)) {
 			if (rfs->alloc_state == DESPERATION)
 				return 0;
 
@@ -888,7 +891,7 @@ static blk_t get_new_block(ext2_resize_t
 		    ext2fs_test_block_bitmap(rfs->reserve_blocks,
 					     rfs->new_blk) ||
 		    ((rfs->alloc_state == AVOID_OLD) &&
-		     (rfs->new_blk < rfs->old_fs->super->s_blocks_count) &&
+		     (rfs->new_blk < EXT2_BLOCKS_COUNT(rfs->old_fs->super)) &&
 		     ext2fs_test_block_bitmap(rfs->old_fs->block_map,
 					      rfs->new_blk))) {
 			rfs->new_blk++;
@@ -933,7 +936,7 @@ static errcode_t block_mover(ext2_resize
 	to_move = moved = 0;
 	init_block_alloc(rfs);
 	for (blk = old_fs->super->s_first_data_block;
-	     blk < old_fs->super->s_blocks_count; blk++) {
+	     blk < EXT2_BLOCKS_COUNT(old_fs->super); blk++) {
 		if (!ext2fs_test_block_bitmap(old_fs->block_map, blk))
 			continue;
 		if (!ext2fs_test_block_bitmap(rfs->move_blocks, blk))
@@ -1127,10 +1130,10 @@ static errcode_t inode_scan_and_fix(ext2
 	 * is larger.  We need to do this to avoid catching an error
 	 * by the block iterator routines
 	 */
-	orig_size = rfs->old_fs->super->s_blocks_count;
-	if (orig_size < rfs->new_fs->super->s_blocks_count)
-		rfs->old_fs->super->s_blocks_count =
-			rfs->new_fs->super->s_blocks_count;
+	orig_size = EXT2_BLOCKS_COUNT(rfs->old_fs->super);
+	if (orig_size < EXT2_BLOCKS_COUNT(rfs->new_fs->super))
+		EXT2_BLOCKS_COUNT_SET(rfs->old_fs->super,
+			EXT2_BLOCKS_COUNT(rfs->new_fs->super));
 
 	retval = ext2fs_open_inode_scan(rfs->old_fs, 0, &scan);
 	if (retval) goto errout;
@@ -1239,7 +1242,7 @@ static errcode_t inode_scan_and_fix(ext2
 	io_channel_flush(rfs->old_fs->io);
 
 errout:
-	rfs->old_fs->super->s_blocks_count = orig_size;
+	EXT2_BLOCKS_COUNT_SET(rfs->old_fs->super, orig_size);
 	if (rfs->bmap) {
 		ext2fs_free_extent_table(rfs->bmap);
 		rfs->bmap = 0;
@@ -1566,21 +1569,21 @@ static errcode_t ext2fs_calculate_summar
 	 * First calculate the block statistics
 	 */
 	for (blk = fs->super->s_first_data_block;
-	     blk < fs->super->s_blocks_count; blk++) {
+	     blk < EXT2_BLOCKS_COUNT(fs->super); blk++) {
 		if (!ext2fs_fast_test_block_bitmap(fs->block_map, blk)) {
 			group_free++;
 			total_free++;
 		}
 		count++;
 		if ((count == fs->super->s_blocks_per_group) ||
-		    (blk == fs->super->s_blocks_count-1)) {
+		    (blk == EXT2_BLOCKS_COUNT(fs->super)-1)) {
 			fs->group_desc[group++].bg_free_blocks_count =
 				group_free;
 			count = 0;
 			group_free = 0;
 		}
 	}
-	fs->super->s_free_blocks_count = total_free;
+	EXT2_FREE_BLOCKS_COUNT_SET(fs->super, total_free);
 	
 	/*
 	 * Next, calculate the inode statistics
Index: e2fsprogs-1.39-tyt3-v7/lib/ext2fs/extent.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/lib/ext2fs/extent.c	2007-06-21 13:12:03.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/lib/ext2fs/extent.c	2007-06-21 13:13:05.000000000 +0200
@@ -106,7 +106,7 @@ errcode_t ext2fs_extent_verify(ext2_fils
 {
 	ext_show_extent(ex);
 	/* FIXME: 48-bit support */
-	if (ex->ee_start > fs->super->s_blocks_count)
+	if (ex->ee_start > EXT2_BLOCKS_COUNT(fs->super))
 		return EXT2_ET_EXTENT_LEAF_BAD;
 
 	if (ex->ee_len == 0)
@@ -149,7 +149,7 @@ errcode_t ext2fs_extent_index_verify(ext
 {
 	ext_show_index(ix);
 	/* FIXME: 48-bit support */
-	if (ix->ei_leaf > fs->super->s_blocks_count)
+	if (ix->ei_leaf > EXT2_BLOCKS_COUNT(fs->super))
 		return EXT2_ET_EXTENT_INDEX_BAD;
 
 	if (ix_prev == NULL)
Index: e2fsprogs-1.39-tyt3-v7/tests/progs/test_icount.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/tests/progs/test_icount.c	2007-06-21 13:12:03.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/tests/progs/test_icount.c	2007-06-21 13:13:05.000000000 +0200
@@ -307,7 +307,7 @@ int main(int argc, char **argv)
 	 * Create a sample filesystem structure
 	 */
 	memset(&param, 0, sizeof(struct ext2_super_block));
-	param.s_blocks_count = 80000;
+	EXT2_BLOCKS_COUNT_SET(&param, 80000);
 	param.s_inodes_count = 20000;
 	retval = ext2fs_initialize("/dev/null", 0, &param,
 				   unix_io_manager, &test_fs);

--------------010708000909080208020201--
