From: Coly Li <colyli@gmail.com>
Subject: [PATCH] __ext4_get_inode_loc: use s_inodes_per_block directly
Date: Tue, 25 Jan 2011 03:18:19 +0800
Message-ID: <1295896699-7314-1-git-send-email-bosong.ly@taobao.com>
Cc: Coly Li <bosong.ly@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:35639 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988Ab1AXSyY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Jan 2011 13:54:24 -0500
Received: by pva4 with SMTP id 4so728515pva.19
        for <linux-ext4@vger.kernel.org>; Mon, 24 Jan 2011 10:54:24 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Coly Li <bosong.ly@taobao.com>

In __ext4_get_inode_loc(), inodes_per_block is calculated by
(EXT4_BLOCK_SIZE(sb) / EXT4_INODE_SIZE(sb)). This is unncessary, the
value can be found directly from s_inodes_per_block.

Signed-off-by: Coly Li <bosong.ly@taobao.com>
---
 fs/ext4/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9f7f9e4..837c5a6 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4668,7 +4668,7 @@ static int __ext4_get_inode_loc(struct inode *inode,
 	/*
 	 * Figure out the offset within the block group inode table
 	 */
-	inodes_per_block = (EXT4_BLOCK_SIZE(sb) / EXT4_INODE_SIZE(sb));
+	inodes_per_block = EXT4_SB(sb)->s_inodes_per_block;
 	inode_offset = ((inode->i_ino - 1) %
 			EXT4_INODES_PER_GROUP(sb));
 	block = ext4_inode_table(sb, gdp) + (inode_offset / inodes_per_block);
-- 
1.7.3.2

