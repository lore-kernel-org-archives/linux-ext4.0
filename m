From: Alexandre Ratchov <alexandre.ratchov@bull.net>
Subject: [patch 04/12] rfc: 2fsprogs update
Date: Tue, 26 Sep 2006 16:47:16 +0200
Message-ID: <20060926144716.GD25755@openx1.frec.bull.fr>
References: <20060926143343.GA20020@openx1.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jean-Pierre Dion <jean-pierre.dion@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:36487 "EHLO
	ecfrec.frec.bull.fr") by vger.kernel.org with ESMTP id S932097AbWIZOrb
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Sep 2006 10:47:31 -0400
Received: from localhost (localhost [127.0.0.1])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 4E21E19D915
	for <linux-ext4@vger.kernel.org>; Tue, 26 Sep 2006 16:47:27 +0200 (CEST)
Received: from ecfrec.frec.bull.fr ([127.0.0.1])
 by localhost (ecfrec.frec.bull.fr [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 12225-07 for <linux-ext4@vger.kernel.org>;
 Tue, 26 Sep 2006 16:47:17 +0200 (CEST)
Received: from ecn002.frec.bull.fr (ecn002.frec.bull.fr [129.183.4.6])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 3012A19D90C
	for <linux-ext4@vger.kernel.org>; Tue, 26 Sep 2006 16:47:17 +0200 (CEST)
To: linux-ext4@vger.kernel.org
In-Reply-To: <20060926143343.GA20020@openx1.frec.bull.fr>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

from Andreas:

Support for checking 32-bit extents format inodes.

Clear the high 16 bits of extents and index entries, since the
extents patches did not do this explicitly.  Some parts of this
code need fixing for checking > 32-bit block filesystems,
marked "XXX: 48-bit".

Verify extent headers in blocks, logical ordering of extents,
logical ordering of indexes.

Add explicit checking of {d,t,}indirect and index blocks to detect
corruption instead of implicitly doing this by checking the referred
blocks and only block-at-a-time correctness.  This avoids incorrectly
invoking the very lengthy duplicate blocks pass for bad indirect/index
blocks.  We may want to tune the "threshold" for how many errors make
a "bad" indirect/index block.

Add ability to split or remove extents in order to allow extent
reallocation during the duplicate blocks pass.

NOTE: also attachment for tests/f_extents/image.gz (do not gunzip)

Index: e2fsprogs-1.39/e2fsck/Makefile.in
===================================================================
--- e2fsprogs-1.39.orig/e2fsck/Makefile.in	2006-03-27 07:44:11.000000000 +0200
+++ e2fsprogs-1.39/e2fsck/Makefile.in	2006-09-18 17:23:02.000000000 +0200
@@ -261,6 +261,7 @@ super.o: $(srcdir)/super.c $(top_srcdir)
 pass1.o: $(srcdir)/pass1.c $(srcdir)/e2fsck.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
  $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/ext2fs/ext2_fs.h \
+ $(top_srcdir)/lib/ext2fs/ext4_extents.h \
  $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
  $(top_builddir)/lib/ext2fs/ext2_err.h $(top_srcdir)/lib/ext2fs/bitops.h \
  $(top_srcdir)/lib/blkid/blkid.h $(top_builddir)/lib/blkid/blkid_types.h \
Index: e2fsprogs-1.39/e2fsck/e2fsck.h
===================================================================
--- e2fsprogs-1.39.orig/e2fsck/e2fsck.h	2006-09-18 16:55:08.000000000 +0200
+++ e2fsprogs-1.39/e2fsck/e2fsck.h	2006-09-18 17:24:28.000000000 +0200
@@ -327,6 +327,7 @@ struct e2fsck_struct {
 	__u32 large_files;
 	__u32 fs_ext_attr_inodes;
 	__u32 fs_ext_attr_blocks;
+	__u32 extent_files;
 
 	time_t now;
 
Index: e2fsprogs-1.39/e2fsck/pass1.c
===================================================================
--- e2fsprogs-1.39.orig/e2fsck/pass1.c	2006-09-18 17:14:00.000000000 +0200
+++ e2fsprogs-1.39/e2fsck/pass1.c	2006-09-18 17:23:02.000000000 +0200
@@ -46,6 +46,7 @@
 
 #include "e2fsck.h"
 #include <ext2fs/ext2_ext_attr.h>
+#include <ext2fs/ext4_extents.h>
 
 #include "problem.h"
 
@@ -79,7 +80,7 @@ static void adjust_extattr_refcount(e2fs
 struct process_block_struct {
 	ext2_ino_t	ino;
 	unsigned	is_dir:1, is_reg:1, clear:1, suppress:1,
-				fragmented:1, compressed:1, bbcheck:1;
+			fragmented:1, compressed:1, bbcheck:1, extent:1;
 	blk_t		num_blocks;
 	blk_t		max_blocks;
 	e2_blkcnt_t	last_block;
@@ -89,6 +90,7 @@ struct process_block_struct {
 	struct problem_context *pctx;
 	ext2fs_block_bitmap fs_meta_blocks;
 	e2fsck_t	ctx;
+	void		*block_buf;
 };
 
 struct process_inode_block {
@@ -137,7 +139,7 @@ int e2fsck_pass1_check_device_inode(ext2
 	 * this is a bogus device/fifo/socket
 	 */
 	if ((ext2fs_inode_data_blocks(fs, inode) != 0) ||
-	    (inode->i_flags & EXT2_INDEX_FL))
+	    (inode->i_flags & (EXT2_INDEX_FL | EXT4_EXTENTS_FL)))
 		return 0;
 
 	/*
@@ -171,7 +173,7 @@ int e2fsck_pass1_check_symlink(ext2_fils
 	blk_t	blocks;
 
 	if ((inode->i_size_high || inode->i_size == 0) ||
-	    (inode->i_flags & EXT2_INDEX_FL))
+	    (inode->i_flags & (EXT2_INDEX_FL | EXT4_EXTENTS_FL)))
 		return 0;
 
 	blocks = ext2fs_inode_data_blocks(fs, inode);
@@ -389,7 +391,8 @@ void e2fsck_pass1(e2fsck_t ctx)
 	struct		problem_context pctx;
 	struct		scan_callback_struct scan_struct;
 	struct ext2_super_block *sb = ctx->fs->super;
-	int		imagic_fs;
+	struct ext4_extent_header *eh;
+	int		imagic_fs, extent_fs;
 	int		busted_fs_time = 0;
 	int		inode_size;
 	
@@ -423,6 +426,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 #undef EXT2_BPP
 
 	imagic_fs = (sb->s_feature_compat & EXT2_FEATURE_COMPAT_IMAGIC_INODES);
+	extent_fs = (sb->s_feature_incompat & EXT4_FEATURE_INCOMPAT_EXTENTS);
 
 	/*
 	 * Allocate bitmaps structures
@@ -793,8 +797,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 				check_blocks(ctx, &pctx, block_buf);
 				continue;
 			}
-		}
-		else if (LINUX_S_ISFIFO (inode->i_mode) &&
+		} else if (LINUX_S_ISFIFO (inode->i_mode) &&
 			 e2fsck_pass1_check_device_inode(fs, inode)) {
 			check_immutable(ctx, &pctx);
 			check_size(ctx, &pctx);
@@ -806,21 +809,73 @@ void e2fsck_pass1(e2fsck_t ctx)
 			ctx->fs_sockets_count++;
 		} else
 			mark_inode_bad(ctx, ino);
-		if (inode->i_block[EXT2_IND_BLOCK])
-			ctx->fs_ind_count++;
-		if (inode->i_block[EXT2_DIND_BLOCK])
-			ctx->fs_dind_count++;
-		if (inode->i_block[EXT2_TIND_BLOCK])
-			ctx->fs_tind_count++;
-		if (inode->i_block[EXT2_IND_BLOCK] ||
-		    inode->i_block[EXT2_DIND_BLOCK] ||
-		    inode->i_block[EXT2_TIND_BLOCK] ||
-		    inode->i_file_acl) {
-			inodes_to_process[process_inode_count].ino = ino;
-			inodes_to_process[process_inode_count].inode = *inode;
-			process_inode_count++;
-		} else
-			check_blocks(ctx, &pctx, block_buf);
+
+		eh = (struct ext4_extent_header *)inode->i_block;
+		if ((inode->i_flags & EXT4_EXTENTS_FL)) {
+			if ((LINUX_S_ISREG(inode->i_mode) ||
+			     LINUX_S_ISDIR(inode->i_mode)) &&
+			    ext2fs_extent_header_verify(eh, EXT2_N_BLOCKS *
+							sizeof(__u32)) == 0) {
+				if (!extent_fs &&
+				    fix_problem(ctx,PR_1_EXTENT_FEATURE,&pctx)){
+					sb->s_feature_incompat |=
+						EXT4_FEATURE_INCOMPAT_EXTENTS;
+					ext2fs_mark_super_dirty(fs);
+					extent_fs = 1;
+				}
+			} else if (fix_problem(ctx, PR_1_SET_EXTENT_FL, &pctx)){
+				inode->i_flags &= ~EXT4_EXTENTS_FL;
+				e2fsck_write_inode(ctx, ino, inode, "pass1");
+			}
+		} else if (extent_fs &&
+			   (LINUX_S_ISREG(inode->i_mode) ||
+			    LINUX_S_ISDIR(inode->i_mode)) &&
+			   ext2fs_extent_header_verify(eh, EXT2_N_BLOCKS *
+						       sizeof(__u32)) == 0 &&
+			   fix_problem(ctx, PR_1_UNSET_EXTENT_FL, &pctx)) {
+			inode->i_flags |= EXT4_EXTENTS_FL;
+			e2fsck_write_inode(ctx, ino, inode, "pass1");
+		}
+		if (extent_fs && inode->i_flags & EXT4_EXTENTS_FL) {
+			ctx->extent_files++;
+			switch(eh->eh_depth) {
+			case 0:
+				break;
+			case 1:
+				ctx->fs_ind_count++;
+				break;
+			case 2:
+				ctx->fs_dind_count++;
+				break;
+			default:
+				ctx->fs_tind_count++;
+				break;
+			}
+			if (eh->eh_depth > 0) {
+				inodes_to_process[process_inode_count].ino = ino;
+				inodes_to_process[process_inode_count].inode = *inode;
+				process_inode_count++;
+			} else {
+				check_blocks(ctx, &pctx, block_buf);
+			}
+		} else {
+			if (inode->i_block[EXT2_IND_BLOCK])
+				ctx->fs_ind_count++;
+			if (inode->i_block[EXT2_DIND_BLOCK])
+				ctx->fs_dind_count++;
+			if (inode->i_block[EXT2_TIND_BLOCK])
+				ctx->fs_tind_count++;
+			if (inode->i_block[EXT2_IND_BLOCK] ||
+			    inode->i_block[EXT2_DIND_BLOCK] ||
+			    inode->i_block[EXT2_TIND_BLOCK] ||
+			    inode->i_file_acl) {
+				inodes_to_process[process_inode_count].ino = ino;
+				inodes_to_process[process_inode_count].inode = *inode;
+				process_inode_count++;
+			} else {
+				check_blocks(ctx, &pctx, block_buf);
+			}
+		}
 
 		if (ctx->flags & E2F_FLAG_SIGNAL_MASK)
 			return;
@@ -1363,6 +1418,132 @@ static int handle_htree(e2fsck_t ctx, st
 	return 0;
 }
 
+/* sort 0 to the end of the list so we can exit early */
+static EXT2_QSORT_TYPE verify_ind_cmp(const void *a, const void *b)
+{
+	const __u32 blk_a = *(__u32 *)a - 1, blk_b = *(__u32 *)b - 1;
+
+	return blk_b > blk_a ? -1 : blk_a - blk_b;
+}
+
+/* Verify whether an indirect block is sane.  If it has multiple references
+ * to the same block, or if it has a large number of bad or duplicate blocks
+ * chances are that it is corrupt and we should just clear it instead of
+ * trying to salvage it.
+ * NOTE: this needs to get a copy of the blocks, since it reorders them */
+static int e2fsck_ind_block_verify(struct process_block_struct *p,
+				   void *block_buf, int buflen)
+{
+	__u32 blocks[EXT2_N_BLOCKS], *indir = block_buf;
+	int num_indir = buflen / sizeof(*indir);
+	int i, bad = 0;
+
+	if (num_indir == EXT2_N_BLOCKS) {
+		memcpy(blocks, block_buf, buflen);
+		indir = blocks;
+	}
+	qsort(indir, num_indir, sizeof(*indir), verify_ind_cmp);
+
+	for (i = 0; i < num_indir; i++) {
+		if (indir[i] == 0)
+			break;
+
+		/* bad block number, or duplicate block */
+		if (indir[i] < p->ctx->fs->super->s_first_data_block ||
+		    indir[i] > p->ctx->fs->super->s_blocks_count ||
+		    ext2fs_fast_test_block_bitmap(p->ctx->block_found_map,
+						  indir[i]))
+			bad++;
+
+		/* shouldn't reference the same block twice within a block */
+		if (i > 0 && indir[i] == indir[i - 1])
+			bad++;
+	}
+
+	if ((num_indir <= EXT2_N_BLOCKS && bad > 4) || bad > 8)
+		return PR_1_INDIRECT_BAD;
+
+#if DEBUG_E2FSCK
+	/* For debugging, clobber buffer to ensure it doesn't appear sane */
+	memset(indir, 0xca, buflen);
+#endif
+	return 0;
+}
+
+/* we have already verified the header in e2fsck_pass1() before calling this */
+static int e2fsck_ext_block_verify(struct process_block_struct *p,
+				   void *block_buf, int buflen)
+{
+	struct ext4_extent_header *eh = block_buf;
+	e2fsck_t ctx = p->ctx;
+	struct problem_context *pctx = p->pctx;
+	int i, bad = 0, changed = 0;
+
+	if (eh->eh_depth == 0) {
+		struct ext4_extent *ex = EXT_FIRST_EXTENT(eh), *ex_prev = NULL;
+
+		for (i = 0; i < eh->eh_entries; i++, ex++) {
+			/* FIXME: 48-bit check for s_blocks_count_hi */
+			if (ex->ee_start_hi && fix_problem(ctx, PR_1_EXTENT_HI,
+							   pctx)) {
+				ex->ee_start_hi = 0;
+				changed++;
+			}
+
+			if (ext2fs_extent_verify(ctx->fs, ex, ex_prev, NULL,0)){
+				pctx->blkcount = ex->ee_start;
+				pctx->num = ex->ee_len;
+				pctx->blk = ex->ee_block;
+				if (fix_problem(ctx, PR_1_EXTENT_BAD, pctx)) {
+					ext2fs_extent_remove(eh, ex);
+					i--; ex--; /* check next (moved) item */
+					changed++;
+					continue;
+				} else {
+					bad++;
+				}
+			}
+
+			ex_prev = ex;
+		}
+	} else {
+		struct ext4_extent_idx *ix =EXT_FIRST_INDEX(eh), *ix_prev =NULL;
+
+		for (i = 0; i < eh->eh_entries; i++, ix++) {
+			/* FIXME: 48-bit check for s_blocks_count_hi */
+			if (ix->ei_leaf_hi && fix_problem(ctx, PR_1_EXTENT_HI,
+							  pctx)) {
+				ix->ei_leaf_hi = ix->ei_unused = 0;
+				changed++;
+			}
+
+			if (ext2fs_extent_index_verify(ctx->fs, ix, ix_prev)) {
+				pctx->blkcount = ix->ei_leaf;;
+				pctx->num = i;
+				pctx->blk = ix->ei_block;
+				if (fix_problem(ctx, PR_1_EXTENT_IDX_BAD,pctx)){
+					ext2fs_extent_index_remove(eh, ix);
+					i--; ix--; /* check next (moved) item */
+					changed++;
+					continue;
+				} else {
+					bad++;
+				}
+			}
+
+			ix_prev = ix;
+		}
+	}
+
+	if ((eh->eh_entries < 8 && bad > 2) || bad > 6)
+		return PR_1_EXTENT_BAD;
+
+	if (changed)
+		return PR_1_EXTENT_HI;
+
+	return 0;
+}
+
 /*
  * This subroutine is called on each inode to account for all of the
  * blocks used by that inode.
@@ -1385,6 +1566,7 @@ static void check_blocks(e2fsck_t ctx, s
 	pb.suppress = 0; pb.clear = 0;
 	pb.fragmented = 0;
 	pb.compressed = 0;
+	pb.extent = !!(inode->i_flags & EXT4_EXTENTS_FL);
 	pb.previous_block = 0;
 	pb.is_dir = LINUX_S_ISDIR(inode->i_mode);
 	pb.is_reg = LINUX_S_ISREG(inode->i_mode);
@@ -1392,6 +1574,7 @@ static void check_blocks(e2fsck_t ctx, s
 	pb.inode = inode;
 	pb.pctx = pctx;
 	pb.ctx = ctx;
+	pb.block_buf = block_buf;
 	pctx->ino = ino;
 	pctx->errcode = 0;
 
@@ -1410,10 +1593,27 @@ static void check_blocks(e2fsck_t ctx, s
 	if (inode->i_file_acl && check_ext_attr(ctx, pctx, block_buf))
 		pb.num_blocks++;
 
-	if (ext2fs_inode_has_valid_blocks(inode))
-		pctx->errcode = ext2fs_block_iterate2(fs, ino,
-				       pb.is_dir ? BLOCK_FLAG_HOLE : 0,
-				       block_buf, process_block, &pb);
+	if (ext2fs_inode_has_valid_blocks(inode)) {
+		int problem = 0;
+
+		if (pb.extent)
+			problem = e2fsck_ext_block_verify(&pb, inode->i_block,
+							sizeof(inode->i_block));
+		else
+			problem = e2fsck_ind_block_verify(&pb, inode->i_block,
+							sizeof(inode->i_block));
+		if (problem == PR_1_EXTENT_HI) {
+			dirty_inode++;
+			problem = 0;
+		}
+
+		if (problem && fix_problem(ctx, problem, pctx))
+			pb.clear = 1;
+		else
+			pctx->errcode = ext2fs_block_iterate2(fs, ino,
+						pb.is_dir ? BLOCK_FLAG_HOLE : 0,
+						block_buf, process_block, &pb);
+	}
 	end_problem_latch(ctx, PR_LATCH_BLOCK);
 	end_problem_latch(ctx, PR_LATCH_TOOBIG);
 	if (ctx->flags & E2F_FLAG_SIGNAL_MASK)
@@ -1577,6 +1777,9 @@ static char *describe_illegal_block(ext2
 }
 #endif
 
+#define IND_BLKCNT(_b) ((_b) == BLOCK_COUNT_IND || (_b) == BLOCK_COUNT_DIND ||\
+			(_b) == BLOCK_COUNT_TIND)
+
 /*
  * This is a helper function for check_blocks().
  */
@@ -1655,7 +1858,8 @@ static int process_block(ext2_filsys fs,
 	 * file be contiguous.  (Which can never be true for really
 	 * big files that are greater than a block group.)
 	 */
-	if (!HOLE_BLKADDR(p->previous_block)) {
+	if (!HOLE_BLKADDR(p->previous_block) &&
+	    !(p->extent && IND_BLKCNT(blockcnt))) {
 		if (p->previous_block+1 != blk)
 			p->fragmented = 1;
 	}
@@ -1672,6 +1876,32 @@ static int process_block(ext2_filsys fs,
 	    blk >= fs->super->s_blocks_count)
 		problem = PR_1_ILLEGAL_BLOCK_NUM;
 
+	if (!problem && IND_BLKCNT(blockcnt) && p->ino != EXT2_RESIZE_INO) {
+		if (p->extent) {
+			problem = ext2fs_read_ext_block(ctx->fs, blk,
+							p->block_buf);
+			if (problem)
+				problem = PR_1_BLOCK_ITERATE;
+			else
+				problem = e2fsck_ext_block_verify(p,
+								 p->block_buf,
+								 fs->blocksize);
+			if (problem == PR_1_EXTENT_HI)
+				problem = ext2fs_write_ext_block(ctx->fs, blk,
+								 p->block_buf);
+
+		} else {
+			problem = ext2fs_read_ind_block(ctx->fs, blk,
+							p->block_buf);
+			if (problem)
+				problem = PR_1_BLOCK_ITERATE;
+			else
+				problem = e2fsck_ind_block_verify(p,
+								 p->block_buf,
+								 fs->blocksize);
+		}
+	}
+
 	if (problem) {
 		p->num_illegal_blocks++;
 		if (!p->suppress && (p->num_illegal_blocks % 12) == 0) {
Index: e2fsprogs-1.39/e2fsck/pass2.c
===================================================================
--- e2fsprogs-1.39.orig/e2fsck/pass2.c	2006-03-19 03:34:00.000000000 +0100
+++ e2fsprogs-1.39/e2fsck/pass2.c	2006-09-18 17:23:02.000000000 +0200
@@ -280,7 +280,16 @@ void e2fsck_pass2(e2fsck_t ctx)
 			ext2fs_mark_super_dirty(fs);
 		}
 	}
-	
+
+	if (!ctx->extent_files &&
+	    (sb->s_feature_incompat & EXT4_FEATURE_INCOMPAT_EXTENTS)) {
+		if (fs->flags & EXT2_FLAG_RW) {
+			sb->s_feature_incompat &=
+				~EXT4_FEATURE_INCOMPAT_EXTENTS;
+			ext2fs_mark_super_dirty(fs);
+		}
+	}
+
 #ifdef RESOURCE_TRACK
 	if (ctx->options & E2F_OPT_TIME2) {
 		e2fsck_clear_progbar(ctx);
Index: e2fsprogs-1.39/e2fsck/problem.c
===================================================================
--- e2fsprogs-1.39.orig/e2fsck/problem.c	2006-03-09 04:02:50.000000000 +0100
+++ e2fsprogs-1.39/e2fsck/problem.c	2006-09-18 17:23:02.000000000 +0200
@@ -774,6 +774,46 @@ static struct e2fsck_problem problem_tab
 	  N_("@a in @i %i has a hash (%N) which is @n (must be 0)\n"),
 	  PROMPT_CLEAR, PR_PREEN_OK },
 
+	/* indirect block corrupt */
+	{ PR_1_INDIRECT_BAD,
+	  N_("@i %i has corrupt indirect block\n"),
+	  PROMPT_CLEAR, PR_PREEN_OK },
+
+	/* inode has extents, superblock missing INCOMPAT_EXTENTS feature */
+	{ PR_1_EXTENT_FEATURE,
+	  N_("@i %i is in extent format, but @S is missing EXTENTS feature\n"),
+	  PROMPT_FIX, PR_PREEN_OK },
+
+	/* inode has EXTENTS_FL set, but is not an extent inode */
+	{ PR_1_SET_EXTENT_FL,
+	  N_("@i %i has EXTENT_FL set, but is not in extents format\n"),
+	  PROMPT_FIX, PR_PREEN_OK },
+
+	/* inode missing EXTENTS_FL, but is an extent inode */
+	{ PR_1_UNSET_EXTENT_FL,
+	  N_("@i %i missing EXTENT_FL, but is in extents format\n"),
+	  PROMPT_FIX, PR_PREEN_OK },
+
+	/* extent index corrupt */
+	{ PR_1_EXTENT_BAD,
+	  N_("@i %i has corrupt extent at @b %b (logical %B) length %N\n"),
+	  PROMPT_CLEAR, PR_PREEN_OK },
+
+	/* extent index corrupt */
+	{ PR_1_EXTENT_IDX_BAD,
+	  N_("@i %i has corrupt extent index at @b %b (logical %B) entry %N\n"),
+	  PROMPT_CLEAR, PR_PREEN_OK },
+
+	/* extent has high 16 bits set */
+	{ PR_1_EXTENT_HI,
+	  N_("High 16 bits of extent/index block set\n"),
+	  PROMPT_CLEAR, PR_LATCH_EXTENT_HI | PR_PREEN_OK | PR_NO_OK },
+
+	/* extent has high 16 bits set header */
+	{ PR_1_EXTENT_HI_LATCH,
+	  N_("@i %i has high 16 bits of extent/index block set\n"),
+	  PROMPT_CLEAR, PR_PREEN_OK | PR_NO_OK },
+
 	/* Pass 1b errors */
 
 	/* Pass 1B: Rescan for duplicate/bad blocks */
@@ -1498,6 +1538,7 @@ static struct latch_descr pr_latch_info[
 	{ PR_LATCH_LOW_DTIME, PR_1_ORPHAN_LIST_REFUGEES, 0 },
 	{ PR_LATCH_TOOBIG, PR_1_INODE_TOOBIG, 0 },
 	{ PR_LATCH_OPTIMIZE_DIR, PR_3A_OPTIMIZE_DIR_HEADER, PR_3A_OPTIMIZE_DIR_END },
+	{ PR_LATCH_EXTENT_HI, PR_1_EXTENT_HI_LATCH, 0 },
 	{ -1, 0, 0 },
 };
 
Index: e2fsprogs-1.39/e2fsck/problem.h
===================================================================
--- e2fsprogs-1.39.orig/e2fsck/problem.h	2006-03-09 03:58:28.000000000 +0100
+++ e2fsprogs-1.39/e2fsck/problem.h	2006-09-18 17:23:02.000000000 +0200
@@ -38,6 +38,7 @@ struct problem_context {
 #define PR_LATCH_LOW_DTIME 0x0070 /* Latch for pass1 orphaned list refugees */
 #define PR_LATCH_TOOBIG	0x0080	/* Latch for file to big errors */
 #define PR_LATCH_OPTIMIZE_DIR 0x0090 /* Latch for optimize directories */
+#define PR_LATCH_EXTENT_HI 0x00A0 /* Latch for optimize directories */
 
 #define PR_LATCH(x)	((((x) & PR_LATCH_MASK) >> 4) - 1)
 
@@ -449,6 +450,30 @@ struct problem_context {
 /* wrong EA hash value */
 #define PR_1_ATTR_HASH			0x010054
 
+/* indirect block corrupt */
+#define PR_1_INDIRECT_BAD		0x010059
+
+/* wrong EXT4_FEATURE_INCOMPAT_EXTENTS flag */
+#define PR_1_EXTENT_FEATURE		0x010060
+
+/* EXT4_EXTENT_FL flag set on non-extent file */
+#define PR_1_SET_EXTENT_FL		0x010061
+
+/* EXT4_EXTENT_FL flag not set extent file */
+#define PR_1_UNSET_EXTENT_FL		0x010062
+
+/* extent index corrupt */
+#define PR_1_EXTENT_BAD			0x010063
+
+/* extent index corrupt */
+#define PR_1_EXTENT_IDX_BAD		0x010064
+
+/* extent/index has high 16 bits set - header */
+#define PR_1_EXTENT_HI			0x010065
+
+/* extent/index has high 16 bits set */
+#define PR_1_EXTENT_HI_LATCH		0x010066
+
 /*
  * Pass 1b errors
  */
Index: e2fsprogs-1.39/lib/ext2fs/Makefile.in
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/Makefile.in	2006-04-09 04:02:02.000000000 +0200
+++ e2fsprogs-1.39/lib/ext2fs/Makefile.in	2006-09-18 17:23:02.000000000 +0200
@@ -35,6 +35,7 @@ OBJS= $(DEBUGFS_LIB_OBJS) $(RESIZE_LIB_O
 	dir_iterate.o \
 	expanddir.o \
 	ext_attr.o \
+	extents.o \
 	finddev.o \
 	flushb.o \
 	freefs.o \
@@ -90,6 +91,7 @@ SRCS= ext2_err.c \
 	$(srcdir)/dupfs.c \
 	$(srcdir)/expanddir.c \
 	$(srcdir)/ext_attr.c \
+	$(srcdir)/extents.c \
 	$(srcdir)/fileio.c \
 	$(srcdir)/finddev.c \
 	$(srcdir)/flushb.c \
@@ -134,7 +136,8 @@ SRCS= ext2_err.c \
 	$(srcdir)/tst_getsize.c \
 	$(srcdir)/tst_iscan.c
 
-HFILES= bitops.h ext2fs.h ext2_io.h ext2_fs.h ext2_ext_attr.h
+HFILES= bitops.h ext2fs.h ext2_io.h ext2_fs.h ext2_ext_attr.h block.h \
+	ext4_extents.h
 HFILES_IN=  ext2_err.h ext2_types.h
 
 LIBRARY= libext2fs
@@ -372,6 +375,10 @@ ext_attr.o: $(srcdir)/ext_attr.c $(srcdi
  $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2_ext_attr.h \
  $(srcdir)/ext2fs.h $(srcdir)/ext2_fs.h $(top_srcdir)/lib/et/com_err.h \
  $(srcdir)/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h $(srcdir)/bitops.h
+extents.o: $(srcdir)/extents.c $(srcdir)/ext2_fs.h \
+ $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext4_extents.h \
+ $(srcdir)/ext2fs.h $(srcdir)/ext2_fs.h $(top_srcdir)/lib/et/com_err.h \
+ $(srcdir)/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h $(srcdir)/bitops.h
 fileio.o: $(srcdir)/fileio.c $(srcdir)/ext2_fs.h \
  $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2fs.h \
  $(srcdir)/ext2_fs.h $(top_srcdir)/lib/et/com_err.h $(srcdir)/ext2_io.h \
@@ -516,6 +523,7 @@ unlink.o: $(srcdir)/unlink.c $(srcdir)/e
  $(top_builddir)/lib/ext2fs/ext2_err.h $(srcdir)/bitops.h
 valid_blk.o: $(srcdir)/valid_blk.c $(srcdir)/ext2_fs.h \
  $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2fs.h \
+ $(srcdir)/ext4_extents.h \
  $(srcdir)/ext2_fs.h $(top_srcdir)/lib/et/com_err.h $(srcdir)/ext2_io.h \
  $(top_builddir)/lib/ext2fs/ext2_err.h $(srcdir)/bitops.h
 version.o: $(srcdir)/version.c $(srcdir)/ext2_fs.h \
Index: e2fsprogs-1.39/lib/ext2fs/block.c
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/block.c	2005-09-06 11:40:14.000000000 +0200
+++ e2fsprogs-1.39/lib/ext2fs/block.c	2006-09-18 17:23:02.000000000 +0200
@@ -17,24 +17,16 @@
 
 #include "ext2_fs.h"
 #include "ext2fs.h"
+#include "block.h"
 
-struct block_context {
-	ext2_filsys	fs;
-	int (*func)(ext2_filsys	fs,
-		    blk_t	*blocknr,
-		    e2_blkcnt_t	bcount,
-		    blk_t	ref_blk,
-		    int		ref_offset,
-		    void	*priv_data);
-	e2_blkcnt_t	bcount;
-	int		bsize;
-	int		flags;
-	errcode_t	errcode;
-	char	*ind_buf;
-	char	*dind_buf;
-	char	*tind_buf;
-	void	*priv_data;
-};
+#ifdef EXT_DEBUG
+void show_inode(ext2_ino_t ino)
+{
+        printf("inode: %u\n", ino);
+}
+#else
+#define show_inode(ino) do { } while (0)
+#endif
 
 static int block_iterate_ind(blk_t *ind_block, blk_t ref_block,
 			     int ref_offset, struct block_context *ctx)
@@ -276,29 +268,30 @@ errcode_t ext2fs_block_iterate2(ext2_fil
 				void *priv_data)
 {
 	int	i;
-	int	got_inode = 0;
 	int	ret = 0;
 	blk_t	blocks[EXT2_N_BLOCKS];	/* directory data blocks */
 	struct ext2_inode inode;
 	errcode_t	retval;
 	struct block_context ctx;
 	int	limit;
+	struct ext4_extent_header *eh;
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
+	ctx.errcode = ext2fs_read_inode(fs, ino, &inode);
+	if (ctx.errcode)
+		return ctx.errcode;
+
 	/*
 	 * Check to see if we need to limit large files
 	 */
 	if (flags & BLOCK_FLAG_NO_LARGE) {
-		ctx.errcode = ext2fs_read_inode(fs, ino, &inode);
-		if (ctx.errcode)
-			return ctx.errcode;
-		got_inode = 1;
 		if (!LINUX_S_ISDIR(inode.i_mode) &&
 		    (inode.i_size_high != 0))
 			return EXT2_ET_FILE_TOO_BIG;
 	}
 
+	/* The in-memory inode may have been changed by e2fsck */
 	retval = ext2fs_get_blocks(fs, ino, blocks);
 	if (retval)
 		return retval;
@@ -325,10 +318,6 @@ errcode_t ext2fs_block_iterate2(ext2_fil
 	 */
 	if ((fs->super->s_creator_os == EXT2_OS_HURD) &&
 	    !(flags & BLOCK_FLAG_DATA_ONLY)) {
-		ctx.errcode = ext2fs_read_inode(fs, ino, &inode);
-		if (ctx.errcode)
-			goto abort_exit;
-		got_inode = 1;
 		if (inode.osd1.hurd1.h_i_translator) {
 			ret |= (*ctx.func)(fs,
 					   &inode.osd1.hurd1.h_i_translator,
@@ -338,7 +327,20 @@ errcode_t ext2fs_block_iterate2(ext2_fil
 				goto abort_exit;
 		}
 	}
-	
+
+	/* Iterate over normal data blocks with extents.  We checked that
+	 * EXT4_EXTENTS_FL and EXT4_EXT_MAGIC match in e2fsck_pass1(). */
+	if (inode.i_flags & EXT4_EXTENTS_FL) {
+		eh = (struct ext4_extent_header *)blocks;
+		if (eh->eh_magic == EXT4_EXT_MAGIC) {
+			show_inode(ino);
+			ret |= block_iterate_extents(eh, 0, 0, &ctx);
+		} else {
+			ret |= BLOCK_ERROR;
+		}
+		goto abort_exit;
+	}
+
 	/*
 	 * Iterate over normal data blocks
 	 */
@@ -373,11 +375,6 @@ errcode_t ext2fs_block_iterate2(ext2_fil
 
 abort_exit:
 	if (ret & BLOCK_CHANGED) {
-		if (!got_inode) {
-			retval = ext2fs_read_inode(fs, ino, &inode);
-			if (retval)
-				return retval;
-		}
 		for (i=0; i < EXT2_N_BLOCKS; i++)
 			inode.i_block[i] = blocks[i];
 		retval = ext2fs_write_inode(fs, ino, &inode);
Index: e2fsprogs-1.39/lib/ext2fs/block.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ e2fsprogs-1.39/lib/ext2fs/block.h	2006-09-18 17:23:02.000000000 +0200
@@ -0,0 +1,36 @@
+/*
+ * block.h --- header for block iteration in block.c, extent.c
+ * 
+ * Copyright (C) 1993, 1994, 1995, 1996 Theodore Ts'o.
+ *
+ * %Begin-Header%
+ * This file may be redistributed under the terms of the GNU Public
+ * License.
+ * %End-Header%
+ */
+
+#include "ext4_extents.h"
+
+struct block_context {
+	ext2_filsys	fs;
+	int (*func)(ext2_filsys	fs,
+		    blk_t	*blocknr,
+		    e2_blkcnt_t	bcount,
+		    blk_t	ref_blk,
+		    int		ref_offset,
+		    void	*priv_data);
+	e2_blkcnt_t	bcount;
+	int		bsize;
+	int		flags;
+	errcode_t	errcode;
+	char	*ind_buf;
+	char	*dind_buf;
+	char	*tind_buf;
+	void	*priv_data;
+};
+
+/* Internal function, in extent.c */
+extern int block_iterate_extents(struct ext4_extent_header *eh,
+				 blk_t ref_block,
+				 int ref_offset EXT2FS_ATTR((unused)),
+				 struct block_context *ctx);
Index: e2fsprogs-1.39/lib/ext2fs/bmap.c
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/bmap.c	2005-09-06 11:40:14.000000000 +0200
+++ e2fsprogs-1.39/lib/ext2fs/bmap.c	2006-09-18 17:23:02.000000000 +0200
@@ -17,6 +17,7 @@
 
 #include "ext2_fs.h"
 #include "ext2fs.h"
+#include "ext4_extents.h"
 
 #if defined(__GNUC__) && !defined(NO_INLINE_FUNCS)
 #define _BMAP_INLINE_	__inline__
@@ -31,6 +32,64 @@ extern errcode_t ext2fs_bmap(ext2_filsys
 
 #define inode_bmap(inode, nr) ((inode)->i_block[(nr)])
 
+/* see also block_iterate_extents() */
+static errcode_t block_bmap_extents(struct ext4_extent_header *eh,
+				    ext2_filsys fs, blk_t block,
+				    blk_t *phys_blk)
+{
+	struct ext4_extent *ex;
+	errcode_t ret = 0;
+	int i;
+
+	if (eh->eh_depth == 0) {
+		ex = EXT_FIRST_EXTENT(eh);
+		for (i = 0; i < eh->eh_entries; i++, ex++) {
+			if ((ex->ee_block <= block) &&
+			    (block < ex->ee_block + ex->ee_len)) {
+				*phys_blk = ex->ee_start +
+					(block - ex->ee_block);
+				return 0;
+			}
+		}
+
+		return BLOCK_ERROR;
+	} else {
+		struct ext4_extent_idx *ix;
+		char *block_buf;
+
+		ret = ext2fs_get_mem(fs->blocksize, &block_buf);
+		if (ret)
+			return ret;
+
+		ix = EXT_FIRST_INDEX(eh);
+		for (i = 0; i < eh->eh_entries; i++, ix++) {
+			struct ext4_extent_header *nh;
+
+			if (ix->ei_block < block)
+				continue;
+
+			ret = io_channel_read_blk(fs->io, ix->ei_leaf, 1,
+						  block_buf);
+			if (ret) {
+				ret = BLOCK_ERROR;
+				goto free_buf;
+			}
+
+			nh = (struct ext4_extent_header *)block_buf;
+			if (nh->eh_magic != EXT4_EXT_MAGIC) {
+				ret = BLOCK_ERROR;
+				goto free_buf;
+			}
+
+			ret = block_bmap_extents(nh, fs, block, phys_blk);
+		}
+
+	free_buf:
+		ext2fs_free_mem(&block_buf);
+	}
+	return ret;
+}
+
 static _BMAP_INLINE_ errcode_t block_ind_bmap(ext2_filsys fs, int flags, 
 					      blk_t ind, char *block_buf, 
 					      int *blocks_alloc,
@@ -155,6 +214,17 @@ errcode_t ext2fs_bmap(ext2_filsys fs, ex
 			return retval;
 		inode = &inode_buf;
 	}
+
+	if (inode->i_flags & EXT4_EXTENTS_FL) {
+		struct ext4_extent_header * eh;
+		eh = (struct ext4_extent_header *)&inode_bmap(inode, 0);
+		if (eh->eh_magic == EXT4_EXT_MAGIC)
+			retval = block_bmap_extents(eh, fs, block, phys_blk);
+		else
+			retval = BLOCK_ERROR;
+		goto done;
+	}
+
 	addr_per_block = (blk_t) fs->blocksize >> 2;
 
 	if (!block_buf) {
Index: e2fsprogs-1.39/lib/ext2fs/ext2_err.et.in
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/ext2_err.et.in	2005-09-06 11:40:14.000000000 +0200
+++ e2fsprogs-1.39/lib/ext2fs/ext2_err.et.in	2006-09-18 17:23:02.000000000 +0200
@@ -296,5 +296,17 @@ ec	EXT2_ET_RESIZE_INODE_CORRUPT,
 ec	EXT2_ET_SET_BMAP_NO_IND,
 	"Missing indirect block not present"
 
+ec	EXT2_ET_EXTENT_HEADER_BAD,
+	"Corrupt extent header"
+
+ec	EXT2_ET_EXTENT_INDEX_BAD,
+	"Corrupt extent index"
+
+ec	EXT2_ET_EXTENT_LEAF_BAD,
+	"Corrupt extent"
+
+ec	EXT2_ET_EXTENT_NO_SPACE,
+	"No free space in extent map"
+
 	end
 
Index: e2fsprogs-1.39/lib/ext2fs/ext2fs.h
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/ext2fs.h	2006-09-18 16:55:08.000000000 +0200
+++ e2fsprogs-1.39/lib/ext2fs/ext2fs.h	2006-09-18 17:29:08.000000000 +0200
@@ -65,9 +65,11 @@ extern "C" {
 #if EXT2_FLAT_INCLUDES
 #include "e2_types.h"
 #include "ext2_fs.h"
+#include "ext4_extents.h"
 #else
 #include <ext2fs/ext2_types.h>
 #include <ext2fs/ext2_fs.h>
+#include <ext2fs/ext4_extents.h>
 #endif /* EXT2_FLAT_INCLUDES */
 
 typedef __u32		ext2_ino_t;
@@ -449,12 +451,14 @@ typedef struct ext2_icount *ext2_icount_
 					 EXT2_FEATURE_INCOMPAT_COMPRESSION|\
 					 EXT3_FEATURE_INCOMPAT_JOURNAL_DEV|\
 					 EXT2_FEATURE_INCOMPAT_META_BG|\
-					 EXT3_FEATURE_INCOMPAT_RECOVER)
+					 EXT3_FEATURE_INCOMPAT_RECOVER|\
+					 EXT4_FEATURE_INCOMPAT_EXTENTS)
 #else
 #define EXT2_LIB_FEATURE_INCOMPAT_SUPP	(EXT2_FEATURE_INCOMPAT_FILETYPE|\
 					 EXT3_FEATURE_INCOMPAT_JOURNAL_DEV|\
 					 EXT2_FEATURE_INCOMPAT_META_BG|\
-					 EXT3_FEATURE_INCOMPAT_RECOVER)
+					 EXT3_FEATURE_INCOMPAT_RECOVER|\
+					 EXT4_FEATURE_INCOMPAT_EXTENTS)
 #endif
 #define EXT2_LIB_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER|\
 					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE)
@@ -707,6 +711,21 @@ extern errcode_t ext2fs_adjust_ea_refcou
 					   char *block_buf,
 					   int adjust, __u32 *newcount);
 
+/* extent.c */
+errcode_t ext2fs_extent_header_verify(struct ext4_extent_header *eh, int size);
+errcode_t ext2fs_extent_verify(ext2_filsys fs, struct ext4_extent *ex,
+			       struct ext4_extent *ex_prev,
+			       struct ext4_extent_idx *ix, int ix_len);
+errcode_t ext2fs_extent_index_verify(ext2_filsys fs,
+				     struct ext4_extent_idx *ix,
+				     struct ext4_extent_idx *ix_prev);
+errcode_t ext2fs_extent_remove(struct ext4_extent_header *eh,
+			       struct ext4_extent *ex);
+errcode_t ext2fs_extent_split(struct ext4_extent_header *eh,
+			      struct ext4_extent *ex, int count);
+errcode_t ext2fs_extent_index_remove(struct ext4_extent_header *eh,
+				     struct ext4_extent_idx *ix);
+
 /* fileio.c */
 extern errcode_t ext2fs_file_open2(ext2_filsys fs, ext2_ino_t ino,
 				   struct ext2_inode *inode,
@@ -761,6 +780,8 @@ extern errcode_t ext2fs_image_bitmap_rea
 /* ind_block.c */
 errcode_t ext2fs_read_ind_block(ext2_filsys fs, blk_t blk, void *buf);
 errcode_t ext2fs_write_ind_block(ext2_filsys fs, blk_t blk, void *buf);
+errcode_t ext2fs_read_ext_block(ext2_filsys fs, blk_t blk, void *buf);
+errcode_t ext2fs_write_ext_block(ext2_filsys fs, blk_t blk, void *buf);
 
 /* initialize.c */
 extern errcode_t ext2fs_initialize(const char *name, int flags,
Index: e2fsprogs-1.39/lib/ext2fs/ext4_extents.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ e2fsprogs-1.39/lib/ext2fs/ext4_extents.h	2006-09-18 17:23:02.000000000 +0200
@@ -0,0 +1,238 @@
+/*
+ * Copyright (c) 2003,2004 Cluster File Systems, Inc, info@clusterfs.com
+ * Written by Alex Tomas <alex@clusterfs.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public Licens
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-
+ */
+
+#ifndef _LINUX_EXT4_EXTENTS
+#define _LINUX_EXT4_EXTENTS
+
+/*
+ * with AGRESSIVE_TEST defined capacity of index/leaf blocks
+ * become very little, so index split, in-depth growing and
+ * other hard changes happens much more often
+ * this is for debug purposes only
+ */
+#define AGRESSIVE_TEST_
+
+/*
+ * if CHECK_BINSEARCH defined, then results of binary search
+ * will be checked by linear search
+ */
+#define CHECK_BINSEARCH_
+
+/*
+ * if EXT_DEBUG is defined you can use 'extdebug' mount option
+ * to get lots of info what's going on
+ */
+//#define EXT_DEBUG
+#ifdef EXT_DEBUG
+#define ext_debug(tree,fmt,a...) 			\
+do {							\
+	if (test_opt((tree)->inode->i_sb, EXTDEBUG))	\
+		printk(fmt, ##a);			\
+} while (0);
+#else
+#define ext_debug(tree,fmt,a...)
+#endif
+
+/*
+ * if EXT_STATS is defined then stats numbers are collected
+ * these number will be displayed at umount time
+ */
+#define EXT_STATS_
+
+
+#define EXT4_ALLOC_NEEDED	3	/* block bitmap + group desc. + sb */
+
+/*
+ * ext4_inode has i_block array (total 60 bytes)
+ * first 4 bytes are used to store:
+ *  - tree depth (0 mean there is no tree yet. all extents in the inode)
+ *  - number of alive extents in the inode
+ */
+
+/*
+ * this is extent on-disk structure
+ * it's used at the bottom of the tree
+ */
+struct ext4_extent {
+	__u32	ee_block;	/* first logical block extent covers */
+	__u16	ee_len;		/* number of blocks covered by extent */
+	__u16	ee_start_hi;	/* high 16 bits of physical block */
+	__u32	ee_start;	/* low 32 bigs of physical block */
+};
+
+/*
+ * this is index on-disk structure
+ * it's used at all the levels, but the bottom
+ */
+struct ext4_extent_idx {
+	__u32	ei_block;	/* index covers logical blocks from 'block' */
+	__u32	ei_leaf;	/* pointer to the physical block of the next *
+				 * level. leaf or next index could bet here */
+	__u16	ei_leaf_hi;	/* high 16 bits of physical block */
+	__u16	ei_unused;
+};
+
+/*
+ * each block (leaves and indexes), even inode-stored has header
+ */
+struct ext4_extent_header {
+	__u16	eh_magic;	/* probably will support different formats */
+	__u16	eh_entries;	/* number of valid entries */
+	__u16	eh_max;		/* capacity of store in entries */
+	__u16	eh_depth;	/* has tree real underlaying blocks? */
+	__u32	eh_generation;	/* generation of the tree */
+};
+
+#define EXT4_EXT_MAGIC		0xf30a
+
+/*
+ * array of ext4_ext_path contains path to some extent
+ * creation/lookup routines use it for traversal/splitting/etc
+ * truncate uses it to simulate recursive walking
+ */
+struct ext4_ext_path {
+	__u32				p_block;
+	__u16				p_depth;
+	struct ext4_extent		*p_ext;
+	struct ext4_extent_idx		*p_idx;
+	struct ext4_extent_header	*p_hdr;
+	struct buffer_head		*p_bh;
+};
+
+/*
+ * structure for external API
+ */
+
+#define EXT_CONTINUE	0
+#define EXT_BREAK	1
+#define EXT_REPEAT	2
+
+
+#define EXT_MAX_BLOCK	0xffffffff
+#define EXT_CACHE_MARK	0xffff
+
+
+#define EXT_FIRST_EXTENT(__hdr__) \
+	((struct ext4_extent *) (((char *) (__hdr__)) +		\
+				 sizeof(struct ext4_extent_header)))
+#define EXT_FIRST_INDEX(__hdr__) \
+	((struct ext4_extent_idx *) (((char *) (__hdr__)) +	\
+				     sizeof(struct ext4_extent_header)))
+#define EXT_HAS_FREE_INDEX(__path__) \
+	((__path__)->p_hdr->eh_entries < (__path__)->p_hdr->eh_max)
+#define EXT_LAST_EXTENT(__hdr__) \
+	(EXT_FIRST_EXTENT((__hdr__)) + (__hdr__)->eh_entries - 1)
+#define EXT_LAST_INDEX(__hdr__) \
+	(EXT_FIRST_INDEX((__hdr__)) + (__hdr__)->eh_entries - 1)
+#define EXT_MAX_EXTENT(__hdr__) \
+	(EXT_FIRST_EXTENT((__hdr__)) + (__hdr__)->eh_max - 1)
+#define EXT_MAX_INDEX(__hdr__) \
+	(EXT_FIRST_INDEX((__hdr__)) + (__hdr__)->eh_max - 1)
+
+#define EXT_ROOT_HDR(tree) \
+	((struct ext4_extent_header *) (tree)->root)
+#define EXT_BLOCK_HDR(bh) \
+	((struct ext4_extent_header *) (bh)->b_data)
+#define EXT_DEPTH(_t_)	\
+	(((struct ext4_extent_header *)((_t_)->root))->eh_depth)
+#define EXT_GENERATION(_t_)	\
+	(((struct ext4_extent_header *)((_t_)->root))->eh_generation)
+
+
+#define EXT_ASSERT(__x__) if (!(__x__)) BUG();
+
+
+/*
+ * this structure is used to gather extents from the tree via ioctl
+ */
+struct ext4_extent_buf {
+	unsigned long start;
+	int buflen;
+	void *buffer;
+	void *cur;
+	int err;
+};
+
+/*
+ * this structure is used to collect stats info about the tree
+ */
+struct ext4_extent_tree_stats {
+	int depth;
+	int extents_num;
+	int leaf_num;
+};
+
+#ifdef __KERNEL__
+/*
+ * ext4_extents_tree is used to pass initial information
+ * to top-level extents API
+ */
+struct ext4_extents_helpers;
+struct ext4_extents_tree {
+	struct inode *inode;	/* inode which tree belongs to */
+	void *root;		/* ptr to data top of tree resides at */
+	void *buffer;		/* will be passed as arg to ^^ routines	*/
+	int buffer_len;
+	void *private;
+	struct ext4_extent *cex;/* last found extent */
+	struct ext4_extents_helpers *ops;
+};
+
+struct ext4_extents_helpers {
+	int (*get_write_access)(handle_t *h, void *buffer);
+	int (*mark_buffer_dirty)(handle_t *h, void *buffer);
+	int (*mergable)(struct ext4_extent *ex1, struct ext4_extent *ex2);
+	int (*remove_extent_credits)(struct ext4_extents_tree *,
+					struct ext4_extent *, unsigned long,
+					unsigned long);
+	int (*remove_extent)(struct ext4_extents_tree *,
+				struct ext4_extent *, unsigned long,
+				unsigned long);
+	int (*new_block)(handle_t *, struct ext4_extents_tree *,
+				struct ext4_ext_path *, struct ext4_extent *,
+				int *);
+};
+
+/*
+ * to be called by ext4_ext_walk_space()
+ * negative retcode - error
+ * positive retcode - signal for ext4_ext_walk_space(), see below
+ * callback must return valid extent (passed or newly created)
+ */
+typedef int (*ext_prepare_callback)(struct ext4_extents_tree *,
+					struct ext4_ext_path *,
+					struct ext4_extent *, int);
+void ext4_init_tree_desc(struct ext4_extents_tree *, struct inode *);
+extern int ext4_extent_tree_init(handle_t *, struct ext4_extents_tree *);
+extern int ext4_ext_calc_credits_for_insert(struct ext4_extents_tree *, struct ext4_ext_path *);
+extern int ext4_ext_insert_extent(handle_t *, struct ext4_extents_tree *, struct ext4_ext_path *, struct ext4_extent *);
+extern int ext4_ext_walk_space(struct ext4_extents_tree *, unsigned long, unsigned long, ext_prepare_callback);
+extern int ext4_ext_remove_space(struct ext4_extents_tree *, unsigned long, unsigned long);
+extern struct ext4_ext_path * ext4_ext_find_extent(struct ext4_extents_tree *, int, struct ext4_ext_path *);
+
+static inline void
+ext4_ext_invalidate_cache(struct ext4_extents_tree *tree)
+{
+	if (tree->cex)
+		tree->cex->ee_len = 0;
+}
+#endif /* __KERNEL__ */
+
+
+#endif /* _LINUX_EXT4_EXTENTS */
+
Index: e2fsprogs-1.39/lib/ext2fs/extents.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ e2fsprogs-1.39/lib/ext2fs/extents.c	2006-09-18 17:23:02.000000000 +0200
@@ -0,0 +1,340 @@
+/*
+ * extent.c --- iterate over all blocks in an extent-mapped inode
+ *
+ * Copyright (C) 2005 Alex Tomas <alex@clusterfs.com>
+ * Copyright (C) 2006 Andreas Dilger <adilger@clusterfs.com>
+ *
+ * %Begin-Header%
+ * This file may be redistributed under the terms of the GNU Public
+ * License.
+ * %End-Header%
+ */
+
+#include <stdio.h>
+#include <string.h>
+#if HAVE_UNISTD_H
+#include <unistd.h>
+#endif
+
+#include "ext2_fs.h"
+#include "ext2fs.h"
+#include "block.h"
+
+#ifdef EXT_DEBUG
+void show_header(struct ext4_extent_header *eh)
+{
+	printf("header: magic=%x entries=%u max=%u depth=%u generation=%u\n",
+	       eh->eh_magic, eh->eh_entries, eh->eh_max, eh->eh_depth,
+	       eh->eh_generation);
+}
+
+void show_index(struct ext4_extent_idx *ix)
+{
+	printf("index: block=%u leaf=%u leaf_hi=%u unused=%u\n",
+	       ix->ei_block, ix->ei_leaf, ix->ei_leaf_hi, ix->ei_unused);
+}
+
+void show_extent(struct ext4_extent *ex)
+{
+	printf("extent: block=%u-%u len=%u start=%u start_hi=%u\n",
+	       ex->ee_block, ex->ee_block + ex->ee_len - 1,
+	       ex->ee_len, ex->ee_start, ex->ee_start_hi);
+}
+#else
+#define show_header(eh) do { } while (0)
+#define show_index(ix) do { } while (0)
+#define show_extent(ex) do { } while (0)
+#endif
+
+errcode_t ext2fs_extent_header_verify(struct ext4_extent_header *eh, int size)
+{
+	int eh_max, entry_size;
+
+	show_header(eh);
+	if (eh->eh_magic != EXT4_EXT_MAGIC)
+		return EXT2_ET_EXTENT_HEADER_BAD;
+	if (eh->eh_entries > eh->eh_max)
+		return EXT2_ET_EXTENT_HEADER_BAD;
+	if (eh->eh_depth == 0)
+		entry_size = sizeof(struct ext4_extent);
+	else
+		entry_size = sizeof(struct ext4_extent_idx);
+
+	eh_max = (size - sizeof(*eh)) / entry_size;
+	if (eh->eh_max > eh_max || eh->eh_max < eh_max - 2)
+		return EXT2_ET_EXTENT_HEADER_BAD;
+
+	return 0;
+}
+
+errcode_t ext2fs_extent_verify(ext2_filsys fs, struct ext4_extent *ex,
+			       struct ext4_extent *ex_prev,
+			       struct ext4_extent_idx *ix, int ix_len)
+{
+	show_extent(ex);
+	/* FIXME: 48-bit support */
+	if (ex->ee_start > fs->super->s_blocks_count)
+		return EXT2_ET_EXTENT_LEAF_BAD;
+
+	if (ex->ee_len == 0)
+		return EXT2_ET_EXTENT_LEAF_BAD;
+
+	if (ex_prev) {
+		/* We can't have a zero logical block except for first index */
+		if (ex->ee_block == 0)
+			return EXT2_ET_EXTENT_LEAF_BAD;
+
+		/* FIXME: 48-bit support */
+		/* extents must be in logical offset order */
+		if (ex->ee_block < ex_prev->ee_block + ex_prev->ee_len)
+			return EXT2_ET_EXTENT_LEAF_BAD;
+
+		/* extents must not overlap physical blocks */
+		if ((ex->ee_start < ex_prev->ee_start + ex_prev->ee_len) &&
+		    (ex->ee_start + ex->ee_len > ex_prev->ee_start))
+			return EXT2_ET_EXTENT_LEAF_BAD;
+	}
+
+	if (ix) {
+		/* FIXME: 48-bit support */
+		if (ex->ee_block < ix->ei_block)
+			return EXT2_ET_EXTENT_LEAF_BAD;
+
+		if (ix_len && ex->ee_block + ex->ee_len > ix->ei_block + ix_len)
+			return EXT2_ET_EXTENT_LEAF_BAD;
+	}
+
+	return 0;
+}
+
+errcode_t ext2fs_extent_index_verify(ext2_filsys fs, struct ext4_extent_idx *ix,
+				     struct ext4_extent_idx *ix_prev)
+{
+	show_index(ix);
+	/* FIXME: 48-bit support */
+	if (ix->ei_leaf > fs->super->s_blocks_count)
+		return EXT2_ET_EXTENT_INDEX_BAD;
+
+	if (ix_prev == NULL)
+		return 0;
+
+	/* We can't have a zero logical block except for first index */
+	if (ix->ei_block == 0)
+		return EXT2_ET_EXTENT_INDEX_BAD;
+
+	if (ix->ei_block <= ix_prev->ei_block)
+		return EXT2_ET_EXTENT_INDEX_BAD;
+
+	return 0;
+}
+
+errcode_t ext2fs_extent_remove(struct ext4_extent_header *eh,
+			       struct ext4_extent *ex)
+{
+	int entry = ex - EXT_FIRST_EXTENT(eh);
+
+	if (entry < 0 || entry > eh->eh_entries)
+		return EXT2_ET_EXTENT_LEAF_BAD;
+
+	memmove(ex, ex + 1, (eh->eh_entries - entry - 1) * sizeof(*ex));
+	--eh->eh_entries;
+
+	return 0;
+}
+
+errcode_t ext2fs_extent_split(struct ext4_extent_header *eh,
+			      struct ext4_extent *ex, int count)
+{
+	int entry = ex - EXT_FIRST_EXTENT(eh);
+	struct ext4_extent *ex_new = ex + 1;
+
+	if (entry < 0 || entry > eh->eh_entries)
+		return EXT2_ET_EXTENT_LEAF_BAD;
+
+	if (eh->eh_entries >= eh->eh_max)
+		return EXT2_ET_EXTENT_NO_SPACE;
+
+	if (count > ex->ee_len)
+		return EXT2_ET_EXTENT_LEAF_BAD;
+
+	if (count > ex->ee_len)
+		return EXT2_ET_EXTENT_LEAF_BAD;
+
+	memmove(ex_new, ex, (eh->eh_entries - entry) * sizeof(*ex));
+	++eh->eh_entries;
+
+	ex->ee_len = count;
+	/* FIXME: 48-bit support */
+	ex_new->ee_len -= count;
+	ex_new->ee_block += count;
+	ex_new->ee_start += count;
+
+	return 0;
+}
+
+errcode_t ext2fs_extent_index_remove(struct ext4_extent_header *eh,
+				     struct ext4_extent_idx *ix)
+{
+	struct ext4_extent_idx *first = EXT_FIRST_INDEX(eh);
+	int count = ix - first;
+
+	memmove(ix, ix + 1, (eh->eh_entries - count - 1) * sizeof(*ix));
+	--eh->eh_entries;
+
+	return 0;
+}
+
+/* Internal function for ext2fs_block_iterate().
+ * See also block_bmap_extents(). */
+int block_iterate_extents(struct ext4_extent_header *eh, blk_t ref_block,
+			  int ref_offset EXT2FS_ATTR((unused)),
+			  struct block_context *ctx)
+{
+	int ret = 0;
+	int i, j, flags;
+	blk_t  block_address;
+	struct ext4_extent *ex, *ex_prev = NULL;
+
+	if (eh->eh_depth == 0) {
+		ex = EXT_FIRST_EXTENT(eh);
+		for (i = 0; i < eh->eh_entries; i++, ex++) {
+			show_extent(ex);
+			for (j = 0; j < ex->ee_len; j++) {
+				block_address = ex->ee_start + j;
+				flags = (*ctx->func)(ctx->fs, &block_address,
+						     (ex->ee_block + j),
+						     ref_block, i,
+						     ctx->priv_data);
+				if (flags & BLOCK_ABORT) {
+					ret |= BLOCK_ABORT;
+					return ret;
+				}
+				if (!(flags & BLOCK_CHANGED))
+					continue;
+
+#ifdef EXT_DEBUG
+				printf("ugh, extent leaf changed: "
+				       "block was %u+%u = %u, now %u\n",
+				       ex->ee_start, j,
+				       ex->ee_start + j, block_address);
+#endif
+
+				/* FIXME: 48-bit support */
+				if (ex_prev &&
+				    block_address ==
+				    ex_prev->ee_start + ex_prev->ee_len &&
+				    ex->ee_block + j ==
+				    ex_prev->ee_block + ex_prev->ee_len) {
+					/* can merge block with prev extent */
+					ex_prev->ee_len++;
+
+					ex->ee_len--;
+					if (ex->ee_len == 0) {
+						/* no blocks left in this one */
+						ext2fs_extent_remove(eh, ex);
+						i--; ex--;
+						break;
+					} else {
+						ex->ee_start++;
+						ex->ee_block++;
+						j--;
+					}
+					ret |= BLOCK_CHANGED;
+
+				} else if (ex->ee_len == 1) {
+					/* single-block extent is easy -
+					 * change extent directly */
+					ex->ee_start = block_address;
+					ret |= BLOCK_CHANGED;
+
+				} else if (ext2fs_extent_split(eh, ex, j)) {
+					/* split for new block failed */
+					/* No multi-level split yet */
+					ret |= BLOCK_ABORT | BLOCK_ERROR;
+					return ret;
+
+				} else if (j > 0 && (ex + 1)->ee_len > 1 &&
+					   ext2fs_extent_split(eh, ex + 1, 1)) {
+					/* split after new block failed */
+					/* No multi-level split yet */
+					ret |= BLOCK_ABORT | BLOCK_ERROR;
+					return ret;
+
+				} else if (j == 0) {
+					if (ex->ee_len != 1) {
+						/* this is an internal error */
+						ret |= BLOCK_ABORT |BLOCK_ERROR;
+						return ret;
+					}
+					ex->ee_start = block_address;
+					ret |= BLOCK_CHANGED;
+
+				} else {
+					ex++;
+					i++;
+					if (ex->ee_len != 1) {
+						/* this is an internal error */
+						ret |= BLOCK_ABORT |BLOCK_ERROR;
+						return ret;
+					}
+					ex->ee_start = block_address;
+					ret |= BLOCK_CHANGED;
+				}
+			}
+			ex_prev = ex;
+		}
+	} else {
+		char *block_buf;
+		struct ext4_extent_idx *ix;
+		struct ext4_extent_header *nh;
+
+		ret = ext2fs_get_mem(ctx->fs->blocksize, &block_buf);
+		if (ret)
+			return ret;
+
+		show_header(eh);
+		ix = EXT_FIRST_INDEX(eh);
+		for (i = 0; i < eh->eh_entries; i++, ix++) {
+			show_index(ix);
+			if (!(ctx->flags & BLOCK_FLAG_DEPTH_TRAVERSE) &&
+			    !(ctx->flags & BLOCK_FLAG_DATA_ONLY)) {
+				ret |= (*ctx->func)(ctx->fs, &ix->ei_leaf,
+						    BLOCK_COUNT_IND, ref_block,
+						    i, ctx->priv_data);
+				if (ret & BLOCK_ABORT)
+					goto free_buf;
+			}
+			ctx->errcode = ext2fs_read_ext_block(ctx->fs,
+							     ix->ei_leaf,
+							     block_buf);
+			if (ctx->errcode) {
+				ret |= BLOCK_ERROR;
+				goto free_buf;
+			}
+			nh = (struct ext4_extent_header *)block_buf;
+			if (ext2fs_extent_header_verify(nh,ctx->fs->blocksize)){
+				ret |= BLOCK_ERROR;
+				goto free_buf;
+			}
+			flags = block_iterate_extents(nh, ix->ei_leaf, i, ctx);
+			if (flags & BLOCK_CHANGED)
+				ctx->errcode =
+					ext2fs_write_ext_block(ctx->fs,
+							       ix->ei_leaf,
+							       block_buf);
+			if (flags & BLOCK_ABORT) {
+				ret |= BLOCK_ABORT;
+				goto free_buf;
+			}
+			if ((ctx->flags & BLOCK_FLAG_DEPTH_TRAVERSE) &&
+			    !(ctx->flags & BLOCK_FLAG_DATA_ONLY))
+				ret |= (*ctx->func)(ctx->fs, &ix->ei_leaf,
+						     BLOCK_COUNT_IND, ref_block,
+						     i, ctx->priv_data);
+		}
+
+	free_buf:
+		ext2fs_free_mem(&block_buf);
+	}
+	return ret;
+}
Index: e2fsprogs-1.39/lib/ext2fs/ind_block.c
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/ind_block.c	2005-09-06 11:40:14.000000000 +0200
+++ e2fsprogs-1.39/lib/ext2fs/ind_block.c	2006-09-18 17:23:02.000000000 +0200
@@ -22,9 +22,6 @@
 errcode_t ext2fs_read_ind_block(ext2_filsys fs, blk_t blk, void *buf)
 {
 	errcode_t	retval;
-	blk_t		*block_nr;
-	int		i;
-	int		limit = fs->blocksize >> 2;
 
 	if ((fs->flags & EXT2_FLAG_IMAGE_FILE) &&
 	    (fs->io != fs->image_io))
@@ -36,7 +33,10 @@ errcode_t ext2fs_read_ind_block(ext2_fil
 	}
 #ifdef EXT2FS_ENABLE_SWAPFS
 	if (fs->flags & (EXT2_FLAG_SWAP_BYTES | EXT2_FLAG_SWAP_BYTES_READ)) {
-		block_nr = (blk_t *) buf;
+		int	limit = fs->blocksize >> 2;
+		blk_t	*block_nr = (blk_t *)buf;
+		int	i;
+
 		for (i = 0; i < limit; i++, block_nr++)
 			*block_nr = ext2fs_swab32(*block_nr);
 	}
@@ -46,16 +46,15 @@ errcode_t ext2fs_read_ind_block(ext2_fil
 
 errcode_t ext2fs_write_ind_block(ext2_filsys fs, blk_t blk, void *buf)
 {
-	blk_t		*block_nr;
-	int		i;
-	int		limit = fs->blocksize >> 2;
-
 	if (fs->flags & EXT2_FLAG_IMAGE_FILE)
 		return 0;
 
 #ifdef EXT2FS_ENABLE_SWAPFS
 	if (fs->flags & (EXT2_FLAG_SWAP_BYTES | EXT2_FLAG_SWAP_BYTES_WRITE)) {
-		block_nr = (blk_t *) buf;
+		int	limit = fs->blocksize >> 2;
+		blk_t	*block_nr = (blk_t *)buf;
+		int	i;
+
 		for (i = 0; i < limit; i++, block_nr++)
 			*block_nr = ext2fs_swab32(*block_nr);
 	}
@@ -64,3 +63,82 @@ errcode_t ext2fs_write_ind_block(ext2_fi
 }
 
 
+errcode_t ext2fs_read_ext_block(ext2_filsys fs, blk_t blk, void *buf)
+{
+	errcode_t	retval;
+
+	if ((fs->flags & EXT2_FLAG_IMAGE_FILE) &&
+	    (fs->io != fs->image_io))
+		memset(buf, 0, fs->blocksize);
+	else {
+		retval = io_channel_read_blk(fs->io, blk, 1, buf);
+		if (retval)
+			return retval;
+	}
+#ifdef EXT2FS_ENABLE_SWAPFS
+	if (fs->flags & (EXT2_FLAG_SWAP_BYTES | EXT2_FLAG_SWAP_BYTES_READ)) {
+		struct ext4_extent_header *eh = buf;
+		int i, limit;
+
+		ext2fs_swap_extent_header(eh);
+
+		if (eh->eh_depth == 0) {
+			struct ext4_extent *ex = EXT_FIRST_EXTENT(eh);
+
+			limit = (fs->blocksize - sizeof(*eh)) / sizeof(*ex);
+			if (eh->eh_entries < limit)
+				limit = eh->eh_entries;
+
+			for (i = 0; i < limit; i++, ex++)
+				ext2fs_swap_extent(ex);
+		} else {
+			struct ext4_extent_idx *ix = EXT_FIRST_INDEX(eh);
+
+			limit = (fs->blocksize - sizeof(*eh)) / sizeof(*ix);
+			if (eh->eh_entries < limit)
+				limit = eh->eh_entries;
+
+			for (i = 0; i < limit; i++, ix++)
+				ext2fs_swap_extent_index(ix);
+		}
+	}
+#endif
+	return 0;
+}
+
+errcode_t ext2fs_write_ext_block(ext2_filsys fs, blk_t blk, void *buf)
+{
+	if (fs->flags & EXT2_FLAG_IMAGE_FILE)
+		return 0;
+
+#ifdef EXT2FS_ENABLE_SWAPFS
+	if (fs->flags & (EXT2_FLAG_SWAP_BYTES | EXT2_FLAG_SWAP_BYTES_WRITE)) {
+		struct ext4_extent_header *eh = buf;
+		int i, limit;
+
+		if (eh->eh_depth == 0) {
+			struct ext4_extent *ex = EXT_FIRST_EXTENT(eh);
+
+			limit = (fs->blocksize - sizeof(*eh)) / sizeof(*ex);
+			if (eh->eh_entries < limit)
+				limit = eh->eh_entries;
+
+			for (i = 0; i < limit; i++, ex++)
+				ext2fs_swap_extent(ex);
+		} else {
+			struct ext4_extent_idx *ix = EXT_FIRST_INDEX(eh);
+
+			limit = (fs->blocksize - sizeof(*eh)) / sizeof(*ix);
+			if (eh->eh_entries < limit)
+				limit = eh->eh_entries;
+
+			for (i = 0; i < limit; i++, ix++)
+				ext2fs_swap_extent_index(ix);
+		}
+
+		ext2fs_swap_extent_header(eh);
+	}
+#endif
+	return io_channel_write_blk(fs->io, blk, 1, buf);
+}
+
Index: e2fsprogs-1.39/lib/ext2fs/swapfs.c
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/swapfs.c	2006-04-23 18:47:16.000000000 +0200
+++ e2fsprogs-1.39/lib/ext2fs/swapfs.c	2006-09-18 17:23:02.000000000 +0200
@@ -120,6 +120,28 @@ void ext2fs_swap_ext_attr(char *to, char
 	}
 }
 
+void ext2fs_swap_extent_header(struct ext4_extent_header *eh) {
+	eh->eh_magic = ext2fs_swab16(eh->eh_magic);
+	eh->eh_entries = ext2fs_swab16(eh->eh_entries);
+	eh->eh_max = ext2fs_swab16(eh->eh_max);
+	eh->eh_depth = ext2fs_swab16(eh->eh_depth);
+	eh->eh_generation = ext2fs_swab32(eh->eh_generation);
+}
+
+void ext2fs_swap_extent_index(struct ext4_extent_idx *ix) {
+	ix->ei_block = ext2fs_swab32(ix->ei_block);
+	ix->ei_leaf = ext2fs_swab32(ix->ei_leaf);
+	ix->ei_leaf_hi = ext2fs_swab16(ix->ei_leaf_hi);
+	ix->ei_unused = ext2fs_swab16(ix->ei_unused);
+}
+
+void ext2fs_swap_extent(struct ext4_extent *ex) {
+	ex->ee_block = ext2fs_swab32(ex->ee_block);
+	ex->ee_len = ext2fs_swab16(ex->ee_len);
+	ex->ee_start_hi =ext2fs_swab16(ex->ee_start_hi);
+	ex->ee_start = ext2fs_swab32(ex->ee_start);
+}
+
 void ext2fs_swap_inode_full(ext2_filsys fs, struct ext2_inode_large *t,
 			    struct ext2_inode_large *f, int hostorder,
 			    int bufsize)
Index: e2fsprogs-1.39/lib/ext2fs/valid_blk.c
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/valid_blk.c	2005-09-06 11:40:14.000000000 +0200
+++ e2fsprogs-1.39/lib/ext2fs/valid_blk.c	2006-09-18 17:23:02.000000000 +0200
@@ -19,6 +19,7 @@
 
 #include "ext2_fs.h"
 #include "ext2fs.h"
+#include "ext4_extents.h"
 
 /*
  * This function returns 1 if the inode's block entries actually
@@ -41,12 +42,23 @@ int ext2fs_inode_has_valid_blocks(struct
 	if (LINUX_S_ISLNK (inode->i_mode)) {
 		if (inode->i_file_acl == 0) {
 			/* With no EA block, we can rely on i_blocks */
-			if (inode->i_blocks == 0)
-				return 0;
+			if (inode->i_flags & EXT4_EXTENTS_FL) {
+				struct ext4_extent_header *eh;
+				eh = (struct ext4_extent_header *)inode->i_block;
+				if (eh->eh_entries == 0) 
+					return 0;
+			} else {
+				if (inode->i_blocks == 0)
+					return 0;
+			}
 		} else {
 			/* With an EA block, life gets more tricky */
 			if (inode->i_size >= EXT2_N_BLOCKS*4)
 				return 1; /* definitely using i_block[] */
+			/* 
+			 * we cant have EA + extents, so assume we aren't
+			 * using extents
+			 */
 			if (inode->i_size > 4 && inode->i_block[1] == 0)
 				return 1; /* definitely using i_block[] */
 			return 0; /* Probably a fast symlink */
Index: e2fsprogs-1.39/tests/f_bad_disconnected_inode/expect.1
===================================================================
--- e2fsprogs-1.39.orig/tests/f_bad_disconnected_inode/expect.1	2005-09-06 11:40:14.000000000 +0200
+++ e2fsprogs-1.39/tests/f_bad_disconnected_inode/expect.1	2006-09-18 17:23:02.000000000 +0200
@@ -1,4 +1,10 @@
 Pass 1: Checking inodes, blocks, and sizes
+Inode 15 has EXTENT_FL set, but is not in extents format
+Fix? yes
+
+Inode 16 has EXTENT_FL set, but is not in extents format
+Fix? yes
+
 Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 /lost+found not found.  Create? yes
Index: e2fsprogs-1.39/tests/f_bbfile/expect.1
===================================================================
--- e2fsprogs-1.39.orig/tests/f_bbfile/expect.1	2005-09-06 11:40:14.000000000 +0200
+++ e2fsprogs-1.39/tests/f_bbfile/expect.1	2006-09-18 17:23:02.000000000 +0200
@@ -3,46 +3,60 @@ Filesystem did not have a UUID; generati
 Pass 1: Checking inodes, blocks, and sizes
 Group 0's inode bitmap (4) is bad.  Relocate? yes
 
+Inode 11 has corrupt indirect block
+Clear? yes
+
 Relocating group 0's inode bitmap from 4 to 43...
+Restarting e2fsck from the beginning...
+Pass 1: Checking inodes, blocks, and sizes
 
 Running additional passes to resolve blocks claimed by more than one inode...
 Pass 1B: Rescanning for multiply-claimed blocks
 Multiply-claimed block(s) in inode 2: 21
-Multiply-claimed block(s) in inode 11: 9 10 11 12 13 14 15 16 17 18 19 20
 Multiply-claimed block(s) in inode 12: 25 26
 Pass 1C: Scanning directories for inodes with multiply-claimed blocks
 Pass 1D: Reconciling multiply-claimed blocks
-(There are 3 inodes containing multiply-claimed blocks.)
+(There are 2 inodes containing multiply-claimed blocks.)
 
 File / (inode #2, mod time Sun Jan  2 08:29:13 1994) 
   has 1 multiply-claimed block(s), shared with 1 file(s):
 	<The bad blocks inode> (inode #1, mod time Sun Jul 17 00:47:58 1994)
 Clone multiply-claimed blocks? yes
 
-File /lost+found (inode #11, mod time Sun Jan  2 08:28:40 1994) 
-  has 12 multiply-claimed block(s), shared with 1 file(s):
-	<The bad blocks inode> (inode #1, mod time Sun Jul 17 00:47:58 1994)
-Clone multiply-claimed blocks? yes
-
 File /termcap (inode #12, mod time Sun Jan  2 08:29:13 1994) 
   has 2 multiply-claimed block(s), shared with 1 file(s):
 	<The bad blocks inode> (inode #1, mod time Sun Jul 17 00:47:58 1994)
 Clone multiply-claimed blocks? yes
 
 Pass 2: Checking directory structure
+Entry 'lost+found' in / (2) has deleted/unused inode 11.  Clear? yes
+
 Pass 3: Checking directory connectivity
+/lost+found not found.  Create? yes
+
 Pass 4: Checking reference counts
+Inode 2 ref count is 4, should be 3.  Fix? yes
+
 Pass 5: Checking group summary information
 Block bitmap differences:  +43
 Fix? yes
 
-Free blocks count wrong for group #0 (57, counted=41).
+Free blocks count wrong for group #0 (56, counted=52).
+Fix? yes
+
+Free blocks count wrong (56, counted=52).
+Fix? yes
+
+Free inodes count wrong for group #0 (19, counted=20).
+Fix? yes
+
+Directories count wrong for group #0 (3, counted=2).
 Fix? yes
 
-Free blocks count wrong (57, counted=41).
+Free inodes count wrong (19, counted=20).
 Fix? yes
 
 
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
-test_filesys: 12/32 files (0.0% non-contiguous), 59/100 blocks
+test_filesys: 12/32 files (0.0% non-contiguous), 48/100 blocks
 Exit status is 1
Index: e2fsprogs-1.39/tests/f_bbfile/expect.2
===================================================================
--- e2fsprogs-1.39.orig/tests/f_bbfile/expect.2	2005-09-06 11:40:14.000000000 +0200
+++ e2fsprogs-1.39/tests/f_bbfile/expect.2	2006-09-18 17:23:02.000000000 +0200
@@ -3,5 +3,5 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 12/32 files (8.3% non-contiguous), 59/100 blocks
+test_filesys: 12/32 files (8.3% non-contiguous), 48/100 blocks
 Exit status is 0
Index: e2fsprogs-1.39/tests/f_extents/expect.1
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ e2fsprogs-1.39/tests/f_extents/expect.1	2006-09-18 17:23:02.000000000 +0200
@@ -0,0 +1,61 @@
+Pass 1: Checking inodes, blocks, and sizes
+Inode 12 is in extent format, but superblock is missing EXTENTS feature
+Fix? yes
+
+Inode 13 missing EXTENT_FL, but is in extents format
+Fix? yes
+
+Inode 16 has corrupt extent at block 3 (logical 4613) length 2
+Clear? yes
+
+Inode 16, i_blocks is 16, should be 12.  Fix? yes
+
+Inode 18 has EXTENT_FL set, but is not in extents format
+Fix? yes
+
+Inode 19 has EXTENT_FL set, but is not in extents format
+Fix? yes
+
+Inode 17 has high 16 bits of extent/index block set
+Clear? yes
+
+High 16 bits of extent/index block set
+CLEARED.
+High 16 bits of extent/index block set
+CLEARED.
+
+Running additional passes to resolve blocks claimed by more than one inode...
+Pass 1B: Rescanning for multiply-claimed blocks
+Multiply-claimed block(s) in inode 12: 5133 5124 5125 5129 5132 5133 5142 5143 5144 5145
+Multiply-claimed block(s) in inode 17: 5124 5125 5129 5132 5142 5143 5144 5145
+Pass 1C: Scanning directories for inodes with multiply-claimed blocks
+Pass 1D: Reconciling multiply-claimed blocks
+(There are 2 inodes containing multiply-claimed blocks.)
+
+File /fdup1 (inode #12, mod time Wed Jul  5 21:55:26 2006) 
+  has 10 multiply-claimed block(s), shared with 1 file(s):
+	/fdup2 (inode #17, mod time Wed Jul  5 21:55:27 2006)
+Clone multiply-claimed blocks? yes
+
+File /fdup2 (inode #17, mod time Wed Jul  5 21:55:27 2006) 
+  has 8 multiply-claimed block(s), shared with 1 file(s):
+	/fdup1 (inode #12, mod time Wed Jul  5 21:55:26 2006)
+Multiply-claimed blocks already reassigned or cloned.
+
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+Block bitmap differences:  +4611 -(4613--4614) -(5121--5122) +(5143--5146)
+Fix? yes
+
+Free blocks count wrong for group #0 (7081, counted=7066).
+Fix? yes
+
+Free blocks count wrong (7081, counted=7066).
+Fix? yes
+
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 19/256 files (15.8% non-contiguous), 1126/8192 blocks
+Exit status is 1
Index: e2fsprogs-1.39/tests/f_extents/expect.2
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ e2fsprogs-1.39/tests/f_extents/expect.2	2006-09-18 17:23:02.000000000 +0200
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 19/256 files (15.8% non-contiguous), 1126/8192 blocks
+Exit status is 0
Index: e2fsprogs-1.39/tests/f_extents/name
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ e2fsprogs-1.39/tests/f_extents/name	2006-09-18 17:23:02.000000000 +0200
@@ -0,0 +1 @@
+extent-mapped files with errors
Index: e2fsprogs-1.39/tests/f_lotsbad/expect.1
===================================================================
--- e2fsprogs-1.39.orig/tests/f_lotsbad/expect.1	2005-09-06 11:40:14.000000000 +0200
+++ e2fsprogs-1.39/tests/f_lotsbad/expect.1	2006-09-18 17:23:02.000000000 +0200
@@ -8,54 +8,41 @@ Inode 13, i_size is 15360, should be 122
 
 Inode 13, i_blocks is 32, should be 30.  Fix? yes
 
-Inode 12 has illegal block(s).  Clear? yes
+Inode 12 has corrupt indirect block
+Clear? yes
 
-Illegal block #12 (778398818) in inode 12.  CLEARED.
-Illegal block #13 (1768444960) in inode 12.  CLEARED.
-Illegal block #14 (1752375411) in inode 12.  CLEARED.
-Illegal block #15 (1684829551) in inode 12.  CLEARED.
-Illegal block #16 (1886349344) in inode 12.  CLEARED.
-Illegal block #17 (1819633253) in inode 12.  CLEARED.
-Illegal block #18 (1663072620) in inode 12.  CLEARED.
-Illegal block #19 (1735287144) in inode 12.  CLEARED.
-Illegal block #20 (1310731877) in inode 12.  CLEARED.
-Illegal block #21 (560297071) in inode 12.  CLEARED.
-Illegal block #22 (543512352) in inode 12.  CLEARED.
-Too many illegal blocks in inode 12.
-Clear inode? yes
+Inode 12, i_blocks is 34, should be 24.  Fix? yes
 
-Restarting e2fsck from the beginning...
-Pass 1: Checking inodes, blocks, and sizes
 Pass 2: Checking directory structure
-Entry 'termcap' in / (2) has deleted/unused inode 12.  Clear? yes
+Directory inode 13 has an unallocated block #16580876.  Allocate? yes
 
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Inode 2 ref count is 5, should be 4.  Fix? yes
 
 Pass 5: Checking group summary information
-Block bitmap differences:  -(27--41) -(44--45) -(74--90)
+Block bitmap differences:  -(38--41) -(74--90)
 Fix? yes
 
-Free blocks count wrong for group #0 (9, counted=43).
+Free blocks count wrong for group #0 (9, counted=30).
 Fix? yes
 
-Free blocks count wrong (9, counted=43).
+Free blocks count wrong (9, counted=30).
 Fix? yes
 
-Inode bitmap differences:  -12 -14
+Inode bitmap differences:  -14
 Fix? yes
 
-Free inodes count wrong for group #0 (18, counted=20).
+Free inodes count wrong for group #0 (18, counted=19).
 Fix? yes
 
 Directories count wrong for group #0 (4, counted=3).
 Fix? yes
 
-Free inodes count wrong (18, counted=20).
+Free inodes count wrong (18, counted=19).
 Fix? yes
 
 
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
-test_filesys: 12/32 files (0.0% non-contiguous), 57/100 blocks
+test_filesys: 13/32 files (7.7% non-contiguous), 70/100 blocks
 Exit status is 1
Index: e2fsprogs-1.39/tests/f_messy_inode/expect.1
===================================================================
--- e2fsprogs-1.39.orig/tests/f_messy_inode/expect.1	2005-09-06 11:40:15.000000000 +0200
+++ e2fsprogs-1.39/tests/f_messy_inode/expect.1	2006-09-18 17:23:02.000000000 +0200
@@ -1,38 +1,36 @@
 Filesystem did not have a UUID; generating one.
 
 Pass 1: Checking inodes, blocks, and sizes
-Inode 14 has illegal block(s).  Clear? yes
-
-Illegal block #2 (4294901760) in inode 14.  CLEARED.
-Illegal block #3 (4294901760) in inode 14.  CLEARED.
-Illegal block #4 (4294901760) in inode 14.  CLEARED.
-Illegal block #5 (4294901760) in inode 14.  CLEARED.
-Illegal block #6 (4294901760) in inode 14.  CLEARED.
-Illegal block #7 (4294901760) in inode 14.  CLEARED.
-Illegal block #8 (4294901760) in inode 14.  CLEARED.
-Illegal block #9 (4294901760) in inode 14.  CLEARED.
-Illegal block #10 (4294901760) in inode 14.  CLEARED.
-Inode 14, i_size is 18446462598732849291, should be 2048.  Fix? yes
-
-Inode 14, i_blocks is 18, should be 4.  Fix? yes
+Inode 14 has corrupt indirect block
+Clear? yes
 
+Restarting e2fsck from the beginning...
+Pass 1: Checking inodes, blocks, and sizes
 Pass 2: Checking directory structure
-i_file_acl for inode 14 (/MAKEDEV) is 4294901760, should be zero.
-Clear? yes
+Entry 'MAKEDEV' in / (2) has deleted/unused inode 14.  Clear? yes
 
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-Block bitmap differences:  -(43--49)
+Block bitmap differences:  -(41--49)
+Fix? yes
+
+Free blocks count wrong for group #0 (68, counted=77).
+Fix? yes
+
+Free blocks count wrong (68, counted=77).
+Fix? yes
+
+Inode bitmap differences:  -14
 Fix? yes
 
-Free blocks count wrong for group #0 (68, counted=75).
+Free inodes count wrong for group #0 (3, counted=4).
 Fix? yes
 
-Free blocks count wrong (68, counted=75).
+Free inodes count wrong (3, counted=4).
 Fix? yes
 
 
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
-test_filesys: 29/32 files (3.4% non-contiguous), 25/100 blocks
+test_filesys: 28/32 files (0.0% non-contiguous), 23/100 blocks
 Exit status is 1
Index: e2fsprogs-1.39/tests/f_messy_inode/expect.2
===================================================================
--- e2fsprogs-1.39.orig/tests/f_messy_inode/expect.2	2005-09-06 11:40:15.000000000 +0200
+++ e2fsprogs-1.39/tests/f_messy_inode/expect.2	2006-09-18 17:23:02.000000000 +0200
@@ -3,5 +3,5 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 29/32 files (0.0% non-contiguous), 25/100 blocks
+test_filesys: 28/32 files (0.0% non-contiguous), 23/100 blocks
 Exit status is 0
Index: e2fsprogs-1.39/lib/e2p/feature.c
===================================================================
--- e2fsprogs-1.39.orig/lib/e2p/feature.c	2006-05-04 18:06:50.000000000 +0200
+++ e2fsprogs-1.39/lib/e2p/feature.c	2006-09-18 17:32:10.000000000 +0200
@@ -49,7 +49,7 @@ static struct feature feature_list[] = {
 			"needs_recovery" },
 	{	E2P_FEATURE_INCOMPAT, EXT3_FEATURE_INCOMPAT_JOURNAL_DEV,
 			"journal_dev" },
-	{	E2P_FEATURE_INCOMPAT, EXT3_FEATURE_INCOMPAT_EXTENTS,
+	{	E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_EXTENTS,
 			"extents" },
 	{	E2P_FEATURE_INCOMPAT, EXT2_FEATURE_INCOMPAT_META_BG,
 			"meta_bg" },
Index: e2fsprogs-1.39/lib/ext2fs/ext2_fs.h
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/ext2_fs.h	2006-09-18 17:30:56.000000000 +0200
+++ e2fsprogs-1.39/lib/ext2fs/ext2_fs.h	2006-09-18 17:31:24.000000000 +0200
@@ -582,7 +582,7 @@ struct ext2_super_block {
 #define EXT3_FEATURE_INCOMPAT_RECOVER		0x0004 /* Needs recovery */
 #define EXT3_FEATURE_INCOMPAT_JOURNAL_DEV	0x0008 /* Journal device */
 #define EXT2_FEATURE_INCOMPAT_META_BG		0x0010
-#define EXT3_FEATURE_INCOMPAT_EXTENTS		0x0040
+#define EXT4_FEATURE_INCOMPAT_EXTENTS		0x0040
 
 
 #define EXT2_FEATURE_COMPAT_SUPP	0
