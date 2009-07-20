From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 3/3] libext2fs: Avoid creating unneeded new extents in ext2fs_extent_set_bmap()
Date: Sun, 19 Jul 2009 23:57:05 -0400
Message-ID: <1248062225-710-3-git-send-email-tytso@mit.edu>
References: <1248062225-710-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:59384 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750847AbZGTD5P (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 19 Jul 2009 23:57:15 -0400
In-Reply-To: <1248062225-710-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Avoiding inserting a new extent if it is possible to merge the new
block to the beginning or the end of the previous or next extent.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/extent.c |  118 ++++++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 93 insertions(+), 25 deletions(-)

diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index c47fbcc..1505447 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -1146,11 +1146,14 @@ errcode_t ext2fs_extent_set_bmap(ext2_extent_handle_t handle,
 	int			mapped = 1; /* logical is mapped? */
 	int			orig_height;
 	int			extent_uninit = 0;
+	int			prev_uninit = 0;
+	int			next_uninit = 0;
 	int			new_uninit = 0;
 	int			max_len = EXT_INIT_MAX_LEN;
+	int			has_prev, has_next;
 	blk64_t			orig_lblk;
 	struct extent_path	*path;
-	struct ext2fs_extent	extent;
+	struct ext2fs_extent	extent, next_extent, prev_extent;
 	struct ext2fs_extent	newextent;
 	struct ext2_extent_info	info;
 
@@ -1222,12 +1225,44 @@ errcode_t ext2fs_extent_set_bmap(ext2_extent_handle_t handle,
 	/*
 	 * This may be the extent *before* the requested logical,
 	 * if it's currently unmapped.
+	 *
+	 * Get the previous and next leaf extents, if they are present.
 	 */
 	retval = ext2fs_extent_get(handle, EXT2_EXTENT_CURRENT, &extent);
 	if (retval)
 		goto done;
 	if (extent.e_flags & EXT2_EXTENT_FLAGS_UNINIT)
 		extent_uninit = 1;
+	retval = ext2fs_extent_get(handle, EXT2_EXTENT_NEXT_LEAF, &next_extent);
+	if (retval) {
+		has_next = 0;
+		if (retval != EXT2_ET_EXTENT_NO_NEXT)
+			goto done;
+	} else {
+		dbg_print_extent("set_bmap: next_extent",
+				 &next_extent);
+		has_next = 1;
+		if (next_extent.e_flags & EXT2_EXTENT_FLAGS_UNINIT)
+			next_uninit = 1;
+	}
+	retval = ext2fs_extent_goto(handle, logical);
+	if (retval && retval != EXT2_ET_EXTENT_NOT_FOUND)
+		goto done;
+	retval = ext2fs_extent_get(handle, EXT2_EXTENT_PREV_LEAF, &prev_extent);
+	if (retval) {
+		has_prev = 0;
+		if (retval != EXT2_ET_EXTENT_NO_PREV)
+			goto done;
+	} else {
+		has_prev = 1;
+		dbg_print_extent("set_bmap: prev_extent",
+				 &prev_extent);
+		if (prev_extent.e_flags & EXT2_EXTENT_FLAGS_UNINIT)
+			prev_uninit = 1;
+	}
+	retval = ext2fs_extent_goto(handle, logical);
+	if (retval && retval != EXT2_ET_EXTENT_NOT_FOUND)
+		goto done;
 
 	/* check if already pointing to the requested physical */
 	if (mapped && (new_uninit == extent_uninit) &&
@@ -1248,6 +1283,28 @@ errcode_t ext2fs_extent_set_bmap(ext2_extent_handle_t handle,
 		    ((int) extent.e_len < max_len-1)) {
 			extent.e_len++;
 			retval = ext2fs_extent_replace(handle, 0, &extent);
+		} else if ((logical == extent.e_lblk - 1) &&
+			   (physical == extent.e_pblk - 1) &&
+			   (new_uninit == extent_uninit) &&
+			   ((int) extent.e_len < max_len - 1)) {
+			extent.e_len++;
+			extent.e_lblk--;
+			extent.e_pblk--;
+			retval = ext2fs_extent_replace(handle, 0, &extent);
+		} else if (has_next &&
+			   (logical == next_extent.e_lblk - 1) &&
+			   (physical == next_extent.e_pblk - 1) &&
+			   (new_uninit == next_uninit) &&
+			   ((int) next_extent.e_len < max_len - 1)) {
+			retval = ext2fs_extent_get(handle,
+						   EXT2_EXTENT_NEXT_LEAF,
+						   &next_extent);
+			if (retval)
+				goto done;
+			next_extent.e_len++;
+			next_extent.e_lblk--;
+			next_extent.e_pblk--;
+			retval = ext2fs_extent_replace(handle, 0, &next_extent);
 		} else if (logical < extent.e_lblk)
 			retval = ext2fs_extent_insert(handle, 0, &newextent);
 		else
@@ -1279,14 +1336,32 @@ errcode_t ext2fs_extent_set_bmap(ext2_extent_handle_t handle,
 #ifdef DEBUG
 		printf("(re/un)mapping last block in extent\n");
 #endif
-		/* Make sure insert works before replacing old extent */
 		if (physical) {
-			retval = ext2fs_extent_insert(handle,
-					EXT2_EXTENT_INSERT_AFTER, &newextent);
+			if (has_next &&
+			    (logical == (next_extent.e_lblk - 1)) &&
+			    (physical == (next_extent.e_pblk - 1)) &&
+			    (new_uninit == next_uninit) &&
+			    ((int) next_extent.e_len < max_len - 1)) {
+				retval = ext2fs_extent_get(handle,
+					EXT2_EXTENT_NEXT_LEAF, &next_extent);
+				if (retval)
+					goto done;
+				next_extent.e_len++;
+				next_extent.e_lblk--;
+				next_extent.e_pblk--;
+				retval = ext2fs_extent_replace(handle, 0,
+							       &next_extent);
+				if (retval)
+					goto done;
+			} else
+				retval = ext2fs_extent_insert(handle,
+				      EXT2_EXTENT_INSERT_AFTER, &newextent);
 			if (retval)
 				goto done;
 			/* Now pointing at inserted extent; move back to prev */
-			retval = ext2fs_extent_goto(handle, logical - 1);
+			retval = ext2fs_extent_get(handle,
+						   EXT2_EXTENT_PREV_LEAF,
+						   &extent);
 			if (retval)
 				goto done;
 		}
@@ -1299,30 +1374,23 @@ errcode_t ext2fs_extent_set_bmap(ext2_extent_handle_t handle,
 		printf("(re/un)mapping first block in extent\n");
 #endif
 		if (physical) {
-			retval = ext2fs_extent_get(handle, 
-						   EXT2_EXTENT_PREV_LEAF,
-						   &extent);
-			if (extent.e_flags & EXT2_EXTENT_FLAGS_UNINIT)
-				extent_uninit = 1;
-			if (retval == EXT2_ET_EXTENT_NO_PREV) {
-				retval = ext2fs_extent_goto(handle, logical);
+			if (has_prev &&
+			    (logical == (prev_extent.e_lblk +
+					 prev_extent.e_len)) &&
+			    (physical == (prev_extent.e_pblk +
+					  prev_extent.e_len)) &&
+			    (new_uninit == prev_uninit) &&
+			    ((int) prev_extent.e_len < max_len-1)) {
+				retval = ext2fs_extent_get(handle, 
+					EXT2_EXTENT_PREV_LEAF, &prev_extent);
 				if (retval)
 					goto done;
-				retval = ext2fs_extent_insert(handle,
-							      0, &newextent);
-			} else if (retval)
-				goto done;
-			else if ((logical == extent.e_lblk + extent.e_len) &&
-				 (physical == extent.e_pblk + extent.e_len) &&
-				 (new_uninit == extent_uninit) &&
-				 ((int) extent.e_len < max_len-1)) {
-				extent.e_len++;
+				prev_extent.e_len++;
 				retval = ext2fs_extent_replace(handle, 0,
-							       &extent);
-			} else {
+							       &prev_extent);
+			} else
 				retval = ext2fs_extent_insert(handle,
-				      EXT2_EXTENT_INSERT_AFTER, &newextent);
-			}
+							      0, &newextent);
 			if (retval)
 				goto done;
 			retval = ext2fs_extent_get(handle,
-- 
1.6.3.2.1.gb9f7d.dirty

