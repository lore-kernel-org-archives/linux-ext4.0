From: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Subject: [PATCH] introduce range check for extent pblock references
Date: Sat, 07 Feb 2009 16:36:58 +0100
Message-ID: <498DAA9A.8030309@ph.tum.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090601060903010504060907"
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from hamlet.e18.physik.tu-muenchen.de ([129.187.154.223]:43263 "EHLO
	hamlet.e18.physik.tu-muenchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751684AbZBGPhJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 7 Feb 2009 10:37:09 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090601060903010504060907
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This time I have aimed to catch all cases in which an invalid physical 
block might be used and implemented checks directly in ext_pblock() and 
idx_pblock() following the assumption that most of the times one of 
these functions is called a device access to that address will follow. 
If you think this is too heavy, I could also split the check from the 
pblock calculation, but in that case I could only guess at which of the 
several accesses to *_pblock() in extents.c a check would be necessary 
and where it wouldn't and there would be the possibility of missing 
something.

Another thing I'm unsure about is uninitialised extents, here my 
heuristic again was that ext_pblock() wouldn't be called if there was 
not an access to follow, so I didn't include a condition that would 
excempt them from the check.

The attached patch has only been mildly tested.

And I'm pretty new to linux and ext4, so there might be stupid mistakes.

Signed-off-by: Thiemo Nagel <thiemo.nagel@ph.tum.de>

--------------090601060903010504060907
Content-Type: text/plain;
 name="patch2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch2"

diff -ru download/linux-2.6.29-rc2-vanilla/fs/ext4/ext4_extents.h linux-2.6.29/fs/ext4/ext4_extents.h
--- download/linux-2.6.29-rc2-vanilla/fs/ext4/ext4_extents.h	2009-02-05 12:31:19.000000000 +0100
+++ linux-2.6.29/fs/ext4/ext4_extents.h	2009-02-07 14:35:15.000000000 +0100
@@ -221,7 +221,10 @@
 }
 
 extern int ext4_ext_calc_metadata_amount(struct inode *inode, int blocks);
