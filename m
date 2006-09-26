From: Alexandre Ratchov <alexandre.ratchov@bull.net>
Subject: [patch 10/12] rfc: 2fsprogs update
Date: Tue, 26 Sep 2006 16:50:04 +0200
Message-ID: <20060926145004.GJ25755@openx1.frec.bull.fr>
References: <20060926143343.GA20020@openx1.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jean-Pierre Dion <jean-pierre.dion@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:36490 "EHLO
	ecfrec.frec.bull.fr") by vger.kernel.org with ESMTP id S932105AbWIZOuN
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Sep 2006 10:50:13 -0400
Received: from localhost (localhost [127.0.0.1])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 33F7A19D915
	for <linux-ext4@vger.kernel.org>; Tue, 26 Sep 2006 16:50:09 +0200 (CEST)
Received: from ecfrec.frec.bull.fr ([127.0.0.1])
 by localhost (ecfrec.frec.bull.fr [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 12488-06 for <linux-ext4@vger.kernel.org>;
 Tue, 26 Sep 2006 16:50:06 +0200 (CEST)
Received: from ecn002.frec.bull.fr (ecn002.frec.bull.fr [129.183.4.6])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id D379219D90C
	for <linux-ext4@vger.kernel.org>; Tue, 26 Sep 2006 16:50:05 +0200 (CEST)
To: linux-ext4@vger.kernel.org
In-Reply-To: <20060926143343.GA20020@openx1.frec.bull.fr>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

use 48bit block numbers in extents

Signed-off-by: Alexandre Ratchov <alexandre.ratchov@bull.net>              

Index: e2fsprogs-1.39/lib/ext2fs/extents.c
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/extents.c	2006-09-22 20:26:55.000000000 +0200
+++ e2fsprogs-1.39/lib/ext2fs/extents.c	2006-09-22 20:27:12.000000000 +0200
@@ -72,8 +72,7 @@ errcode_t ext2fs_extent_verify(ext2_fils
 			       struct ext4_extent_idx *ix, int ix_len)
 {
 	show_extent(ex);
-	/* FIXME: 48-bit support */
-	if (ex->ee_start > fs->super->s_blocks_count)
+	if (EXT4_EE_START(ex) > EXT2_BLOCKS_COUNT(fs->super))
 		return EXT2_ET_EXTENT_LEAF_BAD;
 
 	if (ex->ee_len == 0)
@@ -84,19 +83,18 @@ errcode_t ext2fs_extent_verify(ext2_fils
 		if (ex->ee_block == 0)
 			return EXT2_ET_EXTENT_LEAF_BAD;
 
-		/* FIXME: 48-bit support */
 		/* extents must be in logical offset order */
 		if (ex->ee_block < ex_prev->ee_block + ex_prev->ee_len)
 			return EXT2_ET_EXTENT_LEAF_BAD;
 
 		/* extents must not overlap physical blocks */
-		if ((ex->ee_start < ex_prev->ee_start + ex_prev->ee_len) &&
-		    (ex->ee_start + ex->ee_len > ex_prev->ee_start))
+		if ((EXT4_EE_START(ex) < 
+		     EXT4_EE_START(ex_prev) + ex_prev->ee_len) &&
+		    (EXT4_EE_START(ex) + ex->ee_len > EXT4_EE_START(ex_prev)))
 			return EXT2_ET_EXTENT_LEAF_BAD;
 	}
 
 	if (ix) {
-		/* FIXME: 48-bit support */
 		if (ex->ee_block < ix->ei_block)
 			return EXT2_ET_EXTENT_LEAF_BAD;
 
@@ -111,8 +109,7 @@ errcode_t ext2fs_extent_index_verify(ext
 				     struct ext4_extent_idx *ix_prev)
 {
 	show_index(ix);
-	/* FIXME: 48-bit support */
-	if (ix->ei_leaf > fs->super->s_blocks_count)
+	if (EXT4_EI_LEAF(ix) > EXT2_BLOCKS_COUNT(fs->super))
 		return EXT2_ET_EXTENT_INDEX_BAD;
 
 	if (ix_prev == NULL)
@@ -164,10 +161,9 @@ errcode_t ext2fs_extent_split(struct ext
 	++eh->eh_entries;
 
 	ex->ee_len = count;
-	/* FIXME: 48-bit support */
 	ex_new->ee_len -= count;
 	ex_new->ee_block += count;
-	ex_new->ee_start += count;
+	EXT4_EE_START_SET(ex_new, EXT4_EE_START(ex_new) + count);
 
 	return 0;
 }
@@ -200,7 +196,7 @@ int block_iterate_extents(struct ext4_ex
 		for (i = 0; i < eh->eh_entries; i++, ex++) {
 			show_extent(ex);
 			for (j = 0; j < ex->ee_len; j++) {
-				block_address = ex->ee_start + j;
+				block_address = EXT4_EE_START(ex) + j;
 				flags = (*ctx->func)(ctx->fs, &block_address,
 						     (ex->ee_block + j),
 						     ref_block, i,
@@ -214,15 +210,14 @@ int block_iterate_extents(struct ext4_ex
 
 #ifdef EXT_DEBUG
 				printf("ugh, extent leaf changed: "
-				       "block was %u+%u = %u, now %u\n",
-				       ex->ee_start, j,
-				       ex->ee_start + j, block_address);
+				       "block was %llu+%llu = %llu, now %llu\n",
+				       EXT4_EE_START(ex), j,
+				       EXT4_EE_START(ex) + j, block_address);
 #endif
 
-				/* FIXME: 48-bit support */
 				if (ex_prev &&
 				    block_address ==
-				    ex_prev->ee_start + ex_prev->ee_len &&
+				    EXT4_EE_START(ex_prev) + ex_prev->ee_len &&
 				    ex->ee_block + j ==
 				    ex_prev->ee_block + ex_prev->ee_len) {
 					/* can merge block with prev extent */
@@ -235,7 +230,9 @@ int block_iterate_extents(struct ext4_ex
 						i--; ex--;
 						break;
 					} else {
-						ex->ee_start++;
+						EXT4_EE_START_SET(
+							ex,  
+							EXT4_EE_START(ex) + 1);
 						ex->ee_block++;
 						j--;
 					}
@@ -244,7 +241,7 @@ int block_iterate_extents(struct ext4_ex
 				} else if (ex->ee_len == 1) {
 					/* single-block extent is easy -
 					 * change extent directly */
-					ex->ee_start = block_address;
+					EXT4_EE_START_SET(ex, block_address);
 					ret |= BLOCK_CHANGED;
 
 				} else if (ext2fs_extent_split(eh, ex, j)) {
@@ -266,7 +263,7 @@ int block_iterate_extents(struct ext4_ex
 						ret |= BLOCK_ABORT |BLOCK_ERROR;
 						return ret;
 					}
-					ex->ee_start = block_address;
+					EXT4_EE_START_SET(ex, block_address);
 					ret |= BLOCK_CHANGED;
 
 				} else {
@@ -277,7 +274,7 @@ int block_iterate_extents(struct ext4_ex
 						ret |= BLOCK_ABORT |BLOCK_ERROR;
 						return ret;
 					}
-					ex->ee_start = block_address;
+					EXT4_EE_START_SET(ex, block_address);
 					ret |= BLOCK_CHANGED;
 				}
 			}
@@ -287,6 +284,7 @@ int block_iterate_extents(struct ext4_ex
 		char *block_buf;
 		struct ext4_extent_idx *ix;
 		struct ext4_extent_header *nh;
+		blk_t leaf;
 
 		ret = ext2fs_get_mem(ctx->fs->blocksize, &block_buf);
 		if (ret)
@@ -298,39 +296,46 @@ int block_iterate_extents(struct ext4_ex
 			show_index(ix);
 			if (!(ctx->flags & BLOCK_FLAG_DEPTH_TRAVERSE) &&
 			    !(ctx->flags & BLOCK_FLAG_DATA_ONLY)) {
-				ret |= (*ctx->func)(ctx->fs, &ix->ei_leaf,
+				leaf = EXT4_EI_LEAF(ix);
+				ret |= (*ctx->func)(ctx->fs, &leaf,
 						    BLOCK_COUNT_IND, ref_block,
 						    i, ctx->priv_data);
+				EXT4_EI_LEAF_SET(ix, leaf);
 				if (ret & BLOCK_ABORT)
 					goto free_buf;
 			}
-			ctx->errcode = ext2fs_read_ext_block(ctx->fs,
-							     ix->ei_leaf,
-							     block_buf);
+			ctx->errcode = ext2fs_read_ext_block(
+				ctx->fs, EXT4_EI_LEAF(ix), block_buf);
 			if (ctx->errcode) {
 				ret |= BLOCK_ERROR;
 				goto free_buf;
 			}
 			nh = (struct ext4_extent_header *)block_buf;
-			if (ext2fs_extent_header_verify(nh,ctx->fs->blocksize)){
+			if (ext2fs_extent_header_verify(
+				    nh,ctx->fs->blocksize)) {
 				ret |= BLOCK_ERROR;
 				goto free_buf;
 			}
-			flags = block_iterate_extents(nh, ix->ei_leaf, i, ctx);
+			flags = block_iterate_extents(
+				nh, EXT4_EI_LEAF(ix), i, ctx);
 			if (flags & BLOCK_CHANGED)
 				ctx->errcode =
-					ext2fs_write_ext_block(ctx->fs,
-							       ix->ei_leaf,
-							       block_buf);
+					ext2fs_write_ext_block(
+						ctx->fs, EXT4_EI_LEAF(ix), 
+						block_buf);
 			if (flags & BLOCK_ABORT) {
 				ret |= BLOCK_ABORT;
 				goto free_buf;
 			}
 			if ((ctx->flags & BLOCK_FLAG_DEPTH_TRAVERSE) &&
-			    !(ctx->flags & BLOCK_FLAG_DATA_ONLY))
-				ret |= (*ctx->func)(ctx->fs, &ix->ei_leaf,
-						     BLOCK_COUNT_IND, ref_block,
-						     i, ctx->priv_data);
+			    !(ctx->flags & BLOCK_FLAG_DATA_ONLY)) {
+				leaf = EXT4_EI_LEAF(ix);
+				ret |= (*ctx->func)(ctx->fs, &leaf,
+						    BLOCK_COUNT_IND, 
+						    ref_block,
+						    i, ctx->priv_data);
+				EXT4_EI_LEAF_SET(ix, leaf);
+			}
 		}
 
 	free_buf:
Index: e2fsprogs-1.39/lib/ext2fs/ext4_extents.h
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/ext4_extents.h	2006-09-22 20:26:55.000000000 +0200
+++ e2fsprogs-1.39/lib/ext2fs/ext4_extents.h	2006-09-22 20:27:12.000000000 +0200
@@ -75,6 +75,13 @@ struct ext4_extent {
 	__u32	ee_start;	/* low 32 bigs of physical block */
 };
 
+#define EXT4_EE_START(e) (((__u64)(e)->ee_start_hi << 32) + (e)->ee_start)
+#define EXT4_EE_START_SET(e,blk)		\
+do {						\
+	(e)->ee_start = (blk);			\
+	(e)->ee_start_hi = (blk) >> 32;		\
+} while(0)
+
 /*
  * this is index on-disk structure
  * it's used at all the levels, but the bottom
@@ -87,6 +94,13 @@ struct ext4_extent_idx {
 	__u16	ei_unused;
 };
 
+#define EXT4_EI_LEAF(ix) (((__u64)(ix)->ei_leaf_hi << 32) + (ix)->ei_leaf)
+#define EXT4_EI_LEAF_SET(e,blk)			\
+do {						\
+	(ix)->ei_leaf = (blk);			\
+	(ix)->ei_leaf_hi = (blk) >> 32;		\
+} while(0)
+
 /*
  * each block (leaves and indexes), even inode-stored has header
  */
@@ -215,15 +229,22 @@ struct ext4_extents_helpers {
  * callback must return valid extent (passed or newly created)
  */
 typedef int (*ext_prepare_callback)(struct ext4_extents_tree *,
-					struct ext4_ext_path *,
-					struct ext4_extent *, int);
+				    struct ext4_ext_path *,
+				    struct ext4_extent *, int);
 void ext4_init_tree_desc(struct ext4_extents_tree *, struct inode *);
 extern int ext4_extent_tree_init(handle_t *, struct ext4_extents_tree *);
-extern int ext4_ext_calc_credits_for_insert(struct ext4_extents_tree *, struct ext4_ext_path *);
-extern int ext4_ext_insert_extent(handle_t *, struct ext4_extents_tree *, struct ext4_ext_path *, struct ext4_extent *);
-extern int ext4_ext_walk_space(struct ext4_extents_tree *, unsigned long, unsigned long, ext_prepare_callback);
-extern int ext4_ext_remove_space(struct ext4_extents_tree *, unsigned long, unsigned long);
-extern struct ext4_ext_path * ext4_ext_find_extent(struct ext4_extents_tree *, int, struct ext4_ext_path *);
+extern int ext4_ext_calc_credits_for_insert(struct ext4_extents_tree *, 
+					    struct ext4_ext_path *);
+extern int ext4_ext_insert_extent(handle_t *, struct ext4_extents_tree *, 
+				  struct ext4_ext_path *, 
+				  struct ext4_extent *);
+extern int ext4_ext_walk_space(struct ext4_extents_tree *, unsigned long, 
+			       unsigned long, ext_prepare_callback);
+extern int ext4_ext_remove_space(struct ext4_extents_tree *, unsigned long, 
+				 unsigned long);
+extern struct ext4_ext_path *ext4_ext_find_extent(struct ext4_extents_tree *,
+						  int, 
+						  struct ext4_ext_path *);
 
 static inline void
 ext4_ext_invalidate_cache(struct ext4_extents_tree *tree)
Index: e2fsprogs-1.39/lib/ext2fs/bmap.c
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/bmap.c	2006-09-22 20:26:55.000000000 +0200
+++ e2fsprogs-1.39/lib/ext2fs/bmap.c	2006-09-22 20:27:12.000000000 +0200
@@ -46,7 +46,7 @@ static errcode_t block_bmap_extents(stru
 		for (i = 0; i < eh->eh_entries; i++, ex++) {
 			if ((ex->ee_block <= block) &&
 			    (block < ex->ee_block + ex->ee_len)) {
-				*phys_blk = ex->ee_start +
+				*phys_blk = EXT4_EE_START(ex) +
 					(block - ex->ee_block);
 				return 0;
 			}
@@ -68,7 +68,7 @@ static errcode_t block_bmap_extents(stru
 			if (ix->ei_block < block)
 				continue;
 
-			ret = io_channel_read_blk(fs->io, ix->ei_leaf, 1,
+			ret = io_channel_read_blk(fs->io, EXT4_EI_LEAF(ix), 1,
 						  block_buf);
 			if (ret) {
 				ret = BLOCK_ERROR;
Index: e2fsprogs-1.39/e2fsck/pass1.c
===================================================================
--- e2fsprogs-1.39.orig/e2fsck/pass1.c	2006-09-22 20:26:55.000000000 +0200
+++ e2fsprogs-1.39/e2fsck/pass1.c	2006-09-22 20:27:37.000000000 +0200
@@ -1509,14 +1509,18 @@ static int e2fsck_ext_block_verify(struc
 	e2fsck_t ctx = p->ctx;
 	struct problem_context *pctx = p->pctx;
 	int i, bad = 0, changed = 0;
+	int flag_64bit;
+
+	flag_64bit = p->ctx->fs->super->s_feature_incompat & 
+		EXT4_FEATURE_INCOMPAT_64BIT;
 
 	if (eh->eh_depth == 0) {
 		struct ext4_extent *ex = EXT_FIRST_EXTENT(eh), *ex_prev = NULL;
 
 		for (i = 0; i < eh->eh_entries; i++, ex++) {
-			/* FIXME: 48-bit check for s_blocks_count_hi */
-			if (ex->ee_start_hi && fix_problem(ctx, PR_1_EXTENT_HI,
-							   pctx)) {
+			if (!flag_64bit &&
+			    ex->ee_start_hi && 
+			    fix_problem(ctx, PR_1_EXTENT_HI, pctx)) {
 				ex->ee_start_hi = 0;
 				changed++;
 			}
@@ -1541,9 +1545,9 @@ static int e2fsck_ext_block_verify(struc
 		struct ext4_extent_idx *ix =EXT_FIRST_INDEX(eh), *ix_prev =NULL;
 
 		for (i = 0; i < eh->eh_entries; i++, ix++) {
-			/* FIXME: 48-bit check for s_blocks_count_hi */
-			if (ix->ei_leaf_hi && fix_problem(ctx, PR_1_EXTENT_HI,
-							  pctx)) {
+			if (!flag_64bit &&
+			    ix->ei_leaf_hi && 
+			    fix_problem(ctx, PR_1_EXTENT_HI, pctx)) {
 				ix->ei_leaf_hi = ix->ei_unused = 0;
 				changed++;
 			}
