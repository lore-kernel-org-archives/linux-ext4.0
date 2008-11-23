From: Wu Fengguang <fengguang.wu@intel.com>
Subject: [PATCH] ext4: fix build warning
Date: Sun, 23 Nov 2008 18:40:06 +0800
Message-ID: <20081123104006.GA13392@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:36124 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756147AbYKWKkV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 23 Nov 2008 05:40:21 -0500
Received: from wfg by localhost with local (Exim 4.69)
	(envelope-from <fengguang.wu@intel.com>)
	id 1L4CNq-0003Uk-Bg
	for linux-ext4@vger.kernel.org; Sun, 23 Nov 2008 18:40:06 +0800
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Replace `if' with `goto' to assure gcc that ix has been initialized.

Signed-off-by: Wu Fengguang <wfg@linux.intel.com>
---
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ea2ce3c..885645e 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1160,15 +1160,14 @@ ext4_ext_search_right(struct inode *inode, struct ext4_ext_path *path,
 	while (--depth >= 0) {
 		ix = path[depth].p_idx;
 		if (ix != EXT_LAST_INDEX(path[depth].p_hdr))
-			break;
+			goto got_index;
 	}
 
-	if (depth < 0) {
-		/* we've gone up to the root and
-		 * found no index to the right */
-		return 0;
-	}
+	/* we've gone up to the root and
+	 * found no index to the right */
+	return 0;
 
+got_index:
 	/* we've found index to the right, let's
 	 * follow it and find the closest allocated
 	 * block to the right */
@@ -1201,7 +1200,6 @@ ext4_ext_search_right(struct inode *inode, struct ext4_ext_path *path,
 	*phys = ext_pblock(ex);
 	put_bh(bh);
 	return 0;
