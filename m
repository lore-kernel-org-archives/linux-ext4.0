From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/4] resize2fs: fix 32-bit overflow issue which can corrupt 64-bit file systems
Date: Thu,  3 Jan 2013 09:13:25 -0500
Message-ID: <1357222408-7310-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:41496 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753582Ab3ACONf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 Jan 2013 09:13:35 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix a 32-bit overflow bug caused by a missing blk64_t cast which can
cause the block bitmap to get corrupted when doing an off-line resize
of a 64-bit file system.

This problem can be reproduced as follows:

rm -f foo.img; touch foo.img
truncate -s 8T foo.img
mke2fs -F -t ext4 -O 64bit foo.img
e2fsck -f foo.img
truncate -s 21T foo.img
resize2fs foo.img
e2fsck -fy foo.img

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 resize/resize2fs.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 092cfbd..0407e41 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -197,8 +197,7 @@ static void fix_uninit_block_bitmaps(ext2_filsys fs)
 		if (!(ext2fs_bg_flags_test(fs, g, EXT2_BG_BLOCK_UNINIT)))
 			continue;
 
-		blk = (g * fs->super->s_blocks_per_group) +
-			fs->super->s_first_data_block;
+		blk = ext2fs_group_first_block2(fs, g);
 
 		ext2fs_super_and_bgd_loc2(fs, g, &super_blk,
 					  &old_desc_blk, &new_desc_blk, 0);
@@ -846,8 +845,7 @@ static errcode_t blocks_to_move(ext2_resize_t rfs)
 			 * The block bitmap is uninitialized, so skip
 			 * to the next block group.
 			 */
-			blk = ((g+1) * fs->super->s_blocks_per_group) +
-				fs->super->s_first_data_block - 1;
+			blk = ext2fs_group_first_block2(fs, g+1) - 1;
 			continue;
 		}
 		if (ext2fs_test_block_bitmap2(old_fs->block_map, blk) &&
-- 
1.7.12.rc0.22.gcdd159b

