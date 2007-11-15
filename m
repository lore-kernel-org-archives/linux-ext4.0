From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 3/4] ext3: add block bitmap validation
Date: Thu, 15 Nov 2007 17:40:45 +0530
Message-ID: <1195128646-15143-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1195128646-15143-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1195128646-15143-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1195128646-15143-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: cmm@us.ibm.com, torvalds@linux-foundation.org,
	a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
	adilger@clusterfs.com,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:36670 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754886AbXKOMMy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Nov 2007 07:12:54 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp01.au.ibm.com (8.13.1/8.13.1) with ESMTP id lAFCDD9a000660
	for <linux-ext4@vger.kernel.org>; Thu, 15 Nov 2007 23:13:13 +1100
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.6) with ESMTP id lAFCFDIk243050
	for <linux-ext4@vger.kernel.org>; Thu, 15 Nov 2007 23:15:13 +1100
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lAFBAge9005078
	for <linux-ext4@vger.kernel.org>; Thu, 15 Nov 2007 22:10:43 +1100
In-Reply-To: <1195128646-15143-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

When a new block bitmap is read from disk in read_block_bitmap()
there are a few bits that should ALWAYS be set.  In particular,
the blocks given corresponding to block bitmap, inode bitmap and inode tables.
Validate the block bitmap against these blocks.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext3/balloc.c |   77 ++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 69 insertions(+), 8 deletions(-)

diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
index a8ba7e8..8f732b8 100644
--- a/fs/ext3/balloc.c
+++ b/fs/ext3/balloc.c
@@ -80,13 +80,52 @@ struct ext3_group_desc * ext3_get_group_desc(struct super_block * sb,
 	return desc + offset;
 }
 
+static int ext3_valid_block_bitmap(struct super_block *sb,
+					struct ext3_group_desc *desc,
+					unsigned int block_group,
+					struct buffer_head *bh)
+{
+	ext3_grpblk_t offset;
+	ext3_grpblk_t next_zero_bit;
+	ext3_fsblk_t bitmap_blk;
+	ext3_fsblk_t group_first_block;
+
+	group_first_block = ext3_group_first_block_no(sb, block_group);
+
+	/* check whether block bitmap block number is set */
+	bitmap_blk = le32_to_cpu(desc->bg_block_bitmap);
+	offset = bitmap_blk - group_first_block;
+	if (!ext3_test_bit(offset, bh->b_data)) {
+		/* bad block bitmap */
+		return 0;
+	}
+	/* check whether the inode bitmap block number is set */
+	bitmap_blk = le32_to_cpu(desc->bg_inode_bitmap);
+	offset = bitmap_blk - group_first_block;
+	if (!ext3_test_bit(offset, bh->b_data)) {
+		/* bad block bitmap */
+		return 0;
+	}
+	/* check whether the inode table block number is set */
+	bitmap_blk = le32_to_cpu(desc->bg_inode_table);
+	offset = bitmap_blk - group_first_block;
+	next_zero_bit = ext3_find_next_zero_bit(bh->b_data,
+					EXT3_SB(sb)->s_itb_per_group + 1,
+					offset);
+	if (next_zero_bit >= offset + EXT3_SB(sb)->s_itb_per_group)
+		/* good bitmap for inode tables */
+		return 1;
+
+	return 0;
+}
+
 /**
  * read_block_bitmap()
  * @sb:			super block
  * @block_group:	given block group
  *
- * Read the bitmap for a given block_group, reading into the specified
- * slot in the superblock's bitmap cache.
+ * Read the bitmap for a given block_group,and validate the
+ * bits for block/inode/inode tables are set in the bitmaps
  *
  * Return buffer_head on success or NULL in case of failure.
  */
@@ -95,17 +134,39 @@ read_block_bitmap(struct super_block *sb, unsigned int block_group)
 {
 	struct ext3_group_desc * desc;
 	struct buffer_head * bh = NULL;
+	ext3_fsblk_t bitmap_blk;
 
-	desc = ext3_get_group_desc (sb, block_group, NULL);
+	desc = ext3_get_group_desc(sb, block_group, NULL);
 	if (!desc)
-		goto error_out;
-	bh = sb_bread(sb, le32_to_cpu(desc->bg_block_bitmap));
-	if (!bh)
-		ext3_error (sb, "read_block_bitmap",
+		return NULL;
+	bitmap_blk = le32_to_cpu(desc->bg_block_bitmap);
+	bh = sb_getblk(sb, bitmap_blk);
+	if (unlikely(!bh)) {
+		ext3_error(sb, __FUNCTION__,
+			    "Cannot read block bitmap - "
+			    "block_group = %d, block_bitmap = %u",
+			    block_group, le32_to_cpu(desc->bg_block_bitmap));
+		return NULL;
+	}
+	if (likely(bh_uptodate_or_lock(bh)))
+		return bh;
+
+	if (bh_submit_read(bh) < 0) {
+		brelse(bh);
+		ext3_error(sb, __FUNCTION__,
 			    "Cannot read block bitmap - "
 			    "block_group = %d, block_bitmap = %u",
 			    block_group, le32_to_cpu(desc->bg_block_bitmap));
-error_out:
+		return NULL;
+	}
+	if (!ext3_valid_block_bitmap(sb, desc, block_group, bh)) {
+		brelse(bh);
+		ext3_error(sb, __FUNCTION__,
+				"Invalid block bitmap - "
+				"block_group = %d, block = %lu",
+				block_group, bitmap_blk);
+		return NULL;
+	}
 	return bh;
 }
 /*
-- 
1.5.3.5.652.gf192c-dirty
