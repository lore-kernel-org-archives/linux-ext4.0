From: Jan Kara <jack@suse.cz>
Subject: [PATCH] New writepage checks for ext4
Date: Wed, 4 Jun 2008 17:48:24 +0200
Message-ID: <20080604154824.GF16572@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:46138 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756841AbYFDPs0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Jun 2008 11:48:26 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

  the patch below should be used instead of
ext4-Add-validation-to-jbd-lock-inversion-patch-and.patch
  to check whether writepage got all buffers mapped. It duplicates less
code than the original patch and I think there's also nicer separation
between parts doing sanity checks and parts doing real work.

							Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
---

ext4: Add checks to writepage()

Add checks to writepage() calls to check that all pages are properly
mapped and not delayed.

Signed-off-by: Jan Kara <jack@suse.cz>

Index: linux-2.6-linus/fs/ext4/inode.c
===================================================================
--- linux-2.6-linus.orig/fs/ext4/inode.c
+++ linux-2.6-linus/fs/ext4/inode.c
@@ -1479,6 +1479,11 @@ static int jbd2_journal_dirty_data_fn(ha
 	return 0;
 }
 
+static int ext4_bh_unmapped_or_delay(handle_t *handle, struct buffer_head *bh)
+{
+	return !buffer_mapped(bh) || buffer_delay(bh);
+}
+
 /*
  * Note that we don't need to start a transaction unless we're journaling
  * data because we should have holes filled from ext4_page_mkwrite(). If
@@ -1582,7 +1587,18 @@ out_put:
 static int ext4_ordered_writepage(struct page *page,
 				struct writeback_control *wbc)
 {
+	struct inode *inode = page->mapping->host;
+	loff_t size = i_size_read(inode);
+	loff_t len;
+
 	J_ASSERT(PageLocked(page));
+	J_ASSERT(page_has_buffers(page));
+	if (page->index == size >> PAGE_CACHE_SHIFT)
+		len = size & ~PAGE_CACHE_MASK;
+	else
+		len = PAGE_CACHE_SIZE;
+	BUG_ON(walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
+				 ext4_bh_unmapped_or_delay));
 
 	/*
 	 * We give up here if we're reentered, because it might be for a
@@ -1611,6 +1627,19 @@ static int __ext4_writeback_writepage(st
 static int ext4_writeback_writepage(struct page *page,
 				struct writeback_control *wbc)
 {
+	struct inode *inode = page->mapping->host;
+	loff_t size = i_size_read(inode);
+	loff_t len;
+
+	J_ASSERT(PageLocked(page));
+	J_ASSERT(page_has_buffers(page));
+	if (page->index == size >> PAGE_CACHE_SHIFT)
+		len = size & ~PAGE_CACHE_MASK;
+	else
+		len = PAGE_CACHE_SIZE;
+	BUG_ON(walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
+				 ext4_bh_unmapped_or_delay));
+
 	if (!ext4_journal_current_handle())
 		return __ext4_writeback_writepage(page, wbc);
 
@@ -1671,10 +1700,23 @@ out:
 static int ext4_journalled_writepage(struct page *page,
 				struct writeback_control *wbc)
 {
+	struct inode *inode = page->mapping->host;
+	loff_t size = i_size_read(inode);
+	loff_t len;
+
+	J_ASSERT(PageLocked(page));
+	J_ASSERT(page_has_buffers(page));
+	if (page->index == size >> PAGE_CACHE_SHIFT)
+		len = size & ~PAGE_CACHE_MASK;
+	else
+		len = PAGE_CACHE_SIZE;
+	BUG_ON(walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
+				 ext4_bh_unmapped_or_delay));
+
 	if (ext4_journal_current_handle())
 		goto no_write;
 
-	if (!page_has_buffers(page) || PageChecked(page)) {
+	if (PageChecked(page)) {
 		/*
 		 * It's mmapped pagecache.  Add buffers and journal it.  There
 		 * doesn't seem much point in redirtying the page here.
