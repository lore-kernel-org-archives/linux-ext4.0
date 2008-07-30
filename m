From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH v3]Ext4: journal credits reservation fixes for DIO,
	fallocate and delalloc writepages
Date: Wed, 30 Jul 2008 17:46:51 +0530
Message-ID: <20080730121651.GB2932@skywalker>
References: <48841077.500@cse.unsw.edu.au> <20080721082010.GC8788@skywalker> <1216774311.6505.4.camel@mingming-laptop> <20080723074226.GA15091@skywalker> <1217032947.6394.2.camel@mingming-laptop> <1217383118.27664.14.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso <tytso@mit.edu>, Shehjar Tikoo <shehjart@cse.unsw.edu.au>,
	linux-ext4@vger.kernel.org, Andreas Dilger <adilger@sun.com>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:41723 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756036AbYG3MSd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Jul 2008 08:18:33 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp01.au.ibm.com (8.13.1/8.13.1) with ESMTP id m6UCIlUR030653
	for <linux-ext4@vger.kernel.org>; Wed, 30 Jul 2008 22:18:47 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6UCH9IL4497604
	for <linux-ext4@vger.kernel.org>; Wed, 30 Jul 2008 22:17:09 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6UCH8nr002492
	for <linux-ext4@vger.kernel.org>; Wed, 30 Jul 2008 22:17:09 +1000
Content-Disposition: inline
In-Reply-To: <1217383118.27664.14.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Mingming,

This is the patch i was working on. The patch is still not complete.
But sending it early so that i can get some feedback.

commit a4546f0034fcfb0a20991378fe4a3cf6c157ad72
Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date:   Wed Jul 30 17:34:25 2008 +0530

    ext4: Rework the ext4_da_writepages
    
    With the below changes we reserve credit needed to insert only one extent
    resulting from a call to single get_block. That make sure we don't take
    too much journal credits during writeout. We also don't limit the pages
    to write. That means we loop through the dirty pages building largest
    possible contiguous block request. Then we issue a single get_block request.
    We may get less block that we requested. If so we would end up not mapping
    some of the buffer_heads. That means those buffer_heads are still marked delay.
    Later in the writepage callback via __mpage_writepage we redirty those pages.
    
    
    TODO:
    a) Some pages are leaked without unlock. So fsstress deadlock on lock_page
    b) range_start is not handled correctly in loop
    
    Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 5a394c8..23f55cf 100644
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
@@ -1604,9 +1606,10 @@ static int mpage_da_submit_io(struct mpage_da_data *mpd)
 		.get_block = mpd->get_block,
 		.use_writepage = 1,
 	};
-	int ret = 0, err, nr_pages, i;
+	int err, nr_pages, i;
 	unsigned long index, end;
 	struct pagevec pvec;
+	int written_pages = 0;
 
 	BUG_ON(mpd->next_page <= mpd->first_page);
 
@@ -1628,21 +1631,20 @@ static int mpage_da_submit_io(struct mpage_da_data *mpd)
 			index++;
 
 			err = __mpage_writepage(page, mpd->wbc, &mpd_pp);
-
+			if (!err)
+				written_pages++;
 			/*
 			 * In error case, we have to continue because
 			 * remaining pages are still locked
 			 * XXX: unlock and re-dirty them?
 			 */
-			if (ret == 0)
-				ret = err;
 		}
 		pagevec_release(&pvec);
 	}
 	if (mpd_pp.bio)
 		mpage_bio_submit(WRITE, mpd_pp.bio);
 
-	return ret;
+	return written_pages;
 }
 
 /*
@@ -1745,10 +1747,10 @@ static inline void __unmap_underlying_blocks(struct inode *inode,
  * The function ignores errors ->get_block() returns, thus real
  * error handling is postponed to __mpage_writepage()
  */
