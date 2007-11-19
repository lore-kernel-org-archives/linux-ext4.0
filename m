From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext2: add block bitmap validation
Date: Mon, 19 Nov 2007 20:25:59 +0530
Message-ID: <1195484161-14472-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1195484161-14472-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org, aneesh.kumar@linux.vnet.ibm.com
To: cmm@us.ibm.com, akpm@linux-foundation.org, adilger@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:40155 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522AbXKSO4c (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Nov 2007 09:56:32 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id lAJEuRX2016339
	for <linux-ext4@vger.kernel.org>; Tue, 20 Nov 2007 01:56:27 +1100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.6) with ESMTP id lAJF06o9258222
	for <linux-ext4@vger.kernel.org>; Tue, 20 Nov 2007 02:00:06 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lAJEuC7g006770
	for <linux-ext4@vger.kernel.org>; Tue, 20 Nov 2007 01:56:13 +1100
In-Reply-To: <1195484161-14472-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

When a new block bitmap is read from disk in read_block_bitmap()
there are a few bits that should ALWAYS be set.  In particular,
the blocks given corresponding to block bitmap, inode bitmap and inode tables.
Validate the block bitmap against these blocks.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext2/balloc.c |   81 ++++++++++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 72 insertions(+), 9 deletions(-)

diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
index 377ad17..4b5c511 100644
--- a/fs/ext2/balloc.c
+++ b/fs/ext2/balloc.c
@@ -69,9 +69,53 @@ struct ext2_group_desc * ext2_get_group_desc(struct super_block * sb,
 	return desc + offset;
 }
 
+static int ext2_valid_block_bitmap(struct super_block *sb,
+					struct ext2_group_desc *desc,
+					unsigned int block_group,
+					struct buffer_head *bh)
+{
+	ext2_grpblk_t offset;
+	ext2_grpblk_t next_zero_bit;
+	ext2_fsblk_t bitmap_blk;
+	ext2_fsblk_t group_first_block;
+
+	group_first_block = ext2_group_first_block_no(sb, block_group);
+
+	/* check whether block bitmap block number is set */
+	bitmap_blk = le32_to_cpu(desc->bg_block_bitmap);
+	offset = bitmap_blk - group_first_block;
+	if (!ext2_test_bit(offset, bh->b_data))
+		/* bad block bitmap */
+		goto err_out;
+
+	/* check whether the inode bitmap block number is set */
+	bitmap_blk = le32_to_cpu(desc->bg_inode_bitmap);
+	offset = bitmap_blk - group_first_block;
+	if (!ext2_test_bit(offset, bh->b_data))
+		/* bad block bitmap */
+		goto err_out;
+
+	/* check whether the inode table block number is set */
+	bitmap_blk = le32_to_cpu(desc->bg_inode_table);
+	offset = bitmap_blk - group_first_block;
+	next_zero_bit = ext2_find_next_zero_bit(bh->b_data,
+				offset + EXT2_SB(sb)->s_itb_per_group,
+				offset);
+	if (next_zero_bit >= offset + EXT2_SB(sb)->s_itb_per_group)
+		/* good bitmap for inode tables */
+		return 1;
+
+err_out:
+	ext2_error(sb, __FUNCTION__,
+			"Invalid block bitmap - "
+			"block_group = %d, block = %lu",
+			block_group, bitmap_blk);
+	return 0;
+}
+
 /*
- * Read the bitmap for a given block_group, reading into the specified 
- * slot in the superblock's bitmap cache.
+ * Read the bitmap for a given block_group,and validate the
+ * bits for block/inode/inode tables are set in the bitmaps
  *
  * Return buffer_head on success or NULL in case of failure.
  */
@@ -80,17 +124,36 @@ read_block_bitmap(struct super_block *sb, unsigned int block_group)
 {
 	struct ext2_group_desc * desc;
 	struct buffer_head * bh = NULL;
-	
-	desc = ext2_get_group_desc (sb, block_group, NULL);
+	ext2_fsblk_t bitmap_blk;
+
+	desc = ext2_get_group_desc(sb, block_group, NULL);
 	if (!desc)
-		goto error_out;
-	bh = sb_bread(sb, le32_to_cpu(desc->bg_block_bitmap));
-	if (!bh)
-		ext2_error (sb, "read_block_bitmap",
+		return NULL;
+	bitmap_blk = le32_to_cpu(desc->bg_block_bitmap);
+	bh = sb_getblk(sb, bitmap_blk);
+	if (unlikely(!bh)) {
+		ext2_error(sb, __FUNCTION__,
 			    "Cannot read block bitmap - "
 			    "block_group = %d, block_bitmap = %u",
 			    block_group, le32_to_cpu(desc->bg_block_bitmap));
-error_out:
+		return NULL;
+	}
+	if (likely(bh_uptodate_or_lock(bh)))
+		return bh;
+
+	if (bh_submit_read(bh) < 0) {
+		brelse(bh);
+		ext2_error(sb, __FUNCTION__,
+			    "Cannot read block bitmap - "
+			    "block_group = %d, block_bitmap = %u",
+			    block_group, le32_to_cpu(desc->bg_block_bitmap));
+		return NULL;
+	}
+	if (!ext2_valid_block_bitmap(sb, desc, block_group, bh)) {
+		brelse(bh);
+		return NULL;
+	}
+
 	return bh;
 }
 
-- 
1.5.3.5.652.gf192c-dirty
