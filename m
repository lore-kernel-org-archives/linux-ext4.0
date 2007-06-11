From: Valerie Clement <valerie.clement@bull.net>
Subject: [RFC][PATCH 8/12] 48-bit extents in e2fsprogs
Date: Mon, 11 Jun 2007 18:47:24 +0200
Message-ID: <466D7C9C.10500@bull.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000002090604020901020609"
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:48568 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743AbXFKQqC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Jun 2007 12:46:02 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is a multi-part message in MIME format.
--------------000002090604020901020609
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed

This patch contains the changes to support 48-bit block numbers in
extents.

This patch is not complete, the new function block_iterate_extents() was
not updated.

  e2fsck/pass1.c            |   15 +++++++++------
  lib/ext2fs/bmap.c         |    6 +++---
  lib/ext2fs/ext3_extents.h |   30 ++++++++++++++++++++++++++++++
  lib/ext2fs/extent.c       |   16 ++++++----------
  4 files changed, 48 insertions(+), 19 deletions(-)



--------------000002090604020901020609
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
 name="08-48bit-support-in-extents"
Content-Disposition: inline;
 filename="08-48bit-support-in-extents"

Index: e2fsprogs-1.39-tyt3-v6/lib/ext2fs/extent.c
===================================================================
--- e2fsprogs-1.39-tyt3-v6.orig/lib/ext2fs/extent.c	2007-06-11 12:48:52.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v6/lib/ext2fs/extent.c	2007-06-11 12:48:57.000000000 +0200
@@ -105,8 +105,7 @@ errcode_t ext2fs_extent_verify(ext2_fils
 			       struct ext3_extent_idx *ix, int ix_len)
 {
 	ext_show_extent(ex);
-	/* FIXME: 48-bit support */
-	if (ex->ee_start > EXT2_BLOCKS_COUNT(fs->super))
+	if (EXT4_EE_START(ex) > EXT2_BLOCKS_COUNT(fs->super))
 		return EXT2_ET_EXTENT_LEAF_BAD;
 
 	if (ex->ee_len == 0)
@@ -120,19 +119,18 @@ errcode_t ext2fs_extent_verify(ext2_fils
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
 
@@ -148,8 +146,7 @@ errcode_t ext2fs_extent_index_verify(ext
 				     struct ext3_extent_idx *ix_prev)
 {
 	ext_show_index(ix);
-	/* FIXME: 48-bit support */
-	if (ix->ei_leaf > EXT2_BLOCKS_COUNT(fs->super))
+	if (EXT4_EI_LEAF(ix) > EXT2_BLOCKS_COUNT(fs->super))
 		return EXT2_ET_EXTENT_INDEX_BAD;
 
 	if (ix_prev == NULL)
@@ -193,10 +190,9 @@ errcode_t ext2fs_extent_split_internal(s
 	++eh->eh_entries;
 
 	ex->ee_len = offs;
-	/* FIXME: 48-bit support */
 	ex_new->ee_len -= offs;
 	ex_new->ee_block += offs;
-	ex_new->ee_start += offs;
+	EXT4_EE_START_SET(ex_new, EXT4_EE_START(ex_new) + offs);
 
 	return 0;
 }
Index: e2fsprogs-1.39-tyt3-v6/lib/ext2fs/ext3_extents.h
===================================================================
--- e2fsprogs-1.39-tyt3-v6.orig/lib/ext2fs/ext3_extents.h	2007-06-11 12:48:33.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v6/lib/ext2fs/ext3_extents.h	2007-06-11 12:48:57.000000000 +0200
@@ -87,6 +87,36 @@ struct ext3_extent_idx {
 	__u16	ei_unused;
 };
 
+#ifdef _EXT4FS_
+#define EXT4_EE_START(e) (((__u64)(e)->ee_start_hi << 32) + (e)->ee_start)
+#define EXT4_EI_LEAF(ix) (((__u64)(ix)->ei_leaf_hi << 32) + (ix)->ei_leaf)
+
+#define EXT4_EE_START_SET(e,blk)			\
+	do {						\
+		(e)->ee_start = (blk);			\
+		(e)->ee_start_hi = (blk) >> 32;		\
+	} while(0)
+
+#define EXT4_EI_LEAF_SET(e,blk)				\
+	do {						\
+		(ix)->ei_leaf = (blk);			\
+		(ix)->ei_leaf_hi = (blk) >> 32;		\
+	} while(0)
+#else
+#define EXT4_EE_START(e)	((e)->ee_start)
+#define EXT4_EI_LEAF(ix)	((ix)->ei_leaf)
+
+#define EXT4_EE_START_SET(e,blk)			\
+	do {						\
+		(e)->ee_start = (blk);			\
+	} while(0)
+
+#define EXT4_EI_LEAF_SET(e,blk)				\
+	do {						\
+		(ix)->ei_leaf = (blk);			\
+	} while(0)
+#endif
+
 /*
  * each block (leaves and indexes), even inode-stored has header
  */
Index: e2fsprogs-1.39-tyt3-v6/lib/ext2fs/bmap.c
===================================================================
--- e2fsprogs-1.39-tyt3-v6.orig/lib/ext2fs/bmap.c	2007-06-11 12:48:33.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v6/lib/ext2fs/bmap.c	2007-06-11 12:48:57.000000000 +0200
@@ -52,8 +52,8 @@ static errcode_t block_bmap_extents(void
 				continue;
 
 			if (block < ex->ee_block + ex->ee_len)
-				/* FIXME: 48-bit */
-				*phys_blk = ex->ee_start + block - ex->ee_block;
+				*phys_blk = EXT4_EE_START(ex) +
+					(block - ex->ee_block);
 
 			/* only the first extent > block could hold the block
 			 * otherwise the extents would overlap */
@@ -72,7 +72,7 @@ static errcode_t block_bmap_extents(void
 			if (block < ix->ei_block)
 				continue;
 
-			ret = io_channel_read_blk(fs->io, ix->ei_leaf, 1,
+			ret = io_channel_read_blk(fs->io, EXT4_EI_LEAF(ix), 1,
 						  block_buf);
 			if (ret)
 				goto free_buf;
Index: e2fsprogs-1.39-tyt3-v6/e2fsck/pass1.c
===================================================================
--- e2fsprogs-1.39-tyt3-v6.orig/e2fsck/pass1.c	2007-06-11 12:48:54.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v6/e2fsck/pass1.c	2007-06-11 12:48:57.000000000 +0200
@@ -1604,6 +1604,10 @@ static int e2fsck_ext_block_verify(struc
 	e2fsck_t ctx = p->ctx;
 	struct problem_context *pctx = p->pctx;
 	int i, problem = 0;
+	int flag_64bit;
+
+	flag_64bit = p->ctx->fs->super->s_feature_incompat &
+			EXT4_FEATURE_INCOMPAT_64BIT;
 
 	if (ext2fs_extent_header_verify(eh, buflen))
 		return PR_1_EXTENT_IDX_BAD;
@@ -1618,9 +1622,8 @@ static int e2fsck_ext_block_verify(struc
 		struct ext3_extent *ex = EXT_FIRST_EXTENT(eh), *ex_prev = NULL;
 
 		for (i = 0; i < eh->eh_entries; i++, ex++) {
-			/* FIXME: 48-bit check for s_blocks_count_hi */
-			if (ex->ee_start_hi && fix_problem(ctx, PR_1_EXTENT_HI,
-							   pctx)) {
+			if (!flag_64bit && ex->ee_start_hi &&
+				fix_problem(ctx, PR_1_EXTENT_HI, pctx)) {
 				ex->ee_start_hi = 0;
 				problem = PR_1_EXTENT_CHANGED;
 			}
@@ -1644,9 +1647,9 @@ static int e2fsck_ext_block_verify(struc
 		struct ext3_extent_idx *ix =EXT_FIRST_INDEX(eh), *ix_prev =NULL;
 
 		for (i = 0; i < eh->eh_entries; i++, ix++) {
-			/* FIXME: 48-bit check for s_blocks_count_hi */
-			if (ix->ei_leaf_hi && fix_problem(ctx, PR_1_EXTENT_HI,
-							  pctx)) {
+			if (!flag_64bit &&
+			    ix->ei_leaf_hi && 
+			    fix_problem(ctx, PR_1_EXTENT_HI, pctx)) {
 				ix->ei_leaf_hi = ix->ei_unused = 0;
 				problem = PR_1_EXTENT_CHANGED;
 			}

--------------000002090604020901020609--
