From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Rework the ext4_da_writepages
Date: Mon, 11 Aug 2008 15:31:49 +0530
Message-ID: <1218448910-9008-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1218448910-9008-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:47699 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbYHKKCB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Aug 2008 06:02:01 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id m7BA1Axb014966
	for <linux-ext4@vger.kernel.org>; Mon, 11 Aug 2008 20:01:10 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7BA1xvW4206806
	for <linux-ext4@vger.kernel.org>; Mon, 11 Aug 2008 20:01:59 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7BA1vjK015540
	for <linux-ext4@vger.kernel.org>; Mon, 11 Aug 2008 20:01:58 +1000
In-Reply-To: <1218448910-9008-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

With the below changes we reserve credit needed to insert only one extent
resulting from a call to single get_block. That make sure we don't take
too much journal credits during writeout. We also don't limit the pages
to write. That means we loop through the dirty pages building largest
possible contiguous block request. Then we issue a single get_block request.
We may get less block that we requested. If so we would end up not mapping
some of the buffer_heads. That means those buffer_heads are still marked delay.
Later in the writepage callback via __mpage_writepage we redirty those pages.

We should also not limit/throttle wbc->nr_to_write in the filesystem writepages
callback. That cause wrong behaviour in generic_sync_sb_inodes caused by
wbc->nr_to_write being <= 0

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/inode.c |  175 +++++++++++++++++++++++++++++++------------------------
 1 files changed, 99 insertions(+), 76 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 7a66bba..ea1a8db 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -41,6 +41,8 @@
 #include "acl.h"
 #include "ext4_extents.h"
 
+#define MPAGE_DA_EXTENT_TAIL 0x01
+
 static inline int ext4_begin_ordered_truncate(struct inode *inode,
 					      loff_t new_size)
 {
@@ -1604,6 +1606,8 @@ static void ext4_da_page_release_reservation(struct page *page,
 	unsigned long first_page, next_page;	/* extent of pages */
 	get_block_t *get_block;
 	struct writeback_control *wbc;
+	int io_done;
+	long pages_written;
 };
 
 /*
@@ -1623,12 +1627,6 @@ static void ext4_da_page_release_reservation(struct page *page,
 static int mpage_da_submit_io(struct mpage_da_data *mpd)
 {
 	struct address_space *mapping = mpd->inode->i_mapping;
-	struct mpage_data mpd_pp = {
-		.bio = NULL,
-		.last_block_in_bio = 0,
-		.get_block = mpd->get_block,
-		.use_writepage = 1,
-	};
 	int ret = 0, err, nr_pages, i;
 	unsigned long index, end;
 	struct pagevec pvec;
@@ -1652,7 +1650,9 @@ static int mpage_da_submit_io(struct mpage_da_data *mpd)
 				break;
 			index++;
 
-			err = __mpage_writepage(page, mpd->wbc, &mpd_pp);
+			err = mapping->a_ops->writepage(page, mpd->wbc);
+			if (!err)
+				mpd->pages_written++;
 
 			/*
 			 * In error case, we have to continue because
@@ -1664,8 +1664,6 @@ static int mpage_da_submit_io(struct mpage_da_data *mpd)
 		}
 		pagevec_release(&pvec);
 	}
-	if (mpd_pp.bio)
-		mpage_bio_submit(WRITE, mpd_pp.bio);
 
 	return ret;
 }
@@ -1779,8 +1777,8 @@ static inline void __unmap_underlying_blocks(struct inode *inode,
  */
 static void mpage_da_map_blocks(struct mpage_da_data *mpd)
 {
+	int err = 0;
 	struct buffer_head *lbh = &mpd->lbh;
-	int err = 0, remain = lbh->b_size;
 	sector_t next = lbh->b_blocknr;
 	struct buffer_head new;
 
@@ -1790,35 +1788,32 @@ static void mpage_da_map_blocks(struct mpage_da_data *mpd)
 	if (buffer_mapped(lbh) && !buffer_delay(lbh))
 		return;
 
-	while (remain) {
-		new.b_state = lbh->b_state;
-		new.b_blocknr = 0;
-		new.b_size = remain;
-		err = mpd->get_block(mpd->inode, next, &new, 1);
-		if (err) {
-			/*
-			 * Rather than implement own error handling
-			 * here, we just leave remaining blocks
-			 * unallocated and try again with ->writepage()
-			 */
-			break;
-		}
-		BUG_ON(new.b_size == 0);
+	new.b_state = lbh->b_state;
+	new.b_blocknr = 0;
+	new.b_size = lbh->b_size;
 
-		if (buffer_new(&new))
-			__unmap_underlying_blocks(mpd->inode, &new);
+	/*
+	 * If we didn't accumulate anything
+	 * to write simply return
+	 */
+	if (!new.b_size)
+		return;
+	err = mpd->get_block(mpd->inode, next, &new, 1);
+	if (err)
+		return;
+	BUG_ON(new.b_size == 0);
 
-		/*
-		 * If blocks are delayed marked, we need to
-		 * put actual blocknr and drop delayed bit
-		 */
-		if (buffer_delay(lbh) || buffer_unwritten(lbh))
-			mpage_put_bnr_to_bhs(mpd, next, &new);
+	if (buffer_new(&new))
+		__unmap_underlying_blocks(mpd->inode, &new);
 
-		/* go for the remaining blocks */
-		next += new.b_size >> mpd->inode->i_blkbits;
-		remain -= new.b_size;
-	}
+	/*
+	 * If blocks are delayed marked, we need to
+	 * put actual blocknr and drop delayed bit
+	 */
+	if (buffer_delay(lbh) || buffer_unwritten(lbh))
+		mpage_put_bnr_to_bhs(mpd, next, &new);
+
+	return;
 }
 
 #define BH_FLAGS ((1 << BH_Uptodate) | (1 << BH_Mapped) | \
@@ -1864,13 +1859,9 @@ static void mpage_add_bh_to_extent(struct mpage_da_data *mpd,
 	 * need to flush current  extent and start new one
 	 */
 	mpage_da_map_blocks(mpd);
-
-	/*
-	 * Now start a new extent
-	 */
-	lbh->b_size = bh->b_size;
-	lbh->b_state = bh->b_state & BH_FLAGS;
-	lbh->b_blocknr = logical;
+	mpage_da_submit_io(mpd);
+	mpd->io_done = 1;
+	return;
 }
 
 /*
@@ -1890,6 +1881,17 @@ static int __mpage_da_writepage(struct page *page,
 	struct buffer_head *bh, *head, fake;
 	sector_t logical;
 
+	if (mpd->io_done) {
+		/*
+		 * Rest of the page in the page_vec
+		 * redirty then and skip then. We will
+		 * try to to write them again after
+		 * starting a new transaction
+		 */
+		redirty_page_for_writepage(wbc, page);
+		unlock_page(page);
+		return MPAGE_DA_EXTENT_TAIL;
+	}
 	/*
 	 * Can we merge this page to current extent?
 	 */
