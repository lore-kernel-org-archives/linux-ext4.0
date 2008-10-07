From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] Improve buffered streaming write ordering
Date: Tue, 7 Oct 2008 14:15:31 +0530
Message-ID: <20081007084531.GB15881@skywalker>
References: <1222886451.9158.34.camel@think.oraclecorp.com> <20081001215239.ee2ae63f.akpm@linux-foundation.org> <1222950054.6745.18.camel@think.oraclecorp.com> <20081002181856.GB29613@skywalker> <20081002234309.GH30001@disturbed> <1223063155.13375.64.camel@think.oraclecorp.com> <20081006101605.GA15881@skywalker> <1223302903.16546.58.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Chinner <david@fromorbit.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	ext4 <linux-ext4@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1223302903.16546.58.camel@think.oraclecorp.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Oct 06, 2008 at 10:21:43AM -0400, Chris Mason wrote:
> On Mon, 2008-10-06 at 15:46 +0530, Aneesh Kumar K.V wrote:
> > On Fri, Oct 03, 2008 at 03:45:55PM -0400, Chris Mason wrote:
> > > On Fri, 2008-10-03 at 09:43 +1000, Dave Chinner wrote:
> > > > On Thu, Oct 02, 2008 at 11:48:56PM +0530, Aneesh Kumar K.V wrote:
> > > > > On Thu, Oct 02, 2008 at 08:20:54AM -0400, Chris Mason wrote:
> > > > > > On Wed, 2008-10-01 at 21:52 -0700, Andrew Morton wrote:
> > > > > > For a 4.5GB streaming buffered write, this printk inside
> > > > > > ext4_da_writepage shows up 37,2429 times in /var/log/messages.
> > > > > > 
> > > > > 
> > > > > Part of that can happen due to shrink_page_list -> pageout -> writepagee
> > > > > call back with lots of unallocated buffer_heads(blocks).
> > > > 
> > > > Quite frankly, a simple streaming buffered write should *never*
> > > > trigger writeback from the LRU in memory reclaim.
> > > 
> > > The blktrace runs on ext4 didn't show kswapd doing any IO.  It isn't
> > > clear if this is because ext4 did the redirty trick or if kswapd didn't
> > > call writepage.
> > > 
> > > -chris
> > 
> > This patch actually reduced the number of extents for the below test
> > from 564 to 171.
> > 
> 
> For my array, this patch brings the number of ext4 extents down from
> over 4000 to 27.  The throughput reported by dd goes up from ~80MB/s to
> 330MB/s, which means buffered IO is going as fast as O_DIRECT.
> 
> Here's the graph:
> 
> http://oss.oracle.com/~mason/bugs/writeback_ordering/ext4-aneesh.png
> 
> The strange metadata writeback for the uninit block groups is gone.
> 
> Looking at the patch, I think the ext4_writepages code should just make
> its own write_cache_pages.  It's pretty hard to follow the code that is
> there for ext4 vs the code that is there to make write_cache_pages do
> what ext4 expects it to.
> 

How about the below ? The patch is on top of ext4 patchqueue.

commit 9b839065f973eb68e8e28be18e1f31d8fb6854ee
Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date:   Tue Oct 7 12:27:52 2008 +0530

    ext4: Fix file fragmentation during large file write.
    
    The range_cyclic writeback mode use the address_space
    writeback_index as the start index for writeback. With
    delayed allocation we were updating writeback_index
    wrongly resulting in highly fragmented file. Number of
    extents reduced from 4000 to 27 for a 3GB file with
    the below patch.
    
    The patch also cleanup the ext4 delayed allocation writepages
    by implementing write_cache_pages locally with needed changes
    for cleanup. Also it drops the range_cont writeback mode added
    for ext4 delayed allocation writeback
    
    Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 21f1d3a..b6b0985 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1648,6 +1648,7 @@ static int mpage_da_submit_io(struct mpage_da_data *mpd)
 	int ret = 0, err, nr_pages, i;
 	unsigned long index, end;
 	struct pagevec pvec;
+	long pages_skipped;
 
 	BUG_ON(mpd->next_page <= mpd->first_page);
 	pagevec_init(&pvec, 0);
