From: "Jayson R. King" <dev@jaysonking.com>
Subject: [PATCH 2.6.27.y 3/3] ext4: Implement range_cyclic in ext4_da_writepages
 instead of write_cache_pages
Date: Fri, 28 May 2010 14:27:23 -0500
Message-ID: <4C00191B.3030702@jaysonking.com>
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
Received: from bosmailout04.eigbox.net ([66.96.187.4]:54162 "EHLO
	bosmailout04.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758413Ab0E1UEW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 May 2010 16:04:22 -0400
In-Reply-To: <4C001888.8020006@jaysonking.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date: Sat Feb 14 10:42:58 2009 -0500
Subject: ext4: Implement range_cyclic in ext4_da_writepages instead of write_cache_pages

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

---
 fs/ext4/inode.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff -udrNp linux-2.6.27.orig/fs/ext4/inode.c linux-2.6.27/fs/ext4/inode.c
--- linux-2.6.27.orig/fs/ext4/inode.c	2010-05-28 12:53:40.603963323 -0500
+++ linux-2.6.27/fs/ext4/inode.c	2010-05-28 12:53:45.204963256 -0500
@@ -2575,6 +2575,7 @@ static int ext4_da_writepages(struct add
 	struct mpage_da_data mpd;
 	struct inode *inode = mapping->host;
 	long pages_written = 0, pages_skipped;
+	int range_cyclic, cycled = 1, io_done = 0;
 	int needed_blocks, ret = 0, nr_to_writebump = 0;
 	struct ext4_sb_info *sbi = EXT4_SB(mapping->host->i_sb);
 
@@ -2612,9 +2613,15 @@ static int ext4_da_writepages(struct add
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
@@ -2622,6 +2629,7 @@ static int ext4_da_writepages(struct add
 
 	pages_skipped = wbc->pages_skipped;
 
+retry:
 	while (!ret && wbc->nr_to_write > 0) {
 
 		/*
@@ -2676,6 +2684,7 @@ static int ext4_da_writepages(struct add
 			pages_written += mpd.pages_written;
 			wbc->pages_skipped = pages_skipped;
 			ret = 0;
+			io_done = 1;
 		} else if (wbc->nr_to_write)
 			/*
 			 * There is no more writeout needed
@@ -2684,6 +2693,13 @@ static int ext4_da_writepages(struct add
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
@@ -2691,6 +2707,7 @@ static int ext4_da_writepages(struct add
 
 	/* Update index */
 	index += pages_written;
+	wbc->range_cyclic = range_cyclic;
 	if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))
 		/*
 		 * set the writeback_index so that range_cyclic
