From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Rework the ext4_da_writepages
Date: Thu, 31 Jul 2008 23:03:25 +0530
Message-ID: <1217525605-23000-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:43852 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbYGaReK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 31 Jul 2008 13:34:10 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id m6VHXkeq003122
	for <linux-ext4@vger.kernel.org>; Fri, 1 Aug 2008 03:33:46 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6VHY85l266366
	for <linux-ext4@vger.kernel.org>; Fri, 1 Aug 2008 03:34:08 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6VHY7mB014077
	for <linux-ext4@vger.kernel.org>; Fri, 1 Aug 2008 03:34:08 +1000
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

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/inode.c |  128 +++++++++++++++++++++++++++++-------------------------
 1 files changed, 69 insertions(+), 59 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 5665bec..465108b 100644
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
@@ -1580,6 +1582,8 @@ static void ext4_da_page_release_reservation(struct page *page,
 	unsigned long first_page, next_page;	/* extent of pages */
 	get_block_t *get_block;
 	struct writeback_control *wbc;
+	int io_done;
+	long pages_written;
 };
 
 /*
@@ -1629,6 +1633,8 @@ static int mpage_da_submit_io(struct mpage_da_data *mpd)
 			index++;
 
 			err = __mpage_writepage(page, mpd->wbc, &mpd_pp);
+			if (!err)
+				mpd->pages_written++;
 
 			/*
 			 * In error case, we have to continue because
@@ -1748,8 +1754,8 @@ static inline void __unmap_underlying_blocks(struct inode *inode,
  */
 static void mpage_da_map_blocks(struct mpage_da_data *mpd)
 {
+	int err = 0;
 	struct buffer_head *lbh = &mpd->lbh;
-	int err = 0, remain = lbh->b_size;
 	sector_t next = lbh->b_blocknr;
 	struct buffer_head new;
 
@@ -1759,35 +1765,25 @@ static void mpage_da_map_blocks(struct mpage_da_data *mpd)
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
+	err = mpd->get_block(mpd->inode, next, &new, 1);
+	if (err)
+		return;
+	BUG_ON(new.b_size == 0);
 
-		if (buffer_new(&new))
-			__unmap_underlying_blocks(mpd->inode, &new);
+	if (buffer_new(&new))
+		__unmap_underlying_blocks(mpd->inode, &new);
 
-		/*
-		 * If blocks are delayed marked, we need to
-		 * put actual blocknr and drop delayed bit
-		 */
-		if (buffer_delay(lbh))
-			mpage_put_bnr_to_bhs(mpd, next, &new);
+	/*
+	 * If blocks are delayed marked, we need to
+	 * put actual blocknr and drop delayed bit
+	 */
+	if (buffer_delay(lbh))
+		mpage_put_bnr_to_bhs(mpd, next, &new);
 
-		/* go for the remaining blocks */
-		next += new.b_size >> mpd->inode->i_blkbits;
-		remain -= new.b_size;
-	}
+	return;
 }
 
 #define BH_FLAGS ((1 << BH_Uptodate) | (1 << BH_Mapped) | (1 << BH_Delay))
@@ -1832,13 +1828,9 @@ static void mpage_add_bh_to_extent(struct mpage_da_data *mpd,
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
@@ -1858,6 +1850,17 @@ static int __mpage_da_writepage(struct page *page,
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
@@ -1869,6 +1872,13 @@ static int __mpage_da_writepage(struct page *page,
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
@@ -1899,6 +1909,8 @@ static int __mpage_da_writepage(struct page *page,
 		set_buffer_dirty(bh);
 		set_buffer_uptodate(bh);
 		mpage_add_bh_to_extent(mpd, logical, bh);
+		if (mpd->io_done)
+			return MPAGE_DA_EXTENT_TAIL;
 	} else {
 		/*
 		 * Page with regular buffer heads, just add all dirty ones
@@ -1907,8 +1919,11 @@ static int __mpage_da_writepage(struct page *page,
 		bh = head;
 		do {
 			BUG_ON(buffer_locked(bh));
-			if (buffer_dirty(bh))
+			if (buffer_dirty(bh)) {
 				mpage_add_bh_to_extent(mpd, logical, bh);
+				if (mpd->io_done)
+					return MPAGE_DA_EXTENT_TAIL;
+			}
 			logical++;
 		} while ((bh = bh->b_this_page) != head);
 	}
@@ -1943,6 +1958,7 @@ static int mpage_da_writepages(struct address_space *mapping,
 			       get_block_t get_block)
 {
 	struct mpage_da_data mpd;
+	long to_write;
 	int ret;
 
 	if (!get_block)
@@ -1956,17 +1972,22 @@ static int mpage_da_writepages(struct address_space *mapping,
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
 
@@ -2178,10 +2199,6 @@ static int ext4_da_writepages(struct address_space *mapping,
 	int ret = 0;
 	long to_write;
 	loff_t range_start = 0;
-	int blocks_per_page = PAGE_CACHE_SIZE >> inode->i_blkbits;
-	int max_credit_blocks = ext4_journal_max_transaction_buffers(inode);
-	int need_credits_per_page =  ext4_writepages_trans_blocks(inode, 1);
-	int max_writeback_pages = (max_credit_blocks / blocks_per_page) / need_credits_per_page;
 
 	/*
 	 * No pages to write? This is mainly a kludge to avoid starting
@@ -2205,25 +2222,11 @@ static int ext4_da_writepages(struct address_space *mapping,
 		range_start =  wbc->range_start;
 	}
 
-	while (!ret && to_write) {
-		/*
-		 * set the max dirty pages could be write at a time
-		 * to fit into the reserved transaction credits
-		 */
-		if (wbc->nr_to_write > max_writeback_pages)
-			wbc->nr_to_write = max_writeback_pages;
+	while (!ret && to_write > 0) {
+
+		BUG_ON(ext4_should_journal_data(inode));
+		needed_blocks = EXT4_DATA_TRANS_BLOCKS(inode->i_sb);
 
-		/*
-		 * Estimate the worse case needed credits to write out
-		 * to_write pages
-		 */
-		needed_blocks = ext4_writepages_trans_blocks(inode,
-							     wbc->nr_to_write);
-		while (needed_blocks > max_credit_blocks) {
-			wbc->nr_to_write --;
-			needed_blocks = ext4_writepages_trans_blocks(inode,
-							     wbc->nr_to_write);
-		}
 		/* start a new transaction*/
 		handle = ext4_journal_start(inode, needed_blocks);
 		if (IS_ERR(handle)) {
@@ -2251,7 +2254,14 @@ static int ext4_da_writepages(struct address_space *mapping,
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
-- 
1.6.0.rc0.42.g186458.dirty

