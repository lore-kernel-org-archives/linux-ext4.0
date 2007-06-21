From: Valerie Clement <valerie.clement@bull.net>
Subject: [RFC][PATCH 7/11][take 2] handling of 64-bit block numbers in group
 desc in e2fsprogs
Date: Thu, 21 Jun 2007 17:29:59 +0200
Message-ID: <467A9977.3050400@bull.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000402010601050503090806"
To: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:37107 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757537AbXFUPzm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Jun 2007 11:55:42 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is a multi-part message in MIME format.
--------------000402010601050503090806
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed

This patch contains the changes to handle 64-bit block numbers stored in 
group descriptor structure.

Changes from the previous version:
- support of different group descriptor sizes for ext4 filesystems:
  -- Add new inline functions to get/set the block bitmap block, the 
inode bitmap block and the inode table block of a group.
  -- Add a new inline function to get the descriptor of a group.
- remove some'_EXT4FS_' conditional compilation and use instead 
INCOMPAT_64BIT tests.

  debugfs/debugfs.c         |   23 ++++----
  debugfs/logdump.c         |    4 -
  e2fsck/journal.c          |    4 +
  e2fsck/pass1.c            |   50 +++++++++--------
  e2fsck/pass1b.c           |   10 +--
  e2fsck/pass5.c            |   49 ++++++++---------
  e2fsck/super.c            |   35 ++++++------
  e2fsck/swapfs.c           |    4 -
  lib/ext2fs/alloc_stats.c  |   10 ++-
  lib/ext2fs/alloc_tables.c |   12 ++--
  lib/ext2fs/check_desc.c   |   12 ++--
  lib/ext2fs/closefs.c      |   18 ++++--
  lib/ext2fs/dblist.c       |    6 +-
  lib/ext2fs/ext2fs.h       |  132 
+++++++++++++++++++++++++++++++++++++++++++++-
  lib/ext2fs/imager.c       |    4 -
  lib/ext2fs/initialize.c   |    8 +-
  lib/ext2fs/inode.c        |   21 +++----
  lib/ext2fs/openfs.c       |   16 ++++-
  lib/ext2fs/rw_bitmaps.c   |   23 ++++----
  lib/ext2fs/swapfs.c       |    9 ++-
  lib/ext2fs/tst_iscan.c    |    2
  misc/dumpe2fs.c           |   30 +++++-----
  misc/e2image.c            |   12 ++--
  misc/mke2fs.c             |   21 ++++---
  misc/tune2fs.c            |    4 +
  resize/main.c             |    8 +-
  resize/online.c           |    6 +-
  resize/resize2fs.c        |   91 ++++++++++++++++++-------------
  28 files changed, 414 insertions(+), 210 deletions(-)



--------------000402010601050503090806
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
 name="07-handle-new-ext4-group-desc-struct"
Content-Disposition: inline;
 filename="07-handle-new-ext4-group-desc-struct"

This patch contains the changes to handle 64-bit block numbers stored in group
descriptor structure.