-extern ext4_fsblk_t idx_pblock(struct ext4_extent_idx *);
+#define idx_pblock(inode, eh)	\
+	__idx_pblock(__func__, inode, eh)
+extern ext4_fsblk_t __idx_pblock(const char *function, struct inode *inode,
+				 struct ext4_extent_idx *);
 extern void ext4_ext_store_pblock(struct ext4_extent *, ext4_fsblk_t);
 extern int ext4_extent_tree_init(handle_t *, struct inode *);
 extern int ext4_ext_calc_credits_for_single_extent(struct inode *inode,
Only in linux-2.6.29/fs/ext4: ext4_extents.h~
diff -ru download/linux-2.6.29-rc2-vanilla/fs/ext4/extents.c linux-2.6.29/fs/ext4/extents.c
--- download/linux-2.6.29-rc2-vanilla/fs/ext4/extents.c	2009-02-05 12:31:19.000000000 +0100
+++ linux-2.6.29/fs/ext4/extents.c	2009-02-07 14:41:16.000000000 +0100
@@ -45,29 +45,65 @@
 #include "ext4_extents.h"
 
 
+#define ext_pblock(inode, eh)	\
+	__ext_pblock(__func__, inode, eh)
+
 /*
  * ext_pblock:
- * combine low and high parts of physical block number into ext4_fsblk_t
+ * combine low and high parts of physical block number into ext4_fsblk_t and
+ * check whether the result lies inside the filesystem
  */
-static ext4_fsblk_t ext_pblock(struct ext4_extent *ex)
+static ext4_fsblk_t __ext_pblock(const char *function, struct inode *inode,
+				 struct ext4_extent *ex)
 {
+	struct ext4_super_block *esb = EXT4_SB(inode->i_sb)->s_es;
+	unsigned long long esb_first_block = esb->s_first_data_block;
+	unsigned long long esb_block_count = ext4_blocks_count(esb);
+	int extlen;
 	ext4_fsblk_t block;
 
 	block = le32_to_cpu(ex->ee_start_lo);
 	block |= ((ext4_fsblk_t) le16_to_cpu(ex->ee_start_hi) << 31) << 1;
+
+        extlen = ext4_ext_get_actual_len(ex);     
+        if (unlikely(block < esb_first_block
+		     || esb_block_count < block + extlen)) {
+		ext4_error(inode->i_sb, function, ": "
+			   "extent data outside filesystem in inode #%lu: "
+			   "block=%llu, len=%i, sb block_count=%llu\n",
+			   inode->i_ino, 
+			   block, extlen, esb_block_count);
+		return 0;
+	}
+
 	return block;
 }
 
 /*
  * idx_pblock:
  * combine low and high parts of a leaf physical block number into ext4_fsblk_t
+ * and check whether the result lies inside the filesystem
  */
-ext4_fsblk_t idx_pblock(struct ext4_extent_idx *ix)
+ext4_fsblk_t __idx_pblock(const char *function, struct inode *inode,
+			  struct ext4_extent_idx *ix)
 {
+	struct ext4_super_block *esb = EXT4_SB(inode->i_sb)->s_es;
+	unsigned long long esb_first_block = esb->s_first_data_block;
+	unsigned long long esb_block_count = ext4_blocks_count(esb);
 	ext4_fsblk_t block;
 
 	block = le32_to_cpu(ix->ei_leaf_lo);
 	block |= ((ext4_fsblk_t) le16_to_cpu(ix->ei_leaf_hi) << 31) << 1;
+
+	if (unlikely(block < esb_first_block || esb_block_count < block)) {
+		ext4_error(inode->i_sb, function, ": "
+			   "extent index outside filesystem in inode #%lu: "
+			   "block=%llu, sb block_count=%llu\n",
+			   inode->i_ino, 
+			   block, esb_block_count);
+		return 0;
+        }
+
 	return block;
 }
 
@@ -161,7 +197,8 @@
 		/* try to predict block placement */
 		ex = path[depth].p_ext;
 		if (ex)
-			return ext_pblock(ex)+(block-le32_to_cpu(ex->ee_block));
+			return ext_pblock(inode, ex)
+				+ (block-le32_to_cpu(ex->ee_block));
 
 		/* it looks like index is empty;
 		 * try to find starting block from index itself */
@@ -354,12 +391,12 @@
 	for (k = 0; k <= l; k++, path++) {
 		if (path->p_idx) {
 		  ext_debug("  %d->%llu", le32_to_cpu(path->p_idx->ei_block),
-			    idx_pblock(path->p_idx));
+			    idx_pblock(inode, path->p_idx));
 		} else if (path->p_ext) {
 			ext_debug("  %d:%d:%llu ",
 				  le32_to_cpu(path->p_ext->ee_block),
 				  ext4_ext_get_actual_len(path->p_ext),
-				  ext_pblock(path->p_ext));
+				  ext_pblock(inode, path->p_ext));
 		} else
 			ext_debug("  []");
 	}
@@ -381,7 +418,7 @@
 
 	for (i = 0; i < le16_to_cpu(eh->eh_entries); i++, ex++) {
 		ext_debug("%d:%d:%llu ", le32_to_cpu(ex->ee_block),
-			  ext4_ext_get_actual_len(ex), ext_pblock(ex));
+			  ext4_ext_get_actual_len(ex), ext_pblock(inode, ex));
 	}
 	ext_debug("\n");
 }
@@ -432,7 +469,7 @@
 
 	path->p_idx = l - 1;
 	ext_debug("  -> %d->%lld ", le32_to_cpu(path->p_idx->ei_block),
-		  idx_pblock(path->p_idx));
+		  idx_pblock(inode, path->p_idx));
 
 #ifdef CHECK_BINSEARCH
 	{
@@ -501,7 +538,7 @@
 	path->p_ext = l - 1;
 	ext_debug("  -> %d:%llu:%d ",
 			le32_to_cpu(path->p_ext->ee_block),
-			ext_pblock(path->p_ext),
+			ext_pblock(inode, path->p_ext),
 			ext4_ext_get_actual_len(path->p_ext));
 
 #ifdef CHECK_BINSEARCH
@@ -569,7 +606,7 @@
 			  ppos, le16_to_cpu(eh->eh_entries), le16_to_cpu(eh->eh_max));
 
 		ext4_ext_binsearch_idx(inode, path + ppos, block);
