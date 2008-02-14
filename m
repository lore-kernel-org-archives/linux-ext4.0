From: akpm@linux-foundation.org
Subject: - xfs-convert-bex_add-to-bex_add_cpu-new-common-api.patch removed from -mm tree
Date: Thu, 14 Feb 2008 14:22:55 -0500
Message-ID: <200802150226.m1F2QE1S015210@imap1.linux-foundation.org>
To: marcin.slusarz@gmail.com, dgc@sgi.com, linux-ext4@vger.kernel.org,
	mark.fasheh@oracle.com, tes@sgi.com, mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38477 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765012AbYBOC0d (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Feb 2008 21:26:33 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     xfs: convert beX_add to beX_add_cpu (new common API)
has been removed from the -mm tree.  Its filename was
     xfs-convert-bex_add-to-bex_add_cpu-new-common-api.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xfs: convert beX_add to beX_add_cpu (new common API)
From: Marcin Slusarz <marcin.slusarz@gmail.com>

remove beX_add functions and replace all uses with beX_add_cpu

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Mark Fasheh <mark.fasheh@oracle.com>
Reviewed-by: Dave Chinner <dgc@sgi.com>
Cc: Timothy Shimmin <tes@sgi.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/quota/xfs_qm.c          |    6 ++--
 fs/xfs/quota/xfs_trans_dquot.c |    6 ++--
 fs/xfs/xfs_alloc.c             |   16 +++++-----
 fs/xfs/xfs_alloc_btree.c       |   16 +++++-----
 fs/xfs/xfs_arch.h              |   15 ----------
 fs/xfs/xfs_attr_leaf.c         |   46 +++++++++++++++----------------
 fs/xfs/xfs_bmap_btree.c        |   16 +++++-----
 fs/xfs/xfs_da_btree.c          |   14 ++++-----
 fs/xfs/xfs_dir2_block.c        |    8 ++---
 fs/xfs/xfs_dir2_data.c         |    4 +-
 fs/xfs/xfs_dir2_leaf.c         |   16 +++++-----
 fs/xfs/xfs_dir2_node.c         |   18 ++++++------
 fs/xfs/xfs_fsops.c             |    4 +-
 fs/xfs/xfs_ialloc.c            |   12 ++++----
 fs/xfs/xfs_ialloc_btree.c      |   16 +++++-----
 fs/xfs/xfs_log.c               |    6 ++--
 fs/xfs/xfs_trans.c             |   24 ++++++++--------
 17 files changed, 114 insertions(+), 129 deletions(-)

diff -puN fs/xfs/quota/xfs_qm.c~xfs-convert-bex_add-to-bex_add_cpu-new-common-api fs/xfs/quota/xfs_qm.c
--- a/fs/xfs/quota/xfs_qm.c~xfs-convert-bex_add-to-bex_add_cpu-new-common-api
+++ a/fs/xfs/quota/xfs_qm.c
@@ -1648,14 +1648,14 @@ xfs_qm_quotacheck_dqadjust(
 	 * Adjust the inode count and the block count to reflect this inode's
 	 * resource usage.
 	 */
-	be64_add(&dqp->q_core.d_icount, 1);
+	be64_add_cpu(&dqp->q_core.d_icount, 1);
 	dqp->q_res_icount++;
 	if (nblks) {
-		be64_add(&dqp->q_core.d_bcount, nblks);
+		be64_add_cpu(&dqp->q_core.d_bcount, nblks);
 		dqp->q_res_bcount += nblks;
 	}
 	if (rtblks) {
-		be64_add(&dqp->q_core.d_rtbcount, rtblks);
+		be64_add_cpu(&dqp->q_core.d_rtbcount, rtblks);
 		dqp->q_res_rtbcount += rtblks;
 	}
 
diff -puN fs/xfs/quota/xfs_trans_dquot.c~xfs-convert-bex_add-to-bex_add_cpu-new-common-api fs/xfs/quota/xfs_trans_dquot.c
--- a/fs/xfs/quota/xfs_trans_dquot.c~xfs-convert-bex_add-to-bex_add_cpu-new-common-api
+++ a/fs/xfs/quota/xfs_trans_dquot.c
@@ -421,13 +421,13 @@ xfs_trans_apply_dquot_deltas(
 				       (xfs_qcnt_t) -qtrx->qt_icount_delta);
 #endif
 			if (totalbdelta)
-				be64_add(&d->d_bcount, (xfs_qcnt_t)totalbdelta);
+				be64_add_cpu(&d->d_bcount, (xfs_qcnt_t)totalbdelta);
 
 			if (qtrx->qt_icount_delta)
-				be64_add(&d->d_icount, (xfs_qcnt_t)qtrx->qt_icount_delta);
+				be64_add_cpu(&d->d_icount, (xfs_qcnt_t)qtrx->qt_icount_delta);
 
 			if (totalrtbdelta)
-				be64_add(&d->d_rtbcount, (xfs_qcnt_t)totalrtbdelta);
+				be64_add_cpu(&d->d_rtbcount, (xfs_qcnt_t)totalrtbdelta);
 
 			/*
 			 * Get any default limits in use.
diff -puN fs/xfs/xfs_alloc.c~xfs-convert-bex_add-to-bex_add_cpu-new-common-api fs/xfs/xfs_alloc.c
--- a/fs/xfs/xfs_alloc.c~xfs-convert-bex_add-to-bex_add_cpu-new-common-api
+++ a/fs/xfs/xfs_alloc.c
@@ -592,7 +592,7 @@ xfs_alloc_ag_vextent(
 		if (!(args->wasfromfl)) {
 
 			agf = XFS_BUF_TO_AGF(args->agbp);
-			be32_add(&agf->agf_freeblks, -(args->len));
+			be32_add_cpu(&agf->agf_freeblks, -(args->len));
 			xfs_trans_agblocks_delta(args->tp,
 						 -((long)(args->len)));
 			args->pag->pagf_freeblks -= args->len;
@@ -1720,7 +1720,7 @@ xfs_free_ag_extent(
 
 		agf = XFS_BUF_TO_AGF(agbp);
 		pag = &mp->m_perag[agno];
-		be32_add(&agf->agf_freeblks, len);
+		be32_add_cpu(&agf->agf_freeblks, len);
 		xfs_trans_agblocks_delta(tp, len);
 		pag->pagf_freeblks += len;
 		XFS_WANT_CORRUPTED_GOTO(
@@ -2008,18 +2008,18 @@ xfs_alloc_get_freelist(
 	 * Get the block number and update the data structures.
 	 */
 	bno = be32_to_cpu(agfl->agfl_bno[be32_to_cpu(agf->agf_flfirst)]);
-	be32_add(&agf->agf_flfirst, 1);
+	be32_add_cpu(&agf->agf_flfirst, 1);
 	xfs_trans_brelse(tp, agflbp);
 	if (be32_to_cpu(agf->agf_flfirst) == XFS_AGFL_SIZE(mp))
 		agf->agf_flfirst = 0;
 	pag = &mp->m_perag[be32_to_cpu(agf->agf_seqno)];
-	be32_add(&agf->agf_flcount, -1);
+	be32_add_cpu(&agf->agf_flcount, -1);
 	xfs_trans_agflist_delta(tp, -1);
 	pag->pagf_flcount--;
 
 	logflags = XFS_AGF_FLFIRST | XFS_AGF_FLCOUNT;
 	if (btreeblk) {
-		be32_add(&agf->agf_btreeblks, 1);
+		be32_add_cpu(&agf->agf_btreeblks, 1);
 		pag->pagf_btreeblks++;
 		logflags |= XFS_AGF_BTREEBLKS;
 	}
@@ -2117,17 +2117,17 @@ xfs_alloc_put_freelist(
 			be32_to_cpu(agf->agf_seqno), &agflbp)))
 		return error;
 	agfl = XFS_BUF_TO_AGFL(agflbp);
