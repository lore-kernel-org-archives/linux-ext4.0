From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext2/ext3/ext4: Add block bitmap validation
Date: Fri,  3 Aug 2007 12:40:50 +0530
Message-ID: <11861250501999-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Andreas Dilger <adilger@clusterfs.com>
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:60782 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758290AbXHCHMC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Aug 2007 03:12:02 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp04.au.ibm.com (8.13.8/8.13.8) with ESMTP id l737E1jQ309552
	for <linux-ext4@vger.kernel.org>; Fri, 3 Aug 2007 17:14:13 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.250.237])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l737ETGs163100
	for <linux-ext4@vger.kernel.org>; Fri, 3 Aug 2007 17:14:29 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l737AtqK021815
	for <linux-ext4@vger.kernel.org>; Fri, 3 Aug 2007 17:10:56 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

When a new block bitmap is read from disk in read_block_bitmap()
there are a few bits that should ALWAYS be set. In particular, the
blocks given by ext4_blk_bitmap, ext4_inode_bitmap and ext4_inode_table.
Validate the block bitmap against these blocks.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
---
 fs/ext2/balloc.c |   56 ++++++++++++++++++++++++++++++++++++++----------
 fs/ext3/balloc.c |   53 ++++++++++++++++++++++++++++++++++++---------
 fs/ext4/balloc.c |   62 ++++++++++++++++++++++++++++++++++++++++-------------
 3 files changed, 133 insertions(+), 38 deletions(-)

diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
index baf71dd..917a443 100644
--- a/fs/ext2/balloc.c
+++ b/fs/ext2/balloc.c
@@ -69,6 +69,14 @@ struct ext2_group_desc * ext2_get_group_desc(struct super_block * sb,
 	return desc + offset;
 }
 
+static inline int
+block_in_use(unsigned long block, struct super_block *sb, unsigned char *map)
+{
+	return ext2_test_bit ((block -
+		le32_to_cpu(EXT2_SB(sb)->s_es->s_first_data_block)) %
+			 EXT2_BLOCKS_PER_GROUP(sb), map);
+}
+
 /*
  * Read the bitmap for a given block_group, reading into the specified 
  * slot in the superblock's bitmap cache.
@@ -78,20 +86,51 @@ struct ext2_group_desc * ext2_get_group_desc(struct super_block * sb,
 static struct buffer_head *
 read_block_bitmap(struct super_block *sb, unsigned int block_group)
 {
+	int i;
 	struct ext2_group_desc * desc;
 	struct buffer_head * bh = NULL;
-	
+	unsigned int bitmap_blk;
+
 	desc = ext2_get_group_desc (sb, block_group, NULL);
 	if (!desc)
-		goto error_out;
-	bh = sb_bread(sb, le32_to_cpu(desc->bg_block_bitmap));
+		return NULL;
+	bitmap_blk = le32_to_cpu(desc->bg_block_bitmap);
+	bh = sb_bread(sb, bitmap_blk);
 	if (!bh)
-		ext2_error (sb, "read_block_bitmap",
+		ext2_error (sb, __FUNCTION__,
 			    "Cannot read block bitmap - "
 			    "block_group = %d, block_bitmap = %u",
 			    block_group, le32_to_cpu(desc->bg_block_bitmap));
-error_out:
+
+	/* check whether block bitmap block number is set */
+	if (!block_in_use(bitmap_blk, sb, bh->b_data)) {
+		/* bad block bitmap */
+		goto error_out;
+	}
+	/* check whether the inode bitmap block number is set */
+	bitmap_blk = le32_to_cpu(desc->bg_inode_bitmap);
+	if (!block_in_use(bitmap_blk, sb, bh->b_data)) {
+		/* bad block bitmap */
+		goto error_out;
+	}
+	/* check whether the inode table block number is set */
+	bitmap_blk = le32_to_cpu(desc->bg_inode_table);
+	for (i = 0; i < EXT2_SB(sb)->s_itb_per_group; i++, bitmap_blk++) {
+		if (!block_in_use(bitmap_blk, sb, bh->b_data)) {
+			/* bad block bitmap */
+			goto error_out;
+		}
+	}
+
 	return bh;
