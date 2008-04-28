From: akpm@linux-foundation.org
Subject: [patch 279/307] ext3: retry block allocation if new blocks are allocated from system zone
Date: Mon, 28 Apr 2008 02:16:14 -0700
Message-ID: <200804280916.m3S9GEmJ019176@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com,
	linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39679 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762264AbYD1JVG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Apr 2008 05:21:06 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

If the block allocator gets blocks out of system zone ext3 calls ext3_error. 
But if the file system is mounted with errors=continue retry block allocation.
 We need to mark the system zone blocks as in use to make sure retry don't
pick them again

System zone is the block range mapping block bitmap, inode bitmap and inode
table.

[akpm@linux-foundation.org: fix typo in comment]
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/balloc.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff -puN fs/ext3/balloc.c~ext3-retry-block-allocation-if-new-blocks-are-allocated-from-system-zone fs/ext3/balloc.c
--- a/fs/ext3/balloc.c~ext3-retry-block-allocation-if-new-blocks-are-allocated-from-system-zone
+++ a/fs/ext3/balloc.c
@@ -164,10 +164,11 @@ read_block_bitmap(struct super_block *sb
 			    block_group, le32_to_cpu(desc->bg_block_bitmap));
 		return NULL;
 	}
-	if (!ext3_valid_block_bitmap(sb, desc, block_group, bh)) {
-		brelse(bh);
-		return NULL;
-	}
+	ext3_valid_block_bitmap(sb, desc, block_group, bh);
+	/*
+	 * file system mounted not to panic on error, continue with corrupt
+	 * bitmap
+	 */
 	return bh;
 }
 /*
@@ -1641,7 +1642,11 @@ allocated:
 			    "Allocating block in system zone - "
 			    "blocks from "E3FSBLK", length %lu",
 			     ret_block, num);
-		goto out;
+		/*
+		 * claim_block() marked the blocks we allocated as in use. So we
+		 * may want to selectively mark some of the blocks as free.
+		 */
+		goto retry_alloc;
 	}
 
 	performed_allocation = 1;
_
