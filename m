Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B463134252C
	for <linux-ext4@vger.kernel.org>; Tue, 23 Jun 2026 08:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782203199; cv=none; b=RJsHmQD9yGDaItMTo6gz9bmL4YH/Is0Ti0bQi7KV4eNTBVk703xEopVkgv9tPa+WYH/rxrB/4Ju1nPYdq+y94OIHmvrJeHYrWRz/xLPwFXiMHB2demGHdrG9Yni7XsFwTunRZkabLpmlckaKBVWlEY1JNlGHPYSbPveSuzL/Cg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782203199; c=relaxed/simple;
	bh=gl37I9MV8OgwS4AuXJ19Z29jtE1ZAtcPfM8KALnAGGI=;
	h=Mime-Version:Subject:From:To:CC:In-Reply-To:Message-ID:Date:
	 Content-Type:References; b=WEjP08dSJFwC5mSEmXtNseGzi12pEmXXNyB2LIjMpXZHws3fhoMm6OYrpXONf3k1hNJ8eF7lQ3JoObVq06gnl9SyYchkxw30xNrWbbDqHLNIDlgWtodyRSKg6uQfGNK9oSLWigPUC4Yp15rzls0Pa9nTE9K+JZJHZfSe2yAYgmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=dwJkucfh; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="dwJkucfh"
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20260623082635epoutp039a03017d31e03b22fa53e953fb7a1162~7qF0xcpuj3108631086epoutp03h
	for <linux-ext4@vger.kernel.org>; Tue, 23 Jun 2026 08:26:35 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20260623082635epoutp039a03017d31e03b22fa53e953fb7a1162~7qF0xcpuj3108631086epoutp03h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1782203195;
	bh=dNLKg9i9FWPOSjxUTbIwh0GuePr2ucpKltfa1NGEUqk=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=dwJkucfhxZroy3KwBD5JwFARlue5ndZ/2ZL5IlqjXK+g5iW7Mz3bJ3gBaQ6mox61q
	 CNW1dBl84xutPQK4K+koKErQllFGZQ1Jz7cdX+zDgXzB42XRomz0aauoyqZC4mrNAl
	 S56+mXImMmueSx0J2WJz7vPOg9eAGC1DMWqmIJF4=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPS id
	20260623082634epcas2p3c84dcd5c9400aabf350731b41054cead~7qFzqrdA33221332213epcas2p3o;
	Tue, 23 Jun 2026 08:26:34 +0000 (GMT)
Received: from epcas2p4.samsung.com (unknown [182.195.38.203]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4gkypL1rYZz3hhTQ; Tue, 23 Jun
	2026 08:26:34 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: [RFC PATCH v2 2/2] ext4: fast commit: allocate the range array
 lazily
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
In-Reply-To: <20260623082506epcms2p81c2f8abfee34b88e5a645fbfaaf4bf9e@epcms2p8>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20260623082633epcms2p8e656ede170e58142fff08d78a9fc6f2f@epcms2p8>
Date: Tue, 23 Jun 2026 17:26:33 +0900
X-CMS-MailID: 20260623082633epcms2p8e656ede170e58142fff08d78a9fc6f2f
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260623082331epcms2p4798e9d26b06f9a005bcca7b2edf395d3
References: <20260623082506epcms2p81c2f8abfee34b88e5a645fbfaaf4bf9e@epcms2p8>
	<20260623082331epcms2p4798e9d26b06f9a005bcca7b2edf395d3@epcms2p4>
	<CGME20260623082331epcms2p4798e9d26b06f9a005bcca7b2edf395d3@epcms2p8>

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
 fs/ext4/ext4.h        | 23 +++++++++++-----
 fs/ext4/fast_commit.c | 64 ++++++++++++++++++++++++++++++++++++++++---
 fs/ext4/super.c       |  1 +
 3 files changed, 77 insertions(+), 11 deletions(-)

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
index 1ea3742a55b1..9d36365eae02 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -230,6 +230,7 @@ void ext4_fc_init_inode(struct inode *inode)
 	struct ext4_inode_info *ei = EXT4_I(inode);
 
 	ext4_fc_reset_inode(inode);
+	ei->i_fc_ranges = NULL;
 	ext4_clear_inode_state(inode, EXT4_STATE_FC_COMMITTING);
 	ext4_clear_inode_state(inode, EXT4_STATE_FC_REQUEUE);
 	INIT_LIST_HEAD(&ei->i_fc_list);
@@ -691,6 +692,8 @@ static int __track_range(handle_t *handle, struct inode *inode, void *arg,
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	struct __track_range_args *__arg =
 		(struct __track_range_args *)arg;
+	ext4_lblk_t start = __arg->start, end = __arg->end;
+	ext4_lblk_t s0, e0;
 
 	if (inode->i_ino < EXT4_FIRST_INO(inode->i_sb)) {
 		ext4_debug("Special inode %llu being modified\n", inode->i_ino);
@@ -701,12 +704,61 @@ static int __track_range(handle_t *handle, struct inode *inode, void *arg,
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
@@ -1178,7 +1230,11 @@ static int ext4_fc_snapshot_inode_data(struct inode *inode,
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

