From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2.6.27.y 11/11] ext4: Implement range_cyclic in ext4_da_writepages instead of write_cache_pages
Date: Mon, 15 Mar 2010 20:26:05 -0400
Message-ID: <1268699165-17461-12-git-send-email-tytso@mit.edu>
References: <1268699165-17461-1-git-send-email-tytso@mit.edu>
Cc: "Jayson R. King" <dev@jaysonking.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:38671 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937242Ab0CPA0N (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Mar 2010 20:26:13 -0400
In-Reply-To: <1268699165-17461-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

commit 2acf2c261b823d9d9ed954f348b97620297a36b5 upstream.

With delayed allocation we lock the page in write_cache_pages() and
try to build an in memory extent of contiguous blocks.  This is needed
so that we can get large contiguous blocks request.  If range_cyclic
mode is enabled, write_cache_pages() will loop back to the 0 index if
no I/O has been done yet, and try to start writing from the beginning
of the range.  That causes an attempt to take the page lock of lower
index page while holding the page lock of higher index page, which can
cause a dead lock with another writeback thread.

The solution is to implement the range_cyclic behavior in
ext4_da_writepages() instead.

http://bugzilla.kernel.org/show_bug.cgi?id=12579

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Jayson R. King <dev@jaysonking.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/inode.c |   21 +++++++++++++++++++--
 1 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 658ddef..0e4286a 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2456,6 +2456,7 @@ static int ext4_da_writepages(struct address_space *mapping,
 	struct inode *inode = mapping->host;
 	int no_nrwrite_index_update;
 	long pages_written = 0, pages_skipped;
+	int range_cyclic, cycled = 1, io_done = 0;
 	int needed_blocks, ret = 0, nr_to_writebump = 0;
 	struct ext4_sb_info *sbi = EXT4_SB(mapping->host->i_sb);
 
@@ -2493,9 +2494,15 @@ static int ext4_da_writepages(struct address_space *mapping,
 	if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
 		range_whole = 1;
 
-	if (wbc->range_cyclic)
+	range_cyclic = wbc->range_cyclic;
+	if (wbc->range_cyclic) {
 		index = mapping->writeback_index;
-	else
+		if (index)
+			cycled = 0;
+		wbc->range_start = index << PAGE_CACHE_SHIFT;
+		wbc->range_end  = LLONG_MAX;
+		wbc->range_cyclic = 0;
+	} else
 		index = wbc->range_start >> PAGE_CACHE_SHIFT;
 
 	mpd.wbc = wbc;
@@ -2509,6 +2516,7 @@ static int ext4_da_writepages(struct address_space *mapping,
 	wbc->no_nrwrite_index_update = 1;
 	pages_skipped = wbc->pages_skipped;
 
+retry:
 	while (!ret && wbc->nr_to_write > 0) {
 
 		/*
@@ -2563,6 +2571,7 @@ static int ext4_da_writepages(struct address_space *mapping,
 			pages_written += mpd.pages_written;
 			wbc->pages_skipped = pages_skipped;
 			ret = 0;
+			io_done = 1;
 		} else if (wbc->nr_to_write)
 			/*
 			 * There is no more writeout needed
@@ -2571,6 +2580,13 @@ static int ext4_da_writepages(struct address_space *mapping,
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
@@ -2578,6 +2594,7 @@ static int ext4_da_writepages(struct address_space *mapping,
 
 	/* Update index */
 	index += pages_written;
+	wbc->range_cyclic = range_cyclic;
 	if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))
 		/*
 		 * set the writeback_index so that range_cyclic
-- 
1.6.6.1.1.g974db.dirty

