From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 3/7] ext4: Move punch hole logic to didicated function
Date: Fri, 28 Oct 2011 21:00:06 +0400
Message-ID: <1319821210-7374-4-git-send-email-dmonakhov@openvz.org>
References: <1319821210-7374-1-git-send-email-dmonakhov@openvz.org>
Cc: achender@linux.vnet.ibm.com, tytso@mit.edu,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64725 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917Ab1J1RAW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Oct 2011 13:00:22 -0400
Received: by mail-bw0-f46.google.com with SMTP id zt4so624053bkb.19
        for <linux-ext4@vger.kernel.org>; Fri, 28 Oct 2011 10:00:21 -0700 (PDT)
In-Reply-To: <1319821210-7374-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

punch hole logic is sited directly in ext4_ext_map_blocks() on 3rd controll
level, IMHO one can easily screw-up his eyes while invastigating that code.
We have  nothing to hide aren't we? Let's move it to didicate function.
Do it similar to uninitialized extent handlers. Logic moved as is.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/extents.c |  145 +++++++++++++++++++++++++----------------------------
 1 files changed, 68 insertions(+), 77 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 6e3ce38..02dfe38 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3225,6 +3225,70 @@ static void unmap_underlying_metadata_blocks(struct block_device *bdev,
                 unmap_underlying_metadata(bdev, block + i);
 }
 
+static int
+ext4_ext_handle_punched_extent(handle_t *handle, struct inode *inode,
+			struct ext4_map_blocks *map, struct ext4_ext_path *path)
+{
+	struct ext4_extent *ex = path[path->p_depth].p_ext;
+	ext4_lblk_t ee_block =  ext4_ext_get_actual_len(ex);
+	unsigned short ee_len = le32_to_cpu(ex->ee_block);
+	struct ext4_map_blocks punch_map;
+	ext4_fsblk_t partial_cluster = 0;
+	unsigned int punched_out = 0;
+   	int err;
+
+	/* Punch out the map length, but only to the end of the extent */
+	punched_out = ee_len - (map->m_lblk - ee_block);
+	if (punched_out > map->m_len)
+		punched_out = map->m_len;
+	/*
+	 * Sense extents need to be converted to uninitialized, they must
+	 * fit in an uninitialized extent
+	 */
+	if (punched_out > EXT_UNINIT_MAX_LEN)
+		punched_out = EXT_UNINIT_MAX_LEN;
+
+	punch_map.m_lblk = map->m_lblk;
+	punch_map.m_pblk = map->m_lblk - ee_block + ext4_ext_pblock(ex);;
+	punch_map.m_len = punched_out;
+	punch_map.m_flags = 0;
+
+	/* Check to see if the extent needs to be split */
+	if (punch_map.m_len != ee_len || punch_map.m_lblk != ee_block) {
+		err = ext4_split_extent(handle, inode, path, &punch_map, 0,
+					EXT4_GET_BLOCKS_PUNCH_OUT_EXT |
+					EXT4_GET_BLOCKS_PRE_IO);
+		if (err < 0)
+			goto out;
+		/*
+		 * find extent for the block at the start of the hole
+		 */
+		ext4_ext_drop_refs(path);
+		kfree(path);
+
+		path = ext4_ext_find_extent(inode, map->m_lblk, NULL);
+		if (IS_ERR(path)) {
+			err = PTR_ERR(path);
+			path = NULL;
+			goto out;
+		}
+		ex = path[path->p_depth].p_ext;
+	}
+
+	ext4_ext_mark_uninitialized(ex);
+	ext4_ext_invalidate_cache(inode);
+	err = ext4_ext_rm_leaf(handle, inode, path, &partial_cluster,
+			       map->m_lblk, map->m_lblk + punched_out);
+	if (!err && ext4_ext_try_shrink(handle, inode))
+		err = ext4_mark_inode_dirty(handle, inode);
+out:
+	if (path) {
+		ext4_ext_drop_refs(path);
+		kfree(path);
+	}
+
+	return err ? err : punched_out;
+}
 /*
  * Handle EOFBLOCKS_FL flag, clearing it if necessary
  */
@@ -3731,12 +3795,9 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 	int eof_fl = 0;
 	unsigned int allocated = 0, offset = 0;
 	unsigned int allocated_clusters = 0, reserved_clusters = 0;
-	unsigned int punched_out = 0;
-	unsigned int result = 0;
 	struct ext4_allocation_request ar;
 	ext4_io_end_t *io = EXT4_I(inode)->cur_aio_dio;
 	ext4_lblk_t cluster_offset;
-	struct ext4_map_blocks punch_map;
 
 	ext_debug("blocks %u/%u requested for inode %lu\n",
 		  map->m_lblk, map->m_len, inode->i_ino);
@@ -3812,8 +3873,6 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 
 		/* if found extent covers block, simply return it */
 		if (in_range(map->m_lblk, ee_block, ee_len)) {
-			ext4_fsblk_t partial_cluster = 0;
-
 			newblock = map->m_lblk - ee_block + ee_start;
 			/* number of remaining blocks in the extent */
 			allocated = ee_len - (map->m_lblk - ee_block);
@@ -3835,75 +3894,9 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 					allocated, newblock);
 				return ret;
 			}
-
-			/*
-			 * Punch out the map length, but only to the
-			 * end of the extent
-			 */
-			punched_out = allocated < map->m_len ?
-				allocated : map->m_len;
-
-			/*
-			 * Sense extents need to be converted to
-			 * uninitialized, they must fit in an
-			 * uninitialized extent
-			 */
-			if (punched_out > EXT_UNINIT_MAX_LEN)
-				punched_out = EXT_UNINIT_MAX_LEN;
-
-			punch_map.m_lblk = map->m_lblk;
-			punch_map.m_pblk = newblock;
-			punch_map.m_len = punched_out;
-			punch_map.m_flags = 0;
-
-			/* Check to see if the extent needs to be split */
-			if (punch_map.m_len != ee_len ||
-				punch_map.m_lblk != ee_block) {
-
-				ret = ext4_split_extent(handle, inode,
-				path, &punch_map, 0,
-				EXT4_GET_BLOCKS_PUNCH_OUT_EXT |
-				EXT4_GET_BLOCKS_PRE_IO);
-
-				if (ret < 0) {
-					err = ret;
-					goto out2;
-				}
-				/*
-				 * find extent for the block at
-				 * the start of the hole
-				 */
-				ext4_ext_drop_refs(path);
-				kfree(path);
-
-				path = ext4_ext_find_extent(inode,
-				map->m_lblk, NULL);
-				if (IS_ERR(path)) {
-					err = PTR_ERR(path);
-					path = NULL;
-					goto out2;
-				}
-
-				depth = ext_depth(inode);
-				ex = path[depth].p_ext;
-				ee_len = ext4_ext_get_actual_len(ex);
-				ee_block = le32_to_cpu(ex->ee_block);
-				ee_start = ext4_ext_pblock(ex);
-
-			}
-
-			ext4_ext_mark_uninitialized(ex);
-
-			ext4_ext_invalidate_cache(inode);
-
-			err = ext4_ext_rm_leaf(handle, inode, path,
-					       &partial_cluster, map->m_lblk,
-					       map->m_lblk + punched_out);
-
-			if (!err && ext4_ext_try_shrink(handle, inode))
-				err = ext4_mark_inode_dirty(handle, inode);
