From: Tao Ma <tm@tao.ma>
Subject: [PATCH] ext4: Fix the wrong comment in ext4_ext_search_right.
Date: Fri,  7 Oct 2011 23:30:26 +0800
Message-ID: <1318001428-3108-1-git-send-email-tm@tao.ma>
Cc: "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:52199 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753044Ab1JGPch (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Oct 2011 11:32:37 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

With ext4_ext_search_right, the comment is wrong. We returns 0 @phys when
*logical is the 'largest' allocated block, not smallest. So change it.
Some other typos are also included.

Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/extents.c |    4 ++--
 fs/ext4/inode.c   |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index dee73d2..f6b333c 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1260,7 +1260,7 @@ static int ext4_ext_search_left(struct inode *inode,
 /*
  * search the closest allocated block to the right for *logical
  * and returns it at @logical + it's physical address at @phys
- * if *logical is the smallest allocated block, the function
+ * if *logical is the largest allocated block, the function
  * returns 0 at @phys
  * return value contains 0 (success) or error code
  */
@@ -2158,7 +2158,7 @@ int ext4_ext_calc_credits_for_single_extent(struct inode *inode, int nrblocks,
 			 *  need to account for leaf block credit
 			 *
 			 *  bitmaps and block group descriptor blocks
-			 *  and other metadat blocks still need to be
+			 *  and other metadata blocks still need to be
 			 *  accounted.
 			 */
 			/* 1 bitmap, 1 block group descriptor */
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 0e2c0d1..56c4f72 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -455,7 +455,7 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 	 * Returns if the blocks have already allocated
 	 *
 	 * Note that if blocks have been preallocated
-	 * ext4_ext_get_block() returns th create = 0
+	 * ext4_ext_get_block() returns the create = 0
 	 * with buffer head unmapped.
 	 */
 	if (retval > 0 && map->m_flags & EXT4_MAP_MAPPED)
-- 
1.7.1

