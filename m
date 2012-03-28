From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] ext4: Remove non scalable extent cache hit statistics
Date: Wed, 28 Mar 2012 14:46:35 -0700
Message-ID: <1332971195-1842-1-git-send-email-andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Andi Kleen <ak@linux.intel.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:15963 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220Ab2C1VrH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 Mar 2012 17:47:07 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Andi Kleen <ak@linux.intel.com>

We found that the cache line in the superblock that has the new extent
cache hit/miss counters is extremly hot and causes significant slowdowns
on larger systems.

The counter is also buggy: does not use atomics so there can be always
lost updates.

Completely remove the two counters for now. If someone really needs them
(which is dubious given the bad information they always gave) they would
need to be implemented with per cpu counters.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 fs/ext4/ext4.h    |    4 ----
 fs/ext4/extents.c |    6 ------
 fs/ext4/super.c   |   16 ----------------
 3 files changed, 0 insertions(+), 26 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 513004f..6161b26 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1193,10 +1193,6 @@ struct ext4_sb_info {
 	unsigned long s_ext_blocks;
 	unsigned long s_ext_extents;
 #endif
-	/* ext4 extent cache stats */
-	unsigned long extent_cache_hits;
-	unsigned long extent_cache_misses;
-
 	/* for buddy allocator */
 	struct ext4_group_info ***s_group_info;
 	struct inode *s_buddy_cache;
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 7310b0e..f0a0270 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2049,12 +2049,6 @@ static int ext4_ext_check_cache(struct inode *inode, ext4_lblk_t block,
 		ret = 1;
 	}
 errout:
-#if 0
-	if (!ret)
-		sbi->extent_cache_misses++;
-	else
-		sbi->extent_cache_hits++;
-#endif
 	trace_ext4_ext_in_cache(inode, block, ret);
 	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 	return ret;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 502c61f..14dbc78 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2503,18 +2503,6 @@ static ssize_t lifetime_write_kbytes_show(struct ext4_attr *a,
 			  EXT4_SB(sb)->s_sectors_written_start) >> 1)));
 }
 
-static ssize_t extent_cache_hits_show(struct ext4_attr *a,
-				      struct ext4_sb_info *sbi, char *buf)
-{
-	return snprintf(buf, PAGE_SIZE, "%lu\n", sbi->extent_cache_hits);
-}
-
-static ssize_t extent_cache_misses_show(struct ext4_attr *a,
-					struct ext4_sb_info *sbi, char *buf)
-{
-	return snprintf(buf, PAGE_SIZE, "%lu\n", sbi->extent_cache_misses);
-}
