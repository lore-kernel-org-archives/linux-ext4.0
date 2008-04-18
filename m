From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH, RFC] preliminary extent node splitting
Date: Fri, 18 Apr 2008 13:58:27 -0500
Message-ID: <4808EF53.5000500@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:52914 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760679AbYDRS63 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Apr 2008 14:58:29 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m3IIwTgR031984
	for <linux-ext4@vger.kernel.org>; Fri, 18 Apr 2008 14:58:29 -0400
Received: from file.rdu.redhat.com (file.rdu.redhat.com [10.11.255.147])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3IIwSo2022764
	for <linux-ext4@vger.kernel.org>; Fri, 18 Apr 2008 14:58:28 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by file.rdu.redhat.com (8.13.1/8.13.1) with ESMTP id m3IIwSo5004127
	for <linux-ext4@vger.kernel.org>; Fri, 18 Apr 2008 14:58:28 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Just to get it out there, here's what I've got at this point for extent node
splitting in libext2fs.

If not splitting the root node, and parent is full, this just bails
out at the moment.

This feels a bit on the hacky/ugly side, but can't immediately see a cleaner
way to do it... 

-Eric

Index: e2fsprogs/lib/ext2fs/extent.c
===================================================================
--- e2fsprogs.orig/lib/ext2fs/extent.c	2008-04-18 13:23:47.838407915 -0500
+++ e2fsprogs/lib/ext2fs/extent.c	2008-04-18 13:55:27.797849961 -0500
@@ -915,6 +915,141 @@ done:
 	return retval;
 }
 
+/* allocate a new block, move half the current node to it, and update parent */
+errcode_t ext2fs_node_split(ext2_extent_handle_t handle, int flags)
+{
+	errcode_t			retval = 0;
+	blk_t				newblock;
+	char				*block_buf = NULL;
+	struct ext2fs_extent		extent;
+	struct extent_path		*path;
+	struct ext3_extent		*ex;
+	struct ext3_extent_header	*eh, *neweh;
+	char				*cp;
+	int				tocopy;
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
+	/* for now fail if parent has no room to add */
+	if (handle->level &&
+			(handle->path[handle->level - 1].entries >=
+		 	 handle->path[handle->level - 1].max_entries)) {
+		dbg_printf("parent full; failing for now\n");
+		return EXT2_ET_CANT_INSERT_EXTENT;
+	}
+
+	path = handle->path + handle->level;
+	if (!path->curr)
+		return EXT2_ET_NO_CURRENT_NODE;
+
+	/* extent header of the current node we'll split */
+	eh = (struct ext3_extent_header *)path->buf;
+
+	/* splitting root level means moving them all out */
+	if (handle->level == 0) {
+		tocopy = ext2fs_le16_to_cpu(eh->eh_entries);
+	} else
+		tocopy = ext2fs_le16_to_cpu(eh->eh_entries) / 2;
+
+	/* XXX um, can we make an empty node? */
+	if (!tocopy) {
+		dbg_printf("er, nothing to copy to new block\n");
+		/* retval = ??? */
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
+	retval = ext2fs_alloc_block(handle->fs, 0, block_buf, &newblock);
+	if (retval)
+		goto done;
+
+	/* Copy data into new block buffer */
+
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
+	/* ...and write the new node block out to disk. */
+	retval = io_channel_write_blk(handle->fs->io, newblock, 1, block_buf);
+
+	if (retval)
+		goto done;
+
+	/* XXX ERS consolidate root level checks? */
+	/* current path now has fewer active entries */
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
+	if (handle->level == 0)
+		retval = ext2fs_extent_get(handle, EXT2_EXTENT_CURRENT, &extent);
+	else
+		retval = ext2fs_extent_get(handle, EXT2_EXTENT_UP, &extent);
+
+	if (retval)
+		goto done;
+
+	extent.e_lblk = EXT_FIRST_INDEX(neweh)->ei_block;
+	extent.e_pblk = newblock;
+
+	if (handle->level == 0)
+		retval = ext2fs_extent_replace(handle, 0, &extent);
+	else
+		retval = ext2fs_extent_insert(handle, EXT2_EXTENT_INSERT_AFTER, &extent);
+
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
@@ -1180,6 +1315,25 @@ void do_replace_node(int argc, char *arg
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
+	if (check_fs_read_write(argv[0]))
+		return;
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
--- e2fsprogs.orig/lib/ext2fs/extent_dbg.ct	2008-04-18 13:23:47.850407458 -0500
+++ e2fsprogs/lib/ext2fs/extent_dbg.ct	2008-04-18 13:24:04.196470705 -0500
@@ -55,6 +55,9 @@ request do_insert_node, "Insert node",
 request do_set_bmap, "Set block mapping",
 	set_bmap;
 
+request do_split_node, "Split node",
+	split_node, split;
+
 request do_replace_node, "Insert node",
 	replace_node, replace;
 