-static void mpage_da_map_blocks(struct mpage_da_data *mpd)
+static int mpage_da_map_blocks(struct mpage_da_data *mpd)
 {
+	int err = 0;
 	struct buffer_head *lbh = &mpd->lbh;
-	int err = 0, remain = lbh->b_size;
 	sector_t next = lbh->b_blocknr;
 	struct buffer_head new;
 
@@ -1756,37 +1758,33 @@ static void mpage_da_map_blocks(struct mpage_da_data *mpd)
 	 * We consider only non-mapped and non-allocated blocks
 	 */
 	if (buffer_mapped(lbh) && !buffer_delay(lbh))
-		return;
-
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
-
-		if (buffer_new(&new))
-			__unmap_underlying_blocks(mpd->inode, &new);
+		return 0;
 
+	new.b_state = lbh->b_state;
+	new.b_blocknr = 0;
+	new.b_size = lbh->b_size;
+	err = mpd->get_block(mpd->inode, next, &new, 1);
+	if (err) {
 		/*
-		 * If blocks are delayed marked, we need to
-		 * put actual blocknr and drop delayed bit
+		 * We failed to do block allocation. All
+		 * the pages will be redirtied later in
+		 * ext4_da_writepage
 		 */
-		if (buffer_delay(lbh))
-			mpage_put_bnr_to_bhs(mpd, next, &new);
-
-		/* go for the remaining blocks */
-		next += new.b_size >> mpd->inode->i_blkbits;
-		remain -= new.b_size;
+		return 0;
 	}
+	BUG_ON(new.b_size == 0);
+
+	if (buffer_new(&new))
+		__unmap_underlying_blocks(mpd->inode, &new);
+
+	/*
+	 * If blocks are delayed marked, we need to
+	 * put actual blocknr and drop delayed bit
+	 */
+	if (buffer_delay(lbh))
+		mpage_put_bnr_to_bhs(mpd, next, &new);
+
+	return new.b_size;
 }
 
 #define BH_FLAGS ((1 << BH_Uptodate) | (1 << BH_Mapped) | (1 << BH_Delay))
@@ -1800,7 +1798,7 @@ static void mpage_da_map_blocks(struct mpage_da_data *mpd)
  *
  * the function is used to collect contig. blocks in same state
  */
-static void mpage_add_bh_to_extent(struct mpage_da_data *mpd,
+static int mpage_add_bh_to_extent(struct mpage_da_data *mpd,
 				   sector_t logical, struct buffer_head *bh)
 {
 	struct buffer_head *lbh = &mpd->lbh;
@@ -1815,7 +1813,7 @@ static void mpage_add_bh_to_extent(struct mpage_da_data *mpd,
 		lbh->b_blocknr = logical;
 		lbh->b_size = bh->b_size;
 		lbh->b_state = bh->b_state & BH_FLAGS;
-		return;
+		return 0;
 	}
 
 	/*
@@ -1823,21 +1821,14 @@ static void mpage_add_bh_to_extent(struct mpage_da_data *mpd,
 	 */
 	if (logical == next && (bh->b_state & BH_FLAGS) == lbh->b_state) {
 		lbh->b_size += bh->b_size;
-		return;
+		return 0;
 	}
 
 	/*
 	 * We couldn't merge the block to our extent, so we
 	 * need to flush current  extent and start new one
 	 */
-	mpage_da_map_blocks(mpd);
-
-	/*
-	 * Now start a new extent
-	 */
-	lbh->b_size = bh->b_size;
-	lbh->b_state = bh->b_state & BH_FLAGS;
-	lbh->b_blocknr = logical;
+	return MPAGE_DA_EXTENT_TAIL;
 }
 
 /*
@@ -1852,6 +1843,7 @@ static void mpage_add_bh_to_extent(struct mpage_da_data *mpd,
 static int __mpage_da_writepage(struct page *page,
 				struct writeback_control *wbc, void *data)
 {
+	int ret = 0;
 	struct mpage_da_data *mpd = data;
 	struct inode *inode = mpd->inode;
 	struct buffer_head *bh, *head, fake;
@@ -1866,12 +1858,13 @@ static int __mpage_da_writepage(struct page *page,
 		 * and start IO on them using __mpage_writepage()
 		 */
 		if (mpd->next_page != mpd->first_page) {
-			mpage_da_map_blocks(mpd);
-			mpage_da_submit_io(mpd);
+			unlock_page(page);
+			ret = MPAGE_DA_EXTENT_TAIL;
+			goto finish_extent;
 		}
 
 		/*
-		 * Start next extent of pages ...
+		 * Start extent of pages ...
 		 */
 		mpd->first_page = page->index;
 
@@ -1897,7 +1890,7 @@ static int __mpage_da_writepage(struct page *page,
 		bh->b_state = 0;
 		set_buffer_dirty(bh);
 		set_buffer_uptodate(bh);
-		mpage_add_bh_to_extent(mpd, logical, bh);
+		ret = mpage_add_bh_to_extent(mpd, logical, bh);
 	} else {
 		/*
 		 * Page with regular buffer heads, just add all dirty ones
@@ -1906,13 +1899,17 @@ static int __mpage_da_writepage(struct page *page,
 		bh = head;
 		do {
 			BUG_ON(buffer_locked(bh));
-			if (buffer_dirty(bh))
-				mpage_add_bh_to_extent(mpd, logical, bh);
+			if (buffer_dirty(bh)) {
+				ret = mpage_add_bh_to_extent(mpd, logical, bh);
+				if (ret == MPAGE_DA_EXTENT_TAIL)
+					goto finish_extent;
+			}
 			logical++;
 		} while ((bh = bh->b_this_page) != head);
 	}
 
-	return 0;
+finish_extent:
+	return ret;
 }
 
 /*
@@ -1941,8 +1938,8 @@ static int mpage_da_writepages(struct address_space *mapping,
 			       struct writeback_control *wbc,
 			       get_block_t get_block)
 {
+	int ret, to_write, written_pages;
 	struct mpage_da_data mpd;
-	int ret;
 
 	if (!get_block)
 		return generic_writepages(mapping, wbc);
@@ -1956,16 +1953,20 @@ static int mpage_da_writepages(struct address_space *mapping,
 	mpd.next_page = 0;
 	mpd.get_block = get_block;
 
+	to_write = wbc->nr_to_write;
+
 	ret = write_cache_pages(mapping, wbc, __mpage_da_writepage, &mpd);
 
 	/*
-	 * Handle last extent of pages
+	 * Allocate blocks for the dirty delayed
+	 * pages found
 	 */
 	if (mpd.next_page != mpd.first_page) {
 		mpage_da_map_blocks(&mpd);
-		mpage_da_submit_io(&mpd);
+		written_pages =  mpage_da_submit_io(&mpd);
+		/* update nr_to_write correctly */
+		wbc->nr_to_write = to_write - written_pages;
 	}
-
 	return ret;
 }
 
@@ -2118,9 +2119,11 @@ static int ext4_da_writepage(struct page *page,
 			 * If we don't have mapping block we just ignore
 			 * them. We can also reach here via shrink_page_list
 			 */
+			start_pdflush = 1;
 			redirty_page_for_writepage(wbc, page);
 			unlock_page(page);
-			return 0;
+			ret = 0;
+			goto finish_ret;
 		}
 	} else {
 		/*
@@ -2143,9 +2146,11 @@ static int ext4_da_writepage(struct page *page,
 			/* check whether all are mapped and non delay */
 			if (walk_page_buffers(NULL, page_bufs, 0, len, NULL,
 						ext4_bh_unmapped_or_delay)) {
+				start_pdflush = 1;
 				redirty_page_for_writepage(wbc, page);
 				unlock_page(page);
-				return 0;
+				ret = 0;
+				goto finish_ret;
 			}
 		} else {
 			/*
@@ -2153,9 +2158,11 @@ static int ext4_da_writepage(struct page *page,
 			 * so just redity the page and unlock
 			 * and return
 			 */
+			start_pdflush = 1;
 			redirty_page_for_writepage(wbc, page);
 			unlock_page(page);
-			return 0;
+			ret = 0;
+			goto finish_ret;
 		}
 	}
 
