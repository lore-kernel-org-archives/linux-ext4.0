Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F653290A5
	for <linux-ext4@vger.kernel.org>; Thu, 30 Jul 2026 00:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785371946; cv=none; b=IfOKuhtMq8jO8NTrajRnhsqWtK0Ll/J4vKURXKMhTML49EFKEmtSaErVcVdsVA52DhWV6cPrSsw1Qo0F4JdA9iI8bxmLoVjXfvzCnbn+tHVGX40liJC/bPN/r89Ojprn3lypDN+9z1kExwsX9e6/9RX5Jg+5sKvM55cGRLvMl1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785371946; c=relaxed/simple;
	bh=k+E/GcoizgNXRMNcClazNT2hSLvagpKHlpnv1rBAfmk=;
	h=Mime-Version:Subject:From:To:CC:In-Reply-To:Message-ID:Date:
	 Content-Type:References; b=uZFodstcBJ2PCDSE/a6IWXkkQGQ72uYv/oowtDVKkmOO1c8Pefdl7DitIjCRbtioJK2N403MEHlF5sX0OS3OOi3mEdcY0ujjl/pTs6ORBKDkKgeKABJFGG6emYa9WW28fJsUl7Y3013XpjeoGX2t6auRv1an4eImbl6dtp3FLX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=EAcd9Vi1; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="EAcd9Vi1"
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260730003901epoutp022ddcea773badb7669431052dc88985f5~G6lJBxxee3111631116epoutp02d
	for <linux-ext4@vger.kernel.org>; Thu, 30 Jul 2026 00:39:01 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260730003901epoutp022ddcea773badb7669431052dc88985f5~G6lJBxxee3111631116epoutp02d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1785371941;
	bh=j0uVZ/9LPkG/Ths4IlNaYFHknYKsLFy267eBBZDxJMI=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=EAcd9Vi1X5/gEYElPf1DASmg6aHUXWUU2/XuPClc1TrmXB5/EGW9sr9YRPwf4SI2R
	 eURO4VwJmicEcu7ptKrWcSWywI3vHike6exoNVgsavtaJK2JKeYruNU1vpM3cXuqYC
	 cJnJxFuTx2fkbU/fEz70FigP7JpTX45Xa6ukbtSk=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPS id
	20260730003900epcas2p308d51bf6b2020df0288fbca999ec892d~G6lIhTWM12941229412epcas2p3d;
	Thu, 30 Jul 2026 00:39:00 +0000 (GMT)
