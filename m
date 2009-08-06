From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V3 3/3] tune2fs: handle bad blocks when resizing inodes
Date: Thu,  6 Aug 2009 11:42:31 +0530
Message-ID: <1249539151-3191-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1249539151-3191-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:35271 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbZHFGMs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Aug 2009 02:12:48 -0400
Received: from d23relay02.au.ibm.com (d23relay02.au.ibm.com [202.81.31.244])
	by e23smtp09.au.ibm.com (8.14.3/8.13.1) with ESMTP id n766C3i1009440
	for <linux-ext4@vger.kernel.org>; Thu, 6 Aug 2009 16:12:03 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay02.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n766Cmdj1323242
	for <linux-ext4@vger.kernel.org>; Thu, 6 Aug 2009 16:12:48 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n766Cmml007241
	for <linux-ext4@vger.kernel.org>; Thu, 6 Aug 2009 16:12:48 +1000
In-Reply-To: <1249539151-3191-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When increasing inode size if we find that the new block
that we needed to increase the inode table size is a bad
block we fail. This make sure we don't end up with a corrupt
file system when doing inode resize on a file system having
bad blocks.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 misc/tune2fs.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 966738b..546dab9 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -969,9 +969,15 @@ static int get_move_bitmaps(ext2_filsys fs, int new_ino_blks_per_grp,
 			ext2fs_block_bitmap bmap)
 {
 	dgrp_t i;
+	int retval;
+	ext2_badblocks_list bb_list = 0;
 	blk_t j, needed_blocks = 0;
 	blk_t start_blk, end_blk;
 
+	retval = ext2fs_read_bb_inode(fs, &bb_list);
+        if (retval)
+                return retval;
+
 	for (i = 0; i < fs->group_desc_count; i++) {
 		start_blk = fs->group_desc[i].bg_inode_table +
 					fs->inode_blocks_per_group;
@@ -981,10 +987,14 @@ static int get_move_bitmaps(ext2_filsys fs, int new_ino_blks_per_grp,
 
 		for (j = start_blk; j < end_blk; j++) {
 			if (ext2fs_test_block_bitmap(fs->block_map, j)) {
-				/* FIXME!!
-				 * What happens if the block is marked
-				 * as a bad block
+				/*
+				 * IF the block is a bad block we fail
 				 */
+				if (ext2fs_badblocks_list_test(bb_list, j)) {
+					ext2fs_badblocks_list_free(bb_list);
+					return ENOSPC;
+				}
+
 				ext2fs_mark_block_bitmap(bmap, j);
 			} else {
 				/*
@@ -997,6 +1007,7 @@ static int get_move_bitmaps(ext2_filsys fs, int new_ino_blks_per_grp,
 		needed_blocks += end_blk - start_blk;
 	}
 
+	ext2fs_badblocks_list_free(bb_list);
 	if (needed_blocks > fs->super->s_free_blocks_count)
 		return ENOSPC;
 
-- 
1.6.4.13.ge6580

