From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext2/ext3/ext4: Add block bitmap validation
Date: Mon,  9 Jul 2007 23:54:43 +0530
Message-ID: <11840054832202-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: adilger@clusterfs.com,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:48417 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912AbXGISYw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Jul 2007 14:24:52 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp04.au.ibm.com (8.13.8/8.13.8) with ESMTP id l69IlTBb270916
	for <linux-ext4@vger.kernel.org>; Tue, 10 Jul 2007 04:47:30 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.250.244])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l69ISK9o189442
	for <linux-ext4@vger.kernel.org>; Tue, 10 Jul 2007 04:28:20 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l69IOldK009021
	for <linux-ext4@vger.kernel.org>; Tue, 10 Jul 2007 04:24:47 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

When a new block bitmap is read from disk in read_block_bitmap()
there are a few bits that should ALWAYS be set. In particular, the
blocks given by ext4_blk_bitmap, ext4_inode_bitmap and ext4_inode_table.
Validate the block bitmap against these blocks.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext2/balloc.c |   51 +++++++++++++++++++++++++++++++++++++----------
 fs/ext3/balloc.c |   48 ++++++++++++++++++++++++++++++++++++---------
 fs/ext4/balloc.c |   57 ++++++++++++++++++++++++++++++++++++++++-------------
 3 files changed, 121 insertions(+), 35 deletions(-)

diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
index baf71dd..8127682 100644
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
@@ -80,18 +88,46 @@ read_block_bitmap(struct super_block *sb, unsigned int block_group)
 {
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
 		ext2_error (sb, "read_block_bitmap",
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
+	if (!block_in_use(bitmap_blk, sb, bh->b_data)) {
+		/* bad block bitmap */
+		goto error_out;
+	}
+
 	return bh;
+
+error_out:
+	brelse(bh);
+	ext2_error(sb, "read_block_bitmap",
+			"Invalid block bitmap - "
+			"block_group = %d, block = %u",
+			block_group, bitmap_blk);
+	return NULL;
 }
 
 /*
@@ -583,13 +619,6 @@ unsigned long ext2_count_free_blocks (struct super_block * sb)
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
index ca8aee6..fc5ef29 100644
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
@@ -95,18 +102,46 @@ read_block_bitmap(struct super_block *sb, unsigned int block_group)
 {
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
 		ext3_error (sb, "read_block_bitmap",
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
+	if (!block_in_use(bitmap_blk, sb, bh->b_data)) {
+		/* bad block bitmap */
+		goto error_out;
+	}
+
 	return bh;
+
+error_out:
+	brelse(bh);
+	ext3_error(sb, "read_block_bitmap",
+			"Invalid block bitmap - "
+			"block_group = %d, block = %lu",
+			block_group, bitmap_blk);
+	return NULL;
 }
 /*
  * The reservation window structure operations
@@ -1733,13 +1768,6 @@ ext3_fsblk_t ext3_count_free_blocks(struct super_block *sb)
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
index 3b64bb1..7986d4e 100644
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
@@ -115,19 +124,48 @@ read_block_bitmap(struct super_block *sb, unsigned int block_group)
 {
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
 		ext4_error (sb, "read_block_bitmap",
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
+	if (!block_in_use(bitmap_blk, sb, bh->b_data)) {
+		/* bad block bitmap */
+		goto error_out;
+	}
+
 	return bh;
+
+error_out:
+	brelse(bh);
+	ext4_error(sb, "read_block_bitmap",
+			"Invalid block bitmap - "
+			"block_group = %d, block = %llu",
+			block_group, bitmap_blk);
+	return NULL;
+
 }
 /*
  * The reservation window structure operations
@@ -1747,15 +1785,6 @@ ext4_fsblk_t ext4_count_free_blocks(struct super_block *sb)
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
1.5.3.rc0.63.gc956-dirty
