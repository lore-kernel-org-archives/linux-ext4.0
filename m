From: Jan Kara <jack@suse.com>
Subject: [PATCH 02/21] ext2fs: Implement ext2fs_allocate_group_table2()
Date: Wed, 26 Aug 2015 18:22:17 +0200
Message-ID: <1440606156-5754-3-git-send-email-jack@suse.com>
References: <1440606156-5754-1-git-send-email-jack@suse.com>
Cc: Ted Tso <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Jan Kara <jack@suse.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33533 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756929AbbHZQWv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Aug 2015 12:22:51 -0400
In-Reply-To: <1440606156-5754-1-git-send-email-jack@suse.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Implement ext2fs_allocate_group_table2() which marks blocks also in
fs->block_map unconditionally and which always updates allocation
statistics.

Signed-off-by: Jan Kara <jack@suse.com>
---
 lib/ext2fs/alloc_tables.c | 97 ++++++++++++++++++++++++++++++++++-------------
 lib/ext2fs/ext2fs.h       |  7 ++++
 2 files changed, 78 insertions(+), 26 deletions(-)

diff --git a/lib/ext2fs/alloc_tables.c b/lib/ext2fs/alloc_tables.c
index 3e1952fa63e8..7b1f9da22fb8 100644
--- a/lib/ext2fs/alloc_tables.c
+++ b/lib/ext2fs/alloc_tables.c
@@ -81,19 +81,62 @@ static blk64_t flexbg_offset(ext2_filsys fs, dgrp_t group, blk64_t start_blk,
 	return first_free;
 }
 
-errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
-				      ext2fs_block_bitmap bmap)
+static void update_block_bitmap_stats(ext2_filsys fs, blk64_t blk, int len,
+				      unsigned long flags, int flex_bg)
+{
+	if (flags & EXT2FS_ALLOC_TABLE_UPDATE_STATS) {
+		ext2fs_block_alloc_stats_range(fs, blk, len, +1);
+		if (!(flags & EXT2FS_ALLOC_TABLE_SET_BLOCK_BITMAP))
+			ext2fs_unmark_block_bitmap_range2(fs->block_map, blk,
+							  len);
+	} else if (flags & EXT2FS_ALLOC_TABLE_SET_BLOCK_BITMAP) {
+		dgrp_t g, end;
+
+		ext2fs_mark_block_bitmap_range2(fs->block_map, blk, len);
+		/* For fs without FLEX_BG, bitmaps can stay uninitialized */
+		if (!flex_bg)
+			return;
+		/*
+		 * It's an overkill to assume more than two groups can be
+		 * touched but the code is easy to understand this way.
+		 */
+		end = ext2fs_group_of_blk2(fs, blk + len - 1);
+		for (g = ext2fs_group_of_blk2(fs, blk); g <= end; g++) {
+			if (ext2fs_bg_flags_test(fs, g, EXT2_BG_BLOCK_UNINIT)) {
+				ext2fs_bg_flags_clear(fs, g,
+						      EXT2_BG_BLOCK_UNINIT);
+				ext2fs_group_desc_csum_set(fs, g);
+			}
+		}
+	}
+}
+
+/*
+ * Allocate group metadata (bitmaps, inode table) if not present. If
+ * reserve_bmap is set, we use that as a bitmap of blocks free for allocation
+ * (and update used blocks there as well as in fs->block_map).
+ */
+errcode_t ext2fs_allocate_group_table2(ext2_filsys fs, dgrp_t group,
+				       ext2fs_block_bitmap reserve_bmap,
+				       unsigned long flags)
 {
 	errcode_t	retval;
 	blk64_t		group_blk, start_blk, last_blk, new_blk;
 	dgrp_t		last_grp = 0;
 	int		rem_grps = 0, flexbg_size = 0, table_offset = 0;
+	ext2fs_block_bitmap bmap;
 
 	group_blk = ext2fs_group_first_block2(fs, group);
 	last_blk = ext2fs_group_last_block2(fs, group);
 
-	if (!bmap)
+	if (reserve_bmap == fs->block_map)
+		reserve_bmap = NULL;
+
+	if (!reserve_bmap) {
 		bmap = fs->block_map;
+		flags |= EXT2FS_ALLOC_TABLE_SET_BLOCK_BITMAP;
+	} else
+		bmap = reserve_bmap;
 
 	if (EXT2_HAS_INCOMPAT_FEATURE(fs->super,
 				      EXT4_FEATURE_INCOMPAT_FLEX_BG) &&
@@ -153,15 +196,10 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 					last_blk, 1, bmap, &new_blk);
 		if (retval)
 			return retval;
-		ext2fs_mark_block_bitmap2(bmap, new_blk);
 		ext2fs_block_bitmap_loc_set(fs, group, new_blk);
-		if (flexbg_size) {
-			dgrp_t gr = ext2fs_group_of_blk2(fs, new_blk);
-			ext2fs_bg_free_blocks_count_set(fs, gr, ext2fs_bg_free_blocks_count(fs, gr) - 1);
-			ext2fs_free_blocks_count_add(fs->super, -1);
-			ext2fs_bg_flags_clear(fs, gr, EXT2_BG_BLOCK_UNINIT);
-			ext2fs_group_desc_csum_set(fs, gr);
-		}
+		update_block_bitmap_stats(fs, new_blk, 1, flags, flexbg_size);
+		if (reserve_bmap)
+			ext2fs_mark_block_bitmap2(bmap, new_blk);
 	}
 
 	if (flexbg_size) {
@@ -186,15 +224,10 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 					 last_blk, 1, bmap, &new_blk);
 		if (retval)
 			return retval;
