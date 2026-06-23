Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FFFD3CDBB5
	for <linux-ext4@vger.kernel.org>; Tue, 23 Jun 2026 08:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782203111; cv=none; b=B2icWjvbu5q+LjzYgMTQZbnTgrdu68M2hXTHg1rQFrlhG51xRmFdpzORFE3wcuroM5msUamxPiNxCHxNLg5JcKRmaG6/Tml0KoJBJgcFShS7qfthNfa6yGAEr/TN6/ENqWIVaAQlEQ/Z69DbfeTtHCiyd+zVP599EIgmGJyyP0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782203111; c=relaxed/simple;
	bh=Z9cppi3Ob1myQ8qp0V1GqtLwcSrL7OdDLCPxg2BwgTs=;
	h=Mime-Version:Subject:From:To:CC:In-Reply-To:Message-ID:Date:
	 Content-Type:References; b=gQQaH2njwR8B/4Re/X16qcggBvmEhPpOga+oi5szBrTHLp6EK9kLNvsRPSmhHQ0Loz+hswtKsgtFJLsSgWbWEFa1Gw+IRiaSMPnzBZ6EjanpVI2nJD1k0rPLS5h6k2AjWzDjFyvSe0sYg8aAakpj5dmjSvHTeNLdJheclYWGEXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=an+d0jcu; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="an+d0jcu"
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260623082507epoutp027f967159448b986f24187121aa1e57a7~7qEi0Sl9-0068600686epoutp02G
	for <linux-ext4@vger.kernel.org>; Tue, 23 Jun 2026 08:25:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260623082507epoutp027f967159448b986f24187121aa1e57a7~7qEi0Sl9-0068600686epoutp02G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1782203107;
	bh=L7jfFanuTXhPd+g75txpPloQPApSwIZ1RO263aRO+T0=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=an+d0jcuRQ0iNqg4vwZoaik9ffNe8Rv26jFNHA05u78fDjj3oMJ0v0nqgbRLCYiGO
	 AOZ0wsojPRtOQmKh8Crgla1z2vfxcGusc5HUrGmzqdCywG8Cpc7RvrHp4dUld2oG2R
	 H5Y0tE3GLVzjG7IisxeBDwQE7H4PcVf7eVV3FZis=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPS id
	20260623082507epcas2p3c7c0ec549d7ecf624b958047d308d500~7qEiJrBZw0542705427epcas2p3s;
	Tue, 23 Jun 2026 08:25:07 +0000 (GMT)
