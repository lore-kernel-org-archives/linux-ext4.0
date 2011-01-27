From: Coly Li <bosong.ly@taobao.com>
Subject: [PATCH] __ext4_get_inode_loc: use s_inodes_per_block directly
Date: Fri, 28 Jan 2011 00:33:06 +0800
Message-ID: <1296145986-4985-1-git-send-email-bosong.ly@taobao.com>
Cc: Coly Li <bosong.ly@taobao.com>, Theodore Tso <tytso@google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [114.243.227.164] ([114.243.227.164]:50901 "EHLO enigma.site"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751216Ab1A0QOo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 27 Jan 2011 11:14:44 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In __ext4_get_inode_loc(), inodes_per_block is calculated by
(EXT4_BLOCK_SIZE(sb) / EXT4_INODE_SIZE(sb)). This is unncessary, the
value can be found directly from s_inodes_per_block.

Signed-off-by: Coly Li <bosong.ly@taobao.com>
Cc: Theodore Tso <tytso@google.com>
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
1.7.3.4

