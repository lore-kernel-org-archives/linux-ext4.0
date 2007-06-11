From: Valerie Clement <valerie.clement@bull.net>
Subject: [RFC][PATCH 7/12] handling of 64-bit block numbers in group desc
 in e2fsprogs
Date: Mon, 11 Jun 2007 18:45:40 +0200
Message-ID: <466D7C34.20909@bull.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030305010500080002000604"
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:48396 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473AbXFKQoT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Jun 2007 12:44:19 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is a multi-part message in MIME format.
--------------030305010500080002000604
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed

This patch contains the changes to handle 64-bit block numbers stored in
group descriptor structure.


  debugfs/debugfs.c         |    9 +++----
  debugfs/logdump.c         |    4 +--
  e2fsck/pass1.c            |   50 ++++++++++++++++++++++-----------------
  e2fsck/pass1b.c           |   10 +++----
  e2fsck/pass5.c            |    8 +++---
  e2fsck/super.c            |   30 +++++++++++------------
  e2fsck/swapfs.c           |    4 +--
  lib/ext2fs/alloc_tables.c |   12 ++++-----
  lib/ext2fs/check_desc.c   |   12 ++++-----
  lib/ext2fs/ext2_fs.h      |   58 
++++++++++++++++++++++++++++++++++++++++++++++
  lib/ext2fs/imager.c       |    4 +--
  lib/ext2fs/inode.c        |   16 ++++++------
  lib/ext2fs/rw_bitmaps.c   |    8 +++---
  lib/ext2fs/swapfs.c       |    5 +++
  lib/ext2fs/tst_iscan.c    |    2 -
  misc/dumpe2fs.c           |   14 +++++------
  misc/e2image.c            |   12 ++++-----
  misc/mke2fs.c             |    2 -
  resize/main.c             |    8 +++---
  resize/online.c           |    6 ++--
  resize/resize2fs.c        |   54 
+++++++++++++++++++++---------------------
  21 files changed, 199 insertions(+), 129 deletions(-)



--------------030305010500080002000604
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
 name="07-handle-hi-bits-in-group-desc"
Content-Disposition: inline;
 filename="07-handle-hi-bits-in-group-desc"

Index: e2fsprogs-1.39-tyt3-v6/lib/ext2fs/ext2_fs.h
===================================================================
--- e2fsprogs-1.39-tyt3-v6.orig/lib/ext2fs/ext2_fs.h	2007-06-11 12:48:52.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v6/lib/ext2fs/ext2_fs.h	2007-06-11 12:48:54.000000000 +0200
@@ -604,6 +604,38 @@ struct ext2_super_block {
 		(s)->s_free_blocks_count = (v);		\
 		(s)->s_free_blocks_hi = (v) >> 32;	\
 	} while (0)
+
+#define EXT2_BLOCK_BITMAP(bg)		\
+	((bg)->bg_block_bitmap + ((__u64)(bg)->bg_block_bitmap_hi << 32))
+#define EXT2_INODE_BITMAP(bg)		\
+	((bg)->bg_inode_bitmap + ((__u64)(bg)->bg_inode_bitmap_hi << 32))
+#define EXT2_INODE_TABLE(bg)		\
+	((bg)->bg_inode_table  + ((__u64)(bg)->bg_inode_table_hi  << 32))
+
+#define EXT2_BLOCK_BITMAP_SET(bg, v)				\
+	do {							\
+		(bg)->bg_block_bitmap = (__u32)(v);		\
+		(bg)->bg_block_bitmap_hi = (v) >> 32;		\
+	} while(0)
+
+#define EXT2_INODE_BITMAP_SET(bg, v)				\
+	do {							\
+		(bg)->bg_inode_bitmap = (__u32)(v);		\
+		(bg)->bg_inode_bitmap_hi = (v) >> 32;		\
+	} while(0)
+
+#define EXT2_INODE_TABLE_SET(bg, v)				\
+	do {							\
+		(bg)->bg_inode_table = (__u32)(v);		\
+		(bg)->bg_inode_table_hi = (v) >> 32;		\
+	} while(0)
+
+#define EXT2_IS_USED_BLOCK_BITMAP(bg)	\
+	((bg)->bg_block_bitmap != 0 || (bg)->bg_block_bitmap_hi != 0)
+#define EXT2_IS_USED_INODE_BITMAP(bg)	\
+	((bg)->bg_inode_bitmap != 0 || (bg)->bg_inode_bitmap_hi != 0)
+#define EXT2_IS_USED_INODE_TABLE(bg)	\
+	((bg)->bg_inode_table  != 0 || (bg)->bg_inode_table_hi  != 0)
 #else
 #define EXT2_BLOCKS_COUNT(s)		((s)->s_blocks_count)
 #define EXT2_R_BLOCKS_COUNT(s)		((s)->s_r_blocks_count)
