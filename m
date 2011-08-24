From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH 5/5 v6] ext4: fix partial page writes
Date: Wed, 24 Aug 2011 12:07:22 -0700
Message-ID: <1314212842-16741-6-git-send-email-achender@linux.vnet.ibm.com>
References: <1314212842-16741-1-git-send-email-achender@linux.vnet.ibm.com>
Cc: Allison Henderson <achender@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:34312 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753781Ab1HXTFC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 24 Aug 2011 15:05:02 -0400
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by e3.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p7OIeZN7009426
	for <linux-ext4@vger.kernel.org>; Wed, 24 Aug 2011 14:40:35 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p7OJ4ut5225148
	for <linux-ext4@vger.kernel.org>; Wed, 24 Aug 2011 15:04:57 -0400
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p7OD40jR024980
	for <linux-ext4@vger.kernel.org>; Wed, 24 Aug 2011 07:04:00 -0600
In-Reply-To: <1314212842-16741-1-git-send-email-achender@linux.vnet.ibm.com>
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
:100644 100644 6328428... 1674fa7... M	fs/ext4/inode.c
 fs/ext4/inode.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 6328428..1674fa7 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2214,6 +2214,7 @@ static int ext4_da_write_begin(struct file *file, struct address_space *mapping,
 	pgoff_t index;
 	struct inode *inode = mapping->host;
 	handle_t *handle;
+	loff_t page_len;
 
 	index = pos >> PAGE_CACHE_SHIFT;
 
@@ -2260,6 +2261,13 @@ retry:
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
@@ -2302,6 +2310,7 @@ static int ext4_da_write_end(struct file *file,
 	loff_t new_i_size;
 	unsigned long start, end;
 	int write_mode = (int)(unsigned long)fsdata;
+	loff_t page_len;
 
 	if (write_mode == FALL_BACK_TO_NONDELALLOC) {
 		if (ext4_should_order_data(inode)) {
@@ -2350,6 +2359,16 @@ static int ext4_da_write_end(struct file *file,
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

