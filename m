Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6EE91A9F90
	for <linux-ext4@vger.kernel.org>; Thu, 11 Jun 2026 04:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781153363; cv=none; b=E7/93hve5y9s4wNTl5+6rZc7Vrk4DqAa3TMRF3tnebJgJrToHscowXMFNul3WPLD5OElcpbNLg9NvmjowWa07+0K02qoql5UgAWIf1NNENfeO8WsySw8ZrOd/neahTAktJejloE2yE5MyImYORute+grYT5NHvbF4otVI4O21v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781153363; c=relaxed/simple;
	bh=x9cGjq6i2jdgL+snZKLDyhe6bGuM4bnkBJJu8mdkZ9s=;
	h=Mime-Version:Subject:From:To:CC:In-Reply-To:Message-ID:Date:
	 Content-Type:References; b=D+JWm/3vqiCnb0ny9i4zfRR4Q/h7uXs3kYRZpL5bSwQqvHyQ8MmYIRxGr0b6bt1yhovilwozgW+yTZMRjNz9FcyExpPukWslJ7A9vHO6YmGB0Wf5NoHkPvwkB3ttxcthiWasxjpYBFfqsjmggwHRll1LzimYxIzZye5p+05ECI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=rIQMtA3d; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="rIQMtA3d"
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20260611044919epoutp037ba82179a98d546ced55c7050c7b2ada~37YtBJ1kJ2347523475epoutp03Y
	for <linux-ext4@vger.kernel.org>; Thu, 11 Jun 2026 04:49:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20260611044919epoutp037ba82179a98d546ced55c7050c7b2ada~37YtBJ1kJ2347523475epoutp03Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1781153360;
	bh=f+6XRYt5FWPKUPiAEVrLg3cZquY4CvJDfcoCMuJaBOw=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=rIQMtA3dxu8SqGX30zl3LST2njVuhb7rl7F7LQ0jw5eHRRvI0xqugm2fUYdt520wV
	 BQQhHyvGJR3/88MxjzwqcHmr2d71+XqQbESuA7UWT+hXIwn1CQ1PGboT+RzMLbY1vX
	 gamOIGVH4J74r5lqX/cDs5amAdbZx75YRA/HyCyE=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPS id
	20260611044919epcas2p4c6d0783809498559b472f79808c4b2a0~37Ysxz3DD3176331763epcas2p4R;
	Thu, 11 Jun 2026 04:49:19 +0000 (GMT)
