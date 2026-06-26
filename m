Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61FAC2BD5A8
	for <linux-ext4@vger.kernel.org>; Fri, 26 Jun 2026 08:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782463259; cv=none; b=KAGnbWHJ5kMrU8XHG6h5257Qv/9EpWxDr0PHJjXyu/cj8max48q7HnkQ5Env13U2Aupy54ujjRxCls66Hw4BxX6e/MWPJVGSNodzqQsl6SH3uz/xg/hZU9ZId5jxiPpG7zJvX3nlxHp19d7KKaqBqhGUiBrMT84NzNGRxSIH1oE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782463259; c=relaxed/simple;
	bh=j7V2J2FTFCkeIqYSKwMa4XXnJArgA2hLIG5UTuYvTUE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=dqynmzH5aKFthJH6X7IPp+5WkcEUhIIEBUxmIeJy2O3k8aY1BNxo1COylB/k7cIgO84eEIKFL5CLrVjq/pRrJvTD5rP2Fdimu6Nxm1jkhN5MhxKq/l7PRwbf3wNNvQ8094FfgR7WpCQn7qDW17i3pSRED5bbjCqsmLZdi7w2kEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=sxoMDD7W; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="sxoMDD7W"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782463247; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=5FddR/malM+yWedxCNk0Jxz4z3ipxxBJubHqoegtMhg=;
	b=sxoMDD7WsS2l3tfMm+AmC/eaE2sYAZ85Wig37V63GaZKOY548aNULrH4RO7/3UZnVyUsG7XBksw3z4/jQlRMb6eBH4/KSfzsC1I2XhsrQiq0O5DzdNpJS9+DTgdYJTTRVPv9YAPcWtWC/NB6OJWFT8d+e3yKhDBnlKTg3w1f7FE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X5e4zdx_1782462919;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X5e4zdx_1782462919 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 26 Jun 2026 16:35:29 +0800
From: Baokun Li <libaokun@linux.alibaba.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	yi.zhang@huawei.com,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	peng_wang@linux.alibaba.com
Subject: [PATCH v3 0/9] ext4: allow more DIO writes under shared i_rwsem
Date: Fri, 26 Jun 2026 16:35:09 +0800
Message-ID: <20260626083518.1064517-1-libaokun@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Changes since v2:
  * Collect RVB from Honza and Yi. (Thank you for your review!)
  * Patch 6: improved EXT4_GET_BLOCKS_CACHED_NOWAIT handling - cache-hit
    path now uses "goto found" to run check_block_validity(), closing a
    security bypass for malicious extents from crafted filesystem images.
  * Added Patch 9 to fix NOWAIT semantic violation in DAX extending writes
    reported by Sashiko.

Changes since v1:
  * Collect RVB from Honza and Yi. (Thank you for your review!)
  * Added Patch 1 to fix NOWAIT issues reported by Sashiko.
  * Added Patch 2 to fix ext3 DIO and DIO fallback data race issue.
    (Patch 4 increases the probability of this race)
  * Added Patches 5-8 to fix other NOWAIT issues discovered during
    investigation.

v1: https://lore.kernel.org/linux-ext4/20260611163441.2431805-1-libaokun@linux.alibaba.com/
v2: https://lore.kernel.org/linux-ext4/20260618125735.4156639-1-libaokun@linux.alibaba.com/

======

Hi all,

This series relaxes the i_rwsem requirements of ext4_dio_write_iter()
so that more direct I/O writes can proceed under the shared lock.

It continues the work started by Peng Wang's RFC [1]; I'm taking
over this effort going forward.

ext4_dio_write_checks() currently calls ext4_overwrite_io() to decide
whether the shared lock is sufficient. Its single ext4_map_blocks()
lookup only sees the first contiguous extent of the same type, which
forces the exclusive lock for two cases that are actually safe under
the shared lock (see individual patches for the full safety
argument):

  1. Aligned writes spanning multiple already-allocated extents (e.g.
     written + unwritten, or two discontiguous written extents).

  2. Unaligned writes whose head/tail partial blocks land on written
     extents but the fully-covered middle blocks include hole or
     unwritten extents.

Patch 1 fixes a NOWAIT issue where ext4_iomap_alloc() may sleep when
IOMAP_NOWAIT is set.

Patch 2 fixes a data race between DIO completion and buffered I/O
fallback on ext3 (no-extent inodes). This race was made more likely
by Patch 4.

