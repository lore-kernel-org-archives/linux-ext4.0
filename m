From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] vfs: Remove the range_cont writeback mode.
Date: Tue, 14 Oct 2008 12:03:25 +0530
Message-ID: <1223966008-6656-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1223966008-6656-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1223966008-6656-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1223966008-6656-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, cmm@us.ibm.com, tytso@mit.edu,
	sandeen@redhat.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1223966008-6656-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Ext4 was the only user of range_cont writeback mode
and ext4 switched to a different method. So remove
the range_cont mode which is not used in the kernel.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
CC: linux-fsdevel@vger.kernel.org
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
1.6.0.2.526.g5c283

