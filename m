From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/2] resize2fs: fix overly-pessimistic calculation of minimum size required
Date: Mon, 28 Apr 2014 07:26:35 -0400
Message-ID: <1398684396-32689-2-git-send-email-tytso@mit.edu>
References: <1398684396-32689-1-git-send-email-tytso@mit.edu>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
	Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36918 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755109AbaD1L0r (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Apr 2014 07:26:47 -0400
In-Reply-To: <1398684396-32689-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

For extent-mapped file systems, we need to reserve some extra space in
case we need to grow the extent tree.  Calculate the safety margin
more intelligently, so we don't overestimate the amount of space
required.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Reported-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 resize/resize2fs.c | 36 ++++++++++++++++++++++++++----------
 1 file changed, 26 insertions(+), 10 deletions(-)

diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 6b9ca09..99669a8 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -2351,9 +2351,10 @@ blk64_t calculate_minimum_resize_size(ext2_filsys fs, int flags)
 	 * inode tables of slack space so the resize operation can be
 	 * guaranteed to finish.
 	 */
+	blks_needed = data_needed;
 	if (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_FLEX_BG) {
 		extra_groups = flexbg_size - (groups & (flexbg_size - 1));
-		data_needed += fs->inode_blocks_per_group * extra_groups;
+		blks_needed += fs->inode_blocks_per_group * extra_groups;
 		extra_groups = groups % flexbg_size;
 	}
 
@@ -2387,8 +2388,8 @@ blk64_t calculate_minimum_resize_size(ext2_filsys fs, int flags)
 	 * if we need more group descriptors in order to accomodate our data
 	 * then we need to add them here
 	 */
-	while (data_needed > data_blocks) {
-		blk64_t remainder = data_needed - data_blocks;
+	while (blks_needed > data_blocks) {
+		blk64_t remainder = blks_needed - data_blocks;
 		dgrp_t extra_grps;
 
 		/* figure out how many more groups we need for the data */
@@ -2428,17 +2429,16 @@ blk64_t calculate_minimum_resize_size(ext2_filsys fs, int flags)
 			 */
 			extra_groups = flexbg_size -
 						(groups & (flexbg_size - 1));
-			data_needed += (fs->inode_blocks_per_group *
+			blks_needed += (fs->inode_blocks_per_group *
 					extra_groups);
 			extra_groups = groups % flexbg_size;
 		}
 #ifdef RESIZE2FS_DEBUG
 		if (flags & RESIZE_DEBUG_MIN_CALC)
 			printf("Added %d extra group(s), "
-			       "data_needed %llu, data_blocks %llu, "
-			       "last_start %llu\n",
-			       extra_grps, data_needed, data_blocks,
-			       last_start);
+			       "blks_needed %llu, data_blocks %llu, "
+			       "last_start %llu\n", extra_grps, blks_needed,
+			       data_blocks, last_start);
 #endif
 	}
 
@@ -2453,8 +2453,8 @@ blk64_t calculate_minimum_resize_size(ext2_filsys fs, int flags)
 	 * if this is the case then the last group is going to have data in it
 	 * so we need to adjust the size of the last group accordingly
 	 */
-	if (last_start < data_needed) {
-		blk64_t remainder = data_needed - last_start;
+	if (last_start < blks_needed) {
+		blk64_t remainder = blks_needed - last_start;
 
 #ifdef RESIZE2FS_DEBUG
 		if (flags & RESIZE_DEBUG_MIN_CALC)
@@ -2512,10 +2512,26 @@ blk64_t calculate_minimum_resize_size(ext2_filsys fs, int flags)
 	 * We need to reserve a few extra blocks if extents are
 	 * enabled, in case we need to grow the extent tree.  The more
 	 * we shrink the file system, the more space we need.
+	 *
+	 * The absolute worst case is every single data block is in
+	 * the part of the file system that needs to be evacuated,
+	 * with each data block needs to be in its own extent, and
+	 * with each inode needing at least one extent block.
 	 */
 	if (fs->super->s_feature_incompat & EXT3_FEATURE_INCOMPAT_EXTENTS) {
 		blk64_t safe_margin = (ext2fs_blocks_count(fs->super) -
 				       blks_needed)/500;
+		unsigned int exts_per_blk = (fs->blocksize /
+					     sizeof(struct ext3_extent)) - 1;
+		blk64_t worst_case = ((data_needed + exts_per_blk - 1) /
+				      exts_per_blk);
+
+		if (worst_case < inode_count)
+			worst_case = inode_count;
+
+		if (safe_margin > worst_case)
+			safe_margin = worst_case;
+
 #ifdef RESIZE2FS_DEBUG
 		if (flags & RESIZE_DEBUG_MIN_CALC)
 			printf("Extents safety margin: %llu\n", safe_margin);
-- 
1.9.0

