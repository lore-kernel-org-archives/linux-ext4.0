From: akpm@linux-foundation.org
Subject: [patch 272/307] ext3: use ext3_get_group_desc()
Date: Mon, 28 Apr 2008 02:16:08 -0700
Message-ID: <200804280916.m3S9G8e0019141@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, akinobu.mita@gmail.com,
	linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51717 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761255AbYD1JU5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Apr 2008 05:20:57 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Akinobu Mita <akinobu.mita@gmail.com>

Use ext3_get_group_desc()

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/inode.c |   23 +++++------------------
 1 file changed, 5 insertions(+), 18 deletions(-)

diff -puN fs/ext3/inode.c~ext3-use-ext3_get_group_desc fs/ext3/inode.c
--- a/fs/ext3/inode.c~ext3-use-ext3_get_group_desc
+++ a/fs/ext3/inode.c
@@ -2454,11 +2454,10 @@ out_stop:
 static ext3_fsblk_t ext3_get_inode_block(struct super_block *sb,
 		unsigned long ino, struct ext3_iloc *iloc)
 {
-	unsigned long desc, group_desc, block_group;
+	unsigned long block_group;
 	unsigned long offset;
 	ext3_fsblk_t block;
-	struct buffer_head *bh;
-	struct ext3_group_desc * gdp;
+	struct ext3_group_desc *gdp;
 
 	if (!ext3_valid_inum(sb, ino)) {
 		/*
@@ -2470,27 +2469,15 @@ static ext3_fsblk_t ext3_get_inode_block
 	}
 
 	block_group = (ino - 1) / EXT3_INODES_PER_GROUP(sb);
-	if (block_group >= EXT3_SB(sb)->s_groups_count) {
-		ext3_error(sb,"ext3_get_inode_block","group >= groups count");
-		return 0;
-	}
-	smp_rmb();
-	group_desc = block_group >> EXT3_DESC_PER_BLOCK_BITS(sb);
-	desc = block_group & (EXT3_DESC_PER_BLOCK(sb) - 1);
-	bh = EXT3_SB(sb)->s_group_desc[group_desc];
-	if (!bh) {
-		ext3_error (sb, "ext3_get_inode_block",
-			    "Descriptor not loaded");
+	gdp = ext3_get_group_desc(sb, block_group, NULL);
+	if (!gdp)
 		return 0;
-	}
