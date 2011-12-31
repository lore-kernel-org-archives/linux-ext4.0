From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH] ext4: teach ext4_free_blocks to handle multi journalled data blocks
Date: Sat, 31 Dec 2011 09:35:39 +0800
Message-ID: <1325295339-6268-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45317 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab1LaFRK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 31 Dec 2011 00:17:10 -0500
Received: by iaeh11 with SMTP id h11so26286334iae.19
        for <linux-ext4@vger.kernel.org>; Fri, 30 Dec 2011 21:17:10 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch makes ext4_free_blocks work well with multi journaled data blocks.
Consider that journal mode of a file is changed from ordered mode to
jounral mode, then ext4_free_blocks() should record data blocks in revoke table.
ext4 with journal mode also needs ext4_free_blocks() to record data blocks
in revoke table.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/mballoc.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index cb990b2..46f5a24 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4562,19 +4562,17 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 	trace_ext4_free_blocks(inode, block, count, flags);
 
 	if (flags & EXT4_FREE_BLOCKS_FORGET) {
-		struct buffer_head *tbh = bh;
 		int i;
 
 		BUG_ON(bh && (count > 1));
 
 		for (i = 0; i < count; i++) {
 			if (!bh)
-				tbh = sb_find_get_block(inode->i_sb,
+				bh = sb_find_get_block(inode->i_sb,
 							block + i);
-			if (unlikely(!tbh))
-				continue;
 			ext4_forget(handle, flags & EXT4_FREE_BLOCKS_METADATA,
-				    inode, tbh, block + i);
+				    inode, bh, block + i);
+			bh = NULL;
 		}
 	}
 
-- 
1.7.5.1

