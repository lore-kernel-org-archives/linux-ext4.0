From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 3/5] ext4: let ext4_free_blocks handle multiblock correctly
Date: Tue, 15 Nov 2011 16:07:52 +0800
Message-ID: <1321344474-14707-3-git-send-email-xiaoqiangnk@gmail.com>
References: <1321344474-14707-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33075 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754831Ab1KOKcf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Nov 2011 05:32:35 -0500
Received: by mail-iy0-f174.google.com with SMTP id e36so8283497iag.19
        for <linux-ext4@vger.kernel.org>; Tue, 15 Nov 2011 02:32:35 -0800 (PST)
In-Reply-To: <1321344474-14707-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We should not pass buffer whiose block number is not block + i.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/mballoc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 2529efc..a64b3b8 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4572,6 +4572,7 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 							block + i);
 			ext4_forget(handle, flags & EXT4_FREE_BLOCKS_METADATA,
 				    inode, bh, block + i);
+			bh = NULL;
 		}
 	}
 
-- 
1.7.5.1

