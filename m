From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 24/74] dumpe2fs: check return values
Date: Tue, 10 Dec 2013 17:20:59 -0800
Message-ID: <20131211012059.30655.24946.stgit@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42740 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706Ab3LKBVI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 20:21:08 -0500
In-Reply-To: <20131211011813.30655.39624.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Check the return values from ext2fs_get_block_bitmap_range2(); if an
error happened, print that and don't print garbage bitmap.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/dumpe2fs.c |   26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)


diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
index 8be7ce2..3dbfcb9 100644
--- a/misc/dumpe2fs.c
+++ b/misc/dumpe2fs.c
@@ -162,6 +162,7 @@ static void list_desc (ext2_filsys fs)
 	int has_super;
 	blk64_t		blk_itr = EXT2FS_B2C(fs, fs->super->s_first_data_block);
 	ext2_ino_t	ino_itr = 1;
+	errcode_t	retval;
 
 	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
 				       EXT4_FEATURE_RO_COMPAT_BIGALLOC))
@@ -264,21 +265,30 @@ static void list_desc (ext2_filsys fs)
 				ext2fs_bg_itable_unused(fs, i));
 		if (block_bitmap) {
 			fputs(_("  Free blocks: "), stdout);
-			ext2fs_get_block_bitmap_range2(fs->block_map,
+			retval = ext2fs_get_block_bitmap_range2(fs->block_map,
 				 blk_itr, block_nbytes << 3, block_bitmap);
-			print_free(i, block_bitmap,
-				   fs->super->s_clusters_per_group,
-				   fs->super->s_first_data_block,
-				   EXT2FS_CLUSTER_RATIO(fs));
+			if (retval)
+				com_err("list_desc", retval,
+					"while reading block bitmap");
+			else
+				print_free(i, block_bitmap,
+					   fs->super->s_clusters_per_group,
+					   fs->super->s_first_data_block,
+					   EXT2FS_CLUSTER_RATIO(fs));
 			fputc('\n', stdout);
 			blk_itr += fs->super->s_clusters_per_group;
 		}
 		if (inode_bitmap) {
 			fputs(_("  Free inodes: "), stdout);
-			ext2fs_get_inode_bitmap_range2(fs->inode_map,
+			retval = ext2fs_get_inode_bitmap_range2(fs->inode_map,
 				 ino_itr, inode_nbytes << 3, inode_bitmap);
-			print_free(i, inode_bitmap,
-				   fs->super->s_inodes_per_group, 1, 1);
+			if (retval)
+				com_err("list_desc", retval,
+					"while reading inode bitmap");
+			else
+				print_free(i, inode_bitmap,
+					   fs->super->s_inodes_per_group,
+					   1, 1);
 			fputc('\n', stdout);
 			ino_itr += fs->super->s_inodes_per_group;
 		}

