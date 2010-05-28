From: "Jayson R. King" <dev@jaysonking.com>
Subject: [PATCH 2.6.27.y 2/3] ext4: Fix file fragmentation during large file
 write.
Date: Fri, 28 May 2010 14:26:57 -0500
Message-ID: <4C001901.1070207@jaysonking.com>
References: <4C001888.8020006@jaysonking.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Jayson R. King" <dev@jaysonking.com>,
	Theodore Ts'o <tytso@mit.edu>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Dave Chinner <david@fromorbit.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Kay Diederichs <Kay.Diederichs@uni-konstanz.de>
To: Stable team <stable@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bosmailout19.eigbox.net ([66.96.184.19]:39845 "EHLO
	bosmailout19.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635Ab0E1UD4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 May 2010 16:03:56 -0400
In-Reply-To: <4C001888.8020006@jaysonking.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date: Thu Oct 16 10:10:36 2008 -0400
Subject: ext4: Fix file fragmentation during large file write.

commit 22208dedbd7626e5fc4339c417f8d24cc21f79d7 upstream.

The range_cyclic writeback mode uses the address_space writeback_index
as the start index for writeback.  With delayed allocation we were
updating writeback_index wrongly resulting in highly fragmented file.
This patch reduces the number of extents reduced from 4000 to 27 for a
3GB file.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
[dev@jaysonking.com: Some changed lines from the original version of this patch were dropped, since they were rolled up with another cherry-picked patch applied to 2.6.27.y earlier.]
[dev@jaysonking.com: Use of wbc->no_nrwrite_index_update was dropped, since write_cache_pages_da() implies it.]
Signed-off-by: Jayson R. King <dev@jaysonking.com>

---
 fs/ext4/inode.c |   77 ++++++++++++++++++++++++++--------------------
 1 file changed, 45 insertions(+), 32 deletions(-)

diff -udrNp linux-2.6.27.orig/fs/ext4/inode.c linux-2.6.27/fs/ext4/inode.c
--- linux-2.6.27.orig/fs/ext4/inode.c	2010-05-28 12:52:08.450963139 -0500
+++ linux-2.6.27/fs/ext4/inode.c	2010-05-28 12:52:18.258962978 -0500
@@ -1721,7 +1721,11 @@ static int mpage_da_submit_io(struct mpa
 
 			pages_skipped = mpd->wbc->pages_skipped;
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
@@ -2295,7 +2299,6 @@ static int mpage_da_writepages(struct ad
 			       struct writeback_control *wbc,
 			       struct mpage_da_data *mpd)
 {
-	long to_write;
 	int ret;
 
 	if (!mpd->get_block)
@@ -2310,19 +2313,18 @@ static int mpage_da_writepages(struct ad
 	mpd->pages_written = 0;
 	mpd->retval = 0;
 
-	to_write = wbc->nr_to_write;
-
 	ret = write_cache_pages_da(mapping, wbc, mpd);
-
 	/*
 	 * Handle last extent of pages
 	 */
 	if (!mpd->io_done && mpd->next_page != mpd->first_page) {
 		if (mpage_da_map_blocks(mpd) == 0)
 			mpage_da_submit_io(mpd);
-	}
 
-	wbc->nr_to_write = to_write - mpd->pages_written;
+		mpd->io_done = 1;
+		ret = MPAGE_DA_EXTENT_TAIL;
+	}
+	wbc->nr_to_write -= mpd->pages_written;
 	return ret;
 }
 
@@ -2567,11 +2569,13 @@ static int ext4_da_writepages_trans_bloc
 static int ext4_da_writepages(struct address_space *mapping,
 			      struct writeback_control *wbc)
 {
+	pgoff_t	index;
+	int range_whole = 0;
 	handle_t *handle = NULL;
 	struct mpage_da_data mpd;
 	struct inode *inode = mapping->host;
+	long pages_written = 0, pages_skipped;
 	int needed_blocks, ret = 0, nr_to_writebump = 0;
-	long to_write, pages_skipped = 0;
 	struct ext4_sb_info *sbi = EXT4_SB(mapping->host->i_sb);
 
 	/*
@@ -2605,16 +2609,20 @@ static int ext4_da_writepages(struct add
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
+	pages_skipped = wbc->pages_skipped;
+
+	while (!ret && wbc->nr_to_write > 0) {
 
 		/*
 		 * we  insert one extent at a time. So we need
@@ -2647,46 +2655,51 @@ restart_loop:
 				goto out_writepages;
 			}
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
+			wbc->pages_skipped = pages_skipped;
+			ret = 0;
+		} else if (ret == MPAGE_DA_EXTENT_TAIL) {
 			/*
 			 * got one extent now try with
 			 * rest of the pages
 			 */
-			to_write += wbc->nr_to_write;
+			pages_written += mpd.pages_written;
+			wbc->pages_skipped = pages_skipped;
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
+	if (pages_skipped != wbc->pages_skipped)
+		printk(KERN_EMERG "This should not happen leaving %s "
+				"with nr_to_write = %ld ret = %d\n",
+				__func__, wbc->nr_to_write, ret);
 
-	if (!wbc->range_cyclic && (pages_skipped != wbc->pages_skipped)) {
-		/* We skipped pages in this loop */
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
+	wbc->nr_to_write -= nr_to_writebump;
 	return ret;
 }
 
