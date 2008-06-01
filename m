From: Mingming Cao <cmm@us.ibm.com>
Subject: [PATCH] ext4: Need clear buffer_delay after page writeout for
	delayed allocation
Date: Sun, 01 Jun 2008 14:10:02 -0700
Message-ID: <1212354602.4368.12.camel@localhost.localdomain>
References: <1212154769-16486-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: jack@suse.cz, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:36940 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbYFAVKK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Jun 2008 17:10:10 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m51LA90u024406
	for <linux-ext4@vger.kernel.org>; Sun, 1 Jun 2008 17:10:09 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m51LA9TL092342
	for <linux-ext4@vger.kernel.org>; Sun, 1 Jun 2008 15:10:09 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m51LA8dh002313
	for <linux-ext4@vger.kernel.org>; Sun, 1 Jun 2008 15:10:09 -0600
In-Reply-To: <1212154769-16486-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4:  Need clear buffer_delay after page writeout for delayed allocation

From: Mingming Cao <cmm@us.ibm.com>

Need clear buffer_delay in ext4_da_writepage() after page has been writeout

Signed-off-by: Mingming Cao <cmm@us.ibm.com>

---
 fs/ext4/inode.c |   27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

Index: linux-2.6.26-rc4/fs/ext4/inode.c
===================================================================
--- linux-2.6.26-rc4.orig/fs/ext4/inode.c	2008-06-01 13:39:14.000000000 -0700
+++ linux-2.6.26-rc4/fs/ext4/inode.c	2008-06-01 13:40:00.000000000 -0700
@@ -1495,6 +1495,13 @@ static int ext4_bh_unmapped_or_delay(han
 	return (!buffer_mapped(bh) || buffer_delay(bh));
 }
 
+static int ext4_bh_clear_delay(handle_t *handle, struct buffer_head *bh)
+{
+	clear_buffer_delay(bh);
+	return 1;
+}
+
+
 /* FIXME!! only support data=writeback mode */
 /*
  * get called vi ext4_da_writepages after taking page lock
@@ -1508,10 +1515,16 @@ static int ext4_da_writepage(struct page
 	loff_t size;
 	unsigned long len;
 	handle_t *handle = NULL;
-	struct buffer_head *page_bufs;
+	struct buffer_head *page_bufs = page_buffers(page);
 	struct inode *inode = page->mapping->host;
 
+	size = i_size_read(inode);
+	if (page->index == size >> PAGE_CACHE_SHIFT)
+		len = size & ~PAGE_CACHE_MASK;
+	else
+		len = PAGE_CACHE_SIZE;
 	handle = ext4_journal_current_handle();
+
 	if (!handle) {
 		/*
 		 * This can happen when we aren't called via
@@ -1519,14 +1532,6 @@ static int ext4_da_writepage(struct page
 		 * We cannot easily start a transaction here so we just skip
 		 * writing the page in case we would have to do so.
 		 */
-		size = i_size_read(inode);
-
-		page_bufs = page_buffers(page);
-		if (page->index == size >> PAGE_CACHE_SHIFT)
-			len = size & ~PAGE_CACHE_MASK;
-		else
-			len = PAGE_CACHE_SIZE;
-
 		if (walk_page_buffers(NULL, page_bufs, 0,
 				len, NULL, ext4_bh_unmapped_or_delay)) {
 			/*
@@ -1544,7 +1549,9 @@ static int ext4_da_writepage(struct page
 		ret = nobh_writepage(page, ext4_da_get_block_write, wbc);
 	else
 		ret = block_write_full_page(page, ext4_da_get_block_write, wbc);
