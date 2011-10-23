From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 5/8] e2fsprogs: add exclude bitmap support in dumpe2fs
Date: Sun, 23 Oct 2011 15:21:25 +0800
Message-ID: <1319354488-6050-6-git-send-email-xiaoqiangnk@gmail.com>
References: <1319354488-6050-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: amir73il@users.sf.net, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58496 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218Ab1JWJLD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 23 Oct 2011 05:11:03 -0400
Received: by mail-iy0-f174.google.com with SMTP id y12so71200iab.19
        for <linux-ext4@vger.kernel.org>; Sun, 23 Oct 2011 02:11:03 -0700 (PDT)
In-Reply-To: <1319354488-6050-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Exclude bitmap feature is needed by ext4 snapshot.  This patch adds
exclude bitmap support in dumpe2fs.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 misc/dumpe2fs.c |   28 +++++++++++++++++++++++++++-
 1 files changed, 27 insertions(+), 1 deletions(-)

diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
index df241c2..6b39575 100644
--- a/misc/dumpe2fs.c
+++ b/misc/dumpe2fs.c
@@ -119,6 +119,8 @@ static void print_bg_opts(ext2_filsys fs, dgrp_t i)
 
 	print_bg_opt(bg_flags, EXT2_BG_INODE_UNINIT, "INODE_UNINIT",
  		     &first);
+	print_bg_opt(bg_flags, EXT2_BG_EXCLUDE_UNINIT, "EXCLUDE_UNINIT",
+		     &first);
 	print_bg_opt(bg_flags, EXT2_BG_BLOCK_UNINIT, "BLOCK_UNINIT",
  		     &first);
 	print_bg_opt(bg_flags, EXT2_BG_INODE_ZEROED, "ITABLE_ZEROED",
@@ -148,12 +150,13 @@ static void list_desc (ext2_filsys fs)
 	unsigned long i;
 	blk64_t	first_block, last_block;
 	blk64_t	super_blk, old_desc_blk, new_desc_blk;
-	char *block_bitmap=NULL, *inode_bitmap=NULL;
+	char *block_bitmap = NULL, *exclude_bitmap = NULL, *inode_bitmap = NULL;
 	const char *units = _("blocks");
 	int inode_blocks_per_group, old_desc_blocks, reserved_gdt;
 	int		block_nbytes, inode_nbytes;
 	int has_super;
 	blk64_t		blk_itr = EXT2FS_B2C(fs, fs->super->s_first_data_block);
+	blk64_t		exclude_itr = blk_itr;
 	ext2_ino_t	ino_itr = 1;
 
 	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
@@ -165,6 +168,8 @@ static void list_desc (ext2_filsys fs)
 
 	if (fs->block_map)
 		block_bitmap = malloc(block_nbytes);
+	if (fs->exclude_map)
+		exclude_bitmap = malloc(block_nbytes);
 	if (fs->inode_map)
 		inode_bitmap = malloc(inode_nbytes);
 
@@ -222,6 +227,14 @@ static void list_desc (ext2_filsys fs)
 		print_number(ext2fs_block_bitmap_loc(fs, i));
 		print_bg_rel_offset(fs, ext2fs_block_bitmap_loc(fs, i), 0,
 				    first_block, last_block);
+		if (fs->super->s_feature_compat &
+				EXT2_FEATURE_COMPAT_EXCLUDE_BITMAP) {
+			fputs(_(", snapshot bitmap at "), stdout);
+			print_number(ext2fs_exclude_bitmap_loc(fs, i));
+			print_bg_rel_offset(fs,
+					ext2fs_exclude_bitmap_loc(fs, i),
+					0, first_block, last_block);
+		}
 		fputs(_(", Inode bitmap at "), stdout);
 		print_number(ext2fs_inode_bitmap_loc(fs, i));
 		print_bg_rel_offset(fs, ext2fs_inode_bitmap_loc(fs, i), 0,
@@ -252,6 +265,17 @@ static void list_desc (ext2_filsys fs)
 			fputc('\n', stdout);
 			blk_itr += fs->super->s_clusters_per_group;
 		}
+		if (exclude_bitmap) {
+			fputs(_("  Non-snapshot blocks: "), stdout);
+			ext2fs_get_exclude_bitmap_range2(fs->exclude_map,
+				exclude_itr, block_nbytes << 3, exclude_bitmap);
+			print_free(i, block_bitmap,
+				   fs->super->s_clusters_per_group,
+				   fs->super->s_first_data_block,
+				   EXT2FS_CLUSTER_RATIO(fs));
+			fputc('\n', stdout);
+			exclude_itr += fs->super->s_blocks_per_group;
+		}
 		if (inode_bitmap) {
 			fputs(_("  Free inodes: "), stdout);
 			ext2fs_get_inode_bitmap_range2(fs->inode_map,
@@ -264,6 +288,8 @@ static void list_desc (ext2_filsys fs)
 	}
 	if (block_bitmap)
 		free(block_bitmap);
+	if (exclude_bitmap)
+		free(exclude_bitmap);
 	if (inode_bitmap)
 		free(inode_bitmap);
 }
-- 
1.7.5.1