-		path[ppos].p_block = idx_pblock(path[ppos].p_idx);
+		path[ppos].p_block = idx_pblock(inode, path[ppos].p_idx);
 		path[ppos].p_depth = i;
 		path[ppos].p_ext = NULL;
 
@@ -596,7 +633,7 @@
 	ext4_ext_binsearch(inode, path + ppos, block);
 	/* if not an empty leaf */
 	if (path[ppos].p_ext)
-		path[ppos].p_block = ext_pblock(path[ppos].p_ext);
+		path[ppos].p_block = ext_pblock(inode, path[ppos].p_ext);
 
 	ext4_ext_show_path(inode, path);
 
@@ -765,7 +802,7 @@
 			EXT_MAX_EXTENT(path[depth].p_hdr)) {
 		ext_debug("move %d:%llu:%d in new leaf %llu\n",
 				le32_to_cpu(path[depth].p_ext->ee_block),
-				ext_pblock(path[depth].p_ext),
+				ext_pblock(inode, path[depth].p_ext),
 				ext4_ext_get_actual_len(path[depth].p_ext),
 				newblock);
 		/*memmove(ex++, path[depth].p_ext++,
@@ -844,7 +881,7 @@
 		while (path[i].p_idx <= EXT_MAX_INDEX(path[i].p_hdr)) {
 			ext_debug("%d: move %d:%llu in new index %llu\n", i,
 					le32_to_cpu(path[i].p_idx->ei_block),
-					idx_pblock(path[i].p_idx),
+					idx_pblock(inode, path[i].p_idx),
 					newblock);
 			/*memmove(++fidx, path[i].p_idx++,
 					sizeof(struct ext4_extent_idx));
@@ -983,7 +1020,7 @@
 	fidx = EXT_FIRST_INDEX(neh);
 	ext_debug("new root: num %d(%d), lblock %d, ptr %llu\n",
 		  le16_to_cpu(neh->eh_entries), le16_to_cpu(neh->eh_max),
-		  le32_to_cpu(fidx->ei_block), idx_pblock(fidx));
+		  le32_to_cpu(fidx->ei_block), idx_pblock(inode, fidx));
 
 	neh->eh_depth = cpu_to_le16(path->p_depth + 1);
 	err = ext4_ext_dirty(handle, inode, curp);
@@ -1102,7 +1139,7 @@
 	BUG_ON(*logical < (le32_to_cpu(ex->ee_block) + ee_len));
 
 	*logical = le32_to_cpu(ex->ee_block) + ee_len - 1;
-	*phys = ext_pblock(ex) + ee_len - 1;
+	*phys = ext_pblock(inode, ex) + ee_len - 1;
 	return 0;
 }
 
@@ -1144,7 +1181,7 @@
 			BUG_ON(ix != EXT_FIRST_INDEX(path[depth].p_hdr));
 		}
 		*logical = le32_to_cpu(ex->ee_block);
-		*phys = ext_pblock(ex);
+		*phys = ext_pblock(inode, ex);
 		return 0;
 	}
 
@@ -1154,7 +1191,7 @@
 		/* next allocated block in this leaf */
 		ex++;
 		*logical = le32_to_cpu(ex->ee_block);
-		*phys = ext_pblock(ex);
+		*phys = ext_pblock(inode, ex);
 		return 0;
 	}
 
@@ -1173,7 +1210,7 @@
 	 * follow it and find the closest allocated
 	 * block to the right */
 	ix++;
