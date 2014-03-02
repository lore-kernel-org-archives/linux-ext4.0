From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 06/32] libext2fs: fix parents when modifying extents
Date: Sat, 01 Mar 2014 23:17:17 -0800
Message-ID: <20140302071717.28217.26062.stgit@birch.djwong.org>
References: <20140302071639.28217.57302.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17455 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbaCBHRV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Mar 2014 02:17:21 -0500
In-Reply-To: <20140302071639.28217.57302.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In ext2fs_extent_set_bmap() and ext2fs_punch_extent(), fix the parents
when altering either end of an extent so that the parent nodes reflect
the added mapping.

There's a slight complication to using fix_parents: if there are two
mappings to an lblk in the tree, the value of handle->path->curr can
point to either extent afterwards), which is documented in a comment.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/extent.c |   30 ++++++++++++++++++++++++------
 lib/ext2fs/punch.c  |   14 ++++++++++----
 2 files changed, 34 insertions(+), 10 deletions(-)


diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index f27344e..80ce88f 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -720,7 +720,14 @@ errcode_t ext2fs_extent_goto(ext2_extent_handle_t handle,
  * and so on.
  *
  * Safe to call for any position in node; if not at the first entry,
- * will  simply return.
+ * it will simply return.
+ *
+ * Note a subtlety of this function -- if there happen to be two extents
+ * mapping the same lblk and someone calls fix_parents on the second of the two
+ * extents, the position of the extent handle after the call will be the second
+ * extent if nothing happened, or the first extent if something did.  A caller
+ * in this situation must use ext2fs_extent_goto() after calling this function.
+ * Or simply don't map the same lblk with two extents, ever.
  */
 errcode_t ext2fs_extent_fix_parents(ext2_extent_handle_t handle)
 {
@@ -1379,17 +1386,25 @@ errcode_t ext2fs_extent_set_bmap(ext2_extent_handle_t handle,
 							       &next_extent);
 				if (retval)
 					goto done;
-				retval = ext2fs_extent_fix_parents(handle);
-				if (retval)
-					goto done;
 			} else
 				retval = ext2fs_extent_insert(handle,
 				      EXT2_EXTENT_INSERT_AFTER, &newextent);
 			if (retval)
 				goto done;
-			/* Now pointing at inserted extent; move back to prev */
+			retval = ext2fs_extent_fix_parents(handle);
+			if (retval)
+				goto done;
+			/*
+			 * Now pointing at inserted extent; move back to prev.
+			 *
+			 * We cannot use EXT2_EXTENT_PREV to go back; note the
+			 * subtlety in the comment for fix_parents().
+			 */
+			retval = ext2fs_extent_goto(handle, logical);
+			if (retval)
+				goto done;
 			retval = ext2fs_extent_get(handle,
-						   EXT2_EXTENT_PREV_LEAF,
+						   EXT2_EXTENT_CURRENT,
 						   &extent);
 			if (retval)
 				goto done;
@@ -1422,6 +1437,9 @@ errcode_t ext2fs_extent_set_bmap(ext2_extent_handle_t handle,
 							      0, &newextent);
 			if (retval)
 				goto done;
+			retval = ext2fs_extent_fix_parents(handle);
+			if (retval)
+				goto done;
 			retval = ext2fs_extent_get(handle,
 						   EXT2_EXTENT_NEXT_LEAF,
 						   &extent);
diff --git a/lib/ext2fs/punch.c b/lib/ext2fs/punch.c
index a3d020e..2a2cf10 100644
--- a/lib/ext2fs/punch.c
+++ b/lib/ext2fs/punch.c
@@ -343,10 +343,16 @@ static errcode_t ext2fs_punch_extent(ext2_filsys fs, ext2_ino_t ino,
 					EXT2_EXTENT_INSERT_AFTER, &newex);
 			if (retval)
 				goto errout;
-			/* Now pointing at inserted extent; so go back */
-			retval = ext2fs_extent_get(handle,
-						   EXT2_EXTENT_PREV_LEAF,
-						   &newex);
+			retval = ext2fs_extent_fix_parents(handle);
+			if (retval)
+				goto errout;
+			/*
+			 * Now pointing at inserted extent; so go back.
+			 *
+			 * We cannot use EXT2_EXTENT_PREV to go back; note the
+			 * subtlety in the comment for fix_parents().
+			 */
+			retval = ext2fs_extent_goto(handle, extent.e_lblk);
 			if (retval)
 				goto errout;
 		} 

