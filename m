From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/3] libext2fs: Improve debugging printf's in extent.c
Date: Sun, 19 Jul 2009 23:57:04 -0400
Message-ID: <1248062225-710-2-git-send-email-tytso@mit.edu>
References: <1248062225-710-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:59386 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236AbZGTD5P (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 19 Jul 2009 23:57:15 -0400
In-Reply-To: <1248062225-710-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Comment out less common debugging printf's, and fix some type
warnings.  Add high-level debugging printf's for ext2fs_extent_goto(),
ext2fs_extent_insert(), ext2fs_extent_delete(), ext2fs_extent_replace()

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/extent.c |   59 ++++++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 51 insertions(+), 8 deletions(-)

diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index 9d7b7de..c47fbcc 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -104,7 +104,7 @@ static void dbg_print_extent(char *desc, struct ext2fs_extent *extent)
 {
 	if (desc)
 		printf("%s: ", desc);
-	printf("extent: lblk %llu--%llu, len %lu, pblk %llu, flags: ",
+	printf("extent: lblk %llu--%llu, len %u, pblk %llu, flags: ",
 	       extent->e_lblk, extent->e_lblk + extent->e_len - 1,
 	       extent->e_len, extent->e_pblk);
 	if (extent->e_flags & EXT2_EXTENT_FLAGS_LEAF)
@@ -321,7 +321,7 @@ retry:
 				return EXT2_ET_EXTENT_NO_NEXT;
 		}
 		if (op != EXT2_EXTENT_NEXT_SIB) {
-#ifdef DEBUG
+#ifdef DEBUG_GET_EXTENT
 			printf("<<<< OP = %s\n",
 			       (op == EXT2_EXTENT_DOWN) ? "down" :
 			       ((op == EXT2_EXTENT_UP) ? "up" : "unknown"));
@@ -352,7 +352,7 @@ retry:
 				return EXT2_ET_EXTENT_NO_PREV;
 		}
 		if (op != EXT2_EXTENT_PREV_SIB) {
-#ifdef DEBUG
+#ifdef DEBUG_GET_EXTENT
 			printf("<<<< OP = %s\n",
 			       (op == EXT2_EXTENT_DOWN_AND_LAST) ? "down/last" :
 			       ((op == EXT2_EXTENT_UP) ? "up" : "unknown"));
@@ -366,7 +366,7 @@ retry:
 			op = EXT2_EXTENT_DOWN;
 		else
 			op = EXT2_EXTENT_LAST_SIB;
-#ifdef DEBUG
+#ifdef DEBUG_GET_EXTENT
 		printf("<<<< OP = %s\n",
 			   (op == EXT2_EXTENT_DOWN) ? "down" : "last_sib");
 #endif
@@ -481,7 +481,7 @@ retry:
 			if (handle->level < handle->max_depth)
 				path->visit_num = 1;
 		}
-#ifdef DEBUG
+#ifdef DEBUG_GET_EXTENT
 		printf("Down to level %d/%d, end_blk=%llu\n",
 			   handle->level, handle->max_depth,
 			   path->end_blk);
@@ -495,7 +495,7 @@ retry:
 		return EXT2_ET_NO_CURRENT_NODE;
 
 	extent->e_flags = 0;
-#ifdef DEBUG
+#ifdef DEBUG_GET_EXTENT
 	printf("(Left %d)\n", path->left);
 #endif
 
@@ -628,7 +628,14 @@ static errcode_t extent_goto(ext2_extent_handle_t handle,
 		return EXT2_ET_OP_NOT_SUPPORTED;
 	}
 
+#ifdef DEBUG
+	printf("goto extent ino %u, level %d, %llu\n", handle->ino,
+	       leaf_level, blk);
+#endif
+
+#ifdef DEBUG_GOTO_EXTENTS
 	dbg_print_extent("root", &extent);
+#endif
 	while (1) {
 		if (handle->max_depth - handle->level == leaf_level) {
 			/* block is in this &extent */
@@ -658,7 +665,9 @@ static errcode_t extent_goto(ext2_extent_handle_t handle,
 		if (retval)
 			return retval;
 
+#ifdef DEBUG_GOTO_EXTENTS
 		dbg_print_extent("next", &extent);
+#endif
 		if (blk == extent.e_lblk)
 			goto go_down;
 		if (blk > extent.e_lblk)
@@ -669,7 +678,9 @@ static errcode_t extent_goto(ext2_extent_handle_t handle,
 		if (retval)
 			return retval;
 
+#ifdef DEBUG_GOTO_EXTENTS
 		dbg_print_extent("prev", &extent);
+#endif
 
 	go_down:
 		retval = ext2fs_extent_get(handle, EXT2_EXTENT_DOWN,
@@ -677,7 +688,9 @@ static errcode_t extent_goto(ext2_extent_handle_t handle,
 		if (retval)
 			return retval;
 
+#ifdef DEBUG_GOTO_EXTENTS
 		dbg_print_extent("down", &extent);
+#endif
 	}
 }
 
@@ -765,6 +778,11 @@ errcode_t ext2fs_extent_replace(ext2_extent_handle_t handle,
 	if (!path->curr)
 		return EXT2_ET_NO_CURRENT_NODE;
 
+#ifdef DEBUG
+	printf("extent replace: %u ", handle->ino);
+	dbg_print_extent(0, extent);
+#endif
+
 	if (handle->level == handle->max_depth) {
 		ex = path->curr;
 
@@ -922,7 +940,8 @@ static errcode_t extent_node_split(ext2_extent_handle_t handle)
 		goto done;
 
 #ifdef DEBUG
-	printf("will copy to new node at block %lu\n", new_node_pblk);
+	printf("will copy to new node at block %lu\n",
+	       (unsigned long) new_node_pblk);
 #endif
 
 	/* Copy data into new block buffer */
@@ -1040,6 +1059,11 @@ errcode_t ext2fs_extent_insert(ext2_extent_handle_t handle, int flags,
 	if (!handle->path)
 		return EXT2_ET_NO_CURRENT_NODE;
 
+#ifdef DEBUG
+	printf("extent insert: %u ", handle->ino);
+	dbg_print_extent(0, extent);
+#endif
+
 	path = handle->path + handle->level;
 
 	if (path->entries >= path->max_entries) {
@@ -1132,6 +1156,11 @@ errcode_t ext2fs_extent_set_bmap(ext2_extent_handle_t handle,
 
 	EXT2_CHECK_MAGIC(handle, EXT2_ET_MAGIC_EXTENT_HANDLE);
 
+#ifdef DEBUG
+	printf("set_bmap ino %u log %lld phys %lld flags %d\n",
+	       handle->ino, logical, physical, flags);
+#endif
+
 	if (!(handle->fs->flags & EXT2_FLAG_RW))
 		return EXT2_ET_RO_FILSYS;
 
@@ -1364,6 +1393,19 @@ errcode_t ext2fs_extent_delete(ext2_extent_handle_t handle, int flags)
 	if (!handle->path)
 		return EXT2_ET_NO_CURRENT_NODE;
 
+#ifdef DEBUG
+	{
+		struct ext2fs_extent	extent;
+
+		retval = ext2fs_extent_get(handle, EXT2_EXTENT_CURRENT,
+					   &extent);
+		if (retval == 0) {
+			printf("extent delete %u ", handle->ino);
+			dbg_print_extent(0, &extent);
+		}
+	}
+#endif
+
 	path = handle->path + handle->level;
 	if (!path->curr)
 		return EXT2_ET_NO_CURRENT_NODE;
@@ -1886,7 +1928,8 @@ void do_goto_block(int argc, char **argv)
 	retval = extent_goto(current_handle, level, (blk64_t) blk);
 
 	if (retval) {
-		com_err(argv[0], retval, "while trying to go to block %lu, level %d",
+		com_err(argv[0], retval,
+			"while trying to go to block %u, level %d",
 			blk, level);
 		return;
 	}
-- 
1.6.3.2.1.gb9f7d.dirty

