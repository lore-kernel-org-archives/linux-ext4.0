Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D572725B08A
	for <linux-ext4@vger.kernel.org>; Wed, 22 Jul 2026 00:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784681973; cv=none; b=BM4OcJBYWSp0lhWXDq9gfhJNdU0QCwsKDbX0H6pM5qP5eO+cAhQJl8FNJ94jF89xzaYGqR2s0+It19kMVKMBUZDGGS3h37rMTtBNjxMRxgLiv+jW8/4quceJei0fYbpYBjsAaFFXKDsP38e+uG6viIDgSbqLiHWam8V2YvwufJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784681973; c=relaxed/simple;
	bh=6y9d8GNTbJp4KIYiseS2/aSswu1KQDChGyRB1G9TrlY=;
	h=Mime-Version:Subject:From:To:CC:Message-ID:Date:Content-Type:
	 References; b=X0huzW6S0APiv6DKfk0Yq70z6oIbFlNA19bWYiCilCQ6JLSnfyV+KWDMqTJlPjAUuPzcEGekP9MMa1vfI0oI6Jlfx04WGRIeTw+pGS2BzqgcmCK643yfVFmdBPdQJJowTY7O1WsoOHLmNKryddTI1q3FOQh07UX6KN6zLzpf/dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=LlcEVrGy; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="LlcEVrGy"
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20260722005923epoutp0394598c0b27adf3478d064d4d5c824236~Edso-xpbb1928019280epoutp03d
	for <linux-ext4@vger.kernel.org>; Wed, 22 Jul 2026 00:59:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20260722005923epoutp0394598c0b27adf3478d064d4d5c824236~Edso-xpbb1928019280epoutp03d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1784681963;
	bh=XlFYd4s5Qi92k7vYTrRnbticxfFrohAO34uKSsFnjCg=;
	h=Subject:Reply-To:From:To:CC:Date:References:From;
	b=LlcEVrGyBfmqL9Nae/POghzR7zux+o3BcAthrXneIvQg7jaT+rft4TLYUfz4e/fbn
	 SpWJ/CTvLBa+F5j+pY6O1I5RHcIdvRNvIoOQdJw+NjiGVv7+wKq/JcR+YeCi5GngIk
	 veSPeUWNYQhg0+kCc5w5RssMZ4eJSROIxk0RJj1Q=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPS id
	20260722005922epcas2p290b60c7dcbd7250848f2b3a6961e0316~Edsoeh9ee0776707767epcas2p2E;
	Wed, 22 Jul 2026 00:59:22 +0000 (GMT)