@@ -2165,7 +2172,7 @@ static int ext4_da_writepage(struct page *page,
 		ret = block_write_full_page(page,
 						ext4_normal_get_block_write,
 						wbc);
-
+finish_ret:
 	return ret;
 }
 
@@ -2201,19 +2208,14 @@ static int ext4_da_writepages(struct address_space *mapping,
 	}
 
 	while (!ret && to_write) {
-		/*
-		 * set the max dirty pages could be write at a time
-		 * to fit into the reserved transaction credits
-		 */
-		if (wbc->nr_to_write > EXT4_MAX_WRITEBACK_PAGES)
-			wbc->nr_to_write = EXT4_MAX_WRITEBACK_PAGES;
 
 		/*
-		 * Estimate the worse case needed credits to write out
-		 * to_write pages
+		 * We write only a single extent in a loop.
+		 * So allocate credit needed to write a single
+		 * extent. journalled mode is not supported.
 		 */
-		needed_blocks = ext4_writepages_trans_blocks(inode,
-							     wbc->nr_to_write);
+		BUG_ON(ext4_should_journal_data(inode));
+		needed_blocks = EXT4_DATA_TRANS_BLOCKS(inode->i_sb);
 
 		/* start a new transaction*/
 		handle = ext4_journal_start(inode, needed_blocks);
@@ -2239,7 +2241,19 @@ static int ext4_da_writepages(struct address_space *mapping,
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
+			/*
+			 * Try to write from the start
+			 * The pages already written will
+			 * not be tagged dirty
+			 */
+			//wbc->range_start = range_start;
+		} else if (wbc->nr_to_write) {
 			/*
 			 * There is no more writeout needed
 			 * or we requested for a noblocking writeout
