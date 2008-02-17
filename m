From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 3/4] ext3: use ext3_get_group_desc()
Date: Sun, 17 Feb 2008 15:05:24 +0900
Message-ID: <20080217060523.GF3390@APFDCB5C>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Stephen Tweedie <sct@redhat.com>, adilger@clusterfs.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:53590 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406AbYBQGLm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Feb 2008 01:11:42 -0500
Received: by wa-out-1112.google.com with SMTP id v27so2075881wah.23
        for <linux-ext4@vger.kernel.org>; Sat, 16 Feb 2008 22:11:42 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use ext3_get_group_desc()

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Stephen Tweedie <sct@redhat.com>
Cc: adilger@clusterfs.com
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 fs/ext3/inode.c |   23 +++++------------------
 1 file changed, 5 insertions(+), 18 deletions(-)

Index: 2.6-rc/fs/ext3/inode.c
===================================================================
--- 2.6-rc.orig/fs/ext3/inode.c
+++ 2.6-rc/fs/ext3/inode.c
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
-
-	gdp = (struct ext3_group_desc *)bh->b_data;
 	/*
 	 * Figure out the offset within the block group inode table
 	 */
 	offset = ((ino - 1) % EXT3_INODES_PER_GROUP(sb)) *
 		EXT3_INODE_SIZE(sb);
-	block = le32_to_cpu(gdp[desc].bg_inode_table) +
+	block = le32_to_cpu(gdp->bg_inode_table) +
 		(offset >> EXT3_BLOCK_SIZE_BITS(sb));
 
 	iloc->block_group = block_group;
