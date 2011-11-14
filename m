From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 2/2] ext4: let ext4 cache uninitialized extents
Date: Mon, 14 Nov 2011 11:07:06 +0800
Message-ID: <1321240026-844-3-git-send-email-xiaoqiangnk@gmail.com>
References: <1321240026-844-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: tytso@mit.edu, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38112 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab1KNF3i (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Nov 2011 00:29:38 -0500
Received: by mail-iy0-f174.google.com with SMTP id e36so6824050iag.19
        for <linux-ext4@vger.kernel.org>; Sun, 13 Nov 2011 21:29:37 -0800 (PST)
In-Reply-To: <1321240026-844-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

For now, ext4 does not cache uninitialized extents.  Thus,
ext4_ext_map_blocks on a fallocated file lookups extent tree
every time.  This patch tries to cache uninitialized extents.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/ext4.h    |    1 +
 fs/ext4/extents.c |   52 +++++++++++++++++++++++++++++++++++++++++-----------
 2 files changed, 42 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 604c200..80d29ed 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -770,6 +770,7 @@ do {									       \
 /*
  * storage for cached extent
  * If ec_len == 0, then the cache is invalid.
+ * If ec_len > EXT_INIT_MAX_LEN, then the cache is uninitialized.
  * If ec_start == 0, then the cache represents a gap (null mapping)
  */
 struct ext4_ext_cache {
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index a99d123..7d68186 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2009,6 +2009,18 @@ ext4_ext_put_gap_in_cache(struct inode *inode, struct ext4_ext_path *path,
 	ext4_ext_put_in_cache(inode, lblock, len, 0);
 }
 
+static unsigned int ext4_ext_cache_get_actual_len(struct ext4_ext_cache *cex)
+{
+	return cex->ec_start == 0 ? cex->ec_len :
+	       (cex->ec_len <= EXT_INIT_MAX_LEN ? cex->ec_len :
+		(cex->ec_len - EXT_INIT_MAX_LEN));
+}
+
+static int ext4_ext_cache_is_uninitialized(struct ext4_ext_cache *cex)
+{
+	return cex->ec_start == 0 ? 0 : cex->ec_len > EXT_INIT_MAX_LEN;
+}
+
 /*
  * ext4_ext_check_cache()
  * Checks to see if the given block is in the cache.
@@ -2042,11 +2054,14 @@ static int ext4_ext_check_cache(struct inode *inode, ext4_lblk_t block,
 	if (cex->ec_len == 0)
 		goto errout;
 
-	if (in_range(block, cex->ec_block, cex->ec_len)) {
+	if (in_range(block, cex->ec_block,
+		     ext4_ext_cache_get_actual_len(cex))) {
 		memcpy(ex, cex, sizeof(struct ext4_ext_cache));
-		ext_debug("%u cached by %u:%u:%llu\n",
-				block,
-				cex->ec_block, cex->ec_len, cex->ec_start);
+		ext_debug("%u cached by %u:[%d]%u:%llu\n",
+			  block, cex->ec_block,
+			  ext4_ext_cache_is_uninitialized(cex),
+			  ext4_ext_cache_get_actual_len(cex),
+			  cex->ec_start);
 		ret = 1;
 	}
 errout:
@@ -2061,6 +2076,7 @@ errout:
 
 #define CACHE_EXTENT_HOLE		1
 #define CACHE_EXTENT_INITIALIZED	2
+#define CACHE_EXTENT_UNINITIALIZED	3
 /*
  * ext4_ext_in_cache()
  * Checks to see if the given block is in the cache.
@@ -2084,9 +2100,11 @@ ext4_ext_in_cache(struct inode *inode, ext4_lblk_t block,
 	if (ext4_ext_check_cache(inode, block, &cex)) {
 		ex->ee_block = cpu_to_le32(cex.ec_block);
 		ext4_ext_store_pblock(ex, cex.ec_start);
-		ex->ee_len = cpu_to_le16(cex.ec_len);
+		ex->ee_len = ext4_ext_cache_get_actual_len(&cex);
 		if (cex.ec_start == 0)
 			ret = CACHE_EXTENT_HOLE;
+		else if (ext4_ext_cache_is_uninitialized(&cex))
+			ret = CACHE_EXTENT_UNINITIALIZED;
 		else
 			ret = CACHE_EXTENT_INITIALIZED;
 	}
@@ -3483,6 +3501,7 @@ ext4_ext_handle_uninitialized_extents(handle_t *handle, struct inode *inode,
 			ext4_set_inode_state(inode, EXT4_STATE_DIO_UNWRITTEN);
 		if (ext4_should_dioread_nolock(inode))
 			map->m_flags |= EXT4_MAP_UNINIT;
+		ext4_ext_invalidate_cache(inode);
 		goto out;
 	}
 	/* IO end_io complete, convert the filled extent to written */
@@ -3493,6 +3512,7 @@ ext4_ext_handle_uninitialized_extents(handle_t *handle, struct inode *inode,
 			ext4_update_inode_fsync_trans(handle, inode, 1);
 			err = check_eofblocks_fl(handle, inode, map->m_lblk,
 						 path, map->m_len);
+			ext4_ext_invalidate_cache(inode);
 		} else
 			err = ret;
 		goto out2;
@@ -3514,14 +3534,21 @@ ext4_ext_handle_uninitialized_extents(handle_t *handle, struct inode *inode,
 		 * the buffer head will be unmapped so that
 		 * a read from the block returns 0s.
 		 */
+		int depth = ext_depth(inode);
+		struct ext4_extent *ex = path[depth].p_ext;
+		ext4_ext_put_in_cache(inode, le32_to_cpu(ex->ee_block),
+				      le16_to_cpu(ex->ee_len),
+				      ext4_ext_pblock(ex));
 		map->m_flags |= EXT4_MAP_UNWRITTEN;
 		goto out1;
 	}
 
 	/* buffered write, writepage time, convert*/
 	ret = ext4_ext_convert_to_initialized(handle, inode, map, path);
-	if (ret >= 0)
+	if (ret >= 0) {
 		ext4_update_inode_fsync_trans(handle, inode, 1);
+		ext4_ext_invalidate_cache(inode);
+	}
 out:
 	if (ret <= 0) {
 		err = ret;
@@ -3744,6 +3771,12 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 			/* we should allocate requested block */
 			break;
 
+		case CACHE_EXTENT_UNINITIALIZED:
+			if (flags & EXT4_GET_BLOCKS_CREATE)
+				break;
+
+			map->m_flags |= EXT4_MAP_UNWRITTEN;
+
 		case CACHE_EXTENT_INITIALIZED:
 			/* block is already allocated */
 			if (sbi->s_cluster_ratio > 1)
@@ -3808,10 +3841,6 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 				  ee_block, ee_len, newblock);
 
 			if ((flags & EXT4_GET_BLOCKS_PUNCH_OUT_EXT) == 0) {
-				/*
-				 * Do not put uninitialized extent
-				 * in the cache
-				 */
 				if (!ext4_ext_is_uninitialized(ex)) {
 					ext4_ext_put_in_cache(inode, ee_block,
 						ee_len, ee_start);
@@ -4165,7 +4194,8 @@ out:
 	if (allocated > map->m_len)
 		allocated = map->m_len;
 	ext4_ext_show_leaf(inode, path);
-	map->m_flags |= EXT4_MAP_MAPPED;
+	if (!(map->m_flags&EXT4_MAP_UNWRITTEN))
+		map->m_flags |= EXT4_MAP_MAPPED;
 	map->m_pblk = newblock;
 	map->m_len = allocated;
 out2:
-- 
1.7.5.1

