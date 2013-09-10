From: "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH] ext4: fix dirty pages writback regression.
Date: Tue, 10 Sep 2013 10:02:58 +0800
Message-ID: <1378778578-5000-1-git-send-email-zheng.z.yan@intel.com>
Cc: jack@suse.cz, tytso@mit.edu, lkp@linux.intel.com,
	"Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:48814 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595Ab3IJCD2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Sep 2013 22:03:28 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: "Yan, Zheng" <zheng.z.yan@intel.com>

Our Linux Kernel Performance project found that commit 4e7ea81db5
(ext4: restructure writeback path) indroduced regression. After
the commit, ext4 does not merge adjacent mapped dirty pages during
writeback. The "!buffer_delay(bh) && !buffer_unwritten(bh)" check
in mpage_add_bh_to_extent() prevents the merging.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 fs/ext4/inode.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c79fd7d..bfeb8b2 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1944,8 +1944,7 @@ static bool mpage_add_bh_to_extent(struct mpage_da_data *mpd, ext4_lblk_t lblk,
 	struct ext4_map_blocks *map = &mpd->map;
 
 	/* Buffer that doesn't need mapping for writeback? */
-	if (!buffer_dirty(bh) || !buffer_mapped(bh) ||
-	    (!buffer_delay(bh) && !buffer_unwritten(bh))) {
+	if (!buffer_dirty(bh) || !buffer_mapped(bh)) {
 		/* So far no extent to map => we write the buffer right away */
 		if (map->m_len == 0)
 			return true;
-- 
1.8.1.4

