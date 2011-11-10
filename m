From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH] e2fsprogs: fix "Illegal block number" for scan_block_bitmap()
Date: Thu, 10 Nov 2011 20:15:24 +0800
Message-ID: <1320927324-3613-1-git-send-email-hao.bigrat@gmail.com>
Cc: Robin Dong <sanbai@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:46246 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab1KJMPf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Nov 2011 07:15:35 -0500
Received: by qyk27 with SMTP id 27so5776908qyk.19
        for <linux-ext4@vger.kernel.org>; Thu, 10 Nov 2011 04:15:34 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

After:
# mke2fs -O ^has_journal,^resize_inode,^uninit_bg,extent,meta_bg,flex_bg,bigalloc /dev/sda
# e2freefrag /dev/sda

It will report error message like:

 Illegal block number passed to ext2fs_test_block_bitmap #1732133 for block bitmap for /dev/sda
 Illegal block number passed to ext2fs_test_block_bitmap #1732134 for block bitmap for /dev/sda
 Illegal block number passed to ext2fs_test_block_bitmap #1732135 for block bitmap for /dev/sda

One bit in bitmap of bigalloc-ext4 means a cluster not a block, therefore ext2fs_fast_test_block_bitmap2
should check cluster.

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 misc/e2freefrag.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/misc/e2freefrag.c b/misc/e2freefrag.c
index b442f32..a09df6b 100644
--- a/misc/e2freefrag.c
+++ b/misc/e2freefrag.c
@@ -121,7 +121,7 @@ void scan_block_bitmap(ext2_filsys fs, struct chunk_info *info)
 				chunk_start_blk = blk;
 			}
 			used = ext2fs_fast_test_block_bitmap2(fs->block_map,
-							     chunk_start_blk);
+				chunk_start_blk >> fs->cluster_ratio_bits);
 			if (!used) {
 				last_chunk_size++;
 				chunk_free++;
-- 
1.7.3.2

