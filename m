From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] resize2fs: fix computation of the real end of the bitmap to be 64-bit
Date: Fri,  7 Jan 2011 16:39:41 -0500
Message-ID: <1294436381-6413-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:43525 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753209Ab1AGVjp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Jan 2011 16:39:45 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

real_end had been previously declared with a bogus type, which is why
this was missed earlier.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 resize/resize2fs.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 55e5512..216a626 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -294,7 +294,7 @@ errcode_t adjust_fs_info(ext2_filsys fs, ext2_filsys old_fs,
 	blk64_t		overhead = 0;
 	blk64_t		rem;
 	blk64_t		blk, group_block;
-	ext2_ino_t	real_end;
+	blk64_t		real_end;
 	blk64_t		adj, old_numblocks, numblocks, adjblocks;
 	unsigned long	i, j, old_desc_blocks, max_group;
 	unsigned int	meta_bg, meta_bg_size;
@@ -381,9 +381,9 @@ retry:
 					    fs->inode_map);
 	if (retval) goto errout;
 
-	real_end = ((EXT2_BLOCKS_PER_GROUP(fs->super)
-		     * fs->group_desc_count)) - 1 +
-			     fs->super->s_first_data_block;
+	real_end = (((blk64_t) EXT2_BLOCKS_PER_GROUP(fs->super) *
+		     fs->group_desc_count)) - 1 +
+		fs->super->s_first_data_block;
 	retval = ext2fs_resize_block_bitmap2(ext2fs_blocks_count(fs->super)-1,
 					    real_end, fs->block_map);
 
-- 
1.7.3.1