-		ext2fs_mark_block_bitmap2(bmap, new_blk);
 		ext2fs_inode_bitmap_loc_set(fs, group, new_blk);
-		if (flexbg_size) {
-			dgrp_t gr = ext2fs_group_of_blk2(fs, new_blk);
-			ext2fs_bg_free_blocks_count_set(fs, gr, ext2fs_bg_free_blocks_count(fs, gr) - 1);
-			ext2fs_free_blocks_count_add(fs->super, -1);
-			ext2fs_bg_flags_clear(fs, gr, EXT2_BG_BLOCK_UNINIT);
-			ext2fs_group_desc_csum_set(fs, gr);
-		}
+		update_block_bitmap_stats(fs, new_blk, 1, flags, flexbg_size);
+		if (reserve_bmap)
+			ext2fs_mark_block_bitmap2(bmap, new_blk);
 	}
 
 	/*
@@ -223,18 +256,30 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 						bmap, &new_blk);
 		if (retval)
 			return retval;
-		if (flexbg_size)
-			ext2fs_block_alloc_stats_range(fs, new_blk,
-				       fs->inode_blocks_per_group, +1);
-		else
-			ext2fs_mark_block_bitmap_range2(fs->block_map,
-					new_blk, fs->inode_blocks_per_group);
 		ext2fs_inode_table_loc_set(fs, group, new_blk);
+		update_block_bitmap_stats(fs, new_blk,
+					  fs->inode_blocks_per_group, flags,
+					  flexbg_size);
+		if (reserve_bmap)
+			ext2fs_mark_block_bitmap_range2(bmap,
+					new_blk, fs->inode_blocks_per_group);
 	}
 	ext2fs_group_desc_csum_set(fs, group);
 	return 0;
 }
 
+errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
+				      ext2fs_block_bitmap bmap)
+{
+	unsigned long flags = 0;
+
+	if (EXT2_HAS_INCOMPAT_FEATURE(fs->super,
+                                      EXT4_FEATURE_INCOMPAT_FLEX_BG))
+		flags |= EXT2FS_ALLOC_TABLE_UPDATE_STATS;
+
+	return ext2fs_allocate_group_table2(fs, group, bmap, flags);
+}
+
 errcode_t ext2fs_allocate_tables(ext2_filsys fs)
 {
 	errcode_t	retval;
@@ -248,7 +293,7 @@ errcode_t ext2fs_allocate_tables(ext2_filsys fs)
 	for (i = 0; i < fs->group_desc_count; i++) {
 		if (fs->progress_ops && fs->progress_ops->update)
 			(fs->progress_ops->update)(fs, &progress, i);
-		retval = ext2fs_allocate_group_table(fs, i, fs->block_map);
+		retval = ext2fs_allocate_group_table(fs, i, 0);
 		if (retval)
 			return retval;
 	}
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 13cbe567b19c..3eda8d1f4ad3 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -713,6 +713,13 @@ void ext2fs_block_alloc_stats_range(ext2_filsys fs, blk64_t blk,
 extern errcode_t ext2fs_allocate_tables(ext2_filsys fs);
 extern errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 					     ext2fs_block_bitmap bmap);
+/* Update allocation statistics */
+#define EXT2FS_ALLOC_TABLE_UPDATE_STATS		0x0001
+/* Set fs->block_map in addition to provided bmap */
+#define EXT2FS_ALLOC_TABLE_SET_BLOCK_BITMAP	0x0002
+extern errcode_t ext2fs_allocate_group_table2(ext2_filsys fs, dgrp_t group,
+					      ext2fs_block_bitmap bmap,
+					      unsigned long flags);
 
 /* badblocks.c */
 extern errcode_t ext2fs_u32_list_create(ext2_u32_list *ret, int size);
-- 
2.1.4

