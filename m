From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: [PATCH] ext4: Return the length of a hole from get_block
Date: Fri,  3 Jul 2015 11:15:11 -0400
Message-ID: <1435936511-17705-1-git-send-email-matthew.r.wilcox@intel.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:27407 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754599AbbGCPPa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Jul 2015 11:15:30 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Matthew Wilcox <willy@linux.intel.com>

Currently, if ext4's get_block encounters a hole, it does not modify the
buffer_head.  That's fine for many callers, but for DAX, it's useful to
know how large the hole is.  XFS already returns the length of the hole,
so this improvement should not confuse any callers.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 fs/ext4/ext4.h  | 6 ++++--
 fs/ext4/inode.c | 6 +++++-
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 9a83f14..7b7c097 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -154,12 +154,14 @@ struct ext4_allocation_request {
  * well as to store the information returned by ext4_map_blocks().  It
  * takes less room on the stack than a struct buffer_head.
  */
+#define EXT4_MAP_UPTODATE	(1 << BH_Uptodate)
 #define EXT4_MAP_NEW		(1 << BH_New)
 #define EXT4_MAP_MAPPED		(1 << BH_Mapped)
 #define EXT4_MAP_UNWRITTEN	(1 << BH_Unwritten)
 #define EXT4_MAP_BOUNDARY	(1 << BH_Boundary)
-#define EXT4_MAP_FLAGS		(EXT4_MAP_NEW | EXT4_MAP_MAPPED |\
-				 EXT4_MAP_UNWRITTEN | EXT4_MAP_BOUNDARY)
+#define EXT4_MAP_FLAGS		(EXT4_MAP_UPTODATE | EXT4_MAP_NEW | \
+				 EXT4_MAP_MAPPED | EXT4_MAP_UNWRITTEN | \
+				 EXT4_MAP_BOUNDARY)
 
 struct ext4_map_blocks {
 	ext4_fsblk_t m_pblk;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9b46f6f..0fc49ac 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -494,7 +494,11 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 				retval = map->m_len;
 			map->m_len = retval;
 		} else if (ext4_es_is_delayed(&es) || ext4_es_is_hole(&es)) {
-			retval = 0;
+			map->m_flags |= EXT4_MAP_UPTODATE;
+			retval = es.es_len - (map->m_lblk - es.es_lblk);
+			if (retval > map->m_len)
+				retval = map->m_len;
+			map->m_len = retval;
 		} else {
 			BUG_ON(1);
 		}
-- 
2.1.4

