From: akpm@linux-foundation.org
Subject: + ext2-add-block-bitmap-validation.patch added to -mm tree
Date: Mon, 19 Nov 2007 23:19:58 -0800
Message-ID: <200711200719.lAK7Jw9R020934@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Cc: aneesh.kumar@linux.vnet.ibm.com, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext2: add block bitmap validation
has been added to the -mm tree.  Its filename is
     ext2-add-block-bitmap-validation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ext2: add block bitmap validation
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

When a new block bitmap is read from disk in read_block_bitmap() there are a
few bits that should ALWAYS be set.  In particular, the blocks given
corresponding to block bitmap, inode bitmap and inode tables.  Validate the
block bitmap against these blocks.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/balloc.c |   81 ++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 72 insertions(+), 9 deletions(-)

diff -puN fs/ext2/balloc.c~ext2-add-block-bitmap-validation fs/ext2/balloc.c
--- a/fs/ext2/balloc.c~ext2-add-block-bitmap-validation
+++ a/fs/ext2/balloc.c
@@ -69,9 +69,53 @@ struct ext2_group_desc * ext2_get_group_
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
@@ -80,17 +124,36 @@ read_block_bitmap(struct super_block *sb
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
 
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

ext2-return-after-ext2_error-in-case-of-failures.patch
ext2-change-the-default-behaviour-on-error.patch
add-buffer-head-related-helper-functions.patch
ext2-add-block-bitmap-validation.patch
ext3-add-block-bitmap-validation.patch
ext4-add-block-bitmap-validation.patch
ext3-return-after-ext3_error-in-case-of-failures.patch
ext3-change-the-default-behaviour-on-error.patch