Index: e2fsprogs-1.39-tyt3-v7/lib/ext2fs/check_desc.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/lib/ext2fs/check_desc.c	2007-06-21 16:39:32.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/lib/ext2fs/check_desc.c	2007-06-21 16:44:41.000000000 +0200
@@ -45,22 +45,22 @@ errcode_t ext2fs_check_desc(ext2_filsys 
 		 * Check to make sure block bitmap for group is
 		 * located within the group.
 		 */
-		if (fs->group_desc[i].bg_block_bitmap < first_block ||
-		    fs->group_desc[i].bg_block_bitmap > last_block)
+		if (ext2_block_bitmap(fs, i) < first_block ||
+			ext2_block_bitmap(fs, i) > last_block)
 			return EXT2_ET_GDESC_BAD_BLOCK_MAP;
 		/*
 		 * Check to make sure inode bitmap for group is
 		 * located within the group
 		 */
-		if (fs->group_desc[i].bg_inode_bitmap < first_block ||
-		    fs->group_desc[i].bg_inode_bitmap > last_block)
+		if (ext2_inode_bitmap(fs, i) < first_block ||
+			ext2_inode_bitmap(fs, i) > last_block)
 			return EXT2_ET_GDESC_BAD_INODE_MAP;
 		/*
 		 * Check to make sure inode table for group is located
 		 * within the group
 		 */
-		if (fs->group_desc[i].bg_inode_table < first_block ||
-		    ((fs->group_desc[i].bg_inode_table +
+		if (ext2_inode_table(fs, i) < first_block ||
+			((ext2_inode_table(fs, i) +
 		      fs->inode_blocks_per_group) > last_block))
 			return EXT2_ET_GDESC_BAD_INODE_TABLE;
 	}
Index: e2fsprogs-1.39-tyt3-v7/lib/ext2fs/alloc_tables.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/lib/ext2fs/alloc_tables.c	2007-06-21 16:39:32.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/lib/ext2fs/alloc_tables.c	2007-06-21 16:44:41.000000000 +0200
@@ -56,7 +56,7 @@ errcode_t ext2fs_allocate_group_table(ex
 	} else
 		start_blk = group_blk;
 
-	if (!fs->group_desc[group].bg_block_bitmap) {
+	if (!ext2_block_bitmap(fs, group)) {
 		retval = ext2fs_get_free_blocks(fs, start_blk, last_blk,
 						1, bmap, &new_blk);
 		if (retval == EXT2_ET_BLOCK_ALLOC_FAIL) 
@@ -65,10 +65,10 @@ errcode_t ext2fs_allocate_group_table(ex
 		if (retval)
 			return retval;
 		ext2fs_mark_block_bitmap(bmap, new_blk);
-		fs->group_desc[group].bg_block_bitmap = new_blk;
+		ext2_block_bitmap_set(fs, group, new_blk);
 	}
 
-	if (!fs->group_desc[group].bg_inode_bitmap) {
+	if (!ext2_inode_bitmap(fs, group)) {
 		retval = ext2fs_get_free_blocks(fs, start_blk, last_blk,
 						1, bmap, &new_blk);
 		if (retval == EXT2_ET_BLOCK_ALLOC_FAIL) 
@@ -77,13 +77,13 @@ errcode_t ext2fs_allocate_group_table(ex
 		if (retval)
 			return retval;
 		ext2fs_mark_block_bitmap(bmap, new_blk);
-		fs->group_desc[group].bg_inode_bitmap = new_blk;
+		ext2_inode_bitmap_set(fs, group, new_blk);
 	}
 
 	/*
 	 * Allocate the inode table
 	 */
-	if (!fs->group_desc[group].bg_inode_table) {
+	if (!ext2_inode_table(fs, group)) {
 		retval = ext2fs_get_free_blocks(fs, group_blk, last_blk,
 						fs->inode_blocks_per_group,
 						bmap, &new_blk);
@@ -93,7 +93,7 @@ errcode_t ext2fs_allocate_group_table(ex
 		     j < fs->inode_blocks_per_group;
 		     j++, blk++)
 			ext2fs_mark_block_bitmap(bmap, blk);
-		fs->group_desc[group].bg_inode_table = new_blk;
+		ext2_inode_table_set(fs, group, new_blk);
 	}
 
 	
Index: e2fsprogs-1.39-tyt3-v7/e2fsck/pass5.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/e2fsck/pass5.c	2007-06-21 16:39:32.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/e2fsck/pass5.c	2007-06-21 16:44:41.000000000 +0200
@@ -123,6 +123,7 @@ static void check_block_bitmaps(e2fsck_t
 	errcode_t	retval;
 	int		lazy_bg = 0;
 	int		skip_group = 0;
+	struct ext4_group_desc *gdp;
 
 	clear_problem_context(&pctx);
 	free_array = (int *) e2fsck_allocate_memory(ctx,
@@ -165,8 +166,8 @@ redo_counts:
 	had_problem = 0;
 	save_problem = 0;
 	pctx.blk = pctx.blk2 = NO_BLK;
-	if (lazy_bg && (fs->group_desc[group].bg_flags &
-			EXT2_BG_BLOCK_UNINIT))
+	gdp = ext2_get_group_desc(fs, group);
+	if (lazy_bg && (gdp->bg_flags & EXT2_BG_BLOCK_UNINIT))
 		skip_group++;
 	super = fs->super->s_first_data_block;
 	for (i = fs->super->s_first_data_block;
@@ -179,12 +180,12 @@ redo_counts:
 			    (i <= super + fs->desc_blocks) &&
 			    ext2fs_bg_has_super(fs, group))
 				bitmap = 1;
-			else if (i == fs->group_desc[group].bg_block_bitmap)
+			else if (i == ext2_block_bitmap(fs, group))
 				bitmap = 1;
-			else if (i == fs->group_desc[group].bg_inode_bitmap)
+			else if (i == ext2_inode_bitmap(fs, group))
 				bitmap = 1;
-			else if (i >= fs->group_desc[group].bg_inode_table &&
-				 (i < fs->group_desc[group].bg_inode_table
+			else if (i >= ext2_inode_table(fs, group) &&
+				 (i < ext2_inode_table(fs, group)
 				  + fs->inode_blocks_per_group))
 				bitmap = 1;
 			else
@@ -241,10 +242,10 @@ redo_counts:
 				if ((ctx->progress)(ctx, 5, group,
 						    fs->group_desc_count*2))
 					goto errout;
+			gdp = ext2_get_group_desc(fs, group);
 			if (lazy_bg &&
 			    (i != EXT2_BLOCKS_COUNT(fs->super)-1) &&
-			    (fs->group_desc[group].bg_flags &
-			     EXT2_BG_BLOCK_UNINIT))
+			    (gdp->bg_flags & EXT2_BG_BLOCK_UNINIT))
 				skip_group++;
 		}
 	}
@@ -277,15 +278,15 @@ redo_counts:
 		ext2fs_unmark_valid(fs);
 
 	for (i = 0; i < fs->group_desc_count; i++) {
-		if (free_array[i] != fs->group_desc[i].bg_free_blocks_count) {
+		gdp = ext2_get_group_desc(fs, i);
+		if (free_array[i] != gdp->bg_free_blocks_count) {
 			pctx.group = i;
-			pctx.blk = fs->group_desc[i].bg_free_blocks_count;
+			pctx.blk = gdp->bg_free_blocks_count;
 			pctx.blk2 = free_array[i];
 
 			if (fix_problem(ctx, PR_5_FREE_BLOCK_COUNT_GROUP,
 					&pctx)) {
-				fs->group_desc[i].bg_free_blocks_count =
-					free_array[i];
+				gdp->bg_free_blocks_count = free_array[i];
 				ext2fs_mark_super_dirty(fs);
 			} else
 				ext2fs_unmark_valid(fs);
@@ -323,6 +324,7 @@ static void check_inode_bitmaps(e2fsck_t
 	int		problem, save_problem, fixit, had_problem;
 	int		lazy_bg = 0;
 	int		skip_group = 0;
+	struct ext4_group_desc *gdp;
 
 	clear_problem_context(&pctx);
 	free_array = (int *) e2fsck_allocate_memory(ctx,
@@ -366,8 +368,8 @@ redo_counts:
 	had_problem = 0;
 	save_problem = 0;
 	pctx.ino = pctx.ino2 = 0;
-	if (lazy_bg && (fs->group_desc[group].bg_flags &
-			EXT2_BG_INODE_UNINIT))
+	gdp = ext2_get_group_desc(fs, group);
+	if (lazy_bg && (gdp->bg_flags & EXT2_BG_INODE_UNINIT))
 		skip_group++;
 
 	/* Protect loop from wrap-around if inodes_count is maxed */
@@ -430,10 +432,10 @@ do_counts:
 					    group + fs->group_desc_count,
 					    fs->group_desc_count*2))
 					goto errout;
+			gdp = ext2_get_group_desc(fs, group);
 			if (lazy_bg &&
 			    (i != fs->super->s_inodes_count) &&
-			    (fs->group_desc[group].bg_flags &
-			     EXT2_BG_INODE_UNINIT))
+			    (gdp->bg_flags & EXT2_BG_INODE_UNINIT))
 				skip_group++;
 		}
 	}
@@ -469,27 +471,26 @@ do_counts:
 		ext2fs_unmark_valid(fs);
 
 	for (i = 0; i < fs->group_desc_count; i++) {
-		if (free_array[i] != fs->group_desc[i].bg_free_inodes_count) {
+		gdp = ext2_get_group_desc(fs, i);
+		if (free_array[i] != gdp->bg_free_inodes_count) {
 			pctx.group = i;
-			pctx.ino = fs->group_desc[i].bg_free_inodes_count;
+			pctx.ino = gdp->bg_free_inodes_count;
 			pctx.ino2 = free_array[i];
 			if (fix_problem(ctx, PR_5_FREE_INODE_COUNT_GROUP,
 					&pctx)) {
-				fs->group_desc[i].bg_free_inodes_count =
-					free_array[i];
+				gdp->bg_free_inodes_count = free_array[i];
 				ext2fs_mark_super_dirty(fs);
 			} else
 				ext2fs_unmark_valid(fs);
 		}
-		if (dir_array[i] != fs->group_desc[i].bg_used_dirs_count) {
+		if (dir_array[i] != gdp->bg_used_dirs_count) {
 			pctx.group = i;
-			pctx.ino = fs->group_desc[i].bg_used_dirs_count;
+			pctx.ino = gdp->bg_used_dirs_count;
 			pctx.ino2 = dir_array[i];
 
 			if (fix_problem(ctx, PR_5_FREE_DIR_COUNT_GROUP,
 					&pctx)) {
-				fs->group_desc[i].bg_used_dirs_count =
-					dir_array[i];
+				gdp->bg_used_dirs_count = dir_array[i];
 				ext2fs_mark_super_dirty(fs);
 			} else
 				ext2fs_unmark_valid(fs);
Index: e2fsprogs-1.39-tyt3-v7/lib/ext2fs/swapfs.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/lib/ext2fs/swapfs.c	2007-06-21 16:39:32.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/lib/ext2fs/swapfs.c	2007-06-21 16:44:41.000000000 +0200
@@ -80,7 +80,8 @@ void ext2fs_swap_super(struct ext2_super
 
 }
 
-void ext2fs_swap_group_desc(struct ext2_group_desc *gdp)
+void ext2fs_swap_group_desc(struct ext2_super_block *sb,
+				struct ext4_group_desc *gdp)
 {
 	gdp->bg_block_bitmap = ext2fs_swab32(gdp->bg_block_bitmap);
 	gdp->bg_inode_bitmap = ext2fs_swab32(gdp->bg_inode_bitmap);
@@ -91,6 +92,12 @@ void ext2fs_swap_group_desc(struct ext2_
 	gdp->bg_flags = ext2fs_swab16(gdp->bg_flags);
 	gdp->bg_itable_unused = ext2fs_swab16(gdp->bg_itable_unused);
 	gdp->bg_checksum = ext2fs_swab16(gdp->bg_checksum);
+	if (EXT2_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_64BIT) &&
+			sb->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT) {
+		gdp->bg_block_bitmap_hi = ext2fs_swab32(gdp->bg_block_bitmap_hi);
+		gdp->bg_inode_bitmap_hi = ext2fs_swab32(gdp->bg_inode_bitmap_hi);
+		gdp->bg_inode_table_hi = ext2fs_swab32(gdp->bg_inode_table_hi);
+	}
 }
 
 void ext2fs_swap_ext_attr(char *to, char *from, int bufsize, int has_header)
Index: e2fsprogs-1.39-tyt3-v7/lib/ext2fs/rw_bitmaps.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/lib/ext2fs/rw_bitmaps.c	2007-06-21 16:39:32.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/lib/ext2fs/rw_bitmaps.c	2007-06-21 16:44:41.000000000 +0200
@@ -62,6 +62,7 @@ static errcode_t write_bitmaps(ext2_fils
 	char 		*block_buf, *inode_buf;
 	int		lazy_flag = 0;
 	blk_t		blk;
+	struct ext4_group_desc *gdp;
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
@@ -94,8 +95,8 @@ static errcode_t write_bitmaps(ext2_fils
 		if (!block_bitmap || !do_block)
 			goto skip_block_bitmap;
 
-		if (lazy_flag && fs->group_desc[i].bg_flags &
-		    EXT2_BG_BLOCK_UNINIT) 
+		gdp = ext2_get_group_desc(fs, i);
+		if (lazy_flag && gdp->bg_flags & EXT2_BG_BLOCK_UNINIT) 
 			goto skip_this_block_bitmap;
  
 		memcpy(block_buf, block_bitmap, block_nbytes);
@@ -108,7 +109,7 @@ static errcode_t write_bitmaps(ext2_fils
 				for (j = nbits; j < fs->blocksize * 8; j++)
 					ext2fs_set_bit(j, block_buf);
 		}
-		blk = fs->group_desc[i].bg_block_bitmap;
+		blk = ext2_block_bitmap(fs, i);
 		if (blk) {
 #ifdef EXT2_BIG_ENDIAN_BITMAPS
 			if (!((fs->flags & EXT2_FLAG_SWAP_BYTES) ||
@@ -128,12 +129,11 @@ static errcode_t write_bitmaps(ext2_fils
 		if (!inode_bitmap || !do_inode)
 			continue;
 
-		if (lazy_flag && fs->group_desc[i].bg_flags &
-		    EXT2_BG_INODE_UNINIT) 
+		if (lazy_flag && gdp->bg_flags & EXT2_BG_INODE_UNINIT) 
 			goto skip_this_inode_bitmap;
  
 		memcpy(inode_buf, inode_bitmap, inode_nbytes);
-		blk = fs->group_desc[i].bg_inode_bitmap;
+		 blk = ext2_inode_bitmap(fs, i);
 		if (blk) {
 #ifdef EXT2_BIG_ENDIAN_BITMAPS
 			if (!((fs->flags & EXT2_FLAG_SWAP_BYTES) ||
@@ -171,6 +171,7 @@ static errcode_t read_bitmaps(ext2_filsy
 	int inode_nbytes = (int) EXT2_INODES_PER_GROUP(fs->super) / 8;
 	int lazy_flag = 0;
 	blk_t	blk;
+	struct ext4_group_desc *gdp;
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
@@ -227,9 +228,9 @@ static errcode_t read_bitmaps(ext2_filsy
 
 	for (i = 0; i < fs->group_desc_count; i++) {
 		if (block_bitmap) {
-			blk = fs->group_desc[i].bg_block_bitmap;
-			if (lazy_flag && fs->group_desc[i].bg_flags &
-			    EXT2_BG_BLOCK_UNINIT)
+			blk = ext2_block_bitmap(fs, i);
+			gdp = ext2_get_group_desc(fs, i);
+			if (lazy_flag && gdp->bg_flags & EXT2_BG_BLOCK_UNINIT)
 				blk = 0;
 			if (blk) {
 				retval = io_channel_read_blk(fs->io, blk,
@@ -248,8 +249,8 @@ static errcode_t read_bitmaps(ext2_filsy
 			block_bitmap += block_nbytes;
 		}
 		if (inode_bitmap) {
-			blk = fs->group_desc[i].bg_inode_bitmap;
-			if (lazy_flag && fs->group_desc[i].bg_flags &
+			blk = ext2_inode_bitmap(fs, i);
+			if (lazy_flag && gdp->bg_flags &
 			    EXT2_BG_INODE_UNINIT)
 				blk = 0;
 			if (blk) {
Index: e2fsprogs-1.39-tyt3-v7/resize/online.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/resize/online.c	2007-06-21 16:39:32.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/resize/online.c	2007-06-21 16:44:41.000000000 +0200
@@ -117,9 +117,9 @@ errcode_t online_resize_fs(ext2_filsys f
 				new_fs->super->s_reserved_gdt_blocks;
 
 		input.group = i;
-		input.block_bitmap = new_fs->group_desc[i].bg_block_bitmap;
-		input.inode_bitmap = new_fs->group_desc[i].bg_inode_bitmap;
-		input.inode_table = new_fs->group_desc[i].bg_inode_table;
+		input.block_bitmap = ext2_block_bitmap(new_fs, i);
+		input.inode_bitmap = ext2_inode_bitmap(new_fs, i);
+		input.inode_table = ext2_inode_table(new_fs, i);
 		input.blocks_count = sb->s_blocks_per_group;
 		if (i == new_fs->group_desc_count-1) {
 			input.blocks_count = EXT2_BLOCKS_COUNT(new_fs->super) -
Index: e2fsprogs-1.39-tyt3-v7/debugfs/logdump.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/debugfs/logdump.c	2007-06-21 16:39:32.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/debugfs/logdump.c	2007-06-21 16:44:41.000000000 +0200
@@ -156,7 +156,7 @@ void do_logdump(int argc, char **argv)
 				    / sizeof(struct ext2_inode));
 		
 		inode_block_to_dump = 
-			current_fs->group_desc[inode_group].bg_inode_table + 
+			ext2_inode_table(current_fs, inode_group) +
 			(group_offset / inodes_per_block);
 		inode_offset_to_dump = ((group_offset % inodes_per_block)
 					* sizeof(struct ext2_inode));
@@ -181,7 +181,7 @@ void do_logdump(int argc, char **argv)
 		group_to_dump = ((block_to_dump - 
 				  es->s_first_data_block)
 				 / es->s_blocks_per_group);
-		bitmap_to_dump = current_fs->group_desc[group_to_dump].bg_block_bitmap;
+		bitmap_to_dump = ext2_block_bitmap(current_fs, group_to_dump);
 	}
 
 	if (!journal_fn && check_fs_open(argv[0]))
Index: e2fsprogs-1.39-tyt3-v7/debugfs/debugfs.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/debugfs/debugfs.c	2007-06-21 16:39:32.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/debugfs/debugfs.c	2007-06-21 16:44:41.000000000 +0200
@@ -266,7 +266,7 @@ static void print_features(struct ext2_s
 	fputs("\n", f);
 }
 
-static void print_bg_opts(struct ext2_group_desc *gdp, int mask,
+static void print_bg_opts(struct ext4_group_desc *gdp, int mask,
 			  const char *str, int *first, FILE *f)
 {
 	if (gdp->bg_flags & mask) {
@@ -283,7 +283,7 @@ void do_show_super_stats(int argc, char 
 {
 	dgrp_t	i;
 	FILE 	*out;
-	struct ext2_group_desc *gdp;
+	struct ext4_group_desc *gdp;
 	int	c, header_only = 0;
 	int	numdirs = 0, first;
 
@@ -305,8 +305,10 @@ void do_show_super_stats(int argc, char 
 	out = open_pager();
 
 	list_super2(current_fs->super, out);
-	for (i=0; i < current_fs->group_desc_count; i++)
-		numdirs += current_fs->group_desc[i].bg_used_dirs_count;
+	for (i=0; i < current_fs->group_desc_count; i++) {
+		gdp = ext2_get_group_desc(current_fs, i);
+		numdirs += gdp->bg_used_dirs_count;
+	}
 	fprintf(out, "Directories:              %d\n", numdirs);
 	
 	if (header_only) {
@@ -314,16 +316,17 @@ void do_show_super_stats(int argc, char 
 		return;
 	}
 	
-	gdp = &current_fs->group_desc[0];
-	for (i = 0; i < current_fs->group_desc_count; i++, gdp++) {
+	for (i = 0; i < current_fs->group_desc_count; i++) {
+		gdp = ext2_get_group_desc(current_fs, i);
 		fprintf(out, " Group %2d: block bitmap at %u, "
 		        "inode bitmap at %u, "
 		        "inode table at %u\n"
 		        "           %d free %s, "
 		        "%d free %s, "
 		        "%d used %s\n",
-		        i, gdp->bg_block_bitmap,
-		        gdp->bg_inode_bitmap, gdp->bg_inode_table,
+			i, ext2_block_bitmap(current_fs, i),
+			ext2_inode_bitmap(current_fs, i),
+			ext2_inode_table(current_fs, i),
 		        gdp->bg_free_blocks_count,
 		        gdp->bg_free_blocks_count != 1 ? "blocks" : "block",
 		        gdp->bg_free_inodes_count,
@@ -1798,12 +1801,12 @@ void do_imap(int argc, char *argv[])
 	offset = ((ino - 1) % EXT2_INODES_PER_GROUP(current_fs->super)) *
 		EXT2_INODE_SIZE(current_fs->super);
 	block = offset >> EXT2_BLOCK_SIZE_BITS(current_fs->super);
-	if (!current_fs->group_desc[(unsigned)group].bg_inode_table) {
+	if (!ext2_inode_table(current_fs, group)) {
 		com_err(argv[0], 0, "Inode table for group %lu is missing\n",
 			group);
 		return;
 	}
-	block_nr = current_fs->group_desc[(unsigned)group].bg_inode_table + 
+	block_nr = ext2_inode_table(current_fs, group) +
 		block;
 	offset &= (EXT2_BLOCK_SIZE(current_fs->super) - 1);
 
Index: e2fsprogs-1.39-tyt3-v7/resize/resize2fs.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/resize/resize2fs.c	2007-06-21 16:39:32.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/resize/resize2fs.c	2007-06-21 16:44:41.000000000 +0200
@@ -53,9 +53,9 @@ static errcode_t ext2fs_calculate_summar
 /*
  * Some helper CPP macros
  */
-#define FS_BLOCK_BM(fs, i) ((fs)->group_desc[(i)].bg_block_bitmap)
-#define FS_INODE_BM(fs, i) ((fs)->group_desc[(i)].bg_inode_bitmap)
-#define FS_INODE_TB(fs, i) ((fs)->group_desc[(i)].bg_inode_table)
+#define FS_BLOCK_BM(fs, i) (ext2_block_bitmap((fs), (i)))
+#define FS_INODE_BM(fs, i) (ext2_inode_bitmap((fs), (i)))
+#define FS_INODE_TB(fs, i) (ext2_inode_table((fs), (i)))
 
 #define IS_BLOCK_BM(fs, i, blk) ((blk) == FS_BLOCK_BM((fs),(i)))
 #define IS_INODE_BM(fs, i, blk) ((blk) == FS_INODE_BM((fs),(i)))
@@ -188,6 +188,7 @@ errcode_t adjust_fs_info(ext2_filsys fs,
 	unsigned int	meta_bg, meta_bg_size;
 	int		has_super;
 	__u64		new_inodes;	/* u64 to check for overflow */
+	struct ext4_group_desc *gdp;
 
 	EXT2_BLOCKS_COUNT_SET(fs->super, new_size);
 
@@ -340,7 +341,8 @@ retry:
 	} else
 		numblocks = fs->super->s_blocks_per_group;
 	i = old_fs->group_desc_count - 1;
-	fs->group_desc[i].bg_free_blocks_count += (numblocks-old_numblocks);
+	gdp = ext2_get_group_desc(fs, i);
+	gdp->bg_free_blocks_count += (numblocks-old_numblocks);
 		
 	/*
 	 * If the number of block groups is staying the same, we're
@@ -367,8 +369,13 @@ retry:
 			fs->super->s_reserved_gdt_blocks;
 	for (i = old_fs->group_desc_count;
 	     i < fs->group_desc_count; i++) {
-		memset(&fs->group_desc[i], 0,
-		       sizeof(struct ext2_group_desc));
+		gdp = ext2_get_group_desc(fs, i);
+		if (EXT2_HAS_INCOMPAT_FEATURE(old_fs->super,
+					EXT4_FEATURE_INCOMPAT_64BIT) &&
+				old_fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT)
+			memset(gdp, 0, sizeof(struct ext4_group_desc));
+		else
+			memset(gdp, 0, sizeof(struct ext2_group_desc));
 		adjblocks = 0;
 
 		if (i == fs->group_desc_count-1) {
@@ -412,10 +419,10 @@ retry:
 		EXT2_FREE_BLOCKS_COUNT_SET(fs->super, EXT2_FREE_BLOCKS_COUNT(fs->super) - adjblocks);
 		fs->super->s_free_inodes_count +=
 			fs->super->s_inodes_per_group;
-		fs->group_desc[i].bg_free_blocks_count = numblocks;
-		fs->group_desc[i].bg_free_inodes_count =
+		gdp->bg_free_blocks_count = numblocks;
+		gdp->bg_free_inodes_count =
 			fs->super->s_inodes_per_group;
-		fs->group_desc[i].bg_used_dirs_count = 0;
+		gdp->bg_used_dirs_count = 0;
 
 		retval = ext2fs_allocate_group_table(fs, i, 0);
 		if (retval) goto errout;
@@ -505,7 +512,7 @@ static errcode_t adjust_superblock(ext2_
 		 * Write out the new inode table
 		 */
 		retval = io_channel_write_blk(fs->io,
-					      fs->group_desc[i].bg_inode_table,
+					      ext2_inode_table(fs, i),
 					      fs->inode_blocks_per_group,
 					      rfs->itable_buf);
 		if (retval) goto errout;
@@ -563,7 +570,7 @@ static errcode_t mark_table_blocks(ext2_
 		/*
 		 * Mark the blocks used for the inode table
 		 */
-		for (j = 0, b = fs->group_desc[i].bg_inode_table;
+		for (j = 0, b = ext2_inode_table(fs, i);
 		     j < (unsigned int) fs->inode_blocks_per_group;
 		     j++, b++)
 			ext2fs_mark_block_bitmap(bmap, b);
@@ -572,13 +579,13 @@ static errcode_t mark_table_blocks(ext2_
 		 * Mark block used for the block bitmap 
 		 */
 		ext2fs_mark_block_bitmap(bmap,
-					 fs->group_desc[i].bg_block_bitmap);
+					 ext2_block_bitmap(fs, i));
 
 		/*
 		 * Mark block used for the inode bitmap 
 		 */
 		ext2fs_mark_block_bitmap(bmap,
-					 fs->group_desc[i].bg_inode_bitmap);
+					 ext2_inode_bitmap(fs, i));
 	}
 	return 0;
 }
@@ -603,13 +610,13 @@ static void mark_fs_metablock(ext2_resiz
 	 * mark it as a block to be moved.
 	 */
 	if (IS_BLOCK_BM(fs, group, blk)) {
-		FS_BLOCK_BM(fs, group) = 0;
+		ext2_block_bitmap_set(fs, group, 0UL);
 		rfs->needed_blocks++;
 	} else if (IS_INODE_BM(fs, group, blk)) {
-		FS_INODE_BM(fs, group) = 0;
+		ext2_inode_bitmap_set(fs, group, 0UL);
 		rfs->needed_blocks++;
 	} else if (IS_INODE_TB(fs, group, blk)) {
-		FS_INODE_TB(fs, group) = 0;
+		ext2_inode_table_set(fs, group, 0UL);
 		rfs->needed_blocks++;
 	} else if (ext2fs_test_block_bitmap(rfs->old_fs->block_map, blk) &&
 		   !ext2fs_test_block_bitmap(meta_bmap, blk)) {
@@ -744,23 +751,23 @@ static errcode_t blocks_to_move(ext2_res
 						  group_blk + has_super);
 		}
 
-		if (fs->group_desc[i].bg_inode_table &&
-		    fs->group_desc[i].bg_inode_bitmap &&
-		    fs->group_desc[i].bg_block_bitmap)
+		if (ext2_inode_table(fs, i) &&
+		    ext2_inode_bitmap(fs, i) &&
+		    ext2_block_bitmap(fs, i))
 			goto next_group;
 
 		/*
 		 * Reserve the existing meta blocks that we know
 		 * aren't to be moved.
 		 */
-		if (fs->group_desc[i].bg_block_bitmap)
+		if (ext2_block_bitmap(fs, i))
 			ext2fs_mark_block_bitmap(rfs->reserve_blocks,
-				 fs->group_desc[i].bg_block_bitmap);
-		if (fs->group_desc[i].bg_inode_bitmap)
+				 ext2_block_bitmap(fs, i));
+		if (ext2_inode_bitmap(fs, i))
 			ext2fs_mark_block_bitmap(rfs->reserve_blocks,
-				 fs->group_desc[i].bg_inode_bitmap);
-		if (fs->group_desc[i].bg_inode_table)
-			for (blk = fs->group_desc[i].bg_inode_table, j=0;
+				 ext2_inode_bitmap(fs, i));
+		if (ext2_inode_table(fs, i))
+			for (blk = ext2_inode_table(fs, i), j=0;
 			     j < fs->inode_blocks_per_group ; j++, blk++)
 				ext2fs_mark_block_bitmap(rfs->reserve_blocks,
 							 blk);
@@ -811,7 +818,7 @@ static errcode_t blocks_to_move(ext2_res
 		 * allocation bitmap, and move any blocks that might 
 		 * be necessary.
 		 */
-		for (blk = fs->group_desc[i].bg_inode_table, j=0;
+		for (blk = ext2_inode_table(fs, i), j=0;
 		     j < fs->inode_blocks_per_group ; j++, blk++) {
 			ext2fs_mark_block_bitmap(fs->block_map, blk);
 			if (ext2fs_test_block_bitmap(old_fs->block_map, blk) &&
@@ -824,7 +831,7 @@ static errcode_t blocks_to_move(ext2_res
 		 * Make sure the old inode table is reserved in the
 		 * block reservation bitmap.
 		 */
-		for (blk = rfs->old_fs->group_desc[i].bg_inode_table, j=0;
+		for (blk = ext2_inode_table(rfs->old_fs, i), j=0;
 		     j < fs->inode_blocks_per_group ; j++, blk++)
 			ext2fs_mark_block_bitmap(rfs->reserve_blocks, blk);
 		
@@ -1118,6 +1125,7 @@ static errcode_t inode_scan_and_fix(ext2
 	char			*block_buf = 0;
 	ext2_ino_t		start_to_move;
 	blk_t			orig_size, new_block;
+	struct ext4_group_desc *gdp;
 	
 	if ((rfs->old_fs->group_desc_count <=
 	     rfs->new_fs->group_desc_count) &&
@@ -1225,8 +1233,10 @@ static errcode_t inode_scan_and_fix(ext2
 		if (retval) goto errout;
 
 		group = (new_inode-1) / EXT2_INODES_PER_GROUP(rfs->new_fs->super);
-		if (LINUX_S_ISDIR(inode.i_mode))
-			rfs->new_fs->group_desc[group].bg_used_dirs_count++;
+		if (LINUX_S_ISDIR(inode.i_mode)) {
+			gdp = ext2_get_group_desc(rfs->new_fs, group);
+			gdp->bg_used_dirs_count++;
+		}
 		
 #ifdef RESIZE2FS_DEBUG
 		if (rfs->flags & RESIZE_DEBUG_INODEMAP)
@@ -1404,8 +1414,8 @@ static errcode_t move_itables(ext2_resiz
 	 */
 	to_move = moved = 0;
 	for (i=0; i < max_groups; i++)
-		if (rfs->old_fs->group_desc[i].bg_inode_table !=
-		    fs->group_desc[i].bg_inode_table)
+		if (ext2_inode_table(rfs->old_fs, i) !=
+		    ext2_inode_table(rfs->old_fs, i))
 			to_move++;
 
 	if (to_move == 0)
@@ -1421,8 +1431,8 @@ static errcode_t move_itables(ext2_resiz
 	rfs->old_fs->flags |= EXT2_FLAG_MASTER_SB_ONLY;
 
 	for (i=0; i < max_groups; i++) {
-		old_blk = rfs->old_fs->group_desc[i].bg_inode_table;
-		new_blk = fs->group_desc[i].bg_inode_table;
+		old_blk = ext2_inode_table(rfs->old_fs, i);
+		new_blk = ext2_inode_table(fs, i);
 		diff = new_blk - old_blk;
 		
 #ifdef RESIZE2FS_DEBUG
@@ -1475,11 +1485,11 @@ static errcode_t move_itables(ext2_resiz
 				goto errout;
 		}
 
-		for (blk = rfs->old_fs->group_desc[i].bg_inode_table, j=0;
+		for (blk = ext2_inode_table(rfs->old_fs, i), j=0;
 		     j < fs->inode_blocks_per_group ; j++, blk++)
 			ext2fs_unmark_block_bitmap(fs->block_map, blk);
 
-		rfs->old_fs->group_desc[i].bg_inode_table = new_blk;
+		ext2_inode_table_set(rfs->old_fs, i, new_blk);
 		ext2fs_mark_super_dirty(rfs->old_fs);
 		ext2fs_flush(rfs->old_fs);
 
@@ -1564,6 +1574,7 @@ static errcode_t ext2fs_calculate_summar
 	blk_t		count = 0;
 	blk_t		total_free = 0;
 	int		group_free = 0;
+	struct ext4_group_desc *gdp;
 
 	/*
 	 * First calculate the block statistics
@@ -1577,8 +1588,9 @@ static errcode_t ext2fs_calculate_summar
 		count++;
 		if ((count == fs->super->s_blocks_per_group) ||
 		    (blk == EXT2_BLOCKS_COUNT(fs->super)-1)) {
-			fs->group_desc[group++].bg_free_blocks_count =
-				group_free;
+			gdp = ext2_get_group_desc(fs, group);
+			gdp->bg_free_blocks_count = group_free;
+			group++;
 			count = 0;
 			group_free = 0;
 		}
@@ -1602,8 +1614,9 @@ static errcode_t ext2fs_calculate_summar
 		count++;
 		if ((count == fs->super->s_inodes_per_group) ||
 		    (ino == fs->super->s_inodes_count)) {
-			fs->group_desc[group++].bg_free_inodes_count =
-				group_free;
+			gdp = ext2_get_group_desc(fs, group);
+			gdp->bg_free_inodes_count = group_free;
+			group++;
 			count = 0;
 			group_free = 0;
 		}
Index: e2fsprogs-1.39-tyt3-v7/misc/dumpe2fs.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/misc/dumpe2fs.c	2007-06-21 16:39:32.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/misc/dumpe2fs.c	2007-06-21 16:44:41.000000000 +0200
@@ -111,10 +111,12 @@ static void print_bg_opt(int bg_flags, i
 static void print_bg_opts(ext2_filsys fs, dgrp_t i)
 {
 	int first = 1, bg_flags;
+	struct ext4_group_desc *gdp;
 
-	if (fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_LAZY_BG)
-		bg_flags = fs->group_desc[i].bg_flags;
-	else
+	if (fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_LAZY_BG) {
+		gdp = ext2_get_group_desc(fs, i);
+		bg_flags = gdp->bg_flags;
+	} else
 		bg_flags = 0;
 
 	print_bg_opt(bg_flags, EXT2_BG_INODE_UNINIT, "Inode not init",
@@ -135,6 +137,7 @@ static void list_desc (ext2_filsys fs)
 	char *block_bitmap=NULL, *inode_bitmap=NULL;
 	int inode_blocks_per_group, old_desc_blocks, reserved_gdt;
 	int has_super;
+	struct ext4_group_desc *gdp;
 
 	if (fs->block_map)
 		block_bitmap = fs->block_map->bitmap;
@@ -188,27 +191,28 @@ static void list_desc (ext2_filsys fs)
 		if (has_super)
 			fputc('\n', stdout);
 		fputs(_("  Block bitmap at "), stdout);
-		print_number(fs->group_desc[i].bg_block_bitmap);
-		diff = fs->group_desc[i].bg_block_bitmap - first_block;
+		print_number(ext2_block_bitmap(fs, i));
+		diff = ext2_block_bitmap(fs, i) - first_block;
 		if (diff >= 0)
 			printf(" (+%ld)", diff);
 		fputs(_(", Inode bitmap at "), stdout);
-		print_number(fs->group_desc[i].bg_inode_bitmap);
-		diff = fs->group_desc[i].bg_inode_bitmap - first_block;
+		print_number(ext2_inode_bitmap(fs, i));
+		diff = ext2_inode_bitmap(fs, i) - first_block;
 		if (diff >= 0)
 			printf(" (+%ld)", diff);
 		fputs(_("\n  Inode table at "), stdout);
-		print_range(fs->group_desc[i].bg_inode_table,
-			    fs->group_desc[i].bg_inode_table +
+		print_range(ext2_inode_table(fs, i),
+			    ext2_inode_table(fs, i) +
 			    inode_blocks_per_group - 1);
-		diff = fs->group_desc[i].bg_inode_table - first_block;
+		diff = ext2_inode_table(fs, i) - first_block;
 		if (diff > 0)
 			printf(" (+%ld)", diff);
+		gdp = ext2_get_group_desc(fs, i);
 		printf (_("\n  %d free blocks, %d free inodes, "
 			  "%d directories\n"),
-			fs->group_desc[i].bg_free_blocks_count,
-			fs->group_desc[i].bg_free_inodes_count,
-			fs->group_desc[i].bg_used_dirs_count);
+			gdp->bg_free_blocks_count,
+			gdp->bg_free_inodes_count,
+			gdp->bg_used_dirs_count);
 		if (block_bitmap) {
 			fputs(_("  Free blocks: "), stdout);
 			print_free (i, block_bitmap,
Index: e2fsprogs-1.39-tyt3-v7/e2fsck/swapfs.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/e2fsck/swapfs.c	2007-06-21 16:39:32.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/e2fsck/swapfs.c	2007-06-21 16:44:41.000000000 +0200
@@ -131,7 +131,7 @@ static void swap_inodes(e2fsck_t ctx)
 						    "block interate buffer");
 	for (group = 0; group < fs->group_desc_count; group++) {
 		retval = io_channel_read_blk(fs->io,
-		      fs->group_desc[group].bg_inode_table,
+		      ext2_inode_table(fs, group),
 		      fs->inode_blocks_per_group, buf);
 		if (retval) {
 			com_err("swap_inodes", retval,
@@ -169,7 +169,7 @@ static void swap_inodes(e2fsck_t ctx)
 				ext2fs_swap_inode(fs, inode, inode, 1);
 		}
 		retval = io_channel_write_blk(fs->io,
-		      fs->group_desc[group].bg_inode_table,
+		      ext2_inode_table(fs, group),
 		      fs->inode_blocks_per_group, buf);
 		if (retval) {
 			com_err("swap_inodes", retval,
Index: e2fsprogs-1.39-tyt3-v7/resize/main.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/resize/main.c	2007-06-21 16:39:32.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/resize/main.c	2007-06-21 16:44:41.000000000 +0200
@@ -106,11 +106,11 @@ static void determine_fs_stride(ext2_fil
 		has_sb = ext2fs_bg_has_super(fs, group);
 		if (group == 0 || has_sb != prev_has_sb)
 			goto next;
-		b_stride = fs->group_desc[group].bg_block_bitmap - 
-			fs->group_desc[group-1].bg_block_bitmap - 
+		b_stride = ext2_block_bitmap(fs, group) -
+			ext2_block_bitmap(fs, group-1) -
 			fs->super->s_blocks_per_group;
-		i_stride = fs->group_desc[group].bg_inode_bitmap - 
-			fs->group_desc[group-1].bg_inode_bitmap - 
+		i_stride = ext2_inode_bitmap(fs, group) -
+			ext2_inode_bitmap(fs, group-1) -
 			fs->super->s_blocks_per_group;
 		if (b_stride != i_stride ||
 		    b_stride < 0)
Index: e2fsprogs-1.39-tyt3-v7/misc/mke2fs.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/misc/mke2fs.c	2007-06-21 16:39:32.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/misc/mke2fs.c	2007-06-21 16:44:41.000000000 +0200
@@ -221,6 +221,7 @@ static void handle_bad_blocks(ext2_filsy
 	blk_t			group_block;
 	int			group;
 	int			group_bad;
+	struct ext4_group_desc *gdp;
 
 	if (!bb_list)
 		return;
@@ -262,7 +263,8 @@ _("Warning: the backup superblock/group 
 						group_block);
 				group_bad++;
 				group = ext2fs_group_of_blk(fs, group_block+j);
-				fs->group_desc[group].bg_free_blocks_count++;
+				gdp = ext2_get_group_desc(fs, group);
+				gdp->bg_free_blocks_count++;
 				EXT2_FREE_BLOCKS_COUNT_SET(fs->super, EXT2_FREE_BLOCKS_COUNT(fs->super) + 1);
 			}
 		}
@@ -406,6 +408,7 @@ static void write_inode_tables(ext2_fils
 	int		num;
 	struct progress_struct progress;
 	int		lazy_flag = 0;
+	struct ext4_group_desc *gdp;
 
 	if (quiet)
 		memset(&progress, 0, sizeof(progress));
@@ -420,11 +423,12 @@ static void write_inode_tables(ext2_fils
 	for (i = 0; i < fs->group_desc_count; i++) {
 		progress_update(&progress, i);
 		
-		blk = fs->group_desc[i].bg_inode_table;
+		blk = ext2_inode_table(fs, i);
 		num = fs->inode_blocks_per_group;
 
+		gdp = ext2_get_group_desc(fs, i);
 		if (!(lazy_flag &&
-		      (fs->group_desc[i].bg_flags & EXT2_BG_INODE_UNINIT))) {
+		      (gdp->bg_flags & EXT2_BG_INODE_UNINIT))) {
 			retval = zero_blocks(fs, blk, num, 0, &blk, &num);
 			if (retval) {
 				fprintf(stderr, _("\nCould not write %d "
@@ -449,14 +453,15 @@ static void setup_lazy_bg(ext2_filsys fs
 	dgrp_t i;
 	int blks;
 	struct ext2_super_block *sb = fs->super;
-	struct ext2_group_desc *bg = fs->group_desc;
+	struct ext4_group_desc *bg;
 
 	if (EXT2_HAS_COMPAT_FEATURE(fs->super, 
 				    EXT2_FEATURE_COMPAT_LAZY_BG)) {
-		for (i = 0; i < fs->group_desc_count; i++, bg++) {
+		for (i = 0; i < fs->group_desc_count; i++) {
 			if ((i == 0) ||
 			    (i == fs->group_desc_count-1))
 				continue;
+			bg = ext2_get_group_desc(fs, i);
 			if (bg->bg_free_inodes_count ==
 			    sb->s_inodes_per_group) {
 				bg->bg_free_inodes_count = 0;
@@ -560,11 +565,13 @@ static void reserve_inodes(ext2_filsys f
 {
 	ext2_ino_t	i;
 	int		group;
+	struct ext4_group_desc *gdp;
 
 	for (i = EXT2_ROOT_INO + 1; i < EXT2_FIRST_INODE(fs->super); i++) {
 		ext2fs_mark_inode_bitmap(fs->inode_map, i);
 		group = ext2fs_group_of_ino(fs, i);
-		fs->group_desc[group].bg_free_inodes_count--;
+		gdp = ext2_get_group_desc(fs, group);
+		gdp->bg_free_inodes_count--;
 		fs->super->s_free_inodes_count--;
 	}
 	ext2fs_mark_ib_dirty(fs);
@@ -687,7 +694,7 @@ static void show_stats(ext2_filsys fs)
 	printf(_("First data block=%u\n"), s->s_first_data_block);
 	if (s->s_reserved_gdt_blocks)
 		printf(_("Maximum filesystem blocks=%lu\n"),
-		       (s->s_reserved_gdt_blocks + fs->desc_blocks) *
+		       (blk_t)(s->s_reserved_gdt_blocks + fs->desc_blocks) *
 		       EXT2_DESC_PER_BLOCK(s) * s->s_blocks_per_group);
 	if (fs->group_desc_count > 1)
 		printf(_("%u block groups\n"), fs->group_desc_count);
Index: e2fsprogs-1.39-tyt3-v7/lib/ext2fs/inode.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/lib/ext2fs/inode.c	2007-06-21 16:39:32.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/lib/ext2fs/inode.c	2007-06-21 16:44:41.000000000 +0200
@@ -142,8 +142,8 @@ errcode_t ext2fs_open_inode_scan(ext2_fi
 	scan->current_group = 0;
 	scan->groups_left = fs->group_desc_count - 1;
 	scan->inode_buffer_blocks = buffer_blocks ? buffer_blocks : 8;
-	scan->current_block = scan->fs->
-		group_desc[scan->current_group].bg_inode_table;
+	scan->current_block =
+		ext2_inode_table(scan->fs, scan->current_group);
 	scan->inodes_left = EXT2_INODES_PER_GROUP(scan->fs->super);
 	scan->blocks_left = scan->fs->inode_blocks_per_group;
 	retval = ext2fs_get_mem((size_t) (scan->inode_buffer_blocks * 
@@ -221,8 +221,8 @@ static errcode_t get_next_blockgroup(ext
 	scan->current_group++;
 	scan->groups_left--;
 			
-	scan->current_block = scan->fs->
-		group_desc[scan->current_group].bg_inode_table;
+	scan->current_block =
+		ext2_inode_table(scan->fs, scan->current_group);
 
 	scan->current_inode = scan->current_group *
 		EXT2_INODES_PER_GROUP(scan->fs->super);
@@ -386,6 +386,7 @@ errcode_t ext2fs_get_next_inode_full(ext
 {
 	errcode_t	retval;
 	int		extra_bytes = 0;
+	struct ext4_group_desc *gdp;
 	
 	EXT2_CHECK_MAGIC(scan, EXT2_ET_MAGIC_INODE_SCAN);
 
@@ -413,9 +414,9 @@ errcode_t ext2fs_get_next_inode_full(ext
 	 * These checks are done outside the above if statement so 
 	 * they can be done for block group #0.
 	 */
+	gdp = ext2_get_group_desc(scan->fs, scan->current_group);
 	if ((scan->scan_flags & EXT2_SF_DO_LAZY) &&
-	    (scan->fs->group_desc[scan->current_group].bg_flags &
-	     EXT2_BG_INODE_UNINIT))
+	    (gdp->bg_flags & EXT2_BG_INODE_UNINIT))
 		goto force_new_group;
 	if (scan->current_block == 0) {
 		if (scan->scan_flags & EXT2_SF_SKIP_MISSING_ITABLE) {
@@ -546,9 +547,9 @@ errcode_t ext2fs_read_inode_full(ext2_fi
 		offset = ((ino - 1) % EXT2_INODES_PER_GROUP(fs->super)) *
 			EXT2_INODE_SIZE(fs->super);
 		block = offset >> EXT2_BLOCK_SIZE_BITS(fs->super);
-		if (!fs->group_desc[(unsigned)group].bg_inode_table)
+		if (!ext2_inode_table(fs, group))
 			return EXT2_ET_MISSING_INODE_TABLE;
-		block_nr = fs->group_desc[(unsigned)group].bg_inode_table + 
+		block_nr = ext2_inode_table(fs, group) +
 			block;
 		io = fs->io;
 	}
@@ -669,11 +670,11 @@ errcode_t ext2fs_write_inode_full(ext2_f
 	offset = ((ino - 1) % EXT2_INODES_PER_GROUP(fs->super)) *
 		EXT2_INODE_SIZE(fs->super);
 	block = offset >> EXT2_BLOCK_SIZE_BITS(fs->super);
-	if (!fs->group_desc[(unsigned) group].bg_inode_table) {
+	if (!ext2_inode_table(fs, group)) {
 		retval = EXT2_ET_MISSING_INODE_TABLE;
 		goto errout;
 	}
-	block_nr = fs->group_desc[(unsigned) group].bg_inode_table + block;
+	block_nr = ext2_inode_table(fs, group) + block;
 
 	offset &= (EXT2_BLOCK_SIZE(fs->super) - 1);
 
Index: e2fsprogs-1.39-tyt3-v7/e2fsck/pass1b.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/e2fsck/pass1b.c	2007-06-21 16:39:32.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/e2fsck/pass1b.c	2007-06-21 16:44:41.000000000 +0200
@@ -816,15 +816,15 @@ static int check_if_fs_block(e2fsck_t ct
 		}
 		
 		/* Check the inode table */
-		if ((fs->group_desc[i].bg_inode_table) &&
-		    (test_block >= fs->group_desc[i].bg_inode_table) &&
-		    (test_block < (fs->group_desc[i].bg_inode_table +
+		if (ext2_inode_table(fs, i) &&
+		    (test_block >= ext2_inode_table(fs, i)) &&
+		    (test_block < (ext2_inode_table(fs, i) +
 				   fs->inode_blocks_per_group)))
 			return 1;
 
 		/* Check the bitmap blocks */
-		if ((test_block == fs->group_desc[i].bg_block_bitmap) ||
-		    (test_block == fs->group_desc[i].bg_inode_bitmap))
+		if ((test_block == ext2_block_bitmap(fs, i)) ||
+		    (test_block == ext2_inode_bitmap(fs, i)))
 			return 1;
 		
 		first_block += fs->super->s_blocks_per_group;
Index: e2fsprogs-1.39-tyt3-v7/e2fsck/pass1.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/e2fsck/pass1.c	2007-06-21 16:39:32.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/e2fsck/pass1.c	2007-06-21 16:44:41.000000000 +0200
@@ -1882,16 +1882,16 @@ static char *describe_illegal_block(ext2
 				"of group %d", i);
 			break;
 		}
-		if (block == fs->group_desc[i].bg_block_bitmap) {
+		if (block == ext2_block_bitmap(fs, i)) {
 			sprintf(problem, "is the block bitmap of group %d", i);
 			break;
 		}
-		if (block == fs->group_desc[i].bg_inode_bitmap) {
+		if (block == ext2_inode_bitmap(fs, i)) {
 			sprintf(problem, "is the inode bitmap of group %d", i);
 			break;
 		}
-		if (block >= fs->group_desc[i].bg_inode_table &&
-		    (block < fs->group_desc[i].bg_inode_table
+		if (block >= ext2_inode_table(fs, i) &&
+		    (block < ext2_inode_table(fs, i)
 		     + fs->inode_blocks_per_group)) {
 			sprintf(problem, "is in the inode table of group %d",
 				i);
@@ -2197,22 +2197,22 @@ static int process_bad_block(ext2_filsys
 			return 0;
 		}
 	skip_super:
-		if (blk == fs->group_desc[i].bg_block_bitmap) {
+		if (blk == ext2_block_bitmap(fs, i)) {
 			if (fix_problem(ctx, PR_1_BB_BAD_BLOCK, pctx)) {
 				ctx->invalid_block_bitmap_flag[i]++;
 				ctx->invalid_bitmaps++;
 			}
 			return 0;
 		}
-		if (blk == fs->group_desc[i].bg_inode_bitmap) {
+		if (blk == ext2_inode_bitmap(fs, i)) {
 			if (fix_problem(ctx, PR_1_IB_BAD_BLOCK, pctx)) {
 				ctx->invalid_inode_bitmap_flag[i]++;
 				ctx->invalid_bitmaps++;
 			}
 			return 0;
 		}
-		if ((blk >= fs->group_desc[i].bg_inode_table) &&
-		    (blk < (fs->group_desc[i].bg_inode_table +
+		if ((blk >= ext2_inode_table(fs, i)) &&
+		    (blk < (ext2_inode_table(fs, i) +
 			    fs->inode_blocks_per_group))) {
 			/*
 			 * If there are bad blocks in the inode table,
@@ -2318,22 +2318,28 @@ static void handle_fs_bad_blocks(e2fsck_
 	ext2_filsys fs = ctx->fs;
 	dgrp_t		i;
 	blk_t		first_block;
+	blk_t		blk;
 
 	for (i = 0; i < fs->group_desc_count; i++) {
 		first_block = ext2fs_group_first_block(fs, i);
 
 		if (ctx->invalid_block_bitmap_flag[i]) {
+			blk = ext2_block_bitmap(fs, i);
 			new_table_block(ctx, first_block, i, _("block bitmap"),
-					1, &fs->group_desc[i].bg_block_bitmap);
+					1, &blk);
+			ext2_block_bitmap_set(fs, i, blk);
 		}
 		if (ctx->invalid_inode_bitmap_flag[i]) {
+			blk = ext2_inode_bitmap(fs, i);
 			new_table_block(ctx, first_block, i, _("inode bitmap"),
-					1, &fs->group_desc[i].bg_inode_bitmap);
+					1, &blk);
+			ext2_inode_bitmap_set(fs, i, blk);
 		}
 		if (ctx->invalid_inode_table_flag[i]) {
+			blk = ext2_inode_table(fs, i);
 			new_table_block(ctx, first_block, i, _("inode table"),
-					fs->inode_blocks_per_group, 
-					&fs->group_desc[i].bg_inode_table);
+					fs->inode_blocks_per_group, &blk); 
+			ext2_inode_table_set(fs, i, blk);
 			ctx->flags |= E2F_FLAG_RESTART;
 		}
 	}
@@ -2362,8 +2368,8 @@ static void mark_table_blocks(e2fsck_t c
 		/*
 		 * Mark the blocks used for the inode table
 		 */
-		if (fs->group_desc[i].bg_inode_table) {
-			for (j = 0, b = fs->group_desc[i].bg_inode_table;
+		if (ext2_inode_table(fs, i)) {
+			for (j = 0, b = ext2_inode_table(fs, i);
 			     j < fs->inode_blocks_per_group;
 			     j++, b++) {
 				if (ext2fs_test_block_bitmap(ctx->block_found_map,
@@ -2384,34 +2390,34 @@ static void mark_table_blocks(e2fsck_t c
 		/*
 		 * Mark block used for the block bitmap 
 		 */
-		if (fs->group_desc[i].bg_block_bitmap) {
+		if (ext2_block_bitmap(fs, i)) {
 			if (ext2fs_test_block_bitmap(ctx->block_found_map,
-				     fs->group_desc[i].bg_block_bitmap)) {
-				pctx.blk = fs->group_desc[i].bg_block_bitmap;
+				     ext2_block_bitmap(fs, i))) {
+				pctx.blk = ext2_block_bitmap(fs, i);
 				if (fix_problem(ctx, PR_1_BB_CONFLICT, &pctx)) {
 					ctx->invalid_block_bitmap_flag[i]++;
 					ctx->invalid_bitmaps++;
 				}
 			} else {
 			    ext2fs_mark_block_bitmap(ctx->block_found_map,
-				     fs->group_desc[i].bg_block_bitmap);
+				     ext2_block_bitmap(fs, i));
 		    }
 			
 		}
 		/*
 		 * Mark block used for the inode bitmap 
 		 */
-		if (fs->group_desc[i].bg_inode_bitmap) {
+		if (ext2_inode_bitmap(fs, i)) {
 			if (ext2fs_test_block_bitmap(ctx->block_found_map,
-				     fs->group_desc[i].bg_inode_bitmap)) {
-				pctx.blk = fs->group_desc[i].bg_inode_bitmap;
+				     ext2_inode_bitmap(fs, i))) {
+				pctx.blk = ext2_inode_bitmap(fs, i);
 				if (fix_problem(ctx, PR_1_IB_CONFLICT, &pctx)) {
 					ctx->invalid_inode_bitmap_flag[i]++;
 					ctx->invalid_bitmaps++;
 				} 
 			} else {
 			    ext2fs_mark_block_bitmap(ctx->block_found_map,
-				     fs->group_desc[i].bg_inode_bitmap);
+				     ext2_inode_bitmap(fs, i));
 			}
 		}
 	}
Index: e2fsprogs-1.39-tyt3-v7/e2fsck/super.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/e2fsck/super.c	2007-06-21 16:39:32.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/e2fsck/super.c	2007-06-21 16:44:41.000000000 +0200
@@ -471,7 +471,7 @@ void check_super_block(e2fsck_t ctx)
 	ext2_filsys fs = ctx->fs;
 	blk_t	first_block, last_block;
 	struct ext2_super_block *sb = fs->super;
-	struct ext2_group_desc *gd;
+	struct ext4_group_desc *gd;
 	blk_t	blocks_per_group = fs->super->s_blocks_per_group;
 	blk_t	bpg_max;
 	int	inodes_per_block;
@@ -598,40 +598,41 @@ void check_super_block(e2fsck_t ctx)
 	 */
 	first_block =  sb->s_first_data_block;
 
-	for (i = 0, gd=fs->group_desc; i < fs->group_desc_count; i++, gd++) {
+	for (i = 0; i < fs->group_desc_count; i++) {
 		pctx.group = i;
+		gd = ext2_get_group_desc(fs, i);
 
 		first_block = ext2fs_group_first_block(fs, i);
 		last_block = ext2fs_group_last_block(fs, i);
 
-		if ((gd->bg_block_bitmap < first_block) ||
-		    (gd->bg_block_bitmap > last_block)) {
-			pctx.blk = gd->bg_block_bitmap;
+		if ((ext2_block_bitmap(fs, i) < first_block) ||
+		    (ext2_block_bitmap(fs, i) > last_block)) {
+			pctx.blk = ext2_block_bitmap(fs, i);
 			if (fix_problem(ctx, PR_0_BB_NOT_GROUP, &pctx))
-				gd->bg_block_bitmap = 0;
+				ext2_block_bitmap_set(fs, i, 0UL);
 		}
-		if (gd->bg_block_bitmap == 0) {
+		if (!ext2_block_bitmap(fs, i)) {
 			ctx->invalid_block_bitmap_flag[i]++;
 			ctx->invalid_bitmaps++;
 		}
-		if ((gd->bg_inode_bitmap < first_block) ||
-		    (gd->bg_inode_bitmap > last_block)) {
-			pctx.blk = gd->bg_inode_bitmap;
+		if ((ext2_inode_bitmap(fs, i) < first_block) ||
+		    (ext2_inode_bitmap(fs, i) > last_block)) {
+			pctx.blk = ext2_inode_bitmap(fs, i);
 			if (fix_problem(ctx, PR_0_IB_NOT_GROUP, &pctx))
-				gd->bg_inode_bitmap = 0;
+				ext2_inode_bitmap_set(fs, i, 0UL);
 		}
-		if (gd->bg_inode_bitmap == 0) {
+		if (!ext2_inode_bitmap(fs, i)) {
 			ctx->invalid_inode_bitmap_flag[i]++;
 			ctx->invalid_bitmaps++;
 		}
-		if ((gd->bg_inode_table < first_block) ||
-		    ((gd->bg_inode_table +
+		if ((ext2_inode_table(fs, i) < first_block) ||
+		    ((ext2_inode_table(fs, i) +
 		      fs->inode_blocks_per_group - 1) > last_block)) {
-			pctx.blk = gd->bg_inode_table;
+			pctx.blk = ext2_inode_table(fs, i);
 			if (fix_problem(ctx, PR_0_ITABLE_NOT_GROUP, &pctx))
-				gd->bg_inode_table = 0;
+				ext2_inode_table_set(fs, i, 0UL);
 		}
-		if (gd->bg_inode_table == 0) {
+		if (!ext2_inode_table(fs, i)) {
 			ctx->invalid_inode_table_flag[i]++;
 			ctx->invalid_bitmaps++;
 		}
Index: e2fsprogs-1.39-tyt3-v7/misc/e2image.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/misc/e2image.c	2007-06-21 16:39:32.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/misc/e2image.c	2007-06-21 16:44:41.000000000 +0200
@@ -265,8 +265,8 @@ static void mark_table_blocks(ext2_filsy
 		/*
 		 * Mark the blocks used for the inode table
 		 */
-		if (fs->group_desc[i].bg_inode_table) {
-			for (j = 0, b = fs->group_desc[i].bg_inode_table;
+		if (ext2_inode_table(fs, i)) {
+			for (j = 0, b = ext2_inode_table(fs, i);
 			     j < (unsigned) fs->inode_blocks_per_group;
 			     j++, b++)
 				ext2fs_mark_block_bitmap(meta_block_map, b);
@@ -275,17 +275,17 @@ static void mark_table_blocks(ext2_filsy
 		/*
 		 * Mark block used for the block bitmap 
 		 */
-		if (fs->group_desc[i].bg_block_bitmap) {
+		if (ext2_block_bitmap(fs, i)) {
 			ext2fs_mark_block_bitmap(meta_block_map,
-				     fs->group_desc[i].bg_block_bitmap);
+					ext2_block_bitmap(fs, i));
 		}
 		
 		/*
 		 * Mark block used for the inode bitmap 
 		 */
-		if (fs->group_desc[i].bg_inode_bitmap) {
+		if (ext2_inode_bitmap(fs, i)) {
 			ext2fs_mark_block_bitmap(meta_block_map,
-				 fs->group_desc[i].bg_inode_bitmap);
+					ext2_inode_bitmap(fs, i));
 		}
 	}
 }
Index: e2fsprogs-1.39-tyt3-v7/lib/ext2fs/tst_iscan.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/lib/ext2fs/tst_iscan.c	2007-06-21 16:39:32.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/lib/ext2fs/tst_iscan.c	2007-06-21 16:44:41.000000000 +0200
@@ -182,7 +182,7 @@ static void check_map(void)
 		ext2fs_mark_block_bitmap(touched_map, test_vec[i]);
 	}
 	for (i = 0; i < test_fs->group_desc_count; i++) {
-		for (j=0, blk = test_fs->group_desc[i].bg_inode_table;
+		for (j=0, blk = ext2_inode_table(test_fs, i);
 		     j < test_fs->inode_blocks_per_group;
 		     j++, blk++) {
 			if (!ext2fs_test_block_bitmap(touched_map, blk) &&
Index: e2fsprogs-1.39-tyt3-v7/lib/ext2fs/imager.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/lib/ext2fs/imager.c	2007-06-21 16:39:32.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/lib/ext2fs/imager.c	2007-06-21 16:44:41.000000000 +0200
@@ -71,7 +71,7 @@ errcode_t ext2fs_image_inode_write(ext2_
 		return ENOMEM;
 	
 	for (group = 0; group < fs->group_desc_count; group++) {
-		blk = fs->group_desc[(unsigned)group].bg_inode_table;
+		blk = ext2_inode_table(fs, group);
 		if (!blk) {
 			retval = EXT2_ET_MISSING_INODE_TABLE;
 			goto errout;
@@ -145,7 +145,7 @@ errcode_t ext2fs_image_inode_read(ext2_f
 		return ENOMEM;
 	
 	for (group = 0; group < fs->group_desc_count; group++) {
-		blk = fs->group_desc[(unsigned)group].bg_inode_table;
+		blk = ext2_inode_table(fs, group);
 		if (!blk) {
 			retval = EXT2_ET_MISSING_INODE_TABLE;
 			goto errout;
Index: e2fsprogs-1.39-tyt3-v7/lib/ext2fs/ext2fs.h
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/lib/ext2fs/ext2fs.h	2007-06-21 16:39:32.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/lib/ext2fs/ext2fs.h	2007-06-21 16:44:41.000000000 +0200
@@ -1038,7 +1038,8 @@ extern errcode_t ext2fs_copy_bitmap(ext2
 extern void ext2fs_swap_ext_attr(char *to, char *from, int bufsize, 
 				 int has_header);
 extern void ext2fs_swap_super(struct ext2_super_block * super);
-extern void ext2fs_swap_group_desc(struct ext2_group_desc *gdp);
+extern void ext2fs_swap_group_desc(struct ext2_super_block *super,
+				struct ext4_group_desc *gdp);
 extern void ext2fs_swap_extent_header(struct ext3_extent_header *eh);
 extern void ext2fs_swap_extent_index(struct ext3_extent_idx *ix);
 extern void ext2fs_swap_extent(struct ext3_extent *ex);
@@ -1084,6 +1085,14 @@ extern blk_t ext2fs_group_last_block(ext
 extern blk_t ext2fs_inode_data_blocks(ext2_filsys fs,
 				      struct ext2_inode *inode);
 extern unsigned long ext2fs_div_ceil(unsigned long a, unsigned long b);
+extern blk_t ext2_block_bitmap(ext2_filsys fs, dgrp_t group);
+extern blk_t ext2_inode_bitmap(ext2_filsys fs, dgrp_t group);
+extern blk_t ext2_inode_table(ext2_filsys fs, dgrp_t group);
+extern void ext2_block_bitmap_set(ext2_filsys fs, dgrp_t group, blk_t blk);
+extern void ext2_inode_bitmap_set(ext2_filsys fs, dgrp_t group, blk_t blk);
+extern void ext2_inode_table_set(ext2_filsys fs, dgrp_t group, blk_t blk);
+extern struct ext4_group_desc *ext2_get_group_desc(ext2_filsys fs,
+							dgrp_t group);
 
 /*
  * The actual inlined functions definitions themselves...
@@ -1284,6 +1293,127 @@ _INLINE_ unsigned long ext2fs_div_ceil(u
 		return 0;
 	return ((a - 1) / b) + 1;
 }
+
+/*
+ * Return the block bitmap block of a group
+ */
+_INLINE_ blk_t ext2_block_bitmap(ext2_filsys fs, dgrp_t group)
+{
+	struct ext4_group_desc *gdp;
+
+	if (EXT2_HAS_INCOMPAT_FEATURE(fs->super, EXT4_FEATURE_INCOMPAT_64BIT)
+	    && fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT) {
+		gdp = (struct ext4_group_desc *) (fs->group_desc) + group;
+		return ((blk64_t) gdp->bg_block_bitmap_hi << 32) +
+			gdp->bg_block_bitmap;
+	} else {
+		gdp = (struct ext4_group_desc *) (fs->group_desc + group);
+		return (blk_t) (gdp->bg_block_bitmap);
+	}
+}
+
+/*
+ * Return the inode bitmap block of a group
+ */
+_INLINE_ blk_t ext2_inode_bitmap(ext2_filsys fs, dgrp_t group)
+{
+	struct ext4_group_desc *gdp;
+
+	if (EXT2_HAS_INCOMPAT_FEATURE(fs->super, EXT4_FEATURE_INCOMPAT_64BIT)
+	    && fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT) {
+		gdp = (struct ext4_group_desc *) (fs->group_desc) + group;
+		return ((blk64_t) gdp->bg_inode_bitmap_hi << 32) +
+			gdp->bg_inode_bitmap;
+	} else {
+		gdp = (struct ext4_group_desc *) (fs->group_desc + group);
+		return (blk_t) (gdp->bg_inode_bitmap);
+	}
+}
+
+/*
+ * Return the inode table block of a group
+ */
+_INLINE_ blk_t ext2_inode_table(ext2_filsys fs, dgrp_t group)
+{
+	struct ext4_group_desc *gdp;
+
+	if (EXT2_HAS_INCOMPAT_FEATURE(fs->super, EXT4_FEATURE_INCOMPAT_64BIT)
+	    && fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT) {
+		gdp = (struct ext4_group_desc *) (fs->group_desc) + group;
+		return ((blk64_t) gdp->bg_inode_table_hi << 32) +
+			gdp->bg_inode_table;
+	} else {
+		gdp = (struct ext4_group_desc *) (fs->group_desc + group);
+		return (blk_t) (gdp->bg_inode_table);
+	}
+}
+
+/*
+ * Set the block bitmap block of a group
+ */
+_INLINE_ void ext2_block_bitmap_set(ext2_filsys fs, dgrp_t group, blk_t blk)
+{
+	struct ext4_group_desc *gdp;
+
+	if (EXT2_HAS_INCOMPAT_FEATURE(fs->super, EXT4_FEATURE_INCOMPAT_64BIT)
+	    && fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT) {
+		gdp = (struct ext4_group_desc *) (fs->group_desc) + group;
+		gdp->bg_block_bitmap = (__u32)(blk);
+		gdp->bg_block_bitmap_hi = (__u64)(blk) >> 32;
+	} else {
+		gdp = (struct ext4_group_desc *) (fs->group_desc + group);
+		gdp->bg_block_bitmap = (__u32)(blk);
+	}
+}
+
+/*
+ * Set the inode bitmap block of a group
+ */
+_INLINE_ void ext2_inode_bitmap_set(ext2_filsys fs, dgrp_t group, blk_t blk)
+{
+	struct ext4_group_desc *gdp;
+
+	if (EXT2_HAS_INCOMPAT_FEATURE(fs->super, EXT4_FEATURE_INCOMPAT_64BIT)
+	    && fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT) {
+		gdp = (struct ext4_group_desc *) (fs->group_desc) + group;
+		gdp->bg_inode_bitmap = (__u32)(blk);
+		gdp->bg_inode_bitmap_hi = (__u64)(blk) >> 32;
+	} else {
+		gdp = (struct ext4_group_desc *) (fs->group_desc + group);
+		gdp->bg_inode_bitmap = (__u32)(blk);
+	}
+}
+
+/*
+ * Set the inode table block of a group
+ */
+_INLINE_ void ext2_inode_table_set(ext2_filsys fs, dgrp_t group, blk_t blk)
+{
+	struct ext4_group_desc *gdp;
+
+	if (EXT2_HAS_INCOMPAT_FEATURE(fs->super, EXT4_FEATURE_INCOMPAT_64BIT)
+	    && fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT) {
+		gdp = (struct ext4_group_desc *) (fs->group_desc) + group;
+		gdp->bg_inode_table = (__u32)(blk);
+		gdp->bg_inode_table_hi = (__u64)(blk) >> 32;
+	} else {
+		gdp = (struct ext4_group_desc *) (fs->group_desc + group);
+		gdp->bg_inode_table = (__u32)(blk);
+	}
+}
+
+/*
+ * Return the group descriptor of a group
+ */
+_INLINE_ struct ext4_group_desc *ext2_get_group_desc(ext2_filsys fs, dgrp_t group)
+{
+	if (EXT2_HAS_INCOMPAT_FEATURE(fs->super, EXT4_FEATURE_INCOMPAT_64BIT)
+	    && fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT)
+		return (struct ext4_group_desc *) (fs->group_desc) + group;
+	else
+		return (struct ext4_group_desc *) (fs->group_desc + group);
+}
+		
 #undef _INLINE_
 #endif
 
Index: e2fsprogs-1.39-tyt3-v7/lib/ext2fs/openfs.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/lib/ext2fs/openfs.c	2007-06-21 16:39:32.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/lib/ext2fs/openfs.c	2007-06-21 16:44:41.000000000 +0200
@@ -90,6 +90,7 @@ errcode_t ext2fs_open2(const char *name,
 	blk_t		group_block, blk;
 	char		*dest, *cp;
 	struct ext2_group_desc *gdp;
+	struct ext4_group_desc *gdpe;
 	
 	EXT2_CHECK_MAGIC(manager, EXT2_ET_MAGIC_IO_MANAGER);
 
@@ -288,9 +289,18 @@ errcode_t ext2fs_open2(const char *name,
 			goto cleanup;
 #ifdef EXT2FS_ENABLE_SWAPFS
 		if (fs->flags & EXT2_FLAG_SWAP_BYTES) {
-			gdp = (struct ext2_group_desc *) dest;
-			for (j=0; j < groups_per_block; j++)
-				ext2fs_swap_group_desc(gdp++);
+			if (EXT2_HAS_INCOMPAT_FEATURE(fs->super,
+						EXT4_FEATURE_INCOMPAT_64BIT)
+			    && fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT) {
+				gdpe = (struct ext4_group_desc *) dest;
+				for (j=0; j < groups_per_block; j++, gdpe++)
+					ext2fs_swap_group_desc(fs->super, gdpe);
+			} else {
+				gdp = (struct ext2_group_desc *) dest;
+				for (j=0; j < groups_per_block; j++, gdp++)
+					ext2fs_swap_group_desc(fs->super,
+						(struct ext4_group_desc *) gdp);
+			}
 		}
 #endif
 		dest += fs->blocksize;
Index: e2fsprogs-1.39-tyt3-v7/lib/ext2fs/closefs.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/lib/ext2fs/closefs.c	2007-06-21 16:39:32.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/lib/ext2fs/closefs.c	2007-06-21 16:44:41.000000000 +0200
@@ -209,7 +209,7 @@ errcode_t ext2fs_flush(ext2_filsys fs)
 	unsigned long	fs_state;
 	struct ext2_super_block *super_shadow = 0;
 	struct ext2_group_desc *group_shadow = 0;
-	struct ext2_group_desc *s, *t;
+	struct ext4_group_desc *s, *t;
 	char	*group_ptr;
 	int	old_desc_blocks;
 	
@@ -234,10 +234,18 @@ errcode_t ext2fs_flush(ext2_filsys fs)
 		       fs->desc_blocks);
 
 		/* swap the group descriptors */
-		for (j=0, s=fs->group_desc, t=group_shadow;
-		     j < fs->group_desc_count; j++, t++, s++) {
-			*t = *s;
-			ext2fs_swap_group_desc(t);
+		for (j=0; j < fs->group_desc_count; j++) {
+			if (EXT2_HAS_INCOMPAT_FEATURE(fs->super,
+						EXT4_FEATURE_INCOMPAT_64BIT)
+			    && fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT) {
+				s = (struct ext4_group_desc *) (fs->group_desc) + j;
+				t = (struct ext4_group_desc *) (group_shadow) + j;
+				*t = *s;
+			} else {
+				*(group_shadow +j) = *(fs->group_desc + j);
+				t = (struct ext4_group_desc *) (group_shadow +j);
+			}
+			ext2fs_swap_group_desc(fs->super, t);
 		}
 	} else {
 		super_shadow = fs->super;
Index: e2fsprogs-1.39-tyt3-v7/lib/ext2fs/alloc_stats.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/lib/ext2fs/alloc_stats.c	2007-06-21 16:39:32.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/lib/ext2fs/alloc_stats.c	2007-06-21 16:44:41.000000000 +0200
@@ -18,15 +18,17 @@
 void ext2fs_inode_alloc_stats2(ext2_filsys fs, ext2_ino_t ino,
 			       int inuse, int isdir)
 {
+	struct ext4_group_desc *gdp;
 	int	group = ext2fs_group_of_ino(fs, ino);
 
 	if (inuse > 0)
 		ext2fs_mark_inode_bitmap(fs->inode_map, ino);
 	else
 		ext2fs_unmark_inode_bitmap(fs->inode_map, ino);
-	fs->group_desc[group].bg_free_inodes_count -= inuse;
+	gdp = ext2_get_group_desc(fs, group);
+	gdp->bg_free_inodes_count -= inuse;
 	if (isdir)
-		fs->group_desc[group].bg_used_dirs_count += inuse;
+		gdp->bg_used_dirs_count += inuse;
 	fs->super->s_free_inodes_count -= inuse;
 	ext2fs_mark_super_dirty(fs);
 	ext2fs_mark_ib_dirty(fs);
@@ -39,13 +41,15 @@ void ext2fs_inode_alloc_stats(ext2_filsy
 
 void ext2fs_block_alloc_stats(ext2_filsys fs, blk_t blk, int inuse)
 {
+	struct ext4_group_desc *gdp;
 	int	group = ext2fs_group_of_blk(fs, blk);
 
 	if (inuse > 0)
 		ext2fs_mark_block_bitmap(fs->block_map, blk);
 	else
 		ext2fs_unmark_block_bitmap(fs->block_map, blk);
-	fs->group_desc[group].bg_free_blocks_count -= inuse;
+	gdp = ext2_get_group_desc(fs, group);
+	gdp->bg_free_blocks_count -= inuse;
 	EXT2_FREE_BLOCKS_COUNT_SET(fs->super, EXT2_FREE_BLOCKS_COUNT(fs->super) - inuse);
 	ext2fs_mark_super_dirty(fs);
 	ext2fs_mark_bb_dirty(fs);
Index: e2fsprogs-1.39-tyt3-v7/e2fsck/journal.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/e2fsck/journal.c	2007-06-21 16:39:32.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/e2fsck/journal.c	2007-06-21 16:44:41.000000000 +0200
@@ -855,6 +855,7 @@ void e2fsck_move_ext3_journal(e2fsck_t c
 	errcode_t		retval;
 	const char * const *	cpp;
 	int			group, mount_flags;
+	struct ext4_group_desc	*gdp;
 	
 	clear_problem_context(&pctx);
 
@@ -951,7 +952,8 @@ void e2fsck_move_ext3_journal(e2fsck_t c
 	group = ext2fs_group_of_ino(fs, ino);
 	ext2fs_unmark_inode_bitmap(fs->inode_map, ino);
 	ext2fs_mark_ib_dirty(fs);
-	fs->group_desc[group].bg_free_inodes_count++;
+	gdp = ext2_get_group_desc(fs, group);
+	gdp->bg_free_inodes_count++;
 	fs->super->s_free_inodes_count++;
 	return;
 
Index: e2fsprogs-1.39-tyt3-v7/lib/ext2fs/dblist.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/lib/ext2fs/dblist.c	2007-06-21 16:39:32.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/lib/ext2fs/dblist.c	2007-06-21 16:44:41.000000000 +0200
@@ -31,16 +31,18 @@ errcode_t ext2fs_get_num_dirs(ext2_filsy
 {
 	dgrp_t	i;
 	ext2_ino_t	num_dirs, max_dirs;
+	struct ext4_group_desc *gdp;
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 	
 	num_dirs = 0;
 	max_dirs = fs->super->s_inodes_per_group;
 	for (i = 0; i < fs->group_desc_count; i++) {
-		if (fs->group_desc[i].bg_used_dirs_count > max_dirs)
+		gdp = ext2_get_group_desc(fs, i);
+		if (gdp->bg_used_dirs_count > max_dirs)
 			num_dirs += max_dirs / 8;
 		else
-			num_dirs += fs->group_desc[i].bg_used_dirs_count;
+			num_dirs += gdp->bg_used_dirs_count;
 	}
 	if (num_dirs > fs->super->s_inodes_count)
 		num_dirs = fs->super->s_inodes_count;
Index: e2fsprogs-1.39-tyt3-v7/lib/ext2fs/initialize.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/lib/ext2fs/initialize.c	2007-06-21 16:39:32.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/lib/ext2fs/initialize.c	2007-06-21 16:44:41.000000000 +0200
@@ -106,6 +106,7 @@ errcode_t ext2fs_initialize(const char *
 	int		io_flags;
 	char		*buf;
 	char		c;
+	struct ext4_group_desc *gdp;
 
 	if (!param || !EXT2_BLOCKS_COUNT(param))
 		return EXT2_ET_INVALID_ARGUMENT;
@@ -369,10 +370,11 @@ ipg_retry:
 		numblocks = ext2fs_reserve_super_and_bgd(fs, i, fs->block_map);
 
 		EXT2_FREE_BLOCKS_COUNT_SET(super, EXT2_FREE_BLOCKS_COUNT(super) + numblocks);
-		fs->group_desc[i].bg_free_blocks_count = numblocks;
-		fs->group_desc[i].bg_free_inodes_count =
+		gdp = ext2_get_group_desc(fs, i);
+		gdp->bg_free_blocks_count = numblocks;
+		gdp->bg_free_inodes_count =
 			fs->super->s_inodes_per_group;
-		fs->group_desc[i].bg_used_dirs_count = 0;
+		gdp->bg_used_dirs_count = 0;
 	}
 	
 	c = (char) 255;
Index: e2fsprogs-1.39-tyt3-v7/misc/tune2fs.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/misc/tune2fs.c	2007-06-21 16:39:32.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/misc/tune2fs.c	2007-06-21 16:44:41.000000000 +0200
@@ -208,11 +208,13 @@ static int release_blocks_proc(ext2_fils
 {
 	blk_t	block;
 	int	group;
+	struct ext4_group_desc *gdp;
 
 	block = *blocknr;
 	ext2fs_unmark_block_bitmap(fs->block_map,block);
 	group = ext2fs_group_of_blk(fs, block);
-	fs->group_desc[group].bg_free_blocks_count++;
+	gdp = ext2_get_group_desc(fs, group);
+	gdp->bg_free_blocks_count++;
 	EXT2_FREE_BLOCKS_COUNT_SET(fs->super, EXT2_FREE_BLOCKS_COUNT(fs->super) + 1);
 	return 0;
 }

--------------000402010601050503090806--
