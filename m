From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 2/3] e2fsprogs: move code computing old_desc_blocks to a function
Date: Wed,  4 Jan 2012 19:02:11 +0800
Message-ID: <1325674932-26069-2-git-send-email-xiaoqiangnk@gmail.com>
References: <1325674932-26069-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:47039 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755755Ab2ADOwz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Jan 2012 09:52:55 -0500
Received: by ggdk6 with SMTP id k6so10283392ggd.19
        for <linux-ext4@vger.kernel.org>; Wed, 04 Jan 2012 06:52:55 -0800 (PST)
In-Reply-To: <1325674932-26069-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Code computing old desc blocks is put into a function.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 e2fsck/pass5.c        |    8 +-------
 lib/ext2fs/alloc.c    |    6 +-----
 lib/ext2fs/alloc_sb.c |    6 +-----
 lib/ext2fs/blknum.c   |   14 ++++++++++++++
 lib/ext2fs/closefs.c  |    7 +------
 lib/ext2fs/ext2fs.h   |    1 +
 resize/resize2fs.c    |   41 ++++++++---------------------------------
 7 files changed, 27 insertions(+), 56 deletions(-)

diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index a60e84a..d9a4488 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -216,13 +216,7 @@ redo_counts:
 				ext2fs_super_and_bgd_loc2(fs, group, &super_blk,
 					 &old_desc_blk, &new_desc_blk, 0);
 
-				if (fs->super->s_feature_incompat &
-						EXT2_FEATURE_INCOMPAT_META_BG)
-					old_desc_blocks =
-						fs->super->s_first_meta_bg;
-				else
-					old_desc_blocks = fs->desc_blocks +
-					fs->super->s_reserved_gdt_blocks;
+				old_desc_blocks = ext2fs_old_desc_blocks_count(fs); 
 
 				count = 0;
 				cmp_block = fs->super->s_clusters_per_group;
diff --git a/lib/ext2fs/alloc.c b/lib/ext2fs/alloc.c
index 948a0ec..960a6e2 100644
--- a/lib/ext2fs/alloc.c
+++ b/lib/ext2fs/alloc.c
@@ -47,11 +47,7 @@ static void check_block_uninit(ext2_filsys fs, ext2fs_block_bitmap map,
 	ext2fs_super_and_bgd_loc2(fs, group, &super_blk,
 				  &old_desc_blk, &new_desc_blk, 0);
 
-	if (fs->super->s_feature_incompat &
-	    EXT2_FEATURE_INCOMPAT_META_BG)
-		old_desc_blocks = fs->super->s_first_meta_bg;
-	else
-		old_desc_blocks = fs->desc_blocks + fs->super->s_reserved_gdt_blocks;
+	old_desc_blocks = ext2fs_old_desc_blocks_count(fs);
 
 	for (i=0; i < fs->super->s_blocks_per_group; i++, blk++)
 		ext2fs_fast_unmark_block_bitmap2(map, blk);
diff --git a/lib/ext2fs/alloc_sb.c b/lib/ext2fs/alloc_sb.c
index 7517fbc..feb39f7 100644
--- a/lib/ext2fs/alloc_sb.c
+++ b/lib/ext2fs/alloc_sb.c
@@ -52,11 +52,7 @@ int ext2fs_reserve_super_and_bgd(ext2_filsys fs,
 	ext2fs_super_and_bgd_loc2(fs, group, &super_blk,
 				  &old_desc_blk, &new_desc_blk, &used_blks);
 
-	if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG)
-		old_desc_blocks = fs->super->s_first_meta_bg;
-	else
-		old_desc_blocks =
-			fs->desc_blocks + fs->super->s_reserved_gdt_blocks;
+	old_desc_blocks = ext2fs_old_desc_blocks_count(fs);
 
 	if (super_blk || (group == 0))
 		ext2fs_mark_block_bitmap2(bmap, super_blk);
diff --git a/lib/ext2fs/blknum.c b/lib/ext2fs/blknum.c
index 33da7d6..f1d5156 100644
--- a/lib/ext2fs/blknum.c
+++ b/lib/ext2fs/blknum.c
@@ -98,6 +98,20 @@ blk64_t ext2fs_blocks_count(struct ext2_super_block *super)
 }
 
 /*
+ * Return the old desc blocks count
+ */
+blk64_t ext2fs_old_desc_blocks_count(ext2_filsys fs)
+{
+	blk64_t old_desc_blocks;
+
+	old_desc_blocks = fs->desc_blocks + fs->super->s_reserved_gdt_blocks;
+	if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG &&
+	    old_desc_blocks > fs->super->s_first_meta_bg)
+		old_desc_blocks = fs->super->s_first_meta_bg;
+	return old_desc_blocks;
+}
+
+/*
  * Set the fs block count
  */
 void ext2fs_blocks_count_set(struct ext2_super_block *super, blk64_t blk)
