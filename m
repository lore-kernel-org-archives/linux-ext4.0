From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [Bug 12579] ext4 filesystem hang
Date: Fri, 13 Feb 2009 17:19:58 +0530
Message-ID: <20090213114958.GA7354@skywalker>
References: <bug-12579-13602@http.bugzilla.kernel.org/> <20090213004252.8FE62108040@picon.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp09.in.ibm.com ([59.145.155.9]:44215 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbZBMLuJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Feb 2009 06:50:09 -0500
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp09.in.ibm.com (8.13.1/8.13.1) with ESMTP id n1DBUgF1015818
	for <linux-ext4@vger.kernel.org>; Fri, 13 Feb 2009 17:00:42 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id n1DBo6Uj3801284
	for <linux-ext4@vger.kernel.org>; Fri, 13 Feb 2009 17:20:06 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.13.1/8.13.3) with ESMTP id n1DBo0BI003689
	for <linux-ext4@vger.kernel.org>; Fri, 13 Feb 2009 22:50:00 +1100
Content-Disposition: inline
In-Reply-To: <20090213004252.8FE62108040@picon.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

How about the below patch ?

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Don't use the range_cylic mode implemented by write_cache_pages

With delayed allocation we lock the page in write_cache_pages and try to build
an in memory extent of contiguous blocks. This is needed so that we can get
large contiguous blocks request. Now with range_cyclic mode in write_cache_pages
if we have not done an I/O we loop back to 0 index and try to write the page.
That would imply we will attempt to take page lock of lower index page holding
the page lock of higher index page. This can cause a dead lock with other writeback
thread.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

---
 fs/ext4/inode.c |   20 ++++++++++++++++++--
 1 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 61e8fc0..f743524 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2437,6 +2437,7 @@ static int ext4_da_writepages(struct address_space *mapping,
 	int no_nrwrite_index_update;
 	int pages_written = 0;
 	long pages_skipped;
+	int range_cyclic = 0, cycled = 1, io_done = 0;
 	int needed_blocks, ret = 0, nr_to_writebump = 0;
 	struct ext4_sb_info *sbi = EXT4_SB(mapping->host->i_sb);
 
@@ -2488,9 +2489,14 @@ static int ext4_da_writepages(struct address_space *mapping,
 	if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
 		range_whole = 1;
 
-	if (wbc->range_cyclic)
+	if (wbc->range_cyclic) {
 		index = mapping->writeback_index;
-	else
+		wbc->range_start = index << PAGE_CACHE_SHIFT;
+		wbc->range_end  = LLONG_MAX;
+		wbc->range_cyclic = 0;
+		range_cyclic = 1;
+		cycled = 0;
+	} else
 		index = wbc->range_start >> PAGE_CACHE_SHIFT;
 
 	mpd.wbc = wbc;
@@ -2504,6 +2510,7 @@ static int ext4_da_writepages(struct address_space *mapping,
 	wbc->no_nrwrite_index_update = 1;
 	pages_skipped = wbc->pages_skipped;
 
+retry:
 	while (!ret && wbc->nr_to_write > 0) {
 
 		/*
@@ -2546,6 +2553,7 @@ static int ext4_da_writepages(struct address_space *mapping,
 			pages_written += mpd.pages_written;
 			wbc->pages_skipped = pages_skipped;
 			ret = 0;
+			io_done = 1;
 		} else if (wbc->nr_to_write)
 			/*
 			 * There is no more writeout needed
@@ -2554,6 +2562,13 @@ static int ext4_da_writepages(struct address_space *mapping,
 			 */
 			break;
 	}
+	if (!io_done && !cycled) {
+		cycled = 1;
+		index = 0;
+		wbc->range_start = index << PAGE_CACHE_SHIFT;
+		wbc->range_end  = mapping->writeback_index - 1;
+		goto retry;
+	}
 	if (pages_skipped != wbc->pages_skipped)
 		printk(KERN_EMERG "This should not happen leaving %s "
 				"with nr_to_write = %ld ret = %d\n",
@@ -2561,6 +2576,7 @@ static int ext4_da_writepages(struct address_space *mapping,
 
 	/* Update index */
 	index += pages_written;
+	wbc->range_cyclic = range_cyclic;
 	if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))
 		/*
 		 * set the writeback_index so that range_cyclic
-- 
tg: (6ebb071..) range_cyclic_fix (depends on: fix_list_corruption)
