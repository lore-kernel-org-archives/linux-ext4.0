From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] mke2fs: Fix block bitmaps initalization with -O
 ^resize_inode
Date: Mon, 25 Nov 2013 17:27:06 -0800
Message-ID: <20131126012706.GF10269@birch.djwong.org>
References: <52662BBA.70503@rs.jp.nec.com>
 <20131123013336.GD10269@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25935 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098Ab3KZB1R (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Nov 2013 20:27:17 -0500
Content-Disposition: inline
In-Reply-To: <20131123013336.GD10269@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Does the following patch fix your error?  I think I've started to hit it too,
now that I added ^resize_inode,^meta_bg to the mix.

--D

libext2fs: clear BLOCK_UNINIT any time a group has metadata blocks

If ext2fs_reserve_super_and_bgd() is called with the filesystem's
block bitmap, we clear the group's BLOCK_UNINIT flag if the group has
an old-style (pre-metabg) group descriptor block with reserved
descriptor blocks prior to marking the old-style descriptor blocks in
use.

Unfortunately, this is not sufficient -- if the group has no reserved
blocks yet isn't a meta_bg filesystem (^resize_inode,^meta_bg), we
forget to clear the flag, so the filesystem thinks all blocks are
free, which is disastrous.

Therefore, if we know that we're going to mark any of the bitmaps,
make sure that we clear BLOCK_UNINIT.

This is based on an earlier patch by Akira Fujita.

> Steps to reproduce:
> 1. mke2fs -t ext4 -b 4096 -O ^resize_inode device
> 2. e2fsck -b 32768 DEV 
>   <snip>
>   Pass 1: Checking inodes, blocks, and sizes
>   Pass 2: Checking directory structure
>   Pass 3: Checking directory connectivity
>   Pass 4: Checking reference counts
>   Pass 5: Checking group summary information
>   Block bitmap differences:  +(32768--32769) +(98304--98305) +(163840--163841)
>   Fix<y>? 

Reported-by: Akira Fujita <a-fujita@rs.jp.nec.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/alloc_sb.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/lib/ext2fs/alloc_sb.c b/lib/ext2fs/alloc_sb.c
index 223ec51..f1898df 100644
--- a/lib/ext2fs/alloc_sb.c
+++ b/lib/ext2fs/alloc_sb.c
@@ -52,6 +52,15 @@ int ext2fs_reserve_super_and_bgd(ext2_filsys fs,
 	ext2fs_super_and_bgd_loc2(fs, group, &super_blk,
 				  &old_desc_blk, &new_desc_blk, &used_blks);
 
+	/*
+	 * If we're marking blocks in the main block bitmap, be sure that we
+	 * clear the group's BLOCK_UNINIT flag if this group has metadata
+	 * blocks allocated.
+	 */
+	if (fs->block_map == bmap &&
+	    (new_desc_blk || old_desc_blk || super_blk || (group == 0)))
+		ext2fs_bg_flags_clear(fs, group, EXT2_BG_BLOCK_UNINIT);
+
 	if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG)
 		old_desc_blocks = fs->super->s_first_meta_bg;
 	else
@@ -65,8 +74,6 @@ int ext2fs_reserve_super_and_bgd(ext2_filsys fs,
 		ext2fs_mark_block_bitmap2(bmap, 0);
 
 	if (old_desc_blk) {
-		if (fs->super->s_reserved_gdt_blocks && fs->block_map == bmap)
-			ext2fs_bg_flags_clear(fs, group, EXT2_BG_BLOCK_UNINIT);
 		num_blocks = old_desc_blocks;
 		if (old_desc_blk + num_blocks >= ext2fs_blocks_count(fs->super))
 			num_blocks = ext2fs_blocks_count(fs->super) -