Received: from epcas2p1.samsung.com (unknown [182.195.38.204]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4h9Vgm2zwzz6B9mH; Thu, 30 Jul
	2026 00:39:00 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: [RFC PATCH v4 2/3] ext4: fast commit: keep the first range inline,
 allocate the tree lazily
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
In-Reply-To: <20260730003810epcms2p6cd37c6242602c1467b7665cdcc785ea8@epcms2p6>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20260730003859epcms2p76b1895649892f9f75f822ee08578b46b@epcms2p7>
Date: Thu, 30 Jul 2026 09:38:59 +0900
X-CMS-MailID: 20260730003859epcms2p76b1895649892f9f75f822ee08578b46b
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260730003715epcms2p54b7e3cc3409076cc9ee751f60951e167
References: <20260730003810epcms2p6cd37c6242602c1467b7665cdcc785ea8@epcms2p6>
	<20260730003715epcms2p54b7e3cc3409076cc9ee751f60951e167@epcms2p5>
	<CGME20260730003715epcms2p54b7e3cc3409076cc9ee751f60951e167@epcms2p7>

The previous patch tracks every inode's modified ranges in an rbtree,
allocating a node even for an inode dirtied in a single contiguous region
-- the common case, which never needs more than one range.

Keep the first range inline in the inode instead, in a union with the
rbtree root, so a single-region inode allocates nothing.  A state bit
(EXT4_STATE_FC_RANGE_ARRAY) says which member of the union is live.  Only
when a second, disjoint range appears is the inode upgraded to the tree:
the previously-inline range is seeded as the first node and the new range
added.  Overlapping or adjacent updates keep coalescing into the inline
range with no allocation.

The node holding the previously-inline range is preallocated before the
switch, so the upgrade cannot fail partway.  If that GFP_ATOMIC allocation
fails the inode simply stays inline and coalesces the new range into the
existing span -- a valid fast commit that over-logs the gap, so nothing is
lost and no full-commit fallback is needed.

The commit-time snapshot handles both modes: it adopts and walks the tree
in tree mode, or snapshots the single inline range otherwise.

Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
 fs/ext4/ext4.h        |  38 +++++++++---
 fs/ext4/fast_commit.c | 137 ++++++++++++++++++++++++++++++++++--------
 2 files changed, 139 insertions(+), 36 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 7eedb609019a..23461d15d72a 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1042,6 +1042,12 @@ enum ext4_fc_snap_err {
 	EXT4_FC_SNAP_ERR_INODE_LOC,
 };
 
+/* The first modified range of a fast commit, kept inline in the inode. */
+struct ext4_fc_lblk_range {
+	ext4_lblk_t start;
+	ext4_lblk_t len;
+};
+
 /*
  * Node of the per-inode fast-commit range rbtree (see i_fc_rt).  A dedicated
  * 32-byte node with its own slab cache -- deliberately not the shared
@@ -1110,17 +1116,28 @@ struct ext4_inode_info {
 					 */
 
 	/*
-	 * Logical block ranges modified in this fast commit, tracked as a set of
-	 * disjoint ranges in a private rbtree of struct ext4_fc_rnode nodes
-	 * (keyed by logical block) instead of one coalesced [min,max] span.  This
-	 * avoids snapshotting the whole spanned extent map for scattered
-	 * allocations.  Overlapping/adjacent ranges merge on insert, so the set
-	 * stays disjoint with no fixed bound; density is bounded only by the
-	 * snapshot cap.  rb_root is one pointer, so the tree needs no root
-	 * allocation -- only per-range nodes, torn down at commit.  i_fc_nr_ranges
-	 * is the exact number of tracked ranges.  Protected by i_fc_lock.
+	 * Logical block ranges modified in this fast commit.  Tracking the
+	 * actual modified ranges (instead of one coalesced [min,max]) avoids
+	 * snapshotting the whole spanned extent map for scattered allocations.
+	 *
+	 * The first range is kept inline in i_fc_range, so the common case of a
+	 * single contiguous dirty region needs no allocation.  When a second
+	 * disjoint range appears the inode is upgraded to a private rbtree of
+	 * struct ext4_fc_rnode nodes (a dedicated slab cache, FC-owned; NOT the
+	 * shared i_es_tree).  Adjacent/overlapping ranges are merged on insert, so
+	 * the set stays disjoint with no fixed bound; density is bounded only by
+	 * the snapshot cap.  rb_root is one pointer, so the tree needs no root
+	 * allocation -- only per-range nodes.
+	 *
+	 * The two are a union, so an inode that never scatters pays only for the
+	 * inline range: EXT4_STATE_FC_RANGE_ARRAY says which member is live.
+	 * i_fc_nr_ranges is the exact number of tracked ranges.  All of it is
+	 * protected by i_fc_lock.
 	 */
-	struct rb_root i_fc_rt;
+	union {
+		struct ext4_fc_lblk_range i_fc_range;
+		struct rb_root i_fc_rt;
+	};
 	unsigned int i_fc_nr_ranges;
 
 	/*
@@ -2069,6 +2086,7 @@ enum {
 	EXT4_STATE_FC_FLUSHING_DATA,	/* Fast commit flushing data */
 	EXT4_STATE_ORPHAN_FILE,		/* Inode orphaned in orphan file */
 	EXT4_STATE_FC_REQUEUE,		/* Inode modified during fast commit */
+	EXT4_STATE_FC_RANGE_ARRAY,	/* i_fc_rt (not i_fc_range) is live */
 };
 
 #define EXT4_INODE_BIT_FNS(name, field, offset)				\
diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 4550c5dae39c..1a72d7f31135 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -226,17 +226,22 @@ void ext4_fc_free_range_tree(struct inode *inode)
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	struct ext4_fc_rnode *node, *tmp;
 
-	rbtree_postorder_for_each_entry_safe(node, tmp, &ei->i_fc_rt, rb_node)
-		ext4_fc_rnode_free(node);
-	ei->i_fc_rt = RB_ROOT;
+	if (ext4_test_inode_state(inode, EXT4_STATE_FC_RANGE_ARRAY)) {
+		rbtree_postorder_for_each_entry_safe(node, tmp, &ei->i_fc_rt,
+						     rb_node)
+			ext4_fc_rnode_free(node);
+		ext4_clear_inode_state(inode, EXT4_STATE_FC_RANGE_ARRAY);
+	}
 }
 