-	be32_add(&agf->agf_fllast, 1);
+	be32_add_cpu(&agf->agf_fllast, 1);
 	if (be32_to_cpu(agf->agf_fllast) == XFS_AGFL_SIZE(mp))
 		agf->agf_fllast = 0;
 	pag = &mp->m_perag[be32_to_cpu(agf->agf_seqno)];
-	be32_add(&agf->agf_flcount, 1);
+	be32_add_cpu(&agf->agf_flcount, 1);
 	xfs_trans_agflist_delta(tp, 1);
 	pag->pagf_flcount++;
 
 	logflags = XFS_AGF_FLLAST | XFS_AGF_FLCOUNT;
 	if (btreeblk) {
-		be32_add(&agf->agf_btreeblks, -1);
+		be32_add_cpu(&agf->agf_btreeblks, -1);
 		pag->pagf_btreeblks--;
 		logflags |= XFS_AGF_BTREEBLKS;
 	}
diff -puN fs/xfs/xfs_alloc_btree.c~xfs-convert-bex_add-to-bex_add_cpu-new-common-api fs/xfs/xfs_alloc_btree.c
--- a/fs/xfs/xfs_alloc_btree.c~xfs-convert-bex_add-to-bex_add_cpu-new-common-api
+++ a/fs/xfs/xfs_alloc_btree.c
@@ -221,7 +221,7 @@ xfs_alloc_delrec(
 			 */
 			bno = be32_to_cpu(agf->agf_roots[cur->bc_btnum]);
 			agf->agf_roots[cur->bc_btnum] = *lpp;
-			be32_add(&agf->agf_levels[cur->bc_btnum], -1);
+			be32_add_cpu(&agf->agf_levels[cur->bc_btnum], -1);
 			mp->m_perag[be32_to_cpu(agf->agf_seqno)].pagf_levels[cur->bc_btnum]--;
 			/*
 			 * Put this buffer/block on the ag's freelist.
@@ -1256,9 +1256,9 @@ xfs_alloc_lshift(
 	/*
 	 * Bump and log left's numrecs, decrement and log right's numrecs.
 	 */
-	be16_add(&left->bb_numrecs, 1);
+	be16_add_cpu(&left->bb_numrecs, 1);
 	xfs_alloc_log_block(cur->bc_tp, lbp, XFS_BB_NUMRECS);
-	be16_add(&right->bb_numrecs, -1);
+	be16_add_cpu(&right->bb_numrecs, -1);
 	xfs_alloc_log_block(cur->bc_tp, rbp, XFS_BB_NUMRECS);
 	/*
 	 * Slide the contents of right down one entry.
@@ -1346,7 +1346,7 @@ xfs_alloc_newroot(
 
 		agf = XFS_BUF_TO_AGF(cur->bc_private.a.agbp);
 		agf->agf_roots[cur->bc_btnum] = cpu_to_be32(nbno);
-		be32_add(&agf->agf_levels[cur->bc_btnum], 1);
+		be32_add_cpu(&agf->agf_levels[cur->bc_btnum], 1);
 		seqno = be32_to_cpu(agf->agf_seqno);
 		mp->m_perag[seqno].pagf_levels[cur->bc_btnum]++;
 		xfs_alloc_log_agf(cur->bc_tp, cur->bc_private.a.agbp,
@@ -1558,9 +1558,9 @@ xfs_alloc_rshift(
 	/*
 	 * Decrement and log left's numrecs, bump and log right's numrecs.
 	 */
-	be16_add(&left->bb_numrecs, -1);
+	be16_add_cpu(&left->bb_numrecs, -1);
 	xfs_alloc_log_block(cur->bc_tp, lbp, XFS_BB_NUMRECS);
-	be16_add(&right->bb_numrecs, 1);
+	be16_add_cpu(&right->bb_numrecs, 1);
 	xfs_alloc_log_block(cur->bc_tp, rbp, XFS_BB_NUMRECS);
 	/*
 	 * Using a temporary cursor, update the parent key values of the
@@ -1643,7 +1643,7 @@ xfs_alloc_split(
 	 */
 	if ((be16_to_cpu(left->bb_numrecs) & 1) &&
 	    cur->bc_ptrs[level] <= be16_to_cpu(right->bb_numrecs) + 1)
-		be16_add(&right->bb_numrecs, 1);
+		be16_add_cpu(&right->bb_numrecs, 1);
 	i = be16_to_cpu(left->bb_numrecs) - be16_to_cpu(right->bb_numrecs) + 1;
 	/*
 	 * For non-leaf blocks, copy keys and addresses over to the new block.
@@ -1689,7 +1689,7 @@ xfs_alloc_split(
 	 * Adjust numrecs, sibling pointers.
 	 */
 	lbno = XFS_DADDR_TO_AGBNO(cur->bc_mp, XFS_BUF_ADDR(lbp));
-	be16_add(&left->bb_numrecs, -(be16_to_cpu(right->bb_numrecs)));
+	be16_add_cpu(&left->bb_numrecs, -(be16_to_cpu(right->bb_numrecs)));
 	right->bb_rightsib = left->bb_rightsib;
 	left->bb_rightsib = cpu_to_be32(rbno);
 	right->bb_leftsib = cpu_to_be32(lbno);
diff -puN fs/xfs/xfs_arch.h~xfs-convert-bex_add-to-bex_add_cpu-new-common-api fs/xfs/xfs_arch.h
--- a/fs/xfs/xfs_arch.h~xfs-convert-bex_add-to-bex_add_cpu-new-common-api
+++ a/fs/xfs/xfs_arch.h
@@ -170,21 +170,6 @@
     } \
 }
 
