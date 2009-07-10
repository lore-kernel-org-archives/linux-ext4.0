From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] libext2fs: Make ext2fs_extent_set_bmap() more robust against ENOSPC
Date: Fri, 10 Jul 2009 00:23:50 -0400
Message-ID: <1247199830-21179-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:38045 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbZGJEX5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 10 Jul 2009 00:23:57 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In the case where we ext2fs_extent_set_bmap() is replacing the block
mapping at the beginning of an already-existing extent, insert a new
extent if necessary before shrinking an existing extent, to avoid data
loss if the disk is full.

This mostly addresses the problem described in Red Hat Bugzilla's
statistics are still wrong, but at least the files on the filesystem
are not corrupted.  If there is a failure during the
inode_scan_and_fix pass, the simplest thing to do may be to tell the
user to run e2fsck -fy.

Addresses-Red-Hat-Bug: #510379

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/extent.c |   44 ++++++++++++++++++++++++++++++++------------
 1 files changed, 32 insertions(+), 12 deletions(-)

diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index 4a4fd2c..2f280ea 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -1270,24 +1270,44 @@ again:
 #ifdef DEBUG
 		printf("(re/un)mapping first block in extent\n");
 #endif
+		if (physical) {
+			retval = ext2fs_extent_get(handle, 
+						   EXT2_EXTENT_PREV_LEAF,
+						   &extent);
+			if (extent.e_flags & EXT2_EXTENT_FLAGS_UNINIT)
+				extent_uninit = 1;
+			if (retval == EXT2_ET_EXTENT_NO_PREV) {
+				retval = ext2fs_extent_insert(handle,
+							      0, &newextent);
+			} else if (retval)
+				goto done;
+			else if ((logical == extent.e_lblk + extent.e_len) &&
+				 (physical == extent.e_pblk + extent.e_len) &&
+				 (new_uninit == extent_uninit) &&
+				 ((int) extent.e_len < max_len-1)) {
+				extent.e_len++;
+				retval = ext2fs_extent_replace(handle, 0,
+							       &extent);
+			} else {
+				retval = ext2fs_extent_insert(handle,
+				      EXT2_EXTENT_INSERT_AFTER, &newextent);
+			}
+			if (retval)
+				goto done;
+		}
+		retval = ext2fs_extent_fix_parents(handle);
+		if (retval)
+			goto done;
+		retval = ext2fs_extent_get(handle, EXT2_EXTENT_NEXT_LEAF,
+					   &extent);
+		if (retval)
+			goto done;
 		extent.e_pblk++;
 		extent.e_lblk++;
 		extent.e_len--;
 		retval = ext2fs_extent_replace(handle, 0, &extent);
 		if (retval)
 			goto done;
-		if (physical) {
-			/*
-			 * We've removed the old block, now rely on
-			 * the optimized hueristics for adding a new
-			 * mapping with appropriate merging if necessary.
-			 */
-			goto again;
-		} else {
-			retval = ext2fs_extent_fix_parents(handle);
-			if (retval)
-				goto done;
-		}
 	} else {
 		__u32	orig_length;
 
-- 
1.6.3.2.1.gb9f7d.dirty

