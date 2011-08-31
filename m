From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH 2/6 v7] ext4: fix xfstests 75, 112, 127 punch hole failure
Date: Tue, 30 Aug 2011 17:28:29 -0700
Message-ID: <1314750513-10045-3-git-send-email-achender@linux.vnet.ibm.com>
References: <1314750513-10045-1-git-send-email-achender@linux.vnet.ibm.com>
Cc: Allison Henderson <achender@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:35761 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754132Ab1HaAZ0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 30 Aug 2011 20:25:26 -0400
Received: from /spool/local
	by us.ibm.com with XMail ESMTP
	for <linux-ext4@vger.kernel.org> from <achender@linux.vnet.ibm.com>;
	Tue, 30 Aug 2011 20:25:26 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p7V0PNRi197462
	for <linux-ext4@vger.kernel.org>; Tue, 30 Aug 2011 20:25:23 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p7V0PMkg001544
	for <linux-ext4@vger.kernel.org>; Tue, 30 Aug 2011 21:25:23 -0300
In-Reply-To: <1314750513-10045-1-git-send-email-achender@linux.vnet.ibm.com>
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

This patch also addresses a bug reported by Lukas while working on a
new patch to add discard support for loop devices using punch hole.
The bug happened because of the first and last block number
needed to be cast to a larger data type before calculating the
byte offset, but since now we only need the byte offsets of the
pages, we no longer even need to be calculating the byte offsets
of the blocks.  The code to do the block offset calculations is
removed in this patch.

Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>
---
:100644 100644 57cf568... 18f7e04... M	fs/ext4/extents.c
 fs/ext4/extents.c |   61 +++++++++++++++++++++++++++++++++-------------------
 1 files changed, 39 insertions(+), 22 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 57cf568..18f7e04 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4162,17 +4162,14 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
 	struct address_space *mapping = inode->i_mapping;
 	struct ext4_map_blocks map;
 	handle_t *handle;
-	loff_t first_block_offset, last_block_offset, block_len;
-	loff_t first_page, last_page, first_page_offset, last_page_offset;
+	loff_t first_page, last_page, page_len;
+	loff_t first_page_offset, last_page_offset;
 	int ret, credits, blocks_released, err = 0;
 
 	first_block = (offset + sb->s_blocksize - 1) >>
 		EXT4_BLOCK_SIZE_BITS(sb);
 	last_block = (offset + length) >> EXT4_BLOCK_SIZE_BITS(sb);
 
-	first_block_offset = first_block << EXT4_BLOCK_SIZE_BITS(sb);
-	last_block_offset = last_block << EXT4_BLOCK_SIZE_BITS(sb);
-
 	first_page = (offset + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
 	last_page = (offset + length) >> PAGE_CACHE_SHIFT;
 
@@ -4211,24 +4208,44 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
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
+		err = ext4_discard_partial_page_buffers(handle,
+			mapping, offset, length, 0);
+
+		if (err)
+			goto out;
+	} else {
+		/*
+		 * zero out and unmap the partial page that contains
+		 * the start of the hole
+		 */
+		page_len  = first_page_offset - offset;
+		if (page_len > 0) {
+			err = ext4_discard_partial_page_buffers(handle, mapping,
+						   offset, page_len, 0);
+			if (err)
+				goto out;
+		}
+
+		/*
+		 * zero out and unmap the partial page that contains
+		 * the end of the hole
+		 */
+		page_len = offset + length - last_page_offset;
+		if (page_len > 0) {
+			err = ext4_discard_partial_page_buffers(handle, mapping,
+					last_page_offset, page_len, 0);
+			if (err)
+				goto out;
 		}
 	}
 
-- 
1.7.1

