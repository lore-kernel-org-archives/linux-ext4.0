From: Jan Kara <jack@suse.com>
Subject: [PATCH 05/19] resize2fs: Use ext2fs_allocate_group_table2()
Date: Fri,  7 Aug 2015 12:51:15 +0200
Message-ID: <1438944689-24562-6-git-send-email-jack@suse.com>
References: <1438944689-24562-1-git-send-email-jack@suse.com>
Cc: Ted Tso <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Jan Kara <jack@suse.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39125 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280AbbHGKvp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Aug 2015 06:51:45 -0400
In-Reply-To: <1438944689-24562-1-git-send-email-jack@suse.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Jan Kara <jack@suse.com>
---
 resize/resize2fs.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 02f7d754d316..9d21cebe16aa 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -1448,8 +1448,10 @@ static errcode_t blocks_to_move(ext2_resize_t rfs)
 		    ext2fs_block_bitmap_loc(fs, i))
 			continue;
 
-		retval = ext2fs_allocate_group_table(fs, i,
-						     rfs->reserve_blocks);
+		retval = ext2fs_allocate_group_table2(fs, i,
+				rfs->reserve_blocks,
+				EXT2FS_ALLOC_TABLE_UPDATE_STATS |
+				EXT2FS_ALLOC_TABLE_SET_BLOCK_BITMAP);
 		if (retval)
 			goto errout;
 
@@ -1459,7 +1461,6 @@ static errcode_t blocks_to_move(ext2_resize_t rfs)
 		 */
 		if (ext2fs_block_bitmap_loc(old_fs, i) !=
 		    (blk = ext2fs_block_bitmap_loc(fs, i))) {
-			ext2fs_block_alloc_stats2(fs, blk, +1);
 			if (ext2fs_test_block_bitmap2(old_fs->block_map, blk) &&
 			    !ext2fs_test_block_bitmap2(meta_bmap, blk))
 				ext2fs_mark_block_bitmap2(rfs->move_blocks,
@@ -1467,7 +1468,6 @@ static errcode_t blocks_to_move(ext2_resize_t rfs)
 		}
 		if (ext2fs_inode_bitmap_loc(old_fs, i) !=
 		    (blk = ext2fs_inode_bitmap_loc(fs, i))) {
-			ext2fs_block_alloc_stats2(fs, blk, +1);
 			if (ext2fs_test_block_bitmap2(old_fs->block_map, blk) &&
 			    !ext2fs_test_block_bitmap2(meta_bmap, blk))
 				ext2fs_mark_block_bitmap2(rfs->move_blocks,
@@ -1493,7 +1493,6 @@ static errcode_t blocks_to_move(ext2_resize_t rfs)
 		 */
 		for (blk = ext2fs_inode_table_loc(fs, i), j=0;
 		     j < fs->inode_blocks_per_group ; j++, blk++) {
-			ext2fs_block_alloc_stats2(fs, blk, +1);
 			if (ext2fs_test_block_bitmap2(old_fs->block_map, blk) &&
 			    !ext2fs_test_block_bitmap2(meta_bmap, blk))
 				ext2fs_mark_block_bitmap2(rfs->move_blocks,
-- 
2.1.4

