From: "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH] ext4: fix delayed pages writback regression.
Date: Mon,  9 Sep 2013 11:25:17 +0800
Message-ID: <1378697117-5894-1-git-send-email-zheng.z.yan@intel.com>
Cc: jack@suse.cz, tytso@mit.edu, lkp@linux.intel.com,
	"Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:18139 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765Ab3IIDZl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 8 Sep 2013 23:25:41 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: "Yan, Zheng" <zheng.z.yan@intel.com>

Our Linux Kernel Performance project found that commit 4e7ea81db5
(ext4: restructure writeback path) indroduced a read performance
regression. After the commit, ext4 does not merge adjacent delayed
pages during writeback. The regression is caused by the "buffer
mapped" check in mpage_add_bh_to_extent(), delayed dirty pages are
not mapped.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 fs/ext4/inode.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c79fd7d..f2034cb 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1944,8 +1944,9 @@ static bool mpage_add_bh_to_extent(struct mpage_da_data *mpd, ext4_lblk_t lblk,
 	struct ext4_map_blocks *map = &mpd->map;
 
 	/* Buffer that doesn't need mapping for writeback? */
-	if (!buffer_dirty(bh) || !buffer_mapped(bh) ||
-	    (!buffer_delay(bh) && !buffer_unwritten(bh))) {
+	if (!buffer_dirty(bh) ||
+	    (!buffer_mapped(bh) &&
+	     !buffer_delay(bh) && !buffer_unwritten(bh))) {
 		/* So far no extent to map => we write the buffer right away */
 		if (map->m_len == 0)
 			return true;
-- 
1.8.1.4

