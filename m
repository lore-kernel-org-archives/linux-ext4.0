Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 423B82AEE4
	for <linux-ext4@vger.kernel.org>; Thu, 30 Jul 2026 00:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785371996; cv=none; b=B/eNdrhL5b+MMnWx3JbqN4OBQI9Kk/YXppitAKhO2a/WJ6JW32tveNir0sZQXx2r/0Qjw6Wo6rw5vQ/+yl1cQixUHBlmUUdDJ0+L0YSac/LdH8umek9P/F+JJoCeAuI9MNk62fAsPEK7fTgqE8eik1Pf5mwrlULR5uSNDmwXd3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785371996; c=relaxed/simple;
	bh=e7I2mK2L8GT065O0fYEQB/AWD/PnVCYfJquQZ8On8lo=;
	h=Mime-Version:Subject:From:To:CC:In-Reply-To:Message-ID:Date:
	 Content-Type:References; b=USYn05R5YIkXwERmehiB0ntgx6Bj30antbu2EdxcGswTFFHtJ8HpNCD3wCjCozkdObdmgbNCKpYUlJEcoT4OCnwHG6SVPROuXIan93XOWTIxFtmU7xcC3i3QmHuw0ohZi6qRc9Dax1Gd3u4zmfevG48QCwaOzpOWvqTeUuVX7X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=bporfOIy; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="bporfOIy"
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260730003952epoutp0230d57de2f1b7aa13927ae9ff32cb7bc8~G6l4lBvTx3111831118epoutp02_
	for <linux-ext4@vger.kernel.org>; Thu, 30 Jul 2026 00:39:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260730003952epoutp0230d57de2f1b7aa13927ae9ff32cb7bc8~G6l4lBvTx3111831118epoutp02_
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1785371992;
	bh=Ym8RB+jN64TJOMmEJvJCP6dgzxaSKdFiYljBjwEqjRQ=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=bporfOIyCW0JnJMbdz4a+sivYhzbRM3FN6n4HZ6wMbhm8abi2jdFxh+iVtBB5t5L+
	 wXdF4R/AGs++YskxxTcEyuHBwMLsZ5crfkv/mNlm5sHJDeb0a39vpH8yhUq5jGnwTO
	 /cSCY4syTIygyhmwGUF2V5NmkERtOQS+wb+rUZ8w=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPS id
	20260730003951epcas2p1eda0875ea2d2d455d1bd6cf5cbecf1a1~G6l3tOVEj2100121001epcas2p1F;
	Thu, 30 Jul 2026 00:39:51 +0000 (GMT)
