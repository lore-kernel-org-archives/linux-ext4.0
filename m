From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH 1/9 bigalloc] ext4: get blocks from ext4_ext_get_actual_blocks
Date: Wed,  9 Nov 2011 19:17:00 +0800
Message-ID: <1320837428-8516-2-git-send-email-hao.bigrat@gmail.com>
References: <1320837428-8516-1-git-send-email-hao.bigrat@gmail.com>
Cc: Robin Dong <sanbai@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56031 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab1KILR0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Nov 2011 06:17:26 -0500
Received: by yenr9 with SMTP id r9so558061yen.19
        for <linux-ext4@vger.kernel.org>; Wed, 09 Nov 2011 03:17:26 -0800 (PST)
In-Reply-To: <1320837428-8516-1-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

Since ee_len's unit change to cluster, it need to transform from clusters
to blocks when use new function: ext4_ext_get_actual_blocks.

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 fs/ext4/ext4.h         |    5 ++
 fs/ext4/ext4_extents.h |   16 ++++++-
 fs/ext4/extents.c      |  123 +++++++++++++++++++++++++++---------------------
 3 files changed, 88 insertions(+), 56 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index fba951b..1dea3e8 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -276,6 +276,11 @@ struct ext4_io_submit {
 /* Translate # of blks to # of clusters */
 #define EXT4_NUM_B2C(sbi, blks)	(((blks) + (sbi)->s_cluster_ratio - 1) >> \
 				 (sbi)->s_cluster_bits)
+/* Translate a block number to a cluster number by inode */
+#define EXT4_INODE_B2C(inode, block) (EXT4_B2C(EXT4_SB(inode->i_sb), (block)))
+/* Translate a cluster number to a block number by inode */
+#define EXT4_INODE_C2B(inode, cluster) (EXT4_C2B(EXT4_SB(inode->i_sb), \
+				(cluster)))
 
 /*
  * Structure of a blocks group descriptor
diff --git a/fs/ext4/ext4_extents.h b/fs/ext4/ext4_extents.h
index a52db3a..30c5ce1 100644
--- a/fs/ext4/ext4_extents.h
+++ b/fs/ext4/ext4_extents.h
@@ -70,8 +70,10 @@
  * It's used at the bottom of the tree.
  */
 struct ext4_extent {
-	__le32	ee_block;	/* first logical block extent covers */
-	__le16	ee_len;		/* number of blocks covered by extent */
+	__le32	ee_block;	/* first logical block (or cluster) *
+				 * extent covers */
+	__le16	ee_len;		/* number of blocks (or clusters) *
+				 * covered by extent */
 	__le16	ee_start_hi;	/* high 16 bits of physical block */
 	__le32	ee_start_lo;	/* low 32 bits of physical block */
 };
@@ -212,6 +214,16 @@ static inline int ext4_ext_is_uninitialized(struct ext4_extent *ext)
 	return (le16_to_cpu(ext->ee_len) > EXT_INIT_MAX_LEN);
 }
 
