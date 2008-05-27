From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 3/3] libext2fs: add ext2fs_extent_set_bmap
Date: Tue, 27 May 2008 01:20:20 -0400
Message-ID: <20080527052020.GE7515@mit.edu>
References: <4832EA22.2070301@redhat.com> <4832EB9A.2040507@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:35447 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756078AbYE0KfI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 May 2008 06:35:08 -0400
Content-Disposition: inline
In-Reply-To: <4832EB9A.2040507@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

FYI, I've applied the following changes to your patch, so that
ext2fs_set_bmap() will not cause any side effects to the current
position of the extent handle.  This is going to prove very useful
when we wire up set_bmap() into various functions like
ext2fs_block_iterate() which will be iterating over the extent tree.

(I also renamed ext2fs_node_split() to extent_node_split(), since (a)
the name makes more sense, and (b) it's a static function, so it
doesn't need the ext2fs_ prefix.)

			       	     	     - Ted

diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index b084783..77362b6 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -739,12 +739,13 @@ errcode_t ext2fs_extent_replace(ext2_extent_handle_t handle,
  *
  * handle will be left pointing at original record.
  */
-static errcode_t ext2fs_node_split(ext2_extent_handle_t handle, int flags)
+static errcode_t extent_node_split(ext2_extent_handle_t handle, int flags)
 {
 	errcode_t			retval = 0;
 	blk_t				new_node_pblk;
 	blk64_t				new_node_start;
 	blk64_t				orig_lblk;
+	blk64_t				goal_blk = 0;
 	int				orig_height;
 	char				*block_buf = NULL;
 	struct ext2fs_extent		extent;
@@ -790,7 +791,9 @@ static errcode_t ext2fs_node_split(ext2_extent_handle_t handle, int flags)
 		retval = ext2fs_extent_get(handle, EXT2_EXTENT_UP, &extent);
 		if (retval)
 			goto done;
-		retval = ext2fs_node_split(handle, 0);
+		goal_blk = extent.e_pblk;
+
+		retval = extent_node_split(handle, 0);
 		if (retval)
 			goto done;
 
@@ -820,7 +823,6 @@ static errcode_t ext2fs_node_split(ext2_extent_handle_t handle, int flags)
 				tocopy, ext2fs_le16_to_cpu(eh->eh_entries),
 				handle->level);
 
-	/* XXX um, can we make an empty node? */
 	if (!tocopy) {
 		dbg_printf("Nothing to copy to new block!\n");
 		retval = EXT2_ET_CANT_SPLIT_EXTENT;
@@ -834,8 +836,17 @@ static errcode_t ext2fs_node_split(ext2_extent_handle_t handle, int flags)
 		goto done;
 	}
 
-	/* XXX FIXME this needs a decent goal block */
-	retval = ext2fs_alloc_block(handle->fs, 0, block_buf, &new_node_pblk);
+	if (!goal_blk) {
+		dgrp_t	group = ext2fs_group_of_ino(handle->fs, handle->ino);
+		__u8	log_flex = handle->fs->super->s_log_groups_per_flex;
+
+		if (log_flex)
+			group = group & ~((1 << (log_flex)) - 1);
+		goal_blk = (group * handle->fs->super->s_blocks_per_group) +
+			handle->fs->super->s_first_data_block;
+	}
+	retval = ext2fs_alloc_block(handle->fs, (blk_t) goal_blk, block_buf, 
+				    &new_node_pblk);
 	if (retval)
 		goto done;
 
@@ -957,7 +968,7 @@ errcode_t ext2fs_extent_insert(ext2_extent_handle_t handle, int flags,
 			return EXT2_ET_CANT_INSERT_EXTENT;
 		} else {
 			dbg_printf("node full - splitting\n");
-			retval = ext2fs_node_split(handle, 0);
+			retval = extent_node_split(handle, 0);
 			if (retval)
 				goto errout;
 			path = handle->path + handle->level;
@@ -1027,15 +1038,26 @@ errcode_t ext2fs_extent_set_bmap(ext2_extent_handle_t handle,
 {
 	int			retval = 0;
 	int			mapped = 1; /* logical is mapped? */
+	int			orig_height;
+	blk64_t			orig_lblk;
 	struct extent_path	*path;
 	struct ext2fs_extent	extent;
 	struct ext2fs_extent	newextent;
+	struct ext2_extent_info	info;
 
 	EXT2_CHECK_MAGIC(handle, EXT2_ET_MAGIC_EXTENT_HANDLE);
 
 	if (!(handle->fs->flags & EXT2_FLAG_RW))
 		return EXT2_ET_RO_FILSYS;
 
+	/* save our original location in the extent tree */
+	if (!(retval = ext2fs_extent_get(handle, EXT2_EXTENT_CURRENT, &extent)))
+		return retval;
+	if (!(retval = ext2fs_extent_get_info(handle, &info)))
+		return retval;
+	orig_height = info.max_depth - info.curr_level;
+	orig_lblk = extent.e_lblk;
+
 	/* go to the logical spot we want to (re/un)map */
 	retval = ext2fs_extent_goto(handle, logical);
 	if (retval) {
@@ -1166,6 +1188,10 @@ errcode_t ext2fs_extent_set_bmap(ext2_extent_handle_t handle,
 	}
 
 done:
+	/* get handle back to its position */
+	if (orig_height > handle->max_depth)
+		orig_height = handle->max_depth; /* In case we shortened the tree */
+	extent_goto(handle, orig_height, orig_lblk);
 	return retval;
 }
 
@@ -1453,7 +1479,7 @@ void do_split_node(int argc, char *argv[])
 		return;
 	}
 
-	retval = ext2fs_node_split(current_handle, flags);
+	retval = extent_node_split(current_handle, flags);
 	if (retval) {
 		com_err(cmd, retval, 0);
 		return;