-	block = idx_pblock(ix);
+	block = idx_pblock(inode, ix);
 	while (++depth < path->p_depth) {
 		bh = sb_bread(inode->i_sb, block);
 		if (bh == NULL)
@@ -1184,7 +1221,7 @@
 			return -EIO;
 		}
 		ix = EXT_FIRST_INDEX(eh);
-		block = idx_pblock(ix);
+		block = idx_pblock(inode, ix);
 		put_bh(bh);
 	}
 
@@ -1198,7 +1235,7 @@
 	}
 	ex = EXT_FIRST_EXTENT(eh);
 	*logical = le32_to_cpu(ex->ee_block);
-	*phys = ext_pblock(ex);
+	*phys = ext_pblock(inode, ex);
 	put_bh(bh);
 	return 0;
 }
@@ -1365,7 +1402,7 @@
 		return 0;
 #endif
 
-	if (ext_pblock(ex1) + ext1_ee_len == ext_pblock(ex2))
+	if (ext_pblock(inode, ex1) + ext1_ee_len == ext_pblock(inode, ex2))
 		return 1;
 	return 0;
 }
@@ -1494,7 +1531,8 @@
 		ext_debug("append %d block to %d:%d (from %llu)\n",
 				ext4_ext_get_actual_len(newext),
 				le32_to_cpu(ex->ee_block),
-				ext4_ext_get_actual_len(ex), ext_pblock(ex));
+				ext4_ext_get_actual_len(ex),
+				ext_pblock(inode, ex));
 		err = ext4_ext_get_access(handle, inode, path + depth);
 		if (err)
 			return err;
@@ -1564,7 +1602,7 @@
 		/* there is no extent in this leaf, create first one */
 		ext_debug("first extent in the leaf: %d:%llu:%d\n",
 				le32_to_cpu(newext->ee_block),
-				ext_pblock(newext),
+				ext_pblock(inode, newext),
 				ext4_ext_get_actual_len(newext));
 		path[depth].p_ext = EXT_FIRST_EXTENT(eh);
 	} else if (le32_to_cpu(newext->ee_block)
@@ -1577,7 +1615,7 @@
 			ext_debug("insert %d:%llu:%d after: nearest 0x%p, "
 					"move %d from 0x%p to 0x%p\n",
 					le32_to_cpu(newext->ee_block),
-					ext_pblock(newext),
+					ext_pblock(inode, newext),
 					ext4_ext_get_actual_len(newext),
 					nearex, len, nearex + 1, nearex + 2);
 			memmove(nearex + 2, nearex + 1, len);
@@ -1590,7 +1628,7 @@
 		ext_debug("insert %d:%llu:%d before: nearest 0x%p, "
 				"move %d from 0x%p to 0x%p\n",
 				le32_to_cpu(newext->ee_block),
-				ext_pblock(newext),
+				ext_pblock(inode, newext),
 				ext4_ext_get_actual_len(newext),
 				nearex, len, nearex + 1, nearex + 2);
 		memmove(nearex + 1, nearex, len);
@@ -1600,7 +1638,7 @@
 	le16_add_cpu(&eh->eh_entries, 1);
 	nearex = path[depth].p_ext;
 	nearex->ee_block = newext->ee_block;
-	ext4_ext_store_pblock(nearex, ext_pblock(newext));
+	ext4_ext_store_pblock(nearex, ext_pblock(inode, newext));
 	nearex->ee_len = newext->ee_len;
 
 merge:
@@ -1697,7 +1735,7 @@
 		} else {
 			cbex.ec_block = le32_to_cpu(ex->ee_block);
 			cbex.ec_len = ext4_ext_get_actual_len(ex);
-			cbex.ec_start = ext_pblock(ex);
+			cbex.ec_start = ext_pblock(inode, ex);
 			cbex.ec_type = EXT4_EXT_CACHE_EXTENT;
 		}
 
@@ -1837,7 +1875,7 @@
 
 	/* free index block */
 	path--;
-	leaf = idx_pblock(path->p_idx);
+	leaf = idx_pblock(inode, path->p_idx);
 	BUG_ON(path->p_hdr->eh_entries == 0);
 	err = ext4_ext_get_access(handle, inode, path);
 	if (err)
