Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E9A7404E
	for <linux-ext4@vger.kernel.org>; Thu, 11 Jun 2026 04:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781153269; cv=none; b=KwtIvVr9Vlav0F98xCA48o4B1LuU6MrCqsr5fd6QmgZNOr2q33JQscCXpxb7QsF2SI2obsO5UYhjBPadbMhxx2sP84c47IYbd2z6Zqp/MHCmhQBUiqQtFOI93r+eFMeAH0zDPWBZVnJnD2fD69motD2gfqJZjsycVww/m/M5H5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781153269; c=relaxed/simple;
	bh=9v+tJwd/jlYgsHTcX8MNv7XUxHTB/Vps2xL0Leyb6H8=;
	h=Mime-Version:Subject:From:To:CC:Message-ID:Date:Content-Type:
	 References; b=CI2cVzG0rAHj7SOklnSFljhV/tlETFnc+7/ob3UvJAgvBW7ImOnWtDKBE6NZIVJflzRCq8CpO9QCBV1pR6Bbw82WEi9PrQl2p2D3pxx+KFvS78jYSDy5TRtGUw85LCJvc5BV1i9VjipS7uR9GHjAntFSDBYLnO7/HmkVU7UE7tM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=ma0RLRZP; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ma0RLRZP"
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20260611044737epoutp03fa42250c01e15b5c4e84aa5cc5dd2ae3~37XNp5XFD2173621736epoutp03V
	for <linux-ext4@vger.kernel.org>; Thu, 11 Jun 2026 04:47:37 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20260611044737epoutp03fa42250c01e15b5c4e84aa5cc5dd2ae3~37XNp5XFD2173621736epoutp03V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1781153257;
	bh=iE6/Ad8qcCcmr3Jt3SHYYXtakTRsVdB9SaJ2w8LlsOk=;
	h=Subject:Reply-To:From:To:CC:Date:References:From;
	b=ma0RLRZP1mjMlJCLFvwJnZ/QAv8wTtUea3FVpUZ1HtZK23ZEG2gRPN0kWE0rzdAny
	 ytFyDptqDq9H+d4FnpoKOIDjWEBFeiKH986u9k9FEUj9dbP/szOfBove3oHFeuAIuh
	 62y+49KrmsfMyRt2mVHwbt6Kt1IC9YWW+HkoGjNw=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPS id
	20260611044734epcas2p3a3d22eb1b09dc063d6dc748274409590~37XK6g9yR2754527545epcas2p3Q;
	Thu, 11 Jun 2026 04:47:34 +0000 (GMT)
Received: from epcas2p1.samsung.com (unknown [182.195.38.205]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4gbVWB2BThz6B9mB; Thu, 11 Jun
	2026 04:47:34 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: [PATCH 0/2] ext4: reduce fast-commit write amplification for
 scattered writes
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
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20260611044733epcms2p38013ae683a283555526f70e4eab6d2a9@epcms2p3>
Date: Thu, 11 Jun 2026 13:47:33 +0900
X-CMS-MailID: 20260611044733epcms2p38013ae683a283555526f70e4eab6d2a9
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260611044733epcms2p38013ae683a283555526f70e4eab6d2a9
References: <CGME20260611044733epcms2p38013ae683a283555526f70e4eab6d2a9@epcms2p3>

ext4 fast commit tracks a single coalesced logical range per inode.  When
an inode is dirtied at several disjoint offsets between two commits (e.g.
sparse/scattered random writes), that range is widened to span [min, max]
of all the touched offsets, and ext4_fc_write_inode_data() then re-logs
every extent inside that span -- including the unmodified ones.  On sparse
allocation this inflates fast-commit traffic and frequently overflows the
fast-commit area, forcing a fallback to a full jbd2 commit.

This series replaces the single range with a small, bounded set of disjoint
ranges so that only the actually-modified regions are logged, while keeping
the per-inode memory cost negligible:

  1/2 tracks up to EXT4_FC_MAX_RANGES (16) disjoint ranges, merging the two
      closest ranges when the set would overflow -- so the worst case
      degrades gracefully to the old single-span behaviour.  The on-disk
      fast-commit (TLV) format is unchanged.

  2/2 allocates that array lazily: the first range is kept inline, the array
      is allocated only when a second disjoint range appears, and on an
      allocation failure we fall back to the inline single range.  The
      per-inode fast-commit footprint drops from ~140 to 20 bytes.

Measured on a sparse random-write workload (1 GiB span, R disjoint dirty
regions per fsync, 300 fsyncs, bare-metal NVMe):

  - fast-commit blocks per commit (R=16):  18.6 -> 1.0
  - full-commit fallback rate     (R=16):  22%  -> 2%   (on a small fs)
  - mean fsync latency:  R=16  -10%,  R=64  -14%
  - p99  fsync latency:  R=16  -31%

The p99 improvement comes from eliminating the full-commit fallback spikes.

Testing: crash recovery (power loss -> fast-commit replay -> verify every
fsync'd block, then e2fsck) is clean; the ext4/generic fast-commit xfstests
show no regression; the unchanged on-disk format means e2fsprogs needs no
update.  Both patches are checkpatch --strict clean.

Based on v6.17-rc3.

Daejun Park (2):
  ext4: track multiple disjoint fast-commit ranges per inode
  ext4: allocate the fast-commit range array lazily

 fs/ext4/ext4.h        |  40 +++++++--
 fs/ext4/fast_commit.c | 196 +++++++++++++++++++++++++++++++++++-------
 fs/ext4/super.c       |   1 +
 3 files changed, 199 insertions(+), 38 deletions(-)

-- 
2.43.0

