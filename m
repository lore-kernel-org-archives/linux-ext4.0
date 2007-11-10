From: akpm@linux-foundation.org
Subject: + ridiculous-ext3-costs-was-re-page-fault-costs.patch added to -mm tree
Date: Sat, 10 Nov 2007 14:29:19 -0800
Message-ID: <200711102229.lAAMTJoI008637@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, adilger@clusterfs.com,
	akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com,
	cmm@us.ibm.com, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext3: mostly fix blobk bitmap read performance regression
has been added to the -mm tree.  Its filename is
     ridiculous-ext3-costs-was-re-page-fault-costs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ext3: mostly fix blobk bitmap read performance regression
From: Linus Torvalds <torvalds@linux-foundation.org>

The ext3 block bitmap functions got added validation recently, which caused
a huge performance regression (ie 5x slower) due to very expensive modulus
calculations being done in a loop.

This largely fixes it, by moving the calculations out of the loop.  The
sanity checking is still expensive, but no longer totally excessively so.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Andreas Dilger <adilger@clusterfs.com>
Cc: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/balloc.c |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff -puN fs/ext3/balloc.c~ridiculous-ext3-costs-was-re-page-fault-costs fs/ext3/balloc.c
--- a/fs/ext3/balloc.c~ridiculous-ext3-costs-was-re-page-fault-costs
+++ a/fs/ext3/balloc.c
@@ -80,12 +80,12 @@ struct ext3_group_desc * ext3_get_group_
 	return desc + offset;
 }
 
-static inline int
-block_in_use(ext3_fsblk_t block, struct super_block *sb, unsigned char *map)
+static inline unsigned int
+block_bit_number(__le32 block, struct super_block *sb)
 {
-	return ext3_test_bit ((block -
-		le32_to_cpu(EXT3_SB(sb)->s_es->s_first_data_block)) %
-			 EXT3_BLOCKS_PER_GROUP(sb), map);
+	__le32 first = EXT3_SB(sb)->s_es->s_first_data_block;
+
+	return (le32_to_cpu(block) - le32_to_cpu(first)) % EXT3_BLOCKS_PER_GROUP(sb);
 }
 
 /**
@@ -102,6 +102,7 @@ static struct buffer_head *
 read_block_bitmap(struct super_block *sb, unsigned int block_group)
 {
 	int i;
+	unsigned offset;
 	struct ext3_group_desc * desc;
 	struct buffer_head * bh = NULL;
 	ext3_fsblk_t bitmap_blk;
@@ -120,20 +121,21 @@ read_block_bitmap(struct super_block *sb
 	}
 
 	/* check whether block bitmap block number is set */
-	if (!block_in_use(bitmap_blk, sb, bh->b_data)) {
+	offset = block_bit_number(desc->bg_block_bitmap, sb);
+	if (!ext3_test_bit(offset, bh->b_data)) {
 		/* bad block bitmap */
 		goto error_out;
 	}
 	/* check whether the inode bitmap block number is set */
-	bitmap_blk = le32_to_cpu(desc->bg_inode_bitmap);
-	if (!block_in_use(bitmap_blk, sb, bh->b_data)) {
+	offset = block_bit_number(desc->bg_inode_bitmap, sb);
+	if (!ext3_test_bit(offset, bh->b_data)) {
 		/* bad block bitmap */
 		goto error_out;
 	}
-	/* check whether the inode table block number is set */
-	bitmap_blk = le32_to_cpu(desc->bg_inode_table);
-	for (i = 0; i < EXT3_SB(sb)->s_itb_per_group; i++, bitmap_blk++) {
-		if (!block_in_use(bitmap_blk, sb, bh->b_data)) {
+	/* check whether the inode table block numbers are set */
+	offset = block_bit_number(desc->bg_inode_table, sb);
+	for (i = 0; i < EXT3_SB(sb)->s_itb_per_group; i++, offset++) {
+		if (!ext3_test_bit(offset, bh->b_data)) {
 			/* bad block bitmap */
 			goto error_out;
 		}
_

Patches currently in -mm which might be from torvalds@linux-foundation.org are

git-x86.patch
ridiculous-ext3-costs-was-re-page-fault-costs.patch
workaround-for-a-pci-restoring-bug.patch
