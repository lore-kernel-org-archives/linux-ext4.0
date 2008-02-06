From: akpm@linux-foundation.org
Subject: [patch 250/260] ext3: return after ext3_error in case of failures
Date: Wed, 06 Feb 2008 01:40:13 -0800
Message-ID: <200802060939.m169dsEf004787@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com,
	linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37495 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760663AbYBFKEm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Feb 2008 05:04:42 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

This fixes some instances where we were continuing after calling
ext3_error.  ext3_error calls panic only if errors=panic mount option is
set.  So we need to make sure we return correctly after ext3_error call

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/balloc.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN fs/ext3/balloc.c~ext3-return-after-ext3_error-in-case-of-failures fs/ext3/balloc.c
--- a/fs/ext3/balloc.c~ext3-return-after-ext3_error-in-case-of-failures
+++ a/fs/ext3/balloc.c
@@ -530,11 +530,13 @@ do_more:
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
@@ -1637,11 +1639,13 @@ allocated:
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
 
_