@@ -1901,6 +1903,13 @@ static int __mpage_da_writepage(struct page *page,
 		if (mpd->next_page != mpd->first_page) {
 			mpage_da_map_blocks(mpd);
 			mpage_da_submit_io(mpd);
+			/*
+			 * skip rest of the page in the page_vec
+			 */
+			mpd->io_done = 1;
+			redirty_page_for_writepage(wbc, page);
+			unlock_page(page);
+			return MPAGE_DA_EXTENT_TAIL;
 		}
 
 		/*
@@ -1931,6 +1940,8 @@ static int __mpage_da_writepage(struct page *page,
 		set_buffer_dirty(bh);
 		set_buffer_uptodate(bh);
 		mpage_add_bh_to_extent(mpd, logical, bh);
+		if (mpd->io_done)
+			return MPAGE_DA_EXTENT_TAIL;
 	} else {
 		/*
 		 * Page with regular buffer heads, just add all dirty ones
@@ -1939,8 +1950,12 @@ static int __mpage_da_writepage(struct page *page,
 		bh = head;
 		do {
 			BUG_ON(buffer_locked(bh));
-			if (buffer_dirty(bh))
+			if (buffer_dirty(bh) &&
+				(!buffer_mapped(bh) || buffer_delay(bh))) {
 				mpage_add_bh_to_extent(mpd, logical, bh);
+				if (mpd->io_done)
+					return MPAGE_DA_EXTENT_TAIL;
+			}
 			logical++;
 		} while ((bh = bh->b_this_page) != head);
 	}
@@ -1975,6 +1990,7 @@ static int mpage_da_writepages(struct address_space *mapping,
 			       get_block_t get_block)
 {
 	struct mpage_da_data mpd;
+	long to_write;
 	int ret;
 
 	if (!get_block)
@@ -1988,17 +2004,22 @@ static int mpage_da_writepages(struct address_space *mapping,
 	mpd.first_page = 0;
 	mpd.next_page = 0;
 	mpd.get_block = get_block;
+	mpd.io_done = 0;
+	mpd.pages_written = 0;
+
+	to_write = wbc->nr_to_write;
 
 	ret = write_cache_pages(mapping, wbc, __mpage_da_writepage, &mpd);
 
 	/*
 	 * Handle last extent of pages
 	 */
-	if (mpd.next_page != mpd.first_page) {
+	if (!mpd.io_done && mpd.next_page != mpd.first_page) {
 		mpage_da_map_blocks(&mpd);
 		mpage_da_submit_io(&mpd);
 	}
 
+	wbc->nr_to_write = to_write - mpd.pages_written;
 	return ret;
 }
 
@@ -2210,10 +2231,7 @@ static int ext4_da_writepages(struct address_space *mapping,
 	int ret = 0;
 	long to_write;
 	loff_t range_start = 0;
-	int blocks_per_page = PAGE_CACHE_SIZE >> inode->i_blkbits;
-	int max_credit_blocks = ext4_journal_max_transaction_buffers(inode);
-	int need_credits_per_page =  ext4_writepages_trans_blocks(inode, 1);
-	int max_writeback_pages = (max_credit_blocks / blocks_per_page) / need_credits_per_page;
+	long pages_skipped = 0;
 
 	/*
 	 * No pages to write? This is mainly a kludge to avoid starting
@@ -2223,39 +2241,29 @@ static int ext4_da_writepages(struct address_space *mapping,
 	if (!mapping->nrpages || !mapping_tagged(mapping, PAGECACHE_TAG_DIRTY))
 		return 0;
 
-	if (wbc->nr_to_write > mapping->nrpages)
-		wbc->nr_to_write = mapping->nrpages;
-
-	to_write = wbc->nr_to_write;
-
-	if (!wbc->range_cyclic) {
+	if (!wbc->range_cyclic)
 		/*
 		 * If range_cyclic is not set force range_cont
 		 * and save the old writeback_index
 		 */
 		wbc->range_cont = 1;
-		range_start =  wbc->range_start;
-	}
 
-	while (!ret && to_write) {
-		/*
-		 * set the max dirty pages could be write at a time
-		 * to fit into the reserved transaction credits
-		 */
-		if (wbc->nr_to_write > max_writeback_pages)
-			wbc->nr_to_write = max_writeback_pages;
+	range_start =  wbc->range_start;
+	pages_skipped = wbc->pages_skipped;
+
+restart_loop:
+	to_write = wbc->nr_to_write;
+	while (!ret && to_write > 0) {
 
 		/*
-		 * Estimate the worse case needed credits to write out
-		 * to_write pages
+		 * we  insert one extent at a time. So we need
+		 * credit needed for single extent allocation.
+		 * journalled mode is currently not supported
+		 * by delalloc
 		 */
-		needed_blocks = ext4_writepages_trans_blocks(inode,
-							     wbc->nr_to_write);
-		while (needed_blocks > max_credit_blocks) {
-			wbc->nr_to_write--;
-			needed_blocks = ext4_writepages_trans_blocks(inode,
-							     wbc->nr_to_write);
-		}
+		BUG_ON(ext4_should_journal_data(inode));
+		needed_blocks = EXT4_DATA_TRANS_BLOCKS(inode->i_sb);
+
 		/* start a new transaction*/
 		handle = ext4_journal_start(inode, needed_blocks);
 		if (IS_ERR(handle)) {
@@ -2284,7 +2292,14 @@ static int ext4_da_writepages(struct address_space *mapping,
 		ret = mpage_da_writepages(mapping, wbc,
 						ext4_da_get_block_write);
 		ext4_journal_stop(handle);
-		if (wbc->nr_to_write) {
+		if (ret == MPAGE_DA_EXTENT_TAIL) {
+			/*
+			 * got one extent now try with
+			 * rest of the pages
+			 */
+			to_write += wbc->nr_to_write;
+			ret = 0;
+		} else if (wbc->nr_to_write) {
 			/*
 			 * There is no more writeout needed
 			 * or we requested for a noblocking writeout
@@ -2296,10 +2311,18 @@ static int ext4_da_writepages(struct address_space *mapping,
 		wbc->nr_to_write = to_write;
 	}
 
+	if (wbc->range_cont && (pages_skipped != wbc->pages_skipped)) {
+		/* We skipped pages in this loop */
+		wbc->range_start = range_start;
+		wbc->nr_to_write = to_write +
+					wbc->pages_skipped - pages_skipped;
+		wbc->pages_skipped = pages_skipped;
+		goto restart_loop;
+	}
+
 out_writepages:
 	wbc->nr_to_write = to_write;
-	if (range_start)
-		wbc->range_start = range_start;
+	wbc->range_start = range_start;
 	return ret;
 }
 
-- 
1.6.0.rc0.42.g186458.dirty

