From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 09/12] libext2: optimize ext2fs_new_block2()
Date: Mon, 20 Jan 2014 00:54:11 -0500
Message-ID: <1390197254-14583-10-git-send-email-tytso@mit.edu>
References: <1390197254-14583-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49974 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285AbaATFy3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Jan 2014 00:54:29 -0500
In-Reply-To: <1390197254-14583-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If there are hundreds of thousands of blocks which are in use before
the first free block, it is much, MUCH faster to use
ext2fs_find_first_zero_block_bitmap2() instead of searching the
allocation bitmap bit by bit.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/alloc.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/lib/ext2fs/alloc.c b/lib/ext2fs/alloc.c
index 91637dd..7dcfd3c 100644
--- a/lib/ext2fs/alloc.c
+++ b/lib/ext2fs/alloc.c
@@ -137,8 +137,8 @@ errcode_t ext2fs_new_inode(ext2_filsys fs, ext2_ino_t dir,
 errcode_t ext2fs_new_block2(ext2_filsys fs, blk64_t goal,
 			   ext2fs_block_bitmap map, blk64_t *ret)
 {
-	blk64_t	i;
-	int	c_ratio;
+	errcode_t retval;
+	blk64_t	b;
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
@@ -148,21 +148,21 @@ errcode_t ext2fs_new_block2(ext2_filsys fs, blk64_t goal,
 		return EXT2_ET_NO_BLOCK_BITMAP;
 	if (!goal || (goal >= ext2fs_blocks_count(fs->super)))
 		goal = fs->super->s_first_data_block;
-	i = goal;
-	c_ratio = 1 << ext2fs_get_bitmap_granularity(map);
-	if (c_ratio > 1)
-		goal &= ~EXT2FS_CLUSTER_MASK(fs);
-	do {
-		if (!ext2fs_fast_test_block_bitmap2(map, i)) {
-			clear_block_uninit(fs, ext2fs_group_of_blk2(fs, i));
-			*ret = i;
-			return 0;
-		}
-		i = (i + c_ratio) & ~(c_ratio - 1);
-		if (i >= ext2fs_blocks_count(fs->super))
-			i = fs->super->s_first_data_block;
-	} while (i != goal);
-	return EXT2_ET_BLOCK_ALLOC_FAIL;
+	goal &= ~EXT2FS_CLUSTER_MASK(fs);
+
+	retval = ext2fs_find_first_zero_block_bitmap2(map,
+			goal, ext2fs_blocks_count(fs->super) - 1, &b);
+	if ((retval == ENOENT) && (goal != fs->super->s_first_data_block))
+		retval = ext2fs_find_first_zero_block_bitmap2(map,
+			fs->super->s_first_data_block, goal - 1, &b);
+	if (retval == ENOENT)
+		return EXT2_ET_BLOCK_ALLOC_FAIL;
+	if (retval)
+		return retval;
+
+	clear_block_uninit(fs, ext2fs_group_of_blk2(fs, b));
+	*ret = b;
+	return 0;
 }
 
 errcode_t ext2fs_new_block(ext2_filsys fs, blk_t goal,
-- 
1.8.5.rc3.362.gdf10213