Received: from epcas2p3.samsung.com (unknown [182.195.38.212]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4gkymf4tvvz6B9mX; Tue, 23 Jun
	2026 08:25:06 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: [RFC PATCH v2 1/2] ext4: fast commit: track disjoint modified
 ranges  per inode
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From: Daejun Park <daejun7.park@samsung.com>
To: "tytso@mit.edu" <tytso@mit.edu>, "adilger.kernel@dilger.ca"
	<adilger.kernel@dilger.ca>
CC: "me@linux.beauty" <me@linux.beauty>, "libaokun@linux.alibaba.com"
	<libaokun@linux.alibaba.com>, "harshadshirwadkar@gmail.com"
	<harshadshirwadkar@gmail.com>, "yi.zhang@huaweicloud.com"
	<yi.zhang@huaweicloud.com>, "ojaswin@linux.ibm.com" <ojaswin@linux.ibm.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Daejun Park
	<daejun7.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20260623082331epcms2p4798e9d26b06f9a005bcca7b2edf395d3@epcms2p4>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20260623082506epcms2p81c2f8abfee34b88e5a645fbfaaf4bf9e@epcms2p8>
Date: Tue, 23 Jun 2026 17:25:06 +0900
X-CMS-MailID: 20260623082506epcms2p81c2f8abfee34b88e5a645fbfaaf4bf9e
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260623082331epcms2p4798e9d26b06f9a005bcca7b2edf395d3
References: <20260623082331epcms2p4798e9d26b06f9a005bcca7b2edf395d3@epcms2p4>
	<CGME20260623082331epcms2p4798e9d26b06f9a005bcca7b2edf395d3@epcms2p8>

Fast commit tracks a single coalesced logical range per inode
(i_fc_lblk_start .. i_fc_lblk_len).  When an inode is modified at
several disjoint offsets between two commits (e.g. random writes), that
range widens to span [min, max] of all touched offsets.  At commit time
ext4_fc_snapshot_inode_data() walks that whole span through the extent
status tree, emitting an ADD_RANGE per mapped segment and a DEL_RANGE
per hole -- including the unmodified ones.  On scattered allocations
this produces hundreds to thousands of ranges per commit and exceeds
EXT4_FC_SNAPSHOT_MAX_RANGES, which fails the snapshot and falls back to
a full jbd2 commit -- the heavy path fast commit is meant to avoid.

Replace the single range with a bounded set of up to EXT4_FC_MAX_RANGES
(16) sorted, mutually disjoint ranges.  ext4_fc_range_add() inserts and
merges into it; on overflow the two ranges separated by the smallest
gap are coalesced, so the worst case degrades to the old single-span
behaviour.  ext4_fc_snapshot_inode_data() now walks only the tracked
ranges.  The on-disk fast-commit (TLV) format is unchanged.

On a sparse random-write workload (1 GiB span, 16 disjoint 4 KiB writes
per fsync, 300 fsyncs, dev 7.1.0-rc4): ranges per commit 1095 -> 16,
full-commit fallback 76% -> 0.7%, snap_fail_ranges_cap 226 -> 0.

Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
 fs/ext4/ext4.h        |  31 ++++++--
 fs/ext4/fast_commit.c | 165 +++++++++++++++++++++++++++++++++---------
 2 files changed, 156 insertions(+), 40 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index ddc903738c6b..8e93d30766fd 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1042,6 +1042,20 @@ enum ext4_fc_snap_err {
 	EXT4_FC_SNAP_ERR_INODE_LOC,
 };
 
+/*
+ * Maximum number of disjoint logical-block ranges tracked per inode for a
+ * single fast commit.  Scattered allocations that exceed this get their two
+ * closest ranges merged (see ext4_fc_range_add()), degrading gracefully to
+ * the old single coalesced-range behaviour.
+ */
+#define EXT4_FC_MAX_RANGES 16
+
+/* In-memory record of an lblk range modified in the current fast commit. */
+struct ext4_fc_lblk_range {
+	ext4_lblk_t start;
+	ext4_lblk_t len;
+};
+
 /*
  * fourth extended file system inode data in memory
  */
@@ -1091,11 +1105,16 @@ struct ext4_inode_info {
 					 * protected by sbi->s_fc_lock.
 					 */
 
-	/* Start of lblk range that needs to be committed in this fast commit */
-	ext4_lblk_t i_fc_lblk_start;
-
-	/* End of lblk range that needs to be committed in this fast commit */
-	ext4_lblk_t i_fc_lblk_len;
+	/*
+	 * Disjoint lblk ranges modified in this fast commit.  Tracking the
+	 * actual modified ranges (instead of one coalesced [min,max]) avoids
+	 * snapshotting the whole spanned extent map for scattered allocations.
+	 * Sorted by start, mutually disjoint.  Bounded by EXT4_FC_MAX_RANGES;
+	 * the extra slot is transient room used while inserting before an
+	 * overflow merge.  Protected by i_fc_lock.
+	 */
+	struct ext4_fc_lblk_range i_fc_ranges[EXT4_FC_MAX_RANGES + 1];
+	unsigned int i_fc_nr_ranges;
 
 	/*
 	 * Commit-time fast commit snapshots.
@@ -1116,7 +1135,7 @@ struct ext4_inode_info {
 	spinlock_t i_raw_lock;	/* protects updates to the raw inode */
 
 	/*
-	 * Protect concurrent accesses on i_fc_lblk_start, i_fc_lblk_len
+	 * Protect concurrent accesses on i_fc_ranges, i_fc_nr_ranges
 	 * and inode's EXT4_FC_STATE_COMMITTING state bit.
 	 */
 	spinlock_t i_fc_lock;
diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 4ef796b9b6cb..1ea3742a55b1 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -222,8 +222,7 @@ static inline void ext4_fc_reset_inode(struct inode *inode)
 {
 	struct ext4_inode_info *ei = EXT4_I(inode);
 
-	ei->i_fc_lblk_start = 0;
-	ei->i_fc_lblk_len = 0;
+	ei->i_fc_nr_ranges = 0;
 }
 
 void ext4_fc_init_inode(struct inode *inode)
@@ -582,7 +581,7 @@ static int __track_inode(handle_t *handle, struct inode *inode, void *arg,
 	if (update)
 		return -EEXIST;
 
-	EXT4_I(inode)->i_fc_lblk_len = 0;
+	EXT4_I(inode)->i_fc_nr_ranges = 0;
 
 	return 0;
 }
@@ -622,12 +621,74 @@ struct __track_range_args {
 	ext4_lblk_t start, end;
 };
 
+/*
+ * Record that logical block range [start, end] was modified in the current
+ * fast commit.  Maintains a small, bounded set of sorted, mutually disjoint
+ * ranges, merging the new range with any it overlaps or is adjacent to.  When
+ * the set would exceed EXT4_FC_MAX_RANGES, the consecutive pair separated by
+ * the smallest gap is merged (absorbing that gap), so the worst case degrades
+ * gracefully to the old single coalesced-range behaviour.  Tracking the actual
+ * modified ranges (rather than one [min,max] span) keeps
+ * ext4_fc_snapshot_inode_data() from snapshotting the whole spanned extent map
+ * on scattered allocations.  Caller holds ei->i_fc_lock; ei->i_fc_ranges is
+ * non-NULL with room for EXT4_FC_MAX_RANGES + 1 entries.
+ */
+static void ext4_fc_range_add(struct ext4_inode_info *ei,
+			      ext4_lblk_t start, ext4_lblk_t end)
+{
+	struct ext4_fc_lblk_range *r = ei->i_fc_ranges;
+	unsigned int n = ei->i_fc_nr_ranges;
+	unsigned int i, j;
+
+	/* Skip ranges lying entirely before [start - 1] (no overlap/adjacency). */
+	i = 0;
+	while (i < n && r[i].start + r[i].len < start)
+		i++;
+
+	/* Absorb every range overlapping or adjacent to the growing [start,end]. */
+	j = i;
+	while (j < n && r[j].start <= end + 1) {
+		if (r[j].start < start)
+			start = r[j].start;
+		if (r[j].start + r[j].len - 1 > end)
+			end = r[j].start + r[j].len - 1;
+		j++;
+	}
+
+	/* Replace r[i..j-1] with the merged range (j == i is a plain insert). */
+	if (j != i + 1)
+		memmove(&r[i + 1], &r[j], (n - j) * sizeof(*r));
+	r[i].start = start;
+	r[i].len = end - start + 1;
+	ei->i_fc_nr_ranges = n - (j - i) + 1;
+
+	/* Overflow: merge the consecutive pair separated by the smallest gap. */
+	while (ei->i_fc_nr_ranges > EXT4_FC_MAX_RANGES) {
+		ext4_lblk_t best_gap = ~0U;
+		unsigned int best = 0;
+
+		n = ei->i_fc_nr_ranges;
+		for (i = 0; i + 1 < n; i++) {
+			ext4_lblk_t gap = r[i + 1].start -
+					  (r[i].start + r[i].len);
+
+			if (gap < best_gap) {
+				best_gap = gap;
+				best = i;
+			}
+		}
+		r[best].len = r[best + 1].start + r[best + 1].len - r[best].start;
+		memmove(&r[best + 1], &r[best + 2],
+			(n - best - 2) * sizeof(*r));
+		ei->i_fc_nr_ranges = n - 1;
+	}
+}
+
 /* __track_fn for tracking data updates */
 static int __track_range(handle_t *handle, struct inode *inode, void *arg,
 			 bool update)
 {
 	struct ext4_inode_info *ei = EXT4_I(inode);
-	ext4_lblk_t oldstart;
 	struct __track_range_args *__arg =
 		(struct __track_range_args *)arg;
 
@@ -636,17 +697,16 @@ static int __track_range(handle_t *handle, struct inode *inode, void *arg,
 		return -ECANCELED;
 	}
 
-	oldstart = ei->i_fc_lblk_start;
+	/*
+	 * A sub-block punch hole rounds up the start and down the end, passing
+	 * end == start - 1: no whole block changed, so there is nothing to
+	 * track.  (ext4_fc_track_template has already reset the range set for a
+	 * new transaction.)
+	 */
+	if (__arg->end < __arg->start)
+		return 0;
 
-	if (update && ei->i_fc_lblk_len > 0) {
-		ei->i_fc_lblk_start = min(ei->i_fc_lblk_start, __arg->start);
-		ei->i_fc_lblk_len =
-			max(oldstart + ei->i_fc_lblk_len - 1, __arg->end) -
-				ei->i_fc_lblk_start + 1;
-	} else {
-		ei->i_fc_lblk_start = __arg->start;
-		ei->i_fc_lblk_len = __arg->end - __arg->start + 1;
-	}
+	ext4_fc_range_add(ei, __arg->start, __arg->end);
 
 	return 0;
 }
@@ -994,31 +1054,26 @@ static void ext4_fc_free_inode_snap(struct inode *inode)
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
+	ext4_lblk_t cur_lblk = start_lblk;
 
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
-
-	cur_lblk = start_lblk;
 	ext4_debug("snapshot data ranges %u-%u for inode %llu\n",
 		   start_lblk, end_lblk,
 		   (unsigned long long)inode->i_ino);
@@ -1050,7 +1105,7 @@ static int ext4_fc_snapshot_inode_data(struct inode *inode,
 			continue;
 		}
 
-		if (nr_ranges_total + nr_ranges >= EXT4_FC_SNAPSHOT_MAX_RANGES) {
+		if (nr_ranges_total + *nr_ranges >= EXT4_FC_SNAPSHOT_MAX_RANGES) {
 			atomic64_inc(&stats->snap_fail_ranges_cap);
 			ext4_fc_set_snap_err(snap_err,
 					     EXT4_FC_SNAP_ERR_RANGES_CAP);
@@ -1063,7 +1118,7 @@ static int ext4_fc_snapshot_inode_data(struct inode *inode,
 			ext4_fc_set_snap_err(snap_err, EXT4_FC_SNAP_ERR_NOMEM);
 			return -ENOMEM;
 		}
-		nr_ranges++;
+		(*nr_ranges)++;
 
 		range->lblk = cur_lblk;
 		range->len = len;
@@ -1101,6 +1156,48 @@ static int ext4_fc_snapshot_inode_data(struct inode *inode,
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
+	struct ext4_fc_lblk_range tracked[EXT4_FC_MAX_RANGES + 1];
+	unsigned int nr_ranges = 0, nr_tracked, t;
+	int ret;
+
+	spin_lock(&ei->i_fc_lock);
+	nr_tracked = ei->i_fc_nr_ranges;
+	if (nr_tracked == 0) {
+		spin_unlock(&ei->i_fc_lock);
+		if (nr_rangesp)
+			*nr_rangesp = 0;
+		return 0;
+	}
+	memcpy(tracked, ei->i_fc_ranges, nr_tracked * sizeof(tracked[0]));
+	ei->i_fc_nr_ranges = 0;
+	spin_unlock(&ei->i_fc_lock);
+
+	/*
+	 * Snapshot only the actually-modified ranges, not the whole [min,max]
+	 * span: this is what keeps scattered allocations from blowing past
+	 * EXT4_FC_SNAPSHOT_MAX_RANGES and falling back to a full commit.
+	 */
+	for (t = 0; t < nr_tracked; t++) {
+		ext4_lblk_t s = tracked[t].start;
+		ext4_lblk_t e = s + tracked[t].len - 1;
+
+		ret = ext4_fc_snapshot_lblk_range(inode, s, e, ranges,
+						  nr_ranges_total, &nr_ranges,
+						  snap_err);
+		if (ret)
+			return ret;
+	}
+
 	if (nr_rangesp)
 		*nr_rangesp = nr_ranges;
 	return 0;
-- 
2.43.0

