Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3FF7318EC7
	for <linux-ext4@vger.kernel.org>; Thu, 30 Jul 2026 00:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785371896; cv=none; b=MlCElZ+nNvKhvv81QaBOgTzW1O8L903HDJB1S8KX4VDV0aGYvvx5MRZfg8GMXWRoiicOn73xkYvTGVUTOOHlZYjPybz60KkrM7HlkQT4tHfltwosVrSHNivPLujL6324o5UIydfrMeaEXEsrLuvCIFp8Rc0rqA3r5QR9egDjetY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785371896; c=relaxed/simple;
	bh=LMuw/4iZz2GipuGoULUwb2PPmfNkrUniVlkXlddOvlQ=;
	h=Mime-Version:Subject:From:To:CC:In-Reply-To:Message-ID:Date:
	 Content-Type:References; b=TsknVirIkmPj7P7gfj8IL9C/bxv0jchFmlnoZEAL7EUuYKP+OB1Yr+mKTXP92RmW2QPUZ975VjCgEDdQx7vqtXLCpGiO3cvUFgHoEZQtmABQ7IcQA+b4tAOgCaJ2M5bxSxfAZ7b4DCmKzjCqJDrp3Ol49fx4hVJTaVBMfueK+D4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=mbi5jcxu; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="mbi5jcxu"
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260730003811epoutp04b3ad941bb58ac8421920ac136550a3e3~G6ka2Qe6y0708607086epoutp04H
	for <linux-ext4@vger.kernel.org>; Thu, 30 Jul 2026 00:38:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260730003811epoutp04b3ad941bb58ac8421920ac136550a3e3~G6ka2Qe6y0708607086epoutp04H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1785371891;
	bh=1yl0SGrWIU+2mYSanBFbndf920oIld0SgbqWh6KA2A0=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=mbi5jcxunzq2xGnX0Bce34kpcw5fRQsvA1o6qc/SPG9+v0hY7+GdifOj+DKEFG4es
	 BsMkzADYgnS2MUD3t1YF7AmSVue2kUOiP/XnaULYicW3IbQ0FMjglLATfwyT0DcEvJ
	 ZZWt4DArTyyKWy1q+jDqXVdQ3F5DjIkDg3BPkXZY=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPS id
	20260730003811epcas2p18f54962c8eae91639fad5c15d963c5c7~G6kaeDPRz2854428544epcas2p1_;
	Thu, 30 Jul 2026 00:38:11 +0000 (GMT)
