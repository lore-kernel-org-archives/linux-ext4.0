From: Mingming Cao <cmm@us.ibm.com>
Subject: [PATCH-v2] ext4: Handling preallocated blocks in delayed allocation
Date: Fri, 29 Feb 2008 10:44:35 -0800
Message-ID: <1204310675.3629.9.camel@localhost.localdomain>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:60486 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757822AbYB2SpK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Feb 2008 13:45:10 -0500
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m1TIjATC017337
	for <linux-ext4@vger.kernel.org>; Fri, 29 Feb 2008 13:45:10 -0500
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1TIj6SF219674
	for <linux-ext4@vger.kernel.org>; Fri, 29 Feb 2008 11:45:06 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1TIj5h5007613
	for <linux-ext4@vger.kernel.org>; Fri, 29 Feb 2008 11:45:05 -0700
Received: from [9.67.8.4] (wecm-9-67-8-4.wecm.ibm.com [9.67.8.4])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id m1TIj44k007544
	for <linux-ext4@vger.kernel.org>; Fri, 29 Feb 2008 11:45:04 -0700
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4: Handling preallocated blocks in delayed allocation
From: Mingming Cao <cmm@us.ibm.com>

This patch fix ext4 delayed allocation that allows it
avoid doing delayed allocation handling for blocks that
are already preallocated on disk.

With delayed allocation, at write_begin() time, 
ext4_get_blocks_wrap() now is only doing block map with create = 0.
ext4_get_blocks_wrap() returns 0 if the blocks are not allocated
or preallocated().

If the blocks are prea-allocated, the resulting buffer head
is not mapped marked, but ext4_get_blocks_wrap() returns the number of
blocks are actually being preallocated.

Right now delayed allocation mistream pre-allocated blocks as
un-allocated as the buffer head is unmapped.

This patch fix this by checking the number of blocks
returned by ext4_get_blocks_wrap() rather than checking
if buffer head is mapped or not.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/ext4/inode.c |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

Index: linux-2.6.25-rc3/fs/ext4/inode.c
===================================================================
--- linux-2.6.25-rc3.orig/fs/ext4/inode.c	2008-02-29 10:17:21.000000000 -0800
+++ linux-2.6.25-rc3/fs/ext4/inode.c	2008-02-29 10:40:01.000000000 -0800
@@ -1343,7 +1343,7 @@ static int ext4_journalled_write_end(str
 }
 
 /*
- * this is a special callback for ->prepare_write() only
+ * this is a special callback for ->write_begin() only
  * it's intention is to return mapped block or reserve space
  */
 static int ext4_da_get_block_prep(struct inode *inode, sector_t iblock,
@@ -1354,24 +1354,24 @@ static int ext4_da_get_block_prep(struct
 	BUG_ON(create == 0);
 	BUG_ON(bh_result->b_size != inode->i_sb->s_blocksize);
 
-	/* first, we need to know whether the block is allocated already
-	 * XXX: when the filesystem has a lot of free blocks, we could
-	 * reserve even allocated blocks to save this lookup */
+	/*
+	 * first, we need to know whether the block is allocated already
+	 * preallocated blocks are unmapped but should treated
+	 * the same as allocated blocks.
+	 */
 	ret = ext4_get_blocks_wrap(NULL, inode, iblock, 1,  bh_result, 0, 0);
-	if (ret >= 0) {
-		if (buffer_mapped(bh_result)) {
-			bh_result->b_size = (ret << inode->i_blkbits);
-		} else {
-			/* the block isn't allocated yet, let's reserve space */
-			/* XXX: call reservation here */
-			/*
-			 * XXX: __block_prepare_write() unmaps passed block,
-			 * is it OK?
-			 */
-			map_bh(bh_result, inode->i_sb, 0);
-			set_buffer_new(bh_result);
-			set_buffer_delay(bh_result);
-		}
+	if (ret == 0) {
+		/* the block isn't allocated yet, let's reserve space */
+		/* XXX: call reservation here */
+		/*
+		 * XXX: __block_prepare_write() unmaps passed block,
+		 * is it OK?
+		 */
+		map_bh(bh_result, inode->i_sb, 0);
+		set_buffer_new(bh_result);
+		set_buffer_delay(bh_result);
+	} else if (ret > 0) {
+		bh_result->b_size = (ret << inode->i_blkbits);
 		ret = 0;
 	}
 


