From: "Akira Fujita" <a-fujita@rs.jp.nec.com>
Subject: RE: [PATCH] mke2fs: Fix block bitmaps initalization with -O ^resize_inode
Date: Fri, 22 Nov 2013 17:03:56 +0900
Message-ID: <001c01cee759$64b67db0$2e237910$@rs.jp.nec.com>
References: <52662BBA.70503@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "'Theodore Tso'" <tytso@mit.edu>,
	"'ext4 development'" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO200.gate.nec.co.jp ([202.32.8.215]:42779 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab3KVIKR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Nov 2013 03:10:17 -0500
Received: from tyo202.gate.nec.co.jp ([10.7.69.202])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id rAM8AGCJ004070
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 22 Nov 2013 17:10:16 +0900 (JST)
In-Reply-To: <52662BBA.70503@rs.jp.nec.com>
Content-Language: ja
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

Could you review this patch?

Best,
Akira Fujita

>-----Original Message-----
>From: linux-ext4-owner@vger.kernel.org [mailto:linux-ext4-owner@vger.kernel.org] On Behalf Of
>Akira Fujita
>Sent: Tuesday, October 22, 2013 4:40 PM
>To: Theodore Tso; ext4 development
>Subject: [PATCH] mke2fs: Fix block bitmaps initalization with -O ^resize_inode
>
>If we create ext4 filesystem without resize_inode feature, mke2fs command does not initialize
block
>groups which have backup superblock and/or group descriptor block (With meta_bg feature,
backup
>superblock and group descriptor block are located separately).
>So we have to fix block bitmaps when we run "e2fsck -b superblock device".
>This patch fixes the issue by initializing block bitmaps correctly.
>
>Steps to reproduce:
>1. mke2fs -t ext4 -b 4096 -O ^resize_inode device 2. e2fsck -b 32768 DEV
>  <snip>
>  Pass 1: Checking inodes, blocks, and sizes
>  Pass 2: Checking directory structure
>  Pass 3: Checking directory connectivity
>  Pass 4: Checking reference counts
>  Pass 5: Checking group summary information
>  Block bitmap differences:  +(32768--32769) +(98304--98305) +(163840--163841)
>  Fix<y>?
>
>Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
>---
> lib/ext2fs/alloc_sb.c |   10 ++++++----
> 1 file changed, 6 insertions(+), 4 deletions(-) diff --git a/lib/ext2fs/alloc_sb.c
>b/lib/ext2fs/alloc_sb.c index 223ec51..5419d0d 100644
>--- a/lib/ext2fs/alloc_sb.c
>+++ b/lib/ext2fs/alloc_sb.c
>@@ -58,23 +58,25 @@ int ext2fs_reserve_super_and_bgd(ext2_filsys fs,
> 		old_desc_blocks =
> 			fs->desc_blocks + fs->super->s_reserved_gdt_blocks;
>
>-	if (super_blk || (group == 0))
>+	if (super_blk || (group == 0)) {
>+		ext2fs_bg_flags_clear(fs, group, EXT2_BG_BLOCK_UNINIT);
> 		ext2fs_mark_block_bitmap2(bmap, super_blk);
>+	}
> 	if ((group == 0) && (fs->blocksize == 1024) &&
> 	    EXT2FS_CLUSTER_RATIO(fs) > 1)
> 		ext2fs_mark_block_bitmap2(bmap, 0);
>
> 	if (old_desc_blk) {
>-		if (fs->super->s_reserved_gdt_blocks && fs->block_map == bmap)
>-			ext2fs_bg_flags_clear(fs, group, EXT2_BG_BLOCK_UNINIT);
> 		num_blocks = old_desc_blocks;
> 		if (old_desc_blk + num_blocks >= ext2fs_blocks_count(fs->super))
> 			num_blocks = ext2fs_blocks_count(fs->super) -
> 				old_desc_blk;
> 		ext2fs_mark_block_bitmap_range2(bmap, old_desc_blk, num_blocks);
> 	}
>-	if (new_desc_blk)
>+	if (new_desc_blk) {
>+		ext2fs_bg_flags_clear(fs, group, EXT2_BG_BLOCK_UNINIT);
> 		ext2fs_mark_block_bitmap2(bmap, new_desc_blk);
>+	}
>
> 	num_blocks = ext2fs_group_blocks_count(fs, group);
> 	num_blocks -= 2 + fs->inode_blocks_per_group + used_blks;
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-ext4" in the body of a message
to
>majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html

