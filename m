From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 08/12] libext2fs: optimize ext2fs_allocate_group_table()
Date: Mon, 20 Jan 2014 00:54:10 -0500
Message-ID: <1390197254-14583-9-git-send-email-tytso@mit.edu>
References: <1390197254-14583-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49979 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293AbaATFye (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Jan 2014 00:54:34 -0500
In-Reply-To: <1390197254-14583-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

By using ext2fs_mark_block_bitmap_range2 and/or
ext2fs_block_alloc_stats_range(), we can significantly speed up the
time needed by mke2fs to allocate the inode table.

For example, the CPU time needed to run the command "mke2fs -t ext4
/tmp/foo.img 32T" (where tmpfs was mounted on /tmp) was decreased from
21.7 CPU seconds down to under 1.7 seconds.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/alloc_tables.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/lib/ext2fs/alloc_tables.c b/lib/ext2fs/alloc_tables.c
index 9f3d4e0..fec9003 100644
--- a/lib/ext2fs/alloc_tables.c
+++ b/lib/ext2fs/alloc_tables.c
@@ -83,9 +83,8 @@ static blk64_t flexbg_offset(ext2_filsys fs, dgrp_t group, blk64_t start_blk,
 errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 				      ext2fs_block_bitmap bmap)
 {
-	unsigned int	j;
 	errcode_t	retval;
-	blk64_t		group_blk, start_blk, last_blk, new_blk, blk;
+	blk64_t		group_blk, start_blk, last_blk, new_blk;
 	dgrp_t		last_grp = 0;
 	int		rem_grps = 0, flexbg_size = 0;
 
@@ -205,19 +204,12 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 						bmap, &new_blk);
 		if (retval)
 			return retval;
-		for (j=0, blk = new_blk;
-		     j < fs->inode_blocks_per_group;
-		     j++, blk++) {
-			ext2fs_mark_block_bitmap2(bmap, blk);
-			if (flexbg_size) {
-				dgrp_t gr = ext2fs_group_of_blk2(fs, blk);
-				ext2fs_bg_free_blocks_count_set(fs, gr, ext2fs_bg_free_blocks_count(fs, gr) - 1);
-				ext2fs_free_blocks_count_add(fs->super, -1);
-				ext2fs_bg_flags_clear(fs, gr,
-						     EXT2_BG_BLOCK_UNINIT);
-				ext2fs_group_desc_csum_set(fs, gr);
-			}
-		}
+		if (flexbg_size)
+			ext2fs_block_alloc_stats_range(fs, new_blk,
+				       fs->inode_blocks_per_group, +1);
+		else
+			ext2fs_mark_block_bitmap_range2(fs->block_map,
+					new_blk, fs->inode_blocks_per_group);
 		ext2fs_inode_table_loc_set(fs, group, new_blk);
 	}
 	ext2fs_group_desc_csum_set(fs, group);
-- 
1.8.5.rc3.362.gdf10213

