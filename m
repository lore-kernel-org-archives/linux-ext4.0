From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Fix uninit block group initialization with FLEX_BG
Date: Thu, 15 May 2008 22:59:28 +0530
Message-ID: <1210872568-21848-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org, "Jose R. Santos" <jrs@us.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:47352 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753950AbYEOR3m (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 May 2008 13:29:42 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp07.in.ibm.com (8.13.1/8.13.1) with ESMTP id m4FHTUhQ014415
	for <linux-ext4@vger.kernel.org>; Thu, 15 May 2008 22:59:30 +0530
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4FHTK2Y1269816
	for <linux-ext4@vger.kernel.org>; Thu, 15 May 2008 22:59:20 +0530
Received: from d28av02.in.ibm.com (loopback [127.0.0.1])
	by d28av02.in.ibm.com (8.13.1/8.13.3) with ESMTP id m4FHSsXo030137
	for <linux-ext4@vger.kernel.org>; Thu, 15 May 2008 22:58:55 +0530
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jose R. Santos <jrs@us.ibm.com>

With FLEX_BG block bitmaps, inode bitmaps and inode tables
_MAY_ be allocated outside the group.  So, when initializing
the uninit block group, we need to check the location of this
blocks before setting the corresponding bits in the block
bitmap of the newly initialized group.  Also return the right
number of free blocks when counting the available free blocks
in uninit group.

Tested-by: Aneesh Kumar K.V <aneesh.kumar@inux.vnet.ibm.com>
Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
---
 fs/ext4/balloc.c |   71 +++++++++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 62 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 5c80eb5..46fdc2d 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -43,6 +43,46 @@ void ext4_get_group_no_and_offset(struct super_block *sb, ext4_fsblk_t blocknr,
 
 }
 
+int ext4_block_in_group(struct super_block *sb, ext4_fsblk_t block,
+			ext4_group_t block_group)
+{
+	ext4_group_t actual_group;
+	ext4_get_group_no_and_offset(sb, block, &actual_group, 0);
+	if (actual_group == block_group)
+		return 1;
+	return 0;
+}
+
+int ext4_group_used_meta_blocks(struct super_block *sb,
+				ext4_group_t block_group)
+{
+	ext4_fsblk_t tmp;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	/* block bitmap, inode bitmap, and inode table blocks */
+	int used_blocks = sbi->s_itb_per_group + 2;
+
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG)) {
+		struct ext4_group_desc *gdp;
+		struct buffer_head *bh;
+
+		gdp = ext4_get_group_desc(sb, block_group, &bh);
+		if (!ext4_block_in_group(sb, ext4_block_bitmap(sb, gdp),
+					block_group))
+			used_blocks--;
+
+		if (!ext4_block_in_group(sb, ext4_inode_bitmap(sb, gdp),
+					block_group))
+			used_blocks--;
+
+		tmp = ext4_inode_table(sb, gdp);
+		for (; tmp < ext4_inode_table(sb, gdp) +
+				sbi->s_itb_per_group; tmp++) {
+			if (!ext4_block_in_group(sb, tmp, block_group))
+				used_blocks -= 1;
+		}
+	}
+	return used_blocks;
+}
 /* Initializes an uninitialized block bitmap if given, and returns the
  * number of blocks free in the group. */
 unsigned ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
@@ -105,20 +145,34 @@ unsigned ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
 	free_blocks = group_blocks - bit_max;
 
 	if (bh) {
-		ext4_fsblk_t start;
+		ext4_fsblk_t start, tmp;
+		int flex_bg = 0;
 
 		for (bit = 0; bit < bit_max; bit++)
 			ext4_set_bit(bit, bh->b_data);
 
 		start = ext4_group_first_block_no(sb, block_group);
 
-		/* Set bits for block and inode bitmaps, and inode table */
-		ext4_set_bit(ext4_block_bitmap(sb, gdp) - start, bh->b_data);
-		ext4_set_bit(ext4_inode_bitmap(sb, gdp) - start, bh->b_data);
-		for (bit = (ext4_inode_table(sb, gdp) - start),
-		     bit_max = bit + sbi->s_itb_per_group; bit < bit_max; bit++)
-			ext4_set_bit(bit, bh->b_data);
+		if (EXT4_HAS_INCOMPAT_FEATURE(sb,
+					      EXT4_FEATURE_INCOMPAT_FLEX_BG))
+			flex_bg = 1;
 
+		/* Set bits for block and inode bitmaps, and inode table */
+		tmp = ext4_block_bitmap(sb, gdp);
+		if (!flex_bg || ext4_block_in_group(sb, tmp, block_group))
+			ext4_set_bit(tmp - start, bh->b_data);
+
+		tmp = ext4_inode_bitmap(sb, gdp);
+		if (!flex_bg || ext4_block_in_group(sb, tmp, block_group))
+			ext4_set_bit(tmp - start, bh->b_data);
+
+		tmp = ext4_inode_table(sb, gdp);
+		for (; tmp < ext4_inode_table(sb, gdp) +
+				sbi->s_itb_per_group; tmp++) {
+			if (!flex_bg ||
+				ext4_block_in_group(sb, tmp, block_group))
+				ext4_set_bit(tmp - start, bh->b_data);
+		}
 		/*
 		 * Also if the number of blocks within the group is
 		 * less than the blocksize * 8 ( which is the size
@@ -126,8 +180,7 @@ unsigned ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
 		 */
 		mark_bitmap_end(group_blocks, sb->s_blocksize * 8, bh->b_data);
 	}
