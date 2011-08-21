From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH 3/6 v5] ext4: fix 2nd xfstests 127 punch hole failure
Date: Sat, 20 Aug 2011 19:29:44 -0700
Message-ID: <1313893787-25460-4-git-send-email-achender@linux.vnet.ibm.com>
References: <1313893787-25460-1-git-send-email-achender@linux.vnet.ibm.com>
Cc: Allison Henderson <achender@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:44031 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753933Ab1HUC0m (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 20 Aug 2011 22:26:42 -0400
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by e2.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p7L24sxx023308
	for <linux-ext4@vger.kernel.org>; Sat, 20 Aug 2011 22:04:54 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p7L2Qfr3260690
	for <linux-ext4@vger.kernel.org>; Sat, 20 Aug 2011 22:26:41 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p7L2Qf6Z008798
	for <linux-ext4@vger.kernel.org>; Sat, 20 Aug 2011 22:26:41 -0400
In-Reply-To: <1313893787-25460-1-git-send-email-achender@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch fixes a second punch hole bug found by xfstests 127.

This bug happens because punch hole needs to flush the pages
of the hole to avoid race conditions.  But if the end of the
hole is in the same page as i_size, the buffer heads beyond
i_size need to be unmapped and the page needs to be zeroed
after it is flushed.

To correct this, the new ext4_discard_partial_page_buffers
routine is used to zero and unmap the partial page
beyond i_size if the end of the hole appears in the same
page as i_size.

The code has also been optimized to set the end of the hole
to the page after i_size if the specified hole exceeds i_size,
and the code that flushes the pages has been simplified.

Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>
---
:100644 100644 cd58117... 0d7617d... M	fs/ext4/extents.c
 fs/ext4/extents.c |   38 ++++++++++++++++++++++++++++++++++----
 1 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index cd58117..0d7617d 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4161,6 +4161,20 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
 	loff_t first_page, last_page, first_page_offset, last_page_offset;
 	int ret, credits, blocks_released, err = 0;
 
+	/* No need to punch hole beyond i_size */
+	if (offset >= inode->i_size)
+		return 0;
+
+	/*
+	 * If the hole extends beyond i_size, set the hole
+	 * to end after the page that contains i_size
+	 */
+	if (offset + length > inode->i_size) {
+		length = inode->i_size +
+		   PAGE_CACHE_SIZE - (inode->i_size & (PAGE_CACHE_SIZE - 1)) -
+		   offset;
+	}
+
 	first_block = (offset + sb->s_blocksize - 1) >>
 		EXT4_BLOCK_SIZE_BITS(sb);
 	last_block = (offset + length) >> EXT4_BLOCK_SIZE_BITS(sb);
@@ -4180,11 +4194,10 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
 	 */
 	if (mapping->nrpages && mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
 		err = filemap_write_and_wait_range(mapping,
-			first_page_offset == 0 ? 0 : first_page_offset-1,
-			last_page_offset);
+			offset, offset + length - 1);
 
-			if (err)
-				return err;
+		if (err)
+			return err;
 	}
 
 	/* Now release the pages */
@@ -4239,6 +4252,23 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
 		}
 	}
 
+
+	/*
+	 * If i_size is contained in the last page, we need to
+	 * unmap and zero the partial page after i_size
+	 */
+	if (inode->i_size >> PAGE_CACHE_SHIFT == last_page &&
+	   inode->i_size % PAGE_CACHE_SIZE != 0) {
+
+		page_len = PAGE_CACHE_SIZE -
+			(inode->i_size & (PAGE_CACHE_SIZE - 1));
+
+		if (page_len > 0) {
+			ext4_discard_partial_page_buffers(handle,
+			  mapping, inode->i_size, page_len, 0);
+		}
+	}
+
 	/* If there are no blocks to remove, return now */
 	if (first_block >= last_block)
 		goto out;
-- 
1.7.1