Received: from epcas2p1.samsung.com (unknown [182.195.38.202]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4h9Vhl0lskz6B9mV; Thu, 30 Jul
	2026 00:39:51 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: [RFC PATCH v4 3/3] ext4: fast commit: bound the tracked range count
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
In-Reply-To: <20260730003859epcms2p76b1895649892f9f75f822ee08578b46b@epcms2p7>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20260730003950epcms2p58a5107982defcfbc0b2b58c2f003141c@epcms2p5>
Date: Thu, 30 Jul 2026 09:39:50 +0900
X-CMS-MailID: 20260730003950epcms2p58a5107982defcfbc0b2b58c2f003141c
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260730003715epcms2p54b7e3cc3409076cc9ee751f60951e167
References: <20260730003859epcms2p76b1895649892f9f75f822ee08578b46b@epcms2p7>
	<20260730003810epcms2p6cd37c6242602c1467b7665cdcc785ea8@epcms2p6>
	<20260730003715epcms2p54b7e3cc3409076cc9ee751f60951e167@epcms2p5>
	<CGME20260730003715epcms2p54b7e3cc3409076cc9ee751f60951e167@epcms2p5>

The rbtree grows dynamically, so a pathologically scattered inode could
accumulate an unbounded number of disjoint ranges between commits -- the
fixed-size array this replaced was inherently bounded, so this is a
regression to close.

Cap the tracked ranges at EXT4_FC_SNAPSHOT_MAX_RANGES (2048) -- the limit
the snapshot already enforces on emitted ranges -- and at the cap fall
back to a full commit (mark the transaction ineligible) instead of
growing the tree further.  A GFP_ATOMIC node allocation failure is handled
the same way, so no modification is silently dropped.

Reusing the snapshot's own limit is deliberate, not an arbitrary bound.
The commit snapshots each disjoint tracked range as at least one
ADD_RANGE, so the emitted-tag count is >= the tracked-range count.  A
tracked set larger than EXT4_FC_SNAPSHOT_MAX_RANGES can never fit under
the snapshot cap and would fall back regardless, so that count is exactly
the point past which tracking cannot produce a fast commit.  Falling back
there is the same outcome the snapshot would reach, without growing memory
past the point where a fast commit is already impossible; it also answers
"how many ranges before tracking loses to the fallback" precisely.  This
is why the cap falls back rather than collapsing the tree to a single
[min,max] span and continuing: that span snapshots to at least as many
tags and falls back too, so a collapse only adds a wasted snapshot before
the same result.  The bound is reported as NOMEM: it is a deliberate limit
on how much range state we keep per inode.

ext4_fc_mark_ineligible() takes the s_fc_lock mutex, so both fallback
sites drop and retake the i_fc_lock spinlock around it (the lock order is
s_fc_lock before i_fc_lock), as __track_dentry_update() already does.

Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
 fs/ext4/fast_commit.c | 43 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 32 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 1a72d7f31135..752e579066b5 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -681,11 +681,8 @@ static void ext4_fc_rt_link(struct rb_root *root, struct ext4_fc_rnode *new,
  * [start,end] into one merged node, so the set stays sorted and disjoint with
  * no fixed bound.  Adjacency bounds are evaluated in 64 bits: the largest valid
  * lblk is EXT_MAX_BLOCKS - 1, so "end + 1" and a node's "lblk + len" can reach
- * EXT_MAX_BLOCKS and must not wrap ext4_lblk_t (u32).  Caller holds i_fc_lock.
- *
- * On -ENOMEM (GFP_ATOMIC under i_fc_lock) the new range cannot be recorded, so
- * the transaction falls back to a full commit, which logs everything -- no
- * modification is lost.  Rare under memory pressure.
+ * EXT_MAX_BLOCKS and must not wrap ext4_lblk_t (u32).  Caller holds i_fc_lock
+ * and the tree is live.
  */
 static void ext4_fc_range_add(handle_t *handle, struct inode *inode,
 			      ext4_lblk_t start, ext4_lblk_t end)
@@ -696,6 +693,34 @@ static void ext4_fc_range_add(handle_t *handle, struct inode *inode,
 	struct rb_node *node;
 	unsigned int merged = 0;
 
+	/*
+	 * Cap the tracked ranges at EXT4_FC_SNAPSHOT_MAX_RANGES -- the same limit
+	 * the snapshot enforces on emitted ranges.  The rbtree is dynamic, so
+	 * without a cap a pathologically scattered inode could grow it without
+	 * bound (the fixed array this replaced could not).
+	 *
+	 * That is the right limit to reuse: the commit snapshots each disjoint
+	 * tracked range as at least one ADD_RANGE, so a tracked set larger than
+	 * EXT4_FC_SNAPSHOT_MAX_RANGES can never fit under the snapshot cap and would
+	 * fall back regardless.  So at the cap we fall back to a full commit now,
+	 * the same outcome the snapshot would reach, instead of growing memory past
+	 * the point where a fast commit is already impossible.  (This is also why
+	 * we do not collapse the tree to a single [min,max] span and keep going:
+	 * that span snapshots to at least as many tags and falls back too.)
+	 * Reported as NOMEM: a deliberate limit on per-inode range state.
+	 *
+	 * ext4_fc_mark_ineligible() takes the s_fc_lock mutex, which must not be
+	 * acquired under the i_fc_lock spinlock the caller holds (and the lock
+	 * order is s_fc_lock before i_fc_lock); drop and retake i_fc_lock around
+	 * it, as __track_dentry_update() does.
+	 */
+	if (ei->i_fc_nr_ranges >= EXT4_FC_SNAPSHOT_MAX_RANGES) {
+		spin_unlock(&ei->i_fc_lock);
+		ext4_fc_mark_ineligible(inode->i_sb, EXT4_FC_REASON_NOMEM, handle);
+		spin_lock(&ei->i_fc_lock);
+		return;
+	}
+
 	/* Allocate first so the merge/erase below cannot fail partway. */
 	new = ext4_fc_rnode_alloc();
 	if (!new) {
@@ -703,12 +728,8 @@ static void ext4_fc_range_add(handle_t *handle, struct inode *inode,
 		 * Could not record the range under memory pressure.  A fast
 		 * commit must log every modified range or replay would restore
 		 * an incomplete inode, so fall back to a full commit rather than
-		 * silently drop it.
-		 *
-		 * ext4_fc_mark_ineligible() takes the s_fc_lock mutex, which must
-		 * not be acquired under the i_fc_lock spinlock the caller holds
-		 * (lock order is s_fc_lock before i_fc_lock); drop and retake
-		 * i_fc_lock around it, as __track_dentry_update() does.
+		 * silently drop it.  Drop/retake i_fc_lock around mark_ineligible
+		 * as above.
 		 */
 		spin_unlock(&ei->i_fc_lock);
 		ext4_fc_mark_ineligible(inode->i_sb, EXT4_FC_REASON_NOMEM, handle);
-- 
2.43.0
