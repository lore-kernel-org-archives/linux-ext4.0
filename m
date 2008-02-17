From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 3/4] ext4: use ext4_get_group_desc()
Date: Sun, 17 Feb 2008 15:13:53 +0900
Message-ID: <20080217061352.GJ3390@APFDCB5C>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Stephen Tweedie <sct@redhat.com>, adilger@clusterfs.com,
	Mingming Cao <cmm@us.ibm.com>, Theodore Tso <tytso@MIT.EDU>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.176]:10872 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbYBQGUM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Feb 2008 01:20:12 -0500
Received: by wa-out-1112.google.com with SMTP id v27so2078588wah.23
        for <linux-ext4@vger.kernel.org>; Sat, 16 Feb 2008 22:20:11 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use ext4_get_group_desc()

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Stephen Tweedie <sct@redhat.com>
Cc: adilger@clusterfs.com
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mingming Cao <cmm@us.ibm.com>
Cc: Theodore Tso <tytso@MIT.EDU>
---
 fs/ext4/inode.c |   20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

Index: 2.6-rc/fs/ext4/inode.c
===================================================================
--- 2.6-rc.orig/fs/ext4/inode.c
+++ 2.6-rc/fs/ext4/inode.c
@@ -2455,12 +2455,10 @@ out_stop:
 static ext4_fsblk_t ext4_get_inode_block(struct super_block *sb,
 		unsigned long ino, struct ext4_iloc *iloc)
 {
-	unsigned long desc, group_desc;
 	ext4_group_t block_group;
 	unsigned long offset;
 	ext4_fsblk_t block;
-	struct buffer_head *bh;
-	struct ext4_group_desc * gdp;
+	struct ext4_group_desc *gdp;
 
 	if (!ext4_valid_inum(sb, ino)) {
 		/*
@@ -2472,22 +2470,10 @@ static ext4_fsblk_t ext4_get_inode_block
 	}
 
 	block_group = (ino - 1) / EXT4_INODES_PER_GROUP(sb);
-	if (block_group >= EXT4_SB(sb)->s_groups_count) {
-		ext4_error(sb,"ext4_get_inode_block","group >= groups count");
+	gdp = ext4_get_group_desc(sb, block_group, NULL);
+	if (!gdp)
 		return 0;
-	}
-	smp_rmb();
-	group_desc = block_group >> EXT4_DESC_PER_BLOCK_BITS(sb);
-	desc = block_group & (EXT4_DESC_PER_BLOCK(sb) - 1);
-	bh = EXT4_SB(sb)->s_group_desc[group_desc];
-	if (!bh) {
-		ext4_error (sb, "ext4_get_inode_block",
-			    "Descriptor not loaded");
-		return 0;
-	}
 
-	gdp = (struct ext4_group_desc *)((__u8 *)bh->b_data +
-		desc * EXT4_DESC_SIZE(sb));
 	/*
 	 * Figure out the offset within the block group inode table
 	 */