Received: from epcas2p4.samsung.com (unknown [182.195.38.205]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4h9Vfp6sSlz3hhTL; Thu, 30 Jul
	2026 00:38:10 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: [RFC PATCH v4 1/3] ext4: fast commit: track disjoint modified
 ranges in a private rbtree
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From: Daejun Park <daejun7.park@samsung.com>
To: "tytso@mit.edu" <tytso@mit.edu>, "adilger.kernel@dilger.ca"
	<adilger.kernel@dilger.ca>
CC: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"me@linux.beauty" <me@linux.beauty>, "libaokun@linux.alibaba.com"
	<libaokun@linux.alibaba.com>, "harshadshirwadkar@gmail.com"
	<harshadshirwadkar@gmail.com>, "yi.zhang@huaweicloud.com"
	<yi.zhang@huaweicloud.com>, "ojaswin@linux.ibm.com" <ojaswin@linux.ibm.com>,
	Daejun Park <daejun7.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20260730003715epcms2p54b7e3cc3409076cc9ee751f60951e167@epcms2p5>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20260730003810epcms2p6cd37c6242602c1467b7665cdcc785ea8@epcms2p6>
Date: Thu, 30 Jul 2026 09:38:10 +0900
X-CMS-MailID: 20260730003810epcms2p6cd37c6242602c1467b7665cdcc785ea8
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260730003715epcms2p54b7e3cc3409076cc9ee751f60951e167
References: <20260730003715epcms2p54b7e3cc3409076cc9ee751f60951e167@epcms2p5>
	<CGME20260730003715epcms2p54b7e3cc3409076cc9ee751f60951e167@epcms2p6>

Fast commit tracks a single coalesced [min,max] logical range per inode
(i_fc_lblk_start/len).  When an inode is dirtied at several disjoint
offsets between two commits, that span widens to cover them all, and at
commit time ext4_fc_snapshot_inode_data() walks the whole span through
the extent status tree -- an ADD_RANGE per mapped segment and a DEL_RANGE
per hole.  For scattered writes that is hundreds to thousands of ranges
for a handful of modified regions, which overruns
EXT4_FC_SNAPSHOT_MAX_RANGES and forces a full commit.

Track the actually-modified disjoint ranges instead, in a per-inode
rbtree of struct ext4_fc_rnode nodes keyed by logical block.  Overlapping
and adjacent ranges merge on insert, so the set stays disjoint with no
explicit merge step and no fixed bound; density is bounded only by the
snapshot cap.  The snapshot walks only the tracked ranges.  The on-disk
TLV format is unchanged.

The rbtree is reused (generic rb_* plus rbtree_postorder walk) rather than
open-coding a range container, per review (Andreas Dilger).  It is private
to fast commit, not the shared extent status tree: the es-tree is a
reclaimable cache whose shrinker will evict a mapped entry for a
modified-but-not-yet-committed range, which would lose the modification.
The node is a dedicated 32-byte struct with its own slab cache, rather than
the shared extent_status: extent_status carries an 8-byte es_pblk that fast
commit does not use, and its cache is SLAB_RECLAIM_ACCOUNT, which would
misaccount these non-reclaimable nodes as reclaimable.

rb_root is one pointer embedded in the inode, so the tree needs no root
allocation; per-range nodes are allocated as ranges are tracked and freed
at commit.  On a GFP_ATOMIC node allocation failure under i_fc_lock the
transaction falls back to a full commit, so no modification is lost.

Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
 fs/ext4/ext4.h        |  35 ++++--
 fs/ext4/fast_commit.c | 280 +++++++++++++++++++++++++++++++++++-------
 fs/ext4/super.c       |   2 +
 3 files changed, 269 insertions(+), 48 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 21a951f10636..7eedb609019a 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1042,6 +1042,18 @@ enum ext4_fc_snap_err {
 	EXT4_FC_SNAP_ERR_INODE_LOC,
 };
 
+/*
+ * Node of the per-inode fast-commit range rbtree (see i_fc_rt).  A dedicated
+ * 32-byte node with its own slab cache -- deliberately not the shared
+ * extent_status, which carries an unused es_pblk and lives in a
+ * SLAB_RECLAIM_ACCOUNT cache these non-reclaimable FC nodes would misaccount.
+ */
+struct ext4_fc_rnode {
+	struct rb_node rb_node;
+	ext4_lblk_t start;
+	ext4_lblk_t len;
+};
+
 /*
  * fourth extended file system inode data in memory
  */
@@ -1097,11 +1109,19 @@ struct ext4_inode_info {
 					 * protected by sbi->s_fc_lock.
 					 */
 
-	/* Start of lblk range that needs to be committed in this fast commit */
-	ext4_lblk_t i_fc_lblk_start;
-
-	/* End of lblk range that needs to be committed in this fast commit */
-	ext4_lblk_t i_fc_lblk_len;
+	/*
+	 * Logical block ranges modified in this fast commit, tracked as a set of
+	 * disjoint ranges in a private rbtree of struct ext4_fc_rnode nodes
+	 * (keyed by logical block) instead of one coalesced [min,max] span.  This
+	 * avoids snapshotting the whole spanned extent map for scattered
+	 * allocations.  Overlapping/adjacent ranges merge on insert, so the set
+	 * stays disjoint with no fixed bound; density is bounded only by the
+	 * snapshot cap.  rb_root is one pointer, so the tree needs no root
+	 * allocation -- only per-range nodes, torn down at commit.  i_fc_nr_ranges
+	 * is the exact number of tracked ranges.  Protected by i_fc_lock.
+	 */
+	struct rb_root i_fc_rt;
+	unsigned int i_fc_nr_ranges;
 
 	/*
 	 * Commit-time fast commit snapshots.
@@ -1122,8 +1142,8 @@ struct ext4_inode_info {
 	spinlock_t i_raw_lock;	/* protects updates to the raw inode */
 
 	/*
-	 * Protect concurrent accesses on i_fc_lblk_start, i_fc_lblk_len
-	 * and inode's EXT4_FC_STATE_COMMITTING state bit.
+	 * Protect concurrent accesses on i_fc_rt, i_fc_nr_ranges and inode's
+	 * EXT4_FC_STATE_COMMITTING state bit.
 	 */
 	spinlock_t i_fc_lock;
 
@@ -3062,6 +3082,7 @@ void ext4_end_bitmap_read(struct bio *bio);
 int ext4_fc_info_show(struct seq_file *seq, void *v);
 void ext4_fc_init(struct super_block *sb, journal_t *journal);
 void ext4_fc_init_inode(struct inode *inode);
+void ext4_fc_free_range_tree(struct inode *inode);
 void ext4_fc_track_range(handle_t *handle, struct inode *inode, ext4_lblk_t start,
 			 ext4_lblk_t end);
 void __ext4_fc_track_unlink(handle_t *handle, struct inode *inode,
diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 062103e42cd8..4550c5dae39c 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -185,6 +185,7 @@
 #include <trace/events/ext4.h>
 static struct kmem_cache *ext4_fc_dentry_cachep;
 static struct kmem_cache *ext4_fc_range_cachep;
+static struct kmem_cache *ext4_fc_rnode_cachep;
 
 /*
  * Avoid spending unbounded time/memory snapshotting highly fragmented files
@@ -202,19 +203,54 @@ static inline void ext4_fc_set_snap_err(int *snap_err, int err)
 
 static void ext4_fc_free_inode_snap(struct inode *inode);
 
+/* Allocate/free a node of the private FC range rbtree (dedicated cache). */
+static struct ext4_fc_rnode *ext4_fc_rnode_alloc(void)
+{
+	return kmem_cache_alloc(ext4_fc_rnode_cachep, GFP_ATOMIC | __GFP_NOWARN);
+}
+
+static void ext4_fc_rnode_free(struct ext4_fc_rnode *node)
+{
+	kmem_cache_free(ext4_fc_rnode_cachep, node);
+}
+
+/*
+ * Free the inode's private range rbtree and reset it to empty.  The tree is
+ * per-commit state, so keeping it would pin memory on an inode that may never
+ * scatter again.  Caller holds ei->i_fc_lock (except from init, where the
+ * inode is not yet reachable, and from the inode teardown in super.c, where it
+ * is no longer reachable).
+ */
+void ext4_fc_free_range_tree(struct inode *inode)
+{
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	struct ext4_fc_rnode *node, *tmp;
+
+	rbtree_postorder_for_each_entry_safe(node, tmp, &ei->i_fc_rt, rb_node)
+		ext4_fc_rnode_free(node);
+	ei->i_fc_rt = RB_ROOT;
+}
+
+/* Drop the tracked range set and reset to an empty tree. */
 static inline void ext4_fc_reset_inode(struct inode *inode)
 {
 	struct ext4_inode_info *ei = EXT4_I(inode);
 
-	ei->i_fc_lblk_start = 0;
-	ei->i_fc_lblk_len = 0;
+	ext4_fc_free_range_tree(inode);
+	ei->i_fc_nr_ranges = 0;
 }
 
 void ext4_fc_init_inode(struct inode *inode)
 {
 	struct ext4_inode_info *ei = EXT4_I(inode);
 
-	ext4_fc_reset_inode(inode);
+	/*
+	 * This also runs from the slab constructor (init_once()), i.e. on
+	 * uninitialised memory, so it must not free anything: just empty the
+	 * tree root.  Use ext4_fc_reset_inode() for a live inode instead.
+	 */
+	ei->i_fc_rt = RB_ROOT;
+	ei->i_fc_nr_ranges = 0;
 	ext4_clear_inode_state(inode, EXT4_STATE_FC_COMMITTING);
 	ext4_clear_inode_state(inode, EXT4_STATE_FC_REQUEUE);
 	INIT_LIST_HEAD(&ei->i_fc_list);
@@ -566,7 +602,11 @@ static int __track_inode(handle_t *handle, struct inode *inode, void *arg,
 	if (update)
 		return -EEXIST;
 
-	EXT4_I(inode)->i_fc_lblk_len = 0;
+	/*
+	 * Drop the range set via the helper rather than just zeroing a count:
+	 * a live range tree has to be freed here or it leaks.
+	 */
+	ext4_fc_reset_inode(inode);
 
 	return 0;
 }
@@ -606,32 +646,129 @@ struct __track_range_args {
 	ext4_lblk_t start, end;
 };
 
+/* Link a fresh node for [start,end] into the FC range rbtree (no overlap). */
+static void ext4_fc_rt_link(struct rb_root *root, struct ext4_fc_rnode *new,
+			    ext4_lblk_t start, ext4_lblk_t end)
+{
+	struct rb_node **link = &root->rb_node, *parent = NULL;
+	struct ext4_fc_rnode *node;
+
+	while (*link) {
+		parent = *link;
+		node = rb_entry(parent, struct ext4_fc_rnode, rb_node);
+		if (start < node->start)
+			link = &parent->rb_left;
+		else
+			link = &parent->rb_right;
+	}
+	new->start = start;
+	new->len = end - start + 1;
+	rb_link_node(&new->rb_node, parent, link);
+	rb_insert_color(&new->rb_node, root);
+}
+
+/*
+ * Record that logical block range [start, end] was modified, in the inode's
+ * private range rbtree.  Absorbs every existing node overlapping or adjacent to
+ * [start,end] into one merged node, so the set stays sorted and disjoint with
+ * no fixed bound.  Adjacency bounds are evaluated in 64 bits: the largest valid
+ * lblk is EXT_MAX_BLOCKS - 1, so "end + 1" and a node's "lblk + len" can reach
+ * EXT_MAX_BLOCKS and must not wrap ext4_lblk_t (u32).  Caller holds i_fc_lock.
+ *
+ * On -ENOMEM (GFP_ATOMIC under i_fc_lock) the new range cannot be recorded, so
+ * the transaction falls back to a full commit, which logs everything -- no
+ * modification is lost.  Rare under memory pressure.
+ */
+static void ext4_fc_range_add(handle_t *handle, struct inode *inode,
+			      ext4_lblk_t start, ext4_lblk_t end)
+{
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	struct rb_root *root = &ei->i_fc_rt;
+	struct ext4_fc_rnode *es, *new;
+	struct rb_node *node;
+	unsigned int merged = 0;
+
+	/* Allocate first so the merge/erase below cannot fail partway. */
+	new = ext4_fc_rnode_alloc();
+	if (!new) {
+		/*
+		 * Could not record the range under memory pressure.  A fast
+		 * commit must log every modified range or replay would restore
+		 * an incomplete inode, so fall back to a full commit rather than
+		 * silently drop it.
+		 *
+		 * ext4_fc_mark_ineligible() takes the s_fc_lock mutex, which must
+		 * not be acquired under the i_fc_lock spinlock the caller holds
+		 * (lock order is s_fc_lock before i_fc_lock); drop and retake
+		 * i_fc_lock around it, as __track_dentry_update() does.
+		 */
+		spin_unlock(&ei->i_fc_lock);
+		ext4_fc_mark_ineligible(inode->i_sb, EXT4_FC_REASON_NOMEM, handle);
+		spin_lock(&ei->i_fc_lock);
+		return;
+	}
+
+	/*
+	 * Find the leftmost node that could overlap or adjoin [start,end]: the
+	 * first with "lblk + len >= start" (i.e. its end+1 >= start).
+	 */
+	node = root->rb_node;
+	es = NULL;
+	while (node) {
+		struct ext4_fc_rnode *cur =
+			rb_entry(node, struct ext4_fc_rnode, rb_node);
+
+		if ((u64)cur->start + cur->len < start) {
+			node = node->rb_right;
+		} else {
+			es = cur;
+			node = node->rb_left;
+		}
+	}
+
+	/* Absorb es and its successors while they stay within [.. end+1]. */
+	node = es ? &es->rb_node : NULL;
+	while (node) {
+		es = rb_entry(node, struct ext4_fc_rnode, rb_node);
+		if ((u64)es->start > (u64)end + 1)
+			break;
+		if (es->start < start)
+			start = es->start;
+		if ((u64)es->start + es->len - 1 > end)
+			end = es->start + es->len - 1;
+		node = rb_next(node);
+		rb_erase(&es->rb_node, root);
+		ext4_fc_rnode_free(es);
+		merged++;
+	}
+
+	ext4_fc_rt_link(root, new, start, end);
+	ei->i_fc_nr_ranges += 1 - merged;
+}
+
 /* __track_fn for tracking data updates */
 static int __track_range(handle_t *handle, struct inode *inode, void *arg,
 			 bool update)
 {
-	struct ext4_inode_info *ei = EXT4_I(inode);
-	ext4_lblk_t oldstart;
 	struct __track_range_args *__arg =
 		(struct __track_range_args *)arg;
+	ext4_lblk_t start = __arg->start, end = __arg->end;
 
 	if (inode->i_ino < EXT4_FIRST_INO(inode->i_sb)) {
 		ext4_debug("Special inode %llu being modified\n", inode->i_ino);
 		return -ECANCELED;
 	}
 
-	oldstart = ei->i_fc_lblk_start;
-
-	if (update && ei->i_fc_lblk_len > 0) {
-		ei->i_fc_lblk_start = min(ei->i_fc_lblk_start, __arg->start);
-		ei->i_fc_lblk_len =
-			max(oldstart + ei->i_fc_lblk_len - 1, __arg->end) -
-				ei->i_fc_lblk_start + 1;
-	} else {
-		ei->i_fc_lblk_start = __arg->start;
-		ei->i_fc_lblk_len = __arg->end - __arg->start + 1;
-	}
+	/*
+	 * A sub-block punch hole rounds up the start and down the end, passing
+	 * end == start - 1: no whole block changed, so there is nothing to
+	 * track.  (ext4_fc_track_template has already reset the range set for a
+	 * new transaction, so we need not do it here.)
+	 */
+	if (end < start)
+		return 0;
 
+	ext4_fc_range_add(handle, inode, start, end);
 	return 0;
 }
 
@@ -977,31 +1114,26 @@ static void ext4_fc_free_inode_snap(struct inode *inode)
 	ei->i_fc_snap = NULL;
 }
 
-static int ext4_fc_snapshot_inode_data(struct inode *inode,
+/*
+ * Snapshot one modified lblk range [start_lblk, end_lblk] into @ranges by
+ * walking the extent status tree, emitting an ADD_RANGE per mapped segment and
+ * a DEL_RANGE per hole.  *nr_ranges accumulates the number of ranges produced
+ * for this inode across calls; together with nr_ranges_total (ranges already
+ * produced by earlier inodes in this commit) it is bounded against
+ * EXT4_FC_SNAPSHOT_MAX_RANGES.
+ */
+static int ext4_fc_snapshot_lblk_range(struct inode *inode,
+				       ext4_lblk_t start_lblk,
+				       ext4_lblk_t end_lblk,
 				       struct list_head *ranges,
 				       unsigned int nr_ranges_total,
-				       unsigned int *nr_rangesp,
+				       unsigned int *nr_ranges,
 				       int *snap_err)
 {
-	struct ext4_inode_info *ei = EXT4_I(inode);
 	struct ext4_fc_snap_stats *stats =
 		&EXT4_SB(inode->i_sb)->s_fc_snap_stats;
-	ext4_lblk_t start_lblk, end_lblk, cur_lblk;
-	unsigned int nr_ranges = 0;
-
-	spin_lock(&ei->i_fc_lock);
-	if (ei->i_fc_lblk_len == 0) {
-		spin_unlock(&ei->i_fc_lock);
-		if (nr_rangesp)
-			*nr_rangesp = 0;
-		return 0;
-	}
-	start_lblk = ei->i_fc_lblk_start;
-	end_lblk = ei->i_fc_lblk_start + ei->i_fc_lblk_len - 1;
-	ei->i_fc_lblk_len = 0;
-	spin_unlock(&ei->i_fc_lock);
+	ext4_lblk_t cur_lblk = start_lblk;
 
-	cur_lblk = start_lblk;
 	ext4_debug("snapshot data ranges %u-%u for inode %llu\n",
 		   start_lblk, end_lblk,
 		   (unsigned long long)inode->i_ino);
@@ -1033,7 +1165,7 @@ static int ext4_fc_snapshot_inode_data(struct inode *inode,
 			continue;
 		}
 
-		if (nr_ranges_total + nr_ranges >= EXT4_FC_SNAPSHOT_MAX_RANGES) {
+		if (nr_ranges_total + *nr_ranges >= EXT4_FC_SNAPSHOT_MAX_RANGES) {
 			atomic64_inc(&stats->snap_fail_ranges_cap);
 			ext4_fc_set_snap_err(snap_err,
 					     EXT4_FC_SNAP_ERR_RANGES_CAP);
@@ -1046,7 +1178,7 @@ static int ext4_fc_snapshot_inode_data(struct inode *inode,
 			ext4_fc_set_snap_err(snap_err, EXT4_FC_SNAP_ERR_NOMEM);
 			return -ENOMEM;
 		}
-		nr_ranges++;
+		(*nr_ranges)++;
 
 		range->lblk = cur_lblk;
 		range->len = len;
@@ -1084,6 +1216,58 @@ static int ext4_fc_snapshot_inode_data(struct inode *inode,
 		cur_lblk += range->len;
 	}
 
+	return 0;
+}
+
+static int ext4_fc_snapshot_inode_data(struct inode *inode,
+				       struct list_head *ranges,
+				       unsigned int nr_ranges_total,
+				       unsigned int *nr_rangesp,
+				       int *snap_err)
+{
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	struct rb_root tree = RB_ROOT;
+	struct ext4_fc_rnode *es, *tmp;
+	struct rb_node *node;
+	unsigned int nr_ranges = 0;
+	int ret = 0;
+
+	/*
+	 * Take the whole range tree away from the inode; it is now private, so
+	 * it can be walked lock-free and freed below.  The inode starts a fresh
+	 * (empty) set for the next commit.
+	 */
+	spin_lock(&ei->i_fc_lock);
+	if (ei->i_fc_nr_ranges == 0) {
+		spin_unlock(&ei->i_fc_lock);
+		if (nr_rangesp)
+			*nr_rangesp = 0;
+		return 0;
+	}
+	tree = ei->i_fc_rt;		/* adopt the whole tree */
+	ei->i_fc_rt = RB_ROOT;
+	ei->i_fc_nr_ranges = 0;
+	spin_unlock(&ei->i_fc_lock);
+
+	/*
+	 * Snapshot only the actually-modified ranges, not the whole [min,max]
+	 * span: this is what keeps scattered allocations from blowing past
+	 * EXT4_FC_SNAPSHOT_MAX_RANGES and falling back to a full commit.
+	 */
+	for (node = rb_first(&tree); node; node = rb_next(node)) {
+		es = rb_entry(node, struct ext4_fc_rnode, rb_node);
+		ret = ext4_fc_snapshot_lblk_range(inode, es->start,
+						  es->start + es->len - 1,
+						  ranges, nr_ranges_total,
+						  &nr_ranges, snap_err);
+		if (ret)
+			break;
+	}
+	rbtree_postorder_for_each_entry_safe(es, tmp, &tree, rb_node)
+		ext4_fc_rnode_free(es);
+	if (ret)
+		return ret;
+
 	if (nr_rangesp)
 		*nr_rangesp = nr_ranges;
 	return 0;
@@ -2751,16 +2935,30 @@ int __init ext4_fc_init_dentry_cache(void)
 		return -ENOMEM;
 
 	ext4_fc_range_cachep = KMEM_CACHE(ext4_fc_range, SLAB_RECLAIM_ACCOUNT);
-	if (!ext4_fc_range_cachep) {
-		kmem_cache_destroy(ext4_fc_dentry_cachep);
-		return -ENOMEM;
-	}
+	if (!ext4_fc_range_cachep)
+		goto err_range;
+
+	/*
+	 * FC range-tree nodes are pinned until the commit snapshots them, so
+	 * this cache is deliberately not SLAB_RECLAIM_ACCOUNT (unlike the shared
+	 * extent_status cache) -- they must not be counted as reclaimable.
+	 */
+	ext4_fc_rnode_cachep = KMEM_CACHE(ext4_fc_rnode, 0);
+	if (!ext4_fc_rnode_cachep)
+		goto err_rnode;
 
 	return 0;
+
+err_rnode:
+	kmem_cache_destroy(ext4_fc_range_cachep);
+err_range:
+	kmem_cache_destroy(ext4_fc_dentry_cachep);
+	return -ENOMEM;
 }
 
 void ext4_fc_destroy_dentry_cache(void)
 {
+	kmem_cache_destroy(ext4_fc_rnode_cachep);
 	kmem_cache_destroy(ext4_fc_range_cachep);
 	kmem_cache_destroy(ext4_fc_dentry_cachep);
 }
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 6c18b5adffca..99eca2b123b1 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1464,6 +1464,8 @@ static void ext4_free_in_core_inode(struct inode *inode)
 		pr_warn("%s: inode %llu still in fc list",
 			__func__, inode->i_ino);
 	}
+	/* Tear down the fast-commit range tree if one is still live. */
+	ext4_fc_free_range_tree(inode);
 	kmem_cache_free(ext4_inode_cachep, EXT4_I(inode));
 }
 
-- 
2.43.0