+static inline int ext4_ext_get_actual_blocks(struct ext4_extent *ext,
+		struct super_block *sb)
+{
+	int res = (le16_to_cpu(ext->ee_len) <= EXT_INIT_MAX_LEN ?
+		le16_to_cpu(ext->ee_len) :
+		(le16_to_cpu(ext->ee_len) - EXT_INIT_MAX_LEN));
+
+	return EXT4_C2B(EXT4_SB(sb), res);
+}
+
 static inline int ext4_ext_get_actual_len(struct ext4_extent *ext)
 {
 	return (le16_to_cpu(ext->ee_len) <= EXT_INIT_MAX_LEN ?
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 4c38262..597ebcb 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -304,7 +304,7 @@ ext4_ext_max_entries(struct inode *inode, int depth)
 static int ext4_valid_extent(struct inode *inode, struct ext4_extent *ext)
 {
 	ext4_fsblk_t block = ext4_ext_pblock(ext);
-	int len = ext4_ext_get_actual_len(ext);
+	int len = ext4_ext_get_actual_blocks(ext, inode->i_sb);
 
 	return ext4_data_block_valid(EXT4_SB(inode->i_sb), block, len);
 }
@@ -417,7 +417,8 @@ static void ext4_ext_show_path(struct inode *inode, struct ext4_ext_path *path)
 			ext_debug("  %d:[%d]%d:%llu ",
 				  le32_to_cpu(path->p_ext->ee_block),
 				  ext4_ext_is_uninitialized(path->p_ext),
-				  ext4_ext_get_actual_len(path->p_ext),
+				  ext4_ext_get_actual_blocks(path->p_ext,
+					  inode->i_sb),
 				  ext4_ext_pblock(path->p_ext));
 		} else
 			ext_debug("  []");
@@ -443,7 +444,8 @@ static void ext4_ext_show_leaf(struct inode *inode, struct ext4_ext_path *path)
 	for (i = 0; i < le16_to_cpu(eh->eh_entries); i++, ex++) {
 		ext_debug("%d:[%d]%d:%llu ", le32_to_cpu(ex->ee_block),
 			  ext4_ext_is_uninitialized(ex),
-			  ext4_ext_get_actual_len(ex), ext4_ext_pblock(ex));
+			  ext4_ext_get_actual_blocks(ex, inode->i_sb),
+			  ext4_ext_pblock(ex));
 	}
 	ext_debug("\n");
 }
@@ -474,7 +476,7 @@ static void ext4_ext_show_move(struct inode *inode, struct ext4_ext_path *path,
 				le32_to_cpu(ex->ee_block),
 				ext4_ext_pblock(ex),
 				ext4_ext_is_uninitialized(ex),
-				ext4_ext_get_actual_len(ex),
+				ext4_ext_get_actual_blocks(ex, inode->i_sb),
 				newblock);
 		ex++;
 	}