@@ -623,6 +655,32 @@ struct ext2_super_block {
 	do {								\
 		(s)->s_free_blocks_count = (v);				\
 	} while (0)
+
+#define EXT2_BLOCK_BITMAP(bg)		(bg)->bg_block_bitmap
+#define EXT2_INODE_BITMAP(bg)		(bg)->bg_inode_bitmap
+#define EXT2_INODE_TABLE(bg)		(bg)->bg_inode_table
+
+#define EXT2_BLOCK_BITMAP_SET(bg, v)				\
+	do {							\
+		(bg)->bg_block_bitmap = (__u32)(v);		\
+	} while(0)
+
+#define EXT2_INODE_BITMAP_SET(bg, v)				\
+	do {							\
+		(bg)->bg_inode_bitmap = (__u32)(v);		\
+	} while(0)
+
+#define EXT2_INODE_TABLE_SET(bg, v)				\
+	do {							\
+		(bg)->bg_inode_table = (__u32)(v);		\
+	} while(0)
+
+#define EXT2_IS_USED_BLOCK_BITMAP(bg)	\
+	((bg)->bg_block_bitmap != 0)
+#define EXT2_IS_USED_INODE_BITMAP(bg)	\
+	((bg)->bg_inode_bitmap != 0)
+#define EXT2_IS_USED_INODE_TABLE(bg)	\
+	((bg)->bg_inode_table != 0)
 #endif
 
 /*
Index: e2fsprogs-1.39-tyt3-v6/lib/ext2fs/check_desc.c
===================================================================
--- e2fsprogs-1.39-tyt3-v6.orig/lib/ext2fs/check_desc.c	2007-06-11 12:48:35.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v6/lib/ext2fs/check_desc.c	2007-06-11 12:48:54.000000000 +0200
@@ -45,22 +45,22 @@ errcode_t ext2fs_check_desc(ext2_filsys 
 		 * Check to make sure block bitmap for group is
 		 * located within the group.
 		 */
-		if (fs->group_desc[i].bg_block_bitmap < first_block ||
-		    fs->group_desc[i].bg_block_bitmap > last_block)
+		if (EXT2_BLOCK_BITMAP(&fs->group_desc[i]) < first_block ||
+			EXT2_BLOCK_BITMAP(&fs->group_desc[i]) > last_block)
 			return EXT2_ET_GDESC_BAD_BLOCK_MAP;
 		/*
 		 * Check to make sure inode bitmap for group is
 		 * located within the group
 		 */
-		if (fs->group_desc[i].bg_inode_bitmap < first_block ||
-		    fs->group_desc[i].bg_inode_bitmap > last_block)
+		if (EXT2_INODE_BITMAP(&fs->group_desc[i]) < first_block ||
+			EXT2_INODE_BITMAP(&fs->group_desc[i]) > last_block)
 			return EXT2_ET_GDESC_BAD_INODE_MAP;
 		/*
 		 * Check to make sure inode table for group is located
 		 * within the group
 		 */
-		if (fs->group_desc[i].bg_inode_table < first_block ||
-		    ((fs->group_desc[i].bg_inode_table +
+		if (EXT2_INODE_TABLE(&fs->group_desc[i]) < first_block ||
+			((EXT2_INODE_TABLE(&fs->group_desc[i]) +
 		      fs->inode_blocks_per_group) > last_block))
 			return EXT2_ET_GDESC_BAD_INODE_TABLE;
 	}
Index: e2fsprogs-1.39-tyt3-v6/lib/ext2fs/alloc_tables.c
===================================================================
--- e2fsprogs-1.39-tyt3-v6.orig/lib/ext2fs/alloc_tables.c	2007-06-11 12:48:35.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v6/lib/ext2fs/alloc_tables.c	2007-06-11 12:48:54.000000000 +0200
@@ -56,7 +56,7 @@ errcode_t ext2fs_allocate_group_table(ex
 	} else
 		start_blk = group_blk;
 
-	if (!fs->group_desc[group].bg_block_bitmap) {
+	if (!EXT2_IS_USED_BLOCK_BITMAP(&fs->group_desc[group])) {
 		retval = ext2fs_get_free_blocks(fs, start_blk, last_blk,
 						1, bmap, &new_blk);
 		if (retval == EXT2_ET_BLOCK_ALLOC_FAIL) 
@@ -65,10 +65,10 @@ errcode_t ext2fs_allocate_group_table(ex
 		if (retval)
 			return retval;
 		ext2fs_mark_block_bitmap(bmap, new_blk);
-		fs->group_desc[group].bg_block_bitmap = new_blk;
+		EXT2_BLOCK_BITMAP_SET(&fs->group_desc[group], new_blk);
 	}
 
-	if (!fs->group_desc[group].bg_inode_bitmap) {
+	if (!EXT2_IS_USED_INODE_BITMAP(&fs->group_desc[group])) {
 		retval = ext2fs_get_free_blocks(fs, start_blk, last_blk,
 						1, bmap, &new_blk);
 		if (retval == EXT2_ET_BLOCK_ALLOC_FAIL) 
@@ -77,13 +77,13 @@ errcode_t ext2fs_allocate_group_table(ex
 		if (retval)
 			return retval;
 		ext2fs_mark_block_bitmap(bmap, new_blk);
-		fs->group_desc[group].bg_inode_bitmap = new_blk;
+		EXT2_INODE_BITMAP_SET(&fs->group_desc[group], new_blk);
 	}
 
 	/*
 	 * Allocate the inode table
 	 */
-	if (!fs->group_desc[group].bg_inode_table) {
+	if (!EXT2_IS_USED_INODE_TABLE(&fs->group_desc[group])) {
 		retval = ext2fs_get_free_blocks(fs, group_blk, last_blk,
 						fs->inode_blocks_per_group,
 						bmap, &new_blk);
@@ -93,7 +93,7 @@ errcode_t ext2fs_allocate_group_table(ex
 		     j < fs->inode_blocks_per_group;
 		     j++, blk++)
 			ext2fs_mark_block_bitmap(bmap, blk);
-		fs->group_desc[group].bg_inode_table = new_blk;
+		EXT2_INODE_TABLE_SET(&fs->group_desc[group], new_blk);
 	}
 
 	
Index: e2fsprogs-1.39-tyt3-v6/e2fsck/pass5.c
===================================================================
--- e2fsprogs-1.39-tyt3-v6.orig/e2fsck/pass5.c	2007-06-11 12:48:52.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v6/e2fsck/pass5.c	2007-06-11 12:48:54.000000000 +0200
@@ -179,12 +179,12 @@ redo_counts:
 			    (i <= super + fs->desc_blocks) &&
 			    ext2fs_bg_has_super(fs, group))
 				bitmap = 1;
-			else if (i == fs->group_desc[group].bg_block_bitmap)
+			else if (i == EXT2_BLOCK_BITMAP(&fs->group_desc[group]))
 				bitmap = 1;
-			else if (i == fs->group_desc[group].bg_inode_bitmap)
+			else if (i == EXT2_INODE_BITMAP(&fs->group_desc[group]))
 				bitmap = 1;
-			else if (i >= fs->group_desc[group].bg_inode_table &&
-				 (i < fs->group_desc[group].bg_inode_table
+			else if (i >= EXT2_INODE_TABLE(&fs->group_desc[group]) &&
+				 (i < EXT2_INODE_TABLE(&fs->group_desc[group])
 				  + fs->inode_blocks_per_group))
 				bitmap = 1;
 			else
Index: e2fsprogs-1.39-tyt3-v6/lib/ext2fs/swapfs.c
===================================================================
--- e2fsprogs-1.39-tyt3-v6.orig/lib/ext2fs/swapfs.c	2007-06-11 12:48:52.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v6/lib/ext2fs/swapfs.c	2007-06-11 12:48:54.000000000 +0200
@@ -95,6 +95,11 @@ void ext2fs_swap_group_desc(struct ext2_
 	gdp->bg_flags = ext2fs_swab16(gdp->bg_flags);
 	gdp->bg_itable_unused = ext2fs_swab16(gdp->bg_itable_unused);
 	gdp->bg_checksum = ext2fs_swab16(gdp->bg_checksum);
+#ifdef _EXT4FS_
+	gdp->bg_block_bitmap_hi = ext2fs_swab32(gdp->bg_block_bitmap_hi);
+	gdp->bg_inode_bitmap_hi = ext2fs_swab32(gdp->bg_inode_bitmap_hi);
+	gdp->bg_inode_table_hi = ext2fs_swab32(gdp->bg_inode_table_hi);
+#endif
 }
 
 void ext2fs_swap_ext_attr(char *to, char *from, int bufsize, int has_header)
Index: e2fsprogs-1.39-tyt3-v6/lib/ext2fs/rw_bitmaps.c
===================================================================
--- e2fsprogs-1.39-tyt3-v6.orig/lib/ext2fs/rw_bitmaps.c	2007-06-11 12:48:52.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v6/lib/ext2fs/rw_bitmaps.c	2007-06-11 12:48:54.000000000 +0200
@@ -108,7 +108,7 @@ static errcode_t write_bitmaps(ext2_fils
 				for (j = nbits; j < fs->blocksize * 8; j++)
 					ext2fs_set_bit(j, block_buf);
 		}
-		blk = fs->group_desc[i].bg_block_bitmap;
+		blk = EXT2_BLOCK_BITMAP(&fs->group_desc[i]);
 		if (blk) {
 #ifdef EXT2_BIG_ENDIAN_BITMAPS
 			if (!((fs->flags & EXT2_FLAG_SWAP_BYTES) ||
@@ -133,7 +133,7 @@ static errcode_t write_bitmaps(ext2_fils
 			goto skip_this_inode_bitmap;
  
 		memcpy(inode_buf, inode_bitmap, inode_nbytes);
-		blk = fs->group_desc[i].bg_inode_bitmap;
+		 blk = EXT2_INODE_BITMAP(&fs->group_desc[i]);
 		if (blk) {
 #ifdef EXT2_BIG_ENDIAN_BITMAPS
 			if (!((fs->flags & EXT2_FLAG_SWAP_BYTES) ||
@@ -227,7 +227,7 @@ static errcode_t read_bitmaps(ext2_filsy
 
 	for (i = 0; i < fs->group_desc_count; i++) {
 		if (block_bitmap) {
-			blk = fs->group_desc[i].bg_block_bitmap;
+			blk = EXT2_BLOCK_BITMAP(&fs->group_desc[i]);
 			if (lazy_flag && fs->group_desc[i].bg_flags &
 			    EXT2_BG_BLOCK_UNINIT)
 				blk = 0;
@@ -248,7 +248,7 @@ static errcode_t read_bitmaps(ext2_filsy
 			block_bitmap += block_nbytes;
 		}
 		if (inode_bitmap) {
-			blk = fs->group_desc[i].bg_inode_bitmap;
+			blk = EXT2_INODE_BITMAP(&fs->group_desc[i]);
 			if (lazy_flag && fs->group_desc[i].bg_flags &
 			    EXT2_BG_INODE_UNINIT)
 				blk = 0;
Index: e2fsprogs-1.39-tyt3-v6/resize/online.c
===================================================================
--- e2fsprogs-1.39-tyt3-v6.orig/resize/online.c	2007-06-11 12:48:52.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v6/resize/online.c	2007-06-11 12:48:54.000000000 +0200
@@ -117,9 +117,9 @@ errcode_t online_resize_fs(ext2_filsys f
 				new_fs->super->s_reserved_gdt_blocks;
 
 		input.group = i;
-		input.block_bitmap = new_fs->group_desc[i].bg_block_bitmap;
-		input.inode_bitmap = new_fs->group_desc[i].bg_inode_bitmap;
-		input.inode_table = new_fs->group_desc[i].bg_inode_table;
+		input.block_bitmap = EXT2_BLOCK_BITMAP(&new_fs->group_desc[i]);
+		input.inode_bitmap = EXT2_INODE_BITMAP(&new_fs->group_desc[i]);
+		input.inode_table = EXT2_INODE_TABLE(&new_fs->group_desc[i]);
 		input.blocks_count = sb->s_blocks_per_group;
 		if (i == new_fs->group_desc_count-1) {
 			input.blocks_count = EXT2_BLOCKS_COUNT(new_fs->super) -
Index: e2fsprogs-1.39-tyt3-v6/debugfs/logdump.c
===================================================================
--- e2fsprogs-1.39-tyt3-v6.orig/debugfs/logdump.c	2007-06-11 12:48:52.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v6/debugfs/logdump.c	2007-06-11 12:48:54.000000000 +0200
@@ -156,7 +156,7 @@ void do_logdump(int argc, char **argv)
 				    / sizeof(struct ext2_inode));
 		
 		inode_block_to_dump = 
-			current_fs->group_desc[inode_group].bg_inode_table + 
+			EXT2_INODE_TABLE(&current_fs->group_desc[inode_group]) +
 			(group_offset / inodes_per_block);
 		inode_offset_to_dump = ((group_offset % inodes_per_block)
 					* sizeof(struct ext2_inode));
@@ -181,7 +181,7 @@ void do_logdump(int argc, char **argv)
 		group_to_dump = ((block_to_dump - 
 				  es->s_first_data_block)
 				 / es->s_blocks_per_group);
-		bitmap_to_dump = current_fs->group_desc[group_to_dump].bg_block_bitmap;
+		bitmap_to_dump = EXT2_BLOCK_BITMAP(&current_fs->group_desc[group_to_dump]);
 	}
 
 	if (!journal_fn && check_fs_open(argv[0]))
Index: e2fsprogs-1.39-tyt3-v6/debugfs/debugfs.c
===================================================================
--- e2fsprogs-1.39-tyt3-v6.orig/debugfs/debugfs.c	2007-06-11 12:48:52.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v6/debugfs/debugfs.c	2007-06-11 12:48:54.000000000 +0200
@@ -331,8 +331,9 @@ void do_show_super_stats(int argc, char 
 		        "           %d free %s, "
 		        "%d free %s, "
 		        "%d used %s\n",
-		        i, gdp->bg_block_bitmap,
-		        gdp->bg_inode_bitmap, gdp->bg_inode_table,
+			i, EXT2_BLOCK_BITMAP(gdp),
+			EXT2_INODE_BITMAP(gdp),
+			EXT2_INODE_TABLE(gdp),
 		        gdp->bg_free_blocks_count,
 		        gdp->bg_free_blocks_count != 1 ? "blocks" : "block",
 		        gdp->bg_free_inodes_count,
@@ -1807,12 +1808,12 @@ void do_imap(int argc, char *argv[])
 	offset = ((ino - 1) % EXT2_INODES_PER_GROUP(current_fs->super)) *
 		EXT2_INODE_SIZE(current_fs->super);
 	block = offset >> EXT2_BLOCK_SIZE_BITS(current_fs->super);
-	if (!current_fs->group_desc[(unsigned)group].bg_inode_table) {
+	if (!EXT2_IS_USED_INODE_TABLE(&current_fs->group_desc[(unsigned)group])) {
 		com_err(argv[0], 0, "Inode table for group %lu is missing\n",
 			group);
 		return;
 	}
-	block_nr = current_fs->group_desc[(unsigned)group].bg_inode_table + 
+	block_nr = EXT2_INODE_TABLE(&current_fs->group_desc[(unsigned)group]) +
 		block;
 	offset &= (EXT2_BLOCK_SIZE(current_fs->super) - 1);
 
Index: e2fsprogs-1.39-tyt3-v6/resize/resize2fs.c
===================================================================
--- e2fsprogs-1.39-tyt3-v6.orig/resize/resize2fs.c	2007-06-11 12:48:52.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v6/resize/resize2fs.c	2007-06-11 12:48:54.000000000 +0200
@@ -53,9 +53,9 @@ static errcode_t ext2fs_calculate_summar
 /*
  * Some helper CPP macros
  */
-#define FS_BLOCK_BM(fs, i) ((fs)->group_desc[(i)].bg_block_bitmap)
-#define FS_INODE_BM(fs, i) ((fs)->group_desc[(i)].bg_inode_bitmap)
-#define FS_INODE_TB(fs, i) ((fs)->group_desc[(i)].bg_inode_table)
+#define FS_BLOCK_BM(fs, i) (EXT2_BLOCK_BITMAP(&(fs)->group_desc[(i)]))
+#define FS_INODE_BM(fs, i) (EXT2_INODE_BITMAP(&(fs)->group_desc[(i)]))
+#define FS_INODE_TB(fs, i) (EXT2_INODE_TABLE(&(fs)->group_desc[(i)]))
 
 #define IS_BLOCK_BM(fs, i, blk) ((blk) == FS_BLOCK_BM((fs),(i)))
 #define IS_INODE_BM(fs, i, blk) ((blk) == FS_INODE_BM((fs),(i)))
@@ -505,7 +505,7 @@ static errcode_t adjust_superblock(ext2_
 		 * Write out the new inode table
 		 */
 		retval = io_channel_write_blk(fs->io,
-					      fs->group_desc[i].bg_inode_table,
+					      EXT2_INODE_TABLE(&fs->group_desc[i]),
 					      fs->inode_blocks_per_group,
 					      rfs->itable_buf);
 		if (retval) goto errout;
@@ -563,7 +563,7 @@ static errcode_t mark_table_blocks(ext2_
 		/*
 		 * Mark the blocks used for the inode table
 		 */
-		for (j = 0, b = fs->group_desc[i].bg_inode_table;
+		for (j = 0, b = EXT2_INODE_TABLE(&fs->group_desc[i]);
 		     j < (unsigned int) fs->inode_blocks_per_group;
 		     j++, b++)
 			ext2fs_mark_block_bitmap(bmap, b);
@@ -572,13 +572,13 @@ static errcode_t mark_table_blocks(ext2_
 		 * Mark block used for the block bitmap 
 		 */
 		ext2fs_mark_block_bitmap(bmap,
-					 fs->group_desc[i].bg_block_bitmap);
+					 EXT2_BLOCK_BITMAP(&fs->group_desc[i]));
 
 		/*
 		 * Mark block used for the inode bitmap 
 		 */
 		ext2fs_mark_block_bitmap(bmap,
-					 fs->group_desc[i].bg_inode_bitmap);
+					 EXT2_INODE_BITMAP(&fs->group_desc[i]));
 	}
 	return 0;
 }
@@ -603,13 +603,13 @@ static void mark_fs_metablock(ext2_resiz
 	 * mark it as a block to be moved.
 	 */
 	if (IS_BLOCK_BM(fs, group, blk)) {
-		FS_BLOCK_BM(fs, group) = 0;
+		EXT2_BLOCK_BITMAP_SET(&fs->group_desc[group], 0UL);
 		rfs->needed_blocks++;
 	} else if (IS_INODE_BM(fs, group, blk)) {
-		FS_INODE_BM(fs, group) = 0;
+		EXT2_INODE_BITMAP_SET(&fs->group_desc[group], 0UL);
 		rfs->needed_blocks++;
 	} else if (IS_INODE_TB(fs, group, blk)) {
-		FS_INODE_TB(fs, group) = 0;
+		EXT2_INODE_TABLE_SET(&fs->group_desc[group], 0UL);
 		rfs->needed_blocks++;
 	} else if (ext2fs_test_block_bitmap(rfs->old_fs->block_map, blk) &&
 		   !ext2fs_test_block_bitmap(meta_bmap, blk)) {
@@ -744,23 +744,23 @@ static errcode_t blocks_to_move(ext2_res
 						  group_blk + has_super);
 		}
 
-		if (fs->group_desc[i].bg_inode_table &&
-		    fs->group_desc[i].bg_inode_bitmap &&
-		    fs->group_desc[i].bg_block_bitmap)
+		if (EXT2_IS_USED_INODE_TABLE(&fs->group_desc[i]) &&
+		    EXT2_IS_USED_INODE_BITMAP(&fs->group_desc[i]) &&
+		    EXT2_IS_USED_BLOCK_BITMAP(&fs->group_desc[i]))
 			goto next_group;
 
 		/*
 		 * Reserve the existing meta blocks that we know
 		 * aren't to be moved.
 		 */
-		if (fs->group_desc[i].bg_block_bitmap)
+		if (EXT2_IS_USED_BLOCK_BITMAP(&fs->group_desc[i]))
 			ext2fs_mark_block_bitmap(rfs->reserve_blocks,
-				 fs->group_desc[i].bg_block_bitmap);
-		if (fs->group_desc[i].bg_inode_bitmap)
+				 EXT2_BLOCK_BITMAP(&fs->group_desc[i]));
+		if (EXT2_IS_USED_INODE_BITMAP(&fs->group_desc[i]))
 			ext2fs_mark_block_bitmap(rfs->reserve_blocks,
-				 fs->group_desc[i].bg_inode_bitmap);
-		if (fs->group_desc[i].bg_inode_table)
-			for (blk = fs->group_desc[i].bg_inode_table, j=0;
+				 EXT2_INODE_BITMAP(&fs->group_desc[i]));
+		if (EXT2_IS_USED_INODE_TABLE(&fs->group_desc[i]))
+			for (blk = EXT2_INODE_TABLE(&fs->group_desc[i]), j=0;
 			     j < fs->inode_blocks_per_group ; j++, blk++)
 				ext2fs_mark_block_bitmap(rfs->reserve_blocks,
 							 blk);
@@ -811,7 +811,7 @@ static errcode_t blocks_to_move(ext2_res
 		 * allocation bitmap, and move any blocks that might 
 		 * be necessary.
 		 */
-		for (blk = fs->group_desc[i].bg_inode_table, j=0;
+		for (blk = EXT2_INODE_TABLE(&fs->group_desc[i]), j=0;
 		     j < fs->inode_blocks_per_group ; j++, blk++) {
 			ext2fs_mark_block_bitmap(fs->block_map, blk);
 			if (ext2fs_test_block_bitmap(old_fs->block_map, blk) &&
@@ -824,7 +824,7 @@ static errcode_t blocks_to_move(ext2_res
 		 * Make sure the old inode table is reserved in the
 		 * block reservation bitmap.
 		 */
-		for (blk = rfs->old_fs->group_desc[i].bg_inode_table, j=0;
+		for (blk = EXT2_INODE_TABLE(&rfs->old_fs->group_desc[i]), j=0;
 		     j < fs->inode_blocks_per_group ; j++, blk++)
 			ext2fs_mark_block_bitmap(rfs->reserve_blocks, blk);
 		
@@ -1403,8 +1403,8 @@ static errcode_t move_itables(ext2_resiz
 	 */
 	to_move = moved = 0;
 	for (i=0; i < max_groups; i++)
-		if (rfs->old_fs->group_desc[i].bg_inode_table !=
-		    fs->group_desc[i].bg_inode_table)
+		if (EXT2_INODE_TABLE(&rfs->old_fs->group_desc[i]) !=
+		    EXT2_INODE_TABLE(&fs->group_desc[i]))
 			to_move++;
 
 	if (to_move == 0)
@@ -1420,8 +1420,8 @@ static errcode_t move_itables(ext2_resiz
 	rfs->old_fs->flags |= EXT2_FLAG_MASTER_SB_ONLY;
 
 	for (i=0; i < max_groups; i++) {
-		old_blk = rfs->old_fs->group_desc[i].bg_inode_table;
-		new_blk = fs->group_desc[i].bg_inode_table;
+		old_blk = EXT2_INODE_TABLE(&rfs->old_fs->group_desc[i]);
+		new_blk = EXT2_INODE_TABLE(&fs->group_desc[i]);
 		diff = new_blk - old_blk;
 		
 #ifdef RESIZE2FS_DEBUG
@@ -1474,11 +1474,11 @@ static errcode_t move_itables(ext2_resiz
 				goto errout;
 		}
 
-		for (blk = rfs->old_fs->group_desc[i].bg_inode_table, j=0;
+		for (blk = EXT2_INODE_TABLE(&rfs->old_fs->group_desc[i]), j=0;
 		     j < fs->inode_blocks_per_group ; j++, blk++)
 			ext2fs_unmark_block_bitmap(fs->block_map, blk);
 
-		rfs->old_fs->group_desc[i].bg_inode_table = new_blk;
+		EXT2_INODE_TABLE_SET(&rfs->old_fs->group_desc[i], new_blk);
 		ext2fs_mark_super_dirty(rfs->old_fs);
 		ext2fs_flush(rfs->old_fs);
 
Index: e2fsprogs-1.39-tyt3-v6/misc/dumpe2fs.c
===================================================================
--- e2fsprogs-1.39-tyt3-v6.orig/misc/dumpe2fs.c	2007-06-11 12:48:35.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v6/misc/dumpe2fs.c	2007-06-11 12:48:54.000000000 +0200
@@ -188,20 +188,20 @@ static void list_desc (ext2_filsys fs)
 		if (has_super)
 			fputc('\n', stdout);
 		fputs(_("  Block bitmap at "), stdout);
-		print_number(fs->group_desc[i].bg_block_bitmap);
-		diff = fs->group_desc[i].bg_block_bitmap - first_block;
+		print_number(EXT2_BLOCK_BITMAP(&fs->group_desc[i]));
+		diff = EXT2_BLOCK_BITMAP(&fs->group_desc[i]) - first_block;
 		if (diff >= 0)
 			printf(" (+%ld)", diff);
 		fputs(_(", Inode bitmap at "), stdout);
-		print_number(fs->group_desc[i].bg_inode_bitmap);
-		diff = fs->group_desc[i].bg_inode_bitmap - first_block;
+		print_number(EXT2_INODE_BITMAP(&fs->group_desc[i]));
+		diff = EXT2_INODE_BITMAP(&fs->group_desc[i]) - first_block;
 		if (diff >= 0)
 			printf(" (+%ld)", diff);
 		fputs(_("\n  Inode table at "), stdout);
-		print_range(fs->group_desc[i].bg_inode_table,
-			    fs->group_desc[i].bg_inode_table +
+		print_range(EXT2_INODE_TABLE(&fs->group_desc[i]),
+			    EXT2_INODE_TABLE(&fs->group_desc[i]) +
 			    inode_blocks_per_group - 1);
-		diff = fs->group_desc[i].bg_inode_table - first_block;
+		diff = EXT2_INODE_TABLE(&fs->group_desc[i]) - first_block;
 		if (diff > 0)
 			printf(" (+%ld)", diff);
 		printf (_("\n  %d free blocks, %d free inodes, "
Index: e2fsprogs-1.39-tyt3-v6/e2fsck/swapfs.c
===================================================================
--- e2fsprogs-1.39-tyt3-v6.orig/e2fsck/swapfs.c	2007-06-11 12:48:35.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v6/e2fsck/swapfs.c	2007-06-11 12:48:54.000000000 +0200
@@ -131,7 +131,7 @@ static void swap_inodes(e2fsck_t ctx)
 						    "block interate buffer");
 	for (group = 0; group < fs->group_desc_count; group++) {
 		retval = io_channel_read_blk(fs->io,
-		      fs->group_desc[group].bg_inode_table,
+		      EXT2_INODE_TABLE(&fs->group_desc[group]),
 		      fs->inode_blocks_per_group, buf);
 		if (retval) {
 			com_err("swap_inodes", retval,
@@ -169,7 +169,7 @@ static void swap_inodes(e2fsck_t ctx)
 				ext2fs_swap_inode(fs, inode, inode, 1);
 		}
 		retval = io_channel_write_blk(fs->io,
-		      fs->group_desc[group].bg_inode_table,
+		      EXT2_INODE_TABLE(&fs->group_desc[group]),
 		      fs->inode_blocks_per_group, buf);
 		if (retval) {
 			com_err("swap_inodes", retval,
Index: e2fsprogs-1.39-tyt3-v6/resize/main.c
===================================================================
--- e2fsprogs-1.39-tyt3-v6.orig/resize/main.c	2007-06-11 12:48:52.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v6/resize/main.c	2007-06-11 12:48:54.000000000 +0200
@@ -106,11 +106,11 @@ static void determine_fs_stride(ext2_fil
 		has_sb = ext2fs_bg_has_super(fs, group);
 		if (group == 0 || has_sb != prev_has_sb)
 			goto next;
-		b_stride = fs->group_desc[group].bg_block_bitmap - 
-			fs->group_desc[group-1].bg_block_bitmap - 
+		b_stride = EXT2_BLOCK_BITMAP(&fs->group_desc[group]) -
+			EXT2_BLOCK_BITMAP(&fs->group_desc[group-1]) -
 			fs->super->s_blocks_per_group;
-		i_stride = fs->group_desc[group].bg_inode_bitmap - 
-			fs->group_desc[group-1].bg_inode_bitmap - 
+		i_stride = EXT2_INODE_BITMAP(&fs->group_desc[group]) -
+			EXT2_INODE_BITMAP(&fs->group_desc[group-1]) -
 			fs->super->s_blocks_per_group;
 		if (b_stride != i_stride ||
 		    b_stride < 0)
Index: e2fsprogs-1.39-tyt3-v6/misc/mke2fs.c
===================================================================
--- e2fsprogs-1.39-tyt3-v6.orig/misc/mke2fs.c	2007-06-11 12:48:52.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v6/misc/mke2fs.c	2007-06-11 12:48:54.000000000 +0200
@@ -420,7 +420,7 @@ static void write_inode_tables(ext2_fils
 	for (i = 0; i < fs->group_desc_count; i++) {
 		progress_update(&progress, i);
 		
-		blk = fs->group_desc[i].bg_inode_table;
+		blk = EXT2_INODE_TABLE(&fs->group_desc[i]);
 		num = fs->inode_blocks_per_group;
 
 		if (!(lazy_flag &&
Index: e2fsprogs-1.39-tyt3-v6/lib/ext2fs/inode.c
===================================================================
--- e2fsprogs-1.39-tyt3-v6.orig/lib/ext2fs/inode.c	2007-06-11 12:48:35.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v6/lib/ext2fs/inode.c	2007-06-11 12:48:54.000000000 +0200
@@ -142,8 +142,8 @@ errcode_t ext2fs_open_inode_scan(ext2_fi
 	scan->current_group = 0;
 	scan->groups_left = fs->group_desc_count - 1;
 	scan->inode_buffer_blocks = buffer_blocks ? buffer_blocks : 8;
-	scan->current_block = scan->fs->
-		group_desc[scan->current_group].bg_inode_table;
+	scan->current_block =
+		EXT2_INODE_TABLE(&scan->fs->group_desc[scan->current_group]);
 	scan->inodes_left = EXT2_INODES_PER_GROUP(scan->fs->super);
 	scan->blocks_left = scan->fs->inode_blocks_per_group;
 	retval = ext2fs_get_mem((size_t) (scan->inode_buffer_blocks * 
@@ -221,8 +221,8 @@ static errcode_t get_next_blockgroup(ext
 	scan->current_group++;
 	scan->groups_left--;
 			
-	scan->current_block = scan->fs->
-		group_desc[scan->current_group].bg_inode_table;
+	scan->current_block =
+		EXT2_INODE_TABLE(&scan->fs->group_desc[scan->current_group]);
 
 	scan->current_inode = scan->current_group *
 		EXT2_INODES_PER_GROUP(scan->fs->super);
@@ -546,9 +546,9 @@ errcode_t ext2fs_read_inode_full(ext2_fi
 		offset = ((ino - 1) % EXT2_INODES_PER_GROUP(fs->super)) *
 			EXT2_INODE_SIZE(fs->super);
 		block = offset >> EXT2_BLOCK_SIZE_BITS(fs->super);
-		if (!fs->group_desc[(unsigned)group].bg_inode_table)
+		if (!EXT2_IS_USED_INODE_TABLE(&fs->group_desc[(unsigned)group]))
 			return EXT2_ET_MISSING_INODE_TABLE;
-		block_nr = fs->group_desc[(unsigned)group].bg_inode_table + 
+		block_nr = EXT2_INODE_TABLE(&fs->group_desc[(unsigned)group]) +
 			block;
 		io = fs->io;
 	}
@@ -669,11 +669,11 @@ errcode_t ext2fs_write_inode_full(ext2_f
 	offset = ((ino - 1) % EXT2_INODES_PER_GROUP(fs->super)) *
 		EXT2_INODE_SIZE(fs->super);
 	block = offset >> EXT2_BLOCK_SIZE_BITS(fs->super);
-	if (!fs->group_desc[(unsigned) group].bg_inode_table) {
+	if (!EXT2_IS_USED_INODE_TABLE(&fs->group_desc[(unsigned) group])) {
 		retval = EXT2_ET_MISSING_INODE_TABLE;
 		goto errout;
 	}
-	block_nr = fs->group_desc[(unsigned) group].bg_inode_table + block;
+	block_nr = EXT2_INODE_TABLE(&fs->group_desc[(unsigned) group]) + block;
 
 	offset &= (EXT2_BLOCK_SIZE(fs->super) - 1);
 
Index: e2fsprogs-1.39-tyt3-v6/e2fsck/pass1b.c
===================================================================
--- e2fsprogs-1.39-tyt3-v6.orig/e2fsck/pass1b.c	2007-06-11 12:48:35.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v6/e2fsck/pass1b.c	2007-06-11 12:48:54.000000000 +0200
@@ -816,15 +816,15 @@ static int check_if_fs_block(e2fsck_t ct
 		}
 		
 		/* Check the inode table */
-		if ((fs->group_desc[i].bg_inode_table) &&
-		    (test_block >= fs->group_desc[i].bg_inode_table) &&
-		    (test_block < (fs->group_desc[i].bg_inode_table +
+		if (EXT2_INODE_TABLE(&fs->group_desc[i]) &&
+		    (test_block >= EXT2_INODE_TABLE(&fs->group_desc[i])) &&
+		    (test_block < (EXT2_INODE_TABLE(&fs->group_desc[i]) +
 				   fs->inode_blocks_per_group)))
 			return 1;
 
 		/* Check the bitmap blocks */
-		if ((test_block == fs->group_desc[i].bg_block_bitmap) ||
-		    (test_block == fs->group_desc[i].bg_inode_bitmap))
+		if ((test_block == EXT2_BLOCK_BITMAP(&fs->group_desc[i])) ||
+		    (test_block == EXT2_INODE_BITMAP(&fs->group_desc[i])))
 			return 1;
 		
 		first_block += fs->super->s_blocks_per_group;
Index: e2fsprogs-1.39-tyt3-v6/e2fsck/pass1.c
===================================================================
--- e2fsprogs-1.39-tyt3-v6.orig/e2fsck/pass1.c	2007-06-11 12:48:52.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v6/e2fsck/pass1.c	2007-06-11 12:48:54.000000000 +0200
@@ -1882,16 +1882,16 @@ static char *describe_illegal_block(ext2
 				"of group %d", i);
 			break;
 		}
-		if (block == fs->group_desc[i].bg_block_bitmap) {
+		if (block == EXT2_BLOCK_BITMAP(&fs->group_desc[i])) {
 			sprintf(problem, "is the block bitmap of group %d", i);
 			break;
 		}
-		if (block == fs->group_desc[i].bg_inode_bitmap) {
+		if (block == EXT2_INODE_BITMAP(&fs->group_desc[i])) {
 			sprintf(problem, "is the inode bitmap of group %d", i);
 			break;
 		}
-		if (block >= fs->group_desc[i].bg_inode_table &&
-		    (block < fs->group_desc[i].bg_inode_table
+		if (block >= EXT2_INODE_TABLE(&fs->group_desc[i]) &&
+		    (block < EXT2_INODE_TABLE(&fs->group_desc[i])
 		     + fs->inode_blocks_per_group)) {
 			sprintf(problem, "is in the inode table of group %d",
 				i);
@@ -2197,22 +2197,22 @@ static int process_bad_block(ext2_filsys
 			return 0;
 		}
 	skip_super:
-		if (blk == fs->group_desc[i].bg_block_bitmap) {
+		if (blk == EXT2_BLOCK_BITMAP(&fs->group_desc[i])) {
 			if (fix_problem(ctx, PR_1_BB_BAD_BLOCK, pctx)) {
 				ctx->invalid_block_bitmap_flag[i]++;
 				ctx->invalid_bitmaps++;
 			}
 			return 0;
 		}
-		if (blk == fs->group_desc[i].bg_inode_bitmap) {
+		if (blk == EXT2_INODE_BITMAP(&fs->group_desc[i])) {
 			if (fix_problem(ctx, PR_1_IB_BAD_BLOCK, pctx)) {
 				ctx->invalid_inode_bitmap_flag[i]++;
 				ctx->invalid_bitmaps++;
 			}
 			return 0;
 		}
-		if ((blk >= fs->group_desc[i].bg_inode_table) &&
-		    (blk < (fs->group_desc[i].bg_inode_table +
+		if ((blk >= EXT2_INODE_TABLE(&fs->group_desc[i])) &&
+		    (blk < (EXT2_INODE_TABLE(&fs->group_desc[i]) +
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
+			blk = EXT2_BLOCK_BITMAP(&fs->group_desc[i]);
 			new_table_block(ctx, first_block, i, _("block bitmap"),
-					1, &fs->group_desc[i].bg_block_bitmap);
+					1, &blk);
+			EXT2_BLOCK_BITMAP_SET(&fs->group_desc[i], blk);
 		}
 		if (ctx->invalid_inode_bitmap_flag[i]) {
+			blk = EXT2_INODE_BITMAP(&fs->group_desc[i]);
 			new_table_block(ctx, first_block, i, _("inode bitmap"),
-					1, &fs->group_desc[i].bg_inode_bitmap);
+					1, &blk);
+			EXT2_INODE_BITMAP_SET(&fs->group_desc[i], blk);
 		}
 		if (ctx->invalid_inode_table_flag[i]) {
+			blk = EXT2_INODE_TABLE(&fs->group_desc[i]);
 			new_table_block(ctx, first_block, i, _("inode table"),
-					fs->inode_blocks_per_group, 
-					&fs->group_desc[i].bg_inode_table);
+					fs->inode_blocks_per_group, &blk); 
+			EXT2_INODE_TABLE_SET(&fs->group_desc[i], blk);
 			ctx->flags |= E2F_FLAG_RESTART;
 		}
 	}
@@ -2362,8 +2368,8 @@ static void mark_table_blocks(e2fsck_t c
 		/*
 		 * Mark the blocks used for the inode table
 		 */
-		if (fs->group_desc[i].bg_inode_table) {
-			for (j = 0, b = fs->group_desc[i].bg_inode_table;
+		if (EXT2_IS_USED_INODE_TABLE(&fs->group_desc[i])) {
+			for (j = 0, b = EXT2_INODE_TABLE(&fs->group_desc[i]);
 			     j < fs->inode_blocks_per_group;
 			     j++, b++) {
 				if (ext2fs_test_block_bitmap(ctx->block_found_map,
@@ -2384,34 +2390,34 @@ static void mark_table_blocks(e2fsck_t c
 		/*
 		 * Mark block used for the block bitmap 
 		 */
-		if (fs->group_desc[i].bg_block_bitmap) {
+		if (EXT2_IS_USED_BLOCK_BITMAP(&fs->group_desc[i])) {
 			if (ext2fs_test_block_bitmap(ctx->block_found_map,
-				     fs->group_desc[i].bg_block_bitmap)) {
-				pctx.blk = fs->group_desc[i].bg_block_bitmap;
+				     EXT2_BLOCK_BITMAP(&fs->group_desc[i]))) {
+				pctx.blk = EXT2_BLOCK_BITMAP(&fs->group_desc[i]);
 				if (fix_problem(ctx, PR_1_BB_CONFLICT, &pctx)) {
 					ctx->invalid_block_bitmap_flag[i]++;
 					ctx->invalid_bitmaps++;
 				}
 			} else {
 			    ext2fs_mark_block_bitmap(ctx->block_found_map,
-				     fs->group_desc[i].bg_block_bitmap);
+				     EXT2_BLOCK_BITMAP(&fs->group_desc[i]));
 		    }
 			
 		}
 		/*
 		 * Mark block used for the inode bitmap 
 		 */
-		if (fs->group_desc[i].bg_inode_bitmap) {
+		if (EXT2_IS_USED_INODE_BITMAP(&fs->group_desc[i])) {
 			if (ext2fs_test_block_bitmap(ctx->block_found_map,
-				     fs->group_desc[i].bg_inode_bitmap)) {
-				pctx.blk = fs->group_desc[i].bg_inode_bitmap;
+				     EXT2_INODE_BITMAP(&fs->group_desc[i]))) {
+				pctx.blk = EXT2_INODE_BITMAP(&fs->group_desc[i]);
 				if (fix_problem(ctx, PR_1_IB_CONFLICT, &pctx)) {
 					ctx->invalid_inode_bitmap_flag[i]++;
 					ctx->invalid_bitmaps++;
 				} 
 			} else {
 			    ext2fs_mark_block_bitmap(ctx->block_found_map,
-				     fs->group_desc[i].bg_inode_bitmap);
+				     EXT2_INODE_BITMAP(&fs->group_desc[i]));
 			}
 		}
 	}
Index: e2fsprogs-1.39-tyt3-v6/e2fsck/super.c
===================================================================
--- e2fsprogs-1.39-tyt3-v6.orig/e2fsck/super.c	2007-06-11 12:48:52.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v6/e2fsck/super.c	2007-06-11 12:48:54.000000000 +0200
@@ -607,34 +607,34 @@ void check_super_block(e2fsck_t ctx)
 		first_block = ext2fs_group_first_block(fs, i);
 		last_block = ext2fs_group_last_block(fs, i);
 
-		if ((gd->bg_block_bitmap < first_block) ||
-		    (gd->bg_block_bitmap > last_block)) {
-			pctx.blk = gd->bg_block_bitmap;
+		if ((EXT2_BLOCK_BITMAP(gd) < first_block) ||
+		    (EXT2_BLOCK_BITMAP(gd) > last_block)) {
+			pctx.blk = EXT2_BLOCK_BITMAP(gd);
 			if (fix_problem(ctx, PR_0_BB_NOT_GROUP, &pctx))
-				gd->bg_block_bitmap = 0;
+				EXT2_BLOCK_BITMAP_SET(gd, 0UL);
 		}
-		if (gd->bg_block_bitmap == 0) {
+		if (!EXT2_IS_USED_BLOCK_BITMAP(gd)) {
 			ctx->invalid_block_bitmap_flag[i]++;
 			ctx->invalid_bitmaps++;
 		}
-		if ((gd->bg_inode_bitmap < first_block) ||
-		    (gd->bg_inode_bitmap > last_block)) {
-			pctx.blk = gd->bg_inode_bitmap;
+		if ((EXT2_INODE_BITMAP(gd) < first_block) ||
+		    (EXT2_INODE_BITMAP(gd) > last_block)) {
+			pctx.blk = EXT2_INODE_BITMAP(gd);
 			if (fix_problem(ctx, PR_0_IB_NOT_GROUP, &pctx))
-				gd->bg_inode_bitmap = 0;
+				EXT2_INODE_BITMAP_SET(gd, 0UL);
 		}
-		if (gd->bg_inode_bitmap == 0) {
+		if (!EXT2_IS_USED_INODE_BITMAP(gd)) {
 			ctx->invalid_inode_bitmap_flag[i]++;
 			ctx->invalid_bitmaps++;
 		}
-		if ((gd->bg_inode_table < first_block) ||
-		    ((gd->bg_inode_table +
+		if ((EXT2_INODE_TABLE(gd) < first_block) ||
+		    ((EXT2_INODE_TABLE(gd) +
 		      fs->inode_blocks_per_group - 1) > last_block)) {
-			pctx.blk = gd->bg_inode_table;
+			pctx.blk = EXT2_INODE_TABLE(gd);
 			if (fix_problem(ctx, PR_0_ITABLE_NOT_GROUP, &pctx))
-				gd->bg_inode_table = 0;
+				EXT2_INODE_TABLE_SET(gd, 0UL);
 		}
-		if (gd->bg_inode_table == 0) {
+		if (!EXT2_IS_USED_INODE_TABLE(gd)) {
 			ctx->invalid_inode_table_flag[i]++;
 			ctx->invalid_bitmaps++;
 		}
Index: e2fsprogs-1.39-tyt3-v6/misc/e2image.c
===================================================================
--- e2fsprogs-1.39-tyt3-v6.orig/misc/e2image.c	2007-06-11 12:48:52.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v6/misc/e2image.c	2007-06-11 12:48:54.000000000 +0200
@@ -265,8 +265,8 @@ static void mark_table_blocks(ext2_filsy
 		/*
 		 * Mark the blocks used for the inode table
 		 */
-		if (fs->group_desc[i].bg_inode_table) {
-			for (j = 0, b = fs->group_desc[i].bg_inode_table;
+		if (EXT2_IS_USED_INODE_TABLE(&fs->group_desc[i])) {
+			for (j = 0, b = EXT2_INODE_TABLE(&fs->group_desc[i]);
 			     j < (unsigned) fs->inode_blocks_per_group;
 			     j++, b++)
 				ext2fs_mark_block_bitmap(meta_block_map, b);
@@ -275,17 +275,17 @@ static void mark_table_blocks(ext2_filsy
 		/*
 		 * Mark block used for the block bitmap 
 		 */
-		if (fs->group_desc[i].bg_block_bitmap) {
+		if (EXT2_IS_USED_BLOCK_BITMAP(&fs->group_desc[i])) {
 			ext2fs_mark_block_bitmap(meta_block_map,
-				     fs->group_desc[i].bg_block_bitmap);
+					EXT2_BLOCK_BITMAP(&fs->group_desc[i]));
 		}
 		
 		/*
 		 * Mark block used for the inode bitmap 
 		 */
-		if (fs->group_desc[i].bg_inode_bitmap) {
+		if (EXT2_IS_USED_INODE_BITMAP(&fs->group_desc[i])) {
 			ext2fs_mark_block_bitmap(meta_block_map,
-				 fs->group_desc[i].bg_inode_bitmap);
+					EXT2_INODE_BITMAP(&fs->group_desc[i]));
 		}
 	}
 }
Index: e2fsprogs-1.39-tyt3-v6/lib/ext2fs/tst_iscan.c
===================================================================
--- e2fsprogs-1.39-tyt3-v6.orig/lib/ext2fs/tst_iscan.c	2007-06-11 12:48:52.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v6/lib/ext2fs/tst_iscan.c	2007-06-11 12:48:54.000000000 +0200
@@ -182,7 +182,7 @@ static void check_map(void)
 		ext2fs_mark_block_bitmap(touched_map, test_vec[i]);
 	}
 	for (i = 0; i < test_fs->group_desc_count; i++) {
-		for (j=0, blk = test_fs->group_desc[i].bg_inode_table;
+		for (j=0, blk = EXT2_INODE_TABLE(&test_fs->group_desc[i]);
 		     j < test_fs->inode_blocks_per_group;
 		     j++, blk++) {
 			if (!ext2fs_test_block_bitmap(touched_map, blk) &&
Index: e2fsprogs-1.39-tyt3-v6/lib/ext2fs/imager.c
===================================================================
--- e2fsprogs-1.39-tyt3-v6.orig/lib/ext2fs/imager.c	2007-06-11 12:48:35.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v6/lib/ext2fs/imager.c	2007-06-11 12:48:54.000000000 +0200
@@ -71,7 +71,7 @@ errcode_t ext2fs_image_inode_write(ext2_
 		return ENOMEM;
 	
 	for (group = 0; group < fs->group_desc_count; group++) {
-		blk = fs->group_desc[(unsigned)group].bg_inode_table;
+		blk = EXT2_INODE_TABLE(&fs->group_desc[(unsigned)group]);
 		if (!blk) {
 			retval = EXT2_ET_MISSING_INODE_TABLE;
 			goto errout;
@@ -145,7 +145,7 @@ errcode_t ext2fs_image_inode_read(ext2_f
 		return ENOMEM;
 	
 	for (group = 0; group < fs->group_desc_count; group++) {
-		blk = fs->group_desc[(unsigned)group].bg_inode_table;
+		blk = EXT2_INODE_TABLE(&fs->group_desc[(unsigned)group]);
 		if (!blk) {
 			retval = EXT2_ET_MISSING_INODE_TABLE;
 			goto errout;

--------------030305010500080002000604--
