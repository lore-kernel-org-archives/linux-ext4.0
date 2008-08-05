From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Problem with delayed allocation
Date: Tue, 5 Aug 2008 12:22:17 +0530
Message-ID: <20080805065217.GF9397@skywalker>
References: <E1KPNNn-0003IN-0B@closure.thunk.org> <20080804163505.GE9397@skywalker> <20080805064428.GB8569@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="ikeVEW9yuYc//A+q"
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:57919 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075AbYHEGxW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Aug 2008 02:53:22 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id m756q7Sj013448
	for <linux-ext4@vger.kernel.org>; Tue, 5 Aug 2008 16:52:07 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m756rB944276348
	for <linux-ext4@vger.kernel.org>; Tue, 5 Aug 2008 16:53:11 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m756rA7A017556
	for <linux-ext4@vger.kernel.org>; Tue, 5 Aug 2008 16:53:11 +1000
Content-Disposition: inline
In-Reply-To: <20080805064428.GB8569@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 05, 2008 at 02:44:28AM -0400, Theodore Tso wrote:
> On Mon, Aug 04, 2008 at 10:05:05PM +0530, Aneesh Kumar K.V wrote:
> > 
> > This is the complete patch that  I have. I haven't fully tested it
> > (right now waiting for the machine to be free). This should apply 
> > after stable-boundary-undo.patch
> 
> Umm... the patch doesn't apply right after the stable boundary udo
> patch.
> 
> 						- Ted

I did a fresh git pull and updated the patch. I also accumulated few
changes after words while testing on ABAT. Attaching both the patches
below. The patches apply after ext4_journal_credits_fix_for_writepages.patch
in the patch queue.


-aneesh



--ikeVEW9yuYc//A+q
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="1.patch"

