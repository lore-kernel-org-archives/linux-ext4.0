From: Alexandre Ratchov <alexandre.ratchov@bull.net>
Subject: [patch] 48bit extents in e2fsprogs
Date: Fri, 15 Sep 2006 14:05:40 +0200
Message-ID: <20060915120540.GA23824@openx1.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jean-Pierre Dion <jean-pierre.dion@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:26308 "EHLO
	ecfrec.frec.bull.fr") by vger.kernel.org with ESMTP
	id S1751319AbWIOMFu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 Sep 2006 08:05:50 -0400
Received: from localhost (localhost [127.0.0.1])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 1B35A19D90E
	for <linux-ext4@vger.kernel.org>; Fri, 15 Sep 2006 14:05:47 +0200 (CEST)
Received: from ecfrec.frec.bull.fr ([127.0.0.1])
 by localhost (ecfrec.frec.bull.fr [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 23714-07 for <linux-ext4@vger.kernel.org>;
 Fri, 15 Sep 2006 14:05:42 +0200 (CEST)
Received: from ecn002.frec.bull.fr (ecn002.frec.bull.fr [129.183.4.6])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 1FD7819D90B
	for <linux-ext4@vger.kernel.org>; Fri, 15 Sep 2006 14:05:42 +0200 (CEST)
To: linux-ext4@vger.kernel.org
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

hello, 

here is a patch that fixes 48bit extents in e2fsprogs. Basically, it wraps
acces to 48bit filds of extent indexes and leaves in macros, so 32bit fields
are no more (mis)used, see EXT3_EE_START and EXT3_EI_LEAF macros definitions.

the patch have to be applied on top of last patch set i've sent, see:
http://www.bullopensource.org/ext4/20060908/

tested on x86_64 on 20TB device.

cheers,

-- Alexandre

Signed-off-by: Alexandre Ratchov <alexandre.ratchov@bull.net>

Index: e2fsprogs-1.39/lib/ext2fs/extents.c
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/extents.c	2006-09-14 19:16:03.000000000 +0200
+++ e2fsprogs-1.39/lib/ext2fs/extents.c	2006-09-14 20:28:16.000000000 +0200
@@ -72,8 +72,7 @@ errcode_t ext2fs_extent_verify(ext2_fils
 			       struct ext3_extent_idx *ix, int ix_len)
 {
 	show_extent(ex);
-	/* FIXME: 48-bit support */
-	if (ex->ee_start > fs->super->s_blocks_count)
+	if (EXT3_EE_START(ex) > EXT2_BLOCKS_COUNT(fs->super))
 		return EXT2_ET_EXTENT_LEAF_BAD;
 
 	if (ex->ee_len == 0)
@@ -84,19 +83,17 @@ errcode_t ext2fs_extent_verify(ext2_fils
 		if (ex->ee_block == 0)
 			return EXT2_ET_EXTENT_LEAF_BAD;
 
-		/* FIXME: 48-bit support */
 		/* extents must be in logical offset order */
 		if (ex->ee_block < ex_prev->ee_block + ex_prev->ee_len)
 			return EXT2_ET_EXTENT_LEAF_BAD;
 
 		/* extents must not overlap physical blocks */
-		if ((ex->ee_start < ex_prev->ee_start + ex_prev->ee_len) &&
-		    (ex->ee_start + ex->ee_len > ex_prev->ee_start))
+		if ((EXT3_EE_START(ex) < EXT3_EE_START(ex_prev) + ex_prev->ee_len) &&
+		    (EXT3_EE_START(ex) + ex->ee_len > EXT3_EE_START(ex_prev)))
 			return EXT2_ET_EXTENT_LEAF_BAD;
 	}
 
 	if (ix) {
-		/* FIXME: 48-bit support */
 		if (ex->ee_block < ix->ei_block)
 			return EXT2_ET_EXTENT_LEAF_BAD;
 
@@ -111,8 +108,7 @@ errcode_t ext2fs_extent_index_verify(ext
 				     struct ext3_extent_idx *ix_prev)
 {
 	show_index(ix);
-	/* FIXME: 48-bit support */
-	if (ix->ei_leaf > fs->super->s_blocks_count)
+	if (EXT3_EI_LEAF(ix) > EXT2_BLOCKS_COUNT(fs->super))
 		return EXT2_ET_EXTENT_INDEX_BAD;
 
 	if (ix_prev == NULL)
@@ -164,10 +160,9 @@ errcode_t ext2fs_extent_split(struct ext
 	++eh->eh_entries;
 
 	ex->ee_len = count;
-	/* FIXME: 48-bit support */
 	ex_new->ee_len -= count;
 	ex_new->ee_block += count;
-	ex_new->ee_start += count;
+	EXT3_EE_START_SET(ex_new, EXT3_EE_START(ex_new) + count);
 
 	return 0;
 }
@@ -200,7 +195,7 @@ int block_iterate_extents(struct ext3_ex
 		for (i = 0; i < eh->eh_entries; i++, ex++) {
 			show_extent(ex);
 			for (j = 0; j < ex->ee_len; j++) {
-				block_address = ex->ee_start + j;
+				block_address = EXT3_EE_START(ex) + j;
 				flags = (*ctx->func)(ctx->fs, &block_address,
 						     (ex->ee_block + j),
 						     ref_block, i,
@@ -214,15 +209,14 @@ int block_iterate_extents(struct ext3_ex
 
 #ifdef EXT_DEBUG
 				printf("ugh, extent leaf changed: "
-				       "block was %u+%u = %u, now %u\n",
-				       ex->ee_start, j,
-				       ex->ee_start + j, block_address);
+				       "block was %llu+%llu = %llu, now %llu\n",
+				       EXT3_EE_START(ex), j,
+				       EXT3_EE_START(ex) + j, block_address);
 #endif
 
-				/* FIXME: 48-bit support */
 				if (ex_prev &&
 				    block_address ==
-				    ex_prev->ee_start + ex_prev->ee_len &&
+				    EXT3_EE_START(ex_prev) + ex_prev->ee_len &&
 				    ex->ee_block + j ==
 				    ex_prev->ee_block + ex_prev->ee_len) {
 					/* can merge block with prev extent */
@@ -235,7 +229,8 @@ int block_iterate_extents(struct ext3_ex
 						i--; ex--;
 						break;
 					} else {
-						ex->ee_start++;
+						EXT3_EE_START_SET(
+							ex,  EXT3_EE_START(ex) + 1);
 						ex->ee_block++;
 						j--;
 					}
@@ -244,7 +239,7 @@ int block_iterate_extents(struct ext3_ex
 				} else if (ex->ee_len == 1) {
 					/* single-block extent is easy -
 					 * change extent directly */
-					ex->ee_start = block_address;
+					EXT3_EE_START_SET(ex, block_address);
 					ret |= BLOCK_CHANGED;
 
 				} else if (ext2fs_extent_split(eh, ex, j)) {
@@ -266,7 +261,7 @@ int block_iterate_extents(struct ext3_ex
 						ret |= BLOCK_ABORT |BLOCK_ERROR;
 						return ret;
 					}
-					ex->ee_start = block_address;
+					EXT3_EE_START_SET(ex, block_address);
 					ret |= BLOCK_CHANGED;
 
 				} else {
@@ -277,7 +272,7 @@ int block_iterate_extents(struct ext3_ex
 						ret |= BLOCK_ABORT |BLOCK_ERROR;
 						return ret;
 					}
-					ex->ee_start = block_address;
+					EXT3_EE_START_SET(ex, block_address);
 					ret |= BLOCK_CHANGED;
 				}
 			}
@@ -287,6 +282,7 @@ int block_iterate_extents(struct ext3_ex
 		char *block_buf;
 		struct ext3_extent_idx *ix;
 		struct ext3_extent_header *nh;
+		blk_t leaf;
 
 		ret = ext2fs_get_mem(ctx->fs->blocksize, &block_buf);
 		if (ret)
@@ -298,15 +294,16 @@ int block_iterate_extents(struct ext3_ex
 			show_index(ix);
 			if (!(ctx->flags & BLOCK_FLAG_DEPTH_TRAVERSE) &&
 			    !(ctx->flags & BLOCK_FLAG_DATA_ONLY)) {
-				ret |= (*ctx->func)(ctx->fs, &ix->ei_leaf,
+				leaf = EXT3_EI_LEAF(ix);
+				ret |= (*ctx->func)(ctx->fs, &leaf,
 						    BLOCK_COUNT_IND, ref_block,
 						    i, ctx->priv_data);
+				EXT3_EI_LEAF_SET(ix, leaf);
 				if (ret & BLOCK_ABORT)
 					goto free_buf;
 			}
-			ctx->errcode = ext2fs_read_ext_block(ctx->fs,
-							     ix->ei_leaf,
-							     block_buf);
+			ctx->errcode = ext2fs_read_ext_block(
+				ctx->fs, EXT3_EI_LEAF(ix), block_buf);
 			if (ctx->errcode) {
 				ret |= BLOCK_ERROR;
 				goto free_buf;
@@ -316,21 +313,23 @@ int block_iterate_extents(struct ext3_ex
 				ret |= BLOCK_ERROR;
 				goto free_buf;
 			}
-			flags = block_iterate_extents(nh, ix->ei_leaf, i, ctx);
+			flags = block_iterate_extents(nh, EXT3_EI_LEAF(ix), i, ctx);
 			if (flags & BLOCK_CHANGED)
 				ctx->errcode =
-					ext2fs_write_ext_block(ctx->fs,
-							       ix->ei_leaf,
-							       block_buf);
+					ext2fs_write_ext_block(
+						ctx->fs, EXT3_EI_LEAF(ix), block_buf);
 			if (flags & BLOCK_ABORT) {
 				ret |= BLOCK_ABORT;
 				goto free_buf;
 			}
 			if ((ctx->flags & BLOCK_FLAG_DEPTH_TRAVERSE) &&
-			    !(ctx->flags & BLOCK_FLAG_DATA_ONLY))
-				ret |= (*ctx->func)(ctx->fs, &ix->ei_leaf,
+			    !(ctx->flags & BLOCK_FLAG_DATA_ONLY)) {
+				leaf = EXT3_EI_LEAF(ix);
+				ret |= (*ctx->func)(ctx->fs, &leaf,
 						     BLOCK_COUNT_IND, ref_block,
 						     i, ctx->priv_data);
+				EXT3_EI_LEAF_SET(ix, leaf);
+			}
 		}
 
 	free_buf:
Index: e2fsprogs-1.39/lib/ext2fs/ext3_extents.h
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/ext3_extents.h	2006-09-08 19:04:46.000000000 +0200
+++ e2fsprogs-1.39/lib/ext2fs/ext3_extents.h	2006-09-14 20:29:13.000000000 +0200
@@ -75,6 +75,13 @@ struct ext3_extent {
 	__u32	ee_start;	/* low 32 bigs of physical block */
 };
 
+#define EXT3_EE_START(e) (((blk_t)(e)->ee_start_hi << 32) + (e)->ee_start)
+#define EXT3_EE_START_SET(e,blk)		\
+do {						\
+	(e)->ee_start = (__u32)(blk);		\
+	(e)->ee_start_hi = (blk) >> 32;		\
+} while(0)
+
 /*
  * this is index on-disk structure
  * it's used at all the levels, but the bottom
@@ -87,6 +94,13 @@ struct ext3_extent_idx {
 	__u16	ei_unused;
 };
 
+#define EXT3_EI_LEAF(ix) (((blk_t)(ix)->ei_leaf_hi << 32) + (ix)->ei_leaf)
+#define EXT3_EI_LEAF_SET(e,blk)			\
+do {						\
+	(ix)->ei_leaf = (__u32)(blk);		\
+	(ix)->ei_leaf_hi = (blk) >> 32;		\
+} while(0)
+
 /*
  * each block (leaves and indexes), even inode-stored has header
  */
Index: e2fsprogs-1.39/lib/ext2fs/bmap.c
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/bmap.c	2006-09-08 19:04:46.000000000 +0200
+++ e2fsprogs-1.39/lib/ext2fs/bmap.c	2006-09-14 20:22:20.000000000 +0200
@@ -46,7 +46,7 @@ static errcode_t block_bmap_extents(stru
 		for (i = 0; i < eh->eh_entries; i++, ex++) {
 			if ((ex->ee_block <= block) &&
 			    (block < ex->ee_block + ex->ee_len)) {
-				*phys_blk = ex->ee_start +
+				*phys_blk = EXT3_EE_START(ex) +
 					(block - ex->ee_block);
 				return 0;
 			}
@@ -68,7 +68,7 @@ static errcode_t block_bmap_extents(stru
 			if (ix->ei_block < block)
 				continue;
 
-			ret = io_channel_read_blk(fs->io, ix->ei_leaf, 1,
+			ret = io_channel_read_blk(fs->io, EXT3_EI_LEAF(ix), 1,
 						  block_buf);
 			if (ret) {
 				ret = BLOCK_ERROR;
