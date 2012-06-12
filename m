From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/2] libext2fs: fix block iterator for extents when truncating inodes
Date: Tue, 12 Jun 2012 01:45:06 -0400
Message-ID: <1339479907-19088-1-git-send-email-tytso@mit.edu>
References: <1339467762-5725-1-git-send-email-tytso@mit.edu>
Cc: Andreas Dilger <adilger@whamcloud.com>,
	Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49242 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821Ab2FLFpM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Jun 2012 01:45:12 -0400
In-Reply-To: <1339467762-5725-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When e2fsck uses the block iterator to release the blocks in an
extent-mapped inode, when the last block in an extent is removed, the
current extent has been removed and the extent cursor is now pointing
at the next inode.  But the block iterator code doesn't know that.  So
when it tries to go the next extent, it will end up skipping an
extent, and so the inode will be incompletely truncated.

The fix is to go to the next extent before calling the callback
function for the current extent.  This way, regardless of whether the
current extent gets removed, the extent cursor is still pointing at
the right place.

Reported-by: Andreas Dilger <adilger@whamcloud.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/block.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/lib/ext2fs/block.c b/lib/ext2fs/block.c
index 85a1803..68dcb03 100644
--- a/lib/ext2fs/block.c
+++ b/lib/ext2fs/block.c
@@ -389,7 +389,7 @@ errcode_t ext2fs_block_iterate3(ext2_filsys fs,
 
 	if (inode.i_flags & EXT4_EXTENTS_FL) {
 		ext2_extent_handle_t	handle;
-		struct ext2fs_extent	extent;
+		struct ext2fs_extent	extent, next;
 		e2_blkcnt_t		blockcnt = 0;
 		blk64_t			blk, new_blk;
 		int			op = EXT2_EXTENT_ROOT;
@@ -401,7 +401,11 @@ errcode_t ext2fs_block_iterate3(ext2_filsys fs,
 			goto abort_exit;
 
 		while (1) {
-			ctx.errcode = ext2fs_extent_get(handle, op, &extent);
+			if (op == EXT2_EXTENT_CURRENT)
+				ctx.errcode = 0;
+			else
+				ctx.errcode = ext2fs_extent_get(handle, op,
+								&extent);
 			if (ctx.errcode) {
 				if (ctx.errcode != EXT2_ET_EXTENT_NO_NEXT)
 					break;
@@ -456,6 +460,13 @@ errcode_t ext2fs_block_iterate3(ext2_filsys fs,
 			uninit = 0;
 			if (extent.e_flags & EXT2_EXTENT_FLAGS_UNINIT)
 				uninit = EXT2_EXTENT_SET_BMAP_UNINIT;
+
+			/* 
+			 * Get the next extent before we start messing
+			 * with the current extent
+			 */
+			retval = ext2fs_extent_get(handle, op, &next);
+
 #if 0
 			printf("lblk %llu pblk %llu len %d blockcnt %llu\n",
 			       extent.e_lblk, extent.e_pblk,
@@ -487,6 +498,10 @@ errcode_t ext2fs_block_iterate3(ext2_filsys fs,
 				if (ret & BLOCK_ABORT)
 					goto extent_done;
 			}
+			if (retval == 0) {
+				extent = next;
+				op = EXT2_EXTENT_CURRENT;
+			}
 		}
 
 	extent_done:
-- 
1.7.10.2.552.gaa3bb87

