From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 1/3] libext2fs: ext2fs_node_split
Date: Tue, 20 May 2008 10:14:20 -0500
Message-ID: <4832EACC.1050600@redhat.com>
References: <4832EA22.2070301@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:37164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933211AbYETPOf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 May 2008 11:14:35 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m4KFENk7020605
	for <linux-ext4@vger.kernel.org>; Tue, 20 May 2008 11:14:23 -0400
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4KFEMrt010690
	for <linux-ext4@vger.kernel.org>; Tue, 20 May 2008 11:14:22 -0400
Received: from Liberator.local (sebastian-int.corp.redhat.com [172.16.52.221])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4KFELYY018754
	for <linux-ext4@vger.kernel.org>; Tue, 20 May 2008 11:14:21 -0400
In-Reply-To: <4832EA22.2070301@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When called for a given handle, this function  will split the
current node such that half of the node's entries will be moved
to a new tree block.  The parent will then be updated to point
to the (now smaller) original node as well as the new node.

If the root node is requested to be split, it will move all
entries out to a new node, and leave a single entry in the
root pointing to that new node.

If the reqested split node's parent is full it will recursively
split up to the root to make room for the new node's insertion.

If you ask to split a non-root node with only one entry,
it will refuse (we'd have an empty node otherwise).

It also updates the i_blocks count when a new block has
successfully been connected to the tree.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 lib/ext2fs/ext2_err.et.in |    3 +
 lib/ext2fs/extent.c       |  227 +++++++++++++++++++++++++++++++++++++++++++++
 lib/ext2fs/extent_dbg.ct  |    3 +
 3 files changed, 233 insertions(+), 0 deletions(-)

diff --git a/lib/ext2fs/ext2_err.et.in b/lib/ext2fs/ext2_err.et.in
index 9047a8f..73f9def 100644
--- a/lib/ext2fs/ext2_err.et.in
+++ b/lib/ext2fs/ext2_err.et.in
@@ -401,6 +401,9 @@ ec	EXT2_ET_OP_NOT_SUPPORTED,
 ec	EXT2_ET_CANT_INSERT_EXTENT,
 	"No room to insert extent in node"
 
+ec	EXT2_ET_CANT_SPLIT_EXTENT,
+	"Splitting would result in empty node"
+
 ec	EXT2_ET_EXTENT_NOT_FOUND,
 	"Extent not found"
 
diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index b76abdc..5ec5c3e 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -676,6 +676,206 @@ errcode_t ext2fs_extent_replace(ext2_extent_handle_t handle,
 	return 0;
 }
 
+/*
+ * allocate a new block, move half the current node to it, and update parent
+ *
+ * handle will be left pointing at original record.
+ */
+static errcode_t ext2fs_node_split(ext2_extent_handle_t handle, int flags)
+{
+	errcode_t			retval = 0;
+	blk_t				new_node_pblk;
+	blk64_t				new_node_start;
+	blk64_t				orig_lblk;
+	int				orig_height;
+	char				*block_buf = NULL;
+	struct ext2fs_extent		extent;
+	struct extent_path		*path;
+	struct ext3_extent		*ex;
+	struct ext3_extent_header	*eh, *neweh;
+	char				*cp;
+	int				tocopy;
+	int				new_root = 0;
+	struct ext2_extent_info		info;
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
+	dbg_printf("splitting node at level %d\n", handle->level);
+
+	retval = ext2fs_extent_get(handle, EXT2_EXTENT_CURRENT, &extent);
+	if (retval)
+		goto done;
+
+	retval = ext2fs_extent_get_info(handle, &info);
+	if (retval)
+		goto done;
+
+	/* save the position we were originally splitting... */
+	orig_height = info.max_depth - info.curr_level;
+	orig_lblk = extent.e_lblk;
+
+	/* Is there room in the parent for a new entry? */
+	if (handle->level &&
+			(handle->path[handle->level - 1].entries >=
+		 	 handle->path[handle->level - 1].max_entries)) {
+
+		dbg_printf("parent level %d full; splitting it too\n",
+							handle->level - 1);
+		/* split the parent */
+		retval = ext2fs_extent_get(handle, EXT2_EXTENT_UP, &extent);
+		if (retval)
+			goto done;
+		retval = ext2fs_node_split(handle, 0);
+		if (retval)
+			goto done;
+
+		/* get handle back to our original split position */
+		retval = extent_goto(handle, orig_height, orig_lblk);
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
+	dbg_printf("will copy out %d of %d entries at level %d\n",
+				tocopy, ext2fs_le16_to_cpu(eh->eh_entries),
+				handle->level);
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
+	neweh->eh_max = ext2fs_cpu_to_le16((handle->fs->blocksize -
+			 sizeof(struct ext3_extent_header)) /
+				sizeof(struct ext3_extent));
+
+	/* then the entries for the new block... */
+	memcpy(EXT_FIRST_INDEX(neweh),
+		EXT_FIRST_INDEX(eh) +
+			(ext2fs_le16_to_cpu(eh->eh_entries) - tocopy),
+		sizeof(struct ext3_extent_idx) * tocopy);
+
+	new_node_start = ext2fs_le32_to_cpu(EXT_FIRST_INDEX(neweh)->ei_block);
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
+	/* get handle back to our original position */
+	retval = extent_goto(handle, orig_height, orig_lblk);
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
 errcode_t ext2fs_extent_insert(ext2_extent_handle_t handle, int flags,
 				      struct ext2fs_extent *extent)
 {
@@ -998,6 +1198,33 @@ void do_replace_node(int argc, char *argv[])
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
diff --git a/lib/ext2fs/extent_dbg.ct b/lib/ext2fs/extent_dbg.ct
index 41299fa..788fdab 100644
--- a/lib/ext2fs/extent_dbg.ct
+++ b/lib/ext2fs/extent_dbg.ct
@@ -52,6 +52,9 @@ request do_delete_node, "Delete node",
 request do_insert_node, "Insert node",
 	insert_node, insert;
 
+request do_split_node, "Split node",
+	split_node, split;
+
 request do_replace_node, "Insert node",
 	replace_node, replace;
 
-- 1.5.4.1

