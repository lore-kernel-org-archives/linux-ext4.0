From: "Jayson R. King" <dev@jaysonking.com>
Subject: [09/11] vfs: Add no_nrwrite_index_update writeback control flag
Date: Sat, 27 Feb 2010 00:33:15 -0600
Message-ID: <4B88BCAB.7000205@jaysonking.com>
References: <4B88BA1B.4050500@jaysonking.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Mingming Cao <cmm@us.ibm.com>, Theodore Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Jayson King <dev@jaysonking.com>
To: LKML <linux-kernel@vger.kernel.org>,
	Stable team <stable@kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bosmailout07.eigbox.net ([66.96.187.7]:48415 "EHLO
	bosmailout07.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967854Ab0B0HXj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 27 Feb 2010 02:23:39 -0500
In-Reply-To: <4B88BA1B.4050500@jaysonking.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date: Thu Oct 16 10:09:17 2008 -0400
Subject: vfs: Add no_nrwrite_index_update writeback control flag

commit 17bc6c30cf6bfffd816bdc53682dd46fc34a2cf4 upstream.

If no_nrwrite_index_update is set we don't update nr_to_write and
address space writeback_index in write_cache_pages.  This change
enables a file system to skip these updates in write_cache_pages and do
them in the writepages() callback.  This patch will be followed by an
ext4 patch that make use of these new flags.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
CC: linux-fsdevel@vger.kernel.org
[dev@jaysonking.com: Modified the patch to account for subsequent changes in mainline being cherry-picked earlier for 2.6.27.y.]
Signed-off-by: Jayson R. King <dev@jaysonking.com>

---
 include/linux/writeback.h |    9 +++++++++
 mm/page-writeback.c       |   14 +++++++++-----
 2 files changed, 18 insertions(+), 5 deletions(-)

diff -urNp linux-2.6.27.orig/include/linux/writeback.h linux-2.6.27/include/linux/writeback.h
--- linux-2.6.27.orig/include/linux/writeback.h	2010-02-26 14:26:43.084252730 -0600
+++ linux-2.6.27/include/linux/writeback.h	2010-02-26 14:26:48.468252521 -0600
@@ -62,6 +62,15 @@ struct writeback_control {
 	unsigned for_writepages:1;	/* This is a writepages() call */
 	unsigned range_cyclic:1;	/* range_start is cyclic */
 	unsigned more_io:1;		/* more io to be dispatched */
+	/*
+	 * write_cache_pages() won't update wbc->nr_to_write and
+	 * mapping->writeback_index if no_nrwrite_index_update
+	 * is set.  write_cache_pages() may write more than we
+	 * requested and we want to make sure nr_to_write and
+	 * writeback_index are updated in a consistent manner
+	 * so we use a single control to update them
+	 */
+	unsigned no_nrwrite_index_update:1;
 };
 
 /*
diff -urNp linux-2.6.27.orig/mm/page-writeback.c linux-2.6.27/mm/page-writeback.c
--- linux-2.6.27.orig/mm/page-writeback.c	2010-02-26 14:26:43.085252646 -0600
+++ linux-2.6.27/mm/page-writeback.c	2010-02-26 14:26:48.469252852 -0600
@@ -878,6 +878,7 @@ int write_cache_pages(struct address_spa
 	pgoff_t done_index;
 	int cycled;
 	int range_whole = 0;
+	long nr_to_write = wbc->nr_to_write;
 
 	if (wbc->nonblocking && bdi_write_congested(bdi)) {
 		wbc->encountered_congestion = 1;
@@ -985,9 +986,9 @@ continue_unlock:
 				}
  			}
 
-			if (wbc->nr_to_write > 0) {
-				wbc->nr_to_write--;
-				if (wbc->nr_to_write == 0 &&
+			if (nr_to_write > 0) {
+				nr_to_write--;
+				if (nr_to_write == 0 &&
 				    wbc->sync_mode == WB_SYNC_NONE) {
 					/*
 					 * We stop writing back only if we are
@@ -1024,8 +1025,11 @@ continue_unlock:
 		end = writeback_index - 1;
 		goto retry;
 	}
-	if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))
-		mapping->writeback_index = done_index;
+	if (!wbc->no_nrwrite_index_update) {
+		if (wbc->range_cyclic || (range_whole && nr_to_write > 0))
+			mapping->writeback_index = done_index;
+		wbc->nr_to_write = nr_to_write;
+	}
 
 	return ret;
 }