@@ -599,7 +601,7 @@ ext4_ext_binsearch(struct inode *inode,
 			le32_to_cpu(path->p_ext->ee_block),
 			ext4_ext_pblock(path->p_ext),
 			ext4_ext_is_uninitialized(path->p_ext),
-			ext4_ext_get_actual_len(path->p_ext));
+			ext4_ext_get_actual_blocks(path->p_ext, inode->i_sb));
 
 #ifdef CHECK_BINSEARCH
 	{
@@ -1222,7 +1224,7 @@ static int ext4_ext_search_left(struct inode *inode,
 	 * first one in the file */
 
 	ex = path[depth].p_ext;
-	ee_len = ext4_ext_get_actual_len(ex);
+	ee_len = ext4_ext_get_actual_blocks(ex, inode->i_sb);
 	if (*logical < le32_to_cpu(ex->ee_block)) {
 		if (unlikely(EXT_FIRST_EXTENT(path[depth].p_hdr) != ex)) {
 			EXT4_ERROR_INODE(inode,
@@ -1292,7 +1294,7 @@ static int ext4_ext_search_right(struct inode *inode,
 	 * first one in the file */
 
 	ex = path[depth].p_ext;
-	ee_len = ext4_ext_get_actual_len(ex);
+	ee_len = ext4_ext_get_actual_blocks(ex, inode->i_sb);
 	if (*logical < le32_to_cpu(ex->ee_block)) {
 		if (unlikely(EXT_FIRST_EXTENT(path[depth].p_hdr) != ex)) {
 			EXT4_ERROR_INODE(inode,
@@ -1506,7 +1508,8 @@ int
 ext4_can_extents_be_merged(struct inode *inode, struct ext4_extent *ex1,
 				struct ext4_extent *ex2)
 {
-	unsigned short ext1_ee_len, ext2_ee_len, max_len;
+	/* unit: cluster */
+	unsigned int ext1_ee_len, ext2_ee_len, max_len;
 
 	/*
 	 * Make sure that either both extents are uninitialized, or
@@ -1539,7 +1542,8 @@ ext4_can_extents_be_merged(struct inode *inode, struct ext4_extent *ex1,
 		return 0;
 #endif
 
-	if (ext4_ext_pblock(ex1) + ext1_ee_len == ext4_ext_pblock(ex2))
+	if (ext4_ext_pblock(ex1) + EXT4_INODE_C2B(inode, ext1_ee_len)
+			== ext4_ext_pblock(ex2))
 		return 1;
 	return 0;
 }
@@ -1633,7 +1637,7 @@ static unsigned int ext4_ext_check_overlap(struct ext4_sb_info *sbi,
 	unsigned int ret = 0;
 
 	b1 = le32_to_cpu(newext->ee_block);
-	len1 = ext4_ext_get_actual_len(newext);
+	len1 = ext4_ext_get_actual_blocks(newext, inode->i_sb);
 	depth = ext_depth(inode);
 	if (!path[depth].p_ext)
 		goto out;
@@ -1654,13 +1658,13 @@ static unsigned int ext4_ext_check_overlap(struct ext4_sb_info *sbi,
 	/* check for wrap through zero on extent logical start block*/
 	if (b1 + len1 < b1) {
 		len1 = EXT_MAX_BLOCKS - b1;
-		newext->ee_len = cpu_to_le16(len1);
+		newext->ee_len = cpu_to_le16(EXT4_B2C(sbi, len1));
 		ret = 1;
 	}
 
 	/* check for overlap */
 	if (b1 + len1 > b2) {
-		newext->ee_len = cpu_to_le16(b2 - b1);
+		newext->ee_len = cpu_to_le16(EXT4_B2C(sbi, b2 - b1));
 		ret = 1;
 	}
 out:
@@ -1702,10 +1706,10 @@ int ext4_ext_insert_extent(handle_t *handle, struct inode *inode,
 		&& ext4_can_extents_be_merged(inode, ex, newext)) {
 		ext_debug("append [%d]%d block to %d:[%d]%d (from %llu)\n",
 			  ext4_ext_is_uninitialized(newext),
-			  ext4_ext_get_actual_len(newext),
+			  ext4_ext_get_actual_blocks(newext, inode->i_sb),
 			  le32_to_cpu(ex->ee_block),
 			  ext4_ext_is_uninitialized(ex),
-			  ext4_ext_get_actual_len(ex),
+			  ext4_ext_get_actual_blocks(ex, inode->i_sb),
 			  ext4_ext_pblock(ex));
 		err = ext4_ext_get_access(handle, inode, path + depth);
 		if (err)
@@ -1780,7 +1784,8 @@ has_space:
 				le32_to_cpu(newext->ee_block),
 				ext4_ext_pblock(newext),
 				ext4_ext_is_uninitialized(newext),
-				ext4_ext_get_actual_len(newext));
+				ext4_ext_get_actual_blocks(newext,
+					inode->i_sb));
 		path[depth].p_ext = EXT_FIRST_EXTENT(eh);
 	} else if (le32_to_cpu(newext->ee_block)
 			   > le32_to_cpu(nearex->ee_block)) {
@@ -1794,7 +1799,8 @@ has_space:
 					le32_to_cpu(newext->ee_block),
 					ext4_ext_pblock(newext),
 					ext4_ext_is_uninitialized(newext),
-					ext4_ext_get_actual_len(newext),
+					ext4_ext_get_actual_blocks(newext,
+						inode->i_sb),
 					nearex, len, nearex + 1, nearex + 2);
 			memmove(nearex + 2, nearex + 1, len);
 		}
@@ -1808,7 +1814,8 @@ has_space:
 				le32_to_cpu(newext->ee_block),
 				ext4_ext_pblock(newext),
 				ext4_ext_is_uninitialized(newext),
-				ext4_ext_get_actual_len(newext),
+				ext4_ext_get_actual_blocks(newext,
+					inode->i_sb),
 				nearex, len, nearex, nearex + 1);
 		memmove(nearex + 1, nearex, len);
 		path[depth].p_ext = nearex;
@@ -1891,7 +1898,7 @@ static int ext4_ext_walk_space(struct inode *inode, ext4_lblk_t block,
 			if (block + num < end)
 				end = block + num;
 		} else if (block >= le32_to_cpu(ex->ee_block)
-					+ ext4_ext_get_actual_len(ex)) {
+			+ ext4_ext_get_actual_blocks(ex, inode->i_sb)) {
 			/* need to allocate space after found extent */
 			start = block;
 			end = block + num;
@@ -1904,7 +1911,7 @@ static int ext4_ext_walk_space(struct inode *inode, ext4_lblk_t block,
 			 */
 			start = block;
 			end = le32_to_cpu(ex->ee_block)
-				+ ext4_ext_get_actual_len(ex);
+				+ ext4_ext_get_actual_blocks(ex, inode->i_sb);
 			if (block + num < end)
 				end = block + num;
 			exists = 1;
@@ -1915,7 +1922,7 @@ static int ext4_ext_walk_space(struct inode *inode, ext4_lblk_t block,
 
 		if (!exists) {
 			cbex.ec_block = start;
-			cbex.ec_len = end - start;
+			cbex.ec_len = EXT4_INODE_B2C(inode, end - start);
 			cbex.ec_start = 0;
 		} else {
 			cbex.ec_block = le32_to_cpu(ex->ee_block);
@@ -1947,7 +1954,7 @@ static int ext4_ext_walk_space(struct inode *inode, ext4_lblk_t block,
 			path = NULL;
 		}
 
-		block = cbex.ec_block + cbex.ec_len;
+		block = cbex.ec_block + EXT4_INODE_C2B(inode, cbex.ec_len);
 	}
 
 	if (path) {
@@ -1968,7 +1975,7 @@ ext4_ext_put_in_cache(struct inode *inode, ext4_lblk_t block,
 	trace_ext4_ext_put_in_cache(inode, block, len, start);
 	cex = &EXT4_I(inode)->i_cached_extent;
 	cex->ec_block = block;
-	cex->ec_len = len;
+	cex->ec_len = EXT4_INODE_B2C(inode, len);
 	cex->ec_start = start;
 	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 }
@@ -1999,17 +2006,17 @@ ext4_ext_put_gap_in_cache(struct inode *inode, struct ext4_ext_path *path,
 		ext_debug("cache gap(before): %u [%u:%u]",
 				block,
 				le32_to_cpu(ex->ee_block),
-				 ext4_ext_get_actual_len(ex));
+				 ext4_ext_get_actual_blocks(ex, inode->i_sb));
 	} else if (block >= le32_to_cpu(ex->ee_block)
-			+ ext4_ext_get_actual_len(ex)) {
+			+ ext4_ext_get_actual_blocks(ex, inode->i_sb)) {
 		ext4_lblk_t next;
 		lblock = le32_to_cpu(ex->ee_block)
-			+ ext4_ext_get_actual_len(ex);
+			+ ext4_ext_get_actual_blocks(ex, inode->i_sb);
 
 		next = ext4_ext_next_allocated_block(path);
 		ext_debug("cache gap(after): [%u:%u] %u",
 				le32_to_cpu(ex->ee_block),
-				ext4_ext_get_actual_len(ex),
+				ext4_ext_get_actual_blocks(ex, inode->i_sb),
 				block);
 		BUG_ON(next == lblock);
 		len = next - lblock;
@@ -2207,7 +2214,7 @@ static int ext4_remove_blocks(handle_t *handle, struct inode *inode,
 			      ext4_lblk_t from, ext4_lblk_t to)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
-	unsigned short ee_len =  ext4_ext_get_actual_len(ex);
+	unsigned int ee_len =  ext4_ext_get_actual_blocks(ex, inode->i_sb);
 	ext4_fsblk_t pblk;
 	int flags = EXT4_FREE_BLOCKS_FORGET;
 
@@ -2319,7 +2326,7 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
 	ext4_lblk_t a, b, block;
 	unsigned num;
 	ext4_lblk_t ex_ee_block;
-	unsigned short ex_ee_len;
+	unsigned int ex_ee_len;
 	unsigned uninitialized = 0;
 	struct ext4_extent *ex;
 	struct ext4_map_blocks map;
@@ -2337,7 +2344,7 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
 	ex = EXT_LAST_EXTENT(eh);
 
 	ex_ee_block = le32_to_cpu(ex->ee_block);
-	ex_ee_len = ext4_ext_get_actual_len(ex);
+	ex_ee_len = ext4_ext_get_actual_blocks(ex, inode->i_sb);
 
 	trace_ext4_ext_rm_leaf(inode, start, ex_ee_block, ext4_ext_pblock(ex),
 			       ex_ee_len, *partial_cluster);
@@ -2364,7 +2371,8 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
 		if (end <= ex_ee_block) {
 			ex--;
 			ex_ee_block = le32_to_cpu(ex->ee_block);
-			ex_ee_len = ext4_ext_get_actual_len(ex);
+			ex_ee_len = ext4_ext_get_actual_blocks(ex,
+					inode->i_sb);
 			continue;
 		} else if (a != ex_ee_block &&
 			b != ex_ee_block + ex_ee_len - 1) {
@@ -2399,7 +2407,8 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
 				if (err < 0)
 					goto out;
 
-				ex_ee_len = ext4_ext_get_actual_len(ex);
+				ex_ee_len = ext4_ext_get_actual_blocks(ex,
+						inode->i_sb);
 
 				b = ex_ee_block+ex_ee_len - 1 < end ?
 					ex_ee_block+ex_ee_len - 1 : end;
@@ -2485,7 +2494,7 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
 		}
 
 		ex->ee_block = cpu_to_le32(block);
-		ex->ee_len = cpu_to_le16(num);
+		ex->ee_len = cpu_to_le16(EXT4_B2C(sbi, num));
 		/*
 		 * Do not mark uninitialized if all the blocks in the
 		 * extent have been removed.
@@ -2523,7 +2532,7 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
 				ext4_ext_pblock(ex));
 		ex--;
 		ex_ee_block = le32_to_cpu(ex->ee_block);
-		ex_ee_len = ext4_ext_get_actual_len(ex);
+		ex_ee_len = ext4_ext_get_actual_blocks(ex, inode->i_sb);
 	}
 
 	if (correct_index && eh->eh_entries)
@@ -2706,7 +2715,7 @@ again:
 			flags |= EXT4_FREE_BLOCKS_METADATA;
 
 		ext4_free_blocks(handle, inode, NULL,
-				 EXT4_C2B(EXT4_SB(sb), partial_cluster),
+				 EXT4_INODE_C2B(inode, partial_cluster),
 				 EXT4_SB(sb)->s_cluster_ratio, flags);
 		partial_cluster = 0;
 	}
@@ -2793,7 +2802,7 @@ static int ext4_ext_zeroout(struct inode *inode, struct ext4_extent *ex)
 	unsigned int ee_len;
 	int ret;
 
-	ee_len    = ext4_ext_get_actual_len(ex);
+	ee_len    = ext4_ext_get_actual_blocks(ex, inode->i_sb);
 	ee_pblock = ext4_ext_pblock(ex);
 
 	ret = sb_issue_zeroout(inode->i_sb, ee_pblock, ee_len, GFP_NOFS);
@@ -2854,7 +2863,7 @@ static int ext4_split_extent_at(handle_t *handle,
 	depth = ext_depth(inode);
 	ex = path[depth].p_ext;
 	ee_block = le32_to_cpu(ex->ee_block);
-	ee_len = ext4_ext_get_actual_len(ex);
+	ee_len = ext4_ext_get_actual_blocks(ex, inode->i_sb);
 	newblock = split - ee_block + ext4_ext_pblock(ex);
 
 	BUG_ON(split < ee_block || split >= (ee_block + ee_len));
@@ -2883,7 +2892,7 @@ static int ext4_split_extent_at(handle_t *handle,
 
 	/* case a */
 	memcpy(&orig_ex, ex, sizeof(orig_ex));
-	ex->ee_len = cpu_to_le16(split - ee_block);
+	ex->ee_len = cpu_to_le16(EXT4_INODE_B2C(inode, split - ee_block));
 	if (split_flag & EXT4_EXT_MARK_UNINIT1)
 		ext4_ext_mark_uninitialized(ex);
 
@@ -2897,7 +2906,8 @@ static int ext4_split_extent_at(handle_t *handle,
 
 	ex2 = &newex;
 	ex2->ee_block = cpu_to_le32(split);
-	ex2->ee_len   = cpu_to_le16(ee_len - (split - ee_block));
+	ex2->ee_len   = cpu_to_le16(
+			EXT4_INODE_B2C(inode, ee_len - (split - ee_block)));
 	ext4_ext_store_pblock(ex2, newblock);
 	if (split_flag & EXT4_EXT_MARK_UNINIT2)
 		ext4_ext_mark_uninitialized(ex2);
@@ -2908,7 +2918,7 @@ static int ext4_split_extent_at(handle_t *handle,
 		if (err)
 			goto fix_extent_len;
 		/* update the extent length and mark as initialized */
-		ex->ee_len = cpu_to_le32(ee_len);
+		ex->ee_len = cpu_to_le32(EXT4_INODE_B2C(inode, ee_len));
 		ext4_ext_try_to_merge(inode, path, ex);
 		err = ext4_ext_dirty(handle, inode, path + depth);
 		goto out;
@@ -2953,7 +2963,7 @@ static int ext4_split_extent(handle_t *handle,
 	depth = ext_depth(inode);
 	ex = path[depth].p_ext;
 	ee_block = le32_to_cpu(ex->ee_block);
-	ee_len = ext4_ext_get_actual_len(ex);
+	ee_len = ext4_ext_get_actual_blocks(ex, inode->i_sb);
 	uninitialized = ext4_ext_is_uninitialized(ex);
 
 	if (map->m_lblk + map->m_len < ee_block + ee_len) {
@@ -3028,7 +3038,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 	depth = ext_depth(inode);
 	ex = path[depth].p_ext;
 	ee_block = le32_to_cpu(ex->ee_block);
-	ee_len = ext4_ext_get_actual_len(ex);
+	ee_len = ext4_ext_get_actual_blocks(ex, inode->i_sb);
 	allocated = ee_len - (map->m_lblk - ee_block);
 
 	WARN_ON(map->m_lblk < ee_block);
@@ -3070,7 +3080,8 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 			/* case 3 */
 			zero_ex.ee_block =
 					 cpu_to_le32(map->m_lblk);
-			zero_ex.ee_len = cpu_to_le16(allocated);
+			zero_ex.ee_len = cpu_to_le16(
+					EXT4_INODE_B2C(inode, allocated));
 			ext4_ext_store_pblock(&zero_ex,
 				ext4_ext_pblock(ex) + map->m_lblk - ee_block);
 			err = ext4_ext_zeroout(inode, &zero_ex);
@@ -3084,8 +3095,9 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 			/* case 2 */
 			if (map->m_lblk != ee_block) {
 				zero_ex.ee_block = ex->ee_block;
-				zero_ex.ee_len = cpu_to_le16(map->m_lblk -
-							ee_block);
+				zero_ex.ee_len =
+					cpu_to_le16(EXT4_INODE_B2C(inode,
+					map->m_lblk - ee_block));
 				ext4_ext_store_pblock(&zero_ex,
 						      ext4_ext_pblock(ex));
 				err = ext4_ext_zeroout(inode, &zero_ex);
@@ -3157,7 +3169,7 @@ static int ext4_split_unwritten_extents(handle_t *handle,
 	depth = ext_depth(inode);
 	ex = path[depth].p_ext;
 	ee_block = le32_to_cpu(ex->ee_block);
-	ee_len = ext4_ext_get_actual_len(ex);
+	ee_len = ext4_ext_get_actual_blocks(ex, inode->i_sb);
 
 	split_flag |= ee_block + ee_len <= eof_block ? EXT4_EXT_MAY_ZEROOUT : 0;
 	split_flag |= EXT4_EXT_MARK_UNINIT2;
@@ -3180,7 +3192,7 @@ static int ext4_convert_unwritten_extents_endio(handle_t *handle,
 	ext_debug("ext4_convert_unwritten_extents_endio: inode %lu, logical"
 		"block %llu, max_blocks %u\n", inode->i_ino,
 		(unsigned long long)le32_to_cpu(ex->ee_block),
-		ext4_ext_get_actual_len(ex));
+		ext4_ext_get_actual_blocks(ex, inode->i_sb));
 
 	err = ext4_ext_get_access(handle, inode, path + depth);
 	if (err)
@@ -3242,7 +3254,7 @@ static int check_eofblocks_fl(handle_t *handle, struct inode *inode,
 	 * function immediately.
 	 */
 	if (lblk + len < le32_to_cpu(last_ex->ee_block) +
-	    ext4_ext_get_actual_len(last_ex))
+	    ext4_ext_get_actual_blocks(last_ex, inode->i_sb))
 		return 0;
 	/*
 	 * If the caller does appear to be planning to write at or
@@ -3645,7 +3657,7 @@ static int get_implied_cluster_alloc(struct super_block *sb,
 	ext4_lblk_t rr_cluster_start, rr_cluster_end;
 	ext4_lblk_t ee_block = le32_to_cpu(ex->ee_block);
 	ext4_fsblk_t ee_start = ext4_ext_pblock(ex);
-	unsigned short ee_len = ext4_ext_get_actual_len(ex);
+	unsigned int ee_len = ext4_ext_get_actual_blocks(ex, sb);
 
 	/* The extent passed in that we are trying to match */
 	ex_cluster_start = EXT4_B2C(sbi, ee_block);
@@ -3761,7 +3773,8 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 				   - le32_to_cpu(newex.ee_block)
 				   + ext4_ext_pblock(&newex);
 			/* number of remaining blocks in the extent */
-			allocated = ext4_ext_get_actual_len(&newex) -
+			allocated = ext4_ext_get_actual_blocks(&newex,
+				inode->i_sb) -
 				(map->m_lblk - le32_to_cpu(newex.ee_block));
 			goto out;
 		}
@@ -3796,13 +3809,13 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 		ext4_lblk_t ee_block = le32_to_cpu(ex->ee_block);
 		ext4_fsblk_t ee_start = ext4_ext_pblock(ex);
 		ext4_fsblk_t partial_cluster = 0;
-		unsigned short ee_len;
+		unsigned int ee_len;
 
 		/*
 		 * Uninitialized extents are treated as holes, except that
 		 * we split out initialized portions during a write.
 		 */
-		ee_len = ext4_ext_get_actual_len(ex);
+		ee_len = ext4_ext_get_actual_blocks(ex, inode->i_sb);
 
 		trace_ext4_ext_show_extent(inode, ee_block, ee_start, ee_len);
 
@@ -3880,7 +3893,8 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 
 				depth = ext_depth(inode);
 				ex = path[depth].p_ext;
-				ee_len = ext4_ext_get_actual_len(ex);
+				ee_len = ext4_ext_get_actual_blocks(ex,
+						inode->i_sb);
 				ee_block = le32_to_cpu(ex->ee_block);
 				ee_start = ext4_ext_pblock(ex);
 
@@ -4064,13 +4078,14 @@ got_allocated_blocks:
 		 * but otherwise we'd need to call it every free() */
 		ext4_discard_preallocations(inode);
 		ext4_free_blocks(handle, inode, NULL, ext4_ext_pblock(&newex),
-				 ext4_ext_get_actual_len(&newex), fb_flags);
+				ext4_ext_get_actual_blocks(&newex, inode->i_sb),
+				fb_flags);
 		goto out2;
 	}
 
 	/* previous routine could use block we allocated */
 	newblock = ext4_ext_pblock(&newex);
-	allocated = ext4_ext_get_actual_len(&newex);
+	allocated = ext4_ext_get_actual_blocks(&newex, inode->i_sb);
 	if (allocated > map->m_len)
 		allocated = map->m_len;
 	map->m_flags |= EXT4_MAP_NEW;
-- 
1.7.3.2

