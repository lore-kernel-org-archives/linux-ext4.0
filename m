From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext2: Return after ext2_error in case of failures
Date: Thu, 25 Oct 2007 10:23:48 +0530
Message-ID: <1193288030-7775-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1193288030-7775-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:60525 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbXJYFYo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Oct 2007 01:24:44 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id l9P4rt9G009266
	for <linux-ext4@vger.kernel.org>; Thu, 25 Oct 2007 14:53:55 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9P4ruve1871872
	for <linux-ext4@vger.kernel.org>; Thu, 25 Oct 2007 14:53:56 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9P4ruYm003404
	for <linux-ext4@vger.kernel.org>; Thu, 25 Oct 2007 14:53:57 +1000
In-Reply-To: <1193288030-7775-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This fix some instances where we were continuing
after calling ext2_error. ext2_error call panic
only if errors=panic mount option is set. So
we need to make sure we return correctly after
ext2_error call

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext2/balloc.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
index 18a42de..ed48553 100644
--- a/fs/ext2/balloc.c
+++ b/fs/ext2/balloc.c
@@ -96,11 +96,13 @@ read_block_bitmap(struct super_block *sb, unsigned int block_group)
 		return NULL;
 	bitmap_blk = le32_to_cpu(desc->bg_block_bitmap);
 	bh = sb_bread(sb, bitmap_blk);
-	if (!bh)
+	if (!bh) {
 		ext2_error (sb, __FUNCTION__,
 			    "Cannot read block bitmap - "
 			    "block_group = %d, block_bitmap = %u",
 			    block_group, le32_to_cpu(desc->bg_block_bitmap));
+		return NULL;
+	}
 
 	/* check whether block bitmap block number is set */
 	if (!block_in_use(bitmap_blk, sb, bh->b_data)) {
@@ -513,11 +515,13 @@ do_more:
 	    in_range (block, le32_to_cpu(desc->bg_inode_table),
 		      sbi->s_itb_per_group) ||
 	    in_range (block + count - 1, le32_to_cpu(desc->bg_inode_table),
-		      sbi->s_itb_per_group))
+		      sbi->s_itb_per_group)) {
 		ext2_error (sb, "ext2_free_blocks",
 			    "Freeing blocks in system zones - "
 			    "Block = %lu, count = %lu",
 			    block, count);
+		goto error_return;
+	}
 
 	for (i = 0, group_freed = 0; i < count; i++) {
 		if (!ext2_clear_bit_atomic(sb_bgl_lock(sbi, block_group),
@@ -1350,11 +1354,13 @@ allocated:
 	    in_range(ret_block, le32_to_cpu(gdp->bg_inode_table),
 		      EXT2_SB(sb)->s_itb_per_group) ||
 	    in_range(ret_block + num - 1, le32_to_cpu(gdp->bg_inode_table),
-		      EXT2_SB(sb)->s_itb_per_group))
+		      EXT2_SB(sb)->s_itb_per_group)) {
 		ext2_error(sb, "ext2_new_blocks",
 			    "Allocating block in system zone - "
 			    "blocks from "E2FSBLK", length %lu",
 			    ret_block, num);
+		goto out;
+	}
 
 	performed_allocation = 1;
 
-- 
1.5.3.4.319.gdd817-dirty
