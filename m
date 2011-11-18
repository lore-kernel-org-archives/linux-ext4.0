From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH 3/9 v2 bigalloc] ext4: change unit of extent's ee_block to cluster
Date: Fri, 18 Nov 2011 18:42:58 +0800
Message-ID: <1321612984-10228-4-git-send-email-hao.bigrat@gmail.com>
References: <1321612984-10228-1-git-send-email-hao.bigrat@gmail.com>
Cc: Robin Dong <sanbai@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62580 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab1KRKnV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Nov 2011 05:43:21 -0500
Received: by mail-iy0-f174.google.com with SMTP id e36so3428378iag.19
        for <linux-ext4@vger.kernel.org>; Fri, 18 Nov 2011 02:43:21 -0800 (PST)
In-Reply-To: <1321612984-10228-1-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

Change the unit of ee_block (of extent) from block to cluster

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 fs/ext4/extents.c |  286 ++++++++++++++++++++++++++++++++---------------------
 1 files changed, 174 insertions(+), 112 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 3430ddf..4f764ee 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -140,7 +140,8 @@ static ext4_fsblk_t ext4_ext_find_goal(struct inode *inode,
 		ex = path[depth].p_ext;
 		if (ex) {
 			ext4_fsblk_t ext_pblk = ext4_ext_pblock(ex);
-			ext4_lblk_t ext_block = le32_to_cpu(ex->ee_block);
+			ext4_lblk_t ext_block = EXT4_INODE_C2B(inode,
+					le32_to_cpu(ex->ee_block));
 
 			if (block > ext_block)
 				return ext_pblk + (block - ext_block);
@@ -168,7 +169,8 @@ ext4_ext_new_meta_block(handle_t *handle, struct inode *inode,
 {
 	ext4_fsblk_t goal, newblock;
 
-	goal = ext4_ext_find_goal(inode, path, le32_to_cpu(ex->ee_block));
+	goal = ext4_ext_find_goal(inode, path,
+			EXT4_INODE_C2B(inode, le32_to_cpu(ex->ee_block)));
 	newblock = ext4_new_meta_blocks(handle, inode, goal, flags,
 					NULL, err);
 	return newblock;
@@ -411,11 +413,13 @@ static void ext4_ext_show_path(struct inode *inode, struct ext4_ext_path *path)
 	ext_debug("path:");
 	for (k = 0; k <= l; k++, path++) {
 		if (path->p_idx) {
-		  ext_debug("  %d->%llu", le32_to_cpu(path->p_idx->ei_block),
-			    ext4_idx_pblock(path->p_idx));
+			ext_debug("  %d->%llu", EXT4_INODE_C2B(inode,
+				le32_to_cpu(path->p_idx->ei_block)),
+				ext4_idx_pblock(path->p_idx));
 		} else if (path->p_ext) {
 			ext_debug("  %d:[%d]%d:%llu ",
-				  le32_to_cpu(path->p_ext->ee_block),
+				  EXT4_INODE_C2B(inode,
+					  le32_to_cpu(path->p_ext->ee_block)),
 				  ext4_ext_is_uninitialized(path->p_ext),
 				  ext4_ext_get_actual_blocks(path->p_ext,
 					  inode->i_sb),
@@ -442,7 +446,8 @@ static void ext4_ext_show_leaf(struct inode *inode, struct ext4_ext_path *path)
 	ext_debug("Displaying leaf extents for inode %lu\n", inode->i_ino);
 
 	for (i = 0; i < le16_to_cpu(eh->eh_entries); i++, ex++) {
-		ext_debug("%d:[%d]%d:%llu ", le32_to_cpu(ex->ee_block),
+		ext_debug("%d:[%d]%d:%llu ",
+			  EXT4_INODE_C2B(inode, le32_to_cpu(ex->ee_block)),
 			  ext4_ext_is_uninitialized(ex),
 			  ext4_ext_get_actual_blocks(ex, inode->i_sb),
 			  ext4_ext_pblock(ex));
@@ -461,7 +466,8 @@ static void ext4_ext_show_move(struct inode *inode, struct ext4_ext_path *path,
 		idx = path[level].p_idx;
 		while (idx <= EXT_MAX_INDEX(path[level].p_hdr)) {
 			ext_debug("%d: move %d:%llu in new index %llu\n", level,
-					le32_to_cpu(idx->ei_block),
+					EXT4_INODE_C2B(inode,
+						le32_to_cpu(idx->ei_block)),
 					ext4_idx_pblock(idx),
 					newblock);
 			idx++;
@@ -473,7 +479,8 @@ static void ext4_ext_show_move(struct inode *inode, struct ext4_ext_path *path,
 	ex = path[depth].p_ext;
 	while (ex <= EXT_MAX_EXTENT(path[depth].p_hdr)) {
 		ext_debug("move %d:%llu:[%d]%d in new leaf %llu\n",
-				le32_to_cpu(ex->ee_block),
+				EXT4_INODE_C2B(ionde,
+					le32_to_cpu(ex->ee_block)),
 				ext4_ext_pblock(ex),
 				ext4_ext_is_uninitialized(ex),
 				ext4_ext_get_actual_blocks(ex, inode->i_sb),
@@ -519,17 +526,19 @@ ext4_ext_binsearch_idx(struct inode *inode,
 	r = EXT_LAST_INDEX(eh);
 	while (l <= r) {
 		m = l + (r - l) / 2;
-		if (block < le32_to_cpu(m->ei_block))
+		if (block < EXT4_INODE_C2B(inode, le32_to_cpu(m->ei_block)))
 			r = m - 1;
 		else
 			l = m + 1;
-		ext_debug("%p(%u):%p(%u):%p(%u) ", l, le32_to_cpu(l->ei_block),
-				m, le32_to_cpu(m->ei_block),
-				r, le32_to_cpu(r->ei_block));
+		ext_debug("%p(%u):%p(%u):%p(%u) ",
+			l, EXT4_INODE_C2B(inode, le32_to_cpu(l->ei_block)),
+			m, EXT4_INODE_C2B(inode, le32_to_cpu(m->ei_block)),
+			r, EXT4_INODE_C2B(inode, le32_to_cpu(r->ei_block)));
 	}
 
 	path->p_idx = l - 1;
-	ext_debug("  -> %d->%lld ", le32_to_cpu(path->p_idx->ei_block),
+	ext_debug("  -> %d->%lld ",
+		  EXT4_INODE_C2B(inode, le32_to_cpu(path->p_idx->ei_block)),
 		  ext4_idx_pblock(path->p_idx));
 
 #ifdef CHECK_BINSEARCH
@@ -545,12 +554,14 @@ ext4_ext_binsearch_idx(struct inode *inode,
 				       "first=0x%p\n", k,
 				       ix, EXT_FIRST_INDEX(eh));
 				printk(KERN_DEBUG "%u <= %u\n",
-				       le32_to_cpu(ix->ei_block),
-				       le32_to_cpu(ix[-1].ei_block));
+				       EXT4_INODE_C2B(inode,
+					       le32_to_cpu(ix->ei_block)),
+				       EXT4_INODE_C2B(inode,
+					       le32_to_cpu(ix[-1].ei_block)));
 			}
 			BUG_ON(k && le32_to_cpu(ix->ei_block)
 					   <= le32_to_cpu(ix[-1].ei_block));
-			if (block < le32_to_cpu(ix->ei_block))
+			if (block < EXT4_INODE_C2B(le32_to_cpu(ix->ei_block)))
 				break;
 			chix = ix;
 		}
@@ -587,21 +598,22 @@ ext4_ext_binsearch(struct inode *inode,
 
 	while (l <= r) {
 		m = l + (r - l) / 2;
-		if (block < le32_to_cpu(m->ee_block))
+		if (block < EXT4_INODE_C2B(inode, le32_to_cpu(m->ee_block)))
 			r = m - 1;
 		else
 			l = m + 1;
-		ext_debug("%p(%u):%p(%u):%p(%u) ", l, le32_to_cpu(l->ee_block),
-				m, le32_to_cpu(m->ee_block),
-				r, le32_to_cpu(r->ee_block));
+		ext_debug("%p(%u):%p(%u):%p(%u) ",
+			l, EXT4_INODE_C2B(inode, le32_to_cpu(l->ee_block)),
+			m, EXT4_INODE_C2B(inode, le32_to_cpu(m->ee_block)),
+			r, EXT4_INODE_C2B(inode, le32_to_cpu(r->ee_block)));
 	}
 
 	path->p_ext = l - 1;
 	ext_debug("  -> %d:%llu:[%d]%d ",
-			le32_to_cpu(path->p_ext->ee_block),
-			ext4_ext_pblock(path->p_ext),
-			ext4_ext_is_uninitialized(path->p_ext),
-			ext4_ext_get_actual_blocks(path->p_ext, inode->i_sb));
+		EXT4_INODE_C2B(inode, le32_to_cpu(path->p_ext->ee_block)),
+		ext4_ext_pblock(path->p_ext),
+		ext4_ext_is_uninitialized(path->p_ext),
+		ext4_ext_get_actual_blocks(path->p_ext, inode->i_sb));
 
 #ifdef CHECK_BINSEARCH
 	{
@@ -612,7 +624,8 @@ ext4_ext_binsearch(struct inode *inode,
 		for (k = 0; k < le16_to_cpu(eh->eh_entries); k++, ex++) {
 			BUG_ON(k && le32_to_cpu(ex->ee_block)
 					  <= le32_to_cpu(ex[-1].ee_block));
-			if (block < le32_to_cpu(ex->ee_block))
+			if (block < EXT4_INODE_C2B(inode,
+						le32_to_cpu(ex->ee_block)))
 				break;
 			chex = ex;
 		}
@@ -737,10 +750,13 @@ static int ext4_ext_insert_index(handle_t *handle, struct inode *inode,
 	if (err)
 		return err;
 
+	/* variable "logical" is in unit of cluster */
 	if (unlikely(logical == le32_to_cpu(curp->p_idx->ei_block))) {
 		EXT4_ERROR_INODE(inode,
 				 "logical %d == ei_block %d!",
-				 logical, le32_to_cpu(curp->p_idx->ei_block));
+				 logical,
+				 EXT4_INODE_C2B(inode,
+					 le32_to_cpu(curp->p_idx->ei_block)));
 		return -EIO;
 	}
 
@@ -971,8 +987,9 @@ static int ext4_ext_split(handle_t *handle, struct inode *inode,
 		if (unlikely(EXT_MAX_INDEX(path[i].p_hdr) !=
 					EXT_LAST_INDEX(path[i].p_hdr))) {
 			EXT4_ERROR_INODE(inode,
-					 "EXT_MAX_INDEX != EXT_LAST_INDEX ee_block %d!",
-					 le32_to_cpu(path[i].p_ext->ee_block));
+				"EXT_MAX_INDEX != EXT_LAST_INDEX ee_block %d!",
+				EXT4_INODE_C2B(inode,
+					le32_to_cpu(path[i].p_ext->ee_block)));
 			err = -EIO;
 			goto cleanup;
 		}
@@ -1112,7 +1129,8 @@ static int ext4_ext_grow_indepth(handle_t *handle, struct inode *inode,
 	neh = ext_inode_hdr(inode);
 	ext_debug("new root: num %d(%d), lblock %d, ptr %llu\n",
 		  le16_to_cpu(neh->eh_entries), le16_to_cpu(neh->eh_max),
-		  le32_to_cpu(EXT_FIRST_INDEX(neh)->ei_block),
+		  EXT4_INODE_C2B(inode,
+			  le32_to_cpu(EXT_FIRST_INDEX(neh)->ei_block)),
 		  ext4_idx_pblock(EXT_FIRST_INDEX(neh)));
 
 	neh->eh_depth = cpu_to_le16(path->p_depth + 1);
@@ -1158,7 +1176,8 @@ repeat:
 		/* refill path */
 		ext4_ext_drop_refs(path);
 		path = ext4_ext_find_extent(inode,
-				    (ext4_lblk_t)le32_to_cpu(newext->ee_block),
+				    (ext4_lblk_t)EXT4_INODE_C2B(inode,
+					    le32_to_cpu(newext->ee_block)),
 				    path);
 		if (IS_ERR(path))
 			err = PTR_ERR(path);
@@ -1172,7 +1191,8 @@ repeat:
 		/* refill path */
 		ext4_ext_drop_refs(path);
 		path = ext4_ext_find_extent(inode,
-				   (ext4_lblk_t)le32_to_cpu(newext->ee_block),
+				   (ext4_lblk_t)EXT4_INODE_C2B(inode,
+					   le32_to_cpu(newext->ee_block)),
 				    path);
 		if (IS_ERR(path)) {
 			err = PTR_ERR(path);
@@ -1225,11 +1245,13 @@ static int ext4_ext_search_left(struct inode *inode,
 
 	ex = path[depth].p_ext;
 	ee_len = ext4_ext_get_actual_blocks(ex, inode->i_sb);
-	if (*logical < le32_to_cpu(ex->ee_block)) {
+	if (*logical < EXT4_INODE_C2B(inode, le32_to_cpu(ex->ee_block))) {
 		if (unlikely(EXT_FIRST_EXTENT(path[depth].p_hdr) != ex)) {
 			EXT4_ERROR_INODE(inode,
 					 "EXT_FIRST_EXTENT != ex *logical %d ee_block %d!",
-					 *logical, le32_to_cpu(ex->ee_block));
+					 *logical,
+					 EXT4_INODE_C2B(inode,
+						 le32_to_cpu(ex->ee_block)));
 			return -EIO;
 		}
 		while (--depth >= 0) {
@@ -1237,9 +1259,11 @@ static int ext4_ext_search_left(struct inode *inode,
 			if (unlikely(ix != EXT_FIRST_INDEX(path[depth].p_hdr))) {
 				EXT4_ERROR_INODE(inode,
 				  "ix (%d) != EXT_FIRST_INDEX (%d) (depth %d)!",
-				  ix != NULL ? ix->ei_block : 0,
+				  ix != NULL ? EXT4_INODE_C2B(
+					  inode, ix->ei_block) : 0,
 				  EXT_FIRST_INDEX(path[depth].p_hdr) != NULL ?
-				    EXT_FIRST_INDEX(path[depth].p_hdr)->ei_block : 0,
+				    EXT4_INODE_C2B(inode, EXT_FIRST_INDEX(
+					path[depth].p_hdr)->ei_block) : 0,
 				  depth);
 				return -EIO;
 			}
@@ -1247,14 +1271,19 @@ static int ext4_ext_search_left(struct inode *inode,
 		return 0;
 	}
 
-	if (unlikely(*logical < (le32_to_cpu(ex->ee_block) + ee_len))) {
+	if (unlikely(*logical <
+		(EXT4_INODE_C2B(inode, le32_to_cpu(ex->ee_block)) + ee_len))) {
 		EXT4_ERROR_INODE(inode,
 				 "logical %d < ee_block %d + ee_len %d!",
-				 *logical, le32_to_cpu(ex->ee_block), ee_len);
+				 *logical,
+				 EXT4_INODE_C2B(inode,
+					 le32_to_cpu(ex->ee_block)),
+				 ee_len);
 		return -EIO;
 	}
 
-	*logical = le32_to_cpu(ex->ee_block) + ee_len - 1;
+	*logical = EXT4_INODE_C2B(inode, le32_to_cpu(ex->ee_block))
+		+ ee_len - 1;
 	*phys = ext4_ext_pblock(ex) + ee_len - 1;
 	return 0;
 }
@@ -1295,7 +1324,7 @@ static int ext4_ext_search_right(struct inode *inode,
 
 	ex = path[depth].p_ext;
 	ee_len = ext4_ext_get_actual_blocks(ex, inode->i_sb);
-	if (*logical < le32_to_cpu(ex->ee_block)) {
+	if (*logical < EXT4_INODE_C2B(inode, le32_to_cpu(ex->ee_block))) {
 		if (unlikely(EXT_FIRST_EXTENT(path[depth].p_hdr) != ex)) {
 			EXT4_ERROR_INODE(inode,
 					 "first_extent(path[%d].p_hdr) != ex",
@@ -1314,10 +1343,14 @@ static int ext4_ext_search_right(struct inode *inode,
 		goto found_extent;
 	}
 
-	if (unlikely(*logical < (le32_to_cpu(ex->ee_block) + ee_len))) {
+	if (unlikely(*logical <
+		(EXT4_INODE_C2B(inode, le32_to_cpu(ex->ee_block)) + ee_len))) {
 		EXT4_ERROR_INODE(inode,
 				 "logical %d < ee_block %d + ee_len %d!",
-				 *logical, le32_to_cpu(ex->ee_block), ee_len);
+				 *logical,
+				 EXT4_INODE_C2B(inode,
+					 le32_to_cpu(ex->ee_block)),
+				 ee_len);
 		return -EIO;
 	}
 
@@ -1368,7 +1401,7 @@ got_index:
 	}
 	ex = EXT_FIRST_EXTENT(eh);
 found_extent:
-	*logical = le32_to_cpu(ex->ee_block);
+	*logical = EXT4_INODE_C2B(inode, le32_to_cpu(ex->ee_block));
 	*phys = ext4_ext_pblock(ex);
 	*ret_ex = ex;
 	if (bh)
@@ -1384,7 +1417,7 @@ found_extent:
  * with leaves.
  */
 static ext4_lblk_t
-ext4_ext_next_allocated_block(struct ext4_ext_path *path)
+ext4_ext_next_allocated_block(struct inode *inode, struct ext4_ext_path *path)
 {
 	int depth;
 
@@ -1397,14 +1430,16 @@ ext4_ext_next_allocated_block(struct ext4_ext_path *path)
 	while (depth >= 0) {
 		if (depth == path->p_depth) {
 			/* leaf */
-			if (path[depth].p_ext !=
-					EXT_LAST_EXTENT(path[depth].p_hdr))
-			  return le32_to_cpu(path[depth].p_ext[1].ee_block);
+			if (path[depth].p_ext != EXT_LAST_EXTENT(
+						path[depth].p_hdr))
+				return EXT4_INODE_C2B(inode, le32_to_cpu(
+						path[depth].p_ext[1].ee_block));
 		} else {
 			/* index */
-			if (path[depth].p_idx !=
-					EXT_LAST_INDEX(path[depth].p_hdr))
-			  return le32_to_cpu(path[depth].p_idx[1].ei_block);
+			if (path[depth].p_idx != EXT_LAST_INDEX(
+						path[depth].p_hdr))
+				return EXT4_INODE_C2B(inode, le32_to_cpu(
+						path[depth].p_idx[1].ei_block));
 		}
 		depth--;
 	}
@@ -1416,7 +1451,8 @@ ext4_ext_next_allocated_block(struct ext4_ext_path *path)
  * ext4_ext_next_leaf_block:
  * returns first allocated block from next leaf or EXT_MAX_BLOCKS
  */
-static ext4_lblk_t ext4_ext_next_leaf_block(struct ext4_ext_path *path)
+static ext4_lblk_t ext4_ext_next_leaf_block(struct inode *inode,
+		struct ext4_ext_path *path)
 {
 	int depth;
 
@@ -1433,8 +1469,8 @@ static ext4_lblk_t ext4_ext_next_leaf_block(struct ext4_ext_path *path)
 	while (depth >= 0) {
 		if (path[depth].p_idx !=
 				EXT_LAST_INDEX(path[depth].p_hdr))
-			return (ext4_lblk_t)
-				le32_to_cpu(path[depth].p_idx[1].ei_block);
+			return (ext4_lblk_t) EXT4_INODE_C2B(inode,
+				le32_to_cpu(path[depth].p_idx[1].ei_block));
 		depth--;
 	}
 
@@ -1636,12 +1672,12 @@ static unsigned int ext4_ext_check_overlap(struct ext4_sb_info *sbi,
 	unsigned int depth, len1;
 	unsigned int ret = 0;
 
-	b1 = le32_to_cpu(newext->ee_block);
+	b1 = EXT4_INODE_C2B(inode, le32_to_cpu(newext->ee_block));
 	len1 = ext4_ext_get_actual_blocks(newext, inode->i_sb);
 	depth = ext_depth(inode);
 	if (!path[depth].p_ext)
 		goto out;
-	b2 = le32_to_cpu(path[depth].p_ext->ee_block);
+	b2 = EXT4_INODE_C2B(inode, le32_to_cpu(path[depth].p_ext->ee_block));
 	b2 &= ~(sbi->s_cluster_ratio - 1);
 
 	/*
@@ -1649,7 +1685,7 @@ static unsigned int ext4_ext_check_overlap(struct ext4_sb_info *sbi,
 	 * is before the requested block(s)
 	 */
 	if (b2 < b1) {
-		b2 = ext4_ext_next_allocated_block(path);
+		b2 = ext4_ext_next_allocated_block(inode, path);
 		if (b2 == EXT_MAX_BLOCKS)
 			goto out;
 		b2 &= ~(sbi->s_cluster_ratio - 1);
@@ -1707,7 +1743,7 @@ int ext4_ext_insert_extent(handle_t *handle, struct inode *inode,
 		ext_debug("append [%d]%d block to %d:[%d]%d (from %llu)\n",
 			  ext4_ext_is_uninitialized(newext),
 			  ext4_ext_get_actual_blocks(newext, inode->i_sb),
-			  le32_to_cpu(ex->ee_block),
+			  EXT4_INODE_C2B(inode, le32_to_cpu(ex->ee_block)),
 			  ext4_ext_is_uninitialized(ex),
 			  ext4_ext_get_actual_blocks(ex, inode->i_sb),
 			  ext4_ext_pblock(ex));
@@ -1740,7 +1776,7 @@ int ext4_ext_insert_extent(handle_t *handle, struct inode *inode,
 	fex = EXT_LAST_EXTENT(eh);
 	next = EXT_MAX_BLOCKS;
 	if (le32_to_cpu(newext->ee_block) > le32_to_cpu(fex->ee_block))
-		next = ext4_ext_next_leaf_block(path);
+		next = ext4_ext_next_leaf_block(inode, path);
 	if (next != EXT_MAX_BLOCKS) {
 		ext_debug("next leaf block - %d\n", next);
 		BUG_ON(npath != NULL);
@@ -1781,7 +1817,8 @@ has_space:
 	if (!nearex) {
 		/* there is no extent in this leaf, create first one */
 		ext_debug("first extent in the leaf: %d:%llu:[%d]%d\n",
-				le32_to_cpu(newext->ee_block),
+				EXT4_INODE_C2B(inode,
+					le32_to_cpu(newext->ee_block)),
 				ext4_ext_pblock(newext),
 				ext4_ext_is_uninitialized(newext),
 				ext4_ext_get_actual_blocks(newext,
@@ -1796,7 +1833,8 @@ has_space:
 			len = len < 0 ? 0 : len;
 			ext_debug("insert %d:%llu:[%d]%d after: nearest 0x%p, "
 					"move %d from 0x%p to 0x%p\n",
-					le32_to_cpu(newext->ee_block),
+					EXT4_INODE_C2B(inode,
+						le32_to_cpu(newext->ee_block)),
 					ext4_ext_pblock(newext),
 					ext4_ext_is_uninitialized(newext),
 					ext4_ext_get_actual_blocks(newext,
@@ -1811,7 +1849,8 @@ has_space:
 		len = len < 0 ? 0 : len;
 		ext_debug("insert %d:%llu:[%d]%d before: nearest 0x%p, "
 				"move %d from 0x%p to 0x%p\n",
-				le32_to_cpu(newext->ee_block),
+				EXT4_INODE_C2B(inode,
+					le32_to_cpu(newext->ee_block)),
 				ext4_ext_pblock(newext),
 				ext4_ext_is_uninitialized(newext),
 				ext4_ext_get_actual_blocks(newext,
@@ -1883,7 +1922,7 @@ static int ext4_ext_walk_space(struct inode *inode, ext4_lblk_t block,
 			break;
 		}
 		ex = path[depth].p_ext;
-		next = ext4_ext_next_allocated_block(path);
+		next = ext4_ext_next_allocated_block(inode, path);
 
 		exists = 0;
 		if (!ex) {
@@ -1891,26 +1930,29 @@ static int ext4_ext_walk_space(struct inode *inode, ext4_lblk_t block,
 			 * all requested space */
 			start = block;
 			end = block + num;
-		} else if (le32_to_cpu(ex->ee_block) > block) {
+		} else if (EXT4_INODE_C2B(inode, le32_to_cpu(ex->ee_block))
+				> block) {
 			/* need to allocate space before found extent */
 			start = block;
-			end = le32_to_cpu(ex->ee_block);
+			end = EXT4_INODE_C2B(inode, le32_to_cpu(ex->ee_block));
 			if (block + num < end)
 				end = block + num;
-		} else if (block >= le32_to_cpu(ex->ee_block)
+		} else if (block >=
+				EXT4_INODE_C2B(inode, le32_to_cpu(ex->ee_block))
 			+ ext4_ext_get_actual_blocks(ex, inode->i_sb)) {
 			/* need to allocate space after found extent */
 			start = block;
 			end = block + num;
 			if (end >= next)
 				end = next;
-		} else if (block >= le32_to_cpu(ex->ee_block)) {
+		} else if (block >= EXT4_INODE_C2B(inode,
+					le32_to_cpu(ex->ee_block))) {
 			/*
 			 * some part of requested space is covered
 			 * by found extent
 			 */
 			start = block;
-			end = le32_to_cpu(ex->ee_block)
+			end = EXT4_INODE_C2B(inode, le32_to_cpu(ex->ee_block))
 				+ ext4_ext_get_actual_blocks(ex, inode->i_sb);
 			if (block + num < end)
 				end = block + num;
@@ -1925,7 +1967,8 @@ static int ext4_ext_walk_space(struct inode *inode, ext4_lblk_t block,
 			cbex.ec_len = EXT4_INODE_B2C(inode, end - start);
 			cbex.ec_start = 0;
 		} else {
-			cbex.ec_block = le32_to_cpu(ex->ee_block);
+			cbex.ec_block = EXT4_INODE_C2B(inode,
+					le32_to_cpu(ex->ee_block));
 			cbex.ec_len = ext4_ext_get_actual_len(ex);
 			cbex.ec_start = ext4_ext_pblock(ex);
 		}
@@ -2000,24 +2043,24 @@ ext4_ext_put_gap_in_cache(struct inode *inode, struct ext4_ext_path *path,
 		lblock = 0;
 		len = EXT_MAX_BLOCKS;
 		ext_debug("cache gap(whole file):");
-	} else if (block < le32_to_cpu(ex->ee_block)) {
+	} else if (block < EXT4_INODE_C2B(inode, le32_to_cpu(ex->ee_block))) {
 		lblock = block;
-		len = le32_to_cpu(ex->ee_block) - block;
+		len = EXT4_INODE_C2B(inode, le32_to_cpu(ex->ee_block)) - block;
 		ext_debug("cache gap(before): %u [%u:%u]",
-				block,
-				le32_to_cpu(ex->ee_block),
-				 ext4_ext_get_actual_blocks(ex, inode->i_sb));
-	} else if (block >= le32_to_cpu(ex->ee_block)
+			block,
+			EXT4_INODE_C2B(inode, le32_to_cpu(ex->ee_block)),
+			ext4_ext_get_actual_blocks(ex, inode->i_sb));
+	} else if (block >= EXT4_INODE_C2B(inode, le32_to_cpu(ex->ee_block))
 			+ ext4_ext_get_actual_blocks(ex, inode->i_sb)) {
 		ext4_lblk_t next;
-		lblock = le32_to_cpu(ex->ee_block)
+		lblock = EXT4_INODE_C2B(inode, le32_to_cpu(ex->ee_block))
 			+ ext4_ext_get_actual_blocks(ex, inode->i_sb);
 
-		next = ext4_ext_next_allocated_block(path);
+		next = ext4_ext_next_allocated_block(inode, path);
 		ext_debug("cache gap(after): [%u:%u] %u",
-				le32_to_cpu(ex->ee_block),
-				ext4_ext_get_actual_blocks(ex, inode->i_sb),
-				block);
+			EXT4_INODE_C2B(inode, le32_to_cpu(ex->ee_block)),
+			ext4_ext_get_actual_blocks(ex, inode->i_sb),
+			block);
 		BUG_ON(next == lblock);
 		len = next - lblock;
 	} else {
@@ -2026,7 +2069,7 @@ ext4_ext_put_gap_in_cache(struct inode *inode, struct ext4_ext_path *path,
 	}
 
 	ext_debug(" -> %u:%lu\n", lblock, len);
-	ext4_ext_put_in_cache(inode, lblock, len, 0);
+	ext4_ext_put_in_cache(inode, EXT4_INODE_B2C(inode, lblock), len, 0);
 }
 
 /*
@@ -2062,11 +2105,14 @@ static int ext4_ext_check_cache(struct inode *inode, ext4_lblk_t block,
 	if (cex->ec_len == 0)
 		goto errout;
 
-	if (in_range(block, cex->ec_block, cex->ec_len)) {
+	if (in_range(block, EXT4_C2B(sbi, cex->ec_block),
+				EXT4_C2B(sbi, cex->ec_len))) {
 		memcpy(ex, cex, sizeof(struct ext4_ext_cache));
 		ext_debug("%u cached by %u:%u:%llu\n",
 				block,
-				cex->ec_block, cex->ec_len, cex->ec_start);
+				EXT4_C2B(sbi, cex->ec_block),
+				EXT4_C2B(sbi, cex->ec_len),
+				EXT4_C2B(sbi, cex->ec_start));
 		ret = 1;
 	}
 errout:
@@ -2229,9 +2275,10 @@ static int ext4_remove_blocks(handle_t *handle, struct inode *inode,
 	 */
 	flags |= EXT4_FREE_BLOCKS_NOFREE_FIRST_CLUSTER;
 
-	trace_ext4_remove_blocks(inode, cpu_to_le32(ex->ee_block),
-				 ext4_ext_pblock(ex), ee_len, from,
-				 to, *partial_cluster);
+	trace_ext4_remove_blocks(inode,
+			cpu_to_le32(EXT4_INODE_C2B(inode, ex->ee_block)),
+			ext4_ext_pblock(ex), ee_len, from,
+			to, *partial_cluster);
 	/*
 	 * If we have a partial cluster, and it's different from the
 	 * cluster of the last block, we need to explicitly free the
@@ -2260,12 +2307,14 @@ static int ext4_remove_blocks(handle_t *handle, struct inode *inode,
 		spin_unlock(&sbi->s_ext_stats_lock);
 	}
 #endif
-	if (from >= le32_to_cpu(ex->ee_block)
-	    && to == le32_to_cpu(ex->ee_block) + ee_len - 1) {
+	if (from >= EXT4_INODE_C2B(inode, le32_to_cpu(ex->ee_block))
+	    && to == EXT4_INODE_C2B(inode, le32_to_cpu(ex->ee_block))
+	    + ee_len - 1) {
 		/* tail removal */
 		ext4_lblk_t num;
 
-		num = le32_to_cpu(ex->ee_block) + ee_len - from;
+		num = EXT4_INODE_C2B(inode, le32_to_cpu(ex->ee_block))
+				+ ee_len - from;
 		pblk = ext4_ext_pblock(ex) + ee_len - num;
 		ext_debug("free last %u blocks starting %llu\n", num, pblk);
 		ext4_free_blocks(handle, inode, NULL, pblk, num, flags);
@@ -2282,8 +2331,9 @@ static int ext4_remove_blocks(handle_t *handle, struct inode *inode,
 			*partial_cluster = EXT4_B2C(sbi, pblk);
 		else
 			*partial_cluster = 0;
-	} else if (from == le32_to_cpu(ex->ee_block)
-		   && to <= le32_to_cpu(ex->ee_block) + ee_len - 1) {
+	} else if (from == EXT4_INODE_C2B(inode, le32_to_cpu(ex->ee_block))
+		   && to <= EXT4_INODE_C2B(inode, le32_to_cpu(ex->ee_block))
+		   + ee_len - 1) {
 		/* head removal */
 		ext4_lblk_t num;
 		ext4_fsblk_t start;
@@ -2297,7 +2347,10 @@ static int ext4_remove_blocks(handle_t *handle, struct inode *inode,
 	} else {
 		printk(KERN_INFO "strange request: removal(2) "
 				"%u-%u from %u:%u\n",
-				from, to, le32_to_cpu(ex->ee_block), ee_len);
+				from, to,
+				EXT4_INODE_C2B(inode,
+					le32_to_cpu(ex->ee_block)),
+				ee_len);
 	}
 	return 0;
 }
@@ -2343,7 +2396,7 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
 	/* find where to start removing */
 	ex = EXT_LAST_EXTENT(eh);
 
-	ex_ee_block = le32_to_cpu(ex->ee_block);
+	ex_ee_block = EXT4_INODE_C2B(inode, le32_to_cpu(ex->ee_block));
 	ex_ee_len = ext4_ext_get_actual_blocks(ex, inode->i_sb);
 
 	trace_ext4_ext_rm_leaf(inode, start, ex_ee_block, ext4_ext_pblock(ex),
@@ -2370,7 +2423,8 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
 		/* If this extent is beyond the end of the hole, skip it */
 		if (end <= ex_ee_block) {
 			ex--;
-			ex_ee_block = le32_to_cpu(ex->ee_block);
+			ex_ee_block = EXT4_INODE_C2B(inode,
+					le32_to_cpu(ex->ee_block));
 			ex_ee_len = ext4_ext_get_actual_blocks(ex,
 					inode->i_sb);
 			continue;
@@ -2493,7 +2547,8 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
 			ext4_ext_store_pblock(ex, ext4_ext_pblock(ex) + (b-a));
 		}
 
-		ex->ee_block = cpu_to_le32(block);
+		BUG_ON(block & (sbi->s_cluster_ratio-1));
+		ex->ee_block = cpu_to_le32(EXT4_B2C(sbi, block));
 		ex->ee_len = cpu_to_le16(EXT4_B2C(sbi, num));
 		/*
 		 * Do not mark uninitialized if all the blocks in the
@@ -2531,7 +2586,7 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
 		ext_debug("new extent: %u:%u:%llu\n", block, num,
 				ext4_ext_pblock(ex));
 		ex--;
-		ex_ee_block = le32_to_cpu(ex->ee_block);
+		ex_ee_block = EXT4_INODE_C2B(inode, le32_to_cpu(ex->ee_block));
 		ex_ee_len = ext4_ext_get_actual_blocks(ex, inode->i_sb);
 	}
 
@@ -2862,7 +2917,7 @@ static int ext4_split_extent_at(handle_t *handle,
 
 	depth = ext_depth(inode);
 	ex = path[depth].p_ext;
-	ee_block = le32_to_cpu(ex->ee_block);
+	ee_block = EXT4_INODE_C2B(inode, le32_to_cpu(ex->ee_block));
 	ee_len = ext4_ext_get_actual_blocks(ex, inode->i_sb);
 	newblock = split - ee_block + ext4_ext_pblock(ex);
 
@@ -2905,7 +2960,7 @@ static int ext4_split_extent_at(handle_t *handle,
 		goto fix_extent_len;
 
 	ex2 = &newex;
-	ex2->ee_block = cpu_to_le32(split);
+	ex2->ee_block = cpu_to_le32(EXT4_INODE_B2C(inode, split));
 	ex2->ee_len   = cpu_to_le16(
 			EXT4_INODE_B2C(inode, ee_len - (split - ee_block)));
 	ext4_ext_store_pblock(ex2, newblock);
@@ -2962,7 +3017,7 @@ static int ext4_split_extent(handle_t *handle,
 
 	depth = ext_depth(inode);
 	ex = path[depth].p_ext;
-	ee_block = le32_to_cpu(ex->ee_block);
+	ee_block = EXT4_INODE_C2B(inode, le32_to_cpu(ex->ee_block));
 	ee_len = ext4_ext_get_actual_blocks(ex, inode->i_sb);
 	uninitialized = ext4_ext_is_uninitialized(ex);
 
@@ -3037,7 +3092,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 
 	depth = ext_depth(inode);
 	ex = path[depth].p_ext;
-	ee_block = le32_to_cpu(ex->ee_block);
+	ee_block = EXT4_INODE_C2B(inode, le32_to_cpu(ex->ee_block));
 	ee_len = ext4_ext_get_actual_blocks(ex, inode->i_sb);
 	allocated = ee_len - (map->m_lblk - ee_block);
 
@@ -3078,8 +3133,8 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 		if (allocated <= EXT4_EXT_ZERO_LEN &&
 		    (EXT4_EXT_MAY_ZEROOUT & split_flag)) {
 			/* case 3 */
-			zero_ex.ee_block =
-					 cpu_to_le32(map->m_lblk);
+			zero_ex.ee_block = cpu_to_le32(EXT4_INODE_B2C(inode,
+						map->m_lblk));
 			zero_ex.ee_len = cpu_to_le16(
 					EXT4_INODE_B2C(inode, allocated));
 			ext4_ext_store_pblock(&zero_ex,
@@ -3168,7 +3223,7 @@ static int ext4_split_unwritten_extents(handle_t *handle,
 	 */
 	depth = ext_depth(inode);
 	ex = path[depth].p_ext;
-	ee_block = le32_to_cpu(ex->ee_block);
+	ee_block = EXT4_INODE_C2B(inode, le32_to_cpu(ex->ee_block));
 	ee_len = ext4_ext_get_actual_blocks(ex, inode->i_sb);
 
 	split_flag |= ee_block + ee_len <= eof_block ? EXT4_EXT_MAY_ZEROOUT : 0;
@@ -3191,7 +3246,8 @@ static int ext4_convert_unwritten_extents_endio(handle_t *handle,
 
 	ext_debug("ext4_convert_unwritten_extents_endio: inode %lu, logical"
 		"block %llu, max_blocks %u\n", inode->i_ino,
-		(unsigned long long)le32_to_cpu(ex->ee_block),
+		(unsigned long long)EXT4_INODE_C2B(inode,
+			le32_to_cpu(ex->ee_block)),
 		ext4_ext_get_actual_blocks(ex, inode->i_sb));
 
 	err = ext4_ext_get_access(handle, inode, path + depth);
@@ -3253,7 +3309,7 @@ static int check_eofblocks_fl(handle_t *handle, struct inode *inode,
 	 * this turns out to be false, we can bail out from this
 	 * function immediately.
 	 */
-	if (lblk + len < le32_to_cpu(last_ex->ee_block) +
+	if (lblk + len < EXT4_INODE_C2B(inode, le32_to_cpu(last_ex->ee_block)) +
 	    ext4_ext_get_actual_blocks(last_ex, inode->i_sb))
 		return 0;
 	/*
@@ -3697,7 +3753,7 @@ static int get_implied_cluster_alloc(struct super_block *sb,
 		 *                  |================|
 		 */
 		if (map->m_lblk > ee_block) {
-			ext4_lblk_t next = ext4_ext_next_allocated_block(path);
+			ext4_lblk_t next = 0;//ext4_ext_next_allocated_block(path);
 			map->m_len = min(map->m_len, next - map->m_lblk);
 		}
 
@@ -3770,12 +3826,13 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 			if (sbi->s_cluster_ratio > 1)
 				map->m_flags |= EXT4_MAP_FROM_CLUSTER;
 			newblock = map->m_lblk
-				   - le32_to_cpu(newex.ee_block)
+				   - EXT4_C2B(sbi, le32_to_cpu(newex.ee_block))
 				   + ext4_ext_pblock(&newex);
 			/* number of remaining blocks in the extent */
 			allocated = ext4_ext_get_actual_blocks(&newex,
 				inode->i_sb) -
-				(map->m_lblk - le32_to_cpu(newex.ee_block));
+				(map->m_lblk - EXT4_C2B(sbi,
+						le32_to_cpu(newex.ee_block)));
 			goto out;
 		}
 	}
@@ -3806,7 +3863,7 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 
 	ex = path[depth].p_ext;
 	if (ex) {
-		ext4_lblk_t ee_block = le32_to_cpu(ex->ee_block);
+		ext4_lblk_t ee_block = EXT4_C2B(sbi, le32_to_cpu(ex->ee_block));
 		ext4_fsblk_t ee_start = ext4_ext_pblock(ex);
 		ext4_fsblk_t partial_cluster = 0;
 		unsigned int ee_len;
@@ -3833,7 +3890,8 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 				 * in the cache
 				 */
 				if (!ext4_ext_is_uninitialized(ex)) {
-					ext4_ext_put_in_cache(inode, ee_block,
+					ext4_ext_put_in_cache(inode,
+						EXT4_B2C(sbi, ee_block),
 						ee_len, ee_start);
 					goto out;
 				}
@@ -3895,7 +3953,8 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 				ex = path[depth].p_ext;
 				ee_len = ext4_ext_get_actual_blocks(ex,
 						inode->i_sb);
-				ee_block = le32_to_cpu(ex->ee_block);
+				ee_block = EXT4_C2B(sbi,
+						le32_to_cpu(ex->ee_block));
 				ee_start = ext4_ext_pblock(ex);
 
 			}
@@ -3949,11 +4008,12 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 	 * Okay, we need to do block allocation.
 	 */
 	map->m_flags &= ~EXT4_MAP_FROM_CLUSTER;
-	newex.ee_block = cpu_to_le32(map->m_lblk & ~(sbi->s_cluster_ratio-1));
+	newex.ee_block = EXT4_B2C(sbi,
+			cpu_to_le32(map->m_lblk & ~(sbi->s_cluster_ratio-1)));
 	cluster_offset = map->m_lblk & (sbi->s_cluster_ratio-1);
 
 	if (ex)
-		BUG_ON((le32_to_cpu(ex->ee_block) +
+		BUG_ON((EXT4_C2B(sbi, le32_to_cpu(ex->ee_block)) +
 			EXT4_C2B(sbi, ext4_ext_get_actual_len(ex))) >
 			(map->m_lblk & ~(sbi->s_cluster_ratio-1)));
 
@@ -4012,6 +4072,7 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 		ar.flags = 0;
 	if (flags & EXT4_GET_BLOCKS_NO_NORMALIZE)
 		ar.flags |= EXT4_MB_HINT_NOPREALLOC;
+	printk(KERN_ERR "ar: %lu, %lu, %lu\n", ar.len, ar.goal, ar.logical);
 	newblock = ext4_mb_new_blocks(handle, &ar, &err);
 	if (!newblock)
 		goto out2;
@@ -4153,7 +4214,8 @@ got_allocated_blocks:
 	 * when it is _not_ an uninitialized extent.
 	 */
 	if ((flags & EXT4_GET_BLOCKS_UNINIT_EXT) == 0) {
-		ext4_ext_put_in_cache(inode, ar.logical, allocated, newblock);
+		ext4_ext_put_in_cache(inode, EXT4_B2C(sbi, ar.logical),
+				allocated, newblock);
 		ext4_update_inode_fsync_trans(handle, inode, 1);
 	} else
 		ext4_update_inode_fsync_trans(handle, inode, 0);
-- 
1.7.3.2

