From: hao.bigrat@gmail.com
Subject: [PATCH 3/3] libext2fs: pick out UNINIT-EXTENT block
Date: Sun, 30 Jan 2011 14:28:34 +0800
Message-ID: <1296368914-14079-1-git-send-email-hao.bigrat@gmail.com>
Cc: Robin Dong <sanbai@taobao.com>, Andreas Dilger <adilger@dilger.ca>,
	Theodore Tso <tytso@google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38265 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab1A3G2q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 30 Jan 2011 01:28:46 -0500
Received: by mail-iy0-f174.google.com with SMTP id 18so3863212iyj.19
        for <linux-ext4@vger.kernel.org>; Sat, 29 Jan 2011 22:28:46 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

for display UNINIT-EXTENT block usage in dumpe2fs, modify 
ext2fs_block_iterate3 to distinguish between uninitial extent
block and normal extent block

Signed-off-by: Robing Dong <sanbai@taobao.com>
---
 lib/ext2fs/block.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/ext2fs/block.c b/lib/ext2fs/block.c
index 0e4ec77..c7a60da 100644
--- a/lib/ext2fs/block.c
+++ b/lib/ext2fs/block.c
@@ -458,7 +458,7 @@ errcode_t ext2fs_block_iterate3(ext2_filsys fs,
 			     blk++, blockcnt++, j++) {
 				new_blk = blk;
 				r = (*ctx.func)(fs, &new_blk, blockcnt,
-						0, 0, priv_data);
+						extent.e_flags, 0, priv_data);
 				ret |= r;
 				check_for_ro_violation_goto(&ctx, ret,
 							    extent_errout);
-- 
1.7.3.5

