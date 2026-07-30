Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5959022A7F0
	for <linux-ext4@vger.kernel.org>; Thu, 30 Jul 2026 00:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785371841; cv=none; b=BGRqam5hROBsyeit70udSlm/rjJiklYHqb2Bre2SoYZg5JW1oseCE2zoJmrjSxX5y6j3njIZ1eIrXhgMwZ8IenrvDTOauHV8KBC07dVMHipqsR5T9DWi6bxF5mEPhmEWNAj2DJjnEGHCP0427v68gyRfp2D56DQmI17ZLBej6VY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785371841; c=relaxed/simple;
	bh=RidW8FcZZSRg8WieQ6BVJ004x08aDYwAaaflFH8ealo=;
	h=Mime-Version:Subject:From:To:CC:Message-ID:Date:Content-Type:
	 References; b=sKlQCU9eBEV3en4oJNMpg8vUkaFUV/N5iubrUXW1SBMeq8n0nJya3R79/6HLhuJtZfe8kHCVvlm8NF40vQLzuzpaCkpGWCWAgWbdGLFZd1kmV8ntSQw1HEDXiE53PTtay+ldfFQPY/pIev4zFbzJQMdVZcgn+5mzZcKSilHxyFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Vj/Szel0; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Vj/Szel0"
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260730003716epoutp02a049d5f97d1742503bcdd3ceca3d99ae~G6jnn1XyP2910729107epoutp02l
	for <linux-ext4@vger.kernel.org>; Thu, 30 Jul 2026 00:37:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260730003716epoutp02a049d5f97d1742503bcdd3ceca3d99ae~G6jnn1XyP2910729107epoutp02l
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1785371836;
	bh=S7tXlIMtH/6dG682vcketNvGonnH/itZfpVLOD98ke0=;
	h=Subject:Reply-To:From:To:CC:Date:References:From;
	b=Vj/Szel0XiOre1VBgI8T5k2lFqiPGxs1z5PS4g65cQwCZl29VmiWjHE2maYbnmnyU
	 di9SCGbo97qCcIa9AGjLKPdIbLfDLZO11H98ht02uFuCSIY4FUEh4WVkJp1qOaWrQA
	 iv9oETRfcaxFqZE+lMbIc2rj2qdZwf8u+N0OKbSI=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPS id
	20260730003716epcas2p36e659b8e8e1987a5337a2cef015cb252~G6jnJDtSl0808408084epcas2p3H;
	Thu, 30 Jul 2026 00:37:16 +0000 (GMT)
Received: from epcas2p2.samsung.com (unknown [182.195.38.203]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4h9Vdl6PHBz2SSL1; Thu, 30 Jul
	2026 00:37:15 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: [RFC PATCH v4 0/3] ext4: speed up fast commit on random writes
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
Message-ID: <20260730003715epcms2p54b7e3cc3409076cc9ee751f60951e167@epcms2p5>
Date: Thu, 30 Jul 2026 09:37:15 +0900
X-CMS-MailID: 20260730003715epcms2p54b7e3cc3409076cc9ee751f60951e167
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260730003715epcms2p54b7e3cc3409076cc9ee751f60951e167
References: <CGME20260730003715epcms2p54b7e3cc3409076cc9ee751f60951e167@epcms2p5>

ext4 fast commit tracks one coalesced [min,max] logical range per inode.  An
inode dirtied at several disjoint offsets between commits widens that span to
cover them all, and at commit time ext4_fc_snapshot_inode_data() walks the whole
span -- an ADD_RANGE per mapped segment, a DEL_RANGE per hole.  For scattered
writes that is hundreds to thousands of ranges for a handful of dirty regions,
overrunning EXT4_FC_SNAPSHOT_MAX_RANGES and falling back to a full commit (R=16
disjoint writes/fsync over a 1 GiB span: ~1095 ranges/commit, 76% fallback).

This tracks the actually-modified disjoint ranges and snapshots only those.

v3 [1] used a fixed-size array with a coalesce-on-overflow bound.  Andreas asked
to (a) reuse an existing dynamic structure instead of open-coding one, and (b)
find how many ranges it takes before tracking is worse than the fallback.  This
answers both; the array and the fc_max_ranges tunable are gone.

  1/3  track the disjoint ranges in a per-inode rbtree; merge-on-insert keeps
       the set disjoint.
  2/3  keep the first range inline in a union with the rbtree root, so a
       single-region inode allocates nothing; grow the tree only on the second
       disjoint range.
  3/3  cap the tracked ranges at EXT4_FC_SNAPSHOT_MAX_RANGES (2048); at the cap
       fall back to a full commit.

On (a): a private rbtree, reusing ext4's own machinery -- the extent status tree
already tracks per-inode lblk ranges as an rbtree, so it is idiomatic and adds no
dependency.  Not the shared es-tree: its shrinker reclaims mapped entries for
modified-but-not-yet-committed ranges (a probe evicted 448 under mild pressure),
which would lose modifications.  The node is a dedicated 32-byte struct with its
own slab cache, not extent_status -- which carries an unused 8-byte es_pblk and
lives in a SLAB_RECLAIM_ACCOUNT cache that would misaccount these non-reclaimable
nodes.  (A maple-tree version was also built and compared: behaviour-identical,
memory within ~15%, denser only at the range counts the cap already falls back
from -- so the dependency-free rbtree is the choice.)

On (b): the cap is EXT4_FC_SNAPSHOT_MAX_RANGES itself, reused directly.  Each
disjoint tracked range snapshots to at least one ADD_RANGE, so a tracked set
larger than that can never fit under the snapshot cap -- the fast commit would
overrun it and fall back regardless.  That count is exactly where tracking stops
paying off.  Verified: R=4096/fsync falls back there (fc_info "Insufficient
memory"), R=1024 tracks precisely.

The on-disk TLV format is unchanged; a GFP_ATOMIC failure under i_fc_lock falls
back to a full commit or coalesces into the inline range, so nothing is lost.

Tested on dev: crash recovery (power loss + replay + verify + e2fsck) 9600/9600
blocks clean at 512 dirty regions, and 200000/200000 clean with the cap firing
every round (2500 ranges/fsync); ext4/044 045, generic/456 482 pass (generic/455
fails identically unpatched); checkpatch --strict clean.  e2fsprogs needs no
update (format unchanged).

Still RFC -- feedback welcome.

Changes since v3 [1]:
  - fixed array + overflow-coalesce -> rbtree of disjoint ranges; tunable dropped.
  - first range kept inline (no alloc for single-region inodes).
  - bound memory by falling back at the snapshot cap.
  - documented why the shared es-tree can't be used (measured shrinker hazard).

[1] v3: https://lore.kernel.org/linux-ext4/20260722005922epcms2p566d8027c8d1dbb8d9c46e3d3b35b6fd0@epcms2p5/

Daejun Park (3):
  ext4: fast commit: track disjoint modified ranges in a private rbtree
  ext4: fast commit: keep the first range inline, allocate the tree
    lazily
  ext4: fast commit: bound the tracked range count

 fs/ext4/ext4.h        |  53 +++++-
 fs/ext4/fast_commit.c | 380 +++++++++++++++++++++++++++++++++++++-----
 fs/ext4/super.c       |   2 +
 3 files changed, 390 insertions(+), 45 deletions(-)


base-commit: 97e211ad1a34a5a979558a037619b9e633ca8620
-- 
2.43.0
