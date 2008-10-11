From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 3/4] vfs: Add no_nrwrite_update and no_index_update writeback control flags
Date: Sun, 12 Oct 2008 00:34:39 +0530
Message-ID: <1223751880-16325-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1223751880-16325-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1223751880-16325-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com, npiggin@suse.de
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:34932 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755140AbYJKTE4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 11 Oct 2008 15:04:56 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id m9BJ40RZ024114
	for <linux-ext4@vger.kernel.org>; Sun, 12 Oct 2008 06:04:00 +1100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m9BJ4tJt4366436
	for <linux-ext4@vger.kernel.org>; Sun, 12 Oct 2008 06:04:55 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m9BJ4sko003904
	for <linux-ext4@vger.kernel.org>; Sun, 12 Oct 2008 06:04:55 +1100
In-Reply-To: <1223751880-16325-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If no_nrwrite_update is set we don't update nr_to_write in
write_cache_pages. Similarly if no_index_update is we don't
update address space writeback_index. These changes enable a
file system to skip these updates in write_cache_pages and do
them in the writepages() callback. This patch will be followed
by an ext4 patch that make use of these new flags.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 include/linux/writeback.h |    4 ++++
 mm/page-writeback.c       |    9 +++++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index bd91987..b04287e 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -63,6 +63,10 @@ struct writeback_control {
 	unsigned for_writepages:1;	/* This is a writepages() call */
 	unsigned range_cyclic:1;	/* range_start is cyclic */
 	unsigned more_io:1;		/* more io to be dispatched */
+
+	/* write_cache_pages() control */
+	unsigned no_nrwrite_update:1;	/* don't update nr_to_write */
+	unsigned no_index_update:1;	/* don't update writeback_index */
 };
 
 /*
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 718efa6..4f359f4 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -876,6 +876,7 @@ int write_cache_pages(struct address_space *mapping,
 	pgoff_t end;		/* Inclusive */
 	int scanned = 0;
 	int range_whole = 0;
+	long nr_to_write = wbc->nr_to_write;
 
 	if (wbc->nonblocking && bdi_write_congested(bdi)) {
 		wbc->encountered_congestion = 1;
@@ -939,7 +940,7 @@ int write_cache_pages(struct address_space *mapping,
 				unlock_page(page);
 				ret = 0;
 			}
-			if (ret || (--(wbc->nr_to_write) <= 0))
+			if (ret || (--nr_to_write <= 0))
 				done = 1;
 			if (wbc->nonblocking && bdi_write_congested(bdi)) {
 				wbc->encountered_congestion = 1;
@@ -958,8 +959,12 @@ int write_cache_pages(struct address_space *mapping,
 		index = 0;
 		goto retry;
 	}
-	if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))
+	if (!wbc->no_index_update &&
+		(wbc->range_cyclic || (range_whole && nr_to_write > 0))) {
 		mapping->writeback_index = index;
+	}
+	if (!wbc->no_nrwrite_update)
+		wbc->nr_to_write = nr_to_write;
 
 	return ret;
 }
-- 
1.6.0.2.514.g23abd3

