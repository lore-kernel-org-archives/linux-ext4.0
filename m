From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 29/47] resize2fs: don't mark unallocated bg metadata blocks
 when fixing bg flags
Date: Fri, 07 Nov 2014 13:53:54 -0800
Message-ID: <20141107215354.883.35283.stgit@birch.djwong.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36391 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095AbaKGVx7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Nov 2014 16:53:59 -0500
In-Reply-To: <20141107215042.883.49888.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When fixing up block group bitmaps on the new fs, don't try to mark
unallocated group metadata blocks; these will be allocated (and
marked) later.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 resize/resize2fs.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)


diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 94c0643..a760593 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -242,7 +242,6 @@ static void fix_uninit_block_bitmaps(ext2_filsys fs)
 {
 	blk64_t		blk, lblk;
 	dgrp_t		g;
-	int		i;
 
 	if (!ext2fs_has_group_desc_csum(fs))
 		return;
@@ -257,14 +256,16 @@ static void fix_uninit_block_bitmaps(ext2_filsys fs)
 						  lblk - blk + 1);
 
 		ext2fs_reserve_super_and_bgd(fs, g, fs->block_map);
-		ext2fs_mark_block_bitmap2(fs->block_map,
-					  ext2fs_block_bitmap_loc(fs, g));
-		ext2fs_mark_block_bitmap2(fs->block_map,
-					  ext2fs_inode_bitmap_loc(fs, g));
-		for (i = 0, blk = ext2fs_inode_table_loc(fs, g);
-		     i < (unsigned int) fs->inode_blocks_per_group;
-		     i++, blk++)
+		blk = ext2fs_block_bitmap_loc(fs, g);
+		if (blk)
+			ext2fs_mark_block_bitmap2(fs->block_map, blk);
+		blk = ext2fs_inode_bitmap_loc(fs, g);
+		if (blk)
 			ext2fs_mark_block_bitmap2(fs->block_map, blk);
+		blk = ext2fs_inode_table_loc(fs, g);
+		if (blk)
+			ext2fs_mark_block_bitmap_range2(fs->block_map, blk,
+						fs->inode_blocks_per_group);
 	}
 }
 

