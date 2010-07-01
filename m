From: Greg KH <gregkh@suse.de>
Subject: [16/23] ext4: Implement range_cyclic in ext4_da_writepages instead of write_cache_pages
Date: Thu, 01 Jul 2010 10:27:05 -0700
Message-ID: <20100701172857.786701122@clark.site>
References: <20100701175134.GA2098@kroah.com>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
	"Theodore Tso" <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>,
	"Jayson R. King" <dev@jaysonking.com>,
	Kay Diederichs <Kay.Diederichs@uni-konstanz.de>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100701175134.GA2098@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------


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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/inode.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
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