Received: from epcas2p4.samsung.com (unknown [182.195.38.206]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4gbVYC2g4Dz6B9m4; Thu, 11 Jun
	2026 04:49:19 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: [PATCH 2/2] ext4: allocate the fast-commit range array lazily
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
In-Reply-To: <20260611044817epcms2p3b5a66f4cdb41d0cbaaa7c257cccfc8a1@epcms2p3>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20260611044918epcms2p31f1b10041d3efe6a4043c18fbe237fa0@epcms2p3>
Date: Thu, 11 Jun 2026 13:49:18 +0900
X-CMS-MailID: 20260611044918epcms2p31f1b10041d3efe6a4043c18fbe237fa0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260611044733epcms2p38013ae683a283555526f70e4eab6d2a9
References: <20260611044817epcms2p3b5a66f4cdb41d0cbaaa7c257cccfc8a1@epcms2p3>
	<20260611044733epcms2p38013ae683a283555526f70e4eab6d2a9@epcms2p3>
	<CGME20260611044733epcms2p38013ae683a283555526f70e4eab6d2a9@epcms2p3>

The multi-interval tracker added a fixed array of EXT4_FC_MAX_RANGES + 1
entries to every ext4_inode_info -- ~136 bytes that is wasted on inodes
that never use fast commit (read-only files, directories, ...).

Shrink it to the common case:

 - Keep the first range inline in i_fc_range, so a single contiguous
   dirty region (the common case) needs no allocation at all.

 - Allocate the i_fc_ranges array only when a second disjoint range
   appears, and free it when the inode is evicted.

 - The tracking path runs under i_fc_lock and so cannot sleep, so the
   array is allocated with GFP_ATOMIC.  On failure, fall back to
   coalescing the new range into the inline i_fc_range -- exactly the
   original single coalesced-range behaviour -- so no full-commit
   fallback or fast-commit ineligibility is needed.

The per-inode fast-commit footprint drops from ~140 bytes (the embedded
array) to 20 bytes (inline range + array pointer + count); the array is
allocated only while two or more disjoint ranges are tracked.

No on-disk format change.  Crash recovery (online replay + offline
e2fsck) and the fast-commit xfstests are unaffected.

While rewriting __track_range, also skip degenerate ranges (a sub-block
punch hole rounds the start up past the end, passing end == start - 1, so
no whole block changed) instead of storing an empty range, and drop the
redundant per-transaction reset here -- ext4_fc_track_template() already
resets the range set under i_fc_lock before calling the tracker.

Signed-off-by: Daejun Park <pdaejun@gmail.com>
---
 fs/ext4/ext4.h        | 19 ++++++++----
 fs/ext4/fast_commit.c | 70 +++++++++++++++++++++++++++++++++++++++----
 fs/ext4/super.c       |  1 +
 3 files changed, 80 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 314a1c90075b..6c6ac19e86b6 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1081,14 +1081,23 @@ struct ext4_inode_info {
 					 */
 
 	/*
-	 * Disjoint lblk ranges modified in this fast commit.  Tracking the
+	 * Logical block ranges modified in this fast commit.  Tracking the
 	 * actual modified ranges (instead of one coalesced [min,max]) avoids
 	 * re-logging the whole spanned extent map for scattered allocations.
-	 * Sorted by start, mutually disjoint.  Bounded by EXT4_FC_MAX_RANGES;
-	 * the extra slot is transient room used while inserting before an
-	 * overflow merge.  Protected by i_fc_lock.
+	 *
+	 * The first range is kept inline in i_fc_range, so the common case of a
+	 * single contiguous dirty region needs no allocation.  When a second
+	 * disjoint range appears the inode is upgraded to the i_fc_ranges array
+	 * (EXT4_FC_MAX_RANGES + 1 entries, sorted and mutually disjoint; the
+	 * extra slot is transient room used while inserting before an overflow
+	 * merge), allocated then and freed when the inode is evicted.  If that
+	 * allocation fails we fall back to coalescing into i_fc_range, i.e. the
+	 * original single coalesced-range behaviour.  i_fc_nr_ranges counts the
+	 * valid ranges; while i_fc_ranges is NULL it is 0 or 1.  Protected by
+	 * i_fc_lock.
 	 */
-	struct ext4_fc_lblk_range i_fc_ranges[EXT4_FC_MAX_RANGES + 1];
+	struct ext4_fc_lblk_range i_fc_range;
+	struct ext4_fc_lblk_range *i_fc_ranges;
 	unsigned int i_fc_nr_ranges;
 
 	spinlock_t i_raw_lock;	/* protects updates to the raw inode */
diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index ab9ab50ad0b5..786b79a9c573 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -211,6 +211,7 @@ void ext4_fc_init_inode(struct inode *inode)
 	struct ext4_inode_info *ei = EXT4_I(inode);
 
 	ext4_fc_reset_inode(inode);
+	ei->i_fc_ranges = NULL;
 	ext4_clear_inode_state(inode, EXT4_STATE_FC_COMMITTING);
 	INIT_LIST_HEAD(&ei->i_fc_list);
 	INIT_LIST_HEAD(&ei->i_fc_dilist);
@@ -671,17 +672,73 @@ static int __track_range(handle_t *handle, struct inode *inode, void *arg,
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	struct __track_range_args *__arg =
 		(struct __track_range_args *)arg;
+	ext4_lblk_t start = __arg->start, end = __arg->end;
+	ext4_lblk_t s0, e0;
 
 	if (inode->i_ino < EXT4_FIRST_INO(inode->i_sb)) {
 		ext4_debug("Special inode %ld being modified\n", inode->i_ino);
 		return -ECANCELED;
 	}
 
-	/* A new transaction (update == false) starts a fresh range set. */
-	if (!update)
-		ei->i_fc_nr_ranges = 0;
+	/*
+	 * A sub-block punch hole rounds up the start and down the end, passing
+	 * end == start - 1: no whole block changed, so there is nothing to
+	 * track.  (ext4_fc_track_template has already reset the range set for a
+	 * new transaction, so we need not do it here.)
+	 */
+	if (end < start)
+		return 0;
+
+	/* Already upgraded to the heap array: full multi-interval tracking. */
+	if (ei->i_fc_ranges) {
+		ext4_fc_range_add(ei, start, end);
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
 
-	ext4_fc_range_add(ei, __arg->start, __arg->end);
+	/* Disjoint from it: try to upgrade to the array for exact tracking. */
+	if (start > e0 + 1 || end + 1 < s0) {
+		struct ext4_fc_lblk_range *heap;
+
+		/*
+		 * GFP_ATOMIC: we hold i_fc_lock.  __GFP_NOWARN: failure is not
+		 * fatal -- we fall back to the single coalesced range below --
+		 * so it must not splat under memory pressure.
+		 */
+		heap = kmalloc_array(EXT4_FC_MAX_RANGES + 1, sizeof(*heap),
+				     GFP_ATOMIC | __GFP_NOWARN);
+		if (heap) {
+			heap[0] = ei->i_fc_range;
+			ei->i_fc_ranges = heap;
+			ext4_fc_range_add(ei, start, end);
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
+	/* Overlapping/adjacent, or array allocation failed: coalesce inline. */
+	if (start < s0)
+		s0 = start;
+	if (end > e0)
+		e0 = end;
+	ei->i_fc_range.start = s0;
+	ei->i_fc_range.len = e0 - s0 + 1;
 
 	return 0;
 }
@@ -1016,7 +1073,10 @@ static int ext4_fc_write_inode_data(struct inode *inode, u32 *crc)
 		spin_unlock(&ei->i_fc_lock);
 		return 0;
 	}
-	memcpy(ranges, ei->i_fc_ranges, nr * sizeof(ranges[0]));
+	if (ei->i_fc_ranges)
+		memcpy(ranges, ei->i_fc_ranges, nr * sizeof(ranges[0]));
+	else
+		ranges[0] = ei->i_fc_range;	/* inline single-range mode */
 	ei->i_fc_nr_ranges = 0;
 	spin_unlock(&ei->i_fc_lock);
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 699c15db28a8..93d495cad0ba 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1433,6 +1433,7 @@ static void ext4_free_in_core_inode(struct inode *inode)
 		pr_warn("%s: inode %ld still in fc list",
 			__func__, inode->i_ino);
 	}
+	kfree(EXT4_I(inode)->i_fc_ranges);
 	kmem_cache_free(ext4_inode_cachep, EXT4_I(inode));
 }
 
-- 
2.43.0

