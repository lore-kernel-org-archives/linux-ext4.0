From: amir73il@users.sourceforge.net
Subject: [PATCH RFC 08/30] ext4: snapshot hooks - move extent file data blocks
Date: Mon,  9 May 2011 19:41:26 +0300
Message-ID: <1304959308-11122-9-git-send-email-amir73il@users.sourceforge.net>
References: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu, Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33538 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab1EIQn3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 May 2011 12:43:29 -0400
Received: by mail-wy0-f174.google.com with SMTP id 21so4026020wya.19
        for <linux-ext4@vger.kernel.org>; Mon, 09 May 2011 09:43:28 -0700 (PDT)
In-Reply-To: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
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
 fs/ext4/extents.c   |  143 +++++++++++++++++++++++++++++++++++++++++++++------
 fs/ext4/inode.c     |    3 +-
 3 files changed, 128 insertions(+), 20 deletions(-)

diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index 1c119cc..ea3a0a0 100644
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
index c8cab3d..11fe058 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1256,11 +1256,10 @@ static int ext4_ext_search_left(struct inode *inode,
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
@@ -1324,11 +1323,10 @@ static int ext4_ext_search_right(struct inode *inode,
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
@@ -3155,7 +3153,8 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 			struct ext4_map_blocks *map, int flags)
 {
 	struct ext4_ext_path *path = NULL;
-	struct ext4_extent newex, *ex;
+	struct ext4_extent newex, *ex = NULL;
+	ext4_fsblk_t oldblock = 0;
 	ext4_fsblk_t newblock = 0;
 	int err = 0, depth, ret;
 	unsigned int allocated = 0;
@@ -3184,7 +3183,7 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 			/* number of remaining blocks in the extent */
 			allocated = ext4_ext_get_actual_len(&newex) -
 				(map->m_lblk - le32_to_cpu(newex.ee_block));
-			goto out;
+			goto found;
 		}
 	}
 
@@ -3235,7 +3234,7 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 			if (!ext4_ext_is_uninitialized(ex)) {
 				ext4_ext_put_in_cache(inode, ee_block,
 							ee_len, ee_start);
-				goto out;
+				goto found;
 			}
 			ret = ext4_ext_handle_uninitialized_extents(handle,
 					inode, map, path, flags, allocated,
@@ -3256,6 +3255,59 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
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
+		 *
+		 * XXX With delayed-move-write support,
+		 * multi-blocks should be moved each time.
+		 */
+		allocated = allocated < map->m_len ? allocated : map->m_len;
+		err = ext4_snapshot_get_move_access(handle, inode, newblock,
+				&allocated, 0);
+		map->m_len = allocated;
+		if (err > 0) {
+			if (!(flags & EXT4_GET_BLOCKS_CREATE)) {
+				/* Do not map found block. */
+				map->m_flags |= EXT4_MAP_REMAP;
+				err = 0;
+				goto out;
+			} else {
+				oldblock = newblock;
+			}
+		} else if (err < 0)
+			goto out2;
+
+		if ((path == NULL) && (flags & EXT4_GET_BLOCKS_CREATE)) {
+			/* find extent for this block */
+			path = ext4_ext_find_extent(inode, map->m_lblk, NULL);
+			if (IS_ERR(path)) {
+				err = PTR_ERR(path);
+				path = NULL;
+				goto out2;
+			}
+			depth = ext_depth(inode);
+			ex = path[depth].p_ext;
+		}
+	}
+
+	if (!(flags & EXT4_GET_BLOCKS_CREATE))
+		goto out;
+
 	/*
 	 * Okay, we need to do block allocation.
 	 */
@@ -3265,7 +3317,7 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 	err = ext4_ext_search_left(inode, path, &ar.lleft, &ar.pleft);
 	if (err)
 		goto out2;
-	ar.lright = map->m_lblk;
+	ar.lright = map->m_lblk + allocated;
 	err = ext4_ext_search_right(inode, path, &ar.lright, &ar.pright);
 	if (err)
 		goto out2;
@@ -3286,7 +3338,11 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
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
@@ -3337,7 +3393,55 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 	if (err)
 		goto out2;
 
-	err = ext4_ext_insert_extent(handle, inode, path, &newex, flags);
+	if (oldblock) {
+		/*
+		 * Move oldblocks to snapshot.
+		 */
+		map->m_len = ar.len;
+		err = ext4_snapshot_get_move_access(handle, inode,
+				oldblock, &map->m_len, 1);
+		if (err <= 0 || map->m_len < ar.len) {
+			/* failed to move to snapshot - abort! */
+			err = err ? : -EIO;
+			ext4_journal_abort_handle(__func__, __LINE__,
+					"ext4_snapshot_get_move_access", NULL,
+					handle, err);
+		} else {
+			/*
+			 * Move to snapshot successfully.
+			 * TODO merge extent after finishing MOW
+			 */
+			err = ext4_split_extent(handle, inode, path, map, 0,
+						flags | EXT4_GET_BLOCKS_PRE_IO);
+			if (err < 0)
+				goto out;
+
+			/* extent tree may be changed. */
+			depth = ext_depth(inode);
+			ext4_ext_drop_refs(path);
+			path = ext4_ext_find_extent(inode, map->m_lblk, path);
+			if (IS_ERR(path)) {
+				err = PTR_ERR(path);
+				goto out;
+			}
+
+			/* just verify splitting. */
+			ex = path[depth].p_ext;
+			BUG_ON(le32_to_cpu(ex->ee_block) != map->m_lblk ||
+			       ext4_ext_get_actual_len(ex) != map->m_len);
+
+			err = ext4_ext_get_access(handle, inode, path + depth);
+			if (!err) {
+				/* splice new blocks to the inode*/
+				ext4_ext_store_pblock(ex, newblock);
+				err = ext4_ext_dirty(handle, inode,
+						     path + depth);
+			}
+		}
+
+	} else
+		err = ext4_ext_insert_extent(handle, inode,
+					     path, &newex, flags);
 	if (err) {
 		/* free data blocks we just allocated */
 		/* not a good idea to call discard here directly,
@@ -3366,7 +3470,12 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
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
index 476606b..866ac36 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1357,7 +1357,8 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
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
1.7.0.4

