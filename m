Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A958E34104E
	for <linux-ext4@vger.kernel.org>; Thu, 11 Jun 2026 04:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781153309; cv=none; b=lRiimAV70nt7SjGsx0KZCHf38j48bt3Pb1JDqDOSA+W0o0/HP+YRzpl1CMJKonCRi8PEo06YXJRFKwztqM1YDuF6rf97KEOj3Na3QpTFSEVATPp+FU9hzOH7+IuiVZlnZSEZ5HS9ZdXmQPN8KsZRX2PQKKqvmnsS7cJ/f7PhfU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781153309; c=relaxed/simple;
	bh=hMmSssxyo/0zg0fEsZ/ZVC3htN4m7uYYqtKZCczJas8=;
	h=Mime-Version:Subject:From:To:CC:In-Reply-To:Message-ID:Date:
	 Content-Type:References; b=AcmQQU5vo1iP1C55JOhQ4BBCV59cMN2GZ/xs8rjooJhqo5nu0pBzJl1hrKmMR/KhlwHVyDj7stYoDwn3N8eScHHPZ03qzB/dU4KhjiRDbb5NKDHBYvrICvoP9woePd1+rDRxo82FBhLF/Q9pYsOWRLSn7XPJfkTgYwX9rB7vUVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=bFk1g9+T; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="bFk1g9+T"
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260611044819epoutp013e8b70e2db4c77bd0adf7b184e720974~37X0TqQay2956229562epoutp01P
	for <linux-ext4@vger.kernel.org>; Thu, 11 Jun 2026 04:48:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260611044819epoutp013e8b70e2db4c77bd0adf7b184e720974~37X0TqQay2956229562epoutp01P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1781153299;
	bh=jiFKEQnkuNoDwQ8RYSPJkKLE7G5ADuJIoBsK6O+w5oM=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=bFk1g9+Tf1hkXKyoG2936nKSL624X0tYXXA09oOOsLu38rz6LUQBiqXsJYZa9ObHQ
	 RGeVK2AG+atQwxP/J7Lf9vogx5uP+QRMxvA5BDqPoRSNTF9HTA6jMdAXrgAEZxkSNT
	 RYgoCdW25Thyq5nSlWIHHjn90249+1g3a/hESArw=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPS id
	20260611044818epcas2p4def38e2e688e9b0452d44c44b63874de~37Xz8Kg601557215572epcas2p4A;
	Thu, 11 Jun 2026 04:48:18 +0000 (GMT)
