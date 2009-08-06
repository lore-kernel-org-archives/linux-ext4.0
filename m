From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V3 2/3] tune2fs: Handle fs meta-data blocks during inode resize
Date: Thu,  6 Aug 2009 11:42:30 +0530
Message-ID: <1249539151-3191-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1249539151-3191-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:33910 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbZHFGMo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Aug 2009 02:12:44 -0400
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.31.243])
	by e23smtp03.au.ibm.com (8.14.3/8.13.1) with ESMTP id n766ASZa007357
	for <linux-ext4@vger.kernel.org>; Thu, 6 Aug 2009 16:10:28 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n766CiLN381328
	for <linux-ext4@vger.kernel.org>; Thu, 6 Aug 2009 16:12:44 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n766ChIW007122
	for <linux-ext4@vger.kernel.org>; Thu, 6 Aug 2009 16:12:43 +1000
In-Reply-To: <1249539151-3191-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

With file system formated for RAID arrays we can have inode bitmap
and block bitmap after inode table. Make sure we move them around
properly when doing inode resize.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---

Changes from v2:
	o Set proper retval when we failed to get a mapping block in 
	  the same group. This make sure inode resize fails if we failed
	  to get a mapping fs meta data block in the same group.


 misc/tune2fs.c |   85 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 84 insertions(+), 1 deletions(-)

diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 08fff29..966738b 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -1003,10 +1003,39 @@ static int get_move_bitmaps(ext2_filsys fs, int new_ino_blks_per_grp,
 	return 0;
 }
 
+static int ext2fs_is_meta_block(ext2_filsys fs, blk_t blk)
+{
+	dgrp_t group;
+	group = ext2fs_group_of_blk(fs, blk);
+	if (fs->group_desc[group].bg_block_bitmap == blk)
+		return 1;
+	if (fs->group_desc[group].bg_inode_bitmap == blk)
+		return 1;
+	return 0;
+}
+
+static int ext2fs_is_block_in_group(ext2_filsys fs, dgrp_t group, blk_t blk)
+{
+	blk_t start_blk, end_blk;
+	start_blk = fs->super->s_first_data_block +
+			EXT2_BLOCKS_PER_GROUP(fs->super) * group;
+	/*
+	 * We cannot get new block beyond end_blk for for the last block group
+	 * so we can check with EXT2_BLOCKS_PER_GROUP even for last block group
+	 */
+	end_blk   = start_blk + EXT2_BLOCKS_PER_GROUP(fs->super);
+	if (blk >= start_blk && blk <= end_blk)
+		return 1;
+	return 0;
+}
+
 static int move_block(ext2_filsys fs, ext2fs_block_bitmap bmap)
 {
+
 	char *buf;
+	dgrp_t group;
 	errcode_t retval;
+	int meta_data = 0;
 	blk_t blk, new_blk, goal;
 	struct blk_move *bmv;
 
@@ -1019,11 +1048,31 @@ static int move_block(ext2_filsys fs, ext2fs_block_bitmap bmap)
 		if (!ext2fs_test_block_bitmap(bmap, blk))
 			continue;
 
-		goal = new_blk;
+		if (ext2fs_is_meta_block(fs, blk)) {
+			/*
+			 * If the block is mapping a fs meta data block
+			 * like group desc/block bitmap/inode bitmap. We
+			 * should find a block in the same group and fix
+			 * the respective fs metadata pointers. Otherwise
+			 * fail
+			 */
+			group = ext2fs_group_of_blk(fs, blk);
+			goal = ext2fs_group_first_block(fs, group);
+			meta_data = 1;
+
+		} else {
+			goal = new_blk;
+		}
 		retval = ext2fs_new_block(fs, goal, NULL, &new_blk);
 		if (retval)
 			goto err_out;
 
+		/* new fs meta data block should be in the same group */
+		if (meta_data && !ext2fs_is_block_in_group(fs, group, new_blk)) {
+			retval = ENOSPC;
+			goto err_out;
+		}
+
 		/* Mark this block as allocated */
 		ext2fs_mark_block_bitmap(fs->block_map, new_blk);
 
@@ -1158,6 +1207,36 @@ err_out:
 	return retval;
 }
 
+/*
+ * We need to scan for inode and block bitmaps that may need to be
+ * moved.  This can take place if the filesystem was formatted for
+ * RAID arrays using the mke2fs's extended option "stride".
+ */
+static int group_desc_scan_and_fix(ext2_filsys fs, ext2fs_block_bitmap bmap)
+{
+	dgrp_t i;
+	blk_t blk, new_blk;
+
+	for (i = 0; i < fs->group_desc_count; i++) {
+		blk = fs->group_desc[i].bg_block_bitmap;
+		if (ext2fs_test_block_bitmap(bmap, blk)) {
+			new_blk = translate_block(blk);
+			if (!new_blk)
+				continue;
+			fs->group_desc[i].bg_block_bitmap = new_blk;
+		}
+
+		blk = fs->group_desc[i].bg_inode_bitmap;
+		if (ext2fs_test_block_bitmap(bmap, blk)) {
+			new_blk = translate_block(blk);
+			if (!new_blk)
+				continue;
+			fs->group_desc[i].bg_inode_bitmap = new_blk;
+		}
+	}
+	return 0;
+}
+
 static int expand_inode_table(ext2_filsys fs, unsigned long new_ino_size)
 {
 	dgrp_t i;
@@ -1349,6 +1428,10 @@ static int resize_inode(ext2_filsys fs, unsigned long new_size)
 	if (retval)
 		goto err_out_undo;
 
+	retval = group_desc_scan_and_fix(fs, bmap);
+	if (retval)
+		goto err_out_undo;
+
 	retval = expand_inode_table(fs, new_size);
 	if (retval)
 		goto err_out_undo;
-- 
1.6.4.13.ge6580

