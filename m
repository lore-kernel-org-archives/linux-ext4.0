From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext3: Return after ext3_error in case of failures
Date: Thu, 25 Oct 2007 10:23:47 +0530
Message-ID: <1193288030-7775-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:37573 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbXJYEx5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Oct 2007 00:53:57 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp01.au.ibm.com (8.13.1/8.13.1) with ESMTP id l9P4sCBn010349
	for <linux-ext4@vger.kernel.org>; Thu, 25 Oct 2007 14:54:12 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9P4vTcl215150
	for <linux-ext4@vger.kernel.org>; Thu, 25 Oct 2007 14:57:29 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9P4rsSq003352
	for <linux-ext4@vger.kernel.org>; Thu, 25 Oct 2007 14:53:54 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This fix some instances where we were continuing
after calling ext3_error. ext3_error calls panic
only if errors=panic mount option is set. So
we need to make sure we return correctly after
ext3_error call

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext3/balloc.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
index 7a87d15..4cc1091 100644
--- a/fs/ext3/balloc.c
+++ b/fs/ext3/balloc.c
@@ -111,11 +111,13 @@ read_block_bitmap(struct super_block *sb, unsigned int block_group)
 		return NULL;
 	bitmap_blk = le32_to_cpu(desc->bg_block_bitmap);
 	bh = sb_bread(sb, bitmap_blk);
-	if (!bh)
+	if (!bh) {
 		ext3_error (sb, __FUNCTION__,
 			    "Cannot read block bitmap - "
 			    "block_group = %d, block_bitmap = %u",
 			    block_group, le32_to_cpu(desc->bg_block_bitmap));
+		return NULL;
+	}
 
 	/* check whether block bitmap block number is set */
 	if (!block_in_use(bitmap_blk, sb, bh->b_data)) {
@@ -507,11 +509,13 @@ do_more:
 	    in_range (block, le32_to_cpu(desc->bg_inode_table),
 		      sbi->s_itb_per_group) ||
 	    in_range (block + count - 1, le32_to_cpu(desc->bg_inode_table),
-		      sbi->s_itb_per_group))
+		      sbi->s_itb_per_group)) {
 		ext3_error (sb, "ext3_free_blocks",
 			    "Freeing blocks in system zones - "
 			    "Block = "E3FSBLK", count = %lu",
 			    block, count);
+		goto error_return;
+	}
 
 	/*
 	 * We are about to start releasing blocks in the bitmap,
@@ -1614,11 +1618,13 @@ allocated:
 	    in_range(ret_block, le32_to_cpu(gdp->bg_inode_table),
 		      EXT3_SB(sb)->s_itb_per_group) ||
 	    in_range(ret_block + num - 1, le32_to_cpu(gdp->bg_inode_table),
-		      EXT3_SB(sb)->s_itb_per_group))
+		      EXT3_SB(sb)->s_itb_per_group)) {
 		ext3_error(sb, "ext3_new_block",
 			    "Allocating block in system zone - "
 			    "blocks from "E3FSBLK", length %lu",
 			     ret_block, num);
+		goto out;
+	}
 
 	performed_allocation = 1;
 
-- 
1.5.3.4.319.gdd817-dirty
