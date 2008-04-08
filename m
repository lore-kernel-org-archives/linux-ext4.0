From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 5/5] Preliminary ext2fs_extent_set_bmap
Date: Mon,  7 Apr 2008 22:01:00 -0500
Message-ID: <1207623660-1088-6-git-send-email-sandeen@redhat.com>
References: <1207623660-1088-1-git-send-email-sandeen@redhat.com>
Cc: tytso@mit.edu, Eric Sandeen <sandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:56523 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758793AbYDKSQX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Apr 2008 14:16:23 -0400
In-Reply-To: <1207623660-1088-1-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Allows unmapping or remapping mapped logical blocks,
and mapping currently unmapped blocks.

Does not yet handle cases where the current extent must
be split (unmapping or remapping in the middle of an
extent) or where the parent index node is full (would
require splitting the parent).

Also implements ext2fs_extent_fix_parents() to fix parent
index logical starts, if the first index of a node changes
its logical start block.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 lib/ext2fs/extent.c      |  229 +++++++++++++++++++++++++++++++++++++++++++++-
 lib/ext2fs/extent_dbg.ct |    3 +
 2 files changed, 231 insertions(+), 1 deletions(-)

diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index e7b7e85..d907e66 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -628,6 +628,64 @@ errcode_t ext2fs_extent_goto(ext2_extent_handle_t handle,
 	return extent_goto(handle, 0, blk);
 }
 
+/*
+ * Traverse back up to root fixing parents of current node as needed.
+ *
+ * If we changed start of first entry in a node, fix parent index start
+ * and so on.
+ *
+ * Safe to call for any position in node; if not at the first entry,
+ * will  simply return.
+ */
+errcode_t ext2fs_extent_fix_parents(ext2_extent_handle_t handle)
+{
+	int				retval = 0;
+	blk64_t				start;
+	struct extent_path		*path;
+	struct ext2fs_extent		extent;
+
+	EXT2_CHECK_MAGIC(handle, EXT2_ET_MAGIC_EXTENT_HANDLE);
+
+	if (!(handle->fs->flags & EXT2_FLAG_RW))
+		return EXT2_ET_RO_FILSYS;
+
+	if (!handle->path)
+		return EXT2_ET_NO_CURRENT_NODE;
+
+	path = handle->path + handle->level;
+	if (!path->curr)
+		return EXT2_ET_NO_CURRENT_NODE;
+
+	retval = ext2fs_extent_get(handle, EXT2_EXTENT_CURRENT, &extent);
+	if (retval)
+		goto done;
+
+	/* modified node's start block */
+	start = extent.e_lblk;
+
+	/* traverse up until index not first, or startblk matches, or top */
+	while (handle->level > 0 &&
+	       (path->left == path->entries - 1)) {
+		retval = ext2fs_extent_get(handle, EXT2_EXTENT_UP, &extent);
+		if (retval)
+			goto done;
+		if (extent.e_lblk == start)
+			break;
+		path = handle->path + handle->level;
+		extent.e_len += (extent.e_lblk - start);
+		extent.e_lblk = start;
+		retval = ext2fs_extent_replace(handle, 0, &extent);
+		if (retval)
+			goto done;
+		update_path(handle);
+	}
+
+	/* put handle back to where we started */
+	retval = ext2fs_extent_goto(handle, start);
+done:
+	return retval;
+}
+
 errcode_t ext2fs_extent_replace(ext2_extent_handle_t handle, 
 				int flags EXT2FS_ATTR((unused)),
 				struct ext2fs_extent *extent)
@@ -724,6 +782,139 @@ errout:
 	return retval;
 }
 
