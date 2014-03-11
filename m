From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 38/49] libext2fs: when appending to a file,
 don't split an index block in equal halves
Date: Mon, 10 Mar 2014 23:58:03 -0700
Message-ID: <20140311065803.30585.14919.stgit@birch.djwong.org>
References: <20140311065356.30585.47192.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33348 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254AbaCKG6H (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Mar 2014 02:58:07 -0400
In-Reply-To: <20140311065356.30585.47192.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we're appending an extent to the end of a file and the index
block is full, don't split the index block into two half-full index
blocks because this leaves us with under utilized index blocks, at
least in the fallocate case.  Instead, copy the last extent from the
full block into the new block.  This isn't perfect utilization, but
there's a lot of work involved in teaching extent.c to be able to goto
a nonexistent node in a newly allocated (and empty) extent block.

This patch does not fix the general problem of keeping the extent tree
balanced.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/extent.c |   79 ++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 72 insertions(+), 7 deletions(-)


diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index 80ce88f..cf75a0b 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -29,6 +29,8 @@
 #include "ext2fsP.h"
 #include "e2image.h"
 
+#undef DEBUG
+
 /*
  * Definitions to be dropped in lib/ext2fs/ext2fs.h
  */
@@ -122,11 +124,39 @@ static void dbg_print_extent(char *desc, struct ext2fs_extent *extent)
 
 }
 
+static void dump_path(const char *tag, struct ext2_extent_handle *handle,
+		      struct extent_path *path)
+{
+	struct extent_path *ppp = path;
+	printf("%s: level=%d\n", tag, handle->level);
+
+	do {
+		printf("%s: path=%ld buf=%p entries=%d max_entries=%d left=%d "
+		       "visit_num=%d flags=0x%x end_blk=%llu curr=%p(%ld)\n",
+		       tag, (ppp - handle->path), ppp->buf, ppp->entries,
+		       ppp->max_entries, ppp->left, ppp->visit_num, ppp->flags,
+		       ppp->end_blk, ppp->curr, ppp->curr - (void *)ppp->buf);
+		printf("  ");
+		dbg_show_header((struct ext3_extent_header *)ppp->buf);
+		if (ppp->curr) {
+			printf("  ");
+			dbg_show_index(ppp->curr);
+			printf("  ");
+			dbg_show_extent(ppp->curr);
+		}
+		ppp--;
+	} while (ppp >= handle->path);
+	fflush(stdout);
+
+	return;
+}
+
 #else
 #define dbg_show_header(eh) do { } while (0)
 #define dbg_show_index(ix) do { } while (0)
 #define dbg_show_extent(ex) do { } while (0)
 #define dbg_print_extent(desc, ex) do { } while (0)
+#define dump_path(tag, handle, path) do { } while (0)
 #endif
 
 /*
@@ -837,12 +867,31 @@ errcode_t ext2fs_extent_replace(ext2_extent_handle_t handle,
 	return 0;
 }
 
+static int splitting_at_eof(struct ext2_extent_handle *handle,
+			    struct extent_path *path)
+{
+	struct extent_path *ppp = path;
+	dump_path(__func__, handle, path);
+
+	if (handle->level == 0)
+		return 0;
+
+	do {
+		if (ppp->left)
+			return 0;
+		ppp--;
+	} while (ppp >= handle->path);
+
+	return 1;
+}
+
 /*
  * allocate a new block, move half the current node to it, and update parent
  *
  * handle will be left pointing at original record.
  */
-errcode_t ext2fs_extent_node_split(ext2_extent_handle_t handle)
+static errcode_t extent_node_split(ext2_extent_handle_t handle,
+				   int expand_allowed)
 {
 	errcode_t			retval = 0;
 	blk64_t				new_node_pblk;
@@ -857,6 +906,7 @@ errcode_t ext2fs_extent_node_split(ext2_extent_handle_t handle)
 	int				tocopy;
 	int				new_root = 0;
 	struct ext2_extent_info		info;
+	int				no_balance;
 
 	/* basic sanity */
 	EXT2_CHECK_MAGIC(handle, EXT2_ET_MAGIC_EXTENT_HANDLE);
@@ -897,7 +947,7 @@ errcode_t ext2fs_extent_node_split(ext2_extent_handle_t handle)
 			goto done;
 		goal_blk = extent.e_pblk;
 
-		retval = ext2fs_extent_node_split(handle);
+		retval = extent_node_split(handle, expand_allowed);
 		if (retval)
 			goto done;
 
@@ -912,6 +962,14 @@ errcode_t ext2fs_extent_node_split(ext2_extent_handle_t handle)
 	if (!path->curr)
 		return EXT2_ET_NO_CURRENT_NODE;
 
+	/*
+	 * Normally, we try to split a full node in half.  This doesn't turn
+	 * out so well if we're tacking extents on the end of the file because
+	 * then we're stuck with a tree of half-full extent blocks.  This of
+	 * course doesn't apply to the root level.
+	 */
+	no_balance = expand_allowed ? splitting_at_eof(handle, path) : 0;
+
 	/* extent header of the current node we'll split */
 	eh = (struct ext3_extent_header *)path->buf;
 
@@ -925,7 +983,10 @@ errcode_t ext2fs_extent_node_split(ext2_extent_handle_t handle)
 		if (retval)
 			goto done;
 	} else {
-		tocopy = ext2fs_le16_to_cpu(eh->eh_entries) / 2;
+		if (no_balance)
+			tocopy = 1;
+		else
+			tocopy = ext2fs_le16_to_cpu(eh->eh_entries) / 2;
 	}
 
 #ifdef DEBUG
@@ -934,7 +995,7 @@ errcode_t ext2fs_extent_node_split(ext2_extent_handle_t handle)
 				handle->level);
 #endif
 
-	if (!tocopy) {
+	if (!tocopy && !no_balance) {
 #ifdef DEBUG
 		printf("Nothing to copy to new block!\n");
 #endif
@@ -1059,8 +1120,7 @@ errcode_t ext2fs_extent_node_split(ext2_extent_handle_t handle)
 		goto done;
 
 	/* new node hooked in, so update inode block count (do this here?) */
-	handle->inode->i_blocks += (handle->fs->blocksize *
-				    EXT2FS_CLUSTER_RATIO(handle->fs)) / 512;
+	ext2fs_iblk_add_blocks(handle->fs, handle->inode, 1);
 	retval = ext2fs_write_inode(handle->fs, handle->ino,
 				    handle->inode);
 	if (retval)
@@ -1074,6 +1134,11 @@ done:
 	return retval;
 }
 
+errcode_t ext2fs_extent_node_split(ext2_extent_handle_t handle)
+{
+	return extent_node_split(handle, 0);
+}
+
 errcode_t ext2fs_extent_insert(ext2_extent_handle_t handle, int flags,
 				      struct ext2fs_extent *extent)
 {
@@ -1105,7 +1170,7 @@ errcode_t ext2fs_extent_insert(ext2_extent_handle_t handle, int flags,
 			printf("node full (level %d) - splitting\n",
 				   handle->level);
 #endif
-			retval = ext2fs_extent_node_split(handle);
+			retval = extent_node_split(handle, 1);
 			if (retval)
 				return retval;
 			path = handle->path + handle->level;

