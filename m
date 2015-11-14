From: Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 1/4] libext2fs: fix parents when modifying extents
Date: Fri, 13 Nov 2015 18:10:26 -0700
Message-ID: <1447463429-5966-1-git-send-email-andreas.dilger@intel.com>
Cc: linux-ext4@vger.kernel.org,
	"Darrick J. Wong" <darrick.wong@oracle.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-no.shaw.ca ([64.59.134.9]:47734 "EHLO
	smtp-out-no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbbKNBSl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Nov 2015 20:18:41 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

In ext2fs_extent_set_bmap() and ext2fs_punch_extent(), fix the parents
when altering either end of an extent so that the parent nodes reflect
the added mapping.

There's a slight complication to using fix_parents: if there are two
mappings to an lblk in the tree, the value of handle->path->curr can
point to either extent afterwards), which is documented in a comment.

Some additional color commentary from Darrick:

  In the _set_bmap() case, I noticed that the "remapping last block in
  extent" case would produce symptoms if we are trying to remap a
  block from "extent" to "next_extent", and the two extents are
  pointed to by different index nodes.  _extent_replace(...,
  next_extent) updates e_lblk in the leaf extent, but because there's
  no _extent_fix_parents() call, the index nodes never get updated.

  In the _punch_extent() case, we conclude that we need to split an
  extent into two pieces since we're punching out the middle.  If the
  extent is the last extent in the block, the second extent will be
  inserted into a new leaf node block.  Without _fix_parents(), the
  index node doesn't seem to get updated.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Change-Id: I0fb7af2f6e88c84ef2e4656e2116a4721d57fd45
---
 lib/ext2fs/extent.c |   30 ++++++++++++++++++++++++------
 lib/ext2fs/punch.c  |   14 ++++++++++----
 2 files changed, 34 insertions(+), 10 deletions(-)

diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index c12bc93..d3d5445 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -734,7 +734,14 @@ errcode_t ext2fs_extent_goto(ext2_extent_handle_t handle,
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
@@ -1424,17 +1431,25 @@ errcode_t ext2fs_extent_set_bmap(ext2_extent_handle_t handle,
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
@@ -1467,6 +1482,9 @@ errcode_t ext2fs_extent_set_bmap(ext2_extent_handle_t handle,
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
-- 
1.7.3.4

