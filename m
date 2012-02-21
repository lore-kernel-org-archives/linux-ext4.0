From: Phillip Susi <psusi@ubuntu.com>
Subject: [PATCH] e2image: skip uninitialized bitmaps and inode tables
Date: Tue, 21 Feb 2012 16:47:29 -0500
Message-ID: <1329860849-28076-1-git-send-email-psusi@ubuntu.com>
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rrcs-67-78-168-186.se.biz.rr.com ([67.78.168.186]:43728 "EHLO
	iriserv.iradimed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038Ab2BUVrb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Feb 2012 16:47:31 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When the block bitmap is uninitialized, skip copying it.
When the inode bitmap is uninitialized, skip copying it,
as well as the inode table.  When there are unused inodes
towards the end of the table, skip those blocks too.

Signed-off-by: Phillip Susi <psusi@ubuntu.com>
---
 misc/e2image.c |   22 ++++++++++++++++------
 1 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/misc/e2image.c b/misc/e2image.c
index 4343a3d..79c8afb 100644
--- a/misc/e2image.c
+++ b/misc/e2image.c
@@ -342,18 +342,27 @@ static void mark_table_blocks(ext2_filsys fs)
 		/*
 		 * Mark the blocks used for the inode table
 		 */
-		if (ext2fs_inode_table_loc(fs, i)) {
+		if (!ext2fs_bg_flags_test(fs, i, EXT2_BG_INODE_UNINIT) &&
+		    ext2fs_inode_table_loc(fs, i)) {
+			unsigned int end = (unsigned) fs->inode_blocks_per_group;
+			/* skip unused blocks */
+			if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+						       EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
+				end -= (ext2fs_bg_itable_unused(fs, i) /
+					EXT2_INODES_PER_BLOCK(fs->super));
 			for (j = 0, b = ext2fs_inode_table_loc(fs, i);
-			     j < (unsigned) fs->inode_blocks_per_group;
-			     j++, b++)
+			     j < end;
+			     j++, b++) {
 				ext2fs_mark_block_bitmap2(meta_block_map, b);
-			meta_blocks_count += fs->inode_blocks_per_group;
+				meta_blocks_count++;
+			}
 		}
 
 		/*
 		 * Mark block used for the block bitmap
 		 */
-		if (ext2fs_block_bitmap_loc(fs, i)) {
+		if (!ext2fs_bg_flags_test(fs, i, EXT2_BG_BLOCK_UNINIT) &&
+		    ext2fs_block_bitmap_loc(fs, i)) {
 			ext2fs_mark_block_bitmap2(meta_block_map,
 				     ext2fs_block_bitmap_loc(fs, i));
 			meta_blocks_count++;
@@ -362,7 +371,8 @@ static void mark_table_blocks(ext2_filsys fs)
 		/*
 		 * Mark block used for the inode bitmap
 		 */
-		if (ext2fs_inode_bitmap_loc(fs, i)) {
+		if (!ext2fs_bg_flags_test(fs, i, EXT2_BG_INODE_UNINIT) &&
+		    ext2fs_inode_bitmap_loc(fs, i)) {
 			ext2fs_mark_block_bitmap2(meta_block_map,
 				 ext2fs_inode_bitmap_loc(fs, i));
 			meta_blocks_count++;
-- 
1.7.5.4

