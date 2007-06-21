From: Valerie Clement <valerie.clement@bull.net>
Subject: [RFC][PATCH 2/11][take 2] add new macro EXT2_DESC_PER_BLOCK in e2fsprogs
Date: Thu, 21 Jun 2007 17:15:01 +0200
Message-ID: <467A95F5.6050300@bull.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010203010100040508000306"
To: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:37056 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757429AbXFUPz3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Jun 2007 11:55:29 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is a multi-part message in MIME format.
--------------010203010100040508000306
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed

This patch introduces a new macro EXT2_DESC_PER_BLOCK to calculate the 
number of group descriptors per block as two different structures are 
defined.

Change from previous version:
use s_desc_size instead of sizeof(struct ext4_group_desc)

  lib/ext2fs/closefs.c    |    2 +-
  lib/ext2fs/ext2_fs.h    |    4 +++-
  lib/ext2fs/initialize.c |    2 +-
  lib/ext2fs/openfs.c     |    4 ++--
  misc/mke2fs.c           |    5 ++---
  resize/resize2fs.c      |    7 +++----
  6 files changed, 12 insertions(+), 12 deletions(-)


--------------010203010100040508000306
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
 name="02-add-new-macro-to-get-nb-desc-per-block"
Content-Disposition: inline;
 filename="02-add-new-macro-to-get-nb-desc-per-block"

Index: e2fsprogs-1.39-tyt3-v7/misc/mke2fs.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/misc/mke2fs.c	2007-06-14 12:03:48.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/misc/mke2fs.c	2007-06-18 19:25:52.000000000 +0200
@@ -687,8 +687,7 @@ static void show_stats(ext2_filsys fs)
 	if (s->s_reserved_gdt_blocks)
 		printf(_("Maximum filesystem blocks=%lu\n"),
 		       (s->s_reserved_gdt_blocks + fs->desc_blocks) *
-		       (fs->blocksize / sizeof(struct ext2_group_desc)) *
-		       s->s_blocks_per_group);
+		       EXT2_DESC_PER_BLOCK(s) * s->s_blocks_per_group);
 	if (fs->group_desc_count > 1)
 		printf(_("%u block groups\n"), fs->group_desc_count);
 	else
