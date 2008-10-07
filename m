From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Fix file fragmentation during large file write.
Date: Tue,  7 Oct 2008 14:17:02 +0530
Message-ID: <1223369222-19953-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:38410 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbYJGIrK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Oct 2008 04:47:10 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id m978k6kL006849
	for <linux-ext4@vger.kernel.org>; Tue, 7 Oct 2008 19:46:06 +1100
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m978l7nB045972
	for <linux-ext4@vger.kernel.org>; Tue, 7 Oct 2008 19:47:08 +1100
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m978l7ul026950
	for <linux-ext4@vger.kernel.org>; Tue, 7 Oct 2008 19:47:07 +1100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

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
---
 fs/ext4/inode.c           |  192 +++++++++++++++++++++++++++++++++------------
 include/linux/writeback.h |    1 -
 mm/page-writeback.c       |    2 -
 3 files changed, 143 insertions(+), 52 deletions(-)

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
-- 
1.6.0.1.285.g1070