@@ -1943,7 +1981,7 @@
 		ext4_fsblk_t start;
 
 		num = le32_to_cpu(ex->ee_block) + ee_len - from;
-		start = ext_pblock(ex) + ee_len - num;
+		start = ext_pblock(inode, ex) + ee_len - num;
 		ext_debug("free last %u blocks starting %llu\n", num, start);
 		for (i = 0; i < num; i++) {
 			bh = sb_find_get_block(inode->i_sb, start + i);
@@ -2069,7 +2107,7 @@
 			goto out;
 
 		ext_debug("new extent: %u:%u:%llu\n", block, num,
-				ext_pblock(ex));
+				ext_pblock(inode, ex));
 		ex--;
 		ex_ee_block = le32_to_cpu(ex->ee_block);
 		ex_ee_len = ext4_ext_get_actual_len(ex);
@@ -2177,9 +2215,9 @@
 			struct buffer_head *bh;
 			/* go to the next level */
 			ext_debug("move to level %d (block %llu)\n",
-				  i + 1, idx_pblock(path[i].p_idx));
+				  i + 1, idx_pblock(inode, path[i].p_idx));
 			memset(path + i + 1, 0, sizeof(*path));
-			bh = sb_bread(sb, idx_pblock(path[i].p_idx));
+			bh = sb_bread(sb, idx_pblock(inode, path[i].p_idx));
 			if (!bh) {
 				/* should we reset i_size? */
 				err = -EIO;
@@ -2306,7 +2344,7 @@
 	blkbits   = inode->i_blkbits;
 	blocksize = inode->i_sb->s_blocksize;
 	ee_len    = ext4_ext_get_actual_len(ex);
-	ee_pblock = ext_pblock(ex);
+	ee_pblock = ext_pblock(inode, ex);
 
 	/* convert ee_pblock to 512 byte sectors */
 	ee_pblock = ee_pblock << (blkbits - 9);
@@ -2396,11 +2434,11 @@
 	ee_block = le32_to_cpu(ex->ee_block);
 	ee_len = ext4_ext_get_actual_len(ex);
 	allocated = ee_len - (iblock - ee_block);
-	newblock = iblock - ee_block + ext_pblock(ex);
+	newblock = iblock - ee_block + ext_pblock(inode, ex);
 	ex2 = ex;
 	orig_ex.ee_block = ex->ee_block;
 	orig_ex.ee_len   = cpu_to_le16(ee_len);
-	ext4_ext_store_pblock(&orig_ex, ext_pblock(ex));
+	ext4_ext_store_pblock(&orig_ex, ext_pblock(inode, ex));
 
 	err = ext4_ext_get_access(handle, inode, path + depth);
 	if (err)
@@ -2413,7 +2451,7 @@
 		/* update the extent length and mark as initialized */
 		ex->ee_block = orig_ex.ee_block;
 		ex->ee_len   = orig_ex.ee_len;
-		ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
+		ext4_ext_store_pblock(ex, ext_pblock(inode, &orig_ex));
 		ext4_ext_dirty(handle, inode, path + depth);
 		/* zeroed the full extent */
 		return allocated;
@@ -2448,7 +2486,7 @@
 			ex->ee_block = orig_ex.ee_block;
 			ex->ee_len   = cpu_to_le16(ee_len - allocated);
 			ext4_ext_mark_uninitialized(ex);
-			ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
+			ext4_ext_store_pblock(ex, ext_pblock(inode, &orig_ex));
 			ext4_ext_dirty(handle, inode, path + depth);
 
 			ex3 = &newex;
@@ -2462,7 +2500,7 @@
 					goto fix_extent_len;
 				ex->ee_block = orig_ex.ee_block;
 				ex->ee_len   = orig_ex.ee_len;
-				ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
+				ext4_ext_store_pblock(ex, ext_pblock(inode, &orig_ex));
 				ext4_ext_dirty(handle, inode, path + depth);
 				/* blocks available from iblock */
 				return allocated;
@@ -2519,7 +2557,7 @@
 			/* update the extent length and mark as initialized */
 			ex->ee_block = orig_ex.ee_block;
 			ex->ee_len   = orig_ex.ee_len;
-			ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
+			ext4_ext_store_pblock(ex, ext_pblock(inode, &orig_ex));
 			ext4_ext_dirty(handle, inode, path + depth);
 			/* zeroed the full extent */
 			/* blocks available from iblock */
@@ -2568,7 +2606,7 @@
 			/* update the extent length and mark as initialized */
 			ex->ee_block = orig_ex.ee_block;
 			ex->ee_len   = orig_ex.ee_len;
-			ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
+			ext4_ext_store_pblock(ex, ext_pblock(inode, &orig_ex));
 			ext4_ext_dirty(handle, inode, path + depth);
 			/* zero out the first half */
 			/* blocks available from iblock */
@@ -2637,7 +2675,7 @@
 		/* update the extent length and mark as initialized */
 		ex->ee_block = orig_ex.ee_block;
 		ex->ee_len   = orig_ex.ee_len;
-		ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
+		ext4_ext_store_pblock(ex, ext_pblock(inode, &orig_ex));
 		ext4_ext_dirty(handle, inode, path + depth);
 		/* zero out the first half */
 		return allocated;
@@ -2649,7 +2687,7 @@
 fix_extent_len:
 	ex->ee_block = orig_ex.ee_block;
 	ex->ee_len   = orig_ex.ee_len;
-	ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
+	ext4_ext_store_pblock(ex, ext_pblock(inode, &orig_ex));
 	ext4_ext_mark_uninitialized(ex);
 	ext4_ext_dirty(handle, inode, path + depth);
 	return err;
@@ -2707,7 +2745,7 @@
 			/* block is already allocated */
 			newblock = iblock
 				   - le32_to_cpu(newex.ee_block)
-				   + ext_pblock(&newex);
+				   + ext_pblock(inode, &newex);
 			/* number of remaining blocks in the extent */
 			allocated = ext4_ext_get_actual_len(&newex) -
 					(iblock - le32_to_cpu(newex.ee_block));
@@ -2738,7 +2776,7 @@
 	ex = path[depth].p_ext;
 	if (ex) {
 		ext4_lblk_t ee_block = le32_to_cpu(ex->ee_block);
-		ext4_fsblk_t ee_start = ext_pblock(ex);
+		ext4_fsblk_t ee_start = ext_pblock(inode, ex);
 		unsigned short ee_len;
 
 		/*
@@ -2864,13 +2902,13 @@
 		/* not a good idea to call discard here directly,
 		 * but otherwise we'd need to call it every free() */
 		ext4_discard_preallocations(inode);
-		ext4_free_blocks(handle, inode, ext_pblock(&newex),
+		ext4_free_blocks(handle, inode, ext_pblock(inode, &newex),
 					ext4_ext_get_actual_len(&newex), 0);
 		goto out2;
 	}
 
 	/* previous routine could use block we allocated */
-	newblock = ext_pblock(&newex);
+	newblock = ext_pblock(inode, &newex);
 	allocated = ext4_ext_get_actual_len(&newex);
 outnew:
 	if (extend_disksize) {
diff -ru download/linux-2.6.29-rc2-vanilla/fs/ext4/migrate.c linux-2.6.29/fs/ext4/migrate.c
--- download/linux-2.6.29-rc2-vanilla/fs/ext4/migrate.c	2009-02-05 12:31:20.000000000 +0100
+++ linux-2.6.29/fs/ext4/migrate.c	2009-02-07 14:24:37.000000000 +0100
@@ -404,7 +404,7 @@
 	struct buffer_head *bh;
 	struct ext4_extent_header *eh;
 
-	block = idx_pblock(ix);
+	block = idx_pblock(inode, ix);
 	bh = sb_bread(inode->i_sb, block);
 	if (!bh)
 		return -EIO;

--------------090601060903010504060907--
