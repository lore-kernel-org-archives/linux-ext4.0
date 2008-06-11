From: Shen Feng <shen@cn.fujitsu.com>
Subject: [PATCH 1/2] ext4: add ext4_ prefix for ext_block and idx_pblock
Date: Wed, 11 Jun 2008 13:52:31 +0800
Message-ID: <484F681F.2050300@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, Mingming Cao <cmm@us.ibm.com>,
	Theodore Tso <tytso@MIT.EDU>,
	Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:50568 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752085AbYFKF4C (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Jun 2008 01:56:02 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Rename functions ext_block to ext4_ext_block and
idx_pblock to ext4_idx_pblock since ext_block &
ext4_ext_store_pblock are a pair and idx_pblock &
ext4_idx_store_pblock are a pair.

idx_pblock is a non-static function, too.

Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
---
 fs/ext4/ext4_extents.h |    2 +-
 fs/ext4/extents.c      |   93 +++++++++++++++++++++++++-----------------------
 fs/ext4/migrate.c      |    2 +-
 3 files changed, 50 insertions(+), 47 deletions(-)

diff --git a/fs/ext4/ext4_extents.h b/fs/ext4/ext4_extents.h
index 4010d5e..7fd211b 100644
--- a/fs/ext4/ext4_extents.h
+++ b/fs/ext4/ext4_extents.h
@@ -212,7 +212,7 @@ static inline int ext4_ext_get_actual_len(struct ext4_extent *ext)
 		(le16_to_cpu(ext->ee_len) - EXT_INIT_MAX_LEN));
 }
 
-extern ext4_fsblk_t idx_pblock(struct ext4_extent_idx *);
+extern ext4_fsblk_t ext4_idx_pblock(struct ext4_extent_idx *);
 extern void ext4_ext_store_pblock(struct ext4_extent *, ext4_fsblk_t);
 extern int ext4_ext_calc_credits_for_insert(struct inode *, struct ext4_ext_path *);
 extern int ext4_ext_try_to_merge(struct inode *inode,
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 47929c4..fa8a578 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -45,10 +45,10 @@
 
 
 /*
- * ext_pblock:
+ * ext4_ext_pblock:
  * combine low and high parts of physical block number into ext4_fsblk_t
  */
-static ext4_fsblk_t ext_pblock(struct ext4_extent *ex)
+static ext4_fsblk_t ext4_ext_pblock(struct ext4_extent *ex)
 {
 	ext4_fsblk_t block;
 
@@ -58,10 +58,10 @@ static ext4_fsblk_t ext_pblock(struct ext4_extent *ex)
 }
 
 /*
- * idx_pblock:
+ * ext4_idx_pblock:
  * combine low and high parts of a leaf physical block number into ext4_fsblk_t
  */
-ext4_fsblk_t idx_pblock(struct ext4_extent_idx *ix)
+ext4_fsblk_t ext4_idx_pblock(struct ext4_extent_idx *ix)
 {
 	ext4_fsblk_t block;
 
@@ -159,7 +159,8 @@ static ext4_fsblk_t ext4_ext_find_goal(struct inode *inode,
 		/* try to predict block placement */
 		ex = path[depth].p_ext;
 		if (ex)
-			return ext_pblock(ex)+(block-le32_to_cpu(ex->ee_block));
+			return ext4_ext_pblock(ex)
+				+(block-le32_to_cpu(ex->ee_block));
 
 		/* it looks like index is empty;
 		 * try to find starting block from index itself */
@@ -319,12 +320,12 @@ static void ext4_ext_show_path(struct inode *inode, struct ext4_ext_path *path)
 	for (k = 0; k <= l; k++, path++) {
 		if (path->p_idx) {
 		  ext_debug("  %d->%llu", le32_to_cpu(path->p_idx->ei_block),
-			    idx_pblock(path->p_idx));
+			    ext4_idx_pblock(path->p_idx));
 		} else if (path->p_ext) {
 			ext_debug("  %d:%d:%llu ",
 				  le32_to_cpu(path->p_ext->ee_block),
 				  ext4_ext_get_actual_len(path->p_ext),
-				  ext_pblock(path->p_ext));
+				  ext4_ext_pblock(path->p_ext));
 		} else
 			ext_debug("  []");
 	}
@@ -346,7 +347,7 @@ static void ext4_ext_show_leaf(struct inode *inode, struct ext4_ext_path *path)
 
 	for (i = 0; i < le16_to_cpu(eh->eh_entries); i++, ex++) {
 		ext_debug("%d:%d:%llu ", le32_to_cpu(ex->ee_block),
-			  ext4_ext_get_actual_len(ex), ext_pblock(ex));
+			  ext4_ext_get_actual_len(ex), ext4_ext_pblock(ex));
 	}
 	ext_debug("\n");
 }
