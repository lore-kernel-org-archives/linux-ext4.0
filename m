From: Valerie Clement <valerie.clement@bull.net>
Subject: [RFC][PATCH 11/12] convert blk_t to 64-bit for ext4 FS in e2fsprogs
Date: Mon, 11 Jun 2007 18:54:43 +0200
Message-ID: <466D7E53.5020704@bull.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080502010106060107030606"
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:49388 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973AbXFKQxW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Jun 2007 12:53:22 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is a multi-part message in MIME format.
--------------080502010106060107030606
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed

This patch converts blk_t type to __u64 when compiling code with
_EXT4FS_ option.
Force the 64-bit feature when the filesystem is greater than 2**32
blocks.

  lib/ext2fs/ext2_fs.h |    3 ++-
  lib/ext2fs/ext2fs.h  |   15 +++++++++++----
  misc/mke2fs.c        |   12 +++++++++++-
  3 files changed, 24 insertions(+), 6 deletions(-)




--------------080502010106060107030606
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
 name="11-allow_larger_fs"
Content-Disposition: inline;
 filename="11-allow_larger_fs"

Index: e2fsprogs-1.39-tyt3-v6/misc/mke2fs.c
===================================================================
--- e2fsprogs-1.39-tyt3-v6.orig/misc/mke2fs.c	2007-06-11 12:49:01.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v6/misc/mke2fs.c	2007-06-11 15:39:25.000000000 +0200
@@ -1396,6 +1396,15 @@ static void PRS(int argc, char *argv[])
 		blocksize = use_bsize;
 		EXT2_BLOCKS_COUNT_SET(&fs_param,
 			EXT2_BLOCKS_COUNT(&fs_param) / (blocksize / 1024));
+		if (EXT2_BLOCKS_COUNT(&fs_param) >> 31) {
+			fprintf(stderr, _("\nWarning:"
+			"Filesystem greater than 2**32 blocks, "
+			"64-bit incompatible feature forced.\n\n"));
+			fs_param.s_feature_incompat |=
+				EXT4_FEATURE_INCOMPAT_64BIT;
+			fs_param.s_desc_size =
+				EXT2_MIN_DESC_SIZE_64BIT;
+		}
 	}
 
 	if (inode_ratio == 0) {
@@ -1442,7 +1451,8 @@ static void PRS(int argc, char *argv[])
 		fs_param.s_desc_size = EXT2_MIN_DESC_SIZE_64BIT;
 	}
 
-	if (!force && EXT2_BLOCKS_COUNT(&fs_param) >= ((unsigned) 1 << 31)) {
+	if (!force && (fs_param.s_desc_size < EXT2_MIN_DESC_SIZE_64BIT)
+		&& EXT2_BLOCKS_COUNT(&fs_param) >= ((unsigned) 1 << 31)) {
 		com_err(program_name, 0,
 			_("Filesystem too large.  No more than 2**31-1 blocks\n"
 			  "\t (8TB using a blocksize of 4k) are currently supported."));
Index: e2fsprogs-1.39-tyt3-v6/lib/ext2fs/ext2fs.h
===================================================================
--- e2fsprogs-1.39-tyt3-v6.orig/lib/ext2fs/ext2fs.h	2007-06-11 12:48:59.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v6/lib/ext2fs/ext2fs.h	2007-06-11 12:49:04.000000000 +0200
@@ -73,7 +73,12 @@ extern "C" {
 #endif /* EXT2_FLAT_INCLUDES */
 
 typedef __u32		ext2_ino_t;
+#ifdef _EXT4FS_
+#define _EXT2_64BIT_BLK_T	1
+typedef __u64		blk_t;
+#else
 typedef __u32		blk_t;
+#endif
 typedef __u64		blk64_t;
 typedef __u32		dgrp_t;
 typedef __u32		ext2_off_t;
@@ -495,13 +500,15 @@ struct ext2fs_extent {
 					 EXT3_FEATURE_INCOMPAT_JOURNAL_DEV|\
 					 EXT2_FEATURE_INCOMPAT_META_BG|\
 					 EXT3_FEATURE_INCOMPAT_RECOVER|\
-					 EXT3_FEATURE_INCOMPAT_EXTENTS)
+					 EXT3_FEATURE_INCOMPAT_EXTENTS|\
+					 EXT4_FEATURE_INCOMPAT_64BIT)
 #else
 #define EXT2_LIB_FEATURE_INCOMPAT_SUPP	(EXT2_FEATURE_INCOMPAT_FILETYPE|\
 					 EXT3_FEATURE_INCOMPAT_JOURNAL_DEV|\
 					 EXT2_FEATURE_INCOMPAT_META_BG|\
 					 EXT3_FEATURE_INCOMPAT_RECOVER|\
-					 EXT3_FEATURE_INCOMPAT_EXTENTS)
+					 EXT3_FEATURE_INCOMPAT_EXTENTS|\
+					 EXT4_FEATURE_INCOMPAT_64BIT)
 #endif
 #define EXT2_LIB_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER|\
 					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE)
@@ -1262,7 +1269,7 @@ _INLINE_ int ext2fs_group_of_ino(ext2_fi
 _INLINE_ blk_t ext2fs_group_first_block(ext2_filsys fs, dgrp_t group)
 {
 	return fs->super->s_first_data_block +
-		(group * fs->super->s_blocks_per_group);
+		(group * EXT2_BLOCKS_PER_GROUP(fs->super));
 }
 
 /*
@@ -1273,7 +1280,7 @@ _INLINE_ blk_t ext2fs_group_last_block(e
 	return (group == fs->group_desc_count - 1 ?
 		EXT2_BLOCKS_COUNT(fs->super) - 1 :
 		ext2fs_group_first_block(fs, group) +
-			(fs->super->s_blocks_per_group - 1));
+			(EXT2_BLOCKS_PER_GROUP(fs->super) - 1));
 }
 
 _INLINE_ blk_t ext2fs_inode_data_blocks(ext2_filsys fs,
Index: e2fsprogs-1.39-tyt3-v6/lib/ext2fs/ext2_fs.h
===================================================================
--- e2fsprogs-1.39-tyt3-v6.orig/lib/ext2fs/ext2_fs.h	2007-06-11 12:49:01.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v6/lib/ext2fs/ext2_fs.h	2007-06-11 15:31:48.000000000 +0200
@@ -751,7 +751,8 @@ struct ext2_super_block {
 
 
 #define EXT2_FEATURE_COMPAT_SUPP	0
-#define EXT2_FEATURE_INCOMPAT_SUPP	(EXT2_FEATURE_INCOMPAT_FILETYPE)
+#define EXT2_FEATURE_INCOMPAT_SUPP	(EXT2_FEATURE_INCOMPAT_FILETYPE| \
+					 EXT4_FEATURE_INCOMPAT_64BIT)
 #define EXT2_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER| \
 					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE| \
 					 EXT2_FEATURE_RO_COMPAT_BTREE_DIR)

--------------080502010106060107030606--
