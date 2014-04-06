From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] resize2fs: fix over-pessimistic heuristic.
Date: Sun,  6 Apr 2014 16:56:05 +0400
Message-ID: <1396788965-11777-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:27958 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754353AbaDFM4W (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 6 Apr 2014 08:56:22 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In worst case we need one extent per moved block. Number of blocks to
be moved is less or equals to blks_needed.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 resize/resize2fs.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index f5f1337..8ca53a3 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -2587,11 +2587,17 @@ blk64_t calculate_minimum_resize_size(ext2_filsys fs, int flags)
 	/*
 	 * We need to reserve a few extra blocks if extents are
 	 * enabled, in case we need to grow the extent tree.  The more
-	 * we shrink the file system, the more space we need.
+	 * we shrink the file system, the more blocks will be moved.
+	 * Worse case is one extent per moved block.
 	 */
 	if (fs->super->s_feature_incompat & EXT3_FEATURE_INCOMPAT_EXTENTS) {
-		blk64_t safe_margin = (ext2fs_blocks_count(fs->super) -
-				       blks_needed)/500;
+		blk64_t safe_margin = ext2fs_blocks_count(fs->super)
+			- blks_needed;
+
+		if (safe_margin > blks_needed)
+			safe_margin = blks_needed;
+		safe_margin /= 500;
+
 #ifdef RESIZE2FS_DEBUG
 		if (flags & RESIZE_DEBUG_MIN_CALC)
 			printf("Extents safety margin: %llu\n", safe_margin);
-- 
1.7.1