+
+error_out:
+	brelse(bh);
+	ext2_error(sb, __FUNCTION__,
+			"Invalid block bitmap - "
+			"block_group = %d, block = %u",
+			block_group, bitmap_blk);
+	return NULL;
 }
 
 /*
@@ -583,13 +622,6 @@ unsigned long ext2_count_free_blocks (struct super_block * sb)
 #endif
 }
 
-static inline int
-block_in_use(unsigned long block, struct super_block *sb, unsigned char *map)
-{
-	return ext2_test_bit ((block -
-		le32_to_cpu(EXT2_SB(sb)->s_es->s_first_data_block)) %
-			 EXT2_BLOCKS_PER_GROUP(sb), map);
-}
 
 static inline int test_root(int a, int b)
 {
diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
index ca8aee6..b44c76f 100644
--- a/fs/ext3/balloc.c
+++ b/fs/ext3/balloc.c
@@ -79,6 +79,13 @@ struct ext3_group_desc * ext3_get_group_desc(struct super_block * sb,
 		*bh = sbi->s_group_desc[group_desc];
 	return desc + offset;
 }
+static inline int
+block_in_use(ext3_fsblk_t block, struct super_block *sb, unsigned char *map)
+{
+	return ext3_test_bit ((block -
+		le32_to_cpu(EXT3_SB(sb)->s_es->s_first_data_block)) %
+			 EXT3_BLOCKS_PER_GROUP(sb), map);
+}
 
 /**
  * read_block_bitmap()
@@ -93,20 +100,51 @@ struct ext3_group_desc * ext3_get_group_desc(struct super_block * sb,
 static struct buffer_head *
 read_block_bitmap(struct super_block *sb, unsigned int block_group)
 {
+	int i;
 	struct ext3_group_desc * desc;
 	struct buffer_head * bh = NULL;
+	ext3_fsblk_t bitmap_blk;
 
 	desc = ext3_get_group_desc (sb, block_group, NULL);
 	if (!desc)
-		goto error_out;
-	bh = sb_bread(sb, le32_to_cpu(desc->bg_block_bitmap));
+		return NULL;
+	bitmap_blk = le32_to_cpu(desc->bg_block_bitmap);
+	bh = sb_bread(sb, bitmap_blk);
 	if (!bh)
-		ext3_error (sb, "read_block_bitmap",
+		ext3_error (sb, __FUNCTION__,
 			    "Cannot read block bitmap - "
 			    "block_group = %d, block_bitmap = %u",
 			    block_group, le32_to_cpu(desc->bg_block_bitmap));
-error_out:
+
+	/* check whether block bitmap block number is set */
+	if (!block_in_use(bitmap_blk, sb, bh->b_data)) {
+		/* bad block bitmap */
+		goto error_out;
+	}
+	/* check whether the inode bitmap block number is set */
+	bitmap_blk = le32_to_cpu(desc->bg_inode_bitmap);
+	if (!block_in_use(bitmap_blk, sb, bh->b_data)) {
+		/* bad block bitmap */
+		goto error_out;
+	}
+	/* check whether the inode table block number is set */
+	bitmap_blk = le32_to_cpu(desc->bg_inode_table);
+	for (i = 0; i < EXT3_SB(sb)->s_itb_per_group; i++, bitmap_blk++) {
+		if (!block_in_use(bitmap_blk, sb, bh->b_data)) {
+			/* bad block bitmap */
+			goto error_out;
+		}
+	}
+
 	return bh;
