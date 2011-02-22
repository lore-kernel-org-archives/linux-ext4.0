From: Feng Tang <feng.tang@intel.com>
Subject: [PATCH] ext4: remove the duplicate set_buffer_mapped() for ext4_da_get_block_prep()
Date: Tue, 22 Feb 2011 15:40:38 +0800
Message-ID: <1298360438-9521-1-git-send-email-feng.tang@intel.com>
Cc: Feng Tang <feng.tang@intel.com>
To: linux-ext4@vger.kernel.org, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:63007 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753703Ab1BVHkI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Feb 2011 02:40:08 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The map_bh() called right before it already set the buffer_head to mapped.

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 fs/ext4/inode.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9f7f9e4..6fe60f5 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2597,7 +2597,6 @@ static int ext4_da_get_block_prep(struct inode *inode, sector_t iblock,
 		 * for partial write.
 		 */
 		set_buffer_new(bh);
-		set_buffer_mapped(bh);
 	}
 	return 0;
 }
-- 
1.7.0.4

