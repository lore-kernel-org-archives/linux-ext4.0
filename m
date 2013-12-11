From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 53/74] resize2fs: when toggling 64bit,
 don't free in-use bg data clusters
Date: Tue, 10 Dec 2013 17:24:12 -0800
Message-ID: <20131211012412.30655.91746.stgit@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43597 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706Ab3LKBYT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 20:24:19 -0500
In-Reply-To: <20131211011813.30655.39624.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently, move_bg_metadata() assumes that if a block containing a
superblock or a group descriptor is no longer needed, then it is safe
to free the whole cluster.  This of course isn't true, for bitmaps and
inode tables can share these clusters.  Therefore, check a little more
carefully before freeing clusters.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 resize/resize2fs.c |   71 ++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 55 insertions(+), 16 deletions(-)


diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 3ee8ee4..e95179d 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -307,11 +307,11 @@ static errcode_t resize_group_descriptors(ext2_resize_t rfs, blk64_t new_size)
 static errcode_t move_bg_metadata(ext2_resize_t rfs)
 {
 	dgrp_t i;
-	blk64_t b, c, d;
+	blk64_t b, c, d, old_desc_blocks, new_desc_blocks, j;
 	ext2fs_block_bitmap old_map, new_map;
 	int old, new;
 	errcode_t retval;
-	int zero = 0, one = 1;
+	int zero = 0, one = 1, cluster_ratio;
 
 	if (!(rfs->flags & (RESIZE_DISABLE_64BIT | RESIZE_ENABLE_64BIT)))
 		return 0;
@@ -324,6 +324,17 @@ static errcode_t move_bg_metadata(ext2_resize_t rfs)
 	if (retval)
 		goto out;
 
+	if (EXT2_HAS_INCOMPAT_FEATURE(rfs->old_fs->super,
+				      EXT2_FEATURE_INCOMPAT_META_BG)) {
+		old_desc_blocks = rfs->old_fs->super->s_first_meta_bg;
+		new_desc_blocks = rfs->new_fs->super->s_first_meta_bg;
+	} else {
+		old_desc_blocks = rfs->old_fs->desc_blocks +
+				rfs->old_fs->super->s_reserved_gdt_blocks;
+		new_desc_blocks = rfs->new_fs->desc_blocks +
+				rfs->new_fs->super->s_reserved_gdt_blocks;
+	}
+
 	/* Construct bitmaps of super/descriptor blocks in old and new fs */
 	for (i = 0; i < rfs->old_fs->group_desc_count; i++) {
 		retval = ext2fs_super_and_bgd_loc2(rfs->old_fs, i, &b, &c, &d,
@@ -331,7 +342,8 @@ static errcode_t move_bg_metadata(ext2_resize_t rfs)
 		if (retval)
 			goto out;
 		ext2fs_mark_block_bitmap2(old_map, b);
-		ext2fs_mark_block_bitmap2(old_map, c);
+		for (j = 0; c != 0 && j < old_desc_blocks; j++)
+			ext2fs_mark_block_bitmap2(old_map, c + j);
 		ext2fs_mark_block_bitmap2(old_map, d);
 
 		retval = ext2fs_super_and_bgd_loc2(rfs->new_fs, i, &b, &c, &d,
@@ -339,45 +351,72 @@ static errcode_t move_bg_metadata(ext2_resize_t rfs)
 		if (retval)
 			goto out;
 		ext2fs_mark_block_bitmap2(new_map, b);
-		ext2fs_mark_block_bitmap2(new_map, c);
+		for (j = 0; c != 0 && j < new_desc_blocks; j++)
+			ext2fs_mark_block_bitmap2(new_map, c + j);
 		ext2fs_mark_block_bitmap2(new_map, d);
 	}
 
+	cluster_ratio = EXT2FS_CLUSTER_RATIO(rfs->new_fs);
+
 	/* Find changes in block allocations for bg metadata */
 	for (b = 0;
 	     b < ext2fs_blocks_count(rfs->new_fs->super);
-	     b += EXT2FS_CLUSTER_RATIO(rfs->new_fs)) {
+	     b += cluster_ratio) {
 		old = ext2fs_test_block_bitmap2(old_map, b);
 		new = ext2fs_test_block_bitmap2(new_map, b);
 
-		if (old && !new)
-			ext2fs_unmark_block_bitmap2(rfs->new_fs->block_map, b);
-		else if (!old && new)
-			; /* empty ext2fs_mark_block_bitmap2(new_map, b); */
-		else
+		if (old && !new) {
+			/* mark old_map, unmark new_map */
+			if (cluster_ratio == 1)
+				ext2fs_unmark_block_bitmap2(
+						rfs->new_fs->block_map, b);
+		} else if (!old && new)
+			; /* unmark old_map, mark new_map */
+		else {
+			ext2fs_unmark_block_bitmap2(old_map, b);
 			ext2fs_unmark_block_bitmap2(new_map, b);
+		}
 	}
-	/* new_map now shows blocks that have been newly allocated. */
 
-	/* Move any conflicting bitmaps and inode tables */
+	/*
+	 * new_map now shows blocks that have been newly allocated.
+	 * old_map now shows blocks that have been newly freed.
+	 */
+
+	/*
+	 * Move any conflicting bitmaps and inode tables.  Ensure that we
+	 * don't try to free clusters associated with bitmaps or tables.
+	 */
 	for (i = 0; i < rfs->old_fs->group_desc_count; i++) {
 		b = ext2fs_block_bitmap_loc(rfs->new_fs, i);
 		if (ext2fs_test_block_bitmap2(new_map, b))
 			ext2fs_block_bitmap_loc_set(rfs->new_fs, i, 0);
+		else if (ext2fs_test_block_bitmap2(old_map, b))
+			ext2fs_unmark_block_bitmap2(old_map, b);
 
 		b = ext2fs_inode_bitmap_loc(rfs->new_fs, i);
 		if (ext2fs_test_block_bitmap2(new_map, b))
 			ext2fs_inode_bitmap_loc_set(rfs->new_fs, i, 0);
+		else if (ext2fs_test_block_bitmap2(old_map, b))
+			ext2fs_unmark_block_bitmap2(old_map, b);
 
 		c = ext2fs_inode_table_loc(rfs->new_fs, i);
-		for (b = 0; b < rfs->new_fs->inode_blocks_per_group; b++) {
-			if (ext2fs_test_block_bitmap2(new_map, b + c)) {
+		for (b = 0;
+		     b < rfs->new_fs->inode_blocks_per_group;
+		     b++) {
+			if (ext2fs_test_block_bitmap2(new_map, b + c))
 				ext2fs_inode_table_loc_set(rfs->new_fs, i, 0);
-				break;
-			}
+			else if (ext2fs_test_block_bitmap2(old_map, b + c))
+				ext2fs_unmark_block_bitmap2(old_map, b + c);
 		}
 	}
 
+	/* Free unused clusters */
+	for (b = 0;
+	     cluster_ratio > 1 && b < ext2fs_blocks_count(rfs->new_fs->super);
+	     b += cluster_ratio)
+		if (ext2fs_test_block_bitmap2(old_map, b))
+			ext2fs_unmark_block_bitmap2(rfs->new_fs->block_map, b);
 out:
 	if (old_map)
 		ext2fs_free_block_bitmap(old_map);

