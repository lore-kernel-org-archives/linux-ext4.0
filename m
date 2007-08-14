From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH 4/4][e2fsprogs] New bitmap and inode table allocation for FLEX_BG
Date: Mon, 13 Aug 2007 23:33:14 -0500
Message-ID: <20070814043314.32206.28698.stgit@gara>
References: <20070814043245.32206.34785.stgit@gara>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:45199 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935385AbXHNEdY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 14 Aug 2007 00:33:24 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l7E4YgDJ024863
	for <linux-ext4@vger.kernel.org>; Tue, 14 Aug 2007 00:34:42 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l7E4XN7r444048
	for <linux-ext4@vger.kernel.org>; Tue, 14 Aug 2007 00:33:23 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l7E4XN21003156
	for <linux-ext4@vger.kernel.org>; Tue, 14 Aug 2007 00:33:23 -0400
Received: from austin.ibm.com (netmail2.austin.ibm.com [9.41.248.176])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l7E4XMjH003150
	for <linux-ext4@vger.kernel.org>; Tue, 14 Aug 2007 00:33:22 -0400
Received: from [127.0.1.1] (sig-9-65-58-9.mts.ibm.com [9.65.58.9])
	by austin.ibm.com (8.13.8/8.12.10) with ESMTP id l7E4XMQg040306
	for <linux-ext4@vger.kernel.org>; Mon, 13 Aug 2007 23:33:22 -0500
In-Reply-To: <20070814043245.32206.34785.stgit@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Jose R. Santos <jrs@us.ibm.com>

New bitmap and inode table allocation for FLEX_BG

Change the way we allocate bitmaps and inode tables if the FLEX_BG
feature is used at mke2fs time.  The block and inode bitmaps are
allocated as a one contiguous set for each flex block group.  Due to
the size of the inode tables, the inode table for each block group is
allocate individually but packed close together at the beginning of a
flex group.  For now, this allow for the inode table to be packed
close to the inode bitmaps in cases where we try to allocate a large
group of inode tables right after the bitmaps and fail.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
--

 lib/ext2fs/alloc_tables.c |  132 ++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 128 insertions(+), 4 deletions(-)

diff --git a/lib/ext2fs/alloc_tables.c b/lib/ext2fs/alloc_tables.c
index 4ad2ba9..9740a2f 100644
--- a/lib/ext2fs/alloc_tables.c
+++ b/lib/ext2fs/alloc_tables.c
@@ -27,6 +27,124 @@
 #include "ext2_fs.h"
 #include "ext2fs.h"
 
