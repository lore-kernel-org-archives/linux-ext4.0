From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH 2/6 v5] ext4: fix xfstests 75, 112, 127 punch hole failure
Date: Sat, 20 Aug 2011 19:29:43 -0700
Message-ID: <1313893787-25460-3-git-send-email-achender@linux.vnet.ibm.com>
References: <1313893787-25460-1-git-send-email-achender@linux.vnet.ibm.com>
Cc: Allison Henderson <achender@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:54120 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302Ab1HUC0m (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 20 Aug 2011 22:26:42 -0400
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by e5.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p7L1umtG021095
	for <linux-ext4@vger.kernel.org>; Sat, 20 Aug 2011 21:56:48 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p7L2Qf662904300
	for <linux-ext4@vger.kernel.org>; Sat, 20 Aug 2011 22:26:41 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p7L2Qe8R008788
	for <linux-ext4@vger.kernel.org>; Sat, 20 Aug 2011 22:26:40 -0400
In-Reply-To: <1313893787-25460-1-git-send-email-achender@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch addresses a bug found by xfstests 75, 112, 127
when blocksize = 1k

This bug happens because the punch hole code only zeros
out non block aligned regions of the page.  This means that if the
blocks are smaller than a page, then the block aligned regions of
the page inside the hole are left un-zeroed, and their buffer heads
are still mapped.  This bug is corrected by using
ext4_discard_partial_page_buffers to properly zero the partial page
at the head and tail of the hole, and unmap the corresponding buffer
heads

Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>
---
:100644 100644 4d73e11... cd58117... M	fs/ext4/extents.c
 fs/ext4/extents.c |   48 ++++++++++++++++++++++++++++++------------------
 1 files changed, 30 insertions(+), 18 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 4d73e11..cd58117 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4157,7 +4157,7 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
 	struct address_space *mapping = inode->i_mapping;
 	struct ext4_map_blocks map;
 	handle_t *handle;
-	loff_t first_block_offset, last_block_offset, block_len;
+	loff_t first_block_offset, last_block_offset, page_len;
 	loff_t first_page, last_page, first_page_offset, last_page_offset;
 	int ret, credits, blocks_released, err = 0;
 
@@ -4206,24 +4206,36 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
 		goto out;
 
 	/*
-	 * Now we need to zero out the un block aligned data.
-	 * If the file is smaller than a block, just
-	 * zero out the middle
+	 * Now we need to zero out the non-page-aligned data in the
+	 * pages at the start and tail of the hole, and unmap the buffer
+	 * heads for the block aligned regions of the page that were
+	 * completely zeroed.
 	 */
-	if (first_block > last_block)
-		ext4_block_zero_page_range(handle, mapping, offset, length);
-	else {
-		/* zero out the head of the hole before the first block */
-		block_len  = first_block_offset - offset;
-		if (block_len > 0)
-			ext4_block_zero_page_range(handle, mapping,
-						   offset, block_len);
-
-		/* zero out the tail of the hole after the last block */
-		block_len = offset + length - last_block_offset;
-		if (block_len > 0) {
-			ext4_block_zero_page_range(handle, mapping,
-					last_block_offset, block_len);
+	if (first_page > last_page) {
+		/*
+		 * If the file space being truncated is contained within a page
+		 * just zero out and unmap the middle of that page
+		 */
+		ext4_discard_partial_page_buffers(handle,
+			mapping, offset, length, 0);
+	} else {
+		/*
+		 * zero out and unmap the partial page that contains
+		 * the start of the hole
+		 */
+		page_len  = first_page_offset - offset;
+		if (page_len > 0)
+			ext4_discard_partial_page_buffers(handle, mapping,
+						   offset, page_len, 0);
+
+		/*
+		 * zero out and unmap the partial page that contains
+		 * the end of the hole
+		 */
+		page_len = offset + length - last_page_offset;
+		if (page_len > 0) {
+			ext4_discard_partial_page_buffers(handle, mapping,
+					last_page_offset, page_len, 0);
 		}
 	}
 
-- 
1.7.1

