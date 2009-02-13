From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12579] ext4 filesystem hang
Date: Fri, 13 Feb 2009 03:50:48 -0800 (PST)
Message-ID: <20090213115048.7233511D10A@picon.linux-foundation.org>
References: <bug-12579-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54206 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751363AbZBMLvT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Feb 2009 06:51:19 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n1DBomuW017964
	for <linux-ext4@vger.kernel.org>; Fri, 13 Feb 2009 03:50:49 -0800
In-Reply-To: <bug-12579-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12579





------- Comment #7 from aneesh.kumar@linux.vnet.ibm.com  2009-02-13 03:50 -------
How about the below patch ?

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Don't use the range_cylic mode implemented by
write_cache_pages

With delayed allocation we lock the page in write_cache_pages and try to build
an in memory extent of contiguous blocks. This is needed so that we can get
large contiguous blocks request. Now with range_cyclic mode in
write_cache_pages
if we have not done an I/O we loop back to 0 index and try to write the page.
That would imply we will attempt to take page lock of lower index page holding
the page lock of higher index page. This can cause a dead lock with other
writeback
thread.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

---
 fs/ext4/inode.c |   20 ++++++++++++++++++--
 1 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 61e8fc0..f743524 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2437,6 +2437,7 @@ static int ext4_da_writepages(struct address_space
*mapping,
        int no_nrwrite_index_update;
        int pages_written = 0;
        long pages_skipped;
+       int range_cyclic = 0, cycled = 1, io_done = 0;
        int needed_blocks, ret = 0, nr_to_writebump = 0;
        struct ext4_sb_info *sbi = EXT4_SB(mapping->host->i_sb);

@@ -2488,9 +2489,14 @@ static int ext4_da_writepages(struct address_space
*mapping,
        if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
                range_whole = 1;

-       if (wbc->range_cyclic)
+       if (wbc->range_cyclic) {
                index = mapping->writeback_index;
-       else
+               wbc->range_start = index << PAGE_CACHE_SHIFT;
+               wbc->range_end  = LLONG_MAX;
+               wbc->range_cyclic = 0;
+               range_cyclic = 1;
+               cycled = 0;
+       } else
                index = wbc->range_start >> PAGE_CACHE_SHIFT;

        mpd.wbc = wbc;
@@ -2504,6 +2510,7 @@ static int ext4_da_writepages(struct address_space
*mapping,
        wbc->no_nrwrite_index_update = 1;
        pages_skipped = wbc->pages_skipped;

+retry:
        while (!ret && wbc->nr_to_write > 0) {

                /*
@@ -2546,6 +2553,7 @@ static int ext4_da_writepages(struct address_space
*mapping,
                        pages_written += mpd.pages_written;
                        wbc->pages_skipped = pages_skipped;
                        ret = 0;
+                       io_done = 1;
                } else if (wbc->nr_to_write)
                        /*
                         * There is no more writeout needed
@@ -2554,6 +2562,13 @@ static int ext4_da_writepages(struct address_space
*mapping,
                         */
                        break;
        }
+       if (!io_done && !cycled) {
+               cycled = 1;
+               index = 0;
+               wbc->range_start = index << PAGE_CACHE_SHIFT;
+               wbc->range_end  = mapping->writeback_index - 1;
+               goto retry;
+       }
        if (pages_skipped != wbc->pages_skipped)
                printk(KERN_EMERG "This should not happen leaving %s "
                                "with nr_to_write = %ld ret = %d\n",
@@ -2561,6 +2576,7 @@ static int ext4_da_writepages(struct address_space
*mapping,

        /* Update index */
        index += pages_written;
+       wbc->range_cyclic = range_cyclic;
        if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))
                /*
                 * set the writeback_index so that range_cyclic


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
