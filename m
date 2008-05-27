From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/3] libext2fs: ext2fs_node_split
Date: Tue, 27 May 2008 00:22:18 -0400
Message-ID: <20080527042218.GD7515@mit.edu>
References: <4832EA22.2070301@redhat.com> <4832EACC.1050600@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:35444 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756178AbYE0KfI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 May 2008 06:35:08 -0400
Content-Disposition: inline
In-Reply-To: <4832EACC.1050600@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

FYI, I applied the following change to your patch to add support for
correct goal_block calculation.  We may eventually want to factor this
out into its own libext2fs function, since there are other places in
libext2fs which are defaulting the goal block to 0, and it would be
good to make things consistent (and flex_bg allocation policy aware).

    	     	    	       	    	    	       - Ted

diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index b85a259..0fa2b2b 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -687,6 +687,7 @@ static errcode_t ext2fs_node_split(ext2_extent_handle_t handle, int flags)
 	blk_t				new_node_pblk;
 	blk64_t				new_node_start;
 	blk64_t				orig_lblk;
+	blk64_t				goal_blk = 0;
 	int				orig_height;
 	char				*block_buf = NULL;
 	struct ext2fs_extent		extent;
@@ -732,6 +733,8 @@ static errcode_t ext2fs_node_split(ext2_extent_handle_t handle, int flags)
 		retval = ext2fs_extent_get(handle, EXT2_EXTENT_UP, &extent);
 		if (retval)
 			goto done;
+		goal_blk = extent.e_pblk;
+
 		retval = ext2fs_node_split(handle, 0);
 		if (retval)
 			goto done;
@@ -762,7 +765,6 @@ static errcode_t ext2fs_node_split(ext2_extent_handle_t handle, int flags)
 				tocopy, ext2fs_le16_to_cpu(eh->eh_entries),
 				handle->level);
 
-	/* XXX um, can we make an empty node? */
 	if (!tocopy) {
 		dbg_printf("Nothing to copy to new block!\n");
 		retval = EXT2_ET_CANT_SPLIT_EXTENT;
@@ -776,8 +778,17 @@ static errcode_t ext2fs_node_split(ext2_extent_handle_t handle, int flags)
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
 
