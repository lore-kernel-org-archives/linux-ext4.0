Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3DC4353EEB
	for <linux-ext4@vger.kernel.org>; Wed, 22 Jul 2026 01:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784682348; cv=none; b=rSxRym0swQQF4TtY7II4158oHaFw1ip36jwnug0sGsVs1RcbesAgPIYju698OmYDLIQZ8G8jzEj+4qTnY6xfaudgod11RSLH/nkij1WSHwajnuJ0PVn3lGOzh9Mh1IuNovoZK+2wfh2mntIBGQoCwacpzu96nV9sDnv4z7rEAuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784682348; c=relaxed/simple;
	bh=BJ+l+LwJBfFsB+Saj2vLTTziPnth+V4nL5Ex47CU55g=;
	h=Mime-Version:Subject:From:To:CC:In-Reply-To:Message-ID:Date:
	 Content-Type:References; b=ChUZe4zaPaxIXAEu9qIjhOGlnkvP2FOYqysVF+2tHurnVZ3B8NPPG8Eb9SAzDXn9+KL+Ann4BEWsc0KsKc5OfRLEOx9+2iuEshmgdKx5lfDb4ILxeTuyLvo5vSBmpD6Nj5rcO+1/+dDo6sll9azYTLUHN6sQg73GPPOzHRTPkiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=A9zGuCTJ; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="A9zGuCTJ"
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260722010031epoutp04c13be7ba93149596c04ec035640a160b~EdtoGqltD0644706447epoutp042
	for <linux-ext4@vger.kernel.org>; Wed, 22 Jul 2026 01:00:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260722010031epoutp04c13be7ba93149596c04ec035640a160b~EdtoGqltD0644706447epoutp042
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1784682031;
	bh=7mf6HXrppO2ply/pFElr57YJpYPZwRBJqt9Tg6RFQZk=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=A9zGuCTJWgDraZr++6n1lN0z4N7HHMpgE0dutRGw1OLh+xwMPNo60qyTXN6tD2rPd
	 SklGodoaTlqqyGaWnaF1FI69Re2Wywxaau5AW3W8ULPZRFV5+aquD0PG4wIoHFluqM
	 t5Y4QQXExj86Nbas1nDqBbK7/sIU7W9ZIJyoEdiM=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPS id
	20260722010030epcas2p41c877cbd588dc855cf936f7940ac1d17~Edtno7oW60062100621epcas2p4K;
	Wed, 22 Jul 2026 01:00:30 +0000 (GMT)
Received: from epcas2p1.samsung.com (unknown [182.195.38.209]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4h4bXG1bcPz3hhTJ; Wed, 22 Jul
	2026 01:00:30 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: [RFC PATCH v3 1/2] ext4: fast commit: track disjoint modified
 ranges per inode
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
In-Reply-To: <20260722005922epcms2p566d8027c8d1dbb8d9c46e3d3b35b6fd0@epcms2p5>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20260722010029epcms2p26ccbe5aa30e217a2dbec3de0f909f487@epcms2p2>
Date: Wed, 22 Jul 2026 10:00:29 +0900
X-CMS-MailID: 20260722010029epcms2p26ccbe5aa30e217a2dbec3de0f909f487
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260722005922epcms2p566d8027c8d1dbb8d9c46e3d3b35b6fd0
References: <20260722005922epcms2p566d8027c8d1dbb8d9c46e3d3b35b6fd0@epcms2p5>
	<CGME20260722005922epcms2p566d8027c8d1dbb8d9c46e3d3b35b6fd0@epcms2p2>

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
 fs/ext4/fast_commit.c | 172 +++++++++++++++++++++++++++++++++---------
 2 files changed, 163 insertions(+), 40 deletions(-)

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
index 4ef796b9b6cb..28560d776862 100644
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
@@ -622,12 +621,81 @@ struct __track_range_args {
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
+	/*
+	 * The largest valid lblk is EXT_MAX_BLOCKS - 1, so a range's "first
+	 * block after" (start + len) and a region's "end + 1" can each reach
+	 * EXT_MAX_BLOCKS.  Evaluate those adjacency bounds in 64 bits so they
+	 * cannot wrap the ext4_lblk_t (u32) type.
+	 */
+
+	/* Skip ranges lying entirely before [start - 1] (no overlap/adjacency). */
+	i = 0;
+	while (i < n && (u64)r[i].start + r[i].len < start)
+		i++;
+
+	/* Absorb every range overlapping or adjacent to the growing [start,end]. */
+	j = i;
+	while (j < n && r[j].start <= (u64)end + 1) {
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
 
@@ -636,17 +704,16 @@ static int __track_range(handle_t *handle, struct inode *inode, void *arg,
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
@@ -994,31 +1061,26 @@ static void ext4_fc_free_inode_snap(struct inode *inode)
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
@@ -1050,7 +1112,7 @@ static int ext4_fc_snapshot_inode_data(struct inode *inode,
 			continue;
 		}
 
-		if (nr_ranges_total + nr_ranges >= EXT4_FC_SNAPSHOT_MAX_RANGES) {
+		if (nr_ranges_total + *nr_ranges >= EXT4_FC_SNAPSHOT_MAX_RANGES) {
 			atomic64_inc(&stats->snap_fail_ranges_cap);
 			ext4_fc_set_snap_err(snap_err,
 					     EXT4_FC_SNAP_ERR_RANGES_CAP);
@@ -1063,7 +1125,7 @@ static int ext4_fc_snapshot_inode_data(struct inode *inode,
 			ext4_fc_set_snap_err(snap_err, EXT4_FC_SNAP_ERR_NOMEM);
 			return -ENOMEM;
 		}
-		nr_ranges++;
+		(*nr_ranges)++;
 
 		range->lblk = cur_lblk;
 		range->len = len;
@@ -1101,6 +1163,48 @@ static int ext4_fc_snapshot_inode_data(struct inode *inode,
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
