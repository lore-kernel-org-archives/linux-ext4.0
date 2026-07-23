Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1953E9C1C
	for <linux-ext4@vger.kernel.org>; Thu, 23 Jul 2026 08:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784795123; cv=none; b=Gyzr1IOAFBzYPlANcuQEv0WlgmncqN4ZEWoCsAFBVb82BMyfP3ocZyUGmiEl5ezXd70dlXVI1SMqh3i++7RC14atXe9tW7w4hP+Izsb0mBRJFCrSBXmgKjOfFBqMWHh1ibt0O8DHdHVjov5K8vjpGEcQTDxEX+DqDURIfYLZVjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784795123; c=relaxed/simple;
	bh=aQj+Nnq0XCyMtrQqIFFjfaozczI8tSBMqQC5UU6k5YI=;
	h=Mime-Version:Subject:From:To:CC:In-Reply-To:Message-ID:Date:
	 Content-Type:References; b=cxvh4zWVlJyJ5fAnXLdTl6j97hHpR4biFuLRfIn11QFySkQ3prB2yXlCJrtrketK59Y8uNUep9zd1CuKMWSB60KgaXvLfOuVB5UuiUwiJs5hrLIsI+mNFQ/g2fqQwKfbRgTl8nyN/4/hSeZ8Lq3UHwOHdWHcVTMTtz1wKE0VvzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=YDTZmOup; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="YDTZmOup"
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260723082517epoutp01111d48d79401208a2681614d3f722fdb~E3bQJerJl2886528865epoutp01N
	for <linux-ext4@vger.kernel.org>; Thu, 23 Jul 2026 08:25:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260723082517epoutp01111d48d79401208a2681614d3f722fdb~E3bQJerJl2886528865epoutp01N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1784795117;
	bh=w1oXxbwApySJ79iddyCVTR44mDZoYo0kB9q7TWuB63E=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=YDTZmOupZ9KXD4ELgkksYphS/0iK37rRD6+VPB4nsUcWv5QuFkxnBIYwxxI8nT1bY
	 FujvbCwVdv2gFl/k+lMFvXJEelb4HsNgk9PhKG/8fODbVdsfrRbEWZW1LPcrdLdK/8
	 ANTgp93ocmWJIlBopKINnAGgGGx1uANq7PJAv+3E=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPS id
	20260723082516epcas2p40f87b343cae97d979190768c500495e0~E3bPOeXLb1973619736epcas2p4d;
	Thu, 23 Jul 2026 08:25:16 +0000 (GMT)
Received: from epcas2p4.samsung.com (unknown [182.195.38.208]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4h5PM02YpKz6B9m6; Thu, 23 Jul
	2026 08:25:16 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: RE:(2) [RFC PATCH v3 0/2] ext4: speed up fast commit on random
 writes
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From: Daejun Park <daejun7.park@samsung.com>
To: Andreas Dilger <adilger@dilger.ca>
CC: "tytso@mit.edu" <tytso@mit.edu>, "linux-ext4@vger.kernel.org"
	<linux-ext4@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "me@linux.beauty" <me@linux.beauty>,
	"libaokun@linux.alibaba.com" <libaokun@linux.alibaba.com>,
	"harshadshirwadkar@gmail.com" <harshadshirwadkar@gmail.com>,
	"yi.zhang@huaweicloud.com" <yi.zhang@huaweicloud.com>,
	"ojaswin@linux.ibm.com" <ojaswin@linux.ibm.com>, Daejun Park
	<daejun7.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <0A044AA9-8457-4DF8-902E-72208C1C6CC6@dilger.ca>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20260723082515epcms2p18b33139192f8ddf493573817c2d21cc3@epcms2p1>
Date: Thu, 23 Jul 2026 17:25:15 +0900
X-CMS-MailID: 20260723082515epcms2p18b33139192f8ddf493573817c2d21cc3
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260722005922epcms2p566d8027c8d1dbb8d9c46e3d3b35b6fd0
References: <0A044AA9-8457-4DF8-902E-72208C1C6CC6@dilger.ca>
	<20260722005922epcms2p566d8027c8d1dbb8d9c46e3d3b35b6fd0@epcms2p5>
	<CGME20260722005922epcms2p566d8027c8d1dbb8d9c46e3d3b35b6fd0@epcms2p1>

On Jul 22, 2026, at 01:27, Andreas Dilger <adilger@dilger.ca> wrote:
> Have you looked at implementing a more dynamic structure like another
> extent status tree, rbtree, xarray or or similar instead of having a
> fixed-size array? [...] It would be useful to do some testing of how
> many separate ranges gets worse than the fallback.

Thanks -- I implemented the dynamic structure; it replaces the array and the
tunable entirely.  v4 tracks the modified ranges in a per-inode rbtree, which
answered both of your questions.

It can't be the shared extent status tree: I probed whether the shrinker
reclaims a mapped es entry for a modified-but-not-yet-committed range, and it
does (448 in one short run under mild pressure).  That "modified" mark is not
re-derivable, so marking the shared tree would silently lose modifications -- the
tracker has to own its structure.

So it is a private rbtree, reusing ext4's own machinery (generic rb_*, as the
extent status tree already does for per-inode ranges) -- idiomatic, no new
dependency.  The node is a dedicated 32-byte struct with its own slab cache, not
extent_status: extent_status carries an 8-byte es_pblk that fast commit never
uses, and its cache is SLAB_RECLAIM_ACCOUNT, which would misaccount these
non-reclaimable nodes.  The rb_root is inline in the inode, so only per-range
nodes are allocated.  (I also built and compared a maple-tree version:
behaviour-identical, within ~15% on memory, denser only at the range counts this
series already caps -- so the rbtree, with no dependency, is the choice.)

On "how many is too many": the cap is EXT4_FC_SNAPSHOT_MAX_RANGES (2048), the
limit the snapshot already enforces on emitted ranges -- reused directly, not a
new constant.  Each disjoint tracked range snapshots to at least one ADD_RANGE,
so a tracked set larger than that can never fit under the snapshot cap: the fast
commit would overrun it and fall back regardless.  That count is exactly where
tracking stops paying off, so at the cap the transaction falls back to a full
commit.  (Verified: R=4096 disjoint writes/fsync falls back there; R=1024 tracks
precisely.)

Thanks,
Daejun
