From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 3/3] libext2fs: add ext2fs_extent_set_bmap
Date: Thu, 15 May 2008 13:17:44 -0500
Message-ID: <1210875464-25552-4-git-send-email-sandeen@redhat.com>
References: <1210875464-25552-1-git-send-email-sandeen@redhat.com>
To: sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:41363 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755497AbYEOSTJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 May 2008 14:19:09 -0400
In-Reply-To: <1210875464-25552-1-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Allows unmapping or remapping single mapped logical blocks,
and mapping currently unmapped blocks.

Also implements ext2fs_extent_fix_parents() to fix parent
index logical starts, if the first index of a node changes
its logical start block.

Currently this results in new single-block extents; I think
perhaps ext2fs_extent_insert should grow a flag to request
merging with a nearby extent?

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 lib/ext2fs/extent.c      |  263 ++++++++++++++++++++++++++++++++++++++++++++++
 lib/ext2fs/extent_dbg.ct |    3 +
 2 files changed, 266 insertions(+), 0 deletions(-)

diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index 8a6eaa2..821c05f 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -637,6 +637,64 @@ errcode_t ext2fs_extent_goto(ext2_extent_handle_t handle,
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
@@ -938,6 +996,175 @@ errout:
 	return retval;
 }
 
+/*
+ * Sets the physical block for a logical file block in the extent tree.
+ *
+ * May: map unmapped, unmap mapped, or remap mapped blocks.
+ *
+ * Mapping an unmapped block adds a single-block extent.
+ *
+ * Unmapping first or last block modifies extent in-place
+ *  - But may need to fix parent's starts too in first-block case
+ *
+ * Mapping any unmapped block requires adding a (single-block) extent
+ * and inserting into proper point in tree.
+ *
+ * Modifying (unmapping or remapping) a block in the middle
+ * of an extent requires splitting the extent.
+ *  - Remapping case requires new single-block extent.
+ *
+ * Remapping first or last block adds an extent.
+ *
+ * We really need extent adding to be smart about merging.
+ */
+
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
+	/* go to the logical spot we want to (re/un)map */
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
+		__u32	orig_length;
+
+		dbg_printf("(re/un)mapping in middle of extent\n");
+		/* need to split this extent; later */
+
+		orig_length = extent.e_len;
+
+		/* shorten pre-split extent */
+		extent.e_len = (logical - extent.e_lblk);
+		retval = ext2fs_extent_replace(handle, 0, &extent);
+		if (retval)
+			goto done;
+		/* insert our new extent, if any */
+		if (physical) {
+			/* insert new extent after current */
+			retval = ext2fs_extent_insert(handle,
+					EXT2_EXTENT_INSERT_AFTER, &newextent);
+			if (retval)
+				goto done;
+		}
+		/* add post-split extent */
+		extent.e_pblk += extent.e_len + 1;
+		extent.e_lblk += extent.e_len + 1;
+		extent.e_len = orig_length - extent.e_len - 1;
+		retval = ext2fs_extent_insert(handle,
+				EXT2_EXTENT_INSERT_AFTER, &extent);
+		if (retval)
+			goto done;
+	}
+
+done:
+	return retval;
+}
+
 errcode_t ext2fs_extent_delete(ext2_extent_handle_t handle, 
 			       int flags EXT2FS_ATTR((unused)))
 {
@@ -1277,6 +1504,42 @@ void do_insert_node(int argc, char *argv[])
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
index 788fdab..d0571f4 100644
--- a/lib/ext2fs/extent_dbg.ct
+++ b/lib/ext2fs/extent_dbg.ct
@@ -55,6 +55,9 @@ request do_insert_node, "Insert node",
 request do_split_node, "Split node",
 	split_node, split;
 
+request do_set_bmap, "Set block mapping",
+	set_bmap;
+
 request do_replace_node, "Insert node",
 	replace_node, replace;
 
-- 
1.5.4.1