@@ -1655,20 +1656,30 @@ static int mpage_da_submit_io(struct mpage_da_data *mpd)
 	end = mpd->next_page - 1;
 
 	while (index <= end) {
-		/* XXX: optimize tail */
-		nr_pages = pagevec_lookup(&pvec, mapping, index, PAGEVEC_SIZE);
+		/*
+		 * We can use PAGECACHE_TAG_DIRTY lookup here because
+		 * even though we have cleared the dirty flag on the page
+		 * We still keep the page in the radix tree with tag
+		 * PAGECACHE_TAG_DIRTY. See clear_page_dirty_for_io.
+		 * The PAGECACHE_TAG_DIRTY is cleared in set_page_writeback
+		 * which is called via the below writepage callback.
+		 */
+		nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
+					PAGECACHE_TAG_DIRTY,
+					min(end - index,
+					(pgoff_t)PAGEVEC_SIZE-1) + 1);
 		if (nr_pages == 0)
 			break;
 		for (i = 0; i < nr_pages; i++) {
 			struct page *page = pvec.pages[i];
 
-			index = page->index;
-			if (index > end)
-				break;
-			index++;
-
+			pages_skipped = mpd->wbc->pages_skipped;
 			err = mapping->a_ops->writepage(page, mpd->wbc);
-			if (!err)
+			if (!err && (pages_skipped == mpd->wbc->pages_skipped))
+				/*
+				 * have successfully written the page
+				 * without skipping the same
+				 */
 				mpd->pages_written++;
 			/*
 			 * In error case, we have to continue because
@@ -2088,6 +2099,100 @@ static int __mpage_da_writepage(struct page *page,
 	return 0;
 }
 
+static int ext4_write_cache_pages(struct address_space *mapping,
+		      struct writeback_control *wbc, writepage_t writepage,
+		      void *data)
+{
+	struct pagevec pvec;
+	pgoff_t index, end;
+	long to_write = wbc->nr_to_write;
+	int ret = 0, done = 0, scanned = 0, nr_pages;
+	struct backing_dev_info *bdi = mapping->backing_dev_info;
+
+	if (wbc->nonblocking && bdi_write_congested(bdi)) {
+		wbc->encountered_congestion = 1;
+		return 0;
+	}
+
+	pagevec_init(&pvec, 0);
+	if (wbc->range_cyclic) {
+		index = mapping->writeback_index; /* Start from prev offset */
+		end = -1;
+	} else {
+		index = wbc->range_start >> PAGE_CACHE_SHIFT;
+		end = wbc->range_end >> PAGE_CACHE_SHIFT;
+		scanned = 1;
+	}
+retry:
+	while (!done && (index <= end) &&
+	       (nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
+					      PAGECACHE_TAG_DIRTY,
+					      min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1))) {
+		unsigned i;
+
+		scanned = 1;
+		for (i = 0; i < nr_pages; i++) {
+			struct page *page = pvec.pages[i];
+
+			/*
+			 * At this point we hold neither mapping->tree_lock nor
+			 * lock on the page itself: the page may be truncated or
+			 * invalidated (changing page->mapping to NULL), or even
+			 * swizzled back from swapper_space to tmpfs file
+			 * mapping
+			 */
+			lock_page(page);
+
+			if (unlikely(page->mapping != mapping)) {
+				unlock_page(page);
+				continue;
+			}
+			if (!wbc->range_cyclic && page->index > end) {
+				done = 1;
+				unlock_page(page);
+				continue;
+			}
+			if (wbc->sync_mode != WB_SYNC_NONE)
+				wait_on_page_writeback(page);
+
+			if (PageWriteback(page) ||
+			    !clear_page_dirty_for_io(page)) {
+				unlock_page(page);
+				continue;
+			}
+			ret = (*writepage)(page, wbc, data);
+			if (unlikely(ret == AOP_WRITEPAGE_ACTIVATE)) {
+				unlock_page(page);
+				ret = 0;
+			}
+			if (ret || (--(to_write) <= 0))
+				/*
+				 * writepage either failed.
+				 * or did an extent write.
+				 * We wrote what we are asked to
+				 * write
+				 */
+				done = 1;
+			if (wbc->nonblocking && bdi_write_congested(bdi)) {
+				wbc->encountered_congestion = 1;
+				done = 1;
+			}
+		}
+		pagevec_release(&pvec);
+		cond_resched();
+	}
+	if (!scanned && !done) {
+		/*
+		 * We hit the last page and there is more work to be done: wrap
+		 * back to the start of the file
+		 */
+		scanned = 1;
+		index = 0;
+		goto retry;
+	}
+	return ret;
+}
+
 /*
  * mpage_da_writepages - walk the list of dirty pages of the given
  * address space, allocates non-allocated blocks, maps newly-allocated
@@ -2104,7 +2209,6 @@ static int mpage_da_writepages(struct address_space *mapping,
 			       struct writeback_control *wbc,
 			       struct mpage_da_data *mpd)
 {
-	long to_write;
 	int ret;
 
 	if (!mpd->get_block)
@@ -2119,10 +2223,7 @@ static int mpage_da_writepages(struct address_space *mapping,
 	mpd->pages_written = 0;
 	mpd->retval = 0;
 
-	to_write = wbc->nr_to_write;
-
-	ret = write_cache_pages(mapping, wbc, __mpage_da_writepage, mpd);
-
+	ret = ext4_write_cache_pages(mapping, wbc, __mpage_da_writepage, mpd);
 	/*
 	 * Handle last extent of pages
 	 */
@@ -2131,7 +2232,7 @@ static int mpage_da_writepages(struct address_space *mapping,
 			mpage_da_submit_io(mpd);
 	}
 