Received: from epcas2p1.samsung.com (unknown [182.195.38.208]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4gbVX22vB9z6B9mF; Thu, 11 Jun
	2026 04:48:18 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: [PATCH 1/2] ext4: track multiple disjoint fast-commit ranges per
 inode
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From: Daejun Park <daejun7.park@samsung.com>
To: "tytso@mit.edu" <tytso@mit.edu>, "adilger.kernel@dilger.ca"
	<adilger.kernel@dilger.ca>
CC: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Daejun Park
	<daejun7.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20260611044733epcms2p38013ae683a283555526f70e4eab6d2a9@epcms2p3>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20260611044817epcms2p3b5a66f4cdb41d0cbaaa7c257cccfc8a1@epcms2p3>
Date: Thu, 11 Jun 2026 13:48:17 +0900
X-CMS-MailID: 20260611044817epcms2p3b5a66f4cdb41d0cbaaa7c257cccfc8a1
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260611044733epcms2p38013ae683a283555526f70e4eab6d2a9
References: <20260611044733epcms2p38013ae683a283555526f70e4eab6d2a9@epcms2p3>
	<CGME20260611044733epcms2p38013ae683a283555526f70e4eab6d2a9@epcms2p3>

Fast commit tracks a single coalesced logical range per inode
(i_fc_lblk_start .. i_fc_lblk_len).  When an inode is modified at several
disjoint offsets between two commits (e.g. sparse random writes), the
range is widened to span [min, max] of all touched offsets, and at commit
time ext4_fc_write_inode_data() re-logs every extent inside that span,
including the unmodified ones.  On sparse allocation this inflates
fast-commit traffic and often overflows the fast-commit area, forcing a
fallback to a full jbd2 commit.

Replace the single range with a bounded array of up to EXT4_FC_MAX_RANGES
(16) disjoint ranges.  __track_range inserts and merges into it; on
overflow the two ranges separated by the smallest gap are coalesced, so
it degrades to the old single-span behaviour in the worst case.
ext4_fc_write_inode_data() now walks only the tracked ranges.  The
on-disk fast-commit (TLV) format is unchanged.

The number of disjoint dirty regions an inode accumulates per fsync --
how scattered the writes are -- controls how badly the single-span
tracking over-logs.  On a sparse random-write workload (1 GiB span, 300
fsyncs, NVMe):

                           16 regions    64 regions
  fast-commit blocks/cmt   19.1 -> 1.0   76.3 -> 31.6
  mean fsync latency (us)  2537 -> 2280  3398 -> 2937
  p99  fsync latency (us)  3698 -> 2545  4492 -> 4291

With 16 dirty regions per fsync everything fits within the 16-range cap
and each region is tracked exactly; 64 regions exceeds the cap and
exercises the overflow-merge path, which still roughly halves the logged
blocks.  On a small filesystem whose fast-commit area is easily exhausted,
the reduced traffic also cuts the full-commit fallback rate (e.g. 22% ->
2% at 16 regions on an 8 GiB fs).

Crash recovery (online replay + offline e2fsck) and the ext4/generic
fast-commit xfstests show no regression; the unchanged on-disk format
means e2fsprogs needs no update.

Signed-off-by: Daejun Park <pdaejun@gmail.com>
---
 fs/ext4/ext4.h        |  31 ++++++++--
 fs/ext4/fast_commit.c | 138 ++++++++++++++++++++++++++++++++----------
 2 files changed, 130 insertions(+), 39 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 01a6e2de7fc3..314a1c90075b 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1017,6 +1017,20 @@ enum {
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
@@ -1066,11 +1080,16 @@ struct ext4_inode_info {
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
+	 * re-logging the whole spanned extent map for scattered allocations.
+	 * Sorted by start, mutually disjoint.  Bounded by EXT4_FC_MAX_RANGES;
+	 * the extra slot is transient room used while inserting before an
+	 * overflow merge.  Protected by i_fc_lock.
+	 */
+	struct ext4_fc_lblk_range i_fc_ranges[EXT4_FC_MAX_RANGES + 1];
+	unsigned int i_fc_nr_ranges;
 
 	spinlock_t i_raw_lock;	/* protects updates to the raw inode */
 
@@ -1078,7 +1097,7 @@ struct ext4_inode_info {
 	wait_queue_head_t i_fc_wait;
 
 	/*
-	 * Protect concurrent accesses on i_fc_lblk_start, i_fc_lblk_len
+	 * Protect concurrent accesses on i_fc_ranges, i_fc_nr_ranges
 	 * and inode's EXT4_FC_STATE_COMMITTING state bit.
 	 */
 	spinlock_t i_fc_lock;
diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 42bee1d4f9f9..ab9ab50ad0b5 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -203,8 +203,7 @@ static inline void ext4_fc_reset_inode(struct inode *inode)
 {
 	struct ext4_inode_info *ei = EXT4_I(inode);
 
-	ei->i_fc_lblk_start = 0;
-	ei->i_fc_lblk_len = 0;
+	ei->i_fc_nr_ranges = 0;
 }
 
 void ext4_fc_init_inode(struct inode *inode)
@@ -540,7 +539,7 @@ static int __track_inode(handle_t *handle, struct inode *inode, void *arg,
 	if (update)
 		return -EEXIST;
 
-	EXT4_I(inode)->i_fc_lblk_len = 0;
+	EXT4_I(inode)->i_fc_nr_ranges = 0;
 
 	return 0;
 }
@@ -603,12 +602,73 @@ struct __track_range_args {
 	ext4_lblk_t start, end;
 };
 
+/*
+ * Record that logical block range [start, end] was modified in the current
+ * fast commit.  Maintains a small, bounded set of sorted, mutually disjoint
+ * ranges, merging the new range with any it overlaps or is adjacent to.  When
+ * the set would exceed EXT4_FC_MAX_RANGES, the consecutive pair separated by
+ * the smallest gap is merged (absorbing that gap), so the worst case degrades
+ * gracefully to the old single coalesced-range behaviour.  Tracking the actual
+ * modified ranges (rather than one [min,max] span) keeps ext4_fc_write_inode_data
+ * from re-logging the whole spanned extent map on scattered allocations.
+ * Caller holds ei->i_fc_lock.
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
 
@@ -617,17 +677,11 @@ static int __track_range(handle_t *handle, struct inode *inode, void *arg,
 		return -ECANCELED;
 	}
 
-	oldstart = ei->i_fc_lblk_start;
+	/* A new transaction (update == false) starts a fresh range set. */
+	if (!update)
+		ei->i_fc_nr_ranges = 0;
 
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
@@ -890,33 +944,20 @@ static int ext4_fc_write_inode(struct inode *inode, u32 *crc)
  * Writes updated data ranges for the inode in question. Updates CRC.
  * Returns 0 on success, error otherwise.
  */
-static int ext4_fc_write_inode_data(struct inode *inode, u32 *crc)
+/* Write the fast commit TLVs for one modified lblk range [start, end]. */
+static int ext4_fc_write_lblk_range(struct inode *inode, ext4_lblk_t start,
+				    ext4_lblk_t end, u32 *crc)
 {
-	ext4_lblk_t old_blk_size, cur_lblk_off, new_blk_size;
-	struct ext4_inode_info *ei = EXT4_I(inode);
+	ext4_lblk_t cur_lblk_off = start;
 	struct ext4_map_blocks map;
 	struct ext4_fc_add_range fc_ext;
 	struct ext4_fc_del_range lrange;
 	struct ext4_extent *ex;
 	int ret;
 
-	spin_lock(&ei->i_fc_lock);
-	if (ei->i_fc_lblk_len == 0) {
-		spin_unlock(&ei->i_fc_lock);
-		return 0;
-	}
-	old_blk_size = ei->i_fc_lblk_start;
-	new_blk_size = ei->i_fc_lblk_start + ei->i_fc_lblk_len - 1;
-	ei->i_fc_lblk_len = 0;
-	spin_unlock(&ei->i_fc_lock);
-
-	cur_lblk_off = old_blk_size;
-	ext4_debug("will try writing %d to %d for inode %ld\n",
-		   cur_lblk_off, new_blk_size, inode->i_ino);
-
-	while (cur_lblk_off <= new_blk_size) {
+	while (cur_lblk_off <= end) {
 		map.m_lblk = cur_lblk_off;
-		map.m_len = new_blk_size - cur_lblk_off + 1;
+		map.m_len = end - cur_lblk_off + 1;
 		ret = ext4_map_blocks(NULL, inode, &map,
 				      EXT4_GET_BLOCKS_IO_SUBMIT |
 				      EXT4_EX_NOCACHE);
@@ -962,6 +1003,37 @@ static int ext4_fc_write_inode_data(struct inode *inode, u32 *crc)
 	return 0;
 }
 
+static int ext4_fc_write_inode_data(struct inode *inode, u32 *crc)
+{
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	struct ext4_fc_lblk_range ranges[EXT4_FC_MAX_RANGES + 1];
+	unsigned int nr, i;
+	int ret;
+
+	spin_lock(&ei->i_fc_lock);
+	nr = ei->i_fc_nr_ranges;
+	if (nr == 0) {
+		spin_unlock(&ei->i_fc_lock);
+		return 0;
+	}
+	memcpy(ranges, ei->i_fc_ranges, nr * sizeof(ranges[0]));
+	ei->i_fc_nr_ranges = 0;
+	spin_unlock(&ei->i_fc_lock);
+
+	for (i = 0; i < nr; i++) {
+		ext4_lblk_t start = ranges[i].start;
+		ext4_lblk_t end = ranges[i].start + ranges[i].len - 1;
+
+		ext4_debug("will try writing %u to %u for inode %ld\n",
+			   start, end, inode->i_ino);
+		ret = ext4_fc_write_lblk_range(inode, start, end, crc);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 
 /* Flushes data of all the inodes in the commit queue. */
 static int ext4_fc_flush_data(journal_t *journal)
-- 
2.43.0

