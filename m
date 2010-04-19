From: <gregkh@suse.de>
Subject: patch ext4-use-tag-dirty-lookup-during-mpage_da_submit_io.patch added to 2.6.27-stable tree
Date: Mon, 19 Apr 2010 10:27:03 -0700
Message-ID: <12716980233722@kroah.org>
References: <1268699165-17461-8-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
To: aneesh.kumar@linux.vnet.ibm.com, dev@jaysonking.com,
	gregkh@suse.de, linux-ext4@vger.kernel.org, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:48478 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752425Ab0DSRaB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Apr 2010 13:30:01 -0400
In-Reply-To: <1268699165-17461-8-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


This is a note to let you know that we have just queued up the patch titled

    Subject: ext4: Use tag dirty lookup during mpage_da_submit_io

to the 2.6.27-stable tree.  Its filename is

    ext4-use-tag-dirty-lookup-during-mpage_da_submit_io.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From tytso@mit.edu  Mon Apr 19 10:22:28 2010
From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date: Mon, 15 Mar 2010 20:26:01 -0400
Subject: ext4: Use tag dirty lookup during mpage_da_submit_io
To: stable@kernel.org
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, "Theodore Ts'o" <tytso@mit.edu>, "Jayson R. King" <dev@jaysonking.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Message-ID: <1268699165-17461-8-git-send-email-tytso@mit.edu>


From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

commit af6f029d3836eb7264cd3fbb13a6baf0e5fdb5ea upstream.

This enables us to drop the range_cont writeback mode
use from ext4_da_writepages.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Jayson R. King <dev@jaysonking.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/inode.c |   30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1699,17 +1699,23 @@ static int mpage_da_submit_io(struct mpa
 
 	pagevec_init(&pvec, 0);
 	while (index <= end) {
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
 			BUG_ON(!PageLocked(page));
 			BUG_ON(PageWriteback(page));
 
@@ -2442,7 +2448,6 @@ static int ext4_da_writepages(struct add
 			      struct writeback_control *wbc)
 {
 	handle_t *handle = NULL;
-	loff_t range_start = 0;
 	struct mpage_da_data mpd;
 	struct inode *inode = mapping->host;
 	int needed_blocks, ret = 0, nr_to_writebump = 0;
@@ -2481,14 +2486,7 @@ static int ext4_da_writepages(struct add
 		wbc->nr_to_write = sbi->s_mb_stream_request;
 	}
 
-	if (!wbc->range_cyclic)
-		/*
-		 * If range_cyclic is not set force range_cont
-		 * and save the old writeback_index
-		 */
-		wbc->range_cont = 1;
 
-	range_start =  wbc->range_start;
 	pages_skipped = wbc->pages_skipped;
 
 	mpd.wbc = wbc;
@@ -2559,9 +2557,8 @@ restart_loop:
 		wbc->nr_to_write = to_write;
 	}
 
-	if (wbc->range_cont && (pages_skipped != wbc->pages_skipped)) {
+	if (!wbc->range_cyclic && (pages_skipped != wbc->pages_skipped)) {
 		/* We skipped pages in this loop */
-		wbc->range_start = range_start;
 		wbc->nr_to_write = to_write +
 				wbc->pages_skipped - pages_skipped;
 		wbc->pages_skipped = pages_skipped;
@@ -2570,7 +2567,6 @@ restart_loop:
 
 out_writepages:
 	wbc->nr_to_write = to_write - nr_to_writebump;
-	wbc->range_start = range_start;
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
