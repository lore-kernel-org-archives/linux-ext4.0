Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76E073469E7;
	Wed,  2 Sep 2026 07:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788335243; cv=none; b=laQrsXjyX03EaXXGmTmiK1d6r06hCCJlpmVlGWEKNJ2AeCf3LdIT6Rh8iWZlO7pSZuibADr/d1luEa7rbfcFnNxOmNzXZoX90qRNxJw45FgMFVkr8cS8VnyTrZ6dsLEU5iNrTYMIdbjpNds4AsE29fjAsj0u0REkGGwTZ41VKCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788335243; c=relaxed/simple;
	bh=Wz8l3Gu4W70/Vv6avSB+wGbct1rJflClbOarP/ONjyc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=kZ1D8+8lIPIivB6Bgoj1nC0y6aYM3kY2kPDN53tV3I5AwvQXdN1RGp2XCb88+7bMCDOvD8ibOgFcI3hQnMEYCSPXZun2NJ7vVlrdo7GIl6f+xrwNK+yAeY4A5Fq3B++yOljFamU98y4eQjnlNuUvdDL2fTIFPT6bgeXE5fyNTTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=MTAL8EZW; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="MTAL8EZW"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=PzHZiegNXuduItyVE6hIcWm7KStUom3EumDXT7rj+3M=;
	b=MTAL8EZW8hBog35yVocFuaxUgsn6qoemNDo4keHpeCYhs6GHG8Shf+C89YDNv/Zyu63vFz917
	4UipDFjL6O3JZrSpQcjmQ7mgS+w6f8V4W5pCLUqpHv+2UFd6iRpz1gBVZgEE5XH1w3DRfmHtzML
	bvgw5zSsnyfTCVciBl250mk=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4hZZK56WymzpSvQ;
	Wed,  2 Sep 2026 15:35:53 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 90BAD40538;
	Wed,  2 Sep 2026 15:47:14 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 2 Sep
 2026 15:47:13 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <bcrl@kvack.org>, <viro@zeniv.linux.org.uk>, <brauner@kernel.org>,
	<jack@suse.cz>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>,
	<libaokun@linux.alibaba.com>, <ojaswin@linux.ibm.com>,
	<ritesh.list@gmail.com>, <yi.zhang@huawei.com>, <sforshee@kernel.org>,
	<akpm@linux-foundation.org>, <pmladek@suse.com>, <rostedt@goodmis.org>,
	<andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>,
	<senozhatsky@chromium.org>, <kees@kernel.org>, <tglx@kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-aio@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-ext4@vger.kernel.org>
CC: <ruanjinjie@huawei.com>
Subject: [PATCH v3 0/8] Convert barrier pairs to acquire/release for better performance
Date: Wed, 2 Sep 2026 15:47:57 +0800
Message-ID: <20260902074805.398540-1-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf500011.china.huawei.com (7.185.36.131)

Hi,

This series converts some existing smp_wmb()/smp_rmb() barrier pairs to
smp_store_release()/smp_load_acquire() across various subsystems.

Background
==========

Many architectures support load acquire and store release instructions
which can replace explicit memory barriers and save cycles. As noted
in the ARM architecture reference [1]:

  "Weaker ordering requirements that are imposed by Load-Acquire and
   Store-Release instructions allow for micro-architectural
   optimizations, which could reduce some of the performance impacts
   that are otherwise imposed by an explicit memory barrier.

   If the ordering requirement is satisfied using either a Load-Acquire
   or Store-Release, then it would be preferable to use these
   instructions instead of a DMB."

On arm64, a typical seqcount [2] read loop requires 13 cycles with DMB
barriers. Replacing the read barrier with smp_load_acquire() reduces
this to 8 cycles on an Ampere Altra.

We also observed significant barrier overhead while profiling Unxibench
syscall test on arm64: a single getuid() call is ~8ns slower than on
a comparable x86 system, with the dominant cost in map_id_up()'s smp_rmb(),
which is a DMB ISHLD on arm64. Converting it to smp_load_acquire() allows
the use of LDAR, eliminating the measurable overhead.

This motivated a broader search for existing barrier pairs that can
be converted to the lighter acquire/release semantics.

Changes
=======

Each patch in this series targets a specific barrier pair where the
publish/subscribe pattern is already present:

- Writers populate data, then publish a flag/count/pointer via
  smp_store_release()

- Readers load the flag/count/pointer via smp_load_acquire(), then
  consume the data

This preserves the existing memory ordering guarantees while allowing
architectures with native acquire/release instructions (e.g. arm64's
STLR/LDAR) to avoid the cost of full one-way barriers (DMB ISHST/ISHLD).
On architectures without native support, the generated code is
generally no worse than the explicit barrier pair.

The conversions are mechanical and no functional change is intended.

Testing (Kunpeng HIP09 arm64 server)
====================================

1. UNIXBENCH syscall
	Baseline: 715.27
	Patched:  718.83
	Improvement: +0.50%

2. fs/aio (fio + null_blk, 4 jobs):
	Baseline: 1441k IOPS, 86.46us
	Patched:  1452k IOPS, 85.80us
	Improvement: ~0.8%

Both improvements are consistent across runs and align with the
expected savings from replacing DMB with LDAR/STLR on arm64.

[1]: https://support.arm.com/documentation/102336/0100/Load-Acquire-and-Store-Release-instructions
[2]: https://github.com/torvalds/linux/commit/d0dd066a0fa26d55c19ace9e89dedd9504c5bcba

Changes in v3:
- Add Reviewed-by.
- Split out network patch set as Kuniyuki suggested.
- Link to v2: https://lore.kernel.org/all/20260901024234.135119-1-ruanjinjie@huawei.com/

Changes in v2:
- Fix pre-existing issue for ext4 and 8021q [3].
- Fix missing copy_mnt_idmap() udapte [3].
- Drop nacked isotp patch.
- Add test data.
- Add Reviewed-by and update fs patch as Jan suggested.

[3]: https://sashiko.dev/#/patchset/20260825095422.3166067-1-ruanjinjie%40huawei.com

Jinjie Ruan (8):
  user_namespace: Use acquire/release for nr_extents synchronization
  lib/vsprintf: Use acquire/release for ptr_key publication
  fs: aio: Use acquire/release for ring->tail publication
  fs: Use acquire/release for fdtable resize synchronization
  pidfs: Use test_bit_acquire() for attr flag tests
  super: Use acquire for SB_BORN check in super_cache_count()
  ext4: Fix out-of-bounds read in ext4_get_group_info()
  ext4: Convert group-count barrier protocol to acquire/release

 fs/aio.c                | 10 ++++------
 fs/ext4/balloc.c        |  2 +-
 fs/ext4/ext4.h          | 10 +++-------
 fs/ext4/mballoc.c       |  6 ++----
 fs/ext4/resize.c        | 19 +++++++++++--------
 fs/file.c               | 10 ++++------
 fs/mnt_idmapping.c      |  5 ++---
 fs/pidfs.c              |  6 ++----
 fs/super.c              |  6 ++----
 kernel/user_namespace.c | 24 +++++++++++++-----------
 lib/vsprintf.c          | 11 ++++-------
 11 files changed, 48 insertions(+), 61 deletions(-)

-- 
2.34.1

