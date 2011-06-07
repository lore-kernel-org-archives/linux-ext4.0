From: amir73il@users.sourceforge.net
Subject: [PATCH v1 08/36] ext4: snapshot hooks - move extent file data blocks
Date: Tue,  7 Jun 2011 18:07:35 +0300
Message-ID: <1307459283-22130-9-git-send-email-amir73il@users.sourceforge.net>
References: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu, lczerner@redhat.com,
	Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60303 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755431Ab1FGPJQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Jun 2011 11:09:16 -0400
Received: by mail-wy0-f174.google.com with SMTP id 21so3629480wya.19
        for <linux-ext4@vger.kernel.org>; Tue, 07 Jun 2011 08:09:15 -0700 (PDT)
In-Reply-To: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Amir Goldstein <amir73il@users.sf.net>

Extent mapped file data is moved into snapshot in ext4_ext_map_blocks().
If a part of a extent is to be moved, the extent is splitted. Fragmentation
is light because of delayed-move-on-write.


Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/ext4_jbd2.h |    2 -
 fs/ext4/extents.c   |  151 +++++++++++++++++++++++++++++++++++++++++++++------
 fs/ext4/inode.c     |    3 +-
 3 files changed, 136 insertions(+), 20 deletions(-)

diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index 46dc1ce..1dfd439 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -369,8 +369,6 @@ static inline int ext4_snapshot_should_move_data(struct inode *inode)
 		return 0;
 	if (EXT4_JOURNAL(inode) == NULL)
 		return 0;
-	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
-		return 0;
 	/* when a data block is journaled, it is already COWed as metadata */
 	if (ext4_should_journal_data(inode))
 		return 0;
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 6f0a711..234a043 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1260,11 +1260,10 @@ static int ext4_ext_search_left(struct inode *inode,
 		return 0;
 	}
 
-	if (unlikely(*logical < (le32_to_cpu(ex->ee_block) + ee_len))) {
-		EXT4_ERROR_INODE(inode,
-				 "logical %d < ee_block %d + ee_len %d!",
-				 *logical, le32_to_cpu(ex->ee_block), ee_len);
-		return -EIO;
+	if (*logical < (le32_to_cpu(ex->ee_block) + ee_len)) {
+		*logical -= 1;
+		*phys = ext4_ext_pblock(ex) + *logical;
+		return 0;
 	}
 
 	*logical = le32_to_cpu(ex->ee_block) + ee_len - 1;
@@ -1328,11 +1327,10 @@ static int ext4_ext_search_right(struct inode *inode,
 		return 0;
 	}
 
-	if (unlikely(*logical < (le32_to_cpu(ex->ee_block) + ee_len))) {
-		EXT4_ERROR_INODE(inode,
-				 "logical %d < ee_block %d + ee_len %d!",
-				 *logical, le32_to_cpu(ex->ee_block), ee_len);
-		return -EIO;
+	if (*logical < (le32_to_cpu(ex->ee_block) + ee_len)) {
+		*logical += 1;
+		*phys = ext4_ext_pblock(ex) + *logical;
+		return 0;
 	}
 
 	if (ex != EXT_LAST_EXTENT(path[depth].p_hdr)) {
@@ -3139,6 +3137,63 @@ out2:
 }
 
 /*
+ * Move oldblocks to snapshot and newblocks to the file.
+ */
+static int ext4_ext_move_to_snapshot(handle_t *handle, struct inode *inode,
+				     struct ext4_map_blocks *map,
+				     struct ext4_ext_path *path,
+				     ext4_fsblk_t oldblock,
+				     ext4_fsblk_t newblock)
+{
+	struct ext4_extent *ex;
+	int err, depth, len;
+
+	len = map->m_len;
+	err = ext4_snapshot_get_move_access(handle, inode,
+			oldblock, &map->m_len, 1);
+	if (err <= 0 || map->m_len != len) {
+		/* failed to move to snapshot - abort! */
+		err = err ? : -EIO;
+		ext4_journal_abort_handle(__func__, __LINE__,
+				"ext4_snapshot_get_move_access", NULL,
+				handle, err);
+	} else {
+		/*
+		 * Move to snapshot successfully.
+		 */
+		err = ext4_split_extent(handle, inode, path, map, 0,
+					EXT4_GET_BLOCKS_PRE_IO);
+		if (err < 0)
+			goto out;
+
+		/* extent tree may be changed. */
+		depth = ext_depth(inode);
+		ext4_ext_drop_refs(path);
+		path = ext4_ext_find_extent(inode, map->m_lblk, path);
+		if (IS_ERR(path)) {
+			err = PTR_ERR(path);
+			goto out;
+		}
+
+		/* just verify splitting. */
+		ex = path[depth].p_ext;
+		BUG_ON(le32_to_cpu(ex->ee_block) != map->m_lblk ||
+		       ext4_ext_get_actual_len(ex) != map->m_len);
+
+		err = ext4_ext_get_access(handle, inode, path + depth);
+		if (!err) {
+			/* splice new blocks to the inode*/
+			ext4_ext_store_pblock(ex, newblock);
+			ext4_ext_try_to_merge(inode, path, ex);
+			err = ext4_ext_dirty(handle, inode,
+					     path + depth);
+		}
+	}
+
+out:
+	return err;
+}
+/*
  * Block allocation/map/preallocation routine for extents based files
  *
  *
@@ -3160,7 +3215,8 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 			struct ext4_map_blocks *map, int flags)
 {
 	struct ext4_ext_path *path = NULL;
-	struct ext4_extent newex, *ex;
+	struct ext4_extent newex, *ex = NULL;
+	ext4_fsblk_t oldblock = 0;
 	ext4_fsblk_t newblock = 0;
 	int err = 0, depth, ret;
 	unsigned int allocated = 0;
@@ -3190,7 +3246,7 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 			/* number of remaining blocks in the extent */
 			allocated = ext4_ext_get_actual_len(&newex) -
 				(map->m_lblk - le32_to_cpu(newex.ee_block));
-			goto out;
+			goto found;
 		}
 	}
 