-/* Drop the tracked range set and reset to an empty tree. */
+/* Drop the tracked range set and fall back to the (empty) inline range. */
 static inline void ext4_fc_reset_inode(struct inode *inode)
 {
 	struct ext4_inode_info *ei = EXT4_I(inode);
 
 	ext4_fc_free_range_tree(inode);
+	ei->i_fc_range.start = 0;
+	ei->i_fc_range.len = 0;
 	ei->i_fc_nr_ranges = 0;
 }
 
@@ -246,10 +251,13 @@ void ext4_fc_init_inode(struct inode *inode)
 
 	/*
 	 * This also runs from the slab constructor (init_once()), i.e. on
-	 * uninitialised memory, so it must not free anything: just empty the
-	 * tree root.  Use ext4_fc_reset_inode() for a live inode instead.
+	 * uninitialised memory, so it must not consult the state bit and must
+	 * not free anything: put the union into inline mode outright.  Use
+	 * ext4_fc_reset_inode() for a live inode instead.
 	 */
-	ei->i_fc_rt = RB_ROOT;
+	ext4_clear_inode_state(inode, EXT4_STATE_FC_RANGE_ARRAY);
+	ei->i_fc_range.start = 0;
+	ei->i_fc_range.len = 0;
 	ei->i_fc_nr_ranges = 0;
 	ext4_clear_inode_state(inode, EXT4_STATE_FC_COMMITTING);
 	ext4_clear_inode_state(inode, EXT4_STATE_FC_REQUEUE);
