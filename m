From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH 4/4][e2fsprogs] New bitmap and inode table allocation for FLEX_BG
Date: Thu, 02 Aug 2007 23:01:05 -0500
Message-ID: <20070803040105.29456.1467.stgit@gara>
References: <20070803040041.29456.31454.stgit@gara>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:58391 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbXHCEDa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Aug 2007 00:03:30 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e32.co.us.ibm.com (8.12.11.20060308/8.13.8) with ESMTP id l732vEhi030327
	for <linux-ext4@vger.kernel.org>; Thu, 2 Aug 2007 22:57:14 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l7343TXd205392
	for <linux-ext4@vger.kernel.org>; Thu, 2 Aug 2007 22:03:29 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l7343Td4017172
	for <linux-ext4@vger.kernel.org>; Thu, 2 Aug 2007 22:03:29 -0600
Received: from austin.ibm.com (netmail2.austin.ibm.com [9.41.248.176])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l7343SAY017139
	for <linux-ext4@vger.kernel.org>; Thu, 2 Aug 2007 22:03:28 -0600
Received: from [127.0.1.1] (sig-9-65-28-26.mts.ibm.com [9.65.28.26])
	by austin.ibm.com (8.13.8/8.12.10) with ESMTP id l7343R25050786
	for <linux-ext4@vger.kernel.org>; Thu, 2 Aug 2007 23:03:28 -0500
In-Reply-To: <20070803040041.29456.31454.stgit@gara>
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

 lib/ext2fs/alloc_tables.c |  138 ++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 134 insertions(+), 4 deletions(-)

diff --git a/lib/ext2fs/alloc_tables.c b/lib/ext2fs/alloc_tables.c
index 4ad2ba9..75252fa 100644
--- a/lib/ext2fs/alloc_tables.c
+++ b/lib/ext2fs/alloc_tables.c
@@ -27,6 +27,130 @@
 #include "ext2_fs.h"
 #include "ext2fs.h"
 
+#define ALLOC_BLOCK_BITMAPS	1
+#define ALLOC_INODE_BITMAPS	2
+#define ALLOC_INODE_TABLES	3
+
+#define GROUPS_PER_FLEXBG	64
+#define FIRST_METADATA_GROUP	3
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
+		for (i=0, blk=new_blk; i < count; i++, blk++) {
+			retval = ext2fs_get_free_blocks(fs, start_blk, last_blk,
+							fs->inode_blocks_per_group,
+							bmap, &new_blk);
+			if (retval)
+				return retval;
+			for (j=0, blk = new_blk;
+			     j < fs->inode_blocks_per_group; j++, blk++)
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
+	int		gpm;
+
+	gpm = GROUPS_PER_FLEXBG;
+	blocks = 0;
+
+	for (i = 0; i < fs->group_desc_count; i=i+gpm) {
+		if (i == 0 )
+			start = ext2fs_group_first_block(fs,
+							 FIRST_METADATA_GROUP);
+		else
+			start = ext2fs_group_first_block(fs, i);
+
+		if (i+gpm-1 > fs->group_desc_count) {
+			last = ext2fs_group_last_block(fs, fs->group_desc_count);
+			gpm = fs->group_desc_count - i;
+		}
+		else
+			last = ext2fs_group_last_block(fs, i+gpm-1);
+
+		retval = ext2fs_allocate_contiguous(fs, i, ALLOC_BLOCK_BITMAPS,
+						    start, last, gpm,
+						    fs->block_map);
+		if (retval)
+			return retval;
+		retval = ext2fs_allocate_contiguous(fs, i, ALLOC_INODE_BITMAPS,
+						    start, last, gpm,
+						    fs->block_map);
+		if (retval)
+			return retval;
+		retval = ext2fs_allocate_contiguous(fs, i, ALLOC_INODE_TABLES,
+						    start, last, gpm,
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
+		for (k=i; k<i+gpm; k++){
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
@@ -107,10 +231,16 @@ errcode_t ext2fs_allocate_tables(ext2_filsys fs)
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
