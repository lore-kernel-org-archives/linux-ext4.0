From: Jan Kara <jack@suse.com>
Subject: [PATCH 01/19] ext2fs: Move function to initialize uninitialized bitmaps to libext2fs
Date: Fri,  7 Aug 2015 12:51:11 +0200
Message-ID: <1438944689-24562-2-git-send-email-jack@suse.com>
References: <1438944689-24562-1-git-send-email-jack@suse.com>
Cc: Ted Tso <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39097 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518AbbHGKvm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Aug 2015 06:51:42 -0400
In-Reply-To: <1438944689-24562-1-git-send-email-jack@suse.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jan Kara <jack@suse.cz>

We will need to initialize uninitialized bitmaps both from resize2fs and
tune2fs. Move the function that does this to libext2fs so that code can
be shared.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 lib/ext2fs/bitops.h       |  1 +
 lib/ext2fs/gen_bitmap64.c | 33 +++++++++++++++++++++++++++++++++
 resize/resize2fs.c        | 38 ++------------------------------------
 3 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/lib/ext2fs/bitops.h b/lib/ext2fs/bitops.h
index bc596087d2a7..0699a00fcec4 100644
--- a/lib/ext2fs/bitops.h
+++ b/lib/ext2fs/bitops.h
@@ -211,6 +211,7 @@ extern errcode_t ext2fs_find_first_zero_generic_bmap(ext2fs_generic_bitmap bitma
 extern errcode_t ext2fs_find_first_set_generic_bmap(ext2fs_generic_bitmap bitmap,
 						    __u64 start, __u64 end,
 						    __u64 *out);
+extern void ext2fs_init_uninit_block_bitmaps(ext2_filsys fs);
 
 /*
  * The inline routines themselves...
diff --git a/lib/ext2fs/gen_bitmap64.c b/lib/ext2fs/gen_bitmap64.c
index 3fc734981c18..34122cfa8901 100644
--- a/lib/ext2fs/gen_bitmap64.c
+++ b/lib/ext2fs/gen_bitmap64.c
@@ -905,3 +905,36 @@ errcode_t ext2fs_find_first_set_generic_bmap(ext2fs_generic_bitmap bitmap,
 
 	return ENOENT;
 }
+
+/*
+ * Initialize all unintialized block bitmaps
+ */
+void ext2fs_init_uninit_block_bitmaps(ext2_filsys fs)
+{
+	blk64_t		blk, lblk;
+	dgrp_t		g;
+	int		i;
+
+	if (!ext2fs_has_group_desc_csum(fs))
+		return;
+
+	for (g = 0; g < fs->group_desc_count; g++) {
+		if (!(ext2fs_bg_flags_test(fs, g, EXT2_BG_BLOCK_UNINIT)))
+			continue;
+
+		blk = ext2fs_group_first_block2(fs, g);
+		lblk = ext2fs_group_last_block2(fs, g);
+		ext2fs_unmark_block_bitmap_range2(fs->block_map, blk,
+						  lblk - blk + 1);
+
+		ext2fs_reserve_super_and_bgd(fs, g, fs->block_map);
+		ext2fs_mark_block_bitmap2(fs->block_map,
+					  ext2fs_block_bitmap_loc(fs, g));
+		ext2fs_mark_block_bitmap2(fs->block_map,
+					  ext2fs_inode_bitmap_loc(fs, g));
+		for (i = 0, blk = ext2fs_inode_table_loc(fs, g);
+		     i < (unsigned int) fs->inode_blocks_per_group;
+		     i++, blk++)
+			ext2fs_mark_block_bitmap2(fs->block_map, blk);
+	}
+}
diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 041ff75029b2..02f7d754d316 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -41,7 +41,6 @@
 #define RESIZE2FS_DEBUG
 #endif
 
-static void fix_uninit_block_bitmaps(ext2_filsys fs);
 static errcode_t adjust_superblock(ext2_resize_t rfs, blk64_t new_size);
 static errcode_t blocks_to_move(ext2_resize_t rfs);
 static errcode_t block_mover(ext2_resize_t rfs);
@@ -119,7 +118,7 @@ errcode_t resize_fs(ext2_filsys fs, blk64_t *new_size, int flags,
 	ext2fs_flush(fs);
 
 	init_resource_track(&rtrack, "fix_uninit_block_bitmaps 1", fs->io);
-	fix_uninit_block_bitmaps(fs);
+	ext2fs_init_uninit_block_bitmaps(fs);
 	print_resource_track(rfs, &rtrack, fs->io);
 	retval = ext2fs_dup_handle(fs, &rfs->new_fs);
 	if (retval)
@@ -150,7 +149,7 @@ errcode_t resize_fs(ext2_filsys fs, blk64_t *new_size, int flags,
 	print_resource_track(rfs, &rtrack, fs->io);
 
 	init_resource_track(&rtrack, "fix_uninit_block_bitmaps 2", fs->io);
-	fix_uninit_block_bitmaps(rfs->new_fs);
+	ext2fs_init_uninit_block_bitmaps(rfs->new_fs);
 	print_resource_track(rfs, &rtrack, fs->io);
 	/* Clear the block bitmap uninit flag for the last block group */
 	ext2fs_bg_flags_clear(rfs->new_fs, rfs->new_fs->group_desc_count - 1,
@@ -571,39 +570,6 @@ out:
 	return retval;
 }
 
-/*
- * Clean up the bitmaps for unitialized bitmaps
- */
-static void fix_uninit_block_bitmaps(ext2_filsys fs)
-{
-	blk64_t		blk, lblk;
-	dgrp_t		g;
-	int		i;
-
-	if (!ext2fs_has_group_desc_csum(fs))
-		return;
-
-	for (g=0; g < fs->group_desc_count; g++) {
-		if (!(ext2fs_bg_flags_test(fs, g, EXT2_BG_BLOCK_UNINIT)))
-			continue;
-
-		blk = ext2fs_group_first_block2(fs, g);
-		lblk = ext2fs_group_last_block2(fs, g);
-		ext2fs_unmark_block_bitmap_range2(fs->block_map, blk,
-						  lblk - blk + 1);
-
-		ext2fs_reserve_super_and_bgd(fs, g, fs->block_map);
-		ext2fs_mark_block_bitmap2(fs->block_map,
-					  ext2fs_block_bitmap_loc(fs, g));
-		ext2fs_mark_block_bitmap2(fs->block_map,
-					  ext2fs_inode_bitmap_loc(fs, g));
-		for (i = 0, blk = ext2fs_inode_table_loc(fs, g);
-		     i < (unsigned int) fs->inode_blocks_per_group;
-		     i++, blk++)
-			ext2fs_mark_block_bitmap2(fs->block_map, blk);
-	}
-}