+#define ALLOC_BLOCK_BITMAPS	1
+#define ALLOC_INODE_BITMAPS	2
+#define ALLOC_INODE_TABLES	3
+
+errcode_t ext2fs_allocate_contiguous(ext2_filsys fs, dgrp_t group,
+				     int type, blk_t start_blk, blk_t last_blk, 
+				     int count, ext2fs_block_bitmap bmap)
+{
+	errcode_t	retval;
+	blk_t		new_blk, blk;
+	int		i, j;
+
+	if (!bmap)
+		bmap = fs->block_map;
+
+	switch (type) {
+	case ALLOC_BLOCK_BITMAPS:
+		retval = ext2fs_get_free_blocks(fs, start_blk, last_blk,
+						1 * count, bmap, &new_blk);
+		if (retval)
+			return retval;
+		for (i=0, blk=new_blk; i < count; i++, blk++) {
+			ext2fs_mark_block_bitmap(bmap, blk);
+			fs->group_desc[group+i].bg_block_bitmap = blk;
+		}
+		break;
+
+	case ALLOC_INODE_BITMAPS:
+		retval = ext2fs_get_free_blocks(fs, start_blk, last_blk,
+						1 * count, bmap, &new_blk);
+		if (retval)
+			return retval;
+		for (i=0, blk=new_blk; i < count; i++, blk++) {
+			ext2fs_mark_block_bitmap(bmap, blk);
+			fs->group_desc[group+i].bg_inode_bitmap = blk;
+		}
+		break;
+
+	case ALLOC_INODE_TABLES:
+		for (i=0; i < count; i++) {
+			retval = ext2fs_get_free_blocks(fs, start_blk, last_blk,
+							fs->inode_blocks_per_group,
+							bmap, &new_blk);
+			if (retval)
+				return retval;
+			blk = new_blk;
+			for (j=0; j < fs->inode_blocks_per_group; j++, blk++)
+				ext2fs_mark_block_bitmap(bmap, blk);
+			fs->group_desc[group+i].bg_inode_table = new_blk;
+		}
+		break;
+
+	}
+	return 0;
+}
+
+
+
+errcode_t ext2fs_allocate_flex_groups(ext2_filsys fs)
+{
+	errcode_t	retval;
+	blk_t		start, last, j, blocks;
+	dgrp_t		i, k;
+	int		meta_bg_size;
+
+	meta_bg_size = (fs->blocksize / sizeof (struct ext2_group_desc));
+	blocks = 0;
+
+	for (i = 0; i < fs->group_desc_count; i=i+meta_bg_size) {
+		
+		start = ext2fs_group_first_block(fs, i);
+
+		if (i+meta_bg_size >= fs->group_desc_count) {
+			last = ext2fs_group_last_block(fs, fs->group_desc_count);
+			meta_bg_size = fs->group_desc_count - i;
+		}
+		else
+			last = ext2fs_group_last_block(fs, i+meta_bg_size-1);
+
+		retval = ext2fs_allocate_contiguous(fs, i, ALLOC_BLOCK_BITMAPS,
+						    start, last, meta_bg_size,
+						    fs->block_map);
+		if (retval)
+			return retval;
+		retval = ext2fs_allocate_contiguous(fs, i, ALLOC_INODE_BITMAPS,
+						    start, last, meta_bg_size,
+						    fs->block_map);
+		if (retval)
+			return retval;
+		retval = ext2fs_allocate_contiguous(fs, i, ALLOC_INODE_TABLES,
+						    start, last, meta_bg_size,
+						    fs->block_map);
+		if (retval)
+			return retval;
+
+		/*
+		 * The content of bg_free_blocks_count is previously
+		 * assigned with out knowledge of the new allocation
+		 * scheme.  Need to update the number of free blocks
+		 * per group descriptor or fsck will complain.
+		 */
+
+		for (k=i; k<i+meta_bg_size; k++){
+			if (k > fs->group_desc_count)
+				break;
+			start = ext2fs_group_first_block(fs, k);
+			last = ext2fs_group_last_block(fs, k);
+			for (j=start; j<=last; j++) {
+				if( !ext2fs_fast_test_block_bitmap(fs->block_map, j))
+					blocks++;
+			}
+				fs->group_desc[k].bg_free_blocks_count = blocks;
+			blocks = 0;
+		}
+	}
+	return 0;
+}
+
 errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 				      ext2fs_block_bitmap bmap)
 {
@@ -107,10 +225,16 @@ errcode_t ext2fs_allocate_tables(ext2_filsys fs)
 	errcode_t	retval;
 	dgrp_t		i;
 
-	for (i = 0; i < fs->group_desc_count; i++) {
-		retval = ext2fs_allocate_group_table(fs, i, fs->block_map);
-		if (retval)
-			return retval;
+	if (EXT2_HAS_INCOMPAT_FEATURE (fs->super, 
+				       EXT4_FEATURE_INCOMPAT_FLEX_BG)) 
+		ext2fs_allocate_flex_groups(fs);
+	
+	else {
+		for (i = 0; i < fs->group_desc_count; i++) {
+			retval = ext2fs_allocate_group_table(fs, i, fs->block_map);
+			if (retval)
+				return retval;
+		}
 	}
 	return 0;
 }
