Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63F73469FC
	for <linux-ext4@vger.kernel.org>; Wed, 22 Jul 2026 01:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784682084; cv=none; b=fzOmwBrpW/kkYnHGyGDkoNXyUhAsvNGn3ZCPyrrq4/muzccHJGH2e5uJPq4yGh0SxaWD/3rjnFGQUG2IEdwEuuotG5ZeuOXOMdWxIi/b7qSuw4AXwr5SalXiFPz/55xtdaxnRTRthopkz1A0hGx7byEla1kujj9rfoERDzeXxaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784682084; c=relaxed/simple;
	bh=rJbovAXZEOH/9fW3NXndqg5nozPh23YAGKV2Gxvstds=;
	h=Mime-Version:Subject:From:To:CC:In-Reply-To:Message-ID:Date:
	 Content-Type:References; b=MWxgr9fWg97cOFI0Tq4OHFOMkiiwbh0Xjkm/kN5ZHBDc9Pmzt2YmxXtKXv73fxC92mOj+CsaM9EMDOyxEXx4pCBgQVIEU40PhlMiQugKXJxRjNRrV2MFCgh6xYyVg+coTLphOk/vRonhtawQWxh+3rI2Rzs5Qpqf6POFC1AHhiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=hC6DMD4C; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="hC6DMD4C"
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260722010118epoutp0410bc9a854798442f5bc99d171d548dab~EduUCuyaw0867508675epoutp04d
	for <linux-ext4@vger.kernel.org>; Wed, 22 Jul 2026 01:01:18 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260722010118epoutp0410bc9a854798442f5bc99d171d548dab~EduUCuyaw0867508675epoutp04d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1784682078;
	bh=pJkmZPW+L8gLbxBItzsbK/p/gI/H4BcVG9ldZO0Cm9A=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=hC6DMD4CAOD3XZY54lVYESohrf81LoHqOAn2AhSJ3qgZF/Rcndkf2PFejEF6HbxaU
	 WuczhSU4xtBPnmo2H6bHwBKeUoHbemJJUsUHaHfrowkrgP3EY1iShB9iloCfm5ld5z
	 IAAsdd2gtfXFozLxbtktLfKMtEpA6aXXsGFjW0Eo=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPS id
	20260722010117epcas2p1862f46a0e94679a22ebc880adcd3ab4a~EduThaWqr3069830698epcas2p1G;
	Wed, 22 Jul 2026 01:01:17 +0000 (GMT)
