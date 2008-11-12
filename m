From: Valerie Aurora Henson <vaurora@redhat.com>
Subject: [RFC PATCH 05/17] Convert libext2fs to 64-bit bitmap interface
Date: Tue, 11 Nov 2008 19:42:58 -0800
Message-ID: <1226461390-5502-6-git-send-email-vaurora@redhat.com>
References: <1226461390-5502-1-git-send-email-vaurora@redhat.com>
 <1226461390-5502-2-git-send-email-vaurora@redhat.com>
 <1226461390-5502-3-git-send-email-vaurora@redhat.com>
 <1226461390-5502-4-git-send-email-vaurora@redhat.com>
 <1226461390-5502-5-git-send-email-vaurora@redhat.com>
Cc: Valerie Aurora Henson <vaurora@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:42464 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752038AbYKLDny (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Nov 2008 22:43:54 -0500
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id mAC3hrnK007433
	for <linux-ext4@vger.kernel.org>; Tue, 11 Nov 2008 22:43:53 -0500
In-Reply-To: <1226461390-5502-5-git-send-email-vaurora@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Valerie Aurora Henson <vaurora@redhat.com>
---
 lib/ext2fs/alloc.c        |   35 +++++------
 lib/ext2fs/alloc_sb.c     |   11 +--
 lib/ext2fs/alloc_stats.c  |   10 +--
 lib/ext2fs/alloc_tables.c |   23 +++----
 lib/ext2fs/bb_inode.c     |    2 +-
 lib/ext2fs/bitmaps.c      |  145 ++++++++++++++++++++++++++++++++++-----------
 lib/ext2fs/bitops.h       |    2 +-
 lib/ext2fs/bmove.c        |   16 +++---
 lib/ext2fs/check_desc.c   |   14 ++--
 lib/ext2fs/csum.c         |    4 +-
 lib/ext2fs/ext2_io.h      |    4 +
 lib/ext2fs/ext2fs.h       |   85 ++++++++++++++++++++------
 lib/ext2fs/icount.c       |   44 +++++++-------
 lib/ext2fs/imager.c       |   12 ++--
 lib/ext2fs/rw_bitmaps.c   |   12 ++--
 lib/ext2fs/tst_csum.c     |    2 +-
 lib/ext2fs/tst_iscan.c    |   46 ++++++++------
 17 files changed, 294 insertions(+), 173 deletions(-)

diff --git a/lib/ext2fs/alloc.c b/lib/ext2fs/alloc.c
index fe4fdb4..90599b8 100644
--- a/lib/ext2fs/alloc.c
+++ b/lib/ext2fs/alloc.c
@@ -29,7 +29,7 @@
 /*
  * Check for uninit block bitmaps and deal with them appropriately
  */
-static void check_block_uninit(ext2_filsys fs, ext2fs_block_bitmap map,
+static void check_block_uninit(ext2_filsys fs, ext2fs_block_bitmap64 map,
 			       dgrp_t group)
 {
 	int		i;
@@ -64,9 +64,9 @@ static void check_block_uninit(ext2_filsys fs, ext2fs_block_bitmap map,
 		    (blk >= fs->group_desc[group].bg_inode_table &&
 		     (blk < fs->group_desc[group].bg_inode_table
 		      + fs->inode_blocks_per_group)))
-			ext2fs_fast_mark_block_bitmap(map, blk);
+			ext2fs_fast_mark_block_bitmap2(map, blk);
 		else
-			ext2fs_fast_unmark_block_bitmap(map, blk);
+			ext2fs_fast_unmark_block_bitmap2(map, blk);
 	}
 	fs->group_desc[group].bg_flags &= ~EXT2_BG_BLOCK_UNINIT;
 	ext2fs_group_desc_csum_set(fs, group);
@@ -75,7 +75,7 @@ static void check_block_uninit(ext2_filsys fs, ext2fs_block_bitmap map,
 /*
  * Check for uninit inode bitmaps and deal with them appropriately
  */
-static void check_inode_uninit(ext2_filsys fs, ext2fs_inode_bitmap map,
+static void check_inode_uninit(ext2_filsys fs, ext2fs_inode_bitmap64 map,
 			  dgrp_t group)
 {
 	int		i;
@@ -88,7 +88,7 @@ static void check_inode_uninit(ext2_filsys fs, ext2fs_inode_bitmap map,
 
 	ino = (group * fs->super->s_inodes_per_group) + 1;
 	for (i=0; i < fs->super->s_inodes_per_group; i++, ino++)
-		ext2fs_fast_unmark_inode_bitmap(map, ino);
+		ext2fs_fast_unmark_inode_bitmap2(map, ino);
 
 	fs->group_desc[group].bg_flags &= ~EXT2_BG_INODE_UNINIT;
 	check_block_uninit(fs, fs->block_map, group);
@@ -102,7 +102,7 @@ static void check_inode_uninit(ext2_filsys fs, ext2fs_inode_bitmap map,
  */
 errcode_t ext2fs_new_inode(ext2_filsys fs, ext2_ino_t dir,
 			   int mode EXT2FS_ATTR((unused)),
-			   ext2fs_inode_bitmap map, ext2_ino_t *ret)
+			   ext2fs_inode_bitmap64 map, ext2_ino_t *ret)
 {
 	ext2_ino_t	dir_group = 0;
 	ext2_ino_t	i;
@@ -128,14 +128,14 @@ errcode_t ext2fs_new_inode(ext2_filsys fs, ext2_ino_t dir,
 			check_inode_uninit(fs, map, (i - 1) /
 					   EXT2_INODES_PER_GROUP(fs->super));
 
-		if (!ext2fs_fast_test_inode_bitmap(map, i))
+		if (!ext2fs_fast_test_inode_bitmap2(map, i))
 			break;
 		i++;
 		if (i > fs->super->s_inodes_count)
 			i = EXT2_FIRST_INODE(fs->super);
 	} while (i != start_inode);
 
-	if (ext2fs_test_inode_bitmap(map, i))
+	if (ext2fs_test_inode_bitmap2(map, i))
 		return EXT2_ET_INODE_ALLOC_FAIL;
 	*ret = i;
 	return 0;
@@ -146,7 +146,7 @@ errcode_t ext2fs_new_inode(ext2_filsys fs, ext2_ino_t dir,
  * goal.  Should put in a smarter one someday....
  */
 errcode_t ext2fs_new_block2(ext2_filsys fs, blk64_t goal,
-			   ext2fs_block_bitmap map, blk64_t *ret)
+			   ext2fs_block_bitmap64 map, blk64_t *ret)
 {
 	blk64_t	i;
 
@@ -169,8 +169,7 @@ errcode_t ext2fs_new_block2(ext2_filsys fs, blk64_t goal,
 					   (i - fs->super->s_first_data_block) /
 					   EXT2_BLOCKS_PER_GROUP(fs->super));
 
-		/* FIXME-64 */
-		if (!ext2fs_fast_test_block_bitmap(map, (blk_t) i)) {
+		if (!ext2fs_fast_test_block_bitmap2(map, (blk_t) i)) {
 			*ret = i;
 			return 0;
 		}
@@ -186,7 +185,8 @@ errcode_t ext2fs_new_block(ext2_filsys fs, blk_t goal,
 {
 	errcode_t retval;
 	blk64_t val;
-	retval = ext2fs_new_block2(fs, goal, map, &val);
+	retval = ext2fs_new_block2(fs, goal, (ext2fs_block_bitmap64) map,
+				   &val);
 	if (!retval)
 		*ret = (blk_t) val;
 	return retval;
@@ -217,7 +217,6 @@ errcode_t ext2fs_alloc_block2(ext2_filsys fs, blk64_t goal,
 			goto fail;
 	} else {
 		if (!fs->block_map) {
-			/* FIXME-64 */
 			retval = ext2fs_read_block_bitmap(fs);
 			if (retval)
 				goto fail;
@@ -253,14 +252,14 @@ errcode_t ext2fs_alloc_block(ext2_filsys fs, blk_t goal,
 }
 
 errcode_t ext2fs_get_free_blocks2(ext2_filsys fs, blk64_t start, blk64_t finish,
-				 int num, ext2fs_block_bitmap map, blk64_t *ret)
+				 int num, ext2fs_block_bitmap64 map, blk64_t *ret)
 {
 	blk64_t	b = start;
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
 	if (!map)
-		map = fs->block_map;
+		map = (ext2fs_block_bitmap64) fs->block_map;
 	if (!map)
 		return EXT2_ET_NO_BLOCK_BITMAP;
 	if (!b)
@@ -272,8 +271,7 @@ errcode_t ext2fs_get_free_blocks2(ext2_filsys fs, blk64_t start, blk64_t finish,
 	do {
 		if (b+num-1 > fs->super->s_blocks_count)
 			b = fs->super->s_first_data_block;
-		/* FIXME-64 */
-		if (ext2fs_fast_test_block_bitmap_range(map, (blk_t) b,
+		if (ext2fs_fast_test_block_bitmap_range2(map, (blk_t) b,
 							(blk_t) num)) {
 			*ret = b;
 			return 0;
@@ -288,7 +286,8 @@ errcode_t ext2fs_get_free_blocks(ext2_filsys fs, blk_t start, blk_t finish,
 {
 	errcode_t retval;
 	blk64_t val;
-	retval = ext2fs_get_free_blocks2(fs, start, finish, num, map, &val);
+	retval = ext2fs_get_free_blocks2(fs, start, finish, num,
+					 (ext2fs_block_bitmap64) map, &val);
 	if(!retval)
 		*ret = (blk_t) val;
 	return retval;
diff --git a/lib/ext2fs/alloc_sb.c b/lib/ext2fs/alloc_sb.c
index 42c1d94..ddf4644 100644
--- a/lib/ext2fs/alloc_sb.c
+++ b/lib/ext2fs/alloc_sb.c
@@ -42,7 +42,7 @@
  */
 int ext2fs_reserve_super_and_bgd(ext2_filsys fs,
 				 dgrp_t group,
-				 ext2fs_block_bitmap bmap)
+				 ext2fs_block_bitmap64 bmap)
 {
 	blk64_t	super_blk, old_desc_blk, new_desc_blk;
 	blk_t	used_blks;
@@ -58,21 +58,18 @@ int ext2fs_reserve_super_and_bgd(ext2_filsys fs,
 			fs->desc_blocks + fs->super->s_reserved_gdt_blocks;
 
 	if (super_blk || (group == 0))
-		/* FIXME-64 */
-		ext2fs_mark_block_bitmap(bmap, super_blk);
+		ext2fs_mark_block_bitmap2(bmap, super_blk);
 
 	if (old_desc_blk) {
 		if (fs->super->s_reserved_gdt_blocks && fs->block_map == bmap)
 			fs->group_desc[group].bg_flags &= ~EXT2_BG_BLOCK_UNINIT;
 		for (j=0; j < old_desc_blocks; j++)
 			if (old_desc_blk + j < fs->super->s_blocks_count)
-				/* FIXME-64 */
-				ext2fs_mark_block_bitmap(bmap,
+				ext2fs_mark_block_bitmap2(bmap,
 							 old_desc_blk + j);
 	}
 	if (new_desc_blk)
-		/* FIXME-64 */
-		ext2fs_mark_block_bitmap(bmap, new_desc_blk);
+		ext2fs_mark_block_bitmap2(bmap, new_desc_blk);
 
 	if (group == fs->group_desc_count-1) {
 		num_blocks = (fs->super->s_blocks_count -
diff --git a/lib/ext2fs/alloc_stats.c b/lib/ext2fs/alloc_stats.c
index 79a190e..0998c8c 100644
--- a/lib/ext2fs/alloc_stats.c
+++ b/lib/ext2fs/alloc_stats.c
@@ -21,9 +21,9 @@ void ext2fs_inode_alloc_stats2(ext2_filsys fs, ext2_ino_t ino,
 	int	group = ext2fs_group_of_ino(fs, ino);
 
 	if (inuse > 0)
-		ext2fs_mark_inode_bitmap(fs->inode_map, ino);
+		ext2fs_mark_inode_bitmap2(fs->inode_map, ino);
 	else
-		ext2fs_unmark_inode_bitmap(fs->inode_map, ino);
+		ext2fs_unmark_inode_bitmap2(fs->inode_map, ino);
 	fs->group_desc[group].bg_free_inodes_count -= inuse;
 	if (isdir)
 		fs->group_desc[group].bg_used_dirs_count += inuse;
@@ -59,11 +59,9 @@ void ext2fs_block_alloc_stats2(ext2_filsys fs, blk64_t blk, int inuse)
 	int	group = ext2fs_group_of_blk2(fs, blk);
 
 	if (inuse > 0)
-		/* FIXME-64 */
-		ext2fs_mark_block_bitmap(fs->block_map, blk);
+		ext2fs_mark_block_bitmap2(fs->block_map, blk);
 	else
-		/* FIXME-64 */
-		ext2fs_unmark_block_bitmap(fs->block_map, blk);
+		ext2fs_unmark_block_bitmap2(fs->block_map, blk);
 	fs->group_desc[group].bg_free_blocks_count -= inuse;
 	fs->group_desc[group].bg_flags &= ~EXT2_BG_BLOCK_UNINIT;
 	ext2fs_group_desc_csum_set(fs, group);
diff --git a/lib/ext2fs/alloc_tables.c b/lib/ext2fs/alloc_tables.c
index 2bef914..7235f7d 100644
--- a/lib/ext2fs/alloc_tables.c
+++ b/lib/ext2fs/alloc_tables.c
@@ -33,8 +33,8 @@
  * block number with a correct offset were the bitmaps and inode
  * tables can be allocated continously and in order.
  */
-static blk64_t flexbg_offset(ext2_filsys fs, dgrp_t group, blk_t start_blk,
-			     ext2fs_block_bitmap bmap, int offset, int size,
+static blk64_t flexbg_offset(ext2_filsys fs, dgrp_t group, blk64_t start_blk,
+			     ext2fs_block_bitmap64 bmap, int offset, int size,
 			     int elem_size)
 {
 	int		flexbg, flexbg_size;
@@ -55,7 +55,7 @@ static blk64_t flexbg_offset(ext2_filsys fs, dgrp_t group, blk_t start_blk,
 	 * search is still valid.
 	 */
 	if (start_blk && group % flexbg_size) {
-		if (ext2fs_test_block_bitmap_range(bmap, start_blk + elem_size,
+		if (ext2fs_test_block_bitmap_range2(bmap, start_blk + elem_size,
 						   size))
 			return start_blk + elem_size;
 	}
@@ -79,7 +79,7 @@ static blk64_t flexbg_offset(ext2_filsys fs, dgrp_t group, blk_t start_blk,
 }
 
 errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
-				      ext2fs_block_bitmap bmap)
+				      ext2fs_block_bitmap64 bmap)
 {
 	errcode_t	retval;
 	blk64_t		group_blk, start_blk, last_blk, new_blk, blk;
@@ -90,7 +90,7 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 	last_blk = ext2fs_group_last_block2(fs, group);
 
 	if (!bmap)
-		bmap = fs->block_map;
+		bmap = (ext2fs_block_bitmap64) fs->block_map;
 
 	if (EXT2_HAS_INCOMPAT_FEATURE(fs->super,
 				      EXT4_FEATURE_INCOMPAT_FLEX_BG) &&
@@ -119,7 +119,7 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 		start_blk = group_blk;
 
 	if (flexbg_size) {
-		int prev_block = 0;
+		blk64_t prev_block = 0;
 		if (group && ext2fs_block_bitmap_loc(fs, group - 1))
 			prev_block = ext2fs_block_bitmap_loc(fs, group - 1);
 		start_blk = flexbg_offset(fs, group, prev_block, bmap,
@@ -135,8 +135,7 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 					last_blk, 1, bmap, &new_blk);
 		if (retval)
 			return retval;
-		/* FIXME-64 */
-		ext2fs_mark_block_bitmap(bmap, new_blk);
+		ext2fs_mark_block_bitmap2(bmap, new_blk);
 		ext2fs_block_bitmap_loc_set(fs, group, new_blk);
 		if (flexbg_size) {
 			dgrp_t gr = ext2fs_group_of_blk2(fs, new_blk);
@@ -164,8 +163,7 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 					last_blk, 1, bmap, &new_blk);
 		if (retval)
 			return retval;
-		/* FIXME-64 */
-		ext2fs_mark_block_bitmap(bmap, new_blk);
+		ext2fs_mark_block_bitmap2(bmap, new_blk);
 		ext2fs_inode_bitmap_loc_set(fs, group, new_blk);
 		if (flexbg_size) {
 			dgrp_t gr = ext2fs_group_of_blk2(fs, new_blk);
@@ -200,8 +198,7 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 		for (j=0, blk = new_blk;
 		     j < fs->inode_blocks_per_group;
 		     j++, blk++) {
-			/* FIXME-64 */
-			ext2fs_mark_block_bitmap(bmap, blk);
+			ext2fs_mark_block_bitmap2(bmap, blk);
 			if (flexbg_size) {
 				dgrp_t gr = ext2fs_group_of_blk2(fs, blk);
 				fs->group_desc[gr].bg_free_blocks_count--;
@@ -222,7 +219,7 @@ errcode_t ext2fs_allocate_tables(ext2_filsys fs)
 	dgrp_t		i;
 
 	for (i = 0; i < fs->group_desc_count; i++) {
-		retval = ext2fs_allocate_group_table(fs, i, fs->block_map);
+		retval = ext2fs_allocate_group_table(fs, i, (ext2fs_block_bitmap64) fs->block_map);
 		if (retval)
 			return retval;
 	}
diff --git a/lib/ext2fs/bb_inode.c b/lib/ext2fs/bb_inode.c
index cbeeb98..53122b5 100644
--- a/lib/ext2fs/bb_inode.c
+++ b/lib/ext2fs/bb_inode.c
@@ -235,7 +235,7 @@ static int set_bad_block_proc(ext2_filsys fs, blk_t *block_nr,
 	retry:
 		if (rec->ind_blocks_ptr < rec->ind_blocks_size) {
 			blk = rec->ind_blocks[rec->ind_blocks_ptr++];
-			if (ext2fs_test_block_bitmap(fs->block_map, blk))
+			if (ext2fs_test_block_bitmap2(fs->block_map, blk))
 				goto retry;
 		} else {
 			retval = ext2fs_new_block(fs, 0, 0, &blk);
diff --git a/lib/ext2fs/bitmaps.c b/lib/ext2fs/bitmaps.c
index ea08b3e..f438a8b 100644
--- a/lib/ext2fs/bitmaps.c
+++ b/lib/ext2fs/bitmaps.c
@@ -26,33 +26,33 @@
 
 #include "ext2_fs.h"
 #include "ext2fs.h"
+#include "ext2fsP.h"
 
-void ext2fs_free_inode_bitmap(ext2fs_inode_bitmap bitmap)
+void ext2fs_free_inode_bitmap(ext2fs_inode_bitmap64 bitmap)
 {
-	ext2fs_free_generic_bitmap(bitmap);
+	ext2fs_free_generic_bmap(bitmap);
 }
 
-void ext2fs_free_block_bitmap(ext2fs_block_bitmap bitmap)
+void ext2fs_free_block_bitmap(ext2fs_block_bitmap64 bitmap)
 {
-	ext2fs_free_generic_bitmap(bitmap);
+	ext2fs_free_generic_bmap(bitmap);
 }
 
-errcode_t ext2fs_copy_bitmap(ext2fs_generic_bitmap src,
-			     ext2fs_generic_bitmap *dest)
+errcode_t ext2fs_copy_bitmap(ext2fs_generic_bitmap64 src,
+			     ext2fs_generic_bitmap64 *dest)
 {
-	return (ext2fs_copy_generic_bitmap(src, dest));
+	return (ext2fs_copy_generic_bmap(src, dest));
 }
-
-void ext2fs_set_bitmap_padding(ext2fs_generic_bitmap map)
+void ext2fs_set_bitmap_padding(ext2fs_generic_bitmap64 map)
 {
-	ext2fs_set_generic_bitmap_padding(map);
+	ext2fs_set_generic_bmap_padding( map);
 }
 
 errcode_t ext2fs_allocate_inode_bitmap(ext2_filsys fs,
 				       const char *descr,
-				       ext2fs_inode_bitmap *ret)
+				       ext2fs_inode_bitmap64 *ret)
 {
-	__u32		start, end, real_end;
+	__u64		start, end, real_end;
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
@@ -62,39 +62,66 @@ errcode_t ext2fs_allocate_inode_bitmap(ext2_filsys fs,
 	end = fs->super->s_inodes_count;
 	real_end = (EXT2_INODES_PER_GROUP(fs->super) * fs->group_desc_count);
 
+	/* Are we permitted to use new-style bitmaps? */
+	if (fs->flags & EXT2_FLAG_NEW_BITMAPS)
+		return (ext2fs_alloc_generic_bmap(fs,
+				  EXT2_ET_MAGIC_INODE_BITMAP64,
+				  EXT2FS_BMAP64_BITARRAY,
+				  start, end, real_end, descr, ret));
+
+	/* Otherwise, check to see if the file system is small enough
+	 * to use old-style 32-bit bitmaps */
+	if ((end > ~0U) || (real_end > ~0U))
+		return EXT2_ET_FILE_TOO_BIG; /* XXX better error code */
+
 	return (ext2fs_make_generic_bitmap(EXT2_ET_MAGIC_INODE_BITMAP, fs,
-					   start, end, real_end,
-					   descr, 0, ret));
+					 start, end, real_end,
+					 descr, 0,
+					 (ext2fs_generic_bitmap *) ret));
 }
 
 errcode_t ext2fs_allocate_block_bitmap(ext2_filsys fs,
 				       const char *descr,
-				       ext2fs_block_bitmap *ret)
+				       ext2fs_block_bitmap64 *ret)
 {
-	__u32		start, end, real_end;
+	__u64		start, end, real_end;
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
 	fs->write_bitmaps = ext2fs_write_bitmaps;
 
 	start = fs->super->s_first_data_block;
-	end = fs->super->s_blocks_count-1;
+	end = ext2fs_blocks_count(fs->super)-1;
 	real_end = (EXT2_BLOCKS_PER_GROUP(fs->super)
 		    * fs->group_desc_count)-1 + start;
 
+	if (fs->flags & EXT2_FLAG_NEW_BITMAPS)
+		return (ext2fs_alloc_generic_bmap(fs,
+				  EXT2_ET_MAGIC_BLOCK_BITMAP64,
+				  EXT2FS_BMAP64_BITARRAY,
+				  start, end, real_end, descr, ret));
+
+	if ((end > ~0U) || (real_end > ~0U))
+		return EXT2_ET_FILE_TOO_BIG; /* XXX better error code */
+
 	return (ext2fs_make_generic_bitmap(EXT2_ET_MAGIC_BLOCK_BITMAP, fs,
 					   start, end, real_end,
-					   descr, 0, ret));
+					   descr, 0,
+					   (ext2fs_generic_bitmap *) ret));
 }
 
 errcode_t ext2fs_fudge_inode_bitmap_end(ext2fs_inode_bitmap bitmap,
 					ext2_ino_t end, ext2_ino_t *oend)
 {
+	__u64 tmp_oend;
+	int retval;
 
-	return (ext2fs_fudge_generic_bitmap_end(bitmap,
-						EXT2_ET_MAGIC_INODE_BITMAP,
-						EXT2_ET_FUDGE_INODE_BITMAP_END,
-						end, oend));
+	retval = ext2fs_fudge_generic_bmap_end((ext2fs_generic_bitmap64) bitmap,
+					       EXT2_ET_FUDGE_INODE_BITMAP_END,
+					       end, &tmp_oend);
+	if (oend)
+		*oend = tmp_oend;
+	return retval;
 }
 
 errcode_t ext2fs_fudge_block_bitmap_end(ext2fs_block_bitmap bitmap,
@@ -106,14 +133,22 @@ errcode_t ext2fs_fudge_block_bitmap_end(ext2fs_block_bitmap bitmap,
 						end, oend));
 }
 
-void ext2fs_clear_inode_bitmap(ext2fs_inode_bitmap bitmap)
+errcode_t ext2fs_fudge_block_bitmap_end2(ext2fs_block_bitmap64 bitmap,
+					 blk64_t end, blk64_t *oend)
+{
+	return (ext2fs_fudge_generic_bmap_end(bitmap,
+					      EXT2_ET_FUDGE_BLOCK_BITMAP_END,
+					      end, oend));
+}
+
+void ext2fs_clear_inode_bitmap(ext2fs_inode_bitmap64 bitmap)
 {
-	ext2fs_clear_generic_bitmap(bitmap);
+	ext2fs_clear_generic_bmap(bitmap);
 }
 
-void ext2fs_clear_block_bitmap(ext2fs_block_bitmap bitmap)
+void ext2fs_clear_block_bitmap(ext2fs_block_bitmap64 bitmap)
 {
-	ext2fs_clear_generic_bitmap(bitmap);
+	ext2fs_clear_generic_bmap(bitmap);
 }
 
 errcode_t ext2fs_resize_inode_bitmap(__u32 new_end, __u32 new_real_end,
@@ -123,6 +158,12 @@ errcode_t ext2fs_resize_inode_bitmap(__u32 new_end, __u32 new_real_end,
 					     new_end, new_real_end, bmap));
 }
 
+errcode_t ext2fs_resize_inode_bitmap2(__u64 new_end, __u64 new_real_end,
+				      ext2fs_inode_bitmap64 bmap)
+{
+	return (ext2fs_resize_generic_bmap(bmap, new_end, new_real_end));
+}
+
 errcode_t ext2fs_resize_block_bitmap(__u32 new_end, __u32 new_real_end,
 				     ext2fs_block_bitmap bmap)
 {
@@ -130,20 +171,24 @@ errcode_t ext2fs_resize_block_bitmap(__u32 new_end, __u32 new_real_end,
 					     new_end, new_real_end, bmap));
 }
 
-errcode_t ext2fs_compare_block_bitmap(ext2fs_block_bitmap bm1,
-				      ext2fs_block_bitmap bm2)
+errcode_t ext2fs_resize_block_bitmap2(__u64 new_end, __u64 new_real_end,
+				      ext2fs_block_bitmap64 bmap)
 {
-	return (ext2fs_compare_generic_bitmap(EXT2_ET_MAGIC_BLOCK_BITMAP,
-					      EXT2_ET_NEQ_BLOCK_BITMAP,
-					      bm1, bm2));
+	return (ext2fs_resize_generic_bmap(bmap, new_end, new_real_end));
 }
 
-errcode_t ext2fs_compare_inode_bitmap(ext2fs_inode_bitmap bm1,
-				      ext2fs_inode_bitmap bm2)
+errcode_t ext2fs_compare_block_bitmap(ext2fs_block_bitmap64 bm1,
+				      ext2fs_block_bitmap64 bm2)
 {
-	return (ext2fs_compare_generic_bitmap(EXT2_ET_MAGIC_INODE_BITMAP,
-					      EXT2_ET_NEQ_INODE_BITMAP,
-					      bm1, bm2));
+	return (ext2fs_compare_generic_bmap(EXT2_ET_NEQ_BLOCK_BITMAP,
+					    bm1, bm2));
+}
+
+errcode_t ext2fs_compare_inode_bitmap(ext2fs_inode_bitmap64 bm1,
+				      ext2fs_inode_bitmap64 bm2)
+{
+	return (ext2fs_compare_generic_bmap(EXT2_ET_NEQ_INODE_BITMAP,
+					    bm1, bm2));
 }
 
 errcode_t ext2fs_set_inode_bitmap_range(ext2fs_inode_bitmap bmap,
@@ -155,6 +200,13 @@ errcode_t ext2fs_set_inode_bitmap_range(ext2fs_inode_bitmap bmap,
 						start, num, in));
 }
 
+errcode_t ext2fs_set_inode_bitmap_range2(ext2fs_inode_bitmap64 bmap,
+					 __u64 start, size_t num,
+					 void *in)
+{
+	return (ext2fs_set_generic_bmap_range(bmap, start, num, in));
+}
+
 errcode_t ext2fs_get_inode_bitmap_range(ext2fs_inode_bitmap bmap,
 					ext2_ino_t start, unsigned int num,
 					void *out)
@@ -164,6 +216,13 @@ errcode_t ext2fs_get_inode_bitmap_range(ext2fs_inode_bitmap bmap,
 						start, num, out));
 }
 
+errcode_t ext2fs_get_inode_bitmap_range2(ext2fs_inode_bitmap64 bmap,
+					 __u64 start, size_t num,
+					 void *out)
+{
+	return (ext2fs_get_generic_bmap_range(bmap, start, num, out));
+}
+
 errcode_t ext2fs_set_block_bitmap_range(ext2fs_block_bitmap bmap,
 					blk_t start, unsigned int num,
 					void *in)
@@ -173,6 +232,13 @@ errcode_t ext2fs_set_block_bitmap_range(ext2fs_block_bitmap bmap,
 						start, num, in));
 }
 
+errcode_t ext2fs_set_block_bitmap_range2(ext2fs_block_bitmap64 bmap,
+					 blk64_t start, size_t num,
+					 void *in)
+{
+	return (ext2fs_set_generic_bmap_range(bmap, start, num, in));
+}
+
 errcode_t ext2fs_get_block_bitmap_range(ext2fs_block_bitmap bmap,
 					blk_t start, unsigned int num,
 					void *out)
@@ -181,3 +247,10 @@ errcode_t ext2fs_get_block_bitmap_range(ext2fs_block_bitmap bmap,
 						EXT2_ET_MAGIC_BLOCK_BITMAP,
 						start, num, out));
 }
+
+errcode_t ext2fs_get_block_bitmap_range2(ext2fs_block_bitmap64 bmap,
+					 blk64_t start, size_t num,
+					 void *out)
+{
+	return (ext2fs_get_generic_bmap_range(bmap, start, num, out));
+}
diff --git a/lib/ext2fs/bitops.h b/lib/ext2fs/bitops.h
index 1138800..aa2401b 100644
--- a/lib/ext2fs/bitops.h
+++ b/lib/ext2fs/bitops.h
@@ -107,7 +107,7 @@ extern void ext2fs_fast_unmark_block_bitmap_range(ext2fs_block_bitmap bitmap,
 						  blk_t block, int num);
 extern int ext2fs_fast_test_block_bitmap_range(ext2fs_block_bitmap bitmap,
 					       blk_t block, int num);
-extern void ext2fs_set_bitmap_padding(ext2fs_generic_bitmap map);
+extern void ext2fs_set_bitmap_padding(ext2fs_generic_bitmap64 map);
 
 /* These routines moved to gen_bitmap.c (actually, some of the above, too) */
 extern int ext2fs_mark_generic_bitmap(ext2fs_generic_bitmap bitmap,
diff --git a/lib/ext2fs/bmove.c b/lib/ext2fs/bmove.c
index 019db91..f685f9d 100644
--- a/lib/ext2fs/bmove.c
+++ b/lib/ext2fs/bmove.c
@@ -24,8 +24,8 @@
 struct process_block_struct {
 	ext2_ino_t		ino;
 	struct ext2_inode *	inode;
-	ext2fs_block_bitmap	reserve;
-	ext2fs_block_bitmap	alloc_map;
+	ext2fs_block_bitmap64	reserve;
+	ext2fs_block_bitmap64	alloc_map;
 	errcode_t		error;
 	char			*buf;
 	int			add_dir;
@@ -48,7 +48,7 @@ static int process_block(ext2_filsys fs, blk_t	*block_nr,
 	/*
 	 * Let's see if this is one which we need to relocate
 	 */
-	if (ext2fs_test_block_bitmap(pb->reserve, block)) {
+	if (ext2fs_test_block_bitmap2(pb->reserve, block)) {
 		do {
 			if (++block >= fs->super->s_blocks_count)
 				block = fs->super->s_first_data_block;
@@ -56,8 +56,8 @@ static int process_block(ext2_filsys fs, blk_t	*block_nr,
 				pb->error = EXT2_ET_BLOCK_ALLOC_FAIL;
 				return BLOCK_ABORT;
 			}
-		} while (ext2fs_test_block_bitmap(pb->reserve, block) ||
-			 ext2fs_test_block_bitmap(pb->alloc_map, block));
+		} while (ext2fs_test_block_bitmap2(pb->reserve, block) ||
+			 ext2fs_test_block_bitmap2(pb->alloc_map, block));
 
 		retval = io_channel_read_blk(fs->io, orig, 1, pb->buf);
 		if (retval) {
@@ -70,7 +70,7 @@ static int process_block(ext2_filsys fs, blk_t	*block_nr,
 			return BLOCK_ABORT;
 		}
 		*block_nr = block;
-		ext2fs_mark_block_bitmap(pb->alloc_map, block);
+		ext2fs_mark_block_bitmap2(pb->alloc_map, block);
 		ret = BLOCK_CHANGED;
 		if (pb->flags & EXT2_BMOVE_DEBUG)
 			printf("ino=%ld, blockcnt=%lld, %u->%u\n", pb->ino,
@@ -88,8 +88,8 @@ static int process_block(ext2_filsys fs, blk_t	*block_nr,
 }
 
 errcode_t ext2fs_move_blocks(ext2_filsys fs,
-			     ext2fs_block_bitmap reserve,
-			     ext2fs_block_bitmap alloc_map,
+			     ext2fs_block_bitmap64 reserve,
+			     ext2fs_block_bitmap64 alloc_map,
 			     int flags)
 {
 	ext2_ino_t	ino;
diff --git a/lib/ext2fs/check_desc.c b/lib/ext2fs/check_desc.c
index 299cb01..f863c77 100644
--- a/lib/ext2fs/check_desc.c
+++ b/lib/ext2fs/check_desc.c
@@ -31,7 +31,7 @@
  */
 errcode_t ext2fs_check_desc(ext2_filsys fs)
 {
-	ext2fs_block_bitmap bmap;
+	ext2fs_block_bitmap64 bmap;
 	errcode_t retval;
 	dgrp_t i;
 	blk_t first_block = fs->super->s_first_data_block;
@@ -62,22 +62,22 @@ errcode_t ext2fs_check_desc(ext2_filsys fs)
 		 */
 		blk = fs->group_desc[i].bg_block_bitmap;
 		if (blk < first_block || blk > last_block ||
-		    ext2fs_test_block_bitmap(bmap, blk)) {
+		    ext2fs_test_block_bitmap2(bmap, blk)) {
 			retval = EXT2_ET_GDESC_BAD_BLOCK_MAP;
 			goto errout;
 		}
-		ext2fs_mark_block_bitmap(bmap, blk);
+		ext2fs_mark_block_bitmap2(bmap, blk);
 
 		/*
 		 * Check to make sure the inode bitmap for group is sane
 		 */
 		blk = fs->group_desc[i].bg_inode_bitmap;
 		if (blk < first_block || blk > last_block ||
-		    ext2fs_test_block_bitmap(bmap, blk)) {
+		    ext2fs_test_block_bitmap2(bmap, blk)) {
 			retval = EXT2_ET_GDESC_BAD_INODE_MAP;
 			goto errout;
 		}
-		ext2fs_mark_block_bitmap(bmap, blk);
+		ext2fs_mark_block_bitmap2(bmap, blk);
 
 		/*
 		 * Check to make sure the inode table for group is sane
@@ -90,11 +90,11 @@ errcode_t ext2fs_check_desc(ext2_filsys fs)
 		}
 		for (j = 0, b = blk; j < fs->inode_blocks_per_group;
 		     j++, b++) {
-			if (ext2fs_test_block_bitmap(bmap, b)) {
+			if (ext2fs_test_block_bitmap2(bmap, b)) {
 				retval = EXT2_ET_GDESC_BAD_INODE_TABLE;
 				goto errout;
 			}
-			ext2fs_mark_block_bitmap(bmap, b);
+			ext2fs_mark_block_bitmap2(bmap, b);
 		}
 	}
 errout:
diff --git a/lib/ext2fs/csum.c b/lib/ext2fs/csum.c
index 459c3c0..79d4d2b 100644
--- a/lib/ext2fs/csum.c
+++ b/lib/ext2fs/csum.c
@@ -78,7 +78,7 @@ void ext2fs_group_desc_csum_set(ext2_filsys fs, dgrp_t group)
 			ext2fs_group_desc_csum(fs, group);
 }
 
-static __u32 find_last_inode_ingrp(ext2fs_inode_bitmap bitmap,
+static __u32 find_last_inode_ingrp(ext2fs_inode_bitmap64 bitmap,
 				   __u32 inodes_per_grp, dgrp_t grp_no)
 {
 	ext2_ino_t i, start_ino, end_ino;
@@ -87,7 +87,7 @@ static __u32 find_last_inode_ingrp(ext2fs_inode_bitmap bitmap,
 	end_ino = start_ino + inodes_per_grp - 1;
 
 	for (i = end_ino; i >= start_ino; i--) {
-		if (ext2fs_fast_test_inode_bitmap(bitmap, i))
+		if (ext2fs_fast_test_inode_bitmap2(bitmap, i))
 			return i - start_ino + 1;
 	}
 	return inodes_per_grp;
diff --git a/lib/ext2fs/ext2_io.h b/lib/ext2fs/ext2_io.h
index 2a579e6..a39bd17 100644
--- a/lib/ext2fs/ext2_io.h
+++ b/lib/ext2fs/ext2_io.h
@@ -126,6 +126,10 @@ extern void (*test_io_cb_read_blk)
 	(unsigned long block, int count, errcode_t err);
 extern void (*test_io_cb_write_blk)
 	(unsigned long block, int count, errcode_t err);
+extern void (*test_io_cb_read_blk64)
+	(unsigned long long block, int count, errcode_t err);
+extern void (*test_io_cb_write_blk64)
+	(unsigned long long block, int count, errcode_t err);
 extern void (*test_io_cb_set_blksize)
 	(int blksize, errcode_t err);
 
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index dbc5909..9149991 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -204,8 +204,8 @@ struct struct_ext2_filsys {
 	unsigned long			desc_blocks;
 	struct ext2_group_desc *	group_desc;
 	int				inode_blocks_per_group;
-	ext2fs_inode_bitmap		inode_map;
-	ext2fs_block_bitmap		block_map;
+	ext2fs_inode_bitmap64		inode_map;
+	ext2fs_block_bitmap64		block_map;
 	errcode_t (*get_blocks)(ext2_filsys fs, ext2_ino_t ino, blk_t *blocks);
 	errcode_t (*check_directory)(ext2_filsys fs, ext2_ino_t ino);
 	errcode_t (*write_bitmaps)(ext2_filsys fs);
@@ -559,18 +559,18 @@ typedef struct ext2_icount *ext2_icount_t;
 
 /* alloc.c */
 extern errcode_t ext2fs_new_inode(ext2_filsys fs, ext2_ino_t dir, int mode,
-				  ext2fs_inode_bitmap map, ext2_ino_t *ret);
+				  ext2fs_inode_bitmap64 map, ext2_ino_t *ret);
 extern errcode_t ext2fs_new_block(ext2_filsys fs, blk_t goal,
 				  ext2fs_block_bitmap map, blk_t *ret);
 extern errcode_t ext2fs_new_block2(ext2_filsys fs, blk64_t goal,
-				   ext2fs_block_bitmap map, blk64_t *ret);
+				   ext2fs_block_bitmap64 map, blk64_t *ret);
 extern errcode_t ext2fs_get_free_blocks(ext2_filsys fs, blk_t start,
 					blk_t finish, int num,
 					ext2fs_block_bitmap map,
 					blk_t *ret);
 extern errcode_t ext2fs_get_free_blocks2(ext2_filsys fs, blk64_t start,
 					 blk64_t finish, int num,
-					 ext2fs_block_bitmap map,
+					 ext2fs_block_bitmap64 map,
 					 blk64_t *ret);
 extern errcode_t ext2fs_alloc_block(ext2_filsys fs, blk_t goal,
 				    char *block_buf, blk_t *ret);
@@ -587,7 +587,7 @@ extern void ext2fs_set_alloc_block_callback(ext2_filsys fs,
 /* alloc_sb.c */
 extern int ext2fs_reserve_super_and_bgd(ext2_filsys fs,
 					dgrp_t group,
-					ext2fs_block_bitmap bmap);
+					ext2fs_block_bitmap64 bmap);
 extern void ext2fs_set_block_alloc_stats_callback(ext2_filsys fs,
 						  void (*func)(ext2_filsys fs,
 							       blk64_t blk,
@@ -606,7 +606,7 @@ void ext2fs_block_alloc_stats2(ext2_filsys fs, blk64_t blk, int inuse);
 /* alloc_tables.c */
 extern errcode_t ext2fs_allocate_tables(ext2_filsys fs);
 extern errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
-					     ext2fs_block_bitmap bmap);
+					     ext2fs_block_bitmap64 bmap);
 
 /* badblocks.c */
 extern errcode_t ext2fs_u32_list_create(ext2_u32_list *ret, int size);
@@ -655,48 +655,68 @@ extern errcode_t ext2fs_update_bb_inode(ext2_filsys fs,
 					ext2_badblocks_list bb_list);
 
 /* bitmaps.c */
-extern void ext2fs_free_block_bitmap(ext2fs_block_bitmap bitmap);
-extern void ext2fs_free_inode_bitmap(ext2fs_inode_bitmap bitmap);
-extern errcode_t ext2fs_copy_bitmap(ext2fs_generic_bitmap src,
-				    ext2fs_generic_bitmap *dest);
+extern void ext2fs_free_block_bitmap(ext2fs_block_bitmap64 bitmap);
+extern void ext2fs_free_inode_bitmap(ext2fs_inode_bitmap64 bitmap);
+extern errcode_t ext2fs_copy_bitmap(ext2fs_generic_bitmap64 src,
+				    ext2fs_generic_bitmap64 *dest);
 extern errcode_t ext2fs_write_inode_bitmap(ext2_filsys fs);
 extern errcode_t ext2fs_write_block_bitmap (ext2_filsys fs);
 extern errcode_t ext2fs_read_inode_bitmap (ext2_filsys fs);
 extern errcode_t ext2fs_read_block_bitmap(ext2_filsys fs);
 extern errcode_t ext2fs_allocate_block_bitmap(ext2_filsys fs,
 					      const char *descr,
-					      ext2fs_block_bitmap *ret);
+					      ext2fs_block_bitmap64 *ret);
 extern errcode_t ext2fs_allocate_inode_bitmap(ext2_filsys fs,
 					      const char *descr,
-					      ext2fs_inode_bitmap *ret);
+					      ext2fs_inode_bitmap64 *ret);
 extern errcode_t ext2fs_fudge_inode_bitmap_end(ext2fs_inode_bitmap bitmap,
 					       ext2_ino_t end, ext2_ino_t *oend);
 extern errcode_t ext2fs_fudge_block_bitmap_end(ext2fs_block_bitmap bitmap,
 					       blk_t end, blk_t *oend);
-extern void ext2fs_clear_inode_bitmap(ext2fs_inode_bitmap bitmap);
-extern void ext2fs_clear_block_bitmap(ext2fs_block_bitmap bitmap);
+extern errcode_t ext2fs_fudge_block_bitmap_end2(ext2fs_block_bitmap64 bitmap,
+					 blk64_t end, blk64_t *oend);
+extern void ext2fs_clear_inode_bitmap(ext2fs_inode_bitmap64 bitmap);
+extern void ext2fs_clear_block_bitmap(ext2fs_block_bitmap64 bitmap);
 extern errcode_t ext2fs_read_bitmaps(ext2_filsys fs);
 extern errcode_t ext2fs_write_bitmaps(ext2_filsys fs);
 extern errcode_t ext2fs_resize_inode_bitmap(__u32 new_end, __u32 new_real_end,
 					    ext2fs_inode_bitmap bmap);
+extern errcode_t ext2fs_resize_inode_bitmap2(__u64 new_end,
+					     __u64 new_real_end,
+					     ext2fs_inode_bitmap64 bmap);
 extern errcode_t ext2fs_resize_block_bitmap(__u32 new_end, __u32 new_real_end,
 					    ext2fs_block_bitmap bmap);
-extern errcode_t ext2fs_compare_block_bitmap(ext2fs_block_bitmap bm1,
-					     ext2fs_block_bitmap bm2);
-extern errcode_t ext2fs_compare_inode_bitmap(ext2fs_inode_bitmap bm1,
-					     ext2fs_inode_bitmap bm2);
+extern errcode_t ext2fs_resize_block_bitmap2(__u64 new_end,
+					     __u64 new_real_end,
+					     ext2fs_block_bitmap64 bmap);
+extern errcode_t ext2fs_compare_block_bitmap(ext2fs_block_bitmap64 bm1,
+					     ext2fs_block_bitmap64 bm2);
+extern errcode_t ext2fs_compare_inode_bitmap(ext2fs_inode_bitmap64 bm1,
+					     ext2fs_inode_bitmap64 bm2);
 extern errcode_t ext2fs_set_inode_bitmap_range(ext2fs_inode_bitmap bmap,
 					ext2_ino_t start, unsigned int num,
 					void *in);
+extern errcode_t ext2fs_set_inode_bitmap_range2(ext2fs_inode_bitmap64 bmap,
+					 __u64 start, size_t num,
+					 void *in);
 extern errcode_t ext2fs_get_inode_bitmap_range(ext2fs_inode_bitmap bmap,
 					ext2_ino_t start, unsigned int num,
 					void *out);
+extern errcode_t ext2fs_get_inode_bitmap_range2(ext2fs_inode_bitmap64 bmap,
+					 __u64 start, size_t num,
+					 void *out);
 extern errcode_t ext2fs_set_block_bitmap_range(ext2fs_block_bitmap bmap,
 					blk_t start, unsigned int num,
 					void *in);
+extern errcode_t ext2fs_set_block_bitmap_range2(ext2fs_block_bitmap64 bmap,
+					 blk64_t start, size_t num,
+					 void *in);
 extern errcode_t ext2fs_get_block_bitmap_range(ext2fs_block_bitmap bmap,
 					blk_t start, unsigned int num,
 					void *out);
+extern errcode_t ext2fs_get_block_bitmap_range2(ext2fs_block_bitmap64 bmap,
+					 blk64_t start, size_t num,
+					 void *out);
 
 /* blknum.c */
 extern dgrp_t ext2fs_group_of_blk2(ext2_filsys fs, blk64_t);
@@ -989,6 +1009,33 @@ extern errcode_t ext2fs_set_generic_bitmap_range(ext2fs_generic_bitmap bmap,
 						 __u32 start, __u32 num,
 						 void *in);
 
+/* gen_bitmap64.c */
+void ext2fs_free_generic_bmap(ext2fs_generic_bitmap64 bmap);
+errcode_t ext2fs_alloc_generic_bmap(ext2_filsys fs, errcode_t magic,
+				    int type, __u64 start, __u64 end,
+				    __u64 real_end,
+				    const char *descr,
+				    ext2fs_generic_bitmap64 *ret);
+errcode_t ext2fs_copy_generic_bmap(ext2fs_generic_bitmap64 src,
+				   ext2fs_generic_bitmap64 *dest);
+void ext2fs_clear_generic_bmap(ext2fs_generic_bitmap64 bitmap);
+errcode_t ext2fs_fudge_generic_bmap_end(ext2fs_generic_bitmap64 bitmap,
+					errcode_t neq,
+					__u64 end, __u64 *oend);
+void ext2fs_set_generic_bmap_padding(ext2fs_generic_bitmap64 bmap);
+errcode_t ext2fs_resize_generic_bmap(ext2fs_generic_bitmap64 bmap,
+				     __u64 new_end,
+				     __u64 new_real_end);
+errcode_t ext2fs_compare_generic_bmap(errcode_t neq,
+				      ext2fs_generic_bitmap64 bm1,
+				      ext2fs_generic_bitmap64 bm2);
+errcode_t ext2fs_get_generic_bmap_range(ext2fs_generic_bitmap64 bmap,
+					__u64 start, unsigned int num,
+					void *out);
+errcode_t ext2fs_set_generic_bmap_range(ext2fs_generic_bitmap64 bmap,
+					__u64 start, unsigned int num,
+					void *in);
+
 /* getsize.c */
 extern errcode_t ext2fs_get_device_size(const char *file, int blocksize,
 					blk_t *retblocks);
diff --git a/lib/ext2fs/icount.c b/lib/ext2fs/icount.c
index bec0f5f..fe24e56 100644
--- a/lib/ext2fs/icount.c
+++ b/lib/ext2fs/icount.c
@@ -48,8 +48,8 @@ struct ext2_icount_el {
 
 struct ext2_icount {
 	errcode_t		magic;
-	ext2fs_inode_bitmap	single;
-	ext2fs_inode_bitmap	multiple;
+	ext2fs_inode_bitmap64	single;
+	ext2fs_inode_bitmap64	multiple;
 	ext2_ino_t		count;
 	ext2_ino_t		size;
 	ext2_ino_t		num_inodes;
@@ -498,12 +498,12 @@ errcode_t ext2fs_icount_fetch(ext2_icount_t icount, ext2_ino_t ino, __u16 *ret)
 	if (!ino || (ino > icount->num_inodes))
 		return EXT2_ET_INVALID_ARGUMENT;
 
-	if (ext2fs_test_inode_bitmap(icount->single, ino)) {
+	if (ext2fs_test_inode_bitmap2(icount->single, ino)) {
 		*ret = 1;
 		return 0;
 	}
 	if (icount->multiple &&
-	    !ext2fs_test_inode_bitmap(icount->multiple, ino)) {
+	    !ext2fs_test_inode_bitmap2(icount->multiple, ino)) {
 		*ret = 0;
 		return 0;
 	}
@@ -522,7 +522,7 @@ errcode_t ext2fs_icount_increment(ext2_icount_t icount, ext2_ino_t ino,
 	if (!ino || (ino > icount->num_inodes))
 		return EXT2_ET_INVALID_ARGUMENT;
 
-	if (ext2fs_test_inode_bitmap(icount->single, ino)) {
+	if (ext2fs_test_inode_bitmap2(icount->single, ino)) {
 		/*
 		 * If the existing count is 1, then we know there is
 		 * no entry in the list.
@@ -530,14 +530,14 @@ errcode_t ext2fs_icount_increment(ext2_icount_t icount, ext2_ino_t ino,
 		if (set_inode_count(icount, ino, 2))
 			return EXT2_ET_NO_MEMORY;
 		curr_value = 2;
-		ext2fs_unmark_inode_bitmap(icount->single, ino);
+		ext2fs_unmark_inode_bitmap2(icount->single, ino);
 	} else if (icount->multiple) {
 		/*
 		 * The count is either zero or greater than 1; if the
 		 * inode is set in icount->multiple, then there should
 		 * be an entry in the list, so we need to fix it.
 		 */
-		if (ext2fs_test_inode_bitmap(icount->multiple, ino)) {
+		if (ext2fs_test_inode_bitmap2(icount->multiple, ino)) {
 			get_inode_count(icount, ino, &curr_value);
 			curr_value++;
 			if (set_inode_count(icount, ino, curr_value))
@@ -547,7 +547,7 @@ errcode_t ext2fs_icount_increment(ext2_icount_t icount, ext2_ino_t ino,
 			 * The count was zero; mark the single bitmap
 			 * and return.
 			 */
-			ext2fs_mark_inode_bitmap(icount->single, ino);
+			ext2fs_mark_inode_bitmap2(icount->single, ino);
 			if (ret)
 				*ret = 1;
 			return 0;
@@ -563,7 +563,7 @@ errcode_t ext2fs_icount_increment(ext2_icount_t icount, ext2_ino_t ino,
 			return EXT2_ET_NO_MEMORY;
 	}
 	if (icount->multiple)
-		ext2fs_mark_inode_bitmap(icount->multiple, ino);
+		ext2fs_mark_inode_bitmap2(icount->multiple, ino);
 	if (ret)
 		*ret = icount_16_xlate(curr_value);
 	return 0;
@@ -579,10 +579,10 @@ errcode_t ext2fs_icount_decrement(ext2_icount_t icount, ext2_ino_t ino,
 
 	EXT2_CHECK_MAGIC(icount, EXT2_ET_MAGIC_ICOUNT);
 
-	if (ext2fs_test_inode_bitmap(icount->single, ino)) {
-		ext2fs_unmark_inode_bitmap(icount->single, ino);
+	if (ext2fs_test_inode_bitmap2(icount->single, ino)) {
+		ext2fs_unmark_inode_bitmap2(icount->single, ino);
 		if (icount->multiple)
-			ext2fs_unmark_inode_bitmap(icount->multiple, ino);
+			ext2fs_unmark_inode_bitmap2(icount->multiple, ino);
 		else {
 			set_inode_count(icount, ino, 0);
 		}
@@ -592,7 +592,7 @@ errcode_t ext2fs_icount_decrement(ext2_icount_t icount, ext2_ino_t ino,
 	}
 
 	if (icount->multiple &&
-	    !ext2fs_test_inode_bitmap(icount->multiple, ino))
+	    !ext2fs_test_inode_bitmap2(icount->multiple, ino))
 		return EXT2_ET_INVALID_ARGUMENT;
 
 	get_inode_count(icount, ino, &curr_value);
@@ -603,9 +603,9 @@ errcode_t ext2fs_icount_decrement(ext2_icount_t icount, ext2_ino_t ino,
 		return EXT2_ET_NO_MEMORY;
 
 	if (curr_value == 1)
-		ext2fs_mark_inode_bitmap(icount->single, ino);
+		ext2fs_mark_inode_bitmap2(icount->single, ino);
 	if ((curr_value == 0) && icount->multiple)
-		ext2fs_unmark_inode_bitmap(icount->multiple, ino);
+		ext2fs_unmark_inode_bitmap2(icount->multiple, ino);
 
 	if (ret)
 		*ret = icount_16_xlate(curr_value);
@@ -621,19 +621,19 @@ errcode_t ext2fs_icount_store(ext2_icount_t icount, ext2_ino_t ino,
 	EXT2_CHECK_MAGIC(icount, EXT2_ET_MAGIC_ICOUNT);
 
 	if (count == 1) {
-		ext2fs_mark_inode_bitmap(icount->single, ino);
+		ext2fs_mark_inode_bitmap2(icount->single, ino);
 		if (icount->multiple)
-			ext2fs_unmark_inode_bitmap(icount->multiple, ino);
+			ext2fs_unmark_inode_bitmap2(icount->multiple, ino);
 		return 0;
 	}
 	if (count == 0) {
-		ext2fs_unmark_inode_bitmap(icount->single, ino);
+		ext2fs_unmark_inode_bitmap2(icount->single, ino);
 		if (icount->multiple) {
 			/*
 			 * If the icount->multiple bitmap is enabled,
 			 * we can just clear both bitmaps and we're done
 			 */
-			ext2fs_unmark_inode_bitmap(icount->multiple, ino);
+			ext2fs_unmark_inode_bitmap2(icount->multiple, ino);
 		} else
 			set_inode_count(icount, ino, 0);
 		return 0;
@@ -641,9 +641,9 @@ errcode_t ext2fs_icount_store(ext2_icount_t icount, ext2_ino_t ino,
 
 	if (set_inode_count(icount, ino, count))
 		return EXT2_ET_NO_MEMORY;
-	ext2fs_unmark_inode_bitmap(icount->single, ino);
+	ext2fs_unmark_inode_bitmap2(icount->single, ino);
 	if (icount->multiple)
-		ext2fs_mark_inode_bitmap(icount->multiple, ino);
+		ext2fs_mark_inode_bitmap2(icount->multiple, ino);
 	return 0;
 }
 
@@ -746,7 +746,7 @@ static void setup(void)
 	memset(&param, 0, sizeof(param));
 	param.s_blocks_count = 12000;
 
-	retval = ext2fs_initialize("test fs", 0, &param,
+	retval = ext2fs_initialize("test fs", EXT2_FLAG_NEW_BITMAPS, &param,
 				   test_io_manager, &test_fs);
 	if (retval) {
 		com_err("setup", retval,
diff --git a/lib/ext2fs/imager.c b/lib/ext2fs/imager.c
index 0154333..9fdfa0c 100644
--- a/lib/ext2fs/imager.c
+++ b/lib/ext2fs/imager.c
@@ -277,7 +277,7 @@ errout:
  */
 errcode_t ext2fs_image_bitmap_write(ext2_filsys fs, int fd, int flags)
 {
-	ext2fs_generic_bitmap	bmap;
+	ext2fs_generic_bitmap64	bmap;
 	errcode_t		err, retval;
 	ssize_t			actual;
 	__u32			itr, cnt, size;
@@ -314,8 +314,8 @@ errcode_t ext2fs_image_bitmap_write(ext2_filsys fs, int fd, int flags)
 		if (size > (cnt >> 3))
 			size = (cnt >> 3);
 
-		retval = ext2fs_get_generic_bitmap_range(bmap,
-				 err, itr, size << 3, buf);
+		retval = ext2fs_get_generic_bmap_range(bmap, itr,
+						       size << 3, buf);
 		if (retval)
 			return retval;
 
@@ -354,7 +354,7 @@ errcode_t ext2fs_image_bitmap_write(ext2_filsys fs, int fd, int flags)
  */
 errcode_t ext2fs_image_bitmap_read(ext2_filsys fs, int fd, int flags)
 {
-	ext2fs_generic_bitmap	bmap;
+	ext2fs_generic_bitmap64	bmap;
 	errcode_t		err, retval;
 	__u32			itr, cnt;
 	char			buf[1024];
@@ -396,8 +396,8 @@ errcode_t ext2fs_image_bitmap_read(ext2_filsys fs, int fd, int flags)
 		if (actual != (int) size)
 			return EXT2_ET_SHORT_READ;
 
-		retval = ext2fs_set_generic_bitmap_range(bmap,
-				 err, itr, size << 3, buf);
+		retval = ext2fs_set_generic_bmap_range(bmap, itr,
+						       size << 3, buf);
 		if (retval)
 			return retval;
 
diff --git a/lib/ext2fs/rw_bitmaps.c b/lib/ext2fs/rw_bitmaps.c
index 341f834..c859cca 100644
--- a/lib/ext2fs/rw_bitmaps.c
+++ b/lib/ext2fs/rw_bitmaps.c
@@ -74,7 +74,7 @@ static errcode_t write_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 		    EXT2_BG_BLOCK_UNINIT)
 			goto skip_this_block_bitmap;
 
-		retval = ext2fs_get_block_bitmap_range(fs->block_map,
+		retval = ext2fs_get_block_bitmap_range2(fs->block_map,
 				blk_itr, block_nbytes << 3, block_buf);
 		if (retval)
 			return retval;
@@ -106,7 +106,7 @@ static errcode_t write_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 		    EXT2_BG_INODE_UNINIT)
 			goto skip_this_inode_bitmap;
 
-		retval = ext2fs_get_inode_bitmap_range(fs->inode_map,
+		retval = ext2fs_get_inode_bitmap_range2(fs->inode_map,
 				ino_itr, inode_nbytes << 3, inode_buf);
 		if (retval)
 			return retval;
@@ -202,7 +202,7 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 			cnt = fs->blocksize << 3;
 			if (cnt > ino_cnt)
 				cnt = ino_cnt;
-			retval = ext2fs_set_inode_bitmap_range(fs->inode_map,
+			retval = ext2fs_set_inode_bitmap_range2(fs->inode_map,
 					       ino_itr, cnt, inode_bitmap);
 			if (retval)
 				goto cleanup;
@@ -222,7 +222,7 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 			cnt = fs->blocksize << 3;
 			if (cnt > blk_cnt)
 				cnt = blk_cnt;
-			retval = ext2fs_set_block_bitmap_range(fs->block_map,
+			retval = ext2fs_set_block_bitmap_range2(fs->block_map,
 				       blk_itr, cnt, block_bitmap);
 			if (retval)
 				goto cleanup;
@@ -250,7 +250,7 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 			} else
 				memset(block_bitmap, 0xff, block_nbytes);
 			cnt = block_nbytes << 3;
-			retval = ext2fs_set_block_bitmap_range(fs->block_map,
+			retval = ext2fs_set_block_bitmap_range2(fs->block_map,
 					       blk_itr, cnt, block_bitmap);
 			if (retval)
 				goto cleanup;
@@ -272,7 +272,7 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 			} else
 				memset(inode_bitmap, 0xff, inode_nbytes);
 			cnt = inode_nbytes << 3;
-			retval = ext2fs_set_inode_bitmap_range(fs->inode_map,
+			retval = ext2fs_set_inode_bitmap_range2(fs->inode_map,
 					       ino_itr, cnt, inode_bitmap);
 			if (retval)
 				goto cleanup;
diff --git a/lib/ext2fs/tst_csum.c b/lib/ext2fs/tst_csum.c
index 7a91b19..0ffd92b 100644
--- a/lib/ext2fs/tst_csum.c
+++ b/lib/ext2fs/tst_csum.c
@@ -59,7 +59,7 @@ int main(int argc, char **argv)
 	memset(&param, 0, sizeof(param));
 	param.s_blocks_count = 32768;
 
-	retval = ext2fs_initialize("test fs", 0, &param,
+	retval = ext2fs_initialize("test fs", EXT2_FLAG_NEW_BITMAPS, &param,
 				   test_io_manager, &fs);
 	if (retval) {
 		com_err("setup", retval,
diff --git a/lib/ext2fs/tst_iscan.c b/lib/ext2fs/tst_iscan.c
index b0c7fc3..89d66db 100644
--- a/lib/ext2fs/tst_iscan.c
+++ b/lib/ext2fs/tst_iscan.c
@@ -28,14 +28,14 @@
 blk_t test_vec[] = { 8, 12, 24, 34, 43, 44, 100, 0 };
 
 ext2_filsys	test_fs;
-ext2fs_block_bitmap bad_block_map, touched_map;
-ext2fs_inode_bitmap bad_inode_map;
+ext2fs_block_bitmap64 bad_block_map, touched_map;
+ext2fs_inode_bitmap64 bad_inode_map;
 badblocks_list	test_badblocks;
 
 int first_no_comma = 1;
 int failed = 0;
 
-static void test_read_blk(unsigned long block, int count, errcode_t err)
+static void iscan_test_read_blk64(unsigned long long block, int count, errcode_t err)
 {
 	int	i;
 
@@ -45,20 +45,25 @@ static void test_read_blk(unsigned long block, int count, errcode_t err)
 		printf(", ");
 
 	if (count > 1)
-		printf("%lu-%lu", block, block+count-1);
+		printf("%llu-%llu", block, block+count-1);
 	else
-		printf("%lu", block);
+		printf("%llu", block);
 
 	for (i=0; i < count; i++, block++) {
-		if (ext2fs_test_block_bitmap(touched_map, block)) {
-			printf("\nDuplicate block?!? --- %lu\n", block);
+		if (ext2fs_test_block_bitmap2(touched_map, block)) {
+			printf("\nDuplicate block?!? --- %llu\n", block);
 			failed++;
 			first_no_comma = 1;
 		}
-		ext2fs_mark_block_bitmap(touched_map, block);
+		ext2fs_mark_block_bitmap2(touched_map, block);
 	}
 }
 
+static void iscan_test_read_blk(unsigned long block, int count, errcode_t err)
+{
+	iscan_test_read_blk64(block, count, err);
+}
+
 /*
  * Setup the variables for doing the inode scan test.
  */
@@ -71,12 +76,13 @@ static void setup(void)
 	initialize_ext2_error_table();
 
 	memset(&param, 0, sizeof(param));
-	param.s_blocks_count = 12000;
+	ext2fs_blocks_count_set(&param, 12000);
 
 
-	test_io_cb_read_blk = test_read_blk;
+	test_io_cb_read_blk = iscan_test_read_blk;
+	test_io_cb_read_blk64 = iscan_test_read_blk64;
 
-	retval = ext2fs_initialize("test fs", 0, &param,
+	retval = ext2fs_initialize("test fs", EXT2_FLAG_NEW_BITMAPS, &param,
 				   test_io_manager, &test_fs);
 	if (retval) {
 		com_err("setup", retval,
@@ -123,7 +129,7 @@ static void setup(void)
 				"while adding test vector %d", i);
 			exit(1);
 		}
-		ext2fs_mark_block_bitmap(bad_block_map, test_vec[i]);
+		ext2fs_mark_block_bitmap2(bad_block_map, test_vec[i]);
 	}
 	test_fs->badblocks = test_badblocks;
 }
@@ -152,7 +158,7 @@ static void iterate(void)
 	while (ino) {
 		retval = ext2fs_get_next_inode(scan, &ino, &inode);
 		if (retval == EXT2_ET_BAD_BLOCK_IN_INODE_TABLE) {
-			ext2fs_mark_inode_bitmap(bad_inode_map, ino);
+			ext2fs_mark_inode_bitmap2(bad_inode_map, ino);
 			continue;
 		}
 		if (retval) {
@@ -171,30 +177,30 @@ static void iterate(void)
 static void check_map(void)
 {
 	int	i, j, first=1;
-	unsigned long	blk;
+	blk64_t	blk;
 
 	for (i=0; test_vec[i]; i++) {
-		if (ext2fs_test_block_bitmap(touched_map, test_vec[i])) {
+		if (ext2fs_test_block_bitmap2(touched_map, test_vec[i])) {
 			printf("Bad block was touched --- %u\n", test_vec[i]);
 			failed++;
 			first_no_comma = 1;
 		}
-		ext2fs_mark_block_bitmap(touched_map, test_vec[i]);
+		ext2fs_mark_block_bitmap2(touched_map, test_vec[i]);
 	}
 	for (i = 0; i < test_fs->group_desc_count; i++) {
 		for (j=0, blk = test_fs->group_desc[i].bg_inode_table;
 		     j < test_fs->inode_blocks_per_group;
 		     j++, blk++) {
-			if (!ext2fs_test_block_bitmap(touched_map, blk) &&
-			    !ext2fs_test_block_bitmap(bad_block_map, blk)) {
-				printf("Missing block --- %lu\n", blk);
+			if (!ext2fs_test_block_bitmap2(touched_map, blk) &&
+			    !ext2fs_test_block_bitmap2(bad_block_map, blk)) {
+				printf("Missing block --- %llu\n", blk);
 				failed++;
 			}
 		}
 	}
 	printf("Bad inodes: ");
 	for (i=1; i <= test_fs->super->s_inodes_count; i++) {
-		if (ext2fs_test_inode_bitmap(bad_inode_map, i)) {
+		if (ext2fs_test_inode_bitmap2(bad_inode_map, i)) {
 			if (first)
 				first = 0;
 			else
-- 
1.5.6.5

