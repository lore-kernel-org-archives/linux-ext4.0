From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH] mke2fs: do not initialize block bitmaps of groups having super block
Date: Wed,  9 Nov 2011 18:53:26 +0800
Message-ID: <1320836006-6946-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53123 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab1KINIm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Nov 2011 08:08:42 -0500
Received: by iage36 with SMTP id e36so1701530iag.19
        for <linux-ext4@vger.kernel.org>; Wed, 09 Nov 2011 05:08:41 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Now mke2fs initializes block bitmaps of groups having super block, on
the other hand ext4_init_block_bitmap in kernel can handle this case
rightly.  So let mke2fs let block bitmaps of groups having super block
be uninitialized.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 lib/ext2fs/alloc_sb.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/lib/ext2fs/alloc_sb.c b/lib/ext2fs/alloc_sb.c
index 0d1c000..7517fbc 100644
--- a/lib/ext2fs/alloc_sb.c
+++ b/lib/ext2fs/alloc_sb.c
@@ -65,8 +65,6 @@ int ext2fs_reserve_super_and_bgd(ext2_filsys fs,
 		ext2fs_mark_block_bitmap2(bmap, 0);
 
 	if (old_desc_blk) {
-		if (fs->super->s_reserved_gdt_blocks && fs->block_map == bmap)
-			ext2fs_bg_flags_clear(fs, group, EXT2_BG_BLOCK_UNINIT);
 		for (j=0; j < old_desc_blocks; j++)
 			if (old_desc_blk + j < ext2fs_blocks_count(fs->super))
 				ext2fs_mark_block_bitmap2(bmap,
-- 
1.7.5.1

