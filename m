From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH -v2] ext4: Fix EOFBLOCKS_FL handling
Date: Sat, 21 Aug 2010 17:07:26 -0400
Message-ID: <1282424846-30689-1-git-send-email-tytso@mit.edu>
References: <1282187058-23732-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:50268 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747Ab0HUVH3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 21 Aug 2010 17:07:29 -0400
In-Reply-To: <1282187058-23732-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

It turns out we have several problems with how EOFBLOCKS_FL is
handled.  First of all, there was a fencepost error where we were not
clearing the EOFBLOCKS_FL when fill in the last uninitialized block,
but rather when we allocate the next block _after_ the uninitalized
block.  Secondly we were not testing to see if we needed to clear the
EOFBLOCKS_FL when writing to the file O_DIRECT or when were converting
an uninitialized block (which is the most common case).

Google-Bug-Id: 2928259

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/extents.c |   91 ++++++++++++++++++++++++++++++++++++-----------------
 1 files changed, 62 insertions(+), 29 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 06328d3..98797e2 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3180,6 +3180,50 @@ static void unmap_underlying_metadata_blocks(struct block_device *bdev,
                 unmap_underlying_metadata(bdev, block + i);
 }
 
+/*
+ * Handle EOFBLOCKS_FL flag, clearing it if necessary
+ */
+static int check_eofblocks_fl(handle_t *handle, struct inode *inode,
+			      struct ext4_map_blocks *map,
+			      struct ext4_ext_path *path,
+			      unsigned int len)
+{
+	int i, depth;
+	struct ext4_extent_header *eh;
+	struct ext4_extent *ex, *last_ex;
+
+	if (!ext4_test_inode_flag(inode, EXT4_INODE_EOFBLOCKS))
+		return 0;
+
+	depth = ext_depth(inode);
+	eh = path[depth].p_hdr;
+	ex = path[depth].p_ext;
+
+	if (unlikely(!eh->eh_entries)) {
+		EXT4_ERROR_INODE(inode, "eh->eh_entries == 0 and "
+				 "EOFBLOCKS_FL set");
+		return -EIO;
+	}
+	last_ex = EXT_LAST_EXTENT(eh);
+	/*
+	 * If the current leaf block was reached by looking at the
+	 * last index block all the way down the tree, and we are
+	 * extending the inode beyond the last extent in the current
+	 * leaf block, then clear the EOFBLOCKS_FL flag.
+	 */
+	if (map->m_lblk + len < le32_to_cpu(last_ex->ee_block) +
+	    ext4_ext_get_actual_len(last_ex))
+		return 0;
+	for (i = depth-1; i >= 0; i--) {
+		if (path[i].p_idx != EXT_LAST_INDEX(path[i].p_hdr))
+			break;
+	}
+	if (i >= 0)
+		return 0;
+	ext4_clear_inode_flag(inode, EXT4_INODE_EOFBLOCKS);
+	return ext4_mark_inode_dirty(handle, inode);
+}
+
 static int
 ext4_ext_handle_uninitialized_extents(handle_t *handle, struct inode *inode,
 			struct ext4_map_blocks *map,
@@ -3217,8 +3261,12 @@ ext4_ext_handle_uninitialized_extents(handle_t *handle, struct inode *inode,
 	if ((flags & EXT4_GET_BLOCKS_CONVERT)) {
 		ret = ext4_convert_unwritten_extents_endio(handle, inode,
 							path);
-		if (ret >= 0)
+		if (ret >= 0) {
 			ext4_update_inode_fsync_trans(handle, inode, 1);
+			err = check_eofblocks_fl(handle, inode, map, path,
+						 map->m_len);
+		} else
+			err = ret;
 		goto out2;
 	}
 	/* buffered IO case */
@@ -3244,8 +3292,13 @@ ext4_ext_handle_uninitialized_extents(handle_t *handle, struct inode *inode,
 
 	/* buffered write, writepage time, convert*/
 	ret = ext4_ext_convert_to_initialized(handle, inode, map, path);
-	if (ret >= 0)
+	if (ret >= 0) {
 		ext4_update_inode_fsync_trans(handle, inode, 1);
+		err = check_eofblocks_fl(handle, inode, map, path, map->m_len);
+		if (err < 0)
+			goto out2;
+	}
+
 out:
 	if (ret <= 0) {
 		err = ret;
@@ -3292,6 +3345,7 @@ out2:
 	}
 	return err ? err : allocated;
 }
+
 /*
  * Block allocation/map/preallocation routine for extents based files
  *
@@ -3315,9 +3369,9 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 {
 	struct ext4_ext_path *path = NULL;
 	struct ext4_extent_header *eh;
-	struct ext4_extent newex, *ex, *last_ex;
+	struct ext4_extent newex, *ex;
 	ext4_fsblk_t newblock;
-	int i, err = 0, depth, ret, cache_type;
+	int err = 0, depth, ret, cache_type;
 	unsigned int allocated = 0;
 	struct ext4_allocation_request ar;
 	ext4_io_end_t *io = EXT4_I(inode)->cur_aio_dio;
@@ -3497,31 +3551,10 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 			map->m_flags |= EXT4_MAP_UNINIT;
 	}
 
-	if (unlikely(ext4_test_inode_flag(inode, EXT4_INODE_EOFBLOCKS))) {
-		if (unlikely(!eh->eh_entries)) {
-			EXT4_ERROR_INODE(inode,
-					 "eh->eh_entries == 0 and "
-					 "EOFBLOCKS_FL set");
-			err = -EIO;
-			goto out2;
-		}
-		last_ex = EXT_LAST_EXTENT(eh);
-		/*
-		 * If the current leaf block was reached by looking at
-		 * the last index block all the way down the tree, and
-		 * we are extending the inode beyond the last extent
-		 * in the current leaf block, then clear the
-		 * EOFBLOCKS_FL flag.
-		 */
-		for (i = depth-1; i >= 0; i--) {
-			if (path[i].p_idx != EXT_LAST_INDEX(path[i].p_hdr))
-				break;
-		}
-		if ((i < 0) &&
-		    (map->m_lblk + ar.len > le32_to_cpu(last_ex->ee_block) +
-		     ext4_ext_get_actual_len(last_ex)))
-			ext4_clear_inode_flag(inode, EXT4_INODE_EOFBLOCKS);
-	}
+	err = check_eofblocks_fl(handle, inode, map, path, ar.len);
+	if (err)
+		goto out2;
+
 	err = ext4_ext_insert_extent(handle, inode, path, &newex, flags);
 	if (err) {
 		/* free data blocks we just allocated */
-- 
1.7.1

