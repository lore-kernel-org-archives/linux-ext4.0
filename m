From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 01/31] tune2fs: Don't convert block # to cluster # when
 clearing uninit_bg
Date: Mon, 30 Sep 2013 18:26:49 -0700
Message-ID: <20131001012649.28415.17225.stgit@birch.djwong.org>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37580 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755110Ab3JAB0x (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Sep 2013 21:26:53 -0400
In-Reply-To: <20131001012642.28415.89353.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we're constructing the initial block bitmap as part of removing the
gdt_csum (i.e. uninit_bg) feature, we mustn't convert the block numbers to
cluster numbers because ext2fs_mark_block_bitmap2() does this for us.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/tune2fs.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)


diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index ddf3259..52247e0 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -820,20 +820,17 @@ static void disable_uninit_bg(ext2_filsys fs, __u32 csum_feature_flag)
 	/* The bbitmap is zeroed; we must mark group metadata blocks in use */
 	for (i = 0; i < fs->group_desc_count; i++) {
 		b = ext2fs_block_bitmap_loc(fs, i);
-		ext2fs_mark_block_bitmap2(fs->block_map, EXT2FS_B2C(fs, b));
+		ext2fs_mark_block_bitmap2(fs->block_map, b);
 		b = ext2fs_inode_bitmap_loc(fs, i);
-		ext2fs_mark_block_bitmap2(fs->block_map, EXT2FS_B2C(fs, b));
+		ext2fs_mark_block_bitmap2(fs->block_map, b);
 
 		retval = ext2fs_super_and_bgd_loc2(fs, i, &b, &c, &d, NULL);
 		if (retval == 0 && b)
-			ext2fs_mark_block_bitmap2(fs->block_map,
-						  EXT2FS_B2C(fs, b));
+			ext2fs_mark_block_bitmap2(fs->block_map, b);
 		if (retval == 0 && c)
-			ext2fs_mark_block_bitmap2(fs->block_map,
-						  EXT2FS_B2C(fs, c));
+			ext2fs_mark_block_bitmap2(fs->block_map, c);
 		if (retval == 0 && d)
-			ext2fs_mark_block_bitmap2(fs->block_map,
-						  EXT2FS_B2C(fs, d));
+			ext2fs_mark_block_bitmap2(fs->block_map, d);
 		if (retval) {
 			com_err("disable_uninit_bg", retval,
 				"while initializing block bitmaps");

