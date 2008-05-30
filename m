From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Fix delalloc sync hang with journal lock inversion
Date: Fri, 30 May 2008 19:09:29 +0530
Message-ID: <1212154769-16486-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1212154769-16486-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1212154769-16486-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1212154769-16486-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1212154769-16486-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1212154769-16486-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1212154769-16486-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:51711 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbYE3Nkz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 May 2008 09:40:55 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id m4UDeK6Z007683
	for <linux-ext4@vger.kernel.org>; Fri, 30 May 2008 23:40:20 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4UDebV34178094
	for <linux-ext4@vger.kernel.org>; Fri, 30 May 2008 23:40:37 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m4UDeruQ024636
	for <linux-ext4@vger.kernel.org>; Fri, 30 May 2008 23:40:53 +1000
In-Reply-To: <1212154769-16486-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/inode.c     |   99 ++++++++++++++++++++++++++++++++++----------------
 fs/mpage.c          |   14 ++++----
 mm/page-writeback.c |    7 +++-
 3 files changed, 80 insertions(+), 40 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 65e02a3..2194aa7 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1480,50 +1480,73 @@ static int ext4_da_get_block_write(struct inode *inode, sector_t iblock,
 			up_write(&EXT4_I(inode)->i_data_sem);
 
 			if (EXT4_I(inode)->i_disksize == disksize) {
-				if (handle == NULL)
-					handle = ext4_journal_start(inode, 1);
-				if (!IS_ERR(handle))
-					ext4_mark_inode_dirty(handle, inode);
+				ret = ext4_mark_inode_dirty(handle, inode);
+				return ret;
 			}
 		}
-
 		ret = 0;
 	}
-
 	return ret;
 }
+
+static int ext4_bh_unmapped_or_delay(handle_t *handle, struct buffer_head *bh)
+{
+	return (!buffer_mapped(bh) || buffer_delay(bh));
+}
+
 /* FIXME!! only support data=writeback mode */
-static int __ext4_da_writepage(struct page *page,
+/*
+ * get called vi ext4_da_writepages after taking page lock
+ * We may end up doing block allocation here in case
+ * mpage_da_map_blocks failed to allocate blocks.
+ */
+static int ext4_da_writepage(struct page *page,
 				struct writeback_control *wbc)
 {
-	struct inode *inode = page->mapping->host;
-	handle_t *handle = NULL;
 	int ret = 0;
+	loff_t size;
+	unsigned long len;
+	handle_t *handle = NULL;
+	struct buffer_head *page_bufs;
+	struct inode *inode = page->mapping->host;
 
 	handle = ext4_journal_current_handle();
+	if (!handle) {
+		/*
+		 * This can happen when we aren't called via
+		 * ext4_da_writepages() but directly (shrink_page_lis).
+		 * We cannot easily start a transaction here so we just skip
+		 * writing the page in case we would have to do so.
+		 */
+		size = i_size_read(inode);
 
-	if (test_opt(inode->i_sb, NOBH) && ext4_should_writeback_data(inode))
-		ret = nobh_writepage(page, ext4_get_block, wbc);
-	else
-		ret = block_write_full_page(page, ext4_get_block, wbc);
+		page_bufs = page_buffers(page);
+		if (page->index == size >> PAGE_CACHE_SHIFT)
+			len = size & ~PAGE_CACHE_MASK;
+		else
+			len = PAGE_CACHE_SIZE;
 
-	if (!ret && inode->i_size > EXT4_I(inode)->i_disksize) {
-		EXT4_I(inode)->i_disksize = inode->i_size;
-		ext4_mark_inode_dirty(handle, inode);
+		if (walk_page_buffers(NULL, page_bufs, 0,
+				len, NULL, ext4_bh_unmapped_or_delay)) {
+			/*
+			 * We can't do block allocation under
+			 * page lock without a handle . So redirty
+			 * the page and return
+			 */
+			redirty_page_for_writepage(wbc, page);
+			unlock_page(page);
+			return 0;
+		}
 	}
 
+	if (test_opt(inode->i_sb, NOBH) && ext4_should_writeback_data(inode))
+		ret = nobh_writepage(page, ext4_da_get_block_write, wbc);
+	else
+		ret = block_write_full_page(page, ext4_da_get_block_write, wbc);
+
 	return ret;
 }
-static int ext4_da_writepage(struct page *page,
-				struct writeback_control *wbc)
-{
-	if (!ext4_journal_current_handle())
-		return __ext4_da_writepage(page, wbc);
 
-	redirty_page_for_writepage(wbc, page);
-	unlock_page(page);
-	return 0;
-}
 
 /*
  * For now just follow the DIO way to estimate the max credits
@@ -1547,6 +1570,7 @@ static int ext4_da_writepages(struct address_space *mapping,
 	int ret = 0;
 	unsigned range_cyclic;
 	long to_write;
+	pgoff_t index;
 
 	/*
 	 *  Estimate the worse case needed credits to write out
@@ -1557,6 +1581,15 @@ static int ext4_da_writepages(struct address_space *mapping,
 	to_write = wbc->nr_to_write;
 	range_cyclic = wbc->range_cyclic;
 	wbc->range_cyclic = 1;
+	index =  mapping->writeback_index;
+	if (!range_cyclic) {
+		/*
+		 * We force cyclic write out of pages. If the
+		 * caller didn't request for range_cyclic update
+		 * set the writeback_index to what the caller requested.
+		 */
+		mapping->writeback_index = wbc->range_start >> PAGE_CACHE_SHIFT;
+	}
 
 	while (!ret && to_write) {
 		/* start a new transaction*/
@@ -1571,17 +1604,24 @@ static int ext4_da_writepages(struct address_space *mapping,
 		 */
 		if (wbc->nr_to_write > EXT4_MAX_WRITEBACK_PAGES)
 			wbc->nr_to_write = EXT4_MAX_WRITEBACK_PAGES;
-		to_write -= wbc->nr_to_write;
 
+		to_write -= wbc->nr_to_write;
 		ret = mpage_da_writepages(mapping, wbc,
 						ext4_da_get_block_write);
 		ext4_journal_stop(handle);
-		to_write += wbc->nr_to_write;
+		if (wbc->nr_to_write) {
+			/* There is no more writeout needed */
+			to_write += wbc->nr_to_write;
+			break;
+		}
+		wbc->nr_to_write = to_write;
 	}
 
 out_writepages:
 	wbc->nr_to_write = to_write;
 	wbc->range_cyclic = range_cyclic;
+	if (!range_cyclic)
+		mapping->writeback_index = index;
 	return ret;
 }
 
@@ -1719,11 +1759,6 @@ static int jbd2_journal_dirty_data_fn(handle_t *handle, struct buffer_head *bh)
 	return 0;
 }
 
