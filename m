From: Greg KH <gregkh@suse.de>
Subject: [09/24] vfs: Remove the range_cont writeback mode.
Date: Mon, 24 May 2010 15:28:05 -0700
Message-ID: <20100524223015.837791747@clark.site>
References: <20100524223544.GA13721@kroah.com>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
	linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Theodore Tso" <tytso@mit.edu>,
	"Jayson R. King" <dev@jaysonking.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100524223544.GA13721@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------


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
