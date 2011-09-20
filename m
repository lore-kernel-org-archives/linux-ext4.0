From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 4/4] ext4: fix punch_hole extend handler
Date: Tue, 20 Sep 2011 18:49:30 +0400
Message-ID: <1316530170-3965-5-git-send-email-dmonakhov@openvz.org>
References: <1316530170-3965-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, achender@linux.vnet.ibm.com,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f43.google.com ([209.85.215.43]:58547 "EHLO
	mail-ew0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab1ITOtZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Sep 2011 10:49:25 -0400
Received: by ewy9 with SMTP id 9so674505ewy.2
        for <linux-ext4@vger.kernel.org>; Tue, 20 Sep 2011 07:49:24 -0700 (PDT)
In-Reply-To: <1316530170-3965-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Current implementation has following issues:
 - EOFBLOCK does not changed if necessery
 - ext4_ext_rm_leaf() may return -EAGAIN due to transaction restart
 - punched extent converted to uninitialized incorrectly
 - fsync() logic is bloken because ei->i_sync_tid was not updated
 - Last but not the least all: punch hole logic is sited directly
   in ext4_ext_map_blocks() on 3rd controll level, IMHO one can
   easily screw-up his eyes while invastigating that code. We have
   nothing to hide aren't we?

This patch performs following changes:
 - Move punch hole logic to didicated function similar to uninitialized
   extent handlers.
 - Clear EOFBLOCK if necessery, unfortunately we can not reuse
   check_eofblock_fl() function because it purpose to handle file
   expansion, but in our case we have to recheck base invariant that:
      clear_eof_flag = (eof_block >= last_allocated_block)
 - Repeat punch hole after transaction restart.
 - Update inode sync transaction id on exit.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/extents.c |  202 +++++++++++++++++++++++++++++++++-------------------
 1 files changed, 128 insertions(+), 74 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 098bf6a..3d17652 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3285,6 +3285,125 @@ out2:
 	return err ? err : allocated;
 }
 