+
+error_out:
+	brelse(bh);
+	ext3_error(sb, __FUNCTION__,
+			"Invalid block bitmap - "
+			"block_group = %d, block = %lu",
+			block_group, bitmap_blk);
+	return NULL;
 }
 /*
  * The reservation window structure operations
@@ -1733,13 +1771,6 @@ ext3_fsblk_t ext3_count_free_blocks(struct super_block *sb)
 #endif
 }
 
-static inline int
-block_in_use(ext3_fsblk_t block, struct super_block *sb, unsigned char *map)
-{
-	return ext3_test_bit ((block -
-		le32_to_cpu(EXT3_SB(sb)->s_es->s_first_data_block)) %
-			 EXT3_BLOCKS_PER_GROUP(sb), map);
-}
 
 static inline int test_root(int a, int b)
 {
diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 3b64bb1..7d58f12 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -99,6 +99,15 @@ struct ext4_group_desc * ext4_get_group_desc(struct super_block * sb,
 		*bh = sbi->s_group_desc[group_desc];
 	return desc;
 }
+static inline int
+block_in_use(ext4_fsblk_t block, struct super_block *sb, unsigned char *map)
+{
+	ext4_grpblk_t offset;
+
+	ext4_get_group_no_and_offset(sb, block, NULL, &offset);
+	return ext4_test_bit (offset, map);
+}
+
 
 /**
  * read_block_bitmap()
@@ -113,21 +122,53 @@ struct ext4_group_desc * ext4_get_group_desc(struct super_block * sb,
 static struct buffer_head *
 read_block_bitmap(struct super_block *sb, unsigned int block_group)
 {
+	int i;
 	struct ext4_group_desc * desc;
 	struct buffer_head * bh = NULL;
+	ext4_fsblk_t bitmap_blk;
 
 	desc = ext4_get_group_desc (sb, block_group, NULL);
 	if (!desc)
-		goto error_out;
-	bh = sb_bread(sb, ext4_block_bitmap(sb, desc));
+		return NULL;
+	bitmap_blk = ext4_block_bitmap(sb, desc);
+	bh = sb_bread(sb, bitmap_blk);
 	if (!bh)
-		ext4_error (sb, "read_block_bitmap",
+		ext4_error (sb, __FUNCTION__,
 			    "Cannot read block bitmap - "
 			    "block_group = %d, block_bitmap = %llu",
-			    block_group,
-			    ext4_block_bitmap(sb, desc));
-error_out:
+			    block_group, bitmap_blk);
+
+	/* check whether block bitmap block number is set */
+	if (!block_in_use(bitmap_blk, sb, bh->b_data)) {
+		/* bad block bitmap */
+		goto error_out;
+	}
+
+	/* check whether the inode bitmap block number is set */
+	bitmap_blk = ext4_inode_bitmap(sb, desc);
+	if (!block_in_use(bitmap_blk, sb, bh->b_data)) {
+		/* bad block bitmap */
+		goto error_out;
+	}
+	/* check whether the inode table block number is set */
+	bitmap_blk = ext4_inode_table(sb, desc);
+	for (i = 0; i < EXT4_SB(sb)->s_itb_per_group; i++, bitmap_blk++) {
+		if (!block_in_use(bitmap_blk, sb, bh->b_data)) {
+			/* bad block bitmap */
+			goto error_out;
+		}
+	}
+
 	return bh;
+
+error_out:
+	brelse(bh);
+	ext4_error(sb, __FUNCTION__,
+			"Invalid block bitmap - "
+			"block_group = %d, block = %llu",
+			block_group, bitmap_blk);
+	return NULL;
+
 }
 /*
  * The reservation window structure operations
@@ -1747,15 +1788,6 @@ ext4_fsblk_t ext4_count_free_blocks(struct super_block *sb)
 #endif
 }
 
-static inline int
-block_in_use(ext4_fsblk_t block, struct super_block *sb, unsigned char *map)
-{
-	ext4_grpblk_t offset;
-
-	ext4_get_group_no_and_offset(sb, block, NULL, &offset);
-	return ext4_test_bit (offset, map);
-}
-
 static inline int test_root(int a, int b)
 {
 	int num = b;
-- 
1.5.3.rc2.22.g69a9b-dirty
