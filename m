From: Bernd Schubert <bs_lists@aakef.fastmail.fm>
Subject: [PATCH] make ext4_valid_block_bitmap() more verbose
Date: Sat, 13 Nov 2010 00:26:50 +0100
Message-ID: <201011130026.51268.bs_lists@aakef.fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Bernd Schubert <bschubert@ddn.com>,
	Andreas Dilger <andreas.dilger@oracle.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:38714 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932584Ab0KLX0z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 12 Nov 2010 18:26:55 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The real issue we want to debug with the patch below actually came up while 
stress testing Lustre using the RHEL5.5 kernel (so 2.6.32'ish ext4), but a 
more verbose error function should not hurt for vanilla ext4 either.

make ext4_valid_block_bitmap() more verbose

While running our stress test suite, ext4_valid_block_bitmap() 
frequently complains about an invalid block bitmap.
However, e2fsck does not find anything. So in oder to be able
to better debug this issue, make the function more verbose and 
let it complain about the two possible invalid bitmaps.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>

---
 fs/ext4/balloc.c |   44 +++++++++++++++++++++++++++++++-------------
 1 file changed, 31 insertions(+), 13 deletions(-)

Index: linux-git/fs/ext4/balloc.c
===================================================================
--- linux-git.orig/fs/ext4/balloc.c
+++ linux-git/fs/ext4/balloc.c
@@ -230,6 +230,16 @@ struct ext4_group_desc * ext4_get_group_
 	return desc;
 }
 
+/**
+ * ext4_get_group_desc() -- load group descriptor from disk
+ * @sb:			super block
+ * @ext4_group_desc:	blocks group descriptor
+ * @block_group		block group to check
+ * @bh:			pointer to the buffer head to store the block
+ *			group descriptor
+ *
+ * return 0 on error or 1 if valid
+ */
 static int ext4_valid_block_bitmap(struct super_block *sb,
 					struct ext4_group_desc *desc,
 					unsigned int block_group,
@@ -239,6 +249,7 @@ static int ext4_valid_block_bitmap(struc
 	ext4_grpblk_t next_zero_bit;
 	ext4_fsblk_t bitmap_blk;
 	ext4_fsblk_t group_first_block;
+	int valid = 1;
 
 	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG)) {
 		/* with FLEX_BG, the inode/block bitmaps and itable
@@ -254,16 +265,20 @@ static int ext4_valid_block_bitmap(struc
 	/* check whether block bitmap block number is set */
 	bitmap_blk = ext4_block_bitmap(sb, desc);
 	offset = bitmap_blk - group_first_block;
-	if (!ext4_test_bit(offset, bh->b_data))
-		/* bad block bitmap */
-		goto err_out;
+	if (!ext4_test_bit(offset, bh->b_data)) {
+		ext4_warning(sb, "bad block bitmap block = %llu, offset = %d",
+			     bitmap_blk, (int) offset);
+		valid = 0;
+	}
 
 	/* check whether the inode bitmap block number is set */
 	bitmap_blk = ext4_inode_bitmap(sb, desc);
 	offset = bitmap_blk - group_first_block;
-	if (!ext4_test_bit(offset, bh->b_data))
-		/* bad block bitmap */
-		goto err_out;
+	if (!ext4_test_bit(offset, bh->b_data)) {
+		ext4_warning(sb, "bad inode bitmap block = %llu, offset = %d",
+			     bitmap_blk, (int) offset);
+		valid = 0;
+	}
 
 	/* check whether the inode table block number is set */
 	bitmap_blk = ext4_inode_table(sb, desc);
@@ -271,14 +286,17 @@ static int ext4_valid_block_bitmap(struc
 	next_zero_bit = ext4_find_next_zero_bit(bh->b_data,
 				offset + EXT4_SB(sb)->s_itb_per_group,
 				offset);
-	if (next_zero_bit >= offset + EXT4_SB(sb)->s_itb_per_group)
-		/* good bitmap for inode tables */
-		return 1;
+	/* good bitmap for inode tables */
+	if (next_zero_bit < offset + EXT4_SB(sb)->s_itb_per_group) {
+		ext4_warning(sb, "bad inode table block = %llu, offset = %d",
+			     bitmap_blk, (int) offset);
+		valid = 0;
+	}
 
-err_out:
-	ext4_error(sb, "Invalid block bitmap - block_group = %d, block = %llu",
-			block_group, bitmap_blk);
-	return 0;
+	if (!valid)
+		ext4_error(sb, "Invalid block bitmap - block_group = %d",
+			   block_group);
+	return valid;
 }
 /**
  * ext4_read_block_bitmap()



-- 
Bernd Schubert
DataDirect Networks
