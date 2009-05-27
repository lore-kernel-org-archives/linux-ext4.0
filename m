From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 1/3] ext4: Don't look at buffer_heads outside i_size.
Date: Wed, 27 May 2009 21:28:06 +0530
Message-ID: <1243439888-22680-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com, jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:39392 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554AbZE0P6U (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 May 2009 11:58:20 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp03.in.ibm.com (8.13.1/8.13.1) with ESMTP id n4RFwIhn020346
	for <linux-ext4@vger.kernel.org>; Wed, 27 May 2009 21:28:18 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n4RFwHwQ716884
	for <linux-ext4@vger.kernel.org>; Wed, 27 May 2009 21:28:18 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.13.1/8.13.3) with ESMTP id n4RFwHkK019519
	for <linux-ext4@vger.kernel.org>; Thu, 28 May 2009 01:58:17 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Buffer heads outside i_size will be unmapped. So when we
are doing "walk_page_buffers" limit ourself to i_size.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/inode.c |   29 ++++++++++++++++++-----------
 1 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 3b07a6c..f0f0065 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2514,7 +2514,7 @@ static int ext4_da_writepage(struct page *page,
 		 * all are mapped and non delay. We don't want to
 		 * do block allocation here.
 		 */
-		ret = block_prepare_write(page, 0, PAGE_CACHE_SIZE,
+		ret = block_prepare_write(page, 0, len,
 					  noalloc_get_block_write);
 		if (!ret) {
 			page_bufs = page_buffers(page);
@@ -2536,7 +2536,7 @@ static int ext4_da_writepage(struct page *page,
 			return 0;
 		}
 		/* now mark the buffer_heads as dirty and uptodate */
-		block_commit_write(page, 0, PAGE_CACHE_SIZE);
+		block_commit_write(page, 0, len);
 	}
 
 	if (test_opt(inode->i_sb, NOBH) && ext4_should_writeback_data(inode))
@@ -3210,6 +3210,8 @@ static int ext4_normal_writepage(struct page *page,
 static int __ext4_journalled_writepage(struct page *page,
 				struct writeback_control *wbc)
 {
+	loff_t size;
+	unsigned int len;
 	struct address_space *mapping = page->mapping;
 	struct inode *inode = mapping->host;
 	struct buffer_head *page_bufs;
@@ -3217,14 +3219,19 @@ static int __ext4_journalled_writepage(struct page *page,
 	int ret = 0;
 	int err;
 
-	ret = block_prepare_write(page, 0, PAGE_CACHE_SIZE,
+	size = i_size_read(inode);
+	if (page->index == size >> PAGE_CACHE_SHIFT)
+		len = size & ~PAGE_CACHE_MASK;
+	else
+		len = PAGE_CACHE_SIZE;
+
+	ret = block_prepare_write(page, 0, len,
 				  noalloc_get_block_write);
 	if (ret != 0)
 		goto out_unlock;
 
 	page_bufs = page_buffers(page);
-	walk_page_buffers(handle, page_bufs, 0, PAGE_CACHE_SIZE, NULL,
-								bget_one);
+	walk_page_buffers(handle, page_bufs, 0, len, NULL, bget_one);
 	/* As soon as we unlock the page, it can go away, but we have
 	 * references to buffers so we are safe */
 	unlock_page(page);
@@ -3235,19 +3242,19 @@ static int __ext4_journalled_writepage(struct page *page,
 		goto out;
 	}
 
-	ret = walk_page_buffers(handle, page_bufs, 0,
-			PAGE_CACHE_SIZE, NULL, do_journal_get_write_access);
+	ret = walk_page_buffers(handle, page_bufs, 0, len,
+				NULL, do_journal_get_write_access);
 
-	err = walk_page_buffers(handle, page_bufs, 0,
-				PAGE_CACHE_SIZE, NULL, write_end_fn);
+	err = walk_page_buffers(handle, page_bufs, 0, len,
+				NULL, write_end_fn);
 	if (ret == 0)
 		ret = err;
 	err = ext4_journal_stop(handle);
 	if (!ret)
 		ret = err;
 
-	walk_page_buffers(handle, page_bufs, 0,
-				PAGE_CACHE_SIZE, NULL, bput_one);
+	walk_page_buffers(handle, page_bufs, 0, len,
+				NULL, bput_one);
 	EXT4_I(inode)->i_state |= EXT4_STATE_JDATA;
 	goto out;
 
-- 
1.6.3.1.145.gb74d77