@@ -3241,7 +3297,7 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 			if (!ext4_ext_is_uninitialized(ex)) {
 				ext4_ext_put_in_cache(inode, ee_block,
 							ee_len, ee_start);
-				goto out;
+				goto found;
 			}
 			ret = ext4_ext_handle_uninitialized_extents(handle,
 					inode, map, path, flags, allocated,
@@ -3262,6 +3318,51 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 		ext4_ext_put_gap_in_cache(inode, path, map->m_lblk);
 		goto out2;
 	}
+
+	/*
+	 * two cases:
+	 * 1. the request block is found.
+	 *    a. If EXT4_GET_BLOCKS_CREATE is not set, we will test
+	 *       if MOW is needed.
+	 *    b. If EXT4_GET_BLOCKS_CREATE is set. MOW will be done
+	 *       if MOW is needed.
+	 *
+	 * 2. the request block is not found, EXT4_GET_BLOCKS_CREATE
+	 *    must be set and MOW must be not needed.
+	 */
+found:
+	if (newblock && (flags & EXT4_GET_BLOCKS_MOVE_ON_WRITE)) {
+		BUG_ON(!ext4_snapshot_should_move_data(inode));
+		/*
+		 * Should move 1 block to snapshot?
+		 */
+		allocated = min(map->m_len, allocated);
+		err = ext4_snapshot_get_move_access(handle, inode, newblock,
+						    &allocated, 0);
+		map->m_len = allocated;
+		if (err > 0) {
+			map->m_flags |= EXT4_MAP_REMAP;
+			err = 0;
+			oldblock = newblock;
+		} else if (err < 0)
+			goto out2;
+	}
+
+	if (!(flags & EXT4_GET_BLOCKS_CREATE))
+		goto out;
+
+	map->m_flags &= ~EXT4_MAP_REMAP;
+	if ((path == NULL) && (flags & EXT4_GET_BLOCKS_CREATE)) {
+		/* find extent for this block */
+		path = ext4_ext_find_extent(inode, map->m_lblk, NULL);
+		if (IS_ERR(path)) {
+			err = PTR_ERR(path);
+			path = NULL;
+			goto out2;
+		}
+		depth = ext_depth(inode);
+		ex = path[depth].p_ext;
+	}
 	/*
 	 * Okay, we need to do block allocation.
 	 */
@@ -3271,7 +3372,7 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 	err = ext4_ext_search_left(inode, path, &ar.lleft, &ar.pleft);
 	if (err)
 		goto out2;
-	ar.lright = map->m_lblk;
+	ar.lright = map->m_lblk + allocated;
 	err = ext4_ext_search_right(inode, path, &ar.lright, &ar.pright);
 	if (err)
 		goto out2;
@@ -3292,7 +3393,11 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 	/* Check if we can really insert (m_lblk)::(m_lblk + m_len) extent */
 	newex.ee_block = cpu_to_le32(map->m_lblk);
 	newex.ee_len = cpu_to_le16(map->m_len);
-	err = ext4_ext_check_overlap(inode, &newex, path);
+	if (oldblock) {
+		/* Overlap checking is not needed for MOW case. */
+		err = 0;
+	} else
+		err = ext4_ext_check_overlap(inode, &newex, path);
 	if (err)
 		allocated = ext4_ext_get_actual_len(&newex);
 	else
@@ -3343,7 +3448,14 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 	if (err)
 		goto out2;
 
-	err = ext4_ext_insert_extent(handle, inode, path, &newex, flags);
+	if (oldblock) {
+		map->m_len = ar.len;
+		BUG_ON(!(flags & EXT4_GET_BLOCKS_MOVE_ON_WRITE));
+		err = ext4_ext_move_to_snapshot(handle, inode, map, path,
+						oldblock, newblock);
+	} else
+		err = ext4_ext_insert_extent(handle, inode,
+					     path, &newex, flags);
 	if (err) {
 		/* free data blocks we just allocated */
 		/* not a good idea to call discard here directly,
@@ -3372,7 +3484,12 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 	 * Cache the extent and update transaction to commit on fdatasync only
 	 * when it is _not_ an uninitialized extent.
 	 */
-	if ((flags & EXT4_GET_BLOCKS_UNINIT_EXT) == 0) {
+	if (IS_COWING(handle)) {
+		/*
+		 * snapshot does not supprt fdatasync and fsync
+		 * and there is no need to cache extent
+		 */
+	} else if ((flags & EXT4_GET_BLOCKS_UNINIT_EXT) == 0) {
 		ext4_ext_put_in_cache(inode, map->m_lblk, allocated, newblock);
 		ext4_update_inode_fsync_trans(handle, inode, 1);
 	} else
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 1cb94d2..1f1ba2b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1360,7 +1360,8 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 	 */
 	down_read((&EXT4_I(inode)->i_data_sem));
 	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)) {
-		retval = ext4_ext_map_blocks(handle, inode, map, 0);
+		retval = ext4_ext_map_blocks(handle, inode, map,
+				flags & EXT4_GET_BLOCKS_MOVE_ON_WRITE);
 	} else {
 		retval = ext4_ind_map_blocks(handle, inode, map,
 				flags & EXT4_GET_BLOCKS_MOVE_ON_WRITE);
-- 
1.7.4.1