commit ac92572cf2bc6739b3a7cc7037a044e493cc6b4e
Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date:   Tue Aug 5 09:09:44 2008 +0530

    ext4: Rework the ext4_da_writepages
    
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
    
    Also make sure fallocated area is handled properly by delayed allocation.
    
    Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c96cc0b..fb5aa7b 100644
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
@@ -1732,6 +1730,13 @@ static void mpage_put_bnr_to_bhs(struct mpage_da_data *mpd, sector_t logical,
 				if (buffer_delay(bh)) {
 					bh->b_blocknr = pblock;
 					clear_buffer_delay(bh);
+					bh->b_bdev = inode->i_sb->s_bdev;
+				} else if (buffer_unwritten(bh)) {
+					bh->b_blocknr = pblock;
+					clear_buffer_unwritten(bh);
+					set_buffer_mapped(bh);
+					set_buffer_new(bh);
+					bh->b_bdev = inode->i_sb->s_bdev;
 				} else if (buffer_mapped(bh))
 					BUG_ON(bh->b_blocknr != pblock);
 
@@ -1772,8 +1777,8 @@ static inline void __unmap_underlying_blocks(struct inode *inode,
  */
 static void mpage_da_map_blocks(struct mpage_da_data *mpd)
 {
+	int err = 0;
 	struct buffer_head *lbh = &mpd->lbh;
-	int err = 0, remain = lbh->b_size;
 	sector_t next = lbh->b_blocknr;
 	struct buffer_head new;
 
@@ -1783,38 +1788,29 @@ static void mpage_da_map_blocks(struct mpage_da_data *mpd)
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
+	if (buffer_delay(lbh) || buffer_unwritten(lbh))
+		mpage_put_bnr_to_bhs(mpd, next, &new);
 
-		/* go for the remaining blocks */
-		next += new.b_size >> mpd->inode->i_blkbits;
-		remain -= new.b_size;
-	}
+	return;
 }
 
-#define BH_FLAGS ((1 << BH_Uptodate) | (1 << BH_Mapped) | (1 << BH_Delay))
+#define BH_FLAGS ((1 << BH_Uptodate) | (1 << BH_Mapped) | \
+		(1 << BH_Delay) | (1 << BH_Unwritten))
 
 /*
  * mpage_add_bh_to_extent - try to add one more block to extent of blocks
@@ -1856,13 +1852,9 @@ static void mpage_add_bh_to_extent(struct mpage_da_data *mpd,
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
@@ -1882,6 +1874,17 @@ static int __mpage_da_writepage(struct page *page,
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
@@ -1893,6 +1896,13 @@ static int __mpage_da_writepage(struct page *page,
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
@@ -1923,6 +1933,8 @@ static int __mpage_da_writepage(struct page *page,
 		set_buffer_dirty(bh);
 		set_buffer_uptodate(bh);
 		mpage_add_bh_to_extent(mpd, logical, bh);
+		if (mpd->io_done)
+			return MPAGE_DA_EXTENT_TAIL;
 	} else {
 		/*
 		 * Page with regular buffer heads, just add all dirty ones
@@ -1931,8 +1943,12 @@ static int __mpage_da_writepage(struct page *page,
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
@@ -1967,6 +1983,7 @@ static int mpage_da_writepages(struct address_space *mapping,
 			       get_block_t get_block)
 {
 	struct mpage_da_data mpd;
+	long to_write;
 	int ret;
 
 	if (!get_block)
@@ -1980,17 +1997,22 @@ static int mpage_da_writepages(struct address_space *mapping,
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
 
@@ -2202,10 +2224,7 @@ static int ext4_da_writepages(struct address_space *mapping,
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
@@ -2215,11 +2234,6 @@ static int ext4_da_writepages(struct address_space *mapping,
 	if (!mapping->nrpages || !mapping_tagged(mapping, PAGECACHE_TAG_DIRTY))
 		return 0;
 
-	if (wbc->nr_to_write > mapping->nrpages)
-		wbc->nr_to_write = mapping->nrpages;
-
-	to_write = wbc->nr_to_write;
-
 	if (!wbc->range_cyclic) {
 		/*
 		 * If range_cyclic is not set force range_cont
@@ -2228,26 +2242,21 @@ static int ext4_da_writepages(struct address_space *mapping,
 		wbc->range_cont = 1;
 		range_start =  wbc->range_start;
 	}
+	pages_skipped = wbc->pages_skipped;
 
-	while (!ret && to_write) {
-		/*
-		 * set the max dirty pages could be write at a time
-		 * to fit into the reserved transaction credits
-		 */
-		if (wbc->nr_to_write > max_writeback_pages)
-			wbc->nr_to_write = max_writeback_pages;
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
@@ -2276,7 +2285,14 @@ static int ext4_da_writepages(struct address_space *mapping,
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
@@ -2288,6 +2304,15 @@ static int ext4_da_writepages(struct address_space *mapping,
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
 	if (range_start)

--ikeVEW9yuYc//A+q
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="2.patch"

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 8d62200..023e1a8 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1790,6 +1790,13 @@ static void mpage_da_map_blocks(struct mpage_da_data *mpd)
 	new.b_state = lbh->b_state;
 	new.b_blocknr = 0;
 	new.b_size = lbh->b_size;
+
+	/*
+	 * If we didn't accumulate anything
+	 * to write simply return
+	 */
+	if (!new.b_size)
+		return;
 	err = mpd->get_block(mpd->inode, next, &new, 1);
 	if (err)
 		return;
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 25adfc3..a7db10c 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -517,8 +517,12 @@ void generic_sync_sb_inodes(struct super_block *sb,
 		cond_resched();
 		spin_lock(&inode_lock);
 		if (wbc->nr_to_write <= 0) {
-			wbc->more_io = 1;
-			break;
+			if (wbc->sync_mode == WB_SYNC_ALL) {
+				wbc->nr_to_write = LONG_MAX;
+			} else {
+				wbc->more_io = 1;
+				break;
+			}
 		}
 		if (!list_empty(&sb->s_more_io))
 			wbc->more_io = 1;

--ikeVEW9yuYc//A+q--
