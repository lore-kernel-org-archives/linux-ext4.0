From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 19/49] libext2fs: fix memory leak when drastically shrinking
 extent tree depth
Date: Mon, 10 Mar 2014 23:55:59 -0700
Message-ID: <20140311065559.30585.1536.stgit@birch.djwong.org>
References: <20140311065356.30585.47192.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21569 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600AbaCKG4D (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Mar 2014 02:56:03 -0400
In-Reply-To: <20140311065356.30585.47192.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In ext2fs_extent_free(), h(andle)->max_depth is used as a loop
conditional variable to free all the h->path[].buf pointers.  However,
ext2fs_extent_delete() sets max_depth = 0 if we've removed everything
from the extent tree, which causes a subsequent _free() to leak some
buf pointers.  max_depth can be re-incremented when splitting extent
nodes, but there's no guarantee that it'll reach the old value before
the free.

Therefore, remember the size of h->paths[] separately, and use that
when freeing the extent handle.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/extent.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)


diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index 3ccae66..f27344e 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -58,6 +58,7 @@ struct ext2_extent_handle {
 	int			type;
 	int			level;
 	int			max_depth;
+	int			max_paths;
 	struct extent_path	*path;
 };
 
@@ -168,7 +169,7 @@ void ext2fs_extent_free(ext2_extent_handle_t handle)
 		return;
 
 	if (handle->path) {
-		for (i=1; i <= handle->max_depth; i++) {
+		for (i = 1; i < handle->max_paths; i++) {
 			if (handle->path[i].buf)
 				ext2fs_free_mem(&handle->path[i].buf);
 		}
@@ -242,11 +243,10 @@ errcode_t ext2fs_extent_open2(ext2_filsys fs, ext2_ino_t ino,
 	handle->max_depth = ext2fs_le16_to_cpu(eh->eh_depth);
 	handle->type = ext2fs_le16_to_cpu(eh->eh_magic);
 
-	retval = ext2fs_get_mem(((handle->max_depth+1) *
-				 sizeof(struct extent_path)),
-				&handle->path);
-	memset(handle->path, 0,
-	       (handle->max_depth+1) * sizeof(struct extent_path));
+	handle->max_paths = handle->max_depth + 1;
+	retval = ext2fs_get_memzero(handle->max_paths *
+				    sizeof(struct extent_path),
+				    &handle->path);
 	handle->path[0].buf = (char *) handle->inode->i_block;
 
 	handle->path[0].left = handle->path[0].entries =
@@ -912,13 +912,11 @@ errcode_t ext2fs_extent_node_split(ext2_extent_handle_t handle)
 	if (handle->level == 0) {
 		new_root = 1;
 		tocopy = ext2fs_le16_to_cpu(eh->eh_entries);
-		retval = ext2fs_get_mem(((handle->max_depth+2) *
-					 sizeof(struct extent_path)),
-					&newpath);
+		retval = ext2fs_get_memzero((handle->max_paths + 1) *
+					    sizeof(struct extent_path),
+					    &newpath);
 		if (retval)
 			goto done;
-		memset(newpath, 0,
-		       ((handle->max_depth+2) * sizeof(struct extent_path)));
 	} else {
 		tocopy = ext2fs_le16_to_cpu(eh->eh_entries) / 2;
 	}
@@ -996,13 +994,14 @@ errcode_t ext2fs_extent_node_split(ext2_extent_handle_t handle)
 	/* current path now has fewer active entries, we copied some out */
 	if (handle->level == 0) {
 		memcpy(newpath, path,
-		       sizeof(struct extent_path) * (handle->max_depth+1));
+		       sizeof(struct extent_path) * handle->max_paths);
 		handle->path = newpath;
 		newpath = path;
 		path = handle->path;
 		path->entries = 1;
 		path->left = path->max_entries - 1;
 		handle->max_depth++;
+		handle->max_paths++;
 		eh->eh_depth = ext2fs_cpu_to_le16(handle->max_depth);
 	} else {
 		path->entries -= tocopy;

