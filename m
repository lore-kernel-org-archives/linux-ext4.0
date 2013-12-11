From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 47/74] resize2fs: during shrink,
 don't free in-use bg data clusters
Date: Tue, 10 Dec 2013 17:23:33 -0800
Message-ID: <20131211012333.30655.80931.stgit@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43394 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584Ab3LKBXk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 20:23:40 -0500
In-Reply-To: <20131211011813.30655.39624.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When freeing a group's metadata blocks, be careful not to free
clusters belonging to other groups!

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 resize/resize2fs.c |   78 +++++++++++++++++++++++++++++++++-------------------
 1 file changed, 49 insertions(+), 29 deletions(-)


diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index ff5e6a2..49fe986 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -270,40 +270,60 @@ static void fix_uninit_block_bitmaps(ext2_filsys fs)
  * release them in the new filesystem data structure, and mark them as
  * reserved so the old inode table blocks don't get overwritten.
  */
-static void free_gdp_blocks(ext2_filsys fs,
-			    ext2fs_block_bitmap reserve_blocks,
-			    ext2_filsys old_fs,
-			    dgrp_t group)
+static errcode_t free_gdp_blocks(ext2_filsys fs,
+				 ext2fs_block_bitmap reserve_blocks,
+				 ext2_filsys old_fs,
+				 dgrp_t group, dgrp_t count)
 {
 	blk64_t	blk;
 	int	j;
+	dgrp_t	i;
+	ext2fs_block_bitmap bg_map = NULL;
+	errcode_t retval = 0;
 
-	blk = ext2fs_block_bitmap_loc(old_fs, group);
-	if (blk &&
-	    (blk < ext2fs_blocks_count(fs->super))) {
-		ext2fs_block_alloc_stats2(fs, blk, -1);
-		ext2fs_mark_block_bitmap2(reserve_blocks, blk);
-	}
+	/* If bigalloc, don't free metadata living in the same cluster */
+	if (EXT2FS_CLUSTER_RATIO(fs) > 1) {
+		retval = ext2fs_allocate_block_bitmap(fs, "bgdata", &bg_map);
+		if (retval)
+			goto out;
 
-	blk = ext2fs_inode_bitmap_loc(old_fs, group);
-	if (blk &&
-	    (blk < ext2fs_blocks_count(fs->super))) {
-		ext2fs_block_alloc_stats2(fs, blk, -1);
-		ext2fs_mark_block_bitmap2(reserve_blocks, blk);
+		retval = mark_table_blocks(fs, bg_map);
+		if (retval)
+			goto out;
 	}
 
-	blk = ext2fs_inode_table_loc(old_fs, group);
-	if (blk == 0 ||
-	    (blk >= ext2fs_blocks_count(fs->super)))
-		return;
+	for (i = group; i < group + count; i++) {
+		blk = ext2fs_block_bitmap_loc(old_fs, i);
+		if (blk &&
+		    (blk < ext2fs_blocks_count(fs->super)) &&
+		    !(bg_map && ext2fs_test_block_bitmap2(bg_map, blk))) {
+			ext2fs_block_alloc_stats2(fs, blk, -1);
+			ext2fs_mark_block_bitmap2(reserve_blocks, blk);
+		}
 
-	for (j = 0;
-	     j < fs->inode_blocks_per_group; j++, blk++) {
-		if (blk >= ext2fs_blocks_count(fs->super))
-			break;
-		ext2fs_block_alloc_stats2(fs, blk, -1);
-		ext2fs_mark_block_bitmap2(reserve_blocks, blk);
+		blk = ext2fs_inode_bitmap_loc(old_fs, i);
+		if (blk &&
+		    (blk < ext2fs_blocks_count(fs->super)) &&
+		    !(bg_map && ext2fs_test_block_bitmap2(bg_map, blk))) {
+			ext2fs_block_alloc_stats2(fs, blk, -1);
+			ext2fs_mark_block_bitmap2(reserve_blocks, blk);
+		}
+
+		blk = ext2fs_inode_table_loc(old_fs, i);
+		for (j = 0;
+		     j < fs->inode_blocks_per_group; j++, blk++) {
+			if (blk >= ext2fs_blocks_count(fs->super) ||
+			    (bg_map && ext2fs_test_block_bitmap2(bg_map, blk)))
+				continue;
+			ext2fs_block_alloc_stats2(fs, blk, -1);
+			ext2fs_mark_block_bitmap2(reserve_blocks, blk);
+		}
 	}
+
+out:
+	if (bg_map)
+		ext2fs_free_block_bitmap(bg_map);
+	return retval;
 }
 
 /*
@@ -467,10 +487,10 @@ retry:
 		 * Check the block groups that we are chopping off
 		 * and free any blocks associated with their metadata
 		 */
-		for (i = fs->group_desc_count;
-		     i < old_fs->group_desc_count; i++)
-			free_gdp_blocks(fs, reserve_blocks, old_fs, i);
-		retval = 0;
+		retval = free_gdp_blocks(fs, reserve_blocks, old_fs,
+					 fs->group_desc_count,
+					 old_fs->group_desc_count -
+					 fs->group_desc_count);
 		goto errout;
 	}
 

