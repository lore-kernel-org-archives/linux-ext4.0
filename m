From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [PATCH] mke2fs: Fix block bitmaps initalization with -O ^resize_inode
Date: Tue, 22 Oct 2013 16:39:38 +0900
Message-ID: <52662BBA.70503@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO200.gate.nec.co.jp ([202.32.8.215]:38172 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645Ab3JVHp7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Oct 2013 03:45:59 -0400
Received: from tyo202.gate.nec.co.jp ([10.7.69.202])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id r9M7jwIP013849
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 22 Oct 2013 16:45:58 +0900 (JST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If we create ext4 filesystem without resize_inode feature,
mke2fs command does not initialize block groups
which have backup superblock and/or group descriptor block
(With meta_bg feature, backup superblock and group descriptor block
are located separately).
So we have to fix block bitmaps when we run "e2fsck -b superblock device".
This patch fixes the issue by initializing block bitmaps correctly.

Steps to reproduce:
1. mke2fs -t ext4 -b 4096 -O ^resize_inode device
2. e2fsck -b 32768 DEV 
  <snip>
  Pass 1: Checking inodes, blocks, and sizes
  Pass 2: Checking directory structure
  Pass 3: Checking directory connectivity
  Pass 4: Checking reference counts
  Pass 5: Checking group summary information
  Block bitmap differences:  +(32768--32769) +(98304--98305) +(163840--163841)
  Fix<y>? 

Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
---
 lib/ext2fs/alloc_sb.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)
diff --git a/lib/ext2fs/alloc_sb.c b/lib/ext2fs/alloc_sb.c
index 223ec51..5419d0d 100644
--- a/lib/ext2fs/alloc_sb.c
+++ b/lib/ext2fs/alloc_sb.c
@@ -58,23 +58,25 @@ int ext2fs_reserve_super_and_bgd(ext2_filsys fs,
 		old_desc_blocks =
 			fs->desc_blocks + fs->super->s_reserved_gdt_blocks;
 
-	if (super_blk || (group == 0))
+	if (super_blk || (group == 0)) {
+		ext2fs_bg_flags_clear(fs, group, EXT2_BG_BLOCK_UNINIT);
 		ext2fs_mark_block_bitmap2(bmap, super_blk);
+	}
 	if ((group == 0) && (fs->blocksize == 1024) &&
 	    EXT2FS_CLUSTER_RATIO(fs) > 1)
 		ext2fs_mark_block_bitmap2(bmap, 0);
 
 	if (old_desc_blk) {
-		if (fs->super->s_reserved_gdt_blocks && fs->block_map == bmap)
-			ext2fs_bg_flags_clear(fs, group, EXT2_BG_BLOCK_UNINIT);
 		num_blocks = old_desc_blocks;
 		if (old_desc_blk + num_blocks >= ext2fs_blocks_count(fs->super))
 			num_blocks = ext2fs_blocks_count(fs->super) -
 				old_desc_blk;
 		ext2fs_mark_block_bitmap_range2(bmap, old_desc_blk, num_blocks);
 	}
-	if (new_desc_blk)
+	if (new_desc_blk) {
+		ext2fs_bg_flags_clear(fs, group, EXT2_BG_BLOCK_UNINIT);
 		ext2fs_mark_block_bitmap2(bmap, new_desc_blk);
+	}
 
 	num_blocks = ext2fs_group_blocks_count(fs, group);
 	num_blocks -= 2 + fs->inode_blocks_per_group + used_blks;

