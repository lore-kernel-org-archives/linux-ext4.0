From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/3] libext2fs: ext2fs_extents_fix_parents() should not modify the handle location
Date: Thu, 20 Dec 2012 18:43:42 -0500
Message-ID: <1356047023-28367-2-git-send-email-tytso@mit.edu>
References: <20121220234229.GA22476@thunk.org>
 <1356047023-28367-1-git-send-email-tytso@mit.edu>
Cc: forrestl@synology.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:39633 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745Ab2LTXnp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Dec 2012 18:43:45 -0500
In-Reply-To: <1356047023-28367-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Previously, ext2fs_extent_fix_parents() would only avoid modifying the
cursor location associated with the extent handle the cursor was
pointed at a leaf node in the extent tree.  This is because it saved
the starting logical block number of the current extent, but not the
"level" of the extent (where level 0 is the leaf node, level 1 is the
interior node which points at blocks containing leaf nodes, etc.)

Fix ext2fs_extent_fix_parents() so it is guaranteed to not change the
current extent in the handle even if the current extent is not at the
bottom of the tree.

Also add a fix_extent command to the tst_extents program to make it
easier to test this function.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/extent.c      | 25 ++++++++++++++++++++++++-
 lib/ext2fs/extent_dbg.ct |  3 +++
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index 95a0a86..c6716bc 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -709,9 +709,11 @@ errcode_t ext2fs_extent_goto(ext2_extent_handle_t handle,
 errcode_t ext2fs_extent_fix_parents(ext2_extent_handle_t handle)
 {
 	int				retval = 0;
+	int				orig_height;
 	blk64_t				start;
 	struct extent_path		*path;
 	struct ext2fs_extent		extent;
+	struct ext2_extent_info		info;
 
 	EXT2_CHECK_MAGIC(handle, EXT2_ET_MAGIC_EXTENT_HANDLE);
 
@@ -732,6 +734,10 @@ errcode_t ext2fs_extent_fix_parents(ext2_extent_handle_t handle)
 	/* modified node's start block */
 	start = extent.e_lblk;
 
+	if ((retval = ext2fs_extent_get_info(handle, &info)))
+		return retval;
+	orig_height = info.max_depth - info.curr_level;
+
 	/* traverse up until index not first, or startblk matches, or top */
 	while (handle->level > 0 &&
 	       (path->left == path->entries - 1)) {
@@ -750,7 +756,7 @@ errcode_t ext2fs_extent_fix_parents(ext2_extent_handle_t handle)
 	}
 
 	/* put handle back to where we started */
-	retval = ext2fs_extent_goto(handle, start);
+	retval = extent_goto(handle, orig_height, start);
 done:
 	return retval;
 }
@@ -1943,6 +1949,23 @@ void do_print_all(int argc, char **argv)
 	}
 }
 
+void do_fix_parents(int argc, char **argv)
+{
+	struct ext2fs_extent	extent;
+	struct ext2_extent_info	info;
+	errcode_t		retval;
+
+	if (common_extent_args_process(argc, argv, 1, 1, "fix_parents", "",
+				       CHECK_FS_RW))
+		return;
+
+	retval = ext2fs_extent_fix_parents(current_handle);
+	if (retval) {
+		com_err(argv[0], retval, 0);
+		return;
+	}
+}
+
 void do_info(int argc, char **argv)
 {
 	struct ext2fs_extent	extent;
diff --git a/lib/ext2fs/extent_dbg.ct b/lib/ext2fs/extent_dbg.ct
index d0571f4..c1d8033 100644
--- a/lib/ext2fs/extent_dbg.ct
+++ b/lib/ext2fs/extent_dbg.ct
@@ -55,6 +55,9 @@ request do_insert_node, "Insert node",
 request do_split_node, "Split node",
 	split_node, split;
 
+request do_fix_parents, "Fix parents",
+	fix_parents, fixp;
+
 request do_set_bmap, "Set block mapping",
 	set_bmap;
 
-- 
1.7.12.rc0.22.gcdd159b

