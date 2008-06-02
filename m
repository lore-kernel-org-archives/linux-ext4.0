From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/3] libext2fs: ext2fs_node_split
Date: Mon, 2 Jun 2008 02:53:54 -0400
Message-ID: <20080602065354.GA15419@mit.edu>
References: <4832EA22.2070301@redhat.com> <4832EACC.1050600@redhat.com> <20080527042218.GD7515@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:59449 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752427AbYFBGyI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Jun 2008 02:54:08 -0400
Content-Disposition: inline
In-Reply-To: <20080527042218.GD7515@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

FYI, while doing some more testing, I found another bug in this patch.
It doesn't reallocate and update the handle->path array, with the net
result future operations will result in a core dump as we overrun the
handle->path array and fetch an illegal pointer from handle->path[n].buf.

The fix follows....

						- Ted

diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index 29f6cdd..d421a4b 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -772,7 +772,7 @@ static errcode_t extent_node_split(ext2_extent_handle_t handle, int flags)
 	int				orig_height;
 	char				*block_buf = NULL;
 	struct ext2fs_extent		extent;
-	struct extent_path		*path;
+	struct extent_path		*path, *newpath = 0;
 	struct ext3_extent		*ex;
 	struct ext3_extent_header	*eh, *neweh;
 	char				*cp;
@@ -838,6 +838,13 @@ static errcode_t extent_node_split(ext2_extent_handle_t handle, int flags)
 	if (handle->level == 0) {
 		new_root = 1;
 		tocopy = ext2fs_le16_to_cpu(eh->eh_entries);
+		retval = ext2fs_get_mem(((handle->max_depth+2) *
+					 sizeof(struct extent_path)),
+					&newpath);
+		if (retval)
+			goto done;
+		memset(newpath, 0,
+		       ((handle->max_depth+2) * sizeof(struct extent_path)));
 	} else {
 		tocopy = ext2fs_le16_to_cpu(eh->eh_entries) / 2;
 	}
@@ -873,7 +880,7 @@ static errcode_t extent_node_split(ext2_extent_handle_t handle, int flags)
 	if (retval)
 		goto done;
 
-	dbg_printf("will copy to new node at block %llu\n", new_node_pblk);
+	dbg_printf("will copy to new node at block %lu\n", new_node_pblk);
 
 	/* Copy data into new block buffer */
 	/* First the header for the new block... */
@@ -902,6 +909,11 @@ static errcode_t extent_node_split(ext2_extent_handle_t handle, int flags)
 
 	/* current path now has fewer active entries, we copied some out */
 	if (handle->level == 0) {
+		memcpy(newpath, path,
+		       sizeof(struct extent_path) * (handle->max_depth+1));
+		handle->path = newpath;
+		newpath = path;
+		path = handle->path;
 		path->entries = 1;
 		path->left = path->max_entries - 1;
 		handle->max_depth++;
@@ -962,6 +974,8 @@ static errcode_t extent_node_split(ext2_extent_handle_t handle, int flags)
 		goto done;
 
 done:
+	if (newpath)
+		ext2fs_free_mem(&newpath);
 	if (block_buf)
 		free(block_buf);
 