Patch 3 skips the ext4_overwrite_io() pre-check entirely for aligned
non-extending writes, letting them proceed under the shared lock
regardless of extent state.

Patch 4 replaces ext4_overwrite_io() with ext4_dio_needs_zeroing(),
which directly answers the question driving the lock decision. It
checks only the head and tail partial blocks (at most two
ext4_map_blocks() calls), and ignores the state of middle blocks.

Patch 5 fixes a NOWAIT issue by using kiocb_modified instead of
file_modified in DIO/DAX write paths.

Patch 6 improves EXT4_GET_BLOCKS_CACHED_NOWAIT handling in
ext4_map_blocks(): cache-hit path now jumps to validation instead of
returning directly, cache-miss returns -EAGAIN instead of 0, and
adds a WARN_ON_ONCE to assert CREATE and CACHED_NOWAIT are never
combined.

Patch 7 adds cache-only lookup support to ext4_iomap_begin() for
IOMAP_NOWAIT requests.

Patch 8 adds cache-only lookup support to ext4_dio_needs_zeroing()
for IOCB_NOWAIT requests.

Patch 9 fixes a NOWAIT semantic violation in DAX extending writes
where ext4_journal_start() could sleep when the write extends past
i_disksize.


Testing
=======

"kvm-xfstests -c ext4/all -g auto" passes with no new failures.


Performance
===========

Hardware: /dev/sda (rotational disk, ~1 GB/s sustained write)
Filesystem: ext4 default mkfs

Test 1: aligned 8K DIO writes spanning written+unwritten extent
boundaries. Each thread writes its own 1G region sequentially; the
file is rebuilt between runs so every block is written exactly once.
Metric: IOPS.

  JOBS         base    +patch 3    +patch 3+4    speedup
  ----    ---------    --------    ----------    -------
     1       42,322      43,329        43,087      1.02x
     2       68,516      70,677        66,958      1.03x
     4       62,489      97,072       101,468      1.62x
     8       58,701     110,819       113,679      1.94x
    16       58,569     116,392       115,272      1.97x
    32       60,860     117,244       119,621      1.97x

Wall time at JOBS=32: 69.2s (base) -> 35.4s (patched), 1.96x faster.

Test 2: unaligned DIO writes (14336 bytes at +512 within each 16K
stripe). Each stripe is laid out as [written][unwritten][unwritten]
[written], so the head and tail partial blocks land on written
extents but the middle is unwritten. Metric: IOPS.

  JOBS         base    +patch 3    +patch 3+4    speedup
  ----    ---------    --------    ----------    -------
     1       15,547      15,975        17,381      1.12x
     2       15,910      14,808        34,172      2.15x
     4       15,014      14,828        57,567      3.83x
     8       15,022      14,648        81,947      5.46x
    16       14,586      14,262        99,126      6.80x
    32       14,047      13,809        92,519      6.59x

Wall time at JOBS=32: 149.3s (base) -> 22.7s (patched), 6.58x faster.

In test 2, patch 3 alone has no effect (slight noise) because patch 3
only touches the aligned write path. Patch 4 introduces
ext4_dio_needs_zeroing() which precisely identifies when partial
block zeroing is required, allowing the shared lock for the much
larger set of unaligned writes that don't actually trigger zeroing.

Comments and questions are, as always, welcome.

Thanks,
Baokun

[1]: https://lore.kernel.org/linux-ext4/20260607124935.6168-1-peng_wang@linux.alibaba.com/

Baokun Li (9):
  ext4: prevent sleeping allocation in NOWAIT write path
  ext4: drain in-flight DIO before buffered write fallback
  ext4: skip overwrite check for aligned non-extending DIO writes
  ext4: base unaligned DIO lock decision on partial block zeroing
  ext4: use kiocb_modified instead of file_modified in DIO/DAX write
    path
  ext4: improve EXT4_GET_BLOCKS_CACHED_NOWAIT handling in
    ext4_map_blocks
  ext4: handle IOMAP_NOWAIT in ext4_iomap_begin() with cache-only lookup
  ext4: handle IOCB_NOWAIT in ext4_dio_needs_zeroing() with cache-only
    lookup
  ext4: fix NOWAIT semantic violation in DAX extending writes

 fs/ext4/file.c  | 154 ++++++++++++++++++++++++++++++++++--------------
 fs/ext4/inode.c |  22 +++++--
 2 files changed, 127 insertions(+), 49 deletions(-)

-- 
2.43.7

