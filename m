Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA6725776;
	Tue,  1 Sep 2026 02:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788230540; cv=none; b=ORtLPJsAwm17tx4Vz3CFZ+WAYELAjoSpSz7mx5H0mx7VQITn2xB0fiPX/3xcMLCMeMl9LHSCzVbZy5Ybhq3GYJlC9kRmaSCJunAe2madVyJ/LWcljEuKxN3hI5YY57hZEJTJx6RoygtQLl1MAkxEdlzOCZ25B263wqx2qeidQz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788230540; c=relaxed/simple;
	bh=nnqtrefCLnQIjHXZ6WX2Zy/wRagTfJvxDgIXvYFMGA4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=GVJVKFK+vPY/HLzzvXtv0cYtoggqJbW2TwZTKirMjrhNAmPpcv81a8aAjDm7jvna6lE1Z8/AtSA3ee80MA1lLdLkG21n+TIyZcz/7RamWlwg0C+0vh40fIle9tPz4IhItWb/tngldmv2VPWl0sHahvPPxDtkIc60UznvL3XNVZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=3dXXvUSU; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="3dXXvUSU"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=O4RnVF9vYhiRJKCku6Atjjfmvj/PSgEsj6FGcTGmt18=;
	b=3dXXvUSUSM+4R175Hpm0E2aXdfryUdMKTjU6M5bZqlQSIDVQ62HO9T9H5Eo6Omp74GwHu7xtU
	uT9N++oxgH+fQHwU+BZMMN/BCaODeMPS0BAfms7DzYCuvx+PDCHqys4LQVQOWLrBd+niHq/Wl/n
	CZfnEcVZubMWK5nC+WkpP7U=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4hYqbK305MzpSvd;
	Tue,  1 Sep 2026 10:30:37 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id E74844057F;
	Tue,  1 Sep 2026 10:41:55 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 1 Sep
 2026 10:41:54 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <viro@zeniv.linux.org.uk>, <brauner@kernel.org>, <jack@suse.cz>,
	<bcrl@kvack.org>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>,
	<libaokun@linux.alibaba.com>, <ojaswin@linux.ibm.com>,
	<ritesh.list@gmail.com>, <yi.zhang@huawei.com>, <sforshee@kernel.org>,
	<pmladek@suse.com>, <rostedt@goodmis.org>,
	<andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>,
	<senozhatsky@chromium.org>, <akpm@linux-foundation.org>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <horms@kernel.org>, <kuniyu@google.com>,
	<willemb@google.com>, <jhs@mojatatu.com>, <jiri@resnulli.us>,
	<kees@kernel.org>, <cyphar@cyphar.com>, <tglx@kernel.org>,
	<ruanjinjie@huawei.com>, <sdf@fomichev.me>, <nb@tipi-net.de>,
	<liuhangbin@gmail.com>, <da-x@monatomic.org>, <jeff@garzik.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-aio@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-ext4@vger.kernel.org>,
	<netdev@vger.kernel.org>
Subject: [PATCH v2 00/12] Convert barrier pairs to acquire/release for better performance
Date: Tue, 1 Sep 2026 10:42:22 +0800
Message-ID: <20260901024234.135119-1-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
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

Testing (arm64 Kunpeng HIP09 server)
================

1. UNIXBENCH syscall
	Baseline: 715.27
	Patched:  718.83
	Improvement: +0.50%

2. fs/aio (fio + null_blk, 4 jobs):
	Baseline: 1441k IOPS, 86.46us
	Patched:  1452k IOPS, 85.80us
	Improvement: ~0.8%

3. soreuseport (wrk, 8 servers):
	Baseline: 162.6k req/s, 452.5us
	Patched:  164.2k req/s, 449.4us
	Improvement: ~1.0%

Both improvements are consistent across runs and align with the
expected savings from replacing DMB with LDAR/STLR on arm64.

[1]: https://support.arm.com/documentation/102336/0100/Load-Acquire-and-Store-Release-instructions
[2]: https://github.com/torvalds/linux/commit/d0dd066a0fa26d55c19ace9e89dedd9504c5bcba

Changes in v2:
- Fix pre-existing issue for ext4 and 8021q [3].
- Fix missing copy_mnt_idmap() udapte [3].
- Drop nacked isotp patch.
- Add test data.
- Add Reviewed-by and update fs patch as Jan suggested.

[3]: https://sashiko.dev/#/patchset/20260825095422.3166067-1-ruanjinjie%40huawei.com

Jinjie Ruan (12):
  user_namespace: Use acquire/release for nr_extents synchronization
  lib/vsprintf: Use acquire/release for ptr_key publication
  fs: aio: Use acquire/release for ring->tail publication
  fs: Use acquire/release for fdtable resize synchronization
  pidfs: Use test_bit_acquire() for attr flag tests
  super: Use acquire for SB_BORN check in super_cache_count()
  ext4: Fix out-of-bounds read in ext4_get_group_info()
  ext4: Convert group-count barrier protocol to acquire/release
  soreuseport: publish num_socks with acquire/release
  net: sched: act_gact: use acquire/release for tcfg_ptype
  8021q: Fix data race when publishing vlan net_device pointers
  8021q: publish vlan_devices_arrays entries with acquire/release

 fs/aio.c                  | 10 ++++------
 fs/ext4/balloc.c          |  2 +-
 fs/ext4/ext4.h            | 10 +++-------
 fs/ext4/mballoc.c         |  6 ++----
 fs/ext4/resize.c          | 19 +++++++++++--------
 fs/file.c                 | 10 ++++------
 fs/mnt_idmapping.c        |  5 ++---
 fs/pidfs.c                |  6 ++----
 fs/super.c                |  6 ++----
 kernel/user_namespace.c   | 24 +++++++++++++-----------
 lib/vsprintf.c            | 11 ++++-------
 net/8021q/vlan.c          |  6 ++----
 net/8021q/vlan.h          | 12 +++++-------
 net/core/sock_reuseport.c | 20 ++++++++------------
 net/sched/act_gact.c      | 12 ++++--------
 15 files changed, 67 insertions(+), 92 deletions(-)

-- 
2.34.1

