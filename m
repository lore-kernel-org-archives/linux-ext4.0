Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A81A3CCFA8
	for <linux-ext4@vger.kernel.org>; Tue, 23 Jun 2026 08:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782203016; cv=none; b=oxEEJB5A9v3jNgxFR+wxnkedRjc62h3MZM62+acUqGcOmGeFh58Sim12ekKrHPd52oPCe81NZyBtBHGETYT1vXyerYCcPRiuZGC914ftazErrrz13ype6FHJpFVFlRS4hi7PcL1uct/nmhG4z+ZG63jiUIyBVxFUAeoMjIkL5zU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782203016; c=relaxed/simple;
	bh=DjO9cZycXuk54UdxdufzYblHhhSEiAqgYn7swDfw6Us=;
	h=Mime-Version:Subject:From:To:CC:Message-ID:Date:Content-Type:
	 References; b=m6x8ALJmAAVKlJ732rHSjhF3oY8Z/cwBZlTOkTJKTq12h/8+2oAk3ox/IiDjdC77WpYnwuWpCwx+fr1leg7qun84jp4SeQsetBtkrWhPd85DzOBPA2/YrhqeSC5nhWe31/5kz18Nip+lbOLJAWBBkAiLbdF+XutvOiXtRu4zuRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=IacrQYvd; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="IacrQYvd"
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260623082332epoutp0284b924ee4126720f48f5e0059fffc34d~7qDKVEO1T3063130631epoutp02Q
	for <linux-ext4@vger.kernel.org>; Tue, 23 Jun 2026 08:23:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260623082332epoutp0284b924ee4126720f48f5e0059fffc34d~7qDKVEO1T3063130631epoutp02Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1782203012;
	bh=w9u8koBE2ZH51/q17FRv7wtXHLwCcFhUykaOzHQsc5U=;
	h=Subject:Reply-To:From:To:CC:Date:References:From;
	b=IacrQYvdoa+zRUPjGfi0ZuMg8mFaNDAkuFl0S5BEM+83EFAp7wUG6HHeVED7jp34+
	 oBmofaDffffdIfqLdO7+VOMzESeKrK+DICEkn2ssr7vTdlDsdTgj4c8y3MdbHKA7gf
	 usFNmdXM4+ckolyPvVUJ7grIM52gLvWCLaLGXcco=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPS id
	20260623082332epcas2p28466ed104162d807177236cef0cce022~7qDJtW0H_2591725917epcas2p2K;
	Tue, 23 Jun 2026 08:23:32 +0000 (GMT)
Received: from epcas2p3.samsung.com (unknown [182.195.38.210]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4gkykq5RWyz2SSKg; Tue, 23 Jun
	2026 08:23:31 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: [RFC PATCH v2 0/2] ext4: speed up fast commit on random writes
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
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20260623082331epcms2p4798e9d26b06f9a005bcca7b2edf395d3@epcms2p4>
Date: Tue, 23 Jun 2026 17:23:31 +0900
X-CMS-MailID: 20260623082331epcms2p4798e9d26b06f9a005bcca7b2edf395d3
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260623082331epcms2p4798e9d26b06f9a005bcca7b2edf395d3
References: <CGME20260623082331epcms2p4798e9d26b06f9a005bcca7b2edf395d3@epcms2p4>

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


Changes since v1 [1]:
  - Rebased from v6.17-rc3 onto ext4.git dev; re-implemented on top of the
    merged fast-commit snapshot model (v1 targeted the old
    ext4_fc_write_inode_data(), which no longer exists).

[1] v1: https://lore.kernel.org/linux-ext4/20260611044733epcms2p38013ae683a283555526f70e4eab6d2a9@epcms2p3/

Daejun Park (2):
  ext4: fast commit: track disjoint modified ranges per inode
  ext4: fast commit: allocate the range array lazily

 fs/ext4/ext4.h        |  42 ++++++--
 fs/ext4/fast_commit.c | 219 +++++++++++++++++++++++++++++++++++-------
 fs/ext4/super.c       |   1 +
 3 files changed, 222 insertions(+), 40 deletions(-)


base-commit: c143957520c6c9b5cd72e0de8b52b814f0c576fe
--
2.43.0
