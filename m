From: "Jayson R. King" <dev@jaysonking.com>
Subject: [08/11] vfs: Remove the range_cont writeback mode.
Date: Sat, 27 Feb 2010 00:33:08 -0600
Message-ID: <4B88BCA4.5040201@jaysonking.com>
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
Received: from bosmailout12.eigbox.net ([66.96.189.12]:44199 "EHLO
	bosmailout12.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967841Ab0B0HXH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 27 Feb 2010 02:23:07 -0500
In-Reply-To: <4B88BA1B.4050500@jaysonking.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date: Tue Oct 14 09:21:02 2008 -0400
Subject: vfs: Remove the range_cont writeback mode.

commit 74baaaaec8b4f22e1ae279f5ecca4ff705b28912 upstream.

Ext4 was the only user of range_cont writeback mode and ext4 switched
to a different method. So remove the range_cont mode which is not used
in the kernel.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
CC: linux-fsdevel@vger.kernel.org
Signed-off-by: Jayson R. King <dev@jaysonking.com>

---
 include/linux/writeback.h |    1 -
 mm/page-writeback.c       |    2 --
 2 files changed, 3 deletions(-)

diff -urNp linux-2.6.27.orig/include/linux/writeback.h linux-2.6.27/include/linux/writeback.h
--- linux-2.6.27.orig/include/linux/writeback.h	2010-02-26 14:10:42.106252410 -0600
+++ linux-2.6.27/include/linux/writeback.h	2010-02-26 14:25:58.868253029 -0600
@@ -62,7 +62,6 @@ struct writeback_control {
 	unsigned for_writepages:1;	/* This is a writepages() call */
 	unsigned range_cyclic:1;	/* range_start is cyclic */
 	unsigned more_io:1;		/* more io to be dispatched */
-	unsigned range_cont:1;
 };
 
 /*
diff -urNp linux-2.6.27.orig/mm/page-writeback.c linux-2.6.27/mm/page-writeback.c
--- linux-2.6.27.orig/mm/page-writeback.c	2010-02-26 14:10:42.197252340 -0600
+++ linux-2.6.27/mm/page-writeback.c	2010-02-26 14:25:58.869252611 -0600
@@ -1027,8 +1027,6 @@ continue_unlock:
 	if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))
 		mapping->writeback_index = done_index;
 
-	if (wbc->range_cont)
-		wbc->range_start = index << PAGE_CACHE_SHIFT;
 	return ret;
 }
 EXPORT_SYMBOL(write_cache_pages);
