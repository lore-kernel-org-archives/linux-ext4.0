From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 4/6] resize2fs: handle bg descriptors which overlap with other bg's metadata
Date: Sat, 29 Dec 2012 03:55:26 -0500
Message-ID: <1356771328-18196-5-git-send-email-tytso@mit.edu>
References: <1356771328-18196-1-git-send-email-tytso@mit.edu>
Cc: George Spelvin <linux@horizon.com>, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40802 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752441Ab2L2Izf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 29 Dec 2012 03:55:35 -0500
In-Reply-To: <1356771328-18196-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

With flex_bg file systems, bg-specific metadata (i.e., bitmaps and the
inode table blocks) can be located in another block group.  Hence,
when we grow the number of block group descriptors, we need to check
if we need to relocate metadata blocks not just for the block group
where the bgd blocks are located, but in all block groups.

This change fixes the following test case:

rm -f foo.img; touch foo.img
truncate -s 32G foo.img
mke2fs -F -t ext4 -E resize=12582912 foo.img
e2fsck -f foo.img
truncate -s 256G foo.img
./resize2fs foo.img
e2fsck -fy foo.img

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 resize/resize2fs.c | 35 +++++++++++++++++++++++++++++++----
 1 file changed, 31 insertions(+), 4 deletions(-)

diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 9702645..159846d 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -745,14 +745,41 @@ static void mark_fs_metablock(ext2_resize_t rfs,
 	if (IS_BLOCK_BM(fs, group, blk)) {
 		ext2fs_block_bitmap_loc_set(fs, group, 0);
 		rfs->needed_blocks++;
-	} else if (IS_INODE_BM(fs, group, blk)) {
+		return;
+	}
+	if (IS_INODE_BM(fs, group, blk)) {
 		ext2fs_inode_bitmap_loc_set(fs, group, 0);
 		rfs->needed_blocks++;
-	} else if (IS_INODE_TB(fs, group, blk)) {
+		return;
+	}
+	if (IS_INODE_TB(fs, group, blk)) {
 		ext2fs_inode_table_loc_set(fs, group, 0);
 		rfs->needed_blocks++;
-	} else if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					      EXT4_FEATURE_RO_COMPAT_GDT_CSUM) &&
+		return;
+	}
+	if (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_FLEX_BG) {
+		dgrp_t i;
+
+		for (i=0; i < rfs->old_fs->group_desc_count; i++) {
+			if (IS_BLOCK_BM(fs, i, blk)) {
+				ext2fs_block_bitmap_loc_set(fs, i, 0);
+				rfs->needed_blocks++;
+				return;
+			}
+			if (IS_INODE_BM(fs, i, blk)) {
+				ext2fs_inode_bitmap_loc_set(fs, i, 0);
+				rfs->needed_blocks++;
+				return;
+			}
+			if (IS_INODE_TB(fs, i, blk)) {
+				ext2fs_inode_table_loc_set(fs, i, 0);
+				rfs->needed_blocks++;
+				return;
+			}
+		}
+	}
+	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+				       EXT4_FEATURE_RO_COMPAT_GDT_CSUM) &&
 		   (ext2fs_bg_flags_test(fs, group, EXT2_BG_BLOCK_UNINIT))) {
 		/*
 		 * If the block bitmap is uninitialized, which means
-- 
1.7.12.rc0.22.gcdd159b

