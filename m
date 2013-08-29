From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 2/6] resize2fs: Use blk64_t and location getters for
 free_gdp_blocks()
Date: Wed, 28 Aug 2013 17:43:57 -0700
Message-ID: <20130829004357.3190.18064.stgit@blackbox.djwong.org>
References: <20130829004344.3190.28053.stgit@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26941 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060Ab3H2AoG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Aug 2013 20:44:06 -0400
In-Reply-To: <20130829004344.3190.28053.stgit@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

free_gdp_blocks needs to be taught to use 64-bit fields and the appropriate
getters, otherwise it'll truncate high block numbers (when, say, resizing a
>16T fs) and mark the low numbered group descriptor blocks as free.  Yikes.

Reported-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 resize/resize2fs.c |   41 ++++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 21 deletions(-)


diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 3610e7b..76d7aa6 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -272,34 +272,36 @@ static void fix_uninit_block_bitmaps(ext2_filsys fs)
  */
 static void free_gdp_blocks(ext2_filsys fs,
 			    ext2fs_block_bitmap reserve_blocks,
-			    struct ext2_group_desc *gdp)
+			    ext2_filsys old_fs,
+			    dgrp_t group)
 {
-	blk_t	blk;
+	blk64_t	blk;
 	int	j;
 
-	if (gdp->bg_block_bitmap &&
-	    (gdp->bg_block_bitmap < ext2fs_blocks_count(fs->super))) {
-		ext2fs_block_alloc_stats(fs, gdp->bg_block_bitmap, -1);
-		ext2fs_mark_block_bitmap2(reserve_blocks,
-					 gdp->bg_block_bitmap);
+	blk = ext2fs_block_bitmap_loc(old_fs, group);
+	if (blk &&
+	    (blk < ext2fs_blocks_count(fs->super))) {
+		ext2fs_block_alloc_stats2(fs, blk, -1);
+		ext2fs_mark_block_bitmap2(reserve_blocks, blk);
 	}
 
-	if (gdp->bg_inode_bitmap &&
-	    (gdp->bg_inode_bitmap < ext2fs_blocks_count(fs->super))) {
-		ext2fs_block_alloc_stats(fs, gdp->bg_inode_bitmap, -1);
-		ext2fs_mark_block_bitmap2(reserve_blocks,
-					 gdp->bg_inode_bitmap);
+	blk = ext2fs_inode_bitmap_loc(old_fs, group);
+	if (blk &&
+	    (blk < ext2fs_blocks_count(fs->super))) {
+		ext2fs_block_alloc_stats2(fs, blk, -1);
+		ext2fs_mark_block_bitmap2(reserve_blocks, blk);
 	}
 
-	if (gdp->bg_inode_table == 0 ||
-	    (gdp->bg_inode_table >= ext2fs_blocks_count(fs->super)))
+	blk = ext2fs_inode_table_loc(old_fs, group);
+	if (blk == 0 ||
+	    (blk >= ext2fs_blocks_count(fs->super)))
 		return;
 
-	for (blk = gdp->bg_inode_table, j = 0;
+	for (j = 0;
 	     j < fs->inode_blocks_per_group; j++, blk++) {
 		if (blk >= ext2fs_blocks_count(fs->super))
 			break;
-		ext2fs_block_alloc_stats(fs, blk, -1);
+		ext2fs_block_alloc_stats2(fs, blk, -1);
 		ext2fs_mark_block_bitmap2(reserve_blocks, blk);
 	}
 }
@@ -466,11 +468,8 @@ retry:
 		 * and free any blocks associated with their metadata
 		 */
 		for (i = fs->group_desc_count;
-		     i < old_fs->group_desc_count; i++) {
-			free_gdp_blocks(fs, reserve_blocks,
-					ext2fs_group_desc(old_fs,
-						old_fs->group_desc, i));
-		}
+		     i < old_fs->group_desc_count; i++)
+			free_gdp_blocks(fs, reserve_blocks, old_fs, i);
 		retval = 0;
 		goto errout;
 	}