@@ -397,7 +398,7 @@ ext4_ext_binsearch_idx(struct inode *inode,
 
 	path->p_idx = l - 1;
 	ext_debug("  -> %d->%lld ", le32_to_cpu(path->p_idx->ei_block),
-		  idx_pblock(path->p_idx));
+		  ext4_idx_pblock(path->p_idx));
 
 #ifdef CHECK_BINSEARCH
 	{
@@ -465,7 +466,7 @@ ext4_ext_binsearch(struct inode *inode,
 	path->p_ext = l - 1;
 	ext_debug("  -> %d:%llu:%d ",
 			le32_to_cpu(path->p_ext->ee_block),
-			ext_pblock(path->p_ext),
+			ext4_ext_pblock(path->p_ext),
 			ext4_ext_get_actual_len(path->p_ext));
 
 #ifdef CHECK_BINSEARCH
@@ -532,7 +533,7 @@ ext4_ext_find_extent(struct inode *inode, ext4_lblk_t block,
 			  ppos, le16_to_cpu(eh->eh_entries), le16_to_cpu(eh->eh_max));
 
 		ext4_ext_binsearch_idx(inode, path + ppos, block);
-		path[ppos].p_block = idx_pblock(path[ppos].p_idx);
+		path[ppos].p_block = ext4_idx_pblock(path[ppos].p_idx);
 		path[ppos].p_depth = i;
 		path[ppos].p_ext = NULL;
 
@@ -725,7 +726,7 @@ static int ext4_ext_split(handle_t *handle, struct inode *inode,
 			EXT_MAX_EXTENT(path[depth].p_hdr)) {
 		ext_debug("move %d:%llu:%d in new leaf %llu\n",
 				le32_to_cpu(path[depth].p_ext->ee_block),
-				ext_pblock(path[depth].p_ext),
+				ext4_ext_pblock(path[depth].p_ext),
 				ext4_ext_get_actual_len(path[depth].p_ext),
 				newblock);
 		/*memmove(ex++, path[depth].p_ext++,
@@ -804,7 +805,7 @@ static int ext4_ext_split(handle_t *handle, struct inode *inode,
 		while (path[i].p_idx <= EXT_MAX_INDEX(path[i].p_hdr)) {
 			ext_debug("%d: move %d:%llu in new index %llu\n", i,
 					le32_to_cpu(path[i].p_idx->ei_block),
-					idx_pblock(path[i].p_idx),
+					ext4_idx_pblock(path[i].p_idx),
 					newblock);
 			/*memmove(++fidx, path[i].p_idx++,
 					sizeof(struct ext4_extent_idx));
@@ -943,7 +944,7 @@ static int ext4_ext_grow_indepth(handle_t *handle, struct inode *inode,
 	fidx = EXT_FIRST_INDEX(neh);
 	ext_debug("new root: num %d(%d), lblock %d, ptr %llu\n",
 		  le16_to_cpu(neh->eh_entries), le16_to_cpu(neh->eh_max),
-		  le32_to_cpu(fidx->ei_block), idx_pblock(fidx));
+		  le32_to_cpu(fidx->ei_block), ext4_idx_pblock(fidx));
 
 	neh->eh_depth = cpu_to_le16(path->p_depth + 1);
 	err = ext4_ext_dirty(handle, inode, curp);
@@ -1060,7 +1061,7 @@ ext4_ext_search_left(struct inode *inode, struct ext4_ext_path *path,
 	BUG_ON(*logical < (le32_to_cpu(ex->ee_block) + ee_len));
 
 	*logical = le32_to_cpu(ex->ee_block) + ee_len - 1;
-	*phys = ext_pblock(ex) + ee_len - 1;
+	*phys = ext4_ext_pblock(ex) + ee_len - 1;
 	return 0;
 }
 
@@ -1102,7 +1103,7 @@ ext4_ext_search_right(struct inode *inode, struct ext4_ext_path *path,
 			BUG_ON(ix != EXT_FIRST_INDEX(path[depth].p_hdr));
 		}
 		*logical = le32_to_cpu(ex->ee_block);
-		*phys = ext_pblock(ex);
+		*phys = ext4_ext_pblock(ex);
 		return 0;
 	}
 
@@ -1112,7 +1113,7 @@ ext4_ext_search_right(struct inode *inode, struct ext4_ext_path *path,
 		/* next allocated block in this leaf */
 		ex++;
 		*logical = le32_to_cpu(ex->ee_block);
-		*phys = ext_pblock(ex);
+		*phys = ext4_ext_pblock(ex);
 		return 0;
 	}
 
@@ -1133,7 +1134,7 @@ ext4_ext_search_right(struct inode *inode, struct ext4_ext_path *path,
 	 * follow it and find the closest allocated
 	 * block to the right */
 	ix++;
-	block = idx_pblock(ix);
+	block = ext4_idx_pblock(ix);
 	while (++depth < path->p_depth) {
 		bh = sb_bread(inode->i_sb, block);
 		if (bh == NULL)
@@ -1144,7 +1145,7 @@ ext4_ext_search_right(struct inode *inode, struct ext4_ext_path *path,
 			return -EIO;
 		}
 		ix = EXT_FIRST_INDEX(eh);
-		block = idx_pblock(ix);
+		block = ext4_idx_pblock(ix);
 		put_bh(bh);
 	}
 
@@ -1158,7 +1159,7 @@ ext4_ext_search_right(struct inode *inode, struct ext4_ext_path *path,
 	}
 	ex = EXT_FIRST_EXTENT(eh);
 	*logical = le32_to_cpu(ex->ee_block);
-	*phys = ext_pblock(ex);
+	*phys = ext4_ext_pblock(ex);
 	put_bh(bh);
 	return 0;
 
@@ -1326,7 +1327,7 @@ ext4_can_extents_be_merged(struct inode *inode, struct ext4_extent *ex1,
 		return 0;
 #endif
 
-	if (ext_pblock(ex1) + ext1_ee_len == ext_pblock(ex2))
+	if (ext4_ext_pblock(ex1) + ext1_ee_len == ext4_ext_pblock(ex2))
 		return 1;
 	return 0;
 }
@@ -1455,7 +1456,8 @@ int ext4_ext_insert_extent(handle_t *handle, struct inode *inode,
 		ext_debug("append %d block to %d:%d (from %llu)\n",
 				ext4_ext_get_actual_len(newext),
 				le32_to_cpu(ex->ee_block),
-				ext4_ext_get_actual_len(ex), ext_pblock(ex));
+				ext4_ext_get_actual_len(ex),
+				ext4_ext_pblock(ex));
 		err = ext4_ext_get_access(handle, inode, path + depth);
 		if (err)
 			return err;
@@ -1525,7 +1527,7 @@ has_space:
 		/* there is no extent in this leaf, create first one */
 		ext_debug("first extent in the leaf: %d:%llu:%d\n",
 				le32_to_cpu(newext->ee_block),
-				ext_pblock(newext),
+				ext4_ext_pblock(newext),
 				ext4_ext_get_actual_len(newext));
 		path[depth].p_ext = EXT_FIRST_EXTENT(eh);
 	} else if (le32_to_cpu(newext->ee_block)
@@ -1538,7 +1540,7 @@ has_space:
 			ext_debug("insert %d:%llu:%d after: nearest 0x%p, "
 					"move %d from 0x%p to 0x%p\n",
 					le32_to_cpu(newext->ee_block),
-					ext_pblock(newext),
+					ext4_ext_pblock(newext),
 					ext4_ext_get_actual_len(newext),
 					nearex, len, nearex + 1, nearex + 2);
 			memmove(nearex + 2, nearex + 1, len);
@@ -1551,7 +1553,7 @@ has_space:
 		ext_debug("insert %d:%llu:%d before: nearest 0x%p, "
 				"move %d from 0x%p to 0x%p\n",
 				le32_to_cpu(newext->ee_block),
-				ext_pblock(newext),
+				ext4_ext_pblock(newext),
 				ext4_ext_get_actual_len(newext),
 				nearex, len, nearex + 1, nearex + 2);
 		memmove(nearex + 1, nearex, len);
@@ -1561,7 +1563,7 @@ has_space:
 	le16_add_cpu(&eh->eh_entries, 1);
 	nearex = path[depth].p_ext;
 	nearex->ee_block = newext->ee_block;
-	ext4_ext_store_pblock(nearex, ext_pblock(newext));
+	ext4_ext_store_pblock(nearex, ext4_ext_pblock(newext));
 	nearex->ee_len = newext->ee_len;
 
 merge:
@@ -1692,7 +1694,7 @@ static int ext4_ext_rm_idx(handle_t *handle, struct inode *inode,
 
 	/* free index block */
 	path--;
-	leaf = idx_pblock(path->p_idx);
+	leaf = ext4_idx_pblock(path->p_idx);
 	BUG_ON(path->p_hdr->eh_entries == 0);
 	err = ext4_ext_get_access(handle, inode, path);
 	if (err)
@@ -1791,7 +1793,7 @@ static int ext4_remove_blocks(handle_t *handle, struct inode *inode,
 		ext4_fsblk_t start;
 
 		num = le32_to_cpu(ex->ee_block) + ee_len - from;
-		start = ext_pblock(ex) + ee_len - num;
+		start = ext4_ext_pblock(ex) + ee_len - num;
 		ext_debug("free last %u blocks starting %llu\n", num, start);
 		for (i = 0; i < num; i++) {
 			bh = sb_find_get_block(inode->i_sb, start + i);
@@ -1917,7 +1919,7 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
 			goto out;
 
 		ext_debug("new extent: %u:%u:%llu\n", block, num,
-				ext_pblock(ex));
+				ext4_ext_pblock(ex));
 		ex--;
 		ex_ee_block = le32_to_cpu(ex->ee_block);
 		ex_ee_len = ext4_ext_get_actual_len(ex);
@@ -2025,9 +2027,9 @@ static int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start)
 			struct buffer_head *bh;
 			/* go to the next level */
 			ext_debug("move to level %d (block %llu)\n",
-				  i + 1, idx_pblock(path[i].p_idx));
+				  i + 1, ext4_idx_pblock(path[i].p_idx));
 			memset(path + i + 1, 0, sizeof(*path));
-			bh = sb_bread(sb, idx_pblock(path[i].p_idx));
+			bh = sb_bread(sb, ext4_idx_pblock(path[i].p_idx));
 			if (!bh) {
 				/* should we reset i_size? */
 				err = -EIO;
@@ -2155,7 +2157,7 @@ static int ext4_ext_zeroout(struct inode *inode, struct ext4_extent *ex)
 	blkbits   = inode->i_blkbits;
 	blocksize = inode->i_sb->s_blocksize;
 	ee_len    = ext4_ext_get_actual_len(ex);
-	ee_pblock = ext_pblock(ex);
+	ee_pblock = ext4_ext_pblock(ex);
 
 	/* convert ee_pblock to 512 byte sectors */
 	ee_pblock = ee_pblock << (blkbits - 9);
@@ -2245,11 +2247,11 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 	ee_block = le32_to_cpu(ex->ee_block);
 	ee_len = ext4_ext_get_actual_len(ex);
 	allocated = ee_len - (iblock - ee_block);
-	newblock = iblock - ee_block + ext_pblock(ex);
+	newblock = iblock - ee_block + ext4_ext_pblock(ex);
 	ex2 = ex;
 	orig_ex.ee_block = ex->ee_block;
 	orig_ex.ee_len   = cpu_to_le16(ee_len);
-	ext4_ext_store_pblock(&orig_ex, ext_pblock(ex));
+	ext4_ext_store_pblock(&orig_ex, ext4_ext_pblock(ex));
 
 	err = ext4_ext_get_access(handle, inode, path + depth);
 	if (err)
@@ -2262,7 +2264,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 		/* update the extent length and mark as initialized */
 		ex->ee_block = orig_ex.ee_block;
 		ex->ee_len   = orig_ex.ee_len;
-		ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
+		ext4_ext_store_pblock(ex, ext4_ext_pblock(&orig_ex));
 		ext4_ext_dirty(handle, inode, path + depth);
 		/* zeroed the full extent */
 		return allocated;
@@ -2294,7 +2296,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 			ex->ee_block = orig_ex.ee_block;
 			ex->ee_len   = cpu_to_le16(ee_len - allocated);
 			ext4_ext_mark_uninitialized(ex);
-			ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
+			ext4_ext_store_pblock(ex, ext4_ext_pblock(&orig_ex));
 			ext4_ext_dirty(handle, inode, path + depth);
 
 			ex3 = &newex;
@@ -2308,7 +2310,8 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 					goto fix_extent_len;
 				ex->ee_block = orig_ex.ee_block;
 				ex->ee_len   = orig_ex.ee_len;
-				ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
+				ext4_ext_store_pblock(ex,
+					ext4_ext_pblock(&orig_ex));
 				ext4_ext_dirty(handle, inode, path + depth);
 				/* zeroed the full extent */
 				return allocated;
@@ -2364,7 +2367,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 			/* update the extent length and mark as initialized */
 			ex->ee_block = orig_ex.ee_block;
 			ex->ee_len   = orig_ex.ee_len;
-			ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
+			ext4_ext_store_pblock(ex, ext4_ext_pblock(&orig_ex));
 			ext4_ext_dirty(handle, inode, path + depth);
 			/* zeroed the full extent */
 			return allocated;
@@ -2413,7 +2416,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 			/* update the extent length and mark as initialized */
 			ex->ee_block = orig_ex.ee_block;
 			ex->ee_len   = orig_ex.ee_len;
-			ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
+			ext4_ext_store_pblock(ex, ext4_ext_pblock(&orig_ex));
 			ext4_ext_dirty(handle, inode, path + depth);
 			/* zero out the first half */
 			return allocated;
@@ -2481,7 +2484,7 @@ insert:
 		/* update the extent length and mark as initialized */
 		ex->ee_block = orig_ex.ee_block;
 		ex->ee_len   = orig_ex.ee_len;
-		ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
+		ext4_ext_store_pblock(ex, ext4_ext_pblock(&orig_ex));
 		ext4_ext_dirty(handle, inode, path + depth);
 		/* zero out the first half */
 		return allocated;
@@ -2493,7 +2496,7 @@ out:
 fix_extent_len:
 	ex->ee_block = orig_ex.ee_block;
 	ex->ee_len   = orig_ex.ee_len;
-	ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
+	ext4_ext_store_pblock(ex, ext4_ext_pblock(&orig_ex));
 	ext4_ext_mark_uninitialized(ex);
 	ext4_ext_dirty(handle, inode, path + depth);
 	return err;
@@ -2550,7 +2553,7 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 			/* block is already allocated */
 			newblock = iblock
 				   - le32_to_cpu(newex.ee_block)
-				   + ext_pblock(&newex);
+				   + ext4_ext_pblock(&newex);
 			/* number of remaining blocks in the extent */
 			allocated = ext4_ext_get_actual_len(&newex) -
 					(iblock - le32_to_cpu(newex.ee_block));
@@ -2581,7 +2584,7 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 	ex = path[depth].p_ext;
 	if (ex) {
 		ext4_lblk_t ee_block = le32_to_cpu(ex->ee_block);
-		ext4_fsblk_t ee_start = ext_pblock(ex);
+		ext4_fsblk_t ee_start = ext4_ext_pblock(ex);
 		unsigned short ee_len;
 
 		/*
@@ -2711,7 +2714,7 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 		/* not a good idea to call discard here directly,
 		 * but otherwise we'd need to call it every free() */
 		ext4_mb_discard_inode_preallocations(inode);
-		ext4_free_blocks(handle, inode, ext_pblock(&newex),
+		ext4_free_blocks(handle, inode, ext4_ext_pblock(&newex),
 					ext4_ext_get_actual_len(&newex), 0);
 		goto out2;
 	}
@@ -2720,7 +2723,7 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 		EXT4_I(inode)->i_disksize = inode->i_size;
 
 	/* previous routine could use block we allocated */
-	newblock = ext_pblock(&newex);
+	newblock = ext4_ext_pblock(&newex);
 	allocated = ext4_ext_get_actual_len(&newex);
 outnew:
 	__set_bit(BH_New, &bh_result->b_state);
diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index b9e077b..2be69f2 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -402,7 +402,7 @@ static int free_ext_idx(handle_t *handle, struct inode *inode,
 	struct buffer_head *bh;
 	struct ext4_extent_header *eh;
 
-	block = idx_pblock(ix);
+	block = ext4_idx_pblock(ix);
 	bh = sb_bread(inode->i_sb, block);
 	if (!bh)
 		return -EIO;
-- 
1.5.4.5