-static inline void be16_add(__be16 *a, __s16 b)
-{
-	*a = cpu_to_be16(be16_to_cpu(*a) + b);
-}
-
-static inline void be32_add(__be32 *a, __s32 b)
-{
-	*a = cpu_to_be32(be32_to_cpu(*a) + b);
-}
-
-static inline void be64_add(__be64 *a, __s64 b)
-{
-	*a = cpu_to_be64(be64_to_cpu(*a) + b);
-}
-
 /*
  * In directories inode numbers are stored as unaligned arrays of unsigned
  * 8bit integers on disk.
diff -puN fs/xfs/xfs_attr_leaf.c~xfs-convert-bex_add-to-bex_add_cpu-new-common-api fs/xfs/xfs_attr_leaf.c
--- a/fs/xfs/xfs_attr_leaf.c~xfs-convert-bex_add-to-bex_add_cpu-new-common-api
+++ a/fs/xfs/xfs_attr_leaf.c
@@ -317,7 +317,7 @@ xfs_attr_shortform_add(xfs_da_args_t *ar
 	memcpy(sfe->nameval, args->name, args->namelen);
 	memcpy(&sfe->nameval[args->namelen], args->value, args->valuelen);
 	sf->hdr.count++;
-	be16_add(&sf->hdr.totsize, size);
+	be16_add_cpu(&sf->hdr.totsize, size);
 	xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE | XFS_ILOG_ADATA);
 
 	xfs_sbversion_add_attr2(mp, args->trans);
@@ -363,7 +363,7 @@ xfs_attr_shortform_remove(xfs_da_args_t 
 	if (end != totsize)
 		memmove(&((char *)sf)[base], &((char *)sf)[end], totsize - end);
 	sf->hdr.count--;
-	be16_add(&sf->hdr.totsize, -size);
+	be16_add_cpu(&sf->hdr.totsize, -size);
 
 	/*
 	 * Fix up the start offset of the attribute fork
@@ -1133,7 +1133,7 @@ xfs_attr_leaf_add_work(xfs_dabuf_t *bp, 
 		xfs_da_log_buf(args->trans, bp,
 		    XFS_DA_LOGRANGE(leaf, entry, tmp + sizeof(*entry)));
 	}
-	be16_add(&hdr->count, 1);
+	be16_add_cpu(&hdr->count, 1);
 
 	/*
 	 * Allocate space for the new string (at the end of the run).
@@ -1147,7 +1147,7 @@ xfs_attr_leaf_add_work(xfs_dabuf_t *bp, 
 					 mp->m_sb.sb_blocksize, NULL));
 	ASSERT(be16_to_cpu(map->size) < XFS_LBSIZE(mp));
 	ASSERT((be16_to_cpu(map->size) & 0x3) == 0);
-	be16_add(&map->size,
+	be16_add_cpu(&map->size,
 		-xfs_attr_leaf_newentsize(args->namelen, args->valuelen,
 					  mp->m_sb.sb_blocksize, &tmp));
 	entry->nameidx = cpu_to_be16(be16_to_cpu(map->base) +
@@ -1214,12 +1214,12 @@ xfs_attr_leaf_add_work(xfs_dabuf_t *bp, 
 	map = &hdr->freemap[0];
 	for (i = 0; i < XFS_ATTR_LEAF_MAPSIZE; map++, i++) {
 		if (be16_to_cpu(map->base) == tmp) {
-			be16_add(&map->base, sizeof(xfs_attr_leaf_entry_t));
-			be16_add(&map->size,
+			be16_add_cpu(&map->base, sizeof(xfs_attr_leaf_entry_t));
+			be16_add_cpu(&map->size,
 				 -((int)sizeof(xfs_attr_leaf_entry_t)));
 		}
 	}
-	be16_add(&hdr->usedbytes, xfs_attr_leaf_entsize(leaf, args->index));
+	be16_add_cpu(&hdr->usedbytes, xfs_attr_leaf_entsize(leaf, args->index));
 	xfs_da_log_buf(args->trans, bp,
 		XFS_DA_LOGRANGE(leaf, hdr, sizeof(*hdr)));
 	return(0);
@@ -1727,9 +1727,9 @@ xfs_attr_leaf_remove(xfs_dabuf_t *bp, xf
 		ASSERT(be16_to_cpu(map->base) < XFS_LBSIZE(mp));
 		ASSERT(be16_to_cpu(map->size) < XFS_LBSIZE(mp));
 		if (be16_to_cpu(map->base) == tablesize) {
-			be16_add(&map->base,
+			be16_add_cpu(&map->base,
 				 -((int)sizeof(xfs_attr_leaf_entry_t)));
-			be16_add(&map->size, sizeof(xfs_attr_leaf_entry_t));
+			be16_add_cpu(&map->size, sizeof(xfs_attr_leaf_entry_t));
 		}
 
 		if ((be16_to_cpu(map->base) + be16_to_cpu(map->size))
@@ -1751,19 +1751,19 @@ xfs_attr_leaf_remove(xfs_dabuf_t *bp, xf
 	if ((before >= 0) || (after >= 0)) {
 		if ((before >= 0) && (after >= 0)) {
 			map = &hdr->freemap[before];
-			be16_add(&map->size, entsize);
-			be16_add(&map->size,
+			be16_add_cpu(&map->size, entsize);
+			be16_add_cpu(&map->size,
 				 be16_to_cpu(hdr->freemap[after].size));
 			hdr->freemap[after].base = 0;
 			hdr->freemap[after].size = 0;
 		} else if (before >= 0) {
 			map = &hdr->freemap[before];
-			be16_add(&map->size, entsize);
+			be16_add_cpu(&map->size, entsize);
 		} else {
 			map = &hdr->freemap[after];
 			/* both on-disk, don't endian flip twice */
 			map->base = entry->nameidx;
