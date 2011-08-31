From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH 6/6 v7] ext4: fix partial page writes
Date: Tue, 30 Aug 2011 17:28:33 -0700
Message-ID: <1314750513-10045-7-git-send-email-achender@linux.vnet.ibm.com>
References: <1314750513-10045-1-git-send-email-achender@linux.vnet.ibm.com>
Cc: Allison Henderson <achender@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:35778 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754152Ab1HaAZ3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 30 Aug 2011 20:25:29 -0400
Received: from /spool/local
	by us.ibm.com with XMail ESMTP
	for <linux-ext4@vger.kernel.org> from <achender@linux.vnet.ibm.com>;
	Tue, 30 Aug 2011 20:25:29 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p7V0PQ6V241088
	for <linux-ext4@vger.kernel.org>; Tue, 30 Aug 2011 20:25:26 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p7V0PPYO001636
	for <linux-ext4@vger.kernel.org>; Tue, 30 Aug 2011 21:25:26 -0300
In-Reply-To: <1314750513-10045-1-git-send-email-achender@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

While running extended fsx tests to verify the preceeding patches,
a similar bug was also found in the write operation

When ever a write operation begins or ends in a hole,
or extends EOF, the partial page contained in the hole
or beyond EOF needs to be zeroed out.

To correct this the new ext4_discard_partial_page_buffers_no_lock
routine is used to zero out the partial page, but only for buffer
heads that are already unmapped.

Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>
---
:100644 100644 8c91991... 88db8e5... M	fs/ext4/inode.c
 fs/ext4/inode.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 8c91991..88db8e5 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2258,6 +2258,7 @@ static int ext4_da_write_begin(struct file *file, struct address_space *mapping,
 	pgoff_t index;
 	struct inode *inode = mapping->host;
 	handle_t *handle;
+	loff_t page_len;
 
 	index = pos >> PAGE_CACHE_SHIFT;
 
@@ -2304,6 +2305,13 @@ retry:
 		 */
 		if (pos + len > inode->i_size)
 			ext4_truncate_failed_write(inode);
+	} else {
+		page_len = pos & (PAGE_CACHE_SIZE - 1);
+		if (page_len > 0) {
+			ret = ext4_discard_partial_page_buffers_no_lock(handle,
+				inode, page, pos - page_len, page_len,
+				EXT4_DSCRD_PARTIAL_PG_ZERO_UNMAPED);
+		}
 	}
 
 	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
@@ -2346,6 +2354,7 @@ static int ext4_da_write_end(struct file *file,
 	loff_t new_i_size;
 	unsigned long start, end;
 	int write_mode = (int)(unsigned long)fsdata;
+	loff_t page_len;
 
 	if (write_mode == FALL_BACK_TO_NONDELALLOC) {
 		if (ext4_should_order_data(inode)) {
@@ -2394,6 +2403,16 @@ static int ext4_da_write_end(struct file *file,
 	}
 	ret2 = generic_write_end(file, mapping, pos, len, copied,
 							page, fsdata);
+
+	page_len = PAGE_CACHE_SIZE -
+			((pos + copied - 1) & (PAGE_CACHE_SIZE - 1));
+
+	if (page_len > 0) {
+		ret = ext4_discard_partial_page_buffers_no_lock(handle,
+			inode, page, pos + copied - 1, page_len,
+			EXT4_DSCRD_PARTIAL_PG_ZERO_UNMAPED);
+	}
+
 	copied = ret2;
 	if (ret2 < 0)
 		ret = ret2;
-- 
1.7.1

