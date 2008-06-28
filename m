From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Handle page without buffers in ext4_*_writepage()
Date: Sat, 28 Jun 2008 15:48:55 +0530
Message-ID: <1214648335-2706-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com, jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:46995 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754660AbYF1KTI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 28 Jun 2008 06:19:08 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id m5SAImJP012420
	for <linux-ext4@vger.kernel.org>; Sat, 28 Jun 2008 20:18:48 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5SAIbJF4747458
	for <linux-ext4@vger.kernel.org>; Sat, 28 Jun 2008 20:18:38 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m5SAJ1Iw028328
	for <linux-ext4@vger.kernel.org>; Sat, 28 Jun 2008 20:19:02 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jan Kara <jack@suse.cz>

It can happen that buffers are removed from the page before it gets
marked dirty and then is passed to writepage(). Make ext4_*_writepage()
handle this case (basically by just skipping some checks in this case).

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/inode.c |   86 +++++++++++++++++++++++++++++++++++++++++++++---------
 1 files changed, 71 insertions(+), 15 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 10f1d5d..8bd2595 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1592,11 +1592,15 @@ static int ext4_da_get_block_write(struct inode *inode, sector_t iblock,
 	handle_t *handle = NULL;
 
 	handle = ext4_journal_current_handle();
-	BUG_ON(handle == NULL);
-	BUG_ON(create == 0);
-
-	ret = ext4_get_blocks_wrap(handle, inode, iblock, max_blocks,
+	if (!handle) {
+		ret = ext4_get_blocks_wrap(handle, inode, iblock, max_blocks,
+				   bh_result, 0, 0, 0);
+		BUG_ON(!ret);
+	} else {
+		ret = ext4_get_blocks_wrap(handle, inode, iblock, max_blocks,
 				   bh_result, create, 0, EXT4_DELALLOC_RSVED);
+	}
+
 	if (ret > 0) {
 		bh_result->b_size = (ret << inode->i_blkbits);
 
@@ -1655,7 +1659,13 @@ static int ext4_da_writepage(struct page *page,
 	struct inode *inode = page->mapping->host;
 
 	handle = ext4_journal_current_handle();
-	if (!handle) {
+	/* The test for page_has_buffers() is subtle:
+	 * We know the page is dirty but it lost buffers. That means that
+	 * at some moment in time after write_begin() / write_end() has been
+	 * called all buffers have been clean and thus they must have been
+	 * written at least once. So they are all mapped and we can happily
+	 * proceed with mapping them and writing the page. */
+	if (!handle && page_has_buffers(page)) {
 		/*
 		 * This can happen when we aren't called via
 		 * ext4_da_writepages() but directly (shrink_page_list).
@@ -1918,6 +1928,28 @@ static int bput_one(handle_t *handle, struct buffer_head *bh)
 	return 0;
 }
 
+static int ext4_normal_get_block_write(struct inode *inode, sector_t iblock,
+				   struct buffer_head *bh_result, int create)
+{
+	int ret = 0;
+	handle_t *handle = ext4_journal_current_handle();
+	unsigned max_blocks = bh_result->b_size >> inode->i_blkbits;
+
+	if (!handle) {
+		ret = ext4_get_blocks_wrap(handle, inode, iblock, max_blocks,
+				   bh_result, 0, 0, 0);
+		BUG_ON(!ret);
+	} else {
+		ret = ext4_get_blocks_wrap(handle, inode, iblock, max_blocks,
+				   bh_result, create, 0, EXT4_DELALLOC_RSVED);
+	}
+	if (ret > 0) {
+		bh_result->b_size = (ret << inode->i_blkbits);
+		ret = 0;
+	}
+	return ret;
+}
+
 /*
  * Note that we don't need to start a transaction unless we're journaling data
  * because we should have holes filled from ext4_page_mkwrite(). We even don't
@@ -1977,12 +2009,13 @@ static int __ext4_normal_writepage(struct page *page,
 	struct inode *inode = page->mapping->host;
 
 	if (test_opt(inode->i_sb, NOBH))
-		return nobh_writepage(page, ext4_get_block, wbc);
+		return nobh_writepage(page,
+					ext4_normal_get_block_write, wbc);
 	else
-		return block_write_full_page(page, ext4_get_block, wbc);
+		return block_write_full_page(page,
+					ext4_normal_get_block_write, wbc);
 }
 
-
 static int ext4_normal_writepage(struct page *page,
 				struct writeback_control *wbc)
 {
@@ -1991,13 +2024,24 @@ static int ext4_normal_writepage(struct page *page,
 	loff_t len;
 
 	J_ASSERT(PageLocked(page));
-	J_ASSERT(page_has_buffers(page));
 	if (page->index == size >> PAGE_CACHE_SHIFT)
 		len = size & ~PAGE_CACHE_MASK;
 	else
 		len = PAGE_CACHE_SIZE;
-	BUG_ON(walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
-				 ext4_bh_unmapped_or_delay));
+
+	if (page_has_buffers(page)) {
+		/* if page has buffers it should all be mapped
+		 * and allocated. If there are not buffers attached
+		 * to the page we know the page is dirty but it lost
+		 * buffers. That means that at some moment in time
+		 * after write_begin() / write_end() has been called
+		 * all buffers have been clean and thus they must have been
+		 * written at least once. So they are all mapped and we can
+		 * happily proceed with mapping them and writing the page.
+		 */
+		BUG_ON(walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
+					ext4_bh_unmapped_or_delay));
+	}
 
 	if (!ext4_journal_current_handle())
 		return __ext4_normal_writepage(page, wbc);
@@ -2017,7 +2061,8 @@ static int __ext4_journalled_writepage(struct page *page,
 	int ret = 0;
 	int err;
 
-	ret = block_prepare_write(page, 0, PAGE_CACHE_SIZE, ext4_get_block);
+	ret = block_prepare_write(page, 0, PAGE_CACHE_SIZE,
+					ext4_normal_get_block_write);
 	if (ret != 0)
 		goto out_unlock;
 
@@ -2064,13 +2109,24 @@ static int ext4_journalled_writepage(struct page *page,
 	loff_t len;
 
 	J_ASSERT(PageLocked(page));
-	J_ASSERT(page_has_buffers(page));
 	if (page->index == size >> PAGE_CACHE_SHIFT)
 		len = size & ~PAGE_CACHE_MASK;
 	else
 		len = PAGE_CACHE_SIZE;
-	BUG_ON(walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
-				 ext4_bh_unmapped_or_delay));
+
+	if (page_has_buffers(page)) {
+		/* if page has buffers it should all be mapped
+		 * and allocated. If there are not buffers attached
+		 * to the page we know the page is dirty but it lost
+		 * buffers. That means that at some moment in time
+		 * after write_begin() / write_end() has been called
+		 * all buffers have been clean and thus they must have been
+		 * written at least once. So they are all mapped and we can
+		 * happily proceed with mapping them and writing the page.
+		 */
+		BUG_ON(walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
+					ext4_bh_unmapped_or_delay));
+	}
 
 	if (ext4_journal_current_handle())
 		goto no_write;
-- 
1.5.6.1.78.gde8d9.dirty

