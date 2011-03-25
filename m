From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH] ext4:Fix credits computing for indirect mapped files.
Date: Fri, 25 Mar 2011 21:10:05 +0800
Message-ID: <1301058605-29978-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40508 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab1CYNHW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Mar 2011 09:07:22 -0400
Received: by iwn34 with SMTP id 34so1041996iwn.19
        for <linux-ext4@vger.kernel.org>; Fri, 25 Mar 2011 06:07:22 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Either the first block or the last one could be not aligned with
block boundary, 1 block is needed to fix it.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/inode.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 67e7a3c..7193f23 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5380,11 +5380,11 @@ static int ext4_indirect_trans_blocks(struct inode *inode, int nrblocks,
 	if (chunk) {
 		/*
 		 * With N contiguous data blocks, it need at most
-		 * N/EXT4_ADDR_PER_BLOCK(inode->i_sb) indirect blocks
+		 * N/EXT4_ADDR_PER_BLOCK(inode->i_sb) + 1 indirect blocks
 		 * 2 dindirect blocks
 		 * 1 tindirect block
 		 */
-		indirects = nrblocks / EXT4_ADDR_PER_BLOCK(inode->i_sb);
+		indirects = nrblocks / EXT4_ADDR_PER_BLOCK(inode->i_sb) + 1;
 		return indirects + 3;
 	}
 	/*
-- 
1.7.4

