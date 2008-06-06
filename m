From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] mm: Add range_cont mode for writeback.
Date: Fri,  6 Jun 2008 23:54:51 +0530
Message-ID: <1212776693-435-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1212776693-435-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1212776693-435-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1212776693-435-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1212776693-435-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1212776693-435-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:38926 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755383AbYFFSZg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Jun 2008 14:25:36 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id m56IP455024798
	for <linux-ext4@vger.kernel.org>; Sat, 7 Jun 2008 04:25:04 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m56ITjG0290096
	for <linux-ext4@vger.kernel.org>; Sat, 7 Jun 2008 04:29:45 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m56IPXeh031800
	for <linux-ext4@vger.kernel.org>; Sat, 7 Jun 2008 04:25:34 +1000
In-Reply-To: <1212776693-435-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Filesystems like ext4 needs to start a new transaction in
the writepages for block allocation. This happens with delayed
allocation and there is limit to how many credits we can request
from the journal layer. So we call write_cache_pages multiple
times with wbc->nr_to_write set to the maximum possible value
limitted by the max journal credits available.

Add a new mode to writeback that enables us to handle this
behaviour. In the new mode we update the wbc->range_start
to point to the new offset to be written. Next call to
call to write_cache_pages will start writeout from  specified
range_start offset. In the new mode we also limit writing
to the specified wbc->range_end.


Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 include/linux/writeback.h |    1 +
 mm/page-writeback.c       |   13 +++++++++++++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index f462439..0d8573e 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -63,6 +63,7 @@ struct writeback_control {
 	unsigned for_writepages:1;	/* This is a writepages() call */
 	unsigned range_cyclic:1;	/* range_start is cyclic */
 	unsigned more_io:1;		/* more io to be dispatched */
+	unsigned range_cont:1;
 };
 
 /*
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 789b6ad..7306902 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -882,6 +882,16 @@ int write_cache_pages(struct address_space *mapping,
 	if (wbc->range_cyclic) {
 		index = mapping->writeback_index; /* Start from prev offset */
 		end = -1;
+	} else if (wbc->range_cont) {
+		index = wbc->range_start >> PAGE_CACHE_SHIFT;
+		end = wbc->range_end >> PAGE_CACHE_SHIFT;
+		/*
+		 * we want to set the writeback_index when congested
+		 * and we are requesting for nonblocking mode,
+		 * because we won't force the range_cont mode then
+		 */
+		if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
+			range_whole = 1;
 	} else {
 		index = wbc->range_start >> PAGE_CACHE_SHIFT;
 		end = wbc->range_end >> PAGE_CACHE_SHIFT;
@@ -956,6 +966,9 @@ int write_cache_pages(struct address_space *mapping,
 	}
 	if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))
 		mapping->writeback_index = index;
+
+	if (wbc->range_cont)
+		wbc->range_start = index << PAGE_CACHE_SHIFT;
 	return ret;
 }
 EXPORT_SYMBOL(write_cache_pages);
-- 
1.5.5.1.357.g1af8b.dirty

