From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 1/4] ext4: use ext4_group_first_block_no()
Date: Sun, 17 Feb 2008 15:08:40 +0900
Message-ID: <20080217060839.GH3390@APFDCB5C>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Stephen Tweedie <sct@redhat.com>, adilger@clusterfs.com,
	Mingming Cao <cmm@us.ibm.com>, Theodore Tso <tytso@MIT.EDU>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:61990 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492AbYBQGO6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Feb 2008 01:14:58 -0500
Received: by wa-out-1112.google.com with SMTP id v27so2076914wah.23
        for <linux-ext4@vger.kernel.org>; Sat, 16 Feb 2008 22:14:58 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use ext4_group_first_block_no() and assign the return values to
ext2_fsblk_t variables.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Stephen Tweedie <sct@redhat.com>
Cc: adilger@clusterfs.com
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mingming Cao <cmm@us.ibm.com>
Cc: Theodore Tso <tytso@MIT.EDU>
---
 fs/ext4/balloc.c |    6 +++---
 fs/ext4/xattr.c  |    6 ++----
 2 files changed, 5 insertions(+), 7 deletions(-)

Index: 2.6-rc/fs/ext4/xattr.c
===================================================================
--- 2.6-rc.orig/fs/ext4/xattr.c
+++ 2.6-rc/fs/ext4/xattr.c
@@ -808,10 +808,8 @@ inserted:
 			get_bh(new_bh);
 		} else {
 			/* We need to allocate a new block */
-			ext4_fsblk_t goal = le32_to_cpu(
-					EXT4_SB(sb)->s_es->s_first_data_block) +
-				(ext4_fsblk_t)EXT4_I(inode)->i_block_group *
-				EXT4_BLOCKS_PER_GROUP(sb);
+			ext4_fsblk_t goal = ext4_group_first_block_no(sb,
+						EXT4_I(inode)->i_block_group);
 			ext4_fsblk_t block = ext4_new_block(handle, inode,
 							goal, &error);
 			if (error)
Index: 2.6-rc/fs/ext4/balloc.c
===================================================================
--- 2.6-rc.orig/fs/ext4/balloc.c
+++ 2.6-rc/fs/ext4/balloc.c
@@ -48,7 +48,6 @@ void ext4_get_group_no_and_offset(struct
 unsigned ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
 		 ext4_group_t block_group, struct ext4_group_desc *gdp)
 {
-	unsigned long start;
 	int bit, bit_max;
 	unsigned free_blocks, group_blocks;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
@@ -106,11 +105,12 @@ unsigned ext4_init_block_bitmap(struct s
 	free_blocks = group_blocks - bit_max;
 
 	if (bh) {
+		ext4_fsblk_t start;
+
 		for (bit = 0; bit < bit_max; bit++)
 			ext4_set_bit(bit, bh->b_data);
 
-		start = block_group * EXT4_BLOCKS_PER_GROUP(sb) +
-			le32_to_cpu(sbi->s_es->s_first_data_block);
+		start = ext4_group_first_block_no(sb, block_group);
 
 		/* Set bits for block and inode bitmaps, and inode table */
 		ext4_set_bit(ext4_block_bitmap(sb, gdp) - start, bh->b_data);
