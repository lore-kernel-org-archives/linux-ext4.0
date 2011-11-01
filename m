From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH 1/8 bigalloc] ext4: get blocks from ext4_ext_get_actual_len
Date: Tue,  1 Nov 2011 18:53:30 +0800
Message-ID: <1320144817-16397-2-git-send-email-hao.bigrat@gmail.com>
References: <1320144817-16397-1-git-send-email-hao.bigrat@gmail.com>
Cc: Robin Dong <sanbai@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:52678 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362Ab1KAKxs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Nov 2011 06:53:48 -0400
Received: by pzk2 with SMTP id 2so1043603pzk.1
        for <linux-ext4@vger.kernel.org>; Tue, 01 Nov 2011 03:53:47 -0700 (PDT)
In-Reply-To: <1320144817-16397-1-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

Since ee_len's unit change to cluster, it need to transform from clusters
to blocks when use ext4_ext_get_actual_len.

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 fs/ext4/ext4_extents.h |    2 +-
 fs/ext4/extents.c      |  164 ++++++++++++++++++++++++++++--------------------
 2 files changed, 97 insertions(+), 69 deletions(-)

diff --git a/fs/ext4/ext4_extents.h b/fs/ext4/ext4_extents.h
index a52db3a..eb590fb 100644
--- a/fs/ext4/ext4_extents.h
+++ b/fs/ext4/ext4_extents.h
@@ -71,7 +71,7 @@
  */
 struct ext4_extent {
 	__le32	ee_block;	/* first logical block extent covers */
-	__le16	ee_len;		/* number of blocks covered by extent */
+	__le16	ee_len;		/* number of clusters covered by extent */
 	__le16	ee_start_hi;	/* high 16 bits of physical block */
 	__le32	ee_start_lo;	/* low 32 bits of physical block */
 };
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 4c38262..50f208e 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -303,8 +303,9 @@ ext4_ext_max_entries(struct inode *inode, int depth)
 
 static int ext4_valid_extent(struct inode *inode, struct ext4_extent *ext)
 {
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	ext4_fsblk_t block = ext4_ext_pblock(ext);
-	int len = ext4_ext_get_actual_len(ext);
+	int len = EXT4_C2B(sbi, ext4_ext_get_actual_len(ext));
 
 	return ext4_data_block_valid(EXT4_SB(inode->i_sb), block, len);
 }
@@ -406,6 +407,7 @@ int ext4_ext_check_inode(struct inode *inode)
 #ifdef EXT_DEBUG
 static void ext4_ext_show_path(struct inode *inode, struct ext4_ext_path *path)
 {
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	int k, l = path->p_depth;
 
 	ext_debug("path:");
@@ -415,10 +417,11 @@ static void ext4_ext_show_path(struct inode *inode, struct ext4_ext_path *path)
 			    ext4_idx_pblock(path->p_idx));
 		} else if (path->p_ext) {
 			ext_debug("  %d:[%d]%d:%llu ",
-				  le32_to_cpu(path->p_ext->ee_block),
-				  ext4_ext_is_uninitialized(path->p_ext),
-				  ext4_ext_get_actual_len(path->p_ext),
-				  ext4_ext_pblock(path->p_ext));
+				le32_to_cpu(path->p_ext->ee_block),
+				ext4_ext_is_uninitialized(path->p_ext),
+				EXT4_C2B(sbi,
+					ext4_ext_get_actual_len(path->p_ext)),
+				ext4_ext_pblock(path->p_ext));
 		} else
 			ext_debug("  []");
 	}
@@ -430,6 +433,7 @@ static void ext4_ext_show_leaf(struct inode *inode, struct ext4_ext_path *path)
 	int depth = ext_depth(inode);
 	struct ext4_extent_header *eh;
 	struct ext4_extent *ex;
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	int i;
 
 	if (!path)
