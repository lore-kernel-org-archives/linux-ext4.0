From: Valerie Clement <valerie.clement@bull.net>
Subject: [RFC][PATCH 4/12] convert some block types in e2fsprogs
Date: Mon, 11 Jun 2007 18:42:28 +0200
Message-ID: <466D7B74.5000207@bull.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030105010909030508030408"
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:48164 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbXFKQlG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Jun 2007 12:41:06 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is a multi-part message in MIME format.
--------------030105010909030508030408
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed

This patch converts some int or unsigned int block number definitions
to blk_t type.  Most conversions are necessary for 64-bit porting.

  debugfs/debugfs.c       |   12 +++++-------
  debugfs/logdump.c       |   10 +++++-----
  e2fsck/super.c          |    3 ++-
  lib/e2p/e2p.h           |    2 +-
  lib/e2p/percent.c       |    2 +-
  lib/ext2fs/bitops.h     |    2 +-
  lib/ext2fs/closefs.c    |    7 +++----
  lib/ext2fs/ext2fs.h     |    2 +-
  lib/ext2fs/gen_bitmap.c |    2 +-
  lib/ext2fs/openfs.c     |    3 +-- 

  resize/resize2fs.c      |    4 ++--
  11 files changed, 23 insertions(+), 26 deletions(-)



--------------030105010909030508030408
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
 name="04-clean-up-some-block-types"
Content-Disposition: inline;
 filename="04-clean-up-some-block-types"

Index: e2fsprogs-1.39-tyt3-v6/debugfs/logdump.c
===================================================================
--- e2fsprogs-1.39-tyt3-v6.orig/debugfs/logdump.c	2007-06-11 12:48:36.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v6/debugfs/logdump.c	2007-06-11 12:48:47.000000000 +0200
@@ -36,11 +36,11 @@ extern char *optarg;
 
 enum journal_location {JOURNAL_IS_INTERNAL, JOURNAL_IS_EXTERNAL};
 
-#define ANY_BLOCK ((unsigned int) -1)
+#define ANY_BLOCK ((blk_t) -1)
 
 int		dump_all, dump_contents, dump_descriptors;
-unsigned int	block_to_dump, group_to_dump, bitmap_to_dump;
-unsigned int	inode_block_to_dump, inode_offset_to_dump, bitmap_to_dump;
+blk_t		block_to_dump, bitmap_to_dump, inode_block_to_dump;
+unsigned int	group_to_dump, inode_offset_to_dump;
 ext2_ino_t	inode_to_dump;
 
 struct journal_source 
@@ -365,8 +365,8 @@ static void dump_journal(char *cmdname, 
 		if (dump_all) {
 			fprintf(out_file, "\tuuid=%s\n", jsb_buffer);
 			fprintf(out_file, "\tblocksize=%d\n", blocksize);
-			fprintf(out_file, "\tjournal data size %ld\n",
-				(long) sb->s_blocks_count);
+			fprintf(out_file, "\tjournal data size %lu\n",
+				sb->s_blocks_count);
 		}
 	}
 	
