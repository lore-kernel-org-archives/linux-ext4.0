From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 2/4] vfs: Remove the range_cont writeback mode.
Date: Sun, 12 Oct 2008 00:34:38 +0530
Message-ID: <1223751880-16325-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1223751880-16325-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com, npiggin@suse.de
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:37875 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759592AbYJKTEy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 11 Oct 2008 15:04:54 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp01.au.ibm.com (8.13.1/8.13.1) with ESMTP id m9BJ4xLd012600
	for <linux-ext4@vger.kernel.org>; Sun, 12 Oct 2008 06:04:59 +1100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m9BJ4pbU4431976
	for <linux-ext4@vger.kernel.org>; Sun, 12 Oct 2008 06:04:51 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m9BJ4oJU003855
	for <linux-ext4@vger.kernel.org>; Sun, 12 Oct 2008 06:04:50 +1100
In-Reply-To: <1223751880-16325-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ext4 was the only user of range_cont writeback mode
and ext4 switched to a different method. So remove
the range_cont mode which is not used in the kernel.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 include/linux/writeback.h |    1 -
 mm/page-writeback.c       |    2 --
 2 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 12b15c5..bd91987 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -63,7 +63,6 @@ struct writeback_control {
 	unsigned for_writepages:1;	/* This is a writepages() call */
 	unsigned range_cyclic:1;	/* range_start is cyclic */
 	unsigned more_io:1;		/* more io to be dispatched */
-	unsigned range_cont:1;
 };
 
 /*
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 24de8b6..718efa6 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -961,8 +961,6 @@ int write_cache_pages(struct address_space *mapping,
 	if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))
 		mapping->writeback_index = index;
 
-	if (wbc->range_cont)
-		wbc->range_start = index << PAGE_CACHE_SHIFT;
 	return ret;
 }
 EXPORT_SYMBOL(write_cache_pages);
-- 
1.6.0.2.514.g23abd3