+/*
+ * TODO:
+ * Handle remapping block in middle of extent (requires splitting node)
+ * Handle case where parent is full (requires splitting parent)
+ */
+/* NB: if unmapping or mapping an unmapped block, does not change i_count */
+errcode_t ext2fs_extent_set_bmap(ext2_extent_handle_t handle,
+				 blk64_t logical, blk64_t physical)
+{
+	int			retval = 0;
+	int			mapped = 1; /* logical is mapped? */
+	struct extent_path	*path;
+	struct ext2fs_extent	extent;
+	struct ext2fs_extent	newextent;
+
+	EXT2_CHECK_MAGIC(handle, EXT2_ET_MAGIC_EXTENT_HANDLE);
+
+	if (!(handle->fs->flags & EXT2_FLAG_RW))
+		return EXT2_ET_RO_FILSYS;
+
+	retval = ext2fs_extent_goto(handle, logical);
+	if (retval) {
+		if (retval == EXT2_ET_EXTENT_NOT_FOUND) {
+			retval = 0;
+			mapped = 0;
+			if (!physical) {
+				dbg_printf("block already unmapped\n");
+				goto done;
+			}
+		} else
+			goto done;
+	}
+
+	if (!handle->path)
+		return EXT2_ET_NO_CURRENT_NODE;
+
+	path = handle->path + handle->level;
+	if (!path->curr)
+		return EXT2_ET_NO_CURRENT_NODE;
+
+	/*
+	 * This may be the extent *before* the requested logical,
+	 * if it's currently unmapped.
+	 */
+	retval = ext2fs_extent_get(handle, EXT2_EXTENT_CURRENT, &extent);
+	if (retval)
+		goto done;
+
+	/* check if already pointing to the requested physical */
+	if (mapped && extent.e_pblk + (logical - extent.e_lblk) == physical) {
+		dbg_printf("physical block unchanged\n");
+		goto done;
+	}
+
+	/* if (re)mapping, set up new extent, we'll insert it later */
+	if (physical) {
+		newextent.e_len = 1;
+		newextent.e_pblk = physical;
+		newextent.e_lblk = logical;
+		newextent.e_flags = EXT2_EXTENT_FLAGS_LEAF;
+	}
+
+	if (!mapped) {
+		dbg_printf("mapping unmapped logical block\n");
+		retval = ext2fs_extent_insert(handle,
+				EXT2_EXTENT_INSERT_AFTER, &newextent);
+		if (retval)
+			goto done;
+		retval = ext2fs_extent_fix_parents(handle);
+		if (retval)
+			goto done;
+	} else if (logical == extent.e_lblk + extent.e_len - 1 &&
+		   extent.e_len == 1)  {
+		dbg_printf("(re/un)mapping only block in extent\n");
+		if (physical) {
+			extent.e_pblk = physical;
+			retval = ext2fs_extent_replace(handle, 0, &extent);
+		} else {
+			retval = ext2fs_extent_delete(handle, 0);
+			if (retval)
+				goto done;
+			retval = ext2fs_extent_fix_parents(handle);
+		}
+
+		if (retval)
+			goto done;
+	} else if (logical == extent.e_lblk + extent.e_len - 1)  {
+		dbg_printf("(re/un)mapping last block in extent\n");
+		extent.e_len--;
+		retval = ext2fs_extent_replace(handle, 0, &extent);
+		if (retval)
+			goto done;
+		if (physical) {
+			retval = ext2fs_extent_insert(handle,
+					EXT2_EXTENT_INSERT_AFTER, &newextent);
+			if (retval)
+				goto done;
+		} else {
+			printf("fixing parents\n");
+			retval = ext2fs_extent_fix_parents(handle);
+			if (retval)
+				goto done;
+		}
+	} else if (logical == extent.e_lblk) {
+		dbg_printf("(re/un)mapping first block in extent\n");
+		extent.e_pblk++;
+		extent.e_lblk++;
+		extent.e_len--;
+		retval = ext2fs_extent_replace(handle, 0, &extent);
+		if (retval)
+			goto done;
+		if (physical) {
+			/* insert new extent ahead of current */
+			retval = ext2fs_extent_insert(handle,
+					0, &newextent);
+			if (retval)
+				goto done;
+		} else {
+			retval = ext2fs_extent_fix_parents(handle);
+			if (retval)
+				goto done;
+		}
+	} else {
+		dbg_printf("(re/un)mapping in middle of extent\n");
+		/* need to split this extent; later */
+		retval = EXT2_ET_OP_NOT_SUPPORTED;
+		goto done;
+	}
+
+done:
+	return retval;
+}
+
 errcode_t ext2fs_extent_delete(ext2_extent_handle_t handle, 
 			       int flags EXT2FS_ATTR((unused)))
 {
@@ -1009,7 +1200,7 @@ void do_insert_node(int argc, char *argv[])
 	}
 
 	if (argc != 4) {
-		fprintf(stderr, "usage: %s <lblk> <len> <pblk>\n", cmd);
+		fprintf(stderr, "usage: %s [--after] <lblk> <len> <pblk>\n", cmd);
 		return;
 	}
 
@@ -1036,6 +1227,42 @@ void do_insert_node(int argc, char *argv[])
 	do_current_node(argc, argv);
 }
 
+void do_set_bmap(int argc, char **argv)
+{
+	errcode_t	retval;
+	blk_t		logical;
+	blk_t		physical;
+	char *cmd;
+	int err;
+
+	if (check_fs_read_write(argv[0]))
+		return;
+
+	cmd = argv[0];
+
+	if (argc != 3) {
+		fprintf(stderr, "usage: %s <lblk> <pblk>\n", cmd);
+		return;
+	}
+
+	logical = parse_ulong(argv[1], cmd,
+				    "logical block", &err);
+	if (err)
+		return;
+
+	physical = parse_ulong(argv[2], cmd,
+				    "physical block", &err);
+	if (err)
+		return;
+
+	retval = ext2fs_extent_set_bmap(current_handle, logical, (blk64_t) physical);
+	if (retval) {
+		com_err(cmd, retval, 0);
+		return;
+	}
+	do_current_node(argc, argv);
+}
+
 void do_print_all(int argc, char **argv)
 {
 	struct ext2fs_extent	extent;
diff --git a/lib/ext2fs/extent_dbg.ct b/lib/ext2fs/extent_dbg.ct
index 41299fa..bfd959f 100644
--- a/lib/ext2fs/extent_dbg.ct
+++ b/lib/ext2fs/extent_dbg.ct
@@ -52,6 +52,9 @@ request do_delete_node, "Delete node",
 request do_insert_node, "Insert node",
 	insert_node, insert;
 
+request do_set_bmap, "Set block mapping",
+	set_bmap;
+
 request do_replace_node, "Insert node",
 	replace_node, replace;
 
-- 
1.5.4.1