@@ -443,7 +447,8 @@ static void ext4_ext_show_leaf(struct inode *inode, struct ext4_ext_path *path)
 	for (i = 0; i < le16_to_cpu(eh->eh_entries); i++, ex++) {
 		ext_debug("%d:[%d]%d:%llu ", le32_to_cpu(ex->ee_block),
 			  ext4_ext_is_uninitialized(ex),
-			  ext4_ext_get_actual_len(ex), ext4_ext_pblock(ex));
+			  EXT4_C2B(sbi, ext4_ext_get_actual_len(ex),
+				  ext4_ext_pblock(ex)));
 	}
 	ext_debug("\n");
 }
@@ -453,6 +458,7 @@ static void ext4_ext_show_move(struct inode *inode, struct ext4_ext_path *path,
 {
 	int depth = ext_depth(inode);
 	struct ext4_extent *ex;
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 
 	if (depth != level) {
 		struct ext4_extent_idx *idx;
@@ -474,7 +480,7 @@ static void ext4_ext_show_move(struct inode *inode, struct ext4_ext_path *path,
 				le32_to_cpu(ex->ee_block),
 				ext4_ext_pblock(ex),
 				ext4_ext_is_uninitialized(ex),
-				ext4_ext_get_actual_len(ex),
+				EXT4_C2B(sbi, ext4_ext_get_actual_len(ex)),
 				newblock);
 		ex++;
 	}
@@ -599,7 +605,8 @@ ext4_ext_binsearch(struct inode *inode,
 			le32_to_cpu(path->p_ext->ee_block),
 			ext4_ext_pblock(path->p_ext),
 			ext4_ext_is_uninitialized(path->p_ext),
-			ext4_ext_get_actual_len(path->p_ext));
+			EXT4_C2B(EXT4_SB(inode->i_sb),
+				ext4_ext_get_actual_len(path->p_ext)));
 
 #ifdef CHECK_BINSEARCH
 	{
@@ -1205,6 +1212,7 @@ static int ext4_ext_search_left(struct inode *inode,
 {
 	struct ext4_extent_idx *ix;
 	struct ext4_extent *ex;
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	int depth, ee_len;
 
 	if (unlikely(path == NULL)) {
@@ -1222,7 +1230,7 @@ static int ext4_ext_search_left(struct inode *inode,
 	 * first one in the file */
 
 	ex = path[depth].p_ext;
-	ee_len = ext4_ext_get_actual_len(ex);
+	ee_len = EXT4_C2B(sbi, ext4_ext_get_actual_len(ex));
 	if (*logical < le32_to_cpu(ex->ee_block)) {
 		if (unlikely(EXT_FIRST_EXTENT(path[depth].p_hdr) != ex)) {
 			EXT4_ERROR_INODE(inode,
@@ -1273,6 +1281,7 @@ static int ext4_ext_search_right(struct inode *inode,
 	struct ext4_extent_header *eh;
 	struct ext4_extent_idx *ix;
 	struct ext4_extent *ex;
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	ext4_fsblk_t block;
 	int depth;	/* Note, NOT eh_depth; depth from top of tree */
 	int ee_len;
@@ -1292,7 +1301,7 @@ static int ext4_ext_search_right(struct inode *inode,
 	 * first one in the file */
 
 	ex = path[depth].p_ext;
-	ee_len = ext4_ext_get_actual_len(ex);
+	ee_len = EXT4_C2B(sbi, ext4_ext_get_actual_len(ex));
 	if (*logical < le32_to_cpu(ex->ee_block)) {
 		if (unlikely(EXT_FIRST_EXTENT(path[depth].p_hdr) != ex)) {
 			EXT4_ERROR_INODE(inode,
@@ -1506,7 +1515,9 @@ int
 ext4_can_extents_be_merged(struct inode *inode, struct ext4_extent *ex1,
 				struct ext4_extent *ex2)
 {
-	unsigned short ext1_ee_len, ext2_ee_len, max_len;
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+	/* unit: cluster */
+	unsigned int ext1_ee_len, ext2_ee_len, max_len;
 
 	/*
 	 * Make sure that either both extents are uninitialized, or
@@ -1523,7 +1534,7 @@ ext4_can_extents_be_merged(struct inode *inode, struct ext4_extent *ex1,
 	ext1_ee_len = ext4_ext_get_actual_len(ex1);
 	ext2_ee_len = ext4_ext_get_actual_len(ex2);
 
-	if (le32_to_cpu(ex1->ee_block) + ext1_ee_len !=
+	if (le32_to_cpu(ex1->ee_block) + EXT4_C2B(sbi, ext1_ee_len) !=
 			le32_to_cpu(ex2->ee_block))
 		return 0;
 
@@ -1539,7 +1550,8 @@ ext4_can_extents_be_merged(struct inode *inode, struct ext4_extent *ex1,
 		return 0;
 #endif
 
-	if (ext4_ext_pblock(ex1) + ext1_ee_len == ext4_ext_pblock(ex2))
+	if (ext4_ext_pblock(ex1) + EXT4_C2B(sbi, ext1_ee_len) ==
+			ext4_ext_pblock(ex2))
 		return 1;
 	return 0;
 }
@@ -1633,7 +1645,7 @@ static unsigned int ext4_ext_check_overlap(struct ext4_sb_info *sbi,
 	unsigned int ret = 0;
 
 	b1 = le32_to_cpu(newext->ee_block);
-	len1 = ext4_ext_get_actual_len(newext);
+	len1 = EXT4_C2B(sbi, ext4_ext_get_actual_len(newext));
 	depth = ext_depth(inode);
 	if (!path[depth].p_ext)
 		goto out;
@@ -1654,13 +1666,13 @@ static unsigned int ext4_ext_check_overlap(struct ext4_sb_info *sbi,
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
@@ -1701,12 +1713,14 @@ int ext4_ext_insert_extent(handle_t *handle, struct inode *inode,
 	if (ex && !(flag & EXT4_GET_BLOCKS_PRE_IO)
 		&& ext4_can_extents_be_merged(inode, ex, newext)) {
 		ext_debug("append [%d]%d block to %d:[%d]%d (from %llu)\n",
-			  ext4_ext_is_uninitialized(newext),
-			  ext4_ext_get_actual_len(newext),
-			  le32_to_cpu(ex->ee_block),
-			  ext4_ext_is_uninitialized(ex),
-			  ext4_ext_get_actual_len(ex),
-			  ext4_ext_pblock(ex));
+			 ext4_ext_is_uninitialized(newext),
+			 EXT4_C2B(EXT4_SB(inode->i_sb),
+				 ext4_ext_get_actual_len(newext)),
+			 le32_to_cpu(ex->ee_block),
+			 ext4_ext_is_uninitialized(ex),
+			 EXT4_C2B(EXT4_SB(inode->i_sb),
+				 ext4_ext_get_actual_len(ex)),
+			 ext4_ext_pblock(ex));
 		err = ext4_ext_get_access(handle, inode, path + depth);
 		if (err)
 			return err;
@@ -1780,7 +1794,7 @@ has_space:
 				le32_to_cpu(newext->ee_block),
 				ext4_ext_pblock(newext),
 				ext4_ext_is_uninitialized(newext),
-				ext4_ext_get_actual_len(newext));
+				EXT4_C2B(sbi, ext4_ext_get_actual_len(newext)));
 		path[depth].p_ext = EXT_FIRST_EXTENT(eh);
 	} else if (le32_to_cpu(newext->ee_block)
 			   > le32_to_cpu(nearex->ee_block)) {
@@ -1791,11 +1805,11 @@ has_space:
 			len = len < 0 ? 0 : len;
 			ext_debug("insert %d:%llu:[%d]%d after: nearest 0x%p, "
 					"move %d from 0x%p to 0x%p\n",
-					le32_to_cpu(newext->ee_block),
-					ext4_ext_pblock(newext),
-					ext4_ext_is_uninitialized(newext),
-					ext4_ext_get_actual_len(newext),
-					nearex, len, nearex + 1, nearex + 2);
+				le32_to_cpu(newext->ee_block),
+				ext4_ext_pblock(newext),
+				ext4_ext_is_uninitialized(newext),
+				EXT4_C2B(sbi, ext4_ext_get_actual_len(newext)),
+				nearex, len, nearex + 1, nearex + 2);
 			memmove(nearex + 2, nearex + 1, len);
 		}
 		path[depth].p_ext = nearex + 1;
@@ -1808,7 +1822,7 @@ has_space:
 				le32_to_cpu(newext->ee_block),
 				ext4_ext_pblock(newext),
 				ext4_ext_is_uninitialized(newext),
-				ext4_ext_get_actual_len(newext),
+				EXT4_C2B(sbi, ext4_ext_get_actual_len(newext)),
 				nearex, len, nearex, nearex + 1);
 		memmove(nearex + 1, nearex, len);
 		path[depth].p_ext = nearex;
@@ -1850,6 +1864,7 @@ static int ext4_ext_walk_space(struct inode *inode, ext4_lblk_t block,
 	struct ext4_ext_path *path = NULL;
 	struct ext4_ext_cache cbex;
 	struct ext4_extent *ex;
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	ext4_lblk_t next, start = 0, end = 0;
 	ext4_lblk_t last = block + num;
 	int depth, exists, err = 0;
@@ -1891,7 +1906,7 @@ static int ext4_ext_walk_space(struct inode *inode, ext4_lblk_t block,
 			if (block + num < end)
 				end = block + num;
 		} else if (block >= le32_to_cpu(ex->ee_block)
-					+ ext4_ext_get_actual_len(ex)) {
+				+ EXT4_C2B(sbi, ext4_ext_get_actual_len(ex))) {
 			/* need to allocate space after found extent */
 			start = block;
 			end = block + num;
@@ -1904,7 +1919,7 @@ static int ext4_ext_walk_space(struct inode *inode, ext4_lblk_t block,
 			 */
 			start = block;
 			end = le32_to_cpu(ex->ee_block)
-				+ ext4_ext_get_actual_len(ex);
+				+ EXT4_C2B(sbi, ext4_ext_get_actual_len(ex));
 			if (block + num < end)
 				end = block + num;
 			exists = 1;
@@ -1915,7 +1930,7 @@ static int ext4_ext_walk_space(struct inode *inode, ext4_lblk_t block,
 
 		if (!exists) {
 			cbex.ec_block = start;
-			cbex.ec_len = end - start;
+			cbex.ec_len = EXT4_B2C(sbi, end - start);
 			cbex.ec_start = 0;
 		} else {
 			cbex.ec_block = le32_to_cpu(ex->ee_block);
@@ -1947,7 +1962,7 @@ static int ext4_ext_walk_space(struct inode *inode, ext4_lblk_t block,
 			path = NULL;
 		}
 
-		block = cbex.ec_block + cbex.ec_len;
+		block = cbex.ec_block + EXT4_C2B(sbi, cbex.ec_len);
 	}
 
 	if (path) {
@@ -1963,12 +1978,13 @@ ext4_ext_put_in_cache(struct inode *inode, ext4_lblk_t block,
 			__u32 len, ext4_fsblk_t start)
 {
 	struct ext4_ext_cache *cex;
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	BUG_ON(len == 0);
 	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
 	trace_ext4_ext_put_in_cache(inode, block, len, start);
 	cex = &EXT4_I(inode)->i_cached_extent;
 	cex->ec_block = block;
-	cex->ec_len = len;
+	cex->ec_len = EXT4_B2C(sbi, len);
 	cex->ec_start = start;
 	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 }
@@ -1986,6 +2002,7 @@ ext4_ext_put_gap_in_cache(struct inode *inode, struct ext4_ext_path *path,
 	unsigned long len;
 	ext4_lblk_t lblock;
 	struct ext4_extent *ex;
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 
 	ex = path[depth].p_ext;
 	if (ex == NULL) {
@@ -1999,17 +2016,17 @@ ext4_ext_put_gap_in_cache(struct inode *inode, struct ext4_ext_path *path,
 		ext_debug("cache gap(before): %u [%u:%u]",
 				block,
 				le32_to_cpu(ex->ee_block),
-				 ext4_ext_get_actual_len(ex));
+				EXT4_C2B(sbi, ext4_ext_get_actual_len(ex)));
 	} else if (block >= le32_to_cpu(ex->ee_block)
-			+ ext4_ext_get_actual_len(ex)) {
+			+ EXT4_C2B(sbi, ext4_ext_get_actual_len(ex))) {
 		ext4_lblk_t next;
 		lblock = le32_to_cpu(ex->ee_block)
-			+ ext4_ext_get_actual_len(ex);
+			+ EXT4_C2B(sbi, ext4_ext_get_actual_len(ex));
 
 		next = ext4_ext_next_allocated_block(path);
 		ext_debug("cache gap(after): [%u:%u] %u",
 				le32_to_cpu(ex->ee_block),
-				ext4_ext_get_actual_len(ex),
+				EXT4_C2B(sbi, ext4_ext_get_actual_len(ex)),
 				block);
 		BUG_ON(next == lblock);
 		len = next - lblock;
@@ -2055,11 +2072,12 @@ static int ext4_ext_check_cache(struct inode *inode, ext4_lblk_t block,
 	if (cex->ec_len == 0)
 		goto errout;
 
-	if (in_range(block, cex->ec_block, cex->ec_len)) {
+	if (in_range(block, cex->ec_block, EXT4_C2B(sbi, cex->ec_len))) {
 		memcpy(ex, cex, sizeof(struct ext4_ext_cache));
 		ext_debug("%u cached by %u:%u:%llu\n",
 				block,
-				cex->ec_block, cex->ec_len, cex->ec_start);
+				cex->ec_block, EXT4_C2B(sbi, cex->ec_len),
+				cex->ec_start);
 		ret = 1;
 	}
 errout:
@@ -2207,7 +2225,7 @@ static int ext4_remove_blocks(handle_t *handle, struct inode *inode,
 			      ext4_lblk_t from, ext4_lblk_t to)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
-	unsigned short ee_len =  ext4_ext_get_actual_len(ex);
+	unsigned int ee_len = EXT4_C2B(sbi, ext4_ext_get_actual_len(ex));
 	ext4_fsblk_t pblk;
 	int flags = EXT4_FREE_BLOCKS_FORGET;
 
@@ -2319,7 +2337,7 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
 	ext4_lblk_t a, b, block;
 	unsigned num;
 	ext4_lblk_t ex_ee_block;
-	unsigned short ex_ee_len;
+	unsigned int ex_ee_len;
 	unsigned uninitialized = 0;
 	struct ext4_extent *ex;
 	struct ext4_map_blocks map;
@@ -2337,7 +2355,7 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
 	ex = EXT_LAST_EXTENT(eh);
 
 	ex_ee_block = le32_to_cpu(ex->ee_block);
-	ex_ee_len = ext4_ext_get_actual_len(ex);
+	ex_ee_len = EXT4_C2B(sbi, ext4_ext_get_actual_len(ex));
 
 	trace_ext4_ext_rm_leaf(inode, start, ex_ee_block, ext4_ext_pblock(ex),
 			       ex_ee_len, *partial_cluster);
@@ -2364,7 +2382,7 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
 		if (end <= ex_ee_block) {
 			ex--;
 			ex_ee_block = le32_to_cpu(ex->ee_block);
-			ex_ee_len = ext4_ext_get_actual_len(ex);
+			ex_ee_len = EXT4_C2B(sbi, ext4_ext_get_actual_len(ex));
 			continue;
 		} else if (a != ex_ee_block &&
 			b != ex_ee_block + ex_ee_len - 1) {
@@ -2399,7 +2417,8 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
 				if (err < 0)
 					goto out;
 
-				ex_ee_len = ext4_ext_get_actual_len(ex);
+				ex_ee_len = EXT4_C2B(sbi,
+						ext4_ext_get_actual_len(ex));
 
 				b = ex_ee_block+ex_ee_len - 1 < end ?
 					ex_ee_block+ex_ee_len - 1 : end;
@@ -2485,7 +2504,7 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
 		}
 
 		ex->ee_block = cpu_to_le32(block);
-		ex->ee_len = cpu_to_le16(num);
+		ex->ee_len = cpu_to_le16(EXT4_B2C(sbi, num));
 		/*
 		 * Do not mark uninitialized if all the blocks in the
 		 * extent have been removed.
@@ -2523,7 +2542,7 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
 				ext4_ext_pblock(ex));
 		ex--;
 		ex_ee_block = le32_to_cpu(ex->ee_block);
-		ex_ee_len = ext4_ext_get_actual_len(ex);
+		ex_ee_len = EXT4_C2B(sbi, ext4_ext_get_actual_len(ex));
 	}
 
 	if (correct_index && eh->eh_entries)
@@ -2789,11 +2808,12 @@ void ext4_ext_release(struct super_block *sb)
 /* FIXME!! we need to try to merge to left or right after zero-out  */
 static int ext4_ext_zeroout(struct inode *inode, struct ext4_extent *ex)
 {
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	ext4_fsblk_t ee_pblock;
 	unsigned int ee_len;
 	int ret;
 
-	ee_len    = ext4_ext_get_actual_len(ex);
+	ee_len    = EXT4_C2B(sbi, ext4_ext_get_actual_len(ex));
 	ee_pblock = ext4_ext_pblock(ex);
 
 	ret = sb_issue_zeroout(inode->i_sb, ee_pblock, ee_len, GFP_NOFS);
@@ -2843,6 +2863,7 @@ static int ext4_split_extent_at(handle_t *handle,
 	ext4_lblk_t ee_block;
 	struct ext4_extent *ex, newex, orig_ex;
 	struct ext4_extent *ex2 = NULL;
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	unsigned int ee_len, depth;
 	int err = 0;
 
@@ -2854,7 +2875,7 @@ static int ext4_split_extent_at(handle_t *handle,
 	depth = ext_depth(inode);
 	ex = path[depth].p_ext;
 	ee_block = le32_to_cpu(ex->ee_block);
-	ee_len = ext4_ext_get_actual_len(ex);
+	ee_len = EXT4_C2B(sbi, ext4_ext_get_actual_len(ex));
 	newblock = split - ee_block + ext4_ext_pblock(ex);
 
 	BUG_ON(split < ee_block || split >= (ee_block + ee_len));
@@ -2883,7 +2904,7 @@ static int ext4_split_extent_at(handle_t *handle,
 
 	/* case a */
 	memcpy(&orig_ex, ex, sizeof(orig_ex));
-	ex->ee_len = cpu_to_le16(split - ee_block);
+	ex->ee_len = cpu_to_le16(EXT4_B2C(sbi, split - ee_block));
 	if (split_flag & EXT4_EXT_MARK_UNINIT1)
 		ext4_ext_mark_uninitialized(ex);
 
@@ -2897,7 +2918,7 @@ static int ext4_split_extent_at(handle_t *handle,
 
 	ex2 = &newex;
 	ex2->ee_block = cpu_to_le32(split);
-	ex2->ee_len   = cpu_to_le16(ee_len - (split - ee_block));
+	ex2->ee_len   = cpu_to_le16(EXT4_B2C(sbi, ee_len - (split - ee_block)));
 	ext4_ext_store_pblock(ex2, newblock);
 	if (split_flag & EXT4_EXT_MARK_UNINIT2)
 		ext4_ext_mark_uninitialized(ex2);
@@ -2908,7 +2929,7 @@ static int ext4_split_extent_at(handle_t *handle,
 		if (err)
 			goto fix_extent_len;
 		/* update the extent length and mark as initialized */
-		ex->ee_len = cpu_to_le32(ee_len);
+		ex->ee_len = cpu_to_le32(EXT4_B2C(sbi, ee_len));
 		ext4_ext_try_to_merge(inode, path, ex);
 		err = ext4_ext_dirty(handle, inode, path + depth);
 		goto out;
@@ -2945,6 +2966,7 @@ static int ext4_split_extent(handle_t *handle,
 {
 	ext4_lblk_t ee_block;
 	struct ext4_extent *ex;
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	unsigned int ee_len, depth;
 	int err = 0;
 	int uninitialized;
@@ -2953,7 +2975,7 @@ static int ext4_split_extent(handle_t *handle,
 	depth = ext_depth(inode);
 	ex = path[depth].p_ext;
 	ee_block = le32_to_cpu(ex->ee_block);
-	ee_len = ext4_ext_get_actual_len(ex);
+	ee_len = EXT4_C2B(sbi, ext4_ext_get_actual_len(ex));
 	uninitialized = ext4_ext_is_uninitialized(ex);
 
 	if (map->m_lblk + map->m_len < ee_block + ee_len) {
@@ -3011,6 +3033,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 	struct ext4_map_blocks split_map;
 	struct ext4_extent zero_ex;
 	struct ext4_extent *ex;
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	ext4_lblk_t ee_block, eof_block;
 	unsigned int allocated, ee_len, depth;
 	int err = 0;
@@ -3028,7 +3051,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 	depth = ext_depth(inode);
 	ex = path[depth].p_ext;
 	ee_block = le32_to_cpu(ex->ee_block);
-	ee_len = ext4_ext_get_actual_len(ex);
+	ee_len = EXT4_C2B(sbi, ext4_ext_get_actual_len(ex));
 	allocated = ee_len - (map->m_lblk - ee_block);
 
 	WARN_ON(map->m_lblk < ee_block);
@@ -3070,7 +3093,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 			/* case 3 */
 			zero_ex.ee_block =
 					 cpu_to_le32(map->m_lblk);
-			zero_ex.ee_len = cpu_to_le16(allocated);
+			zero_ex.ee_len = cpu_to_le16(EXT4_B2C(sbi, allocated));
 			ext4_ext_store_pblock(&zero_ex,
 				ext4_ext_pblock(ex) + map->m_lblk - ee_block);
 			err = ext4_ext_zeroout(inode, &zero_ex);
@@ -3084,8 +3107,8 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 			/* case 2 */
 			if (map->m_lblk != ee_block) {
 				zero_ex.ee_block = ex->ee_block;
-				zero_ex.ee_len = cpu_to_le16(map->m_lblk -
-							ee_block);
+				zero_ex.ee_len = cpu_to_le16(EXT4_B2C(sbi,
+						map->m_lblk - ee_block));
 				ext4_ext_store_pblock(&zero_ex,
 						      ext4_ext_pblock(ex));
 				err = ext4_ext_zeroout(inode, &zero_ex);
@@ -3139,6 +3162,7 @@ static int ext4_split_unwritten_extents(handle_t *handle,
 	ext4_lblk_t eof_block;
 	ext4_lblk_t ee_block;
 	struct ext4_extent *ex;
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	unsigned int ee_len;
 	int split_flag = 0, depth;
 
@@ -3157,7 +3181,7 @@ static int ext4_split_unwritten_extents(handle_t *handle,
 	depth = ext_depth(inode);
 	ex = path[depth].p_ext;
 	ee_block = le32_to_cpu(ex->ee_block);
-	ee_len = ext4_ext_get_actual_len(ex);
+	ee_len = EXT4_C2B(sbi, ext4_ext_get_actual_len(ex));
 
 	split_flag |= ee_block + ee_len <= eof_block ? EXT4_EXT_MAY_ZEROOUT : 0;
 	split_flag |= EXT4_EXT_MARK_UNINIT2;
@@ -3180,7 +3204,7 @@ static int ext4_convert_unwritten_extents_endio(handle_t *handle,
 	ext_debug("ext4_convert_unwritten_extents_endio: inode %lu, logical"
 		"block %llu, max_blocks %u\n", inode->i_ino,
 		(unsigned long long)le32_to_cpu(ex->ee_block),
-		ext4_ext_get_actual_len(ex));
+		EXT4_C2B(EXT4_SB(inode->i_sb), ext4_ext_get_actual_len(ex)));
 
 	err = ext4_ext_get_access(handle, inode, path + depth);
 	if (err)
@@ -3219,6 +3243,7 @@ static int check_eofblocks_fl(handle_t *handle, struct inode *inode,
 	int i, depth;
 	struct ext4_extent_header *eh;
 	struct ext4_extent *last_ex;
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 
 	if (!ext4_test_inode_flag(inode, EXT4_INODE_EOFBLOCKS))
 		return 0;
@@ -3242,7 +3267,7 @@ static int check_eofblocks_fl(handle_t *handle, struct inode *inode,
 	 * function immediately.
 	 */
 	if (lblk + len < le32_to_cpu(last_ex->ee_block) +
-	    ext4_ext_get_actual_len(last_ex))
+	    EXT4_C2B(sbi, ext4_ext_get_actual_len(last_ex)))
 		return 0;
 	/*
 	 * If the caller does appear to be planning to write at or
@@ -3645,7 +3670,7 @@ static int get_implied_cluster_alloc(struct super_block *sb,
 	ext4_lblk_t rr_cluster_start, rr_cluster_end;
 	ext4_lblk_t ee_block = le32_to_cpu(ex->ee_block);
 	ext4_fsblk_t ee_start = ext4_ext_pblock(ex);
-	unsigned short ee_len = ext4_ext_get_actual_len(ex);
+	unsigned int ee_len = EXT4_C2B(sbi, ext4_ext_get_actual_len(ex));
 
 	/* The extent passed in that we are trying to match */
 	ex_cluster_start = EXT4_B2C(sbi, ee_block);
@@ -3761,7 +3786,8 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 				   - le32_to_cpu(newex.ee_block)
 				   + ext4_ext_pblock(&newex);
 			/* number of remaining blocks in the extent */
-			allocated = ext4_ext_get_actual_len(&newex) -
+			allocated =
+				EXT4_C2B(sbi, ext4_ext_get_actual_len(&newex)) -
 				(map->m_lblk - le32_to_cpu(newex.ee_block));
 			goto out;
 		}
@@ -3796,13 +3822,13 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
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
+		ee_len = EXT4_C2B(sbi, ext4_ext_get_actual_len(ex));
 
 		trace_ext4_ext_show_extent(inode, ee_block, ee_start, ee_len);
 
@@ -3880,7 +3906,8 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 
 				depth = ext_depth(inode);
 				ex = path[depth].p_ext;
-				ee_len = ext4_ext_get_actual_len(ex);
+				ee_len = EXT4_C2B(sbi,
+						ext4_ext_get_actual_len(ex));
 				ee_block = le32_to_cpu(ex->ee_block);
 				ee_start = ext4_ext_pblock(ex);
 
@@ -3988,7 +4015,7 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 	newex.ee_len = cpu_to_le16(map->m_len);
 	err = ext4_ext_check_overlap(sbi, inode, &newex, path);
 	if (err)
-		allocated = ext4_ext_get_actual_len(&newex);
+		allocated = EXT4_C2B(sbi, ext4_ext_get_actual_len(&newex));
 	else
 		allocated = map->m_len;
 
@@ -4064,13 +4091,14 @@ got_allocated_blocks:
 		 * but otherwise we'd need to call it every free() */
 		ext4_discard_preallocations(inode);
 		ext4_free_blocks(handle, inode, NULL, ext4_ext_pblock(&newex),
-				 ext4_ext_get_actual_len(&newex), fb_flags);
+			EXT4_C2B(sbi, ext4_ext_get_actual_len(&newex)),
+			fb_flags);
 		goto out2;
 	}
 
 	/* previous routine could use block we allocated */
 	newblock = ext4_ext_pblock(&newex);
-	allocated = ext4_ext_get_actual_len(&newex);
+	allocated = EXT4_C2B(sbi, ext4_ext_get_actual_len(&newex));
 	if (allocated > map->m_len)
 		allocated = map->m_len;
 	map->m_flags |= EXT4_MAP_NEW;
-- 
1.7.3.2