@@ -820,7 +819,7 @@ static void parse_extended_opts(struct e
 			bpg = param->s_blocks_per_group;
 			if (!bpg)
 				bpg = blocksize * 8;
-			gdpb = blocksize / sizeof(struct ext2_group_desc);
+			gdpb = EXT2_DESC_PER_BLOCK(param);
 			group_desc_count = 
 				ext2fs_div_ceil(param->s_blocks_count, bpg);
 			desc_blocks = (group_desc_count +
Index: e2fsprogs-1.39-tyt3-v7/lib/ext2fs/openfs.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/lib/ext2fs/openfs.c	2007-04-30 07:10:05.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/lib/ext2fs/openfs.c	2007-06-18 19:25:53.000000000 +0200
@@ -39,7 +39,7 @@ blk_t ext2fs_descriptor_block_loc(ext2_f
 	    (i < fs->super->s_first_meta_bg))
 		return (group_block + i + 1);
 
-	bg = (fs->blocksize / sizeof (struct ext2_group_desc)) * i;
+	bg = EXT2_DESC_PER_BLOCK(fs->super) * i;
 	if (ext2fs_bg_has_super(fs, bg))
 		has_super = 1;
 	ret_blk = (fs->super->s_first_data_block + has_super + 
@@ -281,7 +281,7 @@ errcode_t ext2fs_open2(const char *name,
 	if (!group_block)
 		group_block = fs->super->s_first_data_block;
 	dest = (char *) fs->group_desc;
-	groups_per_block = fs->blocksize / sizeof(struct ext2_group_desc);
+	groups_per_block = EXT2_DESC_PER_BLOCK(fs->super);
 	for (i=0 ; i < fs->desc_blocks; i++) {
 		blk = ext2fs_descriptor_block_loc(fs, group_block, i);
 		retval = io_channel_read_blk(fs->io, blk, 1, dest);
Index: e2fsprogs-1.39-tyt3-v7/lib/ext2fs/closefs.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/lib/ext2fs/closefs.c	2007-04-30 07:10:05.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/lib/ext2fs/closefs.c	2007-06-18 19:25:53.000000000 +0200
@@ -81,7 +81,7 @@ int ext2fs_super_and_bgd_loc(ext2_filsys
 		super_blk = group_block;
 		numblocks--;
 	}
-	meta_bg_size = (fs->blocksize / sizeof (struct ext2_group_desc));
+	meta_bg_size = EXT2_DESC_PER_BLOCK(fs->super);
 	meta_bg = group / meta_bg_size;
 
 	if (!(fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG) ||
Index: e2fsprogs-1.39-tyt3-v7/lib/ext2fs/ext2_fs.h
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/lib/ext2fs/ext2_fs.h	2007-06-14 12:03:48.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/lib/ext2fs/ext2_fs.h	2007-06-18 19:26:38.000000000 +0200
@@ -234,7 +234,9 @@ struct ext2_dx_countlimit {
 #define EXT2_DESC_PER_BLOCK(s)		(EXT2_SB(s)->s_desc_per_block)
 #define EXT2_DESC_PER_BLOCK_BITS(s)	(EXT2_SB(s)->s_desc_per_block_bits)
 #else
-#define EXT2_DESC_PER_BLOCK(s)		(EXT2_BLOCK_SIZE(s) / sizeof (struct ext2_group_desc))
+#define EXT2_DESC_PER_BLOCK(s)		(EXT2_BLOCK_SIZE(s) / \
+	((EXT2_DESC_SIZE(s) >= EXT2_MIN_DESC_SIZE_64BIT) ? \
+	 (s)->s_desc_size : sizeof(struct ext2_group_desc)))
 #endif
 
 /*
Index: e2fsprogs-1.39-tyt3-v7/lib/ext2fs/initialize.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/lib/ext2fs/initialize.c	2007-06-14 12:03:48.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/lib/ext2fs/initialize.c	2007-06-18 19:25:52.000000000 +0200
@@ -67,7 +67,7 @@ static unsigned int calc_reserved_gdt_bl
 {
 	struct ext2_super_block *sb = fs->super;
 	unsigned long bpg = sb->s_blocks_per_group;
-	unsigned int gdpb = fs->blocksize / sizeof(struct ext2_group_desc);
+	unsigned int gdpb = EXT2_DESC_PER_BLOCK(sb);
 	unsigned long max_blocks = 0xffffffff;
 	unsigned long rsv_groups;
 	unsigned int rsv_gdb;
Index: e2fsprogs-1.39-tyt3-v7/resize/resize2fs.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/resize/resize2fs.c	2007-04-30 07:10:05.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/resize/resize2fs.c	2007-06-18 19:25:53.000000000 +0200
@@ -382,8 +382,7 @@ retry:
 			ext2fs_mark_block_bitmap(fs->block_map, group_block);
 			adjblocks++;
 		}
-		meta_bg_size = (fs->blocksize /
-				sizeof (struct ext2_group_desc));
+		meta_bg_size = EXT2_DESC_PER_BLOCK(fs->super);
 		meta_bg = i / meta_bg_size;
 		if (!(fs->super->s_feature_incompat &
 		      EXT2_FEATURE_INCOMPAT_META_BG) ||
@@ -549,7 +548,7 @@ static errcode_t mark_table_blocks(ext2_
 	unsigned long		meta_bg_size;
 	unsigned int		old_desc_blocks;
 
-	meta_bg_size = (fs->blocksize / sizeof (struct ext2_group_desc));
+	meta_bg_size = EXT2_DESC_PER_BLOCK(fs->super);
 	if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG)
 		old_desc_blocks = fs->super->s_first_meta_bg;
 	else
@@ -716,7 +715,7 @@ static errcode_t blocks_to_move(ext2_res
 	 * If we're increasing the number of descriptor blocks, life
 	 * gets interesting....  
 	 */
-	meta_bg_size = (fs->blocksize / sizeof (struct ext2_group_desc));
+	meta_bg_size = EXT2_DESC_PER_BLOCK(fs->super);
 	for (i = 0; i < max_groups; i++) {
 		has_super = ext2fs_bg_has_super(fs, i);
 		if (has_super)

--------------010203010100040508000306--
