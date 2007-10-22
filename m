From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Return after ext4_error in case of failures
Date: Mon, 22 Oct 2007 20:25:07 +0530
Message-ID: <1193064907-7154-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1193064907-7154-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1193064907-7154-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:60427 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbXJVOzi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Oct 2007 10:55:38 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp01.au.ibm.com (8.13.1/8.13.1) with ESMTP id l9MEtsUT007604
	for <linux-ext4@vger.kernel.org>; Tue, 23 Oct 2007 00:55:54 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9MEtbEu2510908
	for <linux-ext4@vger.kernel.org>; Tue, 23 Oct 2007 00:55:37 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9MEtKhL021107
	for <linux-ext4@vger.kernel.org>; Tue, 23 Oct 2007 00:55:20 +1000
In-Reply-To: <1193064907-7154-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This fix some instances where we were continuing
after calling ext4_error. ext4_error call panic
only if errors=panic mount option is set. So
we need to make sure we return correctly after
ext4_error call

Reported by: Adrian Bunk <bunk@kernel.org>

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/balloc.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index e906b65..8517dd7 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -234,11 +234,13 @@ read_block_bitmap(struct super_block *sb, unsigned int block_group)
 	} else {
 		bh = sb_bread(sb, bitmap_blk);
 	}
-	if (!bh)
+	if (!bh) {
 		ext4_error (sb, __FUNCTION__,
 			    "Cannot read block bitmap - "
 			    "block_group = %d, block_bitmap = %llu",
 			    block_group, bitmap_blk);
+		return NULL;
+	}
 
 	/* check whether block bitmap block number is set */
 	if (!block_in_use(bitmap_blk, sb, bh->b_data)) {
@@ -628,11 +630,13 @@ do_more:
 	    in_range(ext4_inode_bitmap(sb, desc), block, count) ||
 	    in_range(block, ext4_inode_table(sb, desc), sbi->s_itb_per_group) ||
 	    in_range(block + count - 1, ext4_inode_table(sb, desc),
-		     sbi->s_itb_per_group))
+		     sbi->s_itb_per_group)) {
 		ext4_error (sb, "ext4_free_blocks",
 			    "Freeing blocks in system zones - "
 			    "Block = %llu, count = %lu",
 			    block, count);
+		goto error_return;
+	}
 
 	/*
 	 * We are about to start releasing blocks in the bitmap,
@@ -1733,11 +1737,13 @@ allocated:
 	    in_range(ret_block, ext4_inode_table(sb, gdp),
 		     EXT4_SB(sb)->s_itb_per_group) ||
 	    in_range(ret_block + num - 1, ext4_inode_table(sb, gdp),
-		     EXT4_SB(sb)->s_itb_per_group))
+		     EXT4_SB(sb)->s_itb_per_group)) {
 		ext4_error(sb, "ext4_new_block",
 			    "Allocating block in system zone - "
 			    "blocks from %llu, length %lu",
 			     ret_block, num);
+		goto out;
+	}
 
 	performed_allocation = 1;
 
-- 
1.5.3.4.206.g58ba4-dirty