Received: from epcas2p3.samsung.com (unknown [182.195.38.208]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4h4bY931dYz6B9mL; Wed, 22 Jul
	2026 01:01:17 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: [RFC PATCH v3 2/2] ext4: fast commit: allocate the range array
 lazily
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
In-Reply-To: <20260722010029epcms2p26ccbe5aa30e217a2dbec3de0f909f487@epcms2p2>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20260722010116epcms2p78e51d428899883446ab365b57cad2edb@epcms2p7>
Date: Wed, 22 Jul 2026 10:01:16 +0900
X-CMS-MailID: 20260722010116epcms2p78e51d428899883446ab365b57cad2edb
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260722005922epcms2p566d8027c8d1dbb8d9c46e3d3b35b6fd0
References: <20260722010029epcms2p26ccbe5aa30e217a2dbec3de0f909f487@epcms2p2>
	<20260722005922epcms2p566d8027c8d1dbb8d9c46e3d3b35b6fd0@epcms2p5>
	<CGME20260722005922epcms2p566d8027c8d1dbb8d9c46e3d3b35b6fd0@epcms2p7>

Patch 1 keeps the disjoint-range set in a fixed EXT4_FC_MAX_RANGES+1
array.  Embedding that in every ext4_inode_info costs ~140 bytes on
inodes that never use fast commit or only ever touch a single
contiguous range.

Keep the first range inline in i_fc_range and allocate the array only
when a second disjoint range appears; free it when the inode is
evicted.  The tracking path runs under i_fc_lock, so the array is
allocated with GFP_ATOMIC; on allocation failure we coalesce into the
inline range -- i.e. the original single-range behaviour -- so memory
pressure never forces a full commit.  The per-inode fast-commit
footprint drops to 20 bytes.

Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
 fs/ext4/ext4.h        | 23 ++++++++++-----
 fs/ext4/fast_commit.c | 69 ++++++++++++++++++++++++++++++++++++++++---
 fs/ext4/super.c       |  1 +
 3 files changed, 82 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 8e93d30766fd..d93cc52cd01e 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1106,14 +1106,23 @@ struct ext4_inode_info {
 					 */
 
 	/*
-	 * Disjoint lblk ranges modified in this fast commit.  Tracking the
+	 * Logical block ranges modified in this fast commit.  Tracking the
 	 * actual modified ranges (instead of one coalesced [min,max]) avoids
 	 * snapshotting the whole spanned extent map for scattered allocations.
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
 
 	/*
@@ -1135,8 +1144,8 @@ struct ext4_inode_info {
 	spinlock_t i_raw_lock;	/* protects updates to the raw inode */
 
 	/*
-	 * Protect concurrent accesses on i_fc_ranges, i_fc_nr_ranges
-	 * and inode's EXT4_FC_STATE_COMMITTING state bit.
+	 * Protect concurrent accesses on i_fc_range, i_fc_ranges,
+	 * i_fc_nr_ranges and inode's EXT4_FC_STATE_COMMITTING state bit.
 	 */
 	spinlock_t i_fc_lock;
 
diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 28560d776862..3d100905d19a 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -230,6 +230,7 @@ void ext4_fc_init_inode(struct inode *inode)
 	struct ext4_inode_info *ei = EXT4_I(inode);
 
 	ext4_fc_reset_inode(inode);
+	ei->i_fc_ranges = NULL;
 	ext4_clear_inode_state(inode, EXT4_STATE_FC_COMMITTING);
 	ext4_clear_inode_state(inode, EXT4_STATE_FC_REQUEUE);
 	INIT_LIST_HEAD(&ei->i_fc_list);
@@ -698,6 +699,8 @@ static int __track_range(handle_t *handle, struct inode *inode, void *arg,
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	struct __track_range_args *__arg =
 		(struct __track_range_args *)arg;
+	ext4_lblk_t start = __arg->start, end = __arg->end;
+	ext4_lblk_t s0, e0;
 
 	if (inode->i_ino < EXT4_FIRST_INO(inode->i_sb)) {
 		ext4_debug("Special inode %llu being modified\n", inode->i_ino);
@@ -708,12 +711,66 @@ static int __track_range(handle_t *handle, struct inode *inode, void *arg,
 	 * A sub-block punch hole rounds up the start and down the end, passing
 	 * end == start - 1: no whole block changed, so there is nothing to
 	 * track.  (ext4_fc_track_template has already reset the range set for a
-	 * new transaction.)
+	 * new transaction, so we need not do it here.)
 	 */
-	if (__arg->end < __arg->start)
+	if (end < start)
 		return 0;
 
-	ext4_fc_range_add(ei, __arg->start, __arg->end);
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
+
+	/*
+	 * Disjoint from it: try to upgrade to the array for exact tracking.
+	 * Evaluate the adjacency bounds in 64 bits: the largest valid lblk is
+	 * EXT_MAX_BLOCKS - 1, so e0 + 1 and end + 1 can reach EXT_MAX_BLOCKS and
+	 * must not wrap the ext4_lblk_t (u32) type.
+	 */
+	if (start > (u64)e0 + 1 || (u64)end + 1 < s0) {
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
@@ -1185,7 +1242,11 @@ static int ext4_fc_snapshot_inode_data(struct inode *inode,
 			*nr_rangesp = 0;
 		return 0;
 	}
-	memcpy(tracked, ei->i_fc_ranges, nr_tracked * sizeof(tracked[0]));
+	if (ei->i_fc_ranges)
+		memcpy(tracked, ei->i_fc_ranges,
+		       nr_tracked * sizeof(tracked[0]));
+	else
+		tracked[0] = ei->i_fc_range;	/* inline single-range mode */
 	ei->i_fc_nr_ranges = 0;
 	spin_unlock(&ei->i_fc_lock);
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index f2c52cc74676..cfa7e6bec385 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1455,6 +1455,7 @@ static void ext4_free_in_core_inode(struct inode *inode)
 		pr_warn("%s: inode %llu still in fc list",
 			__func__, inode->i_ino);
 	}
+	kfree(EXT4_I(inode)->i_fc_ranges);
 	kmem_cache_free(ext4_inode_cachep, EXT4_I(inode));
 }
 
-- 
2.43.0
