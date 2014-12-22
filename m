From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 37/31] libext2fs: fix tdb.c mmap leak
Date: Mon, 22 Dec 2014 10:57:57 -0800
Message-ID: <20141222185757.GL5368@birch.djwong.org>
References: <20141220211640.25563.80596.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17793 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639AbaLVS6B (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Dec 2014 13:58:01 -0500
Content-Disposition: inline
In-Reply-To: <20141220211640.25563.80596.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When undoing an expansion of an mmap'd database while cancelling a
transaction, the tdb code prematurely decreases the variable that
tracks the file size, which leads to a region leak during the
subsequent unmap.  Fix this by maintaining a separate counter for the
region size.

(This is probably unnecessary since e2undo was the only user of tdb
transactions, but I suppose we could be proactive.)

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/tdb.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/lib/ext2fs/tdb.c b/lib/ext2fs/tdb.c
index a916768..7317288 100644
--- a/lib/ext2fs/tdb.c
+++ b/lib/ext2fs/tdb.c
@@ -246,6 +246,7 @@ struct tdb_context {
 	int page_size;
 	int max_dead_records;
 	bool have_transaction_lock;
+	tdb_len_t real_map_size; /* how much space has been mapped */
 };
 
 
@@ -970,9 +971,10 @@ int tdb_munmap(struct tdb_context *tdb)
 
 #ifdef HAVE_MMAP
 	if (tdb->map_ptr) {
-		int ret = munmap(tdb->map_ptr, tdb->map_size);
+		int ret = munmap(tdb->map_ptr, tdb->real_map_size);
 		if (ret != 0)
 			return ret;
+		tdb->real_map_size = 0;
 	}
 #endif
 	tdb->map_ptr = NULL;
@@ -995,10 +997,12 @@ void tdb_mmap(struct tdb_context *tdb)
 		 */
 
 		if (tdb->map_ptr == MAP_FAILED) {
+			tdb->real_map_size = 0;
 			tdb->map_ptr = NULL;
 			TDB_LOG((tdb, TDB_DEBUG_WARNING, "tdb_mmap failed for size %d (%s)\n",
 				 tdb->map_size, strerror(errno)));
 		}
+		tdb->real_map_size = tdb->map_size;
 	} else {
 		tdb->map_ptr = NULL;
 	}