Index: e2fsprogs-1.39-tyt3-v6/debugfs/debugfs.c
===================================================================
--- e2fsprogs-1.39-tyt3-v6.orig/debugfs/debugfs.c	2007-06-11 12:48:36.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v6/debugfs/debugfs.c	2007-06-11 12:48:47.000000000 +0200
@@ -43,7 +43,7 @@ ext2_filsys	current_fs = NULL;
 ext2_ino_t	root, cwd;
 
 static void open_filesystem(char *device, int open_flags, blk_t superblock,
-			    blk_t blocksize, int catastrophic, 
+			    int blocksize, int catastrophic, 
 			    char *data_filename)
 {
 	int	retval;
@@ -123,7 +123,7 @@ void do_open_filesys(int argc, char **ar
 	int	c, err;
 	int	catastrophic = 0;
 	blk_t	superblock = 0;
-	blk_t	blocksize = 0;
+	int	blocksize = 0;
 	int	open_flags = EXT2_FLAG_SOFTSUPP_FEATURES;
 	char	*data_filename = 0;
 	
@@ -149,8 +149,7 @@ void do_open_filesys(int argc, char **ar
 			data_filename = optarg;
 			break;
 		case 'b':
-			blocksize = parse_ulong(optarg, argv[0],
-						"block size", &err);
+			blocksize = atoi(optarg);
 			if (err)
 				return;
 			break;
@@ -1892,7 +1891,7 @@ int main(int argc, char **argv)
 	int		exit_status = 0;
 	char		*cmd_file = 0;
 	blk_t		superblock = 0;
-	blk_t		blocksize = 0;
+	int		blocksize = 0;
 	int		catastrophic = 0;
 	char		*data_filename = 0;
 	
@@ -1918,8 +1917,7 @@ int main(int argc, char **argv)
 			open_flags |= EXT2_FLAG_RW;
 			break;
 		case 'b':
-			blocksize = parse_ulong(optarg, argv[0], 
-						"block size", 0);
+			blocksize = atoi(optarg);
 			break;
 		case 's':
 			superblock = parse_ulong(optarg, argv[0], 
Index: e2fsprogs-1.39-tyt3-v6/lib/ext2fs/openfs.c
===================================================================
--- e2fsprogs-1.39-tyt3-v6.orig/lib/ext2fs/openfs.c	2007-06-11 12:48:36.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v6/lib/ext2fs/openfs.c	2007-06-11 12:48:47.000000000 +0200
@@ -42,8 +42,7 @@ blk_t ext2fs_descriptor_block_loc(ext2_f
 	bg = EXT2_DESC_PER_BLOCK(fs->super) * i;
 	if (ext2fs_bg_has_super(fs, bg))
 		has_super = 1;
-	ret_blk = (fs->super->s_first_data_block + has_super + 
-		   (bg * fs->super->s_blocks_per_group));
+	ret_blk = ext2fs_group_first_block(fs, bg) + has_super;
 	/*
 	 * If group_block is not the normal value, we're trying to use
 	 * the backup group descriptors and superblock --- so use the
Index: e2fsprogs-1.39-tyt3-v6/lib/ext2fs/closefs.c
===================================================================
--- e2fsprogs-1.39-tyt3-v6.orig/lib/ext2fs/closefs.c	2007-06-11 12:48:36.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v6/lib/ext2fs/closefs.c	2007-06-11 12:48:47.000000000 +0200
@@ -54,11 +54,10 @@ int ext2fs_super_and_bgd_loc(ext2_filsys
 {
 	blk_t	group_block, super_blk = 0, old_desc_blk = 0, new_desc_blk = 0;
 	unsigned int meta_bg, meta_bg_size;
-	int	numblocks, has_super;
-	int	old_desc_blocks;
+	blk_t	numblocks, old_desc_blocks;
+	int	has_super;
 
-	group_block = fs->super->s_first_data_block +
-		(group * fs->super->s_blocks_per_group);
+	group_block = ext2fs_group_first_block(fs, group);
 
 	if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG)
 		old_desc_blocks = fs->super->s_first_meta_bg;
Index: e2fsprogs-1.39-tyt3-v6/e2fsck/super.c
===================================================================
--- e2fsprogs-1.39-tyt3-v6.orig/e2fsck/super.c	2007-06-11 12:48:36.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v6/e2fsck/super.c	2007-06-11 12:48:47.000000000 +0200
@@ -483,7 +483,8 @@ void check_super_block(e2fsck_t ctx)
 	dgrp_t	i;
 	blk_t	should_be;
 	struct problem_context	pctx;
-	__u32	free_blocks = 0, free_inodes = 0;
+	blk_t	free_blocks = 0;
+	ino_t	free_inodes = 0;
 
 	inodes_per_block = EXT2_INODES_PER_BLOCK(fs->super);
 	ipg_max = inodes_per_block * (blocks_per_group - 4);
Index: e2fsprogs-1.39-tyt3-v6/resize/resize2fs.c
===================================================================
--- e2fsprogs-1.39-tyt3-v6.orig/resize/resize2fs.c	2007-06-11 12:48:36.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v6/resize/resize2fs.c	2007-06-11 12:48:47.000000000 +0200
@@ -1557,8 +1557,8 @@ static errcode_t ext2fs_calculate_summar
 	blk_t		blk;
 	ext2_ino_t	ino;
 	unsigned int	group = 0;
-	unsigned int	count = 0;
-	int		total_free = 0;
+	blk_t		count = 0;
+	blk_t		total_free = 0;
 	int		group_free = 0;
 
 	/*
Index: e2fsprogs-1.39-tyt3-v6/lib/e2p/e2p.h
===================================================================
--- e2fsprogs-1.39-tyt3-v6.orig/lib/e2p/e2p.h	2007-06-11 12:48:36.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v6/lib/e2p/e2p.h	2007-06-11 12:48:47.000000000 +0200
@@ -51,4 +51,4 @@ unsigned long parse_num_blocks(const cha
 char *e2p_os2string(int os_type);
 int e2p_string2os(char *str);
 
-unsigned int e2p_percent(int percent, unsigned int base);
+unsigned long e2p_percent(int percent, unsigned long base);
Index: e2fsprogs-1.39-tyt3-v6/lib/e2p/percent.c
===================================================================
--- e2fsprogs-1.39-tyt3-v6.orig/lib/e2p/percent.c	2007-06-11 12:48:36.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v6/lib/e2p/percent.c	2007-06-11 12:48:47.000000000 +0200
@@ -15,7 +15,7 @@
  * We work really hard to calculate this accurately, while avoiding
  * an overflow.  "Is there a hyphen in anal-retentive?"  :-)
  */
-unsigned int e2p_percent(int percent, unsigned int base)
+unsigned long e2p_percent(int percent, unsigned long base)
 {
 	unsigned int mask = ~((1 << (sizeof(unsigned int) - 1) * 8) - 1);
 
Index: e2fsprogs-1.39-tyt3-v6/lib/ext2fs/ext2fs.h
===================================================================
--- e2fsprogs-1.39-tyt3-v6.orig/lib/ext2fs/ext2fs.h	2007-06-11 12:48:36.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v6/lib/ext2fs/ext2fs.h	2007-06-11 12:48:47.000000000 +0200
@@ -441,7 +441,7 @@ typedef struct ext2_icount *ext2_icount_
 /*
  * For ext2 compression support
  */
-#define EXT2FS_COMPRESSED_BLKADDR ((blk_t) 0xffffffff)
+#define EXT2FS_COMPRESSED_BLKADDR ((blk_t) -1)
 #define HOLE_BLKADDR(_b) ((_b) == 0 || (_b) == EXT2FS_COMPRESSED_BLKADDR)
 
 /*
Index: e2fsprogs-1.39-tyt3-v6/lib/ext2fs/gen_bitmap.c
===================================================================
--- e2fsprogs-1.39-tyt3-v6.orig/lib/ext2fs/gen_bitmap.c	2007-06-11 12:48:36.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v6/lib/ext2fs/gen_bitmap.c	2007-06-11 12:48:47.000000000 +0200
@@ -28,7 +28,7 @@
 #include "ext2fs.h"
 
 int ext2fs_mark_generic_bitmap(ext2fs_generic_bitmap bitmap,
-					 __u32 bitno)
+					 blk_t bitno)
 {
 	if ((bitno < bitmap->start) || (bitno > bitmap->end)) {
 		ext2fs_warn_bitmap2(bitmap, EXT2FS_MARK_ERROR, bitno);
Index: e2fsprogs-1.39-tyt3-v6/lib/ext2fs/bitops.h
===================================================================
--- e2fsprogs-1.39-tyt3-v6.orig/lib/ext2fs/bitops.h	2007-06-11 12:48:36.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v6/lib/ext2fs/bitops.h	2007-06-11 12:48:47.000000000 +0200
@@ -106,7 +106,7 @@ extern void ext2fs_set_bitmap_padding(ex
 
 /* These two routines moved to gen_bitmap.c */
 extern int ext2fs_mark_generic_bitmap(ext2fs_generic_bitmap bitmap,
-					 __u32 bitno);
+					 blk_t bitno);
 extern int ext2fs_unmark_generic_bitmap(ext2fs_generic_bitmap bitmap,
 					   blk_t bitno);
 /*

--------------030105010909030508030408--
