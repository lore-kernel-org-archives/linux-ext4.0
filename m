From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH 6/6 v5] ext4: fix partial page writes
Date: Sat, 20 Aug 2011 19:29:47 -0700
Message-ID: <1313893787-25460-7-git-send-email-achender@linux.vnet.ibm.com>
References: <1313893787-25460-1-git-send-email-achender@linux.vnet.ibm.com>
Cc: Allison Henderson <achender@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:58602 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753933Ab1HUC0o (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 20 Aug 2011 22:26:44 -0400
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by e9.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p7L1r5Ha005258
	for <linux-ext4@vger.kernel.org>; Sat, 20 Aug 2011 21:53:05 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p7L2QhdK3330214
	for <linux-ext4@vger.kernel.org>; Sat, 20 Aug 2011 22:26:43 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p7L2Qgj6008841
	for <linux-ext4@vger.kernel.org>; Sat, 20 Aug 2011 22:26:43 -0400
In-Reply-To: <1313893787-25460-1-git-send-email-achender@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

These bugs were also found during extended fsx testing
for blocksize = 1k.

When ever a write operation begins or ends in a hole,
or extends EOF, the partial page contained in the hole
or beyond EOF needs to be zeroed out.

To correct this the new ext4_discard_partial_page_buffers_no_lock
routine is used to zero out the partial page, but only for buffer
heads that are already unmapped.

Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>
---
:100644 100644 c1b42cb... 78c723b... M	fs/ext4/inode.c
 fs/ext4/inode.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c1b42cb..78c723b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2214,6 +2214,7 @@ static int ext4_da_write_begin(struct file *file, struct address_space *mapping,
 	pgoff_t index;
 	struct inode *inode = mapping->host;
 	handle_t *handle;
+	loff_t page_len;
 
 	index = pos >> PAGE_CACHE_SHIFT;
 
@@ -2260,6 +2261,11 @@ retry:
 		 */
 		if (pos + len > inode->i_size)
 			ext4_truncate_failed_write(inode);
+	} else {
+		page_len = pos & (PAGE_CACHE_SIZE - 1);
+		ext4_discard_partial_page_buffers_no_lock(handle,
+			inode, page, pos - page_len, page_len,
+			EXT4_DSCRD_PARTIAL_PG_ZERO_UNMAPED);
 	}
 
 	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
@@ -2302,6 +2308,7 @@ static int ext4_da_write_end(struct file *file,
 	loff_t new_i_size;
 	unsigned long start, end;
 	int write_mode = (int)(unsigned long)fsdata;
+	loff_t page_len;
 
 	if (write_mode == FALL_BACK_TO_NONDELALLOC) {
 		if (ext4_should_order_data(inode)) {
@@ -2350,6 +2357,14 @@ static int ext4_da_write_end(struct file *file,
 	}
 	ret2 = generic_write_end(file, mapping, pos, len, copied,
 							page, fsdata);
+
+	page_len = PAGE_CACHE_SIZE -
+			((pos + copied) & (PAGE_CACHE_SIZE - 1));
+
+	ext4_discard_partial_page_buffers_no_lock(handle,
+		inode, page, pos + copied, page_len,
+		EXT4_DSCRD_PARTIAL_PG_ZERO_UNMAPED);
+
 	copied = ret2;
 	if (ret2 < 0)
 		ret = ret2;
-- 
1.7.1