-static int ext4_bh_unmapped_or_delay(handle_t *handle, struct buffer_head *bh)
-{
-	return (!buffer_mapped(bh) || buffer_delay(bh));
-}
-
 /*
  * Note that we don't need to start a transaction unless we're journaling
  * data because we should have holes filled from ext4_page_mkwrite(). If
diff --git a/fs/mpage.c b/fs/mpage.c
index cde7f11..c107728 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -849,13 +849,12 @@ static void mpage_put_bnr_to_bhs(struct mpage_da_data *mpd, sector_t logical,
 			do {
 				if (cur_logical >= logical + blocks)
 					break;
-
 				if (buffer_delay(bh)) {
 					bh->b_blocknr = pblock;
 					clear_buffer_delay(bh);
-				} else if (buffer_mapped(bh)) {
+					set_buffer_mapped(bh);
+				} else if (buffer_mapped(bh))
 					BUG_ON(bh->b_blocknr != pblock);
-				}
 
 				cur_logical++;
 				pblock++;
@@ -930,10 +929,10 @@ static void mpage_da_map_blocks(struct mpage_da_data *mpd)
 		if (buffer_delay(lbh))
 			mpage_put_bnr_to_bhs(mpd, next, &new);
 
-			/* go for the remaining blocks */
-			next += new.b_size >> mpd->inode->i_blkbits;
-			remain -= new.b_size;
-		}
+		/* go for the remaining blocks */
+		next += new.b_size >> mpd->inode->i_blkbits;
+		remain -= new.b_size;
+	}
 }
 
 #define BH_FLAGS ((1 << BH_Uptodate) | (1 << BH_Mapped) | (1 << BH_Delay))
@@ -1052,6 +1051,7 @@ static int __mpage_da_writepage(struct page *page,
 		head = page_buffers(page);
 		bh = head;
 		do {
+
 			BUG_ON(buffer_locked(bh));
 			if (buffer_dirty(bh))
 				mpage_add_bh_to_extent(mpd, logical, bh);
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 789b6ad..655b8bf 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -881,7 +881,12 @@ int write_cache_pages(struct address_space *mapping,
 	pagevec_init(&pvec, 0);
 	if (wbc->range_cyclic) {
 		index = mapping->writeback_index; /* Start from prev offset */
-		end = -1;
+		/*
+		 * write only till the specified range_end even in cyclic mode
+		 */
+		end = wbc->range_end >> PAGE_CACHE_SHIFT;
+		if (!end)
+			end = -1;
 	} else {
 		index = wbc->range_start >> PAGE_CACHE_SHIFT;
 		end = wbc->range_end >> PAGE_CACHE_SHIFT;
-- 
1.5.5.1.357.g1af8b.dirty

