From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 3/4] resize2fs: relocate inode table blocks if necessary when shrinking
Date: Mon, 30 Sep 2013 23:59:33 -0400
Message-ID: <1380599974-2886-3-git-send-email-tytso@mit.edu>
References: <20131001015746.GF5845@thunk.org>
 <1380599974-2886-1-git-send-email-tytso@mit.edu>
Cc: sandeen@redhat.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40486 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755752Ab3JAD7h (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Sep 2013 23:59:37 -0400
In-Reply-To: <1380599974-2886-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the file system is being shrunk, and a block group's inode table
falls beyond the end of the inode table, we need to try to relocate
the inode table blocks.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 resize/resize2fs.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 1e4ac19..ec1594e 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -884,24 +884,34 @@ static errcode_t blocks_to_move(ext2_resize_t rfs)
 	fs = rfs->new_fs;
 
 	/*
-	 * If we're shrinking the filesystem, we need to move any group's
-	 * bitmaps which are beyond the end of the new filesystem.
+	 * If we're shrinking the filesystem, we need to move any
+	 * group's metadata blocks (either allocation bitmaps or the
+	 * inode table) which are beyond the end of the new
+	 * filesystem.
 	 */
 	new_size = ext2fs_blocks_count(fs->super);
 	if (new_size < ext2fs_blocks_count(old_fs->super)) {
 		for (g = 0; g < fs->group_desc_count; g++) {
+			int realloc = 0;
 			/*
-			 * ext2fs_allocate_group_table re-allocates bitmaps
-			 * which are set to block 0.
+			 * ext2fs_allocate_group_table will re-allocate any
+			 * metadata blocks whose location is set to zero.
 			 */
 			if (ext2fs_block_bitmap_loc(fs, g) >= new_size) {
 				ext2fs_block_bitmap_loc_set(fs, g, 0);
-				retval = ext2fs_allocate_group_table(fs, g, 0);
-				if (retval)
-					return retval;
+				realloc = 1;
 			}
 			if (ext2fs_inode_bitmap_loc(fs, g) >= new_size) {
 				ext2fs_inode_bitmap_loc_set(fs, g, 0);
+				realloc = 1;
+			}
+			if ((ext2fs_inode_table_loc(fs, g) +
+			     fs->inode_blocks_per_group) > new_size) {
+				ext2fs_inode_table_loc_set(fs, g, 0);
+				realloc = 1;
+			}
+
+			if (realloc) {
 				retval = ext2fs_allocate_group_table(fs, g, 0);
 				if (retval)
 					return retval;
-- 
1.7.12.rc0.22.gcdd159b

