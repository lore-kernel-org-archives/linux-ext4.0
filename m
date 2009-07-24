From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC PATCH] tune2fs: Make e2fsprogs handle ENOSPC better with inode resize
Date: Fri, 24 Jul 2009 20:25:38 +0530
Message-ID: <1248447338-24625-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:60447 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbZGXOzt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 24 Jul 2009 10:55:49 -0400
Received: from d23relay02.au.ibm.com (d23relay02.au.ibm.com [202.81.31.244])
	by e23smtp05.au.ibm.com (8.14.3/8.13.1) with ESMTP id n6OErRwL013626
	for <linux-ext4@vger.kernel.org>; Sat, 25 Jul 2009 00:53:27 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay02.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n6OEtm661142806
	for <linux-ext4@vger.kernel.org>; Sat, 25 Jul 2009 00:55:48 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n6OEtlIN031327
	for <linux-ext4@vger.kernel.org>; Sat, 25 Jul 2009 00:55:48 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This removes the metadata block bitmap and makes the error handling
simpler. It also check for the enospc with the correct number needed
blocks. Also added specific error messages. We need to run e2undo
only if we start modyfing inode, group desc and inode table.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 misc/tune2fs.c |   87 ++++++++++++++++++++-----------------------------------
 1 files changed, 32 insertions(+), 55 deletions(-)

diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 2ad3436..2849c7e 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -962,34 +962,23 @@ static void parse_extended_opts(ext2_filsys fs, const char *opts)
 }
 
 /*
- * Fill in two bitmaps that we need to to control the inode resizing
- * process.  The first is the set of blocks that must be moved, and
- * the second is the set of blocks which are allocation bitmap blocks
- * and must be treated specially.
+ * Fill in the block bitmap bmap with the information regarding the
+ * blocks to be moved
  */
 static int get_move_bitmaps(ext2_filsys fs, int new_ino_blks_per_grp,
-			    ext2fs_block_bitmap bmap,
-			    ext2fs_block_bitmap metadata_bmap)
+			ext2fs_block_bitmap bmap)
 {
 	dgrp_t i;
 	blk_t j, needed_blocks = 0;
-	blk_t i_bmap, b_bmap;
 	blk_t start_blk, end_blk;
-	int num, k;
 
 	for (i = 0; i < fs->group_desc_count; i++) {
-		b_bmap = fs->group_desc[i].bg_block_bitmap;
-		ext2fs_mark_block_bitmap(metadata_bmap, b_bmap);
-		i_bmap = fs->group_desc[i].bg_inode_bitmap;
-		ext2fs_mark_block_bitmap(metadata_bmap, i_bmap);
-
 		start_blk = fs->group_desc[i].bg_inode_table +
 					fs->inode_blocks_per_group;
 
 		end_blk = fs->group_desc[i].bg_inode_table +
 					new_ino_blks_per_grp;
 
-		num=0;
 		for (j = start_blk; j < end_blk; j++) {
 			if (ext2fs_test_block_bitmap(fs->block_map, j)) {
 				/* FIXME!!
@@ -997,7 +986,6 @@ static int get_move_bitmaps(ext2_filsys fs, int new_ino_blks_per_grp,
 				 * as a bad block
 				 */
 				ext2fs_mark_block_bitmap(bmap, j);
-				needed_blocks++;
 			} else {
 				/*
 				 * We are going to use this block for
@@ -1005,11 +993,8 @@ static int get_move_bitmaps(ext2_filsys fs, int new_ino_blks_per_grp,
 				 */
 				ext2fs_mark_block_bitmap(fs->block_map, j);
 			}
-			if ((j == i_bmap) || (j == b_bmap))
-				num++;
 		}
-		if (num <= fs->group_desc[i].bg_free_blocks_count) 
-			continue;
+		needed_blocks += end_blk - start_blk;
 	}
 
 	if (needed_blocks > fs->super->s_free_blocks_count)
@@ -1018,14 +1003,12 @@ static int get_move_bitmaps(ext2_filsys fs, int new_ino_blks_per_grp,
 	return 0;
 }
 
-static int move_block(ext2_filsys fs, ext2fs_block_bitmap bmap,
-		      ext2fs_block_bitmap metadata_bmap)
+static int move_block(ext2_filsys fs, ext2fs_block_bitmap bmap)
 {
 	char *buf;
 	errcode_t retval;
 	blk_t blk, new_blk, goal;
 	struct blk_move *bmv;
-	dgrp_t		group;
 
 	retval = ext2fs_get_mem(fs->blocksize, &buf);
 	if (retval)
@@ -1036,16 +1019,7 @@ static int move_block(ext2_filsys fs, ext2fs_block_bitmap bmap,
 		if (!ext2fs_test_block_bitmap(bmap, blk))
 			continue;
 
-		/*
-		 * If the block is a bitmap block, find a new block in
-		 * the same block group.
-		 */
-		if (ext2fs_test_block_bitmap(metadata_bmap, blk)) {
-			group = ext2fs_group_of_blk(fs, blk);
-			goal = ext2fs_group_first_block(fs, group);
-		} else
-			goal = new_blk;
-
+		goal = new_blk;
 		retval = ext2fs_new_block(fs, goal, NULL, &new_blk);
 		if (retval)
 			goto err_out;
@@ -1367,7 +1341,7 @@ static int resize_inode(ext2_filsys fs, unsigned long new_size)
 {
 	errcode_t retval;
 	int new_ino_blks_per_grp;
-	ext2fs_block_bitmap bmap, metadata_bmap;
+	ext2fs_block_bitmap bmap;
 
 	ext2fs_read_inode_bitmap(fs);
 	ext2fs_read_block_bitmap(fs);
@@ -1387,34 +1361,32 @@ static int resize_inode(ext2_filsys fs, unsigned long new_size)
 
 	retval = ext2fs_allocate_block_bitmap(fs, _("blocks to be moved"),
 						&bmap);
-	if (retval)
-		return retval;
-
-	retval = ext2fs_allocate_block_bitmap(fs, _("blocks to be moved"),
-						&metadata_bmap);
-	if (retval)
+	if (retval) {
+		fputs(_("Failed to allocate block bitmap when "
+				"increasing inode size\n"), stderr);
 		return retval;
-
-	retval = get_move_bitmaps(fs, new_ino_blks_per_grp, bmap,
-				  metadata_bmap);
-	if (retval)
+	}
+	retval = get_move_bitmaps(fs, new_ino_blks_per_grp, bmap);
+	if (retval) {
+		fputs(_("Not enough space to increase inode size \n"), stderr);
 		goto err_out;
-
-	retval = move_block(fs, bmap, metadata_bmap);
-	if (retval)
+	}
+	retval = move_block(fs, bmap);
+	if (retval) {
+		fputs(_("Failed to relocate blocks during inode resize \n"), stderr);
 		goto err_out;
-
+	}
 	retval = inode_scan_and_fix(fs, bmap);
 	if (retval)
-		goto err_out;
+		goto err_out_undo;
 
 	retval = group_desc_scan_and_fix(fs, bmap);
 	if (retval)
-		goto err_out;
+		goto err_out_undo;
 
 	retval = expand_inode_table(fs, new_size);
 	if (retval)
-		goto err_out;
+		goto err_out_undo;
 
 	ext2fs_calculate_summary_stats(fs);
 
@@ -1428,6 +1400,15 @@ err_out:
 	ext2fs_free_block_bitmap(bmap);
 
 	return retval;
+
+err_out_undo:
+	free_blk_move_list();
+	ext2fs_free_block_bitmap(bmap);
+	fputs(_("Error in resizing the inode size.\n"
+			"Run e2undo to undo the "
+			"file system changes. \n"), stderr);
+
+	return retval;
 }
 
 static int tune2fs_setup_tdb(const char *name, io_manager *io_ptr)
@@ -1744,11 +1725,7 @@ retry_open:
 		 * with the new free inode count
 		 */
 		fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
-		if (resize_inode(fs, new_inode_size)) {
-			fputs(_("Error in resizing the inode size.\n"
-				"Run e2undo to undo the "
-				"file system changes. \n"), stderr);
-		} else {
+		if (resize_inode(fs, new_inode_size) == 0) {
 			printf(_("Setting inode size %lu\n"),
 							new_inode_size);
 		}
-- 
1.6.4.rc2

