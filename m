From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] e2fsck: update global free blocks/inodes count when truncating orphan inodes
Date: Mon, 11 Jun 2012 22:22:42 -0400
Message-ID: <1339467762-5725-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49222 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752447Ab2FLCWp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Jun 2012 22:22:45 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

By the time we start processing the orphan inode list, we have already
calculated the total expected number of free blocks and inodes in
ctx->free_{blocks,inodes}.  This is used to set the free blocks/inodes
count in the superblock in the case where we don't need to do a full
e2fsck.

We need to update these expected free block counts as we process the
orphan inode list so that superblock values are set correctly.
Otherwise we could have the following happen:

% e2fsck /tmp/test.img
e2fsck 1.42.3 (14-May-2012)
Truncating orphaned inode 12 (uid=0, gid=0, mode=0100644, size=0)
Setting free blocks count to 46 (was 79)
/tmp/test.img: clean, 12/16 files, 54/100 blocks

% e2fsck /tmp/test.img
e2fsck 1.42.3 (14-May-2012)
Setting free blocks count to 79 (was 46)
/tmp/test.img: clean, 12/16 files, 21/100 blocks

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/super.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/e2fsck/super.c b/e2fsck/super.c
index 6c18d0e..160991d 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -143,6 +143,7 @@ static int release_inode_block(ext2_filsys fs,
 	}
 
 	ext2fs_block_alloc_stats2(fs, blk, -1);
+	ctx->free_blocks++;
 	return retval;
 }
 
@@ -211,9 +212,11 @@ static int release_inode_blocks(e2fsck_t ctx, ext2_ino_t ino,
 				ino);
 			return 1;
 		}
-		if (count == 0)
+		if (count == 0) {
 			ext2fs_block_alloc_stats2(fs,
 					ext2fs_file_acl_block(fs, inode), -1);
+			ctx->free_blocks++;
+		}
 		ext2fs_file_acl_block_set(fs, inode, 0);
 	}
 	return 0;
@@ -286,6 +289,7 @@ static int release_orphan_inodes(e2fsck_t ctx)
 		if (!inode.i_links_count) {
 			ext2fs_inode_alloc_stats2(fs, ino, -1,
 						  LINUX_S_ISDIR(inode.i_mode));
+			ctx->free_inodes++;
 			inode.i_dtime = ctx->now;
 		} else {
 			inode.i_dtime = 0;
-- 
1.7.10.2.552.gaa3bb87