diff --git a/lib/ext2fs/closefs.c b/lib/ext2fs/closefs.c
index 54a24f8..0a97b69 100644
--- a/lib/ext2fs/closefs.c
+++ b/lib/ext2fs/closefs.c
@@ -77,12 +77,7 @@ errcode_t ext2fs_super_and_bgd_loc2(ext2_filsys fs,
 	if (group_block == 0 && fs->blocksize == 1024)
 		group_block = 1; /* Deal with 1024 blocksize && bigalloc */
 
-	if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG)
-		old_desc_blocks = fs->super->s_first_meta_bg;
-	else
-		old_desc_blocks =
-			fs->desc_blocks + fs->super->s_reserved_gdt_blocks;
-
+	old_desc_blocks = ext2fs_old_desc_blocks_count(fs);
 	has_super = ext2fs_bg_has_super(fs, group);
 
 	if (has_super) {
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 227ee58..78f0f94 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -805,6 +805,7 @@ extern blk64_t ext2fs_inode_data_blocks2(ext2_filsys fs,
 extern blk64_t ext2fs_inode_i_blocks(ext2_filsys fs,
 					 struct ext2_inode *inode);
 extern blk64_t ext2fs_blocks_count(struct ext2_super_block *super);
+extern blk64_t ext2fs_old_desc_blocks_count(ext2_filsys fs);
 extern void ext2fs_blocks_count_set(struct ext2_super_block *super,
 				    blk64_t blk);
 extern void ext2fs_blocks_count_add(struct ext2_super_block *super,
diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 06ce73e..0e5cb9e 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -195,6 +195,8 @@ static void fix_uninit_block_bitmaps(ext2_filsys fs)
 					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM)))
 		return;
 
+	old_desc_blocks = ext2fs_old_desc_blocks_count(fs);
+
 	for (g=0; g < fs->group_desc_count; g++) {
 		if (!(ext2fs_bg_flags_test(fs, g, EXT2_BG_BLOCK_UNINIT)))
 			continue;
@@ -205,11 +207,6 @@ static void fix_uninit_block_bitmaps(ext2_filsys fs)
 		ext2fs_super_and_bgd_loc2(fs, g, &super_blk,
 					  &old_desc_blk, &new_desc_blk, 0);
 
-		if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG)
-			old_desc_blocks = fs->super->s_first_meta_bg;
-		else
-			old_desc_blocks = fs->desc_blocks +
-				fs->super->s_reserved_gdt_blocks;
 
 		for (i=0; i < fs->super->s_blocks_per_group; i++, blk++) {
 			if (blk >= ext2fs_blocks_count(fs->super))
@@ -486,11 +483,7 @@ retry:
 					       EXT4_FEATURE_RO_COMPAT_GDT_CSUM);
 	adj = old_fs->group_desc_count;
 	max_group = fs->group_desc_count - adj;
-	if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG)
-		old_desc_blocks = fs->super->s_first_meta_bg;
-	else
-		old_desc_blocks = fs->desc_blocks +
-			fs->super->s_reserved_gdt_blocks;
+	old_desc_blocks = ext2fs_old_desc_blocks_count(fs);
 	for (i = old_fs->group_desc_count;
 	     i < fs->group_desc_count; i++) {
 		memset(ext2fs_group_desc(fs, fs->group_desc, i), 0,
@@ -684,11 +677,7 @@ static errcode_t mark_table_blocks(ext2_filsys fs,
 	unsigned int		old_desc_blocks;
 
 	meta_bg_size = EXT2_DESC_PER_BLOCK(fs->super);
-	if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG)
-		old_desc_blocks = fs->super->s_first_meta_bg;
-	else
-		old_desc_blocks = fs->desc_blocks +
-			fs->super->s_reserved_gdt_blocks;
+	old_desc_blocks = ext2fs_old_desc_blocks_count(fs);
 	for (i = 0; i < fs->group_desc_count; i++) {
 		ext2fs_reserve_super_and_bgd(fs, i, bmap);
 
@@ -823,13 +812,8 @@ static errcode_t blocks_to_move(ext2_resize_t rfs)
 		ext2fs_mark_block_bitmap2(rfs->reserve_blocks, blk);
 	}
 
-	if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG) {
-		old_blocks = old_fs->super->s_first_meta_bg;
-		new_blocks = fs->super->s_first_meta_bg;
-	} else {
-		old_blocks = old_fs->desc_blocks + old_fs->super->s_reserved_gdt_blocks;
-		new_blocks = fs->desc_blocks + fs->super->s_reserved_gdt_blocks;
-	}
+	old_blocks = ext2fs_old_desc_blocks_count(old_fs); 
+	new_blocks = ext2fs_old_desc_blocks_count(fs);
 
 	if (old_blocks == new_blocks) {
 		retval = 0;
@@ -1773,11 +1757,7 @@ static errcode_t ext2fs_calculate_summary_stats(ext2_filsys fs)
 	uninit = ext2fs_bg_flags_test(fs, group, EXT2_BG_BLOCK_UNINIT);
 	ext2fs_super_and_bgd_loc2(fs, group, &super_blk, &old_desc_blk,
 				  &new_desc_blk, 0);
-	if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG)
-		old_desc_blocks = fs->super->s_first_meta_bg;
-	else
-		old_desc_blocks = fs->desc_blocks +
-			fs->super->s_reserved_gdt_blocks;
+	old_desc_blocks = ext2fs_old_desc_blocks_count(fs);
 	for (blk = fs->super->s_first_data_block;
 	     blk < ext2fs_blocks_count(fs->super); blk++) {
 		if ((uninit &&
@@ -1809,12 +1789,7 @@ static errcode_t ext2fs_calculate_summary_stats(ext2_filsys fs)
 			ext2fs_super_and_bgd_loc2(fs, group, &super_blk,
 						  &old_desc_blk,
 						  &new_desc_blk, 0);
-			if (fs->super->s_feature_incompat &
-			    EXT2_FEATURE_INCOMPAT_META_BG)
-				old_desc_blocks = fs->super->s_first_meta_bg;
-			else
-				old_desc_blocks = fs->desc_blocks +
-					fs->super->s_reserved_gdt_blocks;
+			old_desc_blocks = ext2fs_old_desc_blocks_count(fs);
 		}
 	}
 	ext2fs_free_blocks_count_set(fs->super, total_free);
-- 
1.7.5.1

