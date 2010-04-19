From: <gregkh@suse.de>
Subject: patch vfs-remove-the-range_cont-writeback-mode.patch added to 2.6.27-stable tree
Date: Mon, 19 Apr 2010 10:27:07 -0700
Message-ID: <12716980271572@kroah.org>
References: <1268699165-17461-9-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
To: aneesh.kumar@linux.vnet.ibm.com, dev@jaysonking.com,
	gregkh@suse.de, linux-ext4@vger.kernel.org, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:48500 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752601Ab0DSRaG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Apr 2010 13:30:06 -0400
In-Reply-To: <1268699165-17461-9-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


This is a note to let you know that we have just queued up the patch titled

    Subject: vfs: Remove the range_cont writeback mode.

to the 2.6.27-stable tree.  Its filename is

    vfs-remove-the-range_cont-writeback-mode.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From tytso@mit.edu  Mon Apr 19 10:22:47 2010
From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date: Mon, 15 Mar 2010 20:26:02 -0400
Subject: vfs: Remove the range_cont writeback mode.
To: stable@kernel.org
Cc: linux-fsdevel@vger.kernel.org, Ext4 Developers List <linux-ext4@vger.kernel.org>, "Theodore Ts'o" <tytso@mit.edu>, "Jayson R. King" <dev@jaysonking.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Message-ID: <1268699165-17461-9-git-send-email-tytso@mit.edu>


From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

commit 74baaaaec8b4f22e1ae279f5ecca4ff705b28912 upstream.

Ext4 was the only user of range_cont writeback mode and ext4 switched
to a different method. So remove the range_cont mode which is not used
in the kernel.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
CC: linux-fsdevel@vger.kernel.org
Signed-off-by: Jayson R. King <dev@jaysonking.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/writeback.h |    1 -
 mm/page-writeback.c       |    2 --
 2 files changed, 3 deletions(-)

--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -62,7 +62,6 @@ struct writeback_control {
 	unsigned for_writepages:1;	/* This is a writepages() call */
 	unsigned range_cyclic:1;	/* range_start is cyclic */
 	unsigned more_io:1;		/* more io to be dispatched */
-	unsigned range_cont:1;
 };
 
 /*
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1027,8 +1027,6 @@ continue_unlock:
 	if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))
 		mapping->writeback_index = done_index;
 
-	if (wbc->range_cont)
-		wbc->range_start = index << PAGE_CACHE_SHIFT;
 	return ret;
 }
 EXPORT_SYMBOL(write_cache_pages);


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
