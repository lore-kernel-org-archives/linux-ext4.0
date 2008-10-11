From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 1/4] ext4: Use tag dirty lookup during mpage_da_submit_io
Date: Sun, 12 Oct 2008 00:34:37 +0530
Message-ID: <1223751880-16325-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com, npiggin@suse.de
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:58017 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759591AbYJKTEs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 11 Oct 2008 15:04:48 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id m9BJ3VST015766
	for <linux-ext4@vger.kernel.org>; Sun, 12 Oct 2008 06:03:31 +1100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m9BJ4kdw4366426
	for <linux-ext4@vger.kernel.org>; Sun, 12 Oct 2008 06:04:46 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m9BJ4jJW003822
	for <linux-ext4@vger.kernel.org>; Sun, 12 Oct 2008 06:04:46 +1100
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
1.6.0.2.514.g23abd3

