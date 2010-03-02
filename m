From: Nic Case <number9652@yahoo.com>
Subject: [PATCH] libext2fs: fix ext2fs_extent_get when going to the next or previous extent
Date: Tue, 2 Mar 2010 11:27:16 -0800 (PST)
Message-ID: <155285.46961.qm@web43507.mail.sp1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from n62.bullet.mail.sp1.yahoo.com ([98.136.44.35]:26091 "HELO
	n62.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751427Ab0CBT1Q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Mar 2010 14:27:16 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Because this patch fixes the handling of the EXT2_EXTENT_NEXT flag in
ext2fs_extent_get, it fixes the performance issue noticed when creating
large journals with mkfs.

When ext2fs_extent_get was called with the EXT2_EXTENT_NEXT flag on the
last extent, the handle would get altered to point to the extent above
the original extent, which would cause a subsequent call to
ext2fs_extent_get to begin at the wrong extent.  Also, when
ext2fs_extent_get was called with the EXT2_EXTENT_PREV flag, the wrong
extent could be found if the original extent was at level 0 and not the
first entry.

When ext2fs_extent_get is called with the EXT2_EXTENT_NEXT flag when
there is no next sibling, it should try to go up until it finds a
next sibling, then it should return that sibling.  If it goes up and
doesn't find a sibling, the handle should still point to the original
extent to allow the caller to take appropriate action.

When ext2fs_extent_get is called with the EXT2_EXTENT_PREV flag on a
file with a three-level extent tree when the handle currently points
at the second entry of level 0, it should return the last entry under
the first entry of level 0, which would be at level 2.  Any time it
should go down in the tree, it should go to the leaf level. If called
with EXT2_EXTENT_PREV_LEAF with the original extent being the first
leaf, the function should go up until it sees there is no previous
leaf, then set the handle back to the original extent and return.

Signed-off by Nic Case <number9652@yahoo.com>

--- lib/ext2fs/extent-orig.c    2010-02-05 08:58:41.000000000 -0600
+++ lib/ext2fs/extent.c    2010-03-02 12:47:00.000000000 -0600
@@ -287,7 +287,7 @@
     errcode_t            retval;
     blk_t                blk;
     blk64_t                end_blk;
-    int                orig_op, op;
+    int                orig_op, op, orig_level;
 
     EXT2_CHECK_MAGIC(handle, EXT2_ET_MAGIC_EXTENT_HANDLE);
 
@@ -295,6 +295,7 @@
         return EXT2_ET_NO_CURRENT_NODE;
 
     orig_op = op = flags & EXT2_EXTENT_MOVE_MASK;
+    orig_level = handle->level;
 
 retry:
     path = handle->path + handle->level;
@@ -309,16 +310,20 @@
                 op = EXT2_EXTENT_NEXT_SIB;
             else if (handle->level > 0)
                 op = EXT2_EXTENT_UP;
-            else
+            else {
+                handle->level = orig_level;
                 return EXT2_ET_EXTENT_NO_NEXT;
+            }
         } else {
             /* leaf node */
             if (path->left > 0)
                 op = EXT2_EXTENT_NEXT_SIB;
             else if (handle->level > 0)
                 op = EXT2_EXTENT_UP;
-            else
+            else {
+                handle->level = orig_level;
                 return EXT2_ET_EXTENT_NO_NEXT;
+            }
         }
         if (op != EXT2_EXTENT_NEXT_SIB) {
 #ifdef DEBUG_GET_EXTENT
@@ -340,8 +345,10 @@
                 op = EXT2_EXTENT_PREV_SIB;
             else if (handle->level > 0)
                 op = EXT2_EXTENT_UP;
-            else
+            else {
+                handle->level = orig_level;
                 return EXT2_ET_EXTENT_NO_PREV;
+            }
         } else {
             /* leaf node */
             if (path->left < path->entries-1)
@@ -417,12 +424,16 @@
     case EXT2_EXTENT_UP:
         if (handle->level <= 0)
             return EXT2_ET_EXTENT_NO_UP;
+        path->visit_num = 0;
         handle->level--;
         path--;
         ix = path->curr;
         if ((orig_op == EXT2_EXTENT_PREV) ||
             (orig_op == EXT2_EXTENT_PREV_LEAF))
             path->visit_num = 0;
+        if ((orig_op == EXT2_EXTENT_NEXT) ||
+            (orig_op == EXT2_EXTENT_NEXT_LEAF))
+            path->visit_num = 1;
         break;
     case EXT2_EXTENT_DOWN:
     case EXT2_EXTENT_DOWN_AND_LAST:
@@ -536,6 +547,16 @@
          (path->left != 0)))
         goto retry;
 
+    if (((orig_op == EXT2_EXTENT_NEXT_LEAF) ||
+         (orig_op == EXT2_EXTENT_NEXT)) &&
+        (op == EXT2_EXTENT_UP))
+        goto retry;
+
+    if ((orig_op == EXT2_EXTENT_PREV) &&
+        (op == EXT2_EXTENT_PREV_SIB) &&
+        (handle->level != handle->max_depth))
+        goto retry;
+
     return 0;
 }
 



      

