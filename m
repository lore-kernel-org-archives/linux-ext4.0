From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 2/5] ext4: let ext4 journal deletion of data blocks
Date: Tue, 15 Nov 2011 16:07:51 +0800
Message-ID: <1321344474-14707-2-git-send-email-xiaoqiangnk@gmail.com>
References: <1321344474-14707-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33075 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574Ab1KOKcc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Nov 2011 05:32:32 -0500
Received: by iage36 with SMTP id e36so8283497iag.19
        for <linux-ext4@vger.kernel.org>; Tue, 15 Nov 2011 02:32:32 -0800 (PST)
In-Reply-To: <1321344474-14707-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch lets ext4 journal deletion of data blocks. Besides this,
a unnecessary variable is removed.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/mballoc.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index e2d8be8..2529efc 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4562,19 +4562,16 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
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
 		}
 	}
 
-- 
1.7.5.1

