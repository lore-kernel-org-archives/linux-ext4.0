From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH, RFC] implement set_bmap in extents.c
Date: Thu, 03 Apr 2008 14:55:32 -0500
Message-ID: <47F53634.6010406@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:35852 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756126AbYDCTz4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 Apr 2008 15:55:56 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This seems to work properly for me in the following cases:

o unmap an unmapped block (does nothing)
o unmap first block in extent
o unmap last block in extent
o remap block to same physical block (does nothing)
o remap first block in extent
o remap last block in extent

These cases aren't implemented yet:

o map an unmapped block
o unmap middle block in extent
o remap middle block in extent

Ted, I'm not sure if the "fix parents" function is needed, or
if callers should handle this...

There is also some reliance on the handle endpoint after
ext2fs_extent_insert() is called; I do a relative move after
that to replace the modified extent, but I'm not sure that the
resulting handle location after _insert() is explicitly
defined to be at the newly-inserted-handle, or if that's just
lucky.  ;)

I found myself imagining that maybe ext2fs_extent_goto() could
take an optional ext2fs_extent to fill in once it arrives at
the proper location?

To imlement the remaining cases I need to tidy up the split
function and look into how extent_goto() does things when
you ask it to go to an unmapped block...

Thanks,

-Eric

Index: e2fsprogs/lib/ext2fs/extent.c
===================================================================
--- e2fsprogs.orig/lib/ext2fs/extent.c
+++ e2fsprogs/lib/ext2fs/extent.c
@@ -617,6 +617,65 @@ errcode_t ext2fs_extent_goto(ext2_extent
 	return extent_goto(handle, 0, blk);
 }
 
+/*
+ * Traverse back up to root fixing parents of current node as needed.
+ *
+ * If we changed start of first entry in a node, fix parent index start
+ * and so on.
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
+	/* if we haven't modified first node entry, parent is unchanged */
+	if (path->left != path->entries - 1)
+		goto done;
+
+	retval = ext2fs_extent_get(handle, EXT2_EXTENT_CURRENT, &extent);
+	if (retval)
+		goto done;
+
+	start = extent.e_lblk;
+
+	/* traverse up until index not first, or start already matches */
+	while (handle->level > 0) {
+		retval = ext2fs_extent_get(handle, EXT2_EXTENT_UP, &extent);
+		if (retval)
+			goto done;
+		if (extent.e_lblk == start)
+			break;
+		path = handle->path + handle->level;
+		if (path->left != path->entries - 1)
+			break;
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
@@ -713,6 +772,124 @@ errout:
 	return retval;
 }
 
+/* NB: if unmapping this does not (currently) reduce inode block count */
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
+		/* where does handle end up in this case? */
+		if (retval == EXT2_ET_EXTENT_NOT_FOUND) {
+			retval = 0;
+			mapped = 0;
+			if (!physical) {
+				dbg_printf("block already unmapped\n");
+				goto done;
+			} else {
+				dbg_printf("can't map unmapped block yet\n");
+				retval = EXT2_ET_OP_NOT_SUPPORTED;
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
+	retval = ext2fs_extent_get(handle, EXT2_EXTENT_CURRENT, &extent);
+	if (retval)
+		goto done;
+
+	/* check if already pointing to the requested physical */
+	if (extent.e_pblk + (logical - extent.e_lblk) == physical) {
+		dbg_printf("physical block unchanged\n");
+		goto done;
+	}
+
+	/* if mapping, set up new extent, we'll insert it later */
+	if (physical) {
+		newextent.e_len = 1;
+		newextent.e_pblk = physical;
+		newextent.e_lblk = logical;
+		newextent.e_flags = EXT2_EXTENT_FLAGS_LEAF;
+	}
+
+	/* remapping/unmapping last block in extent */
+	if (logical == extent.e_lblk + extent.e_len - 1)  {
+		dbg_printf("bmapping last block in extent\n");
+		if (physical) {
+			retval = ext2fs_extent_insert(handle,
+					EXT2_EXTENT_INSERT_AFTER, &newextent);
+			if (retval)
+				goto done;
+			retval = ext2fs_extent_get(handle,
+					EXT2_EXTENT_PREV_SIB, &extent);
+			if (retval)
+				goto done;
+		}
+		if (mapped) {
+			extent.e_len--;
+			if (extent.e_len == 0)
+				retval = ext2fs_extent_delete(handle, 0);
+			else
+				retval = ext2fs_extent_replace(handle, 0, &extent);
+			if (retval)
+				goto done;
+		}
+	/* remapping/unmapping first block in extent */
+	} else if (logical == extent.e_lblk) {
+		dbg_printf("bmapping first block in extent\n");
+		if (physical) {
+			/* insert new extent ahead of current */
+			retval = ext2fs_extent_insert(handle,
+					0, &newextent);
+			if (retval)
+				goto done;
+			retval = ext2fs_extent_get(handle,
+					EXT2_EXTENT_NEXT_SIB, &extent);
+			if (retval)
+				goto done;
+		}
+		if (mapped) {
+			extent.e_pblk++;
+			extent.e_lblk++;
+			/* should always be non-zero; last-block case caught 1 block extent */
+			extent.e_len--;
+			retval = ext2fs_extent_replace(handle, 0, &extent);
+			if (retval)
+				goto done;
+			retval = ext2fs_extent_fix_parents(handle);
+			if (retval)
+				goto done;
+		}
+	/* remapping/unmapping something in the middle */
+	} else {
+		dbg_printf("bmapping in middle of extent\n");
+		/* need to split this extent; later */
+		retval = EXT2_ET_OP_NOT_SUPPORTED;
+		goto done;
+	}
+
+done:
+	return retval;
+
+}
 errcode_t ext2fs_extent_delete(ext2_extent_handle_t handle, 
 			       int flags EXT2FS_ATTR((unused)))
 {
@@ -998,7 +1175,7 @@ void do_insert_node(int argc, char *argv
 	}
 
 	if (argc != 4) {
-		fprintf(stderr, "usage: %s <lblk> <len> <pblk>\n", cmd);
+		fprintf(stderr, "usage: %s [--after] <lblk> <len> <pblk>\n", cmd);
 		return;
 	}
 
@@ -1025,6 +1202,42 @@ void do_insert_node(int argc, char *argv
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
Index: e2fsprogs/lib/ext2fs/extent_dbg.ct
===================================================================
--- e2fsprogs.orig/lib/ext2fs/extent_dbg.ct
+++ e2fsprogs/lib/ext2fs/extent_dbg.ct
@@ -52,6 +52,9 @@ request do_delete_node, "Delete node",
 request do_insert_node, "Insert node",
 	insert_node, insert;
 
+request do_set_bmap, "Set block mapping",
+	set_bmap;
+
 request do_replace_node, "Insert node",
 	replace_node, replace;
 