Received: from epcas2p2.samsung.com (unknown [182.195.38.202]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4h4bVy3TLrz6B9mG; Wed, 22 Jul
	2026 00:59:22 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: [RFC PATCH v3 0/2] ext4: speed up fast commit on random writes
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
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20260722005922epcms2p566d8027c8d1dbb8d9c46e3d3b35b6fd0@epcms2p5>
Date: Wed, 22 Jul 2026 09:59:22 +0900
X-CMS-MailID: 20260722005922epcms2p566d8027c8d1dbb8d9c46e3d3b35b6fd0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260722005922epcms2p566d8027c8d1dbb8d9c46e3d3b35b6fd0
References: <CGME20260722005922epcms2p566d8027c8d1dbb8d9c46e3d3b35b6fd0@epcms2p5>

Fast commit is meant to make fsync cheap, but on random-write workloads it
defeats itself.  ext4 still tracks a single coalesced [min,max] logical range
per inode (i_fc_lblk_start/len).  When an inode is dirtied at several disjoint
offsets between two commits, that span widens to cover them all, and at commit
time ext4_fc_snapshot_inode_data() walks the whole span through the extent
status tree -- emitting an ADD_RANGE per mapped segment and a DEL_RANGE per
hole inside it.  For scattered writes that is hundreds to thousands of ranges
even though only a handful of regions were actually modified.

The recently merged fast-commit snapshot work did not change this: it caps a
snapshot at EXT4_FC_SNAPSHOT_MAX_RANGES (2048) and fails over to a full commit
when the span exceeds it.  Measured on dev (7.1.0-rc4) with a sparse
random-write workload (1 GiB span, R disjoint 4 KiB writes per fsync, 300
fsyncs):

  R=16 regions/fsync:  ranges/commit 1095,  full-commit fallback 76%
                       (snap_fail_ranges_cap on 226 of 300 fsyncs)

Fast commit barely functions on this workload.

This series tracks the actually-modified disjoint ranges instead of one span,
and snapshots only those:

  1/2 replaces the single [min,max] range with a small, bounded set of sorted,
      disjoint ranges (up to EXT4_FC_MAX_RANGES = 16; the two closest are
      merged on overflow, so the worst case degrades to the old single-span
      behaviour).  ext4_fc_snapshot_inode_data() then walks only the tracked
      ranges.  The on-disk TLV format is unchanged.

  2/2 allocates the range array lazily: the first range stays inline, the
      array is allocated only when a second disjoint range appears, and on an
      allocation failure we fall back to the inline single range.  Per-inode
      fast-commit footprint stays ~20 bytes.

Result on the same workload (dev, patched):

  R=16:  ranges/commit 1095 -> 16,  fallback 76% -> 0.7%,
         snap_fail_ranges_cap 226 -> 0

i.e. the over-logging and the fallback storm are gone when the number of dirty
regions is within the bound.

Honest limitation: when the number of disjoint regions per fsync exceeds
EXT4_FC_MAX_RANGES (e.g. R=64 with the bound at 16), the overflow merge
re-coalesces and the win largely disappears (fallback 95% -> 87%).  A larger or
tunable bound recovers it -- see the open question below.

Testing (on dev, patched):
  - crash recovery: deterministic writes + fsync, kill -9 QEMU (power loss),
    reboot -> fast-commit replay -> verify every fsync'd block, e2fsck -fn.
    9600/9600 blocks verified, 0 mismatch, e2fsck clean.  Run with R=64, so the
    overflow-merge path is exercised.
  - ext4/generic fast-commit xfstests (ext4/044 ext4/045 generic/455 456 457
    470 482): ext4/044, ext4/045, generic/456 pass; generic/457, 470 skip
    (reflink/dax unsupported on ext4); generic/455 fails identically on
    unpatched dev (pre-existing, patch-unrelated); generic/482's single failure
    in a combined run did not reproduce (3/3 pass in isolation on the patched
    kernel).
  - on-disk format unchanged, so e2fsprogs needs no update.
  - both patches are checkpatch --strict clean.

Posted as RFC -- this sits right on top of the new snapshot code and I would
like direction before a non-RFC submission:

  - Is tracking disjoint ranges in-core (this series) the right shape, or would
    you rather the snapshot side skip holes/unmodified extents some other way?
  - EXT4_FC_MAX_RANGES is fixed at 16.  The R>bound case above wants it larger
    or tunable (sysfs/mount).  Preference?
  - The array is allocated under i_fc_lock with GFP_ATOMIC, falling back to the
    inline range on failure.  Acceptable, or move the allocation outside the
    lock?
  - Overflow merges the two ranges with the smallest gap -- acceptable
    heuristic?

Changes since v2 [1]:
  - Evaluate the range adjacency bounds in 64 bits to remove a latent
    ext4_lblk_t (u32) overflow.  The largest valid lblk is
    EXT_MAX_BLOCKS - 1 (the shrink path in ext4_setattr() passes it; the data
    path is bounded by the m_lblk >= EXT_MAX_BLOCKS check), so "end + 1" and a
    range's "start + len" can reach EXT_MAX_BLOCKS.  These were computed in u32
    in ext4_fc_range_add() (1/2) and __track_range() (2/2).  On reachable inputs
    they stop one short of wrapping, so there is no behavioural change, but the
    arithmetic is now done in u64 so it cannot wrap regardless of caller --
    matching ext4_fc_snapshot_lblk_range(), which already used 64-bit bounds.
    No other site in the series shares this pattern (audited).

Changes since v1 [2]:
  - Rebased from v6.17-rc3 onto ext4.git dev; re-implemented on top of the
    merged fast-commit snapshot model (v1 targeted the old
    ext4_fc_write_inode_data(), which no longer exists).
  - Motivation now uses the in-tree snap_fail_ranges_cap counter.
  - From and Signed-off-by use the same identity.
  - Reposted as RFC.

[1] v2: https://lore.kernel.org/linux-ext4/20260623082331epcms2p4798e9d26b06f9a005bcca7b2edf395d3@epcms2p4/
[2] v1: https://lore.kernel.org/linux-ext4/20260611044733epcms2p38013ae683a283555526f70e4eab6d2a9@epcms2p3/

Daejun Park (2):
  ext4: fast commit: track disjoint modified ranges per inode
  ext4: fast commit: allocate the range array lazily

 fs/ext4/ext4.h        |  42 ++++++--
 fs/ext4/fast_commit.c | 231 ++++++++++++++++++++++++++++++++++++------
 fs/ext4/super.c       |   1 +
 3 files changed, 234 insertions(+), 40 deletions(-)


base-commit: c143957520c6c9b5cd72e0de8b52b814f0c576fe
-- 
2.43.0
