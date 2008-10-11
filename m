From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 4/4] ext4: Fix file fragmentation during large file write.
Date: Sun, 12 Oct 2008 00:34:40 +0530
Message-ID: <1223751880-16325-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1223751880-16325-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1223751880-16325-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1223751880-16325-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com, npiggin@suse.de
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:37977 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762432AbYJKTFB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 11 Oct 2008 15:05:01 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp01.au.ibm.com (8.13.1/8.13.1) with ESMTP id m9BJ58HJ012818
	for <linux-ext4@vger.kernel.org>; Sun, 12 Oct 2008 06:05:08 +1100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m9BJ4xgd242518
	for <linux-ext4@vger.kernel.org>; Sun, 12 Oct 2008 06:04:59 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m9BJ4w1W003958
	for <linux-ext4@vger.kernel.org>; Sun, 12 Oct 2008 06:04:59 +1100
In-Reply-To: <1223751880-16325-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The range_cyclic writeback mode uses the address_space writeback_index
as the start index for writeback.  With delayed allocation we were
updating writeback_index wrongly resulting in highly fragmented file.
Number of extents reduced from 4000 to 27 for a 3GB file with the below
patch.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/inode.c |   83 +++++++++++++++++++++++++++++++++----------------------
 1 files changed, 50 insertions(+), 33 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index cba7960..844c136 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1648,6 +1648,7 @@ static int mpage_da_submit_io(struct mpage_da_data *mpd)
 	int ret = 0, err, nr_pages, i;
 	unsigned long index, end;
 	struct pagevec pvec;
+	long pages_skipped;
 
 	BUG_ON(mpd->next_page <= mpd->first_page);
 	pagevec_init(&pvec, 0);
@@ -1655,7 +1656,6 @@ static int mpage_da_submit_io(struct mpage_da_data *mpd)
 	end = mpd->next_page - 1;
 
 	while (index <= end) {
-		/* XXX: optimize tail */
 		/*
 		 * We can use PAGECACHE_TAG_DIRTY lookup here because
 		 * even though we have cleared the dirty flag on the page
@@ -1673,8 +1673,13 @@ static int mpage_da_submit_io(struct mpage_da_data *mpd)
 		for (i = 0; i < nr_pages; i++) {
 			struct page *page = pvec.pages[i];
 
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
@@ -2110,7 +2115,6 @@ static int mpage_da_writepages(struct address_space *mapping,
 			       struct writeback_control *wbc,
 			       struct mpage_da_data *mpd)
 {
-	long to_write;
 	int ret;
 
 	if (!mpd->get_block)
@@ -2125,10 +2129,7 @@ static int mpage_da_writepages(struct address_space *mapping,
 	mpd->pages_written = 0;
 	mpd->retval = 0;
 
-	to_write = wbc->nr_to_write;
-
 	ret = write_cache_pages(mapping, wbc, __mpage_da_writepage, mpd);
-
 	/*
 	 * Handle last extent of pages
 	 */
@@ -2137,7 +2138,7 @@ static int mpage_da_writepages(struct address_space *mapping,
 			mpage_da_submit_io(mpd);
 	}
 
-	wbc->nr_to_write = to_write - mpd->pages_written;
+	wbc->nr_to_write -= mpd->pages_written;
 	return ret;
 }
 
@@ -2366,11 +2367,14 @@ static int ext4_da_writepages_trans_blocks(struct inode *inode)
 static int ext4_da_writepages(struct address_space *mapping,
 			      struct writeback_control *wbc)
 {
+	pgoff_t	index;
+	int range_whole = 0;
 	handle_t *handle = NULL;
+	long pages_written = 0;
 	struct mpage_da_data mpd;
 	struct inode *inode = mapping->host;
+	int no_nrwrite_update, no_index_update;
 	int needed_blocks, ret = 0, nr_to_writebump = 0;
-	long to_write, pages_skipped = 0;
 	struct ext4_sb_info *sbi = EXT4_SB(mapping->host->i_sb);
 
 	/*
@@ -2390,16 +2394,27 @@ static int ext4_da_writepages(struct address_space *mapping,
 		nr_to_writebump = sbi->s_mb_stream_request - wbc->nr_to_write;
 		wbc->nr_to_write = sbi->s_mb_stream_request;
 	}
+	if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
+		range_whole = 1;
 
-
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
+	/*
+	 * we don't want write_cache_pages to update
+	 * nr_to_write and writeback_index
+	 */
+	no_nrwrite_update = wbc->no_nrwrite_update;
+	wbc->no_nrwrite_update = 1;
+	no_index_update = wbc->no_index_update;
+	wbc->no_index_update   = 1;
+
+	while (!ret && wbc->nr_to_write > 0) {
 
 		/*
 		 * we  insert one extent at a time. So we need
@@ -2420,46 +2435,48 @@ static int ext4_da_writepages(struct address_space *mapping,
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
-	}
-
-	if (!wbc->range_cyclic && (pages_skipped != wbc->pages_skipped)) {
-		/* We skipped pages in this loop */
-		wbc->nr_to_write = to_write +
-				wbc->pages_skipped - pages_skipped;
-		wbc->pages_skipped = pages_skipped;
-		goto restart_loop;
 	}
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
+	if (!no_nrwrite_update)
+		wbc->no_nrwrite_update = 0;
+	if (!no_index_update)
+		wbc->no_index_update   = 0;
+	wbc->nr_to_write -= nr_to_writebump;
 	return ret;
 }
 
-- 
1.6.0.2.514.g23abd3

