From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 4/4] ext4: add block bitmap validation
Date: Thu, 15 Nov 2007 17:40:46 +0530
Message-ID: <1195128646-15143-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1195128646-15143-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1195128646-15143-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1195128646-15143-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1195128646-15143-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: cmm@us.ibm.com, torvalds@linux-foundation.org,
	a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
	adilger@clusterfs.com,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:41460 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280AbXKOMmU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Nov 2007 07:42:20 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id lAFCCjmF028051
	for <linux-ext4@vger.kernel.org>; Thu, 15 Nov 2007 23:12:45 +1100
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.6) with ESMTP id lAFCBgDO2498714
	for <linux-ext4@vger.kernel.org>; Thu, 15 Nov 2007 23:11:42 +1100
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lAFBAljp005146
	for <linux-ext4@vger.kernel.org>; Thu, 15 Nov 2007 22:10:48 +1100
In-Reply-To: <1195128646-15143-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

When a new block bitmap is read from disk in read_block_bitmap()
there are a few bits that should ALWAYS be set.  In particular,
the blocks given corresponding to block bitmap, inode bitmap and inode tables.
Validate the block bitmap against these blocks.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/balloc.c |   96 +++++++++++++++++++++++++++++++++++++++++++++---------
 1 files changed, 80 insertions(+), 16 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 71ee95e..2657a1e 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -189,13 +189,62 @@ struct ext4_group_desc * ext4_get_group_desc(struct super_block * sb,
 	return desc;
 }
 
+static int ext4_valid_block_bitmap(struct super_block *sb,
+					struct ext4_group_desc *desc,
+					unsigned int block_group,
+					struct buffer_head *bh)
+{
+	ext4_grpblk_t offset;
+	ext4_grpblk_t next_zero_bit;
+	ext4_fsblk_t bitmap_blk;
+	ext4_fsblk_t group_first_block;
+
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG)) {
+		/* with FLEX_BG, the inode/block bitmaps and itable
+		 * blocks may not be in the group at all
+		 * so the bitmap validation will be skipped for those groups
+		 * or it has to also read the block group where the bitmaps
+		 * are located to verify they are set.
+		 */
+		return 1;
+	}
+	group_first_block = ext4_group_first_block_no(sb, block_group);
+
+	/* check whether block bitmap block number is set */
+	bitmap_blk = ext4_block_bitmap(sb, desc);
+	offset = bitmap_blk - group_first_block;
+	if (!ext4_test_bit(offset, bh->b_data)) {
+		/* bad block bitmap */
+		return 0;
+	}
+
+	/* check whether the inode bitmap block number is set */
+	bitmap_blk = ext4_inode_bitmap(sb, desc);
+	offset = bitmap_blk - group_first_block;
+	if (!ext4_test_bit(offset, bh->b_data)) {
+		/* bad block bitmap */
+		return 0;
+	}
+
+	/* check whether the inode table block number is set */
+	bitmap_blk = ext4_inode_table(sb, desc);
+	offset = bitmap_blk - group_first_block;
+	next_zero_bit = ext4_find_next_zero_bit(bh->b_data,
+					EXT4_SB(sb)->s_itb_per_group + 1,
+					offset);
+	if (next_zero_bit >= offset + EXT4_SB(sb)->s_itb_per_group)
+		/* good bitmap for inode tables */
+		return 1;
+
+	return 0;
+}
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
@@ -210,25 +259,40 @@ read_block_bitmap(struct super_block *sb, unsigned int block_group)
 	if (!desc)
 		return NULL;
 	bitmap_blk = ext4_block_bitmap(sb, desc);
+	bh = sb_getblk(sb, bitmap_blk);
+	if (unlikely(!bh)) {
+		ext4_error(sb, __FUNCTION__,
+			    "Cannot read block bitmap - "
+			    "block_group = %d, block_bitmap = %llu",
+			    block_group, bitmap_blk);
+		return NULL;
+	}
+	if (bh_uptodate_or_lock(bh))
+		return bh;
+
 	if (desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
-		bh = sb_getblk(sb, bitmap_blk);
-		if (!buffer_uptodate(bh)) {
-			lock_buffer(bh);
-			if (!buffer_uptodate(bh)) {
-				ext4_init_block_bitmap(sb, bh, block_group,
-						       desc);
-				set_buffer_uptodate(bh);
-			}
-			unlock_buffer(bh);
-		}
-	} else {
-		bh = sb_bread(sb, bitmap_blk);
+		ext4_init_block_bitmap(sb, bh, block_group, desc);
+		set_buffer_uptodate(bh);
+		unlock_buffer(bh);
+		return bh;
 	}
-	if (!bh)
-		ext4_error (sb, __FUNCTION__,
+	if (bh_submit_read(bh) < 0) {
+		brelse(bh);
+		ext4_error(sb, __FUNCTION__,
 			    "Cannot read block bitmap - "
 			    "block_group = %d, block_bitmap = %llu",
 			    block_group, bitmap_blk);
+		return NULL;
+	}
+	if (!ext4_valid_block_bitmap(sb, desc, block_group, bh)) {
+		brelse(bh);
+		ext4_error(sb, __FUNCTION__,
+				"Invalid block bitmap - "
+				"block_group = %d, block = %llu",
+				block_group, bitmap_blk);
+		return NULL;
+	}
+
 	return bh;
 }
 /*
-- 
1.5.3.5.652.gf192c-dirty