+static int
+ext4_ext_handle_punched_extent(handle_t *handle, struct inode *inode,
+			struct ext4_map_blocks *map,
+			struct ext4_ext_path *path)
+{
+	struct ext4_extent *ex = path[path->p_depth].p_ext;
+	ext4_lblk_t ee_block =  ext4_ext_get_actual_len(ex);
+	unsigned short ee_len = le32_to_cpu(ex->ee_block);
+	struct ext4_map_blocks punch_map;
+	unsigned int punched_out = 0;
+	int err, inode_dirty = 0;
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
+		err = ext4_split_extent(handle, inode,	path, &punch_map, 0,
+					EXT4_GET_BLOCKS_PUNCH_OUT_EXT |
+					EXT4_GET_BLOCKS_PRE_IO);
+		if (err < 0) {
+			goto out;
+		}
+		/* find extent for the block at the start of the hole */
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
+		ee_len = ext4_ext_get_actual_len(ex);
+		ee_block = le32_to_cpu(ex->ee_block);
+	}
+
+	err = ext4_ext_get_access(handle, inode, path + path->p_depth);
+	if (err)
+		return err;
+	ext4_ext_mark_uninitialized(ex);
+	err = ext4_ext_dirty(handle, inode, path + path->p_depth);
+	if (err)
+		goto out;
+	ext4_ext_invalidate_cache(inode);
+	err = ext4_ext_rm_leaf(handle, inode, path, map->m_lblk,
+			map->m_lblk + punched_out);
+	if (err)
+		goto out;
+
+	inode_dirty = ext4_ext_try_shrink(handle, inode);
+	/* We have punched out an extent, if it was the only extent beyond
+	 * i_size  eofblocks flag should be cleared.*/
+	if (ext4_test_inode_flag(inode, EXT4_INODE_EOFBLOCKS)) {
+		ext4_fsblk_t eof_block =
+			(inode->i_size + (1 << inode->i_blkbits) - 1) >>
+				inode->i_blkbits;
+		/* find the latest extent */
+		ext4_ext_drop_refs(path);
+		kfree(path);
+		path = ext4_ext_find_extent(inode, EXT_MAX_BLOCKS -1, NULL);
+		if (IS_ERR(path)) {
+			err = PTR_ERR(path);
+			path = NULL;
+			goto out;
+		}
+		ex = path[path->p_depth].p_ext;
+		if (ex) {
+			ee_len = ext4_ext_get_actual_len(ex);
+			ee_block = le32_to_cpu(ex->ee_block);
+		} else {
+			/* Inode is empty */
+			ee_block = ee_len = 0;
+		}
+		if (eof_block >= ee_block + ee_len) {
+			ext4_clear_inode_flag(inode, EXT4_INODE_EOFBLOCKS);
+			inode_dirty = 1;
+		} else if (!ext4_ext_is_uninitialized(ex)) {
+			EXT4_ERROR_INODE(inode, "initialized extent beyond "
+					"EOF i_size: %lld, ex[%u:%u] "
+					"depth: %d pblock %lld",
+					inode->i_size, ee_block, ee_len,
+					path->p_depth,
+					path[path->p_depth].p_block);
+			err = -EIO;
+			/* Continue, because inode shrink should be
+			 * accomplished regardless to staled eof blocks */
+		}
+	}
+	if (inode_dirty) {
+		int err2 = ext4_mark_inode_dirty(handle, inode);
+		if (!err)
+			err = err2;
+	}
+out:
+	ext4_update_inode_fsync_trans(handle, inode, 0);
+	if (path) {
+		ext4_ext_drop_refs(path);
+		kfree(path);
+	}
+	return err ? err : punched_out;
+}
+
+
+
 /*
  * Block allocation/map/preallocation routine for extents based files
  *
@@ -3306,21 +3425,19 @@ out2:
 int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 			struct ext4_map_blocks *map, int flags)
 {
-	struct ext4_ext_path *path = NULL;
+	struct ext4_ext_path *path;
 	struct ext4_extent newex, *ex;
 	ext4_fsblk_t newblock = 0;
 	int err = 0, depth, ret;
 	unsigned int allocated = 0;
-	unsigned int punched_out = 0;
-	unsigned int result = 0;
 	struct ext4_allocation_request ar;
 	ext4_io_end_t *io = EXT4_I(inode)->cur_aio_dio;
-	struct ext4_map_blocks punch_map;
 
 	ext_debug("blocks %u/%u requested for inode %lu\n",
 		  map->m_lblk, map->m_len, inode->i_ino);
 	trace_ext4_ext_map_blocks_enter(inode, map->m_lblk, map->m_len, flags);
-
+again:
+	path = NULL;
 	/* check in cache */
 	if (!(flags & EXT4_GET_BLOCKS_PUNCH_OUT_EXT) &&
 		ext4_ext_in_cache(inode, map->m_lblk, &newex)) {
@@ -3403,71 +3520,11 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
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
-			ext4_ext_invalidate_cache(inode);
-			err = ext4_ext_rm_leaf(handle, inode, path,
-				map->m_lblk, map->m_lblk + punched_out);
-			if (!err && ext4_ext_try_shrink(handle, inode))
-				err = ext4_mark_inode_dirty(handle, inode);
-
-			goto out2;
+			ret = ext4_ext_handle_punched_extent(handle, inode,
+							map, path);
+			if (ret == -EAGAIN)
+				goto again;
+			return ret;
 		}
 	}
 
@@ -3618,10 +3675,7 @@ out2:
 	trace_ext4_ext_map_blocks_exit(inode, map->m_lblk,
 		newblock, map->m_len, err ? err : allocated);
 
-	result = (flags & EXT4_GET_BLOCKS_PUNCH_OUT_EXT) ?
-			punched_out : allocated;
