From: Jan Kara <jack@suse.com>
Subject: [PATCH 02/19] ext2fs: Use range marking function to mark all inode table blocks as used
Date: Fri,  7 Aug 2015 12:51:12 +0200
Message-ID: <1438944689-24562-3-git-send-email-jack@suse.com>
References: <1438944689-24562-1-git-send-email-jack@suse.com>
Cc: Ted Tso <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39099 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752520AbbHGKvm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Aug 2015 06:51:42 -0400
In-Reply-To: <1438944689-24562-1-git-send-email-jack@suse.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jan Kara <jack@suse.cz>

Signed-off-by: Jan Kara <jack@suse.cz>
---
 lib/ext2fs/gen_bitmap64.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/lib/ext2fs/gen_bitmap64.c b/lib/ext2fs/gen_bitmap64.c
index 34122cfa8901..2a54514b6b1e 100644
--- a/lib/ext2fs/gen_bitmap64.c
+++ b/lib/ext2fs/gen_bitmap64.c
@@ -913,7 +913,6 @@ void ext2fs_init_uninit_block_bitmaps(ext2_filsys fs)
 {
 	blk64_t		blk, lblk;
 	dgrp_t		g;
-	int		i;
 
 	if (!ext2fs_has_group_desc_csum(fs))
 		return;
@@ -932,9 +931,8 @@ void ext2fs_init_uninit_block_bitmaps(ext2_filsys fs)
 					  ext2fs_block_bitmap_loc(fs, g));
 		ext2fs_mark_block_bitmap2(fs->block_map,
 					  ext2fs_inode_bitmap_loc(fs, g));
-		for (i = 0, blk = ext2fs_inode_table_loc(fs, g);
-		     i < (unsigned int) fs->inode_blocks_per_group;
-		     i++, blk++)
-			ext2fs_mark_block_bitmap2(fs->block_map, blk);
+		ext2fs_mark_block_bitmap_range2(fs->block_map,
+						ext2fs_inode_table_loc(fs, g),
+						fs->inode_blocks_per_group);
 	}
 }
-- 
2.1.4

