From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 3/5] ext4: fix block bitmap validation when bigalloc,
 ^flex_bg
Date: Thu, 01 May 2014 16:17:40 -0700
Message-ID: <20140501231740.892.50993.stgit@birch.djwong.org>
References: <20140501231720.892.58712.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29551 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbaEAXRp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 May 2014 19:17:45 -0400
In-Reply-To: <20140501231720.892.58712.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On a bigalloc,^flex_bg filesystem, the ext4_valid_block_bitmap
function fails to convert from blocks to clusters when spot-checking
the validity of the bitmap block that we've just read from disk.  This
causes ext4 to think that the bitmap is garbage, which results in the
block group being taken offline when it's not necessary.  Add in the
necessary EXT4_B2C() calls to perform the conversions.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ext4/balloc.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)


diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index a4950e9..59c3ba8 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -307,6 +307,7 @@ static ext4_fsblk_t ext4_valid_block_bitmap(struct super_block *sb,
 					    ext4_group_t block_group,
 					    struct buffer_head *bh)
 {
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	ext4_grpblk_t offset;
 	ext4_grpblk_t next_zero_bit;
 	ext4_fsblk_t blk;
@@ -326,14 +327,14 @@ static ext4_fsblk_t ext4_valid_block_bitmap(struct super_block *sb,
 	/* check whether block bitmap block number is set */
 	blk = ext4_block_bitmap(sb, desc);
 	offset = blk - group_first_block;
-	if (!ext4_test_bit(offset, bh->b_data))
+	if (!ext4_test_bit(EXT4_B2C(sbi, offset), bh->b_data))
 		/* bad block bitmap */
 		return blk;
 
 	/* check whether the inode bitmap block number is set */
 	blk = ext4_inode_bitmap(sb, desc);
 	offset = blk - group_first_block;
-	if (!ext4_test_bit(offset, bh->b_data))
+	if (!ext4_test_bit(EXT4_B2C(sbi, offset), bh->b_data))
 		/* bad block bitmap */
 		return blk;
 
@@ -341,9 +342,10 @@ static ext4_fsblk_t ext4_valid_block_bitmap(struct super_block *sb,
 	blk = ext4_inode_table(sb, desc);
 	offset = blk - group_first_block;
 	next_zero_bit = ext4_find_next_zero_bit(bh->b_data,
-				offset + EXT4_SB(sb)->s_itb_per_group,
-				offset);
-	if (next_zero_bit < offset + EXT4_SB(sb)->s_itb_per_group)
+			EXT4_B2C(sbi, offset + EXT4_SB(sb)->s_itb_per_group),
+			EXT4_B2C(sbi, offset));
+	if (next_zero_bit <
+	    EXT4_B2C(sbi, offset + EXT4_SB(sb)->s_itb_per_group))
 		/* bad bitmap for inode tables */
 		return blk;
 	return 0;

