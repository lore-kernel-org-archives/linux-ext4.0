From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2.6.27.y 08/11] vfs: Remove the range_cont writeback mode.
Date: Mon, 15 Mar 2010 20:26:02 -0400
Message-ID: <1268699165-17461-9-git-send-email-tytso@mit.edu>
References: <1268699165-17461-1-git-send-email-tytso@mit.edu>
Cc: "Jayson R. King" <dev@jaysonking.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-fsdevel@vger.kernel.org
To: stable@kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1268699165-17461-1-git-send-email-tytso@mit.edu>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

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
---
 include/linux/writeback.h |    1 -
 mm/page-writeback.c       |    2 --
 2 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index c2835bb..cc0e6d9 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -62,7 +62,6 @@ struct writeback_control {
 	unsigned for_writepages:1;	/* This is a writepages() call */
 	unsigned range_cyclic:1;	/* range_start is cyclic */
 	unsigned more_io:1;		/* more io to be dispatched */
-	unsigned range_cont:1;
 };
 
 /*
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 5f7cdc2..e5c4ca2 100644
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
-- 
1.6.6.1.1.g974db.dirty