-	wbc->nr_to_write = to_write - mpd->pages_written;
+	wbc->nr_to_write -= mpd->pages_written;
 	return ret;
 }
 
@@ -2360,12 +2461,13 @@ static int ext4_da_writepages_trans_blocks(struct inode *inode)
 static int ext4_da_writepages(struct address_space *mapping,
 			      struct writeback_control *wbc)
 {
+	pgoff_t	index;
+	int range_whole = 0;
 	handle_t *handle = NULL;
-	loff_t range_start = 0;
+	long pages_written = 0;
 	struct mpage_da_data mpd;
 	struct inode *inode = mapping->host;
 	int needed_blocks, ret = 0, nr_to_writebump = 0;
-	long to_write, pages_skipped = 0;
 	struct ext4_sb_info *sbi = EXT4_SB(mapping->host->i_sb);
 
 	/*
@@ -2385,23 +2487,18 @@ static int ext4_da_writepages(struct address_space *mapping,
 		nr_to_writebump = sbi->s_mb_stream_request - wbc->nr_to_write;
 		wbc->nr_to_write = sbi->s_mb_stream_request;
 	}
+	if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
+		range_whole = 1;
 
-	if (!wbc->range_cyclic)
-		/*
-		 * If range_cyclic is not set force range_cont
-		 * and save the old writeback_index
-		 */
-		wbc->range_cont = 1;
-
-	range_start =  wbc->range_start;
-	pages_skipped = wbc->pages_skipped;
+	if (wbc->range_cyclic)
+		index = mapping->writeback_index;
+	else
+		index = wbc->range_start >> PAGE_CACHE_SHIFT;
 
 	mpd.wbc = wbc;
 	mpd.inode = mapping->host;
 
-restart_loop:
-	to_write = wbc->nr_to_write;
-	while (!ret && to_write > 0) {
+	while (!ret && wbc->nr_to_write > 0) {
 
 		/*
 		 * we  insert one extent at a time. So we need
@@ -2422,48 +2519,45 @@ static int ext4_da_writepages(struct address_space *mapping,
 			dump_stack();
 			goto out_writepages;
 		}
-		to_write -= wbc->nr_to_write;
-
 		mpd.get_block = ext4_da_get_block_write;
 		ret = mpage_da_writepages(mapping, wbc, &mpd);
 
 		ext4_journal_stop(handle);
 
-		if (mpd.retval == -ENOSPC)
+		if (mpd.retval == -ENOSPC) {
+			/* commit the transaction which would
+			 * free blocks released in the transaction
+			 * and try again
+			 */
 			jbd2_journal_force_commit_nested(sbi->s_journal);
-
-		/* reset the retry count */
-		if (ret == MPAGE_DA_EXTENT_TAIL) {
+			ret = 0;
+		} else if (ret == MPAGE_DA_EXTENT_TAIL) {
 			/*
 			 * got one extent now try with
 			 * rest of the pages
 			 */
-			to_write += wbc->nr_to_write;
+			pages_written += mpd.pages_written;
 			ret = 0;
-		} else if (wbc->nr_to_write) {
+		} else if (wbc->nr_to_write)
 			/*
 			 * There is no more writeout needed
 			 * or we requested for a noblocking writeout
 			 * and we found the device congested
 			 */
-			to_write += wbc->nr_to_write;
 			break;
-		}
-		wbc->nr_to_write = to_write;
 	}
 
-	if (wbc->range_cont && (pages_skipped != wbc->pages_skipped)) {
-		/* We skipped pages in this loop */
-		wbc->range_start = range_start;
-		wbc->nr_to_write = to_write +
-				wbc->pages_skipped - pages_skipped;
-		wbc->pages_skipped = pages_skipped;
-		goto restart_loop;
-	}
+	/* Update index */
+	index += pages_written;
+	if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))
+		/*
+		 * set the writeback_index so that range_cyclic
+		 * mode will write it back later
+		 */
+		mapping->writeback_index = index;
 
 out_writepages:
-	wbc->nr_to_write = to_write - nr_to_writebump;
-	wbc->range_start = range_start;
+	wbc->nr_to_write -= nr_to_writebump;
 	return ret;
 }
 
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 12b15c5..bd91987 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -63,7 +63,6 @@ struct writeback_control {
 	unsigned for_writepages:1;	/* This is a writepages() call */
 	unsigned range_cyclic:1;	/* range_start is cyclic */
 	unsigned more_io:1;		/* more io to be dispatched */
-	unsigned range_cont:1;
 };
 
 /*
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 24de8b6..718efa6 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -961,8 +961,6 @@ int write_cache_pages(struct address_space *mapping,
 	if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))
 		mapping->writeback_index = index;
 
-	if (wbc->range_cont)
-		wbc->range_start = index << PAGE_CACHE_SHIFT;
 	return ret;
 }
 EXPORT_SYMBOL(write_cache_pages);
