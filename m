From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/6] resize2fs: reserve fs metadata blocks first in blocks_to_move()
Date: Sat, 29 Dec 2012 03:55:24 -0500
Message-ID: <1356771328-18196-3-git-send-email-tytso@mit.edu>
References: <1356771328-18196-1-git-send-email-tytso@mit.edu>
Cc: George Spelvin <linux@horizon.com>, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40794 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752311Ab2L2Izc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 29 Dec 2012 03:55:32 -0500
In-Reply-To: <1356771328-18196-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is the first commit to add support for off-line resizing using
flex_bg without the assist of using the resize_inode to reserve gdt
blocks.  This functionality has been broken up into separate commits
which are hopefully obviously correct to make them easier to review
for correctness.

In this first step, we break up the for loop at the end of
blocks_to_move() so that we first mark all of the metadata blocks
which don't need to be moved in the reserve_blocks bitmap, and then
try to allocate the metadata blocks are new or which need to moved
second.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 resize/resize2fs.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index ce8ed91..c5d8a23 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -874,6 +874,7 @@ static errcode_t blocks_to_move(ext2_resize_t rfs)
 	 * gets interesting....
 	 */
 	meta_bg_size = EXT2_DESC_PER_BLOCK(fs->super);
+	/* first reserve all of the existing fs meta blocks */
 	for (i = 0; i < max_groups; i++) {
 		has_super = ext2fs_bg_has_super(fs, i);
 		if (has_super)
@@ -899,11 +900,6 @@ static errcode_t blocks_to_move(ext2_resize_t rfs)
 						  group_blk + has_super);
 		}
 
-		if (ext2fs_inode_table_loc(fs, i) &&
-		    ext2fs_inode_bitmap_loc(fs, i) &&
-		    ext2fs_block_bitmap_loc(fs, i))
-			goto next_group;
-
 		/*
 		 * Reserve the existing meta blocks that we know
 		 * aren't to be moved.
@@ -920,9 +916,17 @@ static errcode_t blocks_to_move(ext2_resize_t rfs)
 				ext2fs_mark_block_bitmap2(rfs->reserve_blocks,
 							 blk);
 
+		group_blk += rfs->new_fs->super->s_blocks_per_group;
+	}
+
+	/* Allocate the missing data structures */
+	for (i = 0; i < max_groups; i++) {
+		if (ext2fs_inode_table_loc(fs, i) &&
+		    ext2fs_inode_bitmap_loc(fs, i) &&
+		    ext2fs_block_bitmap_loc(fs, i))
+			continue;
+
 		/*
-		 * Allocate the missing data structures
-		 *
 		 * XXX We have a problem with FLEX_BG and off-line
 		 * resizing where we are growing the size of the
 		 * filesystem.  ext2fs_allocate_group_table() will try
@@ -977,7 +981,7 @@ static errcode_t blocks_to_move(ext2_resize_t rfs)
 		 * block relocation phase.
 		 */
 		if (ext2fs_inode_table_loc(fs, i) == ext2fs_inode_table_loc(old_fs, i))
-			goto next_group; /* inode table not moved */
+			continue;	/* inode table not moved */
 
 		rfs->needed_blocks += fs->inode_blocks_per_group;
 
@@ -1002,9 +1006,6 @@ static errcode_t blocks_to_move(ext2_resize_t rfs)
 		for (blk = ext2fs_inode_table_loc(rfs->old_fs, i), j=0;
 		     j < fs->inode_blocks_per_group ; j++, blk++)
 			ext2fs_mark_block_bitmap2(rfs->reserve_blocks, blk);