-			be16_add(&map->size, entsize);
+			be16_add_cpu(&map->size, entsize);
 		}
 	} else {
 		/*
@@ -1788,7 +1788,7 @@ xfs_attr_leaf_remove(xfs_dabuf_t *bp, xf
 	 * Compress the remaining entries and zero out the removed stuff.
 	 */
 	memset(XFS_ATTR_LEAF_NAME(leaf, args->index), 0, entsize);
-	be16_add(&hdr->usedbytes, -entsize);
+	be16_add_cpu(&hdr->usedbytes, -entsize);
 	xfs_da_log_buf(args->trans, bp,
 	     XFS_DA_LOGRANGE(leaf, XFS_ATTR_LEAF_NAME(leaf, args->index),
 				   entsize));
@@ -1796,7 +1796,7 @@ xfs_attr_leaf_remove(xfs_dabuf_t *bp, xf
 	tmp = (be16_to_cpu(hdr->count) - args->index)
 					* sizeof(xfs_attr_leaf_entry_t);
 	memmove((char *)entry, (char *)(entry+1), tmp);
-	be16_add(&hdr->count, -1);
+	be16_add_cpu(&hdr->count, -1);
 	xfs_da_log_buf(args->trans, bp,
 	    XFS_DA_LOGRANGE(leaf, entry, tmp + sizeof(*entry)));
 	entry = &leaf->entries[be16_to_cpu(hdr->count)];
@@ -2182,15 +2182,15 @@ xfs_attr_leaf_moveents(xfs_attr_leafbloc
 		 */
 		if (entry_s->flags & XFS_ATTR_INCOMPLETE) { /* skip partials? */
 			memset(XFS_ATTR_LEAF_NAME(leaf_s, start_s + i), 0, tmp);
-			be16_add(&hdr_s->usedbytes, -tmp);
-			be16_add(&hdr_s->count, -1);
+			be16_add_cpu(&hdr_s->usedbytes, -tmp);
+			be16_add_cpu(&hdr_s->count, -1);
 			entry_d--;	/* to compensate for ++ in loop hdr */
 			desti--;
 			if ((start_s + i) < offset)
 				result++;	/* insertion index adjustment */
 		} else {
 #endif /* GROT */
-			be16_add(&hdr_d->firstused, -tmp);
+			be16_add_cpu(&hdr_d->firstused, -tmp);
 			/* both on-disk, don't endian flip twice */
 			entry_d->hashval = entry_s->hashval;
 			/* both on-disk, don't endian flip twice */
@@ -2203,10 +2203,10 @@ xfs_attr_leaf_moveents(xfs_attr_leafbloc
 			ASSERT(be16_to_cpu(entry_s->nameidx) + tmp
 							<= XFS_LBSIZE(mp));
 			memset(XFS_ATTR_LEAF_NAME(leaf_s, start_s + i), 0, tmp);
-			be16_add(&hdr_s->usedbytes, -tmp);
-			be16_add(&hdr_d->usedbytes, tmp);
-			be16_add(&hdr_s->count, -1);
-			be16_add(&hdr_d->count, 1);
+			be16_add_cpu(&hdr_s->usedbytes, -tmp);
+			be16_add_cpu(&hdr_d->usedbytes, tmp);
+			be16_add_cpu(&hdr_s->count, -1);
+			be16_add_cpu(&hdr_d->count, 1);
 			tmp = be16_to_cpu(hdr_d->count)
 						* sizeof(xfs_attr_leaf_entry_t)
 						+ sizeof(xfs_attr_leaf_hdr_t);
@@ -2247,7 +2247,7 @@ xfs_attr_leaf_moveents(xfs_attr_leafbloc
 	 * Fill in the freemap information
 	 */
 	hdr_d->freemap[0].base = cpu_to_be16(sizeof(xfs_attr_leaf_hdr_t));
-	be16_add(&hdr_d->freemap[0].base, be16_to_cpu(hdr_d->count) *
+	be16_add_cpu(&hdr_d->freemap[0].base, be16_to_cpu(hdr_d->count) *
 			sizeof(xfs_attr_leaf_entry_t));
 	hdr_d->freemap[0].size = cpu_to_be16(be16_to_cpu(hdr_d->firstused)
 			      - be16_to_cpu(hdr_d->freemap[0].base));
diff -puN fs/xfs/xfs_bmap_btree.c~xfs-convert-bex_add-to-bex_add_cpu-new-common-api fs/xfs/xfs_bmap_btree.c
--- a/fs/xfs/xfs_bmap_btree.c~xfs-convert-bex_add-to-bex_add_cpu-new-common-api
+++ a/fs/xfs/xfs_bmap_btree.c
@@ -631,7 +631,7 @@ xfs_bmbt_delrec(
 		memcpy(lrp, rrp, numrrecs * sizeof(*lrp));
 		xfs_bmbt_log_recs(cur, lbp, numlrecs + 1, numlrecs + numrrecs);
 	}
-	be16_add(&left->bb_numrecs, numrrecs);
+	be16_add_cpu(&left->bb_numrecs, numrrecs);
 	left->bb_rightsib = right->bb_rightsib;
 	xfs_bmbt_log_block(cur, lbp, XFS_BB_RIGHTSIB | XFS_BB_NUMRECS);
 	if (be64_to_cpu(left->bb_rightsib) != NULLDFSBNO) {
@@ -924,7 +924,7 @@ xfs_bmbt_killroot(
 		xfs_iroot_realloc(ip, i, cur->bc_private.b.whichfork);
 		block = ifp->if_broot;
 	}
-	be16_add(&block->bb_numrecs, i);
+	be16_add_cpu(&block->bb_numrecs, i);
 	ASSERT(block->bb_numrecs == cblock->bb_numrecs);
 	kp = XFS_BMAP_KEY_IADDR(block, 1, cur);
 	ckp = XFS_BMAP_KEY_IADDR(cblock, 1, cur);
@@ -947,7 +947,7 @@ xfs_bmbt_killroot(
 			XFS_TRANS_DQ_BCOUNT, -1L);
 	xfs_trans_binval(cur->bc_tp, cbp);
 	cur->bc_bufs[level - 1] = NULL;
-	be16_add(&block->bb_level, -1);
+	be16_add_cpu(&block->bb_level, -1);
 	xfs_trans_log_inode(cur->bc_tp, ip,
 		XFS_ILOG_CORE | XFS_ILOG_FBROOT(cur->bc_private.b.whichfork));
 	cur->bc_nlevels--;
@@ -1401,9 +1401,9 @@ xfs_bmbt_rshift(
 		key.br_startoff = cpu_to_be64(xfs_bmbt_disk_get_startoff(rrp));
 		rkp = &key;
 	}
-	be16_add(&left->bb_numrecs, -1);
+	be16_add_cpu(&left->bb_numrecs, -1);
 	xfs_bmbt_log_block(cur, lbp, XFS_BB_NUMRECS);
-	be16_add(&right->bb_numrecs, 1);
+	be16_add_cpu(&right->bb_numrecs, 1);
 #ifdef DEBUG
 	if (level > 0)
 		xfs_btree_check_key(XFS_BTNUM_BMAP, rkp, rkp + 1);
@@ -1535,7 +1535,7 @@ xfs_bmbt_split(
 	right->bb_numrecs = cpu_to_be16(be16_to_cpu(left->bb_numrecs) / 2);
 	if ((be16_to_cpu(left->bb_numrecs) & 1) &&
 	    cur->bc_ptrs[level] <= be16_to_cpu(right->bb_numrecs) + 1)
-		be16_add(&right->bb_numrecs, 1);
+		be16_add_cpu(&right->bb_numrecs, 1);
 	i = be16_to_cpu(left->bb_numrecs) - be16_to_cpu(right->bb_numrecs) + 1;
 	if (level > 0) {
 		lkp = XFS_BMAP_KEY_IADDR(left, i, cur);
@@ -1562,7 +1562,7 @@ xfs_bmbt_split(
 		xfs_bmbt_log_recs(cur, rbp, 1, be16_to_cpu(right->bb_numrecs));
 		*startoff = xfs_bmbt_disk_get_startoff(rrp);
 	}
-	be16_add(&left->bb_numrecs, -(be16_to_cpu(right->bb_numrecs)));
+	be16_add_cpu(&left->bb_numrecs, -(be16_to_cpu(right->bb_numrecs)));
 	right->bb_rightsib = left->bb_rightsib;
 	left->bb_rightsib = cpu_to_be64(args.fsbno);
 	right->bb_leftsib = cpu_to_be64(lbno);
@@ -2240,7 +2240,7 @@ xfs_bmbt_newroot(
 	bp = xfs_btree_get_bufl(args.mp, cur->bc_tp, args.fsbno, 0);
 	cblock = XFS_BUF_TO_BMBT_BLOCK(bp);
 	*cblock = *block;
-	be16_add(&block->bb_level, 1);
+	be16_add_cpu(&block->bb_level, 1);
 	block->bb_numrecs = cpu_to_be16(1);
 	cur->bc_nlevels++;
 	cur->bc_ptrs[level + 1] = 1;
diff -puN fs/xfs/xfs_da_btree.c~xfs-convert-bex_add-to-bex_add_cpu-new-common-api fs/xfs/xfs_da_btree.c
--- a/fs/xfs/xfs_da_btree.c~xfs-convert-bex_add-to-bex_add_cpu-new-common-api
+++ a/fs/xfs/xfs_da_btree.c
@@ -511,12 +511,12 @@ xfs_da_node_rebalance(xfs_da_state_t *st
 		 * Move the req'd B-tree elements from high in node1 to
 		 * low in node2.
 		 */
-		be16_add(&node2->hdr.count, count);
+		be16_add_cpu(&node2->hdr.count, count);
 		tmp = count * (uint)sizeof(xfs_da_node_entry_t);
 		btree_s = &node1->btree[be16_to_cpu(node1->hdr.count) - count];
 		btree_d = &node2->btree[0];
 		memcpy(btree_d, btree_s, tmp);
-		be16_add(&node1->hdr.count, -count);
+		be16_add_cpu(&node1->hdr.count, -count);
 	} else {
 		/*
 		 * Move the req'd B-tree elements from low in node2 to
@@ -527,7 +527,7 @@ xfs_da_node_rebalance(xfs_da_state_t *st
 		btree_s = &node2->btree[0];
 		btree_d = &node1->btree[be16_to_cpu(node1->hdr.count)];
 		memcpy(btree_d, btree_s, tmp);
-		be16_add(&node1->hdr.count, count);
+		be16_add_cpu(&node1->hdr.count, count);
 		xfs_da_log_buf(tp, blk1->bp,
 			XFS_DA_LOGRANGE(node1, btree_d, tmp));
 
@@ -539,7 +539,7 @@ xfs_da_node_rebalance(xfs_da_state_t *st
 		btree_s = &node2->btree[count];
 		btree_d = &node2->btree[0];
 		memmove(btree_d, btree_s, tmp);
-		be16_add(&node2->hdr.count, -count);
+		be16_add_cpu(&node2->hdr.count, -count);
 	}
 
 	/*
@@ -604,7 +604,7 @@ xfs_da_node_add(xfs_da_state_t *state, x
 	btree->before = cpu_to_be32(newblk->blkno);
 	xfs_da_log_buf(state->args->trans, oldblk->bp,
 		XFS_DA_LOGRANGE(node, btree, tmp + sizeof(*btree)));
-	be16_add(&node->hdr.count, 1);
+	be16_add_cpu(&node->hdr.count, 1);
 	xfs_da_log_buf(state->args->trans, oldblk->bp,
 		XFS_DA_LOGRANGE(node, &node->hdr, sizeof(node->hdr)));
 
@@ -959,7 +959,7 @@ xfs_da_node_remove(xfs_da_state_t *state
 	memset((char *)btree, 0, sizeof(xfs_da_node_entry_t));
 	xfs_da_log_buf(state->args->trans, drop_blk->bp,
 	    XFS_DA_LOGRANGE(node, btree, sizeof(*btree)));
-	be16_add(&node->hdr.count, -1);
+	be16_add_cpu(&node->hdr.count, -1);
 	xfs_da_log_buf(state->args->trans, drop_blk->bp,
 	    XFS_DA_LOGRANGE(node, &node->hdr, sizeof(node->hdr)));
 
@@ -1018,7 +1018,7 @@ xfs_da_node_unbalance(xfs_da_state_t *st
 	 */
 	tmp = be16_to_cpu(drop_node->hdr.count) * (uint)sizeof(xfs_da_node_entry_t);
 	memcpy(btree, &drop_node->btree[0], tmp);
-	be16_add(&save_node->hdr.count, be16_to_cpu(drop_node->hdr.count));
+	be16_add_cpu(&save_node->hdr.count, be16_to_cpu(drop_node->hdr.count));
 
 	xfs_da_log_buf(tp, save_blk->bp,
 		XFS_DA_LOGRANGE(save_node, &save_node->hdr,
diff -puN fs/xfs/xfs_dir2_block.c~xfs-convert-bex_add-to-bex_add_cpu-new-common-api fs/xfs/xfs_dir2_block.c
--- a/fs/xfs/xfs_dir2_block.c~xfs-convert-bex_add-to-bex_add_cpu-new-common-api
+++ a/fs/xfs/xfs_dir2_block.c
@@ -271,7 +271,7 @@ xfs_dir2_block_addname(
 		}
 		lfloglow = toidx + 1 - (be32_to_cpu(btp->stale) - 1);
 		lfloghigh -= be32_to_cpu(btp->stale) - 1;
-		be32_add(&btp->count, -(be32_to_cpu(btp->stale) - 1));
+		be32_add_cpu(&btp->count, -(be32_to_cpu(btp->stale) - 1));
 		xfs_dir2_data_make_free(tp, bp,
 			(xfs_dir2_data_aoff_t)((char *)blp - (char *)block),
 			(xfs_dir2_data_aoff_t)((be32_to_cpu(btp->stale) - 1) * sizeof(*blp)),
@@ -326,7 +326,7 @@ xfs_dir2_block_addname(
 		/*
 		 * Update the tail (entry count).
 		 */
-		be32_add(&btp->count, 1);
+		be32_add_cpu(&btp->count, 1);
 		/*
 		 * If we now need to rebuild the bestfree map, do so.
 		 * This needs to happen before the next call to use_free.
@@ -387,7 +387,7 @@ xfs_dir2_block_addname(
 			lfloglow = MIN(mid, lfloglow);
 			lfloghigh = MAX(highstale, lfloghigh);
 		}
-		be32_add(&btp->stale, -1);
+		be32_add_cpu(&btp->stale, -1);
 	}
 	/*
 	 * Point to the new data entry.
@@ -767,7 +767,7 @@ xfs_dir2_block_removename(
 	/*
 	 * Fix up the block tail.
 	 */
-	be32_add(&btp->stale, 1);
+	be32_add_cpu(&btp->stale, 1);
 	xfs_dir2_block_log_tail(tp, bp);
 	/*
 	 * Remove the leaf entry by marking it stale.
diff -puN fs/xfs/xfs_dir2_data.c~xfs-convert-bex_add-to-bex_add_cpu-new-common-api fs/xfs/xfs_dir2_data.c
--- a/fs/xfs/xfs_dir2_data.c~xfs-convert-bex_add-to-bex_add_cpu-new-common-api
+++ a/fs/xfs/xfs_dir2_data.c
@@ -587,7 +587,7 @@ xfs_dir2_data_make_free(
 		/*
 		 * Fix up the new big freespace.
 		 */
-		be16_add(&prevdup->length, len + be16_to_cpu(postdup->length));
+		be16_add_cpu(&prevdup->length, len + be16_to_cpu(postdup->length));
 		*xfs_dir2_data_unused_tag_p(prevdup) =
 			cpu_to_be16((char *)prevdup - (char *)d);
 		xfs_dir2_data_log_unused(tp, bp, prevdup);
@@ -621,7 +621,7 @@ xfs_dir2_data_make_free(
 	 */
 	else if (prevdup) {
 		dfp = xfs_dir2_data_freefind(d, prevdup);
-		be16_add(&prevdup->length, len);
+		be16_add_cpu(&prevdup->length, len);
 		*xfs_dir2_data_unused_tag_p(prevdup) =
 			cpu_to_be16((char *)prevdup - (char *)d);
 		xfs_dir2_data_log_unused(tp, bp, prevdup);
diff -puN fs/xfs/xfs_dir2_leaf.c~xfs-convert-bex_add-to-bex_add_cpu-new-common-api fs/xfs/xfs_dir2_leaf.c
--- a/fs/xfs/xfs_dir2_leaf.c~xfs-convert-bex_add-to-bex_add_cpu-new-common-api
+++ a/fs/xfs/xfs_dir2_leaf.c
@@ -359,7 +359,7 @@ xfs_dir2_leaf_addname(
 			bestsp--;
 			memmove(&bestsp[0], &bestsp[1],
 				be32_to_cpu(ltp->bestcount) * sizeof(bestsp[0]));
-			be32_add(&ltp->bestcount, 1);
+			be32_add_cpu(&ltp->bestcount, 1);
 			xfs_dir2_leaf_log_tail(tp, lbp);
 			xfs_dir2_leaf_log_bests(tp, lbp, 0, be32_to_cpu(ltp->bestcount) - 1);
 		}
@@ -445,7 +445,7 @@ xfs_dir2_leaf_addname(
 		 */
 		lfloglow = index;
 		lfloghigh = be16_to_cpu(leaf->hdr.count);
-		be16_add(&leaf->hdr.count, 1);
+		be16_add_cpu(&leaf->hdr.count, 1);
 	}
 	/*
 	 * There are stale entries.
@@ -523,7 +523,7 @@ xfs_dir2_leaf_addname(
 			lfloglow = MIN(index, lfloglow);
 			lfloghigh = MAX(highstale, lfloghigh);
 		}
-		be16_add(&leaf->hdr.stale, -1);
+		be16_add_cpu(&leaf->hdr.stale, -1);
 	}
 	/*
 	 * Fill in the new leaf entry.
@@ -626,7 +626,7 @@ xfs_dir2_leaf_compact(
 	 * Update and log the header, log the leaf entries.
 	 */
 	ASSERT(be16_to_cpu(leaf->hdr.stale) == from - to);
-	be16_add(&leaf->hdr.count, -(be16_to_cpu(leaf->hdr.stale)));
+	be16_add_cpu(&leaf->hdr.count, -(be16_to_cpu(leaf->hdr.stale)));
 	leaf->hdr.stale = 0;
 	xfs_dir2_leaf_log_header(args->trans, bp);
 	if (loglow != -1)
@@ -728,7 +728,7 @@ xfs_dir2_leaf_compact_x1(
 	/*
 	 * Adjust the leaf header values.
 	 */
-	be16_add(&leaf->hdr.count, -(from - to));
+	be16_add_cpu(&leaf->hdr.count, -(from - to));
 	leaf->hdr.stale = cpu_to_be16(1);
 	/*
 	 * Remember the low/high stale value only in the "right"
@@ -1470,7 +1470,7 @@ xfs_dir2_leaf_removename(
 	/*
 	 * We just mark the leaf entry stale by putting a null in it.
 	 */
-	be16_add(&leaf->hdr.stale, 1);
+	be16_add_cpu(&leaf->hdr.stale, 1);
 	xfs_dir2_leaf_log_header(tp, lbp);
 	lep->address = cpu_to_be32(XFS_DIR2_NULL_DATAPTR);
 	xfs_dir2_leaf_log_ents(tp, lbp, index, index);
@@ -1531,7 +1531,7 @@ xfs_dir2_leaf_removename(
 			 */
 			memmove(&bestsp[db - i], bestsp,
 				(be32_to_cpu(ltp->bestcount) - (db - i)) * sizeof(*bestsp));
-			be32_add(&ltp->bestcount, -(db - i));
+			be32_add_cpu(&ltp->bestcount, -(db - i));
 			xfs_dir2_leaf_log_tail(tp, lbp);
 			xfs_dir2_leaf_log_bests(tp, lbp, 0, be32_to_cpu(ltp->bestcount) - 1);
 		} else
@@ -1712,7 +1712,7 @@ xfs_dir2_leaf_trim_data(
 	 * Eliminate the last bests entry from the table.
 	 */
 	bestsp = xfs_dir2_leaf_bests_p(ltp);
-	be32_add(&ltp->bestcount, -1);
+	be32_add_cpu(&ltp->bestcount, -1);
 	memmove(&bestsp[1], &bestsp[0], be32_to_cpu(ltp->bestcount) * sizeof(*bestsp));
 	xfs_dir2_leaf_log_tail(tp, lbp);
 	xfs_dir2_leaf_log_bests(tp, lbp, 0, be32_to_cpu(ltp->bestcount) - 1);
diff -puN fs/xfs/xfs_dir2_node.c~xfs-convert-bex_add-to-bex_add_cpu-new-common-api fs/xfs/xfs_dir2_node.c
--- a/fs/xfs/xfs_dir2_node.c~xfs-convert-bex_add-to-bex_add_cpu-new-common-api
+++ a/fs/xfs/xfs_dir2_node.c
@@ -254,7 +254,7 @@ xfs_dir2_leafn_add(
 				(be16_to_cpu(leaf->hdr.count) - index) * sizeof(*lep));
 		lfloglow = index;
 		lfloghigh = be16_to_cpu(leaf->hdr.count);
-		be16_add(&leaf->hdr.count, 1);
+		be16_add_cpu(&leaf->hdr.count, 1);
 	}
 	/*
 	 * There are stale entries.  We'll use one for the new entry.
@@ -322,7 +322,7 @@ xfs_dir2_leafn_add(
 			lfloglow = MIN(index, lfloglow);
 			lfloghigh = MAX(highstale, lfloghigh);
 		}
-		be16_add(&leaf->hdr.stale, -1);
+		be16_add_cpu(&leaf->hdr.stale, -1);
 	}
 	/*
 	 * Insert the new entry, log everything.
@@ -697,10 +697,10 @@ xfs_dir2_leafn_moveents(
 	/*
 	 * Update the headers and log them.
 	 */
-	be16_add(&leaf_s->hdr.count, -(count));
-	be16_add(&leaf_s->hdr.stale, -(stale));
-	be16_add(&leaf_d->hdr.count, count);
-	be16_add(&leaf_d->hdr.stale, stale);
+	be16_add_cpu(&leaf_s->hdr.count, -(count));
+	be16_add_cpu(&leaf_s->hdr.stale, -(stale));
+	be16_add_cpu(&leaf_d->hdr.count, count);
+	be16_add_cpu(&leaf_d->hdr.stale, stale);
 	xfs_dir2_leaf_log_header(tp, bp_s);
 	xfs_dir2_leaf_log_header(tp, bp_d);
 	xfs_dir2_leafn_check(args->dp, bp_s);
@@ -885,7 +885,7 @@ xfs_dir2_leafn_remove(
 	 * Kill the leaf entry by marking it stale.
 	 * Log the leaf block changes.
 	 */
-	be16_add(&leaf->hdr.stale, 1);
+	be16_add_cpu(&leaf->hdr.stale, 1);
 	xfs_dir2_leaf_log_header(tp, bp);
 	lep->address = cpu_to_be32(XFS_DIR2_NULL_DATAPTR);
 	xfs_dir2_leaf_log_ents(tp, bp, index, index);
@@ -971,7 +971,7 @@ xfs_dir2_leafn_remove(
 			/*
 			 * One less used entry in the free table.
 			 */
-			be32_add(&free->hdr.nused, -1);
+			be32_add_cpu(&free->hdr.nused, -1);
 			xfs_dir2_free_log_header(tp, fbp);
 			/*
 			 * If this was the last entry in the table, we can
@@ -1642,7 +1642,7 @@ xfs_dir2_node_addname_int(
 		 * (this should always be true) then update the header.
 		 */
 		if (be16_to_cpu(free->bests[findex]) == NULLDATAOFF) {
-			be32_add(&free->hdr.nused, 1);
+			be32_add_cpu(&free->hdr.nused, 1);
 			xfs_dir2_free_log_header(tp, fbp);
 		}
 		/*
diff -puN fs/xfs/xfs_fsops.c~xfs-convert-bex_add-to-bex_add_cpu-new-common-api fs/xfs/xfs_fsops.c
--- a/fs/xfs/xfs_fsops.c~xfs-convert-bex_add-to-bex_add_cpu-new-common-api
+++ a/fs/xfs/xfs_fsops.c
@@ -318,7 +318,7 @@ xfs_growfs_data_private(
 		}
 		ASSERT(bp);
 		agi = XFS_BUF_TO_AGI(bp);
-		be32_add(&agi->agi_length, new);
+		be32_add_cpu(&agi->agi_length, new);
 		ASSERT(nagcount == oagcount ||
 		       be32_to_cpu(agi->agi_length) == mp->m_sb.sb_agblocks);
 		xfs_ialloc_log_agi(tp, bp, XFS_AGI_LENGTH);
@@ -331,7 +331,7 @@ xfs_growfs_data_private(
 		}
 		ASSERT(bp);
 		agf = XFS_BUF_TO_AGF(bp);
-		be32_add(&agf->agf_length, new);
+		be32_add_cpu(&agf->agf_length, new);
 		ASSERT(be32_to_cpu(agf->agf_length) ==
 		       be32_to_cpu(agi->agi_length));
 		xfs_alloc_log_agf(tp, bp, XFS_AGF_LENGTH);
diff -puN fs/xfs/xfs_ialloc.c~xfs-convert-bex_add-to-bex_add_cpu-new-common-api fs/xfs/xfs_ialloc.c
--- a/fs/xfs/xfs_ialloc.c~xfs-convert-bex_add-to-bex_add_cpu-new-common-api
+++ a/fs/xfs/xfs_ialloc.c
@@ -301,8 +301,8 @@ xfs_ialloc_ag_alloc(
 		}
 		xfs_trans_inode_alloc_buf(tp, fbuf);
 	}
-	be32_add(&agi->agi_count, newlen);
-	be32_add(&agi->agi_freecount, newlen);
+	be32_add_cpu(&agi->agi_count, newlen);
+	be32_add_cpu(&agi->agi_freecount, newlen);
 	agno = be32_to_cpu(agi->agi_seqno);
 	down_read(&args.mp->m_peraglock);
 	args.mp->m_perag[agno].pagi_freecount += newlen;
@@ -885,7 +885,7 @@ nextag:
 	if ((error = xfs_inobt_update(cur, rec.ir_startino, rec.ir_freecount,
 			rec.ir_free)))
 		goto error0;
-	be32_add(&agi->agi_freecount, -1);
+	be32_add_cpu(&agi->agi_freecount, -1);
 	xfs_ialloc_log_agi(tp, agbp, XFS_AGI_FREECOUNT);
 	down_read(&mp->m_peraglock);
 	mp->m_perag[tagno].pagi_freecount--;
@@ -1065,8 +1065,8 @@ xfs_difree(
 		 * to be freed when the transaction is committed.
 		 */
 		ilen = XFS_IALLOC_INODES(mp);
-		be32_add(&agi->agi_count, -ilen);
-		be32_add(&agi->agi_freecount, -(ilen - 1));
+		be32_add_cpu(&agi->agi_count, -ilen);
+		be32_add_cpu(&agi->agi_freecount, -(ilen - 1));
 		xfs_ialloc_log_agi(tp, agbp, XFS_AGI_COUNT | XFS_AGI_FREECOUNT);
 		down_read(&mp->m_peraglock);
 		mp->m_perag[agno].pagi_freecount -= ilen - 1;
@@ -1095,7 +1095,7 @@ xfs_difree(
 		/* 
 		 * Change the inode free counts and log the ag/sb changes.
 		 */
-		be32_add(&agi->agi_freecount, 1);
+		be32_add_cpu(&agi->agi_freecount, 1);
 		xfs_ialloc_log_agi(tp, agbp, XFS_AGI_FREECOUNT);
 		down_read(&mp->m_peraglock);
 		mp->m_perag[agno].pagi_freecount++;
diff -puN fs/xfs/xfs_ialloc_btree.c~xfs-convert-bex_add-to-bex_add_cpu-new-common-api fs/xfs/xfs_ialloc_btree.c
--- a/fs/xfs/xfs_ialloc_btree.c~xfs-convert-bex_add-to-bex_add_cpu-new-common-api
+++ a/fs/xfs/xfs_ialloc_btree.c
@@ -189,7 +189,7 @@ xfs_inobt_delrec(
 			 */
 			bno = be32_to_cpu(agi->agi_root);
 			agi->agi_root = *pp;
-			be32_add(&agi->agi_level, -1);
+			be32_add_cpu(&agi->agi_level, -1);
 			/*
 			 * Free the block.
 			 */
@@ -1132,7 +1132,7 @@ xfs_inobt_lshift(
 	/*
 	 * Bump and log left's numrecs, decrement and log right's numrecs.
 	 */
-	be16_add(&left->bb_numrecs, 1);
+	be16_add_cpu(&left->bb_numrecs, 1);
 	xfs_inobt_log_block(cur->bc_tp, lbp, XFS_BB_NUMRECS);
 #ifdef DEBUG
 	if (level > 0)
@@ -1140,7 +1140,7 @@ xfs_inobt_lshift(
 	else
 		xfs_btree_check_rec(cur->bc_btnum, lrp - 1, lrp);
 #endif
-	be16_add(&right->bb_numrecs, -1);
+	be16_add_cpu(&right->bb_numrecs, -1);
 	xfs_inobt_log_block(cur->bc_tp, rbp, XFS_BB_NUMRECS);
 	/*
 	 * Slide the contents of right down one entry.
@@ -1232,7 +1232,7 @@ xfs_inobt_newroot(
 	 * Set the root data in the a.g. inode structure.
 	 */
 	agi->agi_root = cpu_to_be32(args.agbno);
-	be32_add(&agi->agi_level, 1);
+	be32_add_cpu(&agi->agi_level, 1);
 	xfs_ialloc_log_agi(args.tp, cur->bc_private.i.agbp,
 		XFS_AGI_ROOT | XFS_AGI_LEVEL);
 	/*
@@ -1426,9 +1426,9 @@ xfs_inobt_rshift(
 	/*
 	 * Decrement and log left's numrecs, bump and log right's numrecs.
 	 */
-	be16_add(&left->bb_numrecs, -1);
+	be16_add_cpu(&left->bb_numrecs, -1);
 	xfs_inobt_log_block(cur->bc_tp, lbp, XFS_BB_NUMRECS);
-	be16_add(&right->bb_numrecs, 1);
+	be16_add_cpu(&right->bb_numrecs, 1);
 #ifdef DEBUG
 	if (level > 0)
 		xfs_btree_check_key(cur->bc_btnum, rkp, rkp + 1);
@@ -1529,7 +1529,7 @@ xfs_inobt_split(
 	 */
 	if ((be16_to_cpu(left->bb_numrecs) & 1) &&
 	    cur->bc_ptrs[level] <= be16_to_cpu(right->bb_numrecs) + 1)
-		be16_add(&right->bb_numrecs, 1);
+		be16_add_cpu(&right->bb_numrecs, 1);
 	i = be16_to_cpu(left->bb_numrecs) - be16_to_cpu(right->bb_numrecs) + 1;
 	/*
 	 * For non-leaf blocks, copy keys and addresses over to the new block.
@@ -1565,7 +1565,7 @@ xfs_inobt_split(
 	 * Find the left block number by looking in the buffer.
 	 * Adjust numrecs, sibling pointers.
 	 */
-	be16_add(&left->bb_numrecs, -(be16_to_cpu(right->bb_numrecs)));
+	be16_add_cpu(&left->bb_numrecs, -(be16_to_cpu(right->bb_numrecs)));
 	right->bb_rightsib = left->bb_rightsib;
 	left->bb_rightsib = cpu_to_be32(args.agbno);
 	right->bb_leftsib = cpu_to_be32(lbno);
diff -puN fs/xfs/xfs_log.c~xfs-convert-bex_add-to-bex_add_cpu-new-common-api fs/xfs/xfs_log.c
--- a/fs/xfs/xfs_log.c~xfs-convert-bex_add-to-bex_add_cpu-new-common-api
+++ a/fs/xfs/xfs_log.c
@@ -1509,9 +1509,9 @@ xlog_sync(xlog_t		*log,
 		 * case, though.
 		 */
 		for (i = 0; i < split; i += BBSIZE) {
-			be32_add((__be32 *)dptr, 1);
+			be32_add_cpu((__be32 *)dptr, 1);
 			if (be32_to_cpu(*(__be32 *)dptr) == XLOG_HEADER_MAGIC_NUM)
-				be32_add((__be32 *)dptr, 1);
+				be32_add_cpu((__be32 *)dptr, 1);
 			dptr += BBSIZE;
 		}
 
@@ -1600,7 +1600,7 @@ xlog_state_finish_copy(xlog_t		*log,
 {
 	spin_lock(&log->l_icloglock);
 
-	be32_add(&iclog->ic_header.h_num_logops, record_cnt);
+	be32_add_cpu(&iclog->ic_header.h_num_logops, record_cnt);
 	iclog->ic_offset += copy_bytes;
 
 	spin_unlock(&log->l_icloglock);
diff -puN fs/xfs/xfs_trans.c~xfs-convert-bex_add-to-bex_add_cpu-new-common-api fs/xfs/xfs_trans.c
--- a/fs/xfs/xfs_trans.c~xfs-convert-bex_add-to-bex_add_cpu-new-common-api
+++ a/fs/xfs/xfs_trans.c
@@ -567,26 +567,26 @@ xfs_trans_apply_sb_deltas(
 	 */
 	if (!xfs_sb_version_haslazysbcount(&(tp->t_mountp->m_sb))) {
 		if (tp->t_icount_delta)
-			be64_add(&sbp->sb_icount, tp->t_icount_delta);
+			be64_add_cpu(&sbp->sb_icount, tp->t_icount_delta);
 		if (tp->t_ifree_delta)
-			be64_add(&sbp->sb_ifree, tp->t_ifree_delta);
+			be64_add_cpu(&sbp->sb_ifree, tp->t_ifree_delta);
 		if (tp->t_fdblocks_delta)
-			be64_add(&sbp->sb_fdblocks, tp->t_fdblocks_delta);
+			be64_add_cpu(&sbp->sb_fdblocks, tp->t_fdblocks_delta);
 		if (tp->t_res_fdblocks_delta)
-			be64_add(&sbp->sb_fdblocks, tp->t_res_fdblocks_delta);
+			be64_add_cpu(&sbp->sb_fdblocks, tp->t_res_fdblocks_delta);
 	}
 
 	if (tp->t_frextents_delta)
-		be64_add(&sbp->sb_frextents, tp->t_frextents_delta);
+		be64_add_cpu(&sbp->sb_frextents, tp->t_frextents_delta);
 	if (tp->t_res_frextents_delta)
-		be64_add(&sbp->sb_frextents, tp->t_res_frextents_delta);
+		be64_add_cpu(&sbp->sb_frextents, tp->t_res_frextents_delta);
 
 	if (tp->t_dblocks_delta) {
-		be64_add(&sbp->sb_dblocks, tp->t_dblocks_delta);
+		be64_add_cpu(&sbp->sb_dblocks, tp->t_dblocks_delta);
 		whole = 1;
 	}
 	if (tp->t_agcount_delta) {
-		be32_add(&sbp->sb_agcount, tp->t_agcount_delta);
+		be32_add_cpu(&sbp->sb_agcount, tp->t_agcount_delta);
 		whole = 1;
 	}
 	if (tp->t_imaxpct_delta) {
@@ -594,19 +594,19 @@ xfs_trans_apply_sb_deltas(
 		whole = 1;
 	}
 	if (tp->t_rextsize_delta) {
-		be32_add(&sbp->sb_rextsize, tp->t_rextsize_delta);
+		be32_add_cpu(&sbp->sb_rextsize, tp->t_rextsize_delta);
 		whole = 1;
 	}
 	if (tp->t_rbmblocks_delta) {
-		be32_add(&sbp->sb_rbmblocks, tp->t_rbmblocks_delta);
+		be32_add_cpu(&sbp->sb_rbmblocks, tp->t_rbmblocks_delta);
 		whole = 1;
 	}
 	if (tp->t_rblocks_delta) {
-		be64_add(&sbp->sb_rblocks, tp->t_rblocks_delta);
+		be64_add_cpu(&sbp->sb_rblocks, tp->t_rblocks_delta);
 		whole = 1;
 	}
 	if (tp->t_rextents_delta) {
-		be64_add(&sbp->sb_rextents, tp->t_rextents_delta);
+		be64_add_cpu(&sbp->sb_rextents, tp->t_rextents_delta);
 		whole = 1;
 	}
 	if (tp->t_rextslog_delta) {
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

origin.patch
git-gfs2-nmw.patch
git-jfs.patch
qla3xxx-convert-byte-order-of-constant-instead-of-variable.patch
ntfs-le_add_cpu-conversion.patch
ocfs2-le_add_cpu-conversion.patch
scsi-le_add_cpu-conversion.patch
ipw2200-le_add_cpu-conversion.patch
git-slub.patch
ext2-le_add_cpu-conversion.patch
ext2-convert-byte-order-of-constant-instead-of-variable.patch
ext3-convert-byte-order-of-constant-instead-of-variable.patch
ufs-e_add_cpu-conversion.patch
ufs-e_add_cpu-conversion-in-return.patch
reiserfs-le_add_cpu-conversion.patch
ext4-le_add_cpu-conversion.patch
ext4-convert-byte-order-of-constant-instead-of-variable.patch
affs-be_add_cpu-conversion.patch
hfs-hfsplus-be_add_cpu-conversion.patch
quota-le_add_cpu-conversion.patch
sysv-e_add_cpu-conversion.patch
