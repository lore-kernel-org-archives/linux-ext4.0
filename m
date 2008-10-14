From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Use tag dirty lookup during mpage_da_submit_io
Date: Tue, 14 Oct 2008 12:03:24 +0530
Message-ID: <1223966008-6656-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1223966008-6656-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1223966008-6656-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, cmm@us.ibm.com, tytso@mit.edu,
	sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:39228 "EHLO
	e28esmtp05.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752753AbYJNGdo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Oct 2008 02:33:44 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp05.in.ibm.com (8.13.1/8.13.1) with ESMTP id m9E6XgBS011365
	for <linux-ext4@vger.kernel.org>; Tue, 14 Oct 2008 12:03:42 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m9E6Xfxx729234
	for <linux-ext4@vger.kernel.org>; Tue, 14 Oct 2008 12:03:42 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id m9E6Xe9n004661
	for <linux-ext4@vger.kernel.org>; Tue, 14 Oct 2008 12:03:41 +0530
In-Reply-To: <1223966008-6656-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This enables us to drop the range_cont writeback mode
use from ext4_da_writepages.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/inode.c |   30 +++++++++++++-----------------
 1 files changed, 13 insertions(+), 17 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 7c2820e..cba7960 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1656,17 +1656,23 @@ static int mpage_da_submit_io(struct mpage_da_data *mpd)
 
 	while (index <= end) {
 		/* XXX: optimize tail */
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
 			err = mapping->a_ops->writepage(page, mpd->wbc);
 			if (!err)
 				mpd->pages_written++;
@@ -2361,7 +2367,6 @@ static int ext4_da_writepages(struct address_space *mapping,
 			      struct writeback_control *wbc)
 {
 	handle_t *handle = NULL;
-	loff_t range_start = 0;
 	struct mpage_da_data mpd;
 	struct inode *inode = mapping->host;
 	int needed_blocks, ret = 0, nr_to_writebump = 0;
@@ -2386,14 +2391,7 @@ static int ext4_da_writepages(struct address_space *mapping,
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
@@ -2452,9 +2450,8 @@ static int ext4_da_writepages(struct address_space *mapping,
 		wbc->nr_to_write = to_write;
 	}
 
-	if (wbc->range_cont && (pages_skipped != wbc->pages_skipped)) {
+	if (!wbc->range_cyclic && (pages_skipped != wbc->pages_skipped)) {
 		/* We skipped pages in this loop */
-		wbc->range_start = range_start;
 		wbc->nr_to_write = to_write +
 				wbc->pages_skipped - pages_skipped;
 		wbc->pages_skipped = pages_skipped;
@@ -2463,7 +2460,6 @@ static int ext4_da_writepages(struct address_space *mapping,
 
 out_writepages:
 	wbc->nr_to_write = to_write - nr_to_writebump;
-	wbc->range_start = range_start;
 	return ret;
 }
 
-- 
1.6.0.2.526.g5c283

