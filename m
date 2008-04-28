From: akpm@linux-foundation.org
Subject: [patch 266/307] ext2: retry block allocation if new blocks are allocated from system zone
Date: Mon, 28 Apr 2008 02:16:04 -0700
Message-ID: <200804280916.m3S9G41J019117@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com,
	linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39776 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761902AbYD1JU6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Apr 2008 05:20:58 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

If the block allocator gets blocks out of system zone ext2 calls ext2_error. 
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

 fs/ext2/balloc.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff -puN fs/ext2/balloc.c~ext2-retry-block-allocation-if-new-blocks-are-allocated-from-system-zone fs/ext2/balloc.c
--- a/fs/ext2/balloc.c~ext2-retry-block-allocation-if-new-blocks-are-allocated-from-system-zone
+++ a/fs/ext2/balloc.c
@@ -149,11 +149,12 @@ read_block_bitmap(struct super_block *sb
 			    block_group, le32_to_cpu(desc->bg_block_bitmap));
 		return NULL;
 	}
-	if (!ext2_valid_block_bitmap(sb, desc, block_group, bh)) {
-		brelse(bh);
-		return NULL;
-	}
 
+	ext2_valid_block_bitmap(sb, desc, block_group, bh);
+	/*
+	 * file system mounted not to panic on error, continue with corrupt
+	 * bitmap
+	 */
 	return bh;
 }
 
@@ -1380,7 +1381,12 @@ allocated:
 			    "Allocating block in system zone - "
 			    "blocks from "E2FSBLK", length %lu",
 			    ret_block, num);
-		goto out;
+		/*
+		 * ext2_try_to_allocate marked the blocks we allocated as in
+		 * use.  So we may want to selectively mark some of the blocks
+		 * as free
+		 */
+		goto retry_alloc;
 	}
 
 	performed_allocation = 1;
_
