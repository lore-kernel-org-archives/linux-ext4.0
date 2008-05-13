From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH e2fsprosg] - final (I hope...) do_split incarnation
Date: Mon, 12 May 2008 23:20:52 -0500
Message-ID: <48291724.3090300@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51900 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753233AbYEMEUz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 May 2008 00:20:55 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m4D4KsZa020854
	for <linux-ext4@vger.kernel.org>; Tue, 13 May 2008 00:20:54 -0400
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4D4Ks8J030026
	for <linux-ext4@vger.kernel.org>; Tue, 13 May 2008 00:20:54 -0400
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4D4Kq41003312
	for <linux-ext4@vger.kernel.org>; Tue, 13 May 2008 00:20:53 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Near as I can tell, this handles any split scenario you
might throw at it.

When called for a given handle, it will split that node
such that half of the node's entries will be moved to a new
trere block.  The parent will then be updated to point to the 
(now smaller) original node as well as the new node.

If the root node is requested to be split, it will move all
entries out to a new node, and leave a single entry in the
root pointing to that new node.

If the reqested split node's parent is full it will recursively 
split up to the root to make room for the new node's insertion.

If you ask to split a non-root node with only one entry,
it will refuse (we'd have an empty node otherwise).

It also updates the i_blocks count when a new block has
successfully been connected to the tree.

This depends on my prior extent_goto fix. 

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: e2fsprogs/lib/ext2fs/extent.c
===================================================================
--- e2fsprogs.orig/lib/ext2fs/extent.c	2008-05-12 18:55:16.998983495 -0500
+++ e2fsprogs/lib/ext2fs/extent.c	2008-05-12 22:10:31.204983204 -0500
@@ -733,6 +733,196 @@ errout:
 	return retval;
 }
 
