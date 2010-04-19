From: <gregkh@suse.de>
Subject: patch vfs-add-no_nrwrite_index_update-writeback-control-flag.patch added to 2.6.27-stable tree
Date: Mon, 19 Apr 2010 10:27:06 -0700
Message-ID: <12716980263125@kroah.org>
References: <1268699165-17461-10-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
To: aneesh.kumar@linux.vnet.ibm.com, dev@jaysonking.com,
	gregkh@suse.de, linux-ext4@vger.kernel.org, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:48496 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752446Ab0DSRaF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Apr 2010 13:30:05 -0400
In-Reply-To: <1268699165-17461-10-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


This is a note to let you know that we have just queued up the patch titled

    Subject: vfs: Add no_nrwrite_index_update writeback control flag

to the 2.6.27-stable tree.  Its filename is

    vfs-add-no_nrwrite_index_update-writeback-control-flag.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From tytso@mit.edu  Mon Apr 19 10:23:14 2010
From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date: Mon, 15 Mar 2010 20:26:03 -0400
Subject: vfs: Add no_nrwrite_index_update writeback control flag
To: stable@kernel.org
Cc: linux-fsdevel@vger.kernel.org, Ext4 Developers List <linux-ext4@vger.kernel.org>, "Theodore Ts'o" <tytso@mit.edu>, "Jayson R. King" <dev@jaysonking.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Message-ID: <1268699165-17461-10-git-send-email-tytso@mit.edu>


From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

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
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/writeback.h |    9 +++++++++
 mm/page-writeback.c       |   14 +++++++++-----
 2 files changed, 18 insertions(+), 5 deletions(-)

--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
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
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
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
