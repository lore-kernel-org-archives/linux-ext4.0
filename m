From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH 2/2 bigalloc] ext4: modify offset to cluster in ext4_valid_block_bitmap
Date: Thu,  4 Aug 2011 11:48:01 +0800
Message-ID: <1312429682-16970-1-git-send-email-hao.bigrat@gmail.com>
Cc: Robin Dong <sanbai@taobao.com>, Ted Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:64824 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755374Ab1HDDsl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Aug 2011 23:48:41 -0400
Received: by pzk37 with SMTP id 37so1253271pzk.1
        for <linux-ext4@vger.kernel.org>; Wed, 03 Aug 2011 20:48:41 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

When I run a test application on ext4 of bigalloc, and also a daemon
which run "echo 3 > /proc/sys/vm/drop_caches" every 2 seconds,
the kernel report:

15319.557145] EXT4-fs error (device sda4): ext4_valid_block_bitmap:324: comm dir_tree: Invalid block bitmap - block_group = 6, block = 3145730

The reason is ext4_valied_block_bitmap has not be modified for cluster.

Signed-off-by: Robin Dong <sanbai@taobao.com>
Cc: Ted Ts'o <tytso@mit.edu>
---
 fs/ext4/balloc.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 23a6375..8b982fc 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -282,6 +282,7 @@ static int ext4_valid_block_bitmap(struct super_block *sb,
 	ext4_grpblk_t next_zero_bit;
 	ext4_fsblk_t bitmap_blk;
 	ext4_fsblk_t group_first_block;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
 
 	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG)) {
 		/* with FLEX_BG, the inode/block bitmaps and itable
@@ -297,14 +298,14 @@ static int ext4_valid_block_bitmap(struct super_block *sb,
 	/* check whether block bitmap block number is set */
 	bitmap_blk = ext4_block_bitmap(sb, desc);
 	offset = bitmap_blk - group_first_block;
-	if (!ext4_test_bit(offset, bh->b_data))
+	if (!ext4_test_bit(EXT4_B2C(sbi, offset), bh->b_data))
 		/* bad block bitmap */
 		goto err_out;
 
 	/* check whether the inode bitmap block number is set */
 	bitmap_blk = ext4_inode_bitmap(sb, desc);
 	offset = bitmap_blk - group_first_block;
-	if (!ext4_test_bit(offset, bh->b_data))
+	if (!ext4_test_bit(EXT4_B2C(sbi, offset), bh->b_data))
 		/* bad block bitmap */
 		goto err_out;
 
@@ -312,9 +313,11 @@ static int ext4_valid_block_bitmap(struct super_block *sb,
 	bitmap_blk = ext4_inode_table(sb, desc);
 	offset = bitmap_blk - group_first_block;
 	next_zero_bit = ext4_find_next_zero_bit(bh->b_data,
-				offset + EXT4_SB(sb)->s_itb_per_group,
-				offset);
-	if (next_zero_bit >= offset + EXT4_SB(sb)->s_itb_per_group)
+			EXT4_B2C(sbi, offset + EXT4_SB(sb)->s_itb_per_group),
+			EXT4_B2C(sbi, offset));
+
+	if (next_zero_bit >=
+			EXT4_B2C(sbi, offset + EXT4_SB(sb)->s_itb_per_group))
 		/* good bitmap for inode tables */
 		return 1;
 
-- 
1.7.3.2