+/* allocate a new block, move half the current node to it, and update parent */
+errcode_t ext2fs_node_split(ext2_extent_handle_t handle, int flags)
+{
+	errcode_t			retval = 0;
+	blk_t				new_node_pblk;
+	blk_t				new_node_start;
+	char				*block_buf = NULL;
+	struct ext2fs_extent		extent;
+	struct extent_path		*path;
+	struct ext3_extent		*ex;
+	struct ext3_extent_header	*eh, *neweh;
+	char				*cp;
+	int				tocopy;
+	int				new_root = 0;
+
+	/* basic sanity */
+	EXT2_CHECK_MAGIC(handle, EXT2_ET_MAGIC_EXTENT_HANDLE);
+
+	if (!(handle->fs->flags & EXT2_FLAG_RW))
+		return EXT2_ET_RO_FILSYS;
+
+	if (!handle->path)
+		return EXT2_ET_NO_CURRENT_NODE;
+
+	/* Is there room in the parent for a new entry? */
+	if (handle->level &&
+			(handle->path[handle->level - 1].entries >=
+		 	 handle->path[handle->level - 1].max_entries)) {
+		struct ext2_extent_info	info;
+		/* for the node we were splitting at ... */
+		int	leaf_height;	/* how far up from leaf level */
+		blk64_t	lblk;		/* our node logical block start */
+
+		retval = ext2fs_extent_get(handle, EXT2_EXTENT_CURRENT,&extent);
+		if (retval)
+			goto done;
+
+		retval = ext2fs_extent_get_info(handle, &info);
+		if (retval)
+			goto done;
+
+		/* save the position of node we were splitting... */
+		leaf_height = info.max_depth - info.curr_level;
+		lblk = extent.e_lblk;
+
+		/* split the parent */
+		retval = ext2fs_extent_get(handle, EXT2_EXTENT_UP, &extent);
+		if (retval)
+			goto done;
+		retval = ext2fs_node_split(handle, 0);
+		if (retval)
+			goto done;
+
+		/* get handle back to our original node */
+		retval = extent_goto(handle, leaf_height, lblk);
+		if (retval)
+			goto done;
+	}
+
+	/* At this point, parent should have room for this split */
+	path = handle->path + handle->level;
+	if (!path->curr)
+		return EXT2_ET_NO_CURRENT_NODE;
+
+	/* extent header of the current node we'll split */
+	eh = (struct ext3_extent_header *)path->buf;
+
+	/* splitting root level means moving them all out */
+	if (handle->level == 0) {
+		new_root = 1;
+		tocopy = ext2fs_le16_to_cpu(eh->eh_entries);
+	} else {
+		tocopy = ext2fs_le16_to_cpu(eh->eh_entries) / 2;
+	}
+
+	dbg_printf("will copy %d entries\n", tocopy);
+
+	/* XXX um, can we make an empty node? */
+	if (!tocopy) {
+		dbg_printf("Nothing to copy to new block!\n");
+		retval = EXT2_ET_CANT_SPLIT_EXTENT;
+		goto done;
+	}
+
+	/* first we need a new block, or can do nothing. */
+	block_buf = malloc(handle->fs->blocksize);
+	if (!block_buf) {
+		retval = ENOMEM;
+		goto done;
+	}
+
+	/* XXX FIXME this needs a decent goal block */
+	retval = ext2fs_alloc_block(handle->fs, 0, block_buf, &new_node_pblk);
+	if (retval)
+		goto done;
+
+	dbg_printf("will copy to new node at block %llu\n", new_node_pblk);
+
+	/* Copy data into new block buffer */
+	/* First the header for the new block... */
+	neweh = (struct ext3_extent_header *) block_buf;
+	memcpy(neweh, eh, sizeof(struct ext3_extent_header));
+	neweh->eh_entries = ext2fs_cpu_to_le16(tocopy);
+	neweh->eh_max = (handle->fs->blocksize -
+			 sizeof(struct ext3_extent_header)) /
+				sizeof(struct ext3_extent);
+
+	/* then the entries for the new block... */
+	memcpy(EXT_FIRST_INDEX(neweh),
+		EXT_FIRST_INDEX(eh) + (eh->eh_entries - tocopy),
+		sizeof(struct ext3_extent_idx) * tocopy);
+
+	new_node_start = EXT_FIRST_INDEX(neweh)->ei_block;
+
+	/* ...and write the new node block out to disk. */
+	retval = io_channel_write_blk(handle->fs->io, new_node_pblk, 1, block_buf);
+
+	if (retval)
+		goto done;
+
+	/* OK! we've created the new node; now adjust the tree */
+
+	/* current path now has fewer active entries, we copied some out */
+	if (handle->level == 0) {
+		path->entries = 1;
+		path->left = path->max_entries - 1;
+		handle->max_depth++;
+		eh->eh_depth = ext2fs_cpu_to_le16(handle->max_depth);
+	} else {
+		path->entries -= tocopy;
+		path->left -= tocopy;
+	}
+
+	eh->eh_entries = ext2fs_cpu_to_le16(path->entries);
+	/* this writes out the node, incl. the modified header */
+	retval = update_path(handle);
+	if (retval)
+		goto done;
+
+	/* now go up and insert/replace index for new node we created */
+	if (new_root) {
+		retval = ext2fs_extent_get(handle, EXT2_EXTENT_FIRST_SIB, &extent);
+		if (retval)
+			goto done;
+
+		extent.e_lblk = new_node_start;
+		extent.e_pblk = new_node_pblk;
+		extent.e_len = handle->path[0].end_blk - extent.e_lblk;
+		retval = ext2fs_extent_replace(handle, 0, &extent);
+		if (retval)
+			goto done;
+	} else {
+		__u32 new_node_length;
+
+		retval = ext2fs_extent_get(handle, EXT2_EXTENT_UP, &extent);
+		/* will insert after this one; it's length is shorter now */
+		new_node_length = new_node_start - extent.e_lblk;
+		extent.e_len -= new_node_length;
+		retval = ext2fs_extent_replace(handle, 0, &extent);
+		if (retval)
+			goto done;
+
+		/* now set up the new extent and insert it */
+		extent.e_lblk = new_node_start;
+		extent.e_pblk = new_node_pblk;
+		extent.e_len = new_node_length;
+		retval = ext2fs_extent_insert(handle, EXT2_EXTENT_INSERT_AFTER, &extent);
+		if (retval)
+			goto done;
+	}
+
+	/* go back down to our new node */
+	retval = ext2fs_extent_get(handle, EXT2_EXTENT_DOWN, &extent);
+	if (retval)
+		goto done;
+
+	/* new node hooked in, so update inode block count (do this here?) */
+	handle->inode->i_blocks += handle->fs->blocksize / 512;
+	retval = ext2fs_write_inode_full(handle->fs, handle->ino,
+		handle->inode, EXT2_INODE_SIZE(handle->fs->super));
+	if (retval)
+		goto done;
+
+done:
+	if (block_buf)
+		free(block_buf);
+
+	return retval;
+}
+
 errcode_t ext2fs_extent_delete(ext2_extent_handle_t handle, 
 			       int flags EXT2FS_ATTR((unused)))
 {
@@ -998,6 +1188,33 @@ void do_replace_node(int argc, char *arg
 	do_current_node(argc, argv);
 }
 
+void do_split_node(int argc, char *argv[])
+{
+	errcode_t	retval;
+	struct ext2fs_extent extent;
+	char *cmd;
+	int err;
+	int flags = 0;
+
+	if (check_fs_open(argv[0]))
+		return;
+
+	if (check_fs_read_write(argv[0]))
+		return;
+
+	if (!current_handle) {
+		com_err(argv[0], 0, "Extent handle not open");
+		return;
+	}
+
+	retval = ext2fs_node_split(current_handle, flags);
+	if (retval) {
+		com_err(cmd, retval, 0);
+		return;
+	}
+	do_current_node(argc, argv);
+}
+
 void do_insert_node(int argc, char *argv[])
 {
 	errcode_t	retval;
Index: e2fsprogs/lib/ext2fs/extent_dbg.ct
===================================================================
--- e2fsprogs.orig/lib/ext2fs/extent_dbg.ct	2008-05-12 18:55:16.998983495 -0500
+++ e2fsprogs/lib/ext2fs/extent_dbg.ct	2008-05-12 18:55:20.091983036 -0500
@@ -52,6 +52,9 @@ request do_delete_node, "Delete node",
 request do_insert_node, "Insert node",
 	insert_node, insert;
 
+request do_split_node, "Split node",
+	split_node, split;
+
 request do_replace_node, "Insert node",
 	replace_node, replace;
 
Index: e2fsprogs/lib/ext2fs/ext2_err.et.in
===================================================================
--- e2fsprogs.orig/lib/ext2fs/ext2_err.et.in	2008-05-12 18:55:16.999983113 -0500
+++ e2fsprogs/lib/ext2fs/ext2_err.et.in	2008-05-12 18:55:20.117983061 -0500
@@ -401,6 +401,9 @@ ec	EXT2_ET_OP_NOT_SUPPORTED,
 ec	EXT2_ET_CANT_INSERT_EXTENT,
 	"No room to insert extent in node"
 
+ec	EXT2_ET_CANT_SPLIT_EXTENT,
+	"Splitting would result in empty node"
+
 ec	EXT2_ET_EXTENT_NOT_FOUND,
 	"Extent not found"
 