@@ -750,9 +758,11 @@ static void ext4_fc_range_add(handle_t *handle, struct inode *inode,
 static int __track_range(handle_t *handle, struct inode *inode, void *arg,
 			 bool update)
 {
+	struct ext4_inode_info *ei = EXT4_I(inode);
 	struct __track_range_args *__arg =
 		(struct __track_range_args *)arg;
 	ext4_lblk_t start = __arg->start, end = __arg->end;
+	ext4_lblk_t s0, e0;
 
 	if (inode->i_ino < EXT4_FIRST_INO(inode->i_sb)) {
 		ext4_debug("Special inode %llu being modified\n", inode->i_ino);
@@ -768,7 +778,62 @@ static int __track_range(handle_t *handle, struct inode *inode, void *arg,
 	if (end < start)
 		return 0;
 
-	ext4_fc_range_add(handle, inode, start, end);
+	/* Already upgraded to the tree: full multi-interval tracking. */
+	if (ext4_test_inode_state(inode, EXT4_STATE_FC_RANGE_ARRAY)) {
+		ext4_fc_range_add(handle, inode, start, end);
+		return 0;
+	}
+
+	/* First range of this commit stays inline, no allocation needed. */
+	if (ei->i_fc_nr_ranges == 0) {
+		ei->i_fc_range.start = start;
+		ei->i_fc_range.len = end - start + 1;
+		ei->i_fc_nr_ranges = 1;
+		return 0;
+	}
+
+	/* One inline range so far. */
+	s0 = ei->i_fc_range.start;
+	e0 = s0 + ei->i_fc_range.len - 1;
+
+	/*
+	 * Disjoint from it: try to upgrade to the tree for exact tracking.
+	 * Evaluate the adjacency bounds in 64 bits: the largest valid lblk is
+	 * EXT_MAX_BLOCKS - 1, so e0 + 1 and end + 1 can reach EXT_MAX_BLOCKS and
+	 * must not wrap the ext4_lblk_t (u32) type.
+	 */
+	if (start > (u64)e0 + 1 || (u64)end + 1 < s0) {
+		struct ext4_fc_rnode *n0 = ext4_fc_rnode_alloc();
+
+		/*
+		 * Pre-allocate the node holding the previously-inline range so
+		 * the switch to tree mode cannot fail partway.  __GFP_NOWARN in
+		 * the allocator: on failure we fall back to the single coalesced
+		 * range below, so it must not splat under memory pressure.
+		 */
+		if (n0) {
+			ei->i_fc_rt = RB_ROOT;
+			ext4_set_inode_state(inode, EXT4_STATE_FC_RANGE_ARRAY);
+			ext4_fc_rt_link(&ei->i_fc_rt, n0, s0, e0);
+			ext4_fc_range_add(handle, inode, start, end);
+			return 0;
+		}
+		/*
+		 * Out of memory: fall back to the original single coalesced
+		 * range by absorbing the gap below.  This over-logs the spanned
+		 * extents but stays a valid fast commit (no full-commit
+		 * fallback), so there is nothing to mark ineligible.
+		 */
+	}
+
+	/* Overlapping/adjacent, or node allocation failed: coalesce inline. */
+	if (start < s0)
+		s0 = start;
+	if (end > e0)
+		e0 = end;
+	ei->i_fc_range.start = s0;
+	ei->i_fc_range.len = e0 - s0 + 1;
+
 	return 0;
 }
 
@@ -1226,26 +1291,37 @@ static int ext4_fc_snapshot_inode_data(struct inode *inode,
 				       int *snap_err)
 {
 	struct ext4_inode_info *ei = EXT4_I(inode);
+	struct ext4_fc_lblk_range inline_range;
 	struct rb_root tree = RB_ROOT;
 	struct ext4_fc_rnode *es, *tmp;
 	struct rb_node *node;
-	unsigned int nr_ranges = 0;
+	unsigned int nr_ranges = 0, nr_tracked;
+	bool tree_mode = false;
 	int ret = 0;
 
 	/*
-	 * Take the whole range tree away from the inode; it is now private, so
-	 * it can be walked lock-free and freed below.  The inode starts a fresh
-	 * (empty) set for the next commit.
+	 * Take the range set away from the inode.  In tree mode we adopt the
+	 * whole rbtree (it is now private, so it can be walked lock-free) and
+	 * free its nodes below; the inode falls back to inline mode for the
+	 * next commit.  The single inline range is small enough to just copy.
 	 */
 	spin_lock(&ei->i_fc_lock);
-	if (ei->i_fc_nr_ranges == 0) {
+	nr_tracked = ei->i_fc_nr_ranges;
+	if (nr_tracked == 0) {
 		spin_unlock(&ei->i_fc_lock);
 		if (nr_rangesp)
 			*nr_rangesp = 0;
 		return 0;
 	}
-	tree = ei->i_fc_rt;		/* adopt the whole tree */
-	ei->i_fc_rt = RB_ROOT;
+	if (ext4_test_inode_state(inode, EXT4_STATE_FC_RANGE_ARRAY)) {
+		tree = ei->i_fc_rt;	/* adopt the whole tree */
+		tree_mode = true;
+		ext4_clear_inode_state(inode, EXT4_STATE_FC_RANGE_ARRAY);
+	} else {
+		inline_range = ei->i_fc_range;	/* inline single-range mode */
+	}
+	ei->i_fc_range.start = 0;
+	ei->i_fc_range.len = 0;
 	ei->i_fc_nr_ranges = 0;
 	spin_unlock(&ei->i_fc_lock);
 
@@ -1254,19 +1330,28 @@ static int ext4_fc_snapshot_inode_data(struct inode *inode,
 	 * span: this is what keeps scattered allocations from blowing past
 	 * EXT4_FC_SNAPSHOT_MAX_RANGES and falling back to a full commit.
 	 */
-	for (node = rb_first(&tree); node; node = rb_next(node)) {
-		es = rb_entry(node, struct ext4_fc_rnode, rb_node);
-		ret = ext4_fc_snapshot_lblk_range(inode, es->start,
-						  es->start + es->len - 1,
-						  ranges, nr_ranges_total,
-						  &nr_ranges, snap_err);
+	if (tree_mode) {
+		for (node = rb_first(&tree); node; node = rb_next(node)) {
+			es = rb_entry(node, struct ext4_fc_rnode, rb_node);
+			ret = ext4_fc_snapshot_lblk_range(inode, es->start,
+							  es->start + es->len - 1,
+							  ranges, nr_ranges_total,
+							  &nr_ranges, snap_err);
+			if (ret)
+				break;
+		}
+		rbtree_postorder_for_each_entry_safe(es, tmp, &tree, rb_node)
+			ext4_fc_rnode_free(es);
 		if (ret)
-			break;
+			return ret;
+	} else {
+		ret = ext4_fc_snapshot_lblk_range(inode, inline_range.start,
+						  inline_range.start + inline_range.len - 1,
+						  ranges, nr_ranges_total, &nr_ranges,
+						  snap_err);
+		if (ret)
+			return ret;
 	}
-	rbtree_postorder_for_each_entry_safe(es, tmp, &tree, rb_node)
-		ext4_fc_rnode_free(es);
-	if (ret)
-		return ret;
 
 	if (nr_rangesp)
 		*nr_rangesp = nr_ranges;
-- 
2.43.0
