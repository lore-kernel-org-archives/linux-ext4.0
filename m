From: <gregkh@suse.de>
Subject: patch ext4-fix-file-fragmentation-during-large-file-write.patch added to 2.6.27-stable tree
Date: Mon, 19 Apr 2010 10:26:50 -0700
Message-ID: <12716980102194@kroah.org>
References: <1268699165-17461-11-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
To: aneesh.kumar@linux.vnet.ibm.com, dev@jaysonking.com,
	gregkh@suse.de, linux-ext4@vger.kernel.org, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:48443 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890Ab0DSR34 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Apr 2010 13:29:56 -0400
In-Reply-To: <1268699165-17461-11-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


This is a note to let you know that we have just queued up the patch titled

    Subject: ext4: Fix file fragmentation during large file write.

to the 2.6.27-stable tree.  Its filename is

    ext4-fix-file-fragmentation-during-large-file-write.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From tytso@mit.edu  Mon Apr 19 10:23:42 2010
From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date: Mon, 15 Mar 2010 20:26:04 -0400
Subject: ext4: Fix file fragmentation during large file write.
To: stable@kernel.org
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, "Theodore Ts'o" <tytso@mit.edu>, "Jayson R. King" <dev@jaysonking.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Message-ID: <1268699165-17461-11-git-send-email-tytso@mit.edu>


From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

commit 22208dedbd7626e5fc4339c417f8d24cc21f79d7 upstream.

The range_cyclic writeback mode uses the address_space writeback_index
as the start index for writeback.  With delayed allocation we were
updating writeback_index wrongly resulting in highly fragmented file.
This patch reduces the number of extents reduced from 4000 to 27 for a
3GB file.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
[dev@jaysonking.com: Some changed lines from the original version of this patch were dropped, since they were rolled up with another cherry-picked patch applied to 2.6.27.y earlier.]
Signed-off-by: Jayson R. King <dev@jaysonking.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/inode.c |   88 +++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 55 insertions(+), 33 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
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
@@ -2175,7 +2179,6 @@ static int mpage_da_writepages(struct ad
 			       struct writeback_control *wbc,
 			       struct mpage_da_data *mpd)
 {
-	long to_write;
 	int ret;
 
 	if (!mpd->get_block)
@@ -2190,19 +2193,18 @@ static int mpage_da_writepages(struct ad
 	mpd->pages_written = 0;
 	mpd->retval = 0;
 
-	to_write = wbc->nr_to_write;
-
 	ret = write_cache_pages(mapping, wbc, __mpage_da_writepage, mpd);
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
 
@@ -2447,11 +2449,14 @@ static int ext4_da_writepages_trans_bloc
 static int ext4_da_writepages(struct address_space *mapping,
 			      struct writeback_control *wbc)
 {
+	pgoff_t	index;
+	int range_whole = 0;
 	handle_t *handle = NULL;
 	struct mpage_da_data mpd;
 	struct inode *inode = mapping->host;
+	int no_nrwrite_index_update;
+	long pages_written = 0, pages_skipped;
 	int needed_blocks, ret = 0, nr_to_writebump = 0;
-	long to_write, pages_skipped = 0;
 	struct ext4_sb_info *sbi = EXT4_SB(mapping->host->i_sb);
 
 	/*
@@ -2485,16 +2490,26 @@ static int ext4_da_writepages(struct add
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
+	no_nrwrite_index_update = wbc->no_nrwrite_index_update;
+	wbc->no_nrwrite_index_update = 1;
+	pages_skipped = wbc->pages_skipped;
+
+	while (!ret && wbc->nr_to_write > 0) {
 
 		/*
 		 * we  insert one extent at a time. So we need
@@ -2527,46 +2542,53 @@ restart_loop:
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
-	}
-
-	if (!wbc->range_cyclic && (pages_skipped != wbc->pages_skipped)) {
-		/* We skipped pages in this loop */
-		wbc->nr_to_write = to_write +
-				wbc->pages_skipped - pages_skipped;
-		wbc->pages_skipped = pages_skipped;
-		goto restart_loop;
 	}
+	if (pages_skipped != wbc->pages_skipped)
+		printk(KERN_EMERG "This should not happen leaving %s "
+				"with nr_to_write = %ld ret = %d\n",
+				__func__, wbc->nr_to_write, ret);
+
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
+	if (!no_nrwrite_index_update)
+		wbc->no_nrwrite_index_update = 0;
+	wbc->nr_to_write -= nr_to_writebump;
 	return ret;
 }
 


Patches currently in stable-queue which might be from aneesh.kumar@linux.vnet.ibm.com are

queue-2.6.27/ext4-fix-file-fragmentation-during-large-file-write.patch
queue-2.6.27/ext4-retry-block-allocation-if-we-have-free-blocks-left.patch
queue-2.6.27/vfs-add-no_nrwrite_index_update-writeback-control-flag.patch
queue-2.6.27/ext4-retry-block-reservation.patch
queue-2.6.27/ext4-invalidate-pages-if-delalloc-block-allocation-fails.patch
queue-2.6.27/ext4-use-tag-dirty-lookup-during-mpage_da_submit_io.patch
queue-2.6.27/vfs-remove-the-range_cont-writeback-mode.patch
queue-2.6.27/ext4-make-sure-all-the-block-allocation-paths-reserve-blocks.patch
queue-2.6.27/ext4-implement-range_cyclic-in-ext4_da_writepages-instead-of-write_cache_pages.patch
queue-2.6.27/ext4-add-percpu-dirty-block-accounting.patch
