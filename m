Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0368476CDA;
	Mon,  7 Sep 2026 11:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788780562; cv=none; b=u+qx4KXyJxDcT+ePjezcjQOAVOGOZ016tfaGm6VwaP1D0UFQ3bmGrm5DCy5U0OPWJ3hupQ7M+X80q4IcP3xcBwJGq90D+ZgA9ibT9nbZnu7HTdW3BcKYS4/GWn0vLMt87sGdN/3qaLiPiWhtM9qEDrnp4o4UvcoZ/K+GDgUj74g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788780562; c=relaxed/simple;
	bh=OKWVHn8a8Fq8ivUApIm9xrMq6PI1FstHuaOYm+wIjLw=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=GeWMuGzx4nxa6phKtAdpkRlkLspK3pqK7LRLAKvcJJgF2IkrcUhOqiMQvPDG7dZB3nbE5ZBAv8ztvRsGBxv0IWwRLY7Y86oUJ6Vrzy6C7H4TfIdMY3iABzxJGSIMrZIUcDKHI3EJoe8lTWJfEgTQklisLcEiofaKldJtk0jEcjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=c4oMSoqL; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="c4oMSoqL"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=4fLtlkBiuB0dKIEhq8WkQbH4a+Gvw+bg1tZRF8p4ypM=;
	b=c4oMSoqL0YUrS4sfQ++pg4ph+JJN4sR5nhLP4dbwj+wKTbFAC/kyoShweL7KYuCZpgyHPGvhX
	U+5X7SMb3aoPiSqkBhVDHWyRsK7g0V26OCQlGHvzd6H5clE9pL6UDgyIUoJuZDneYewndkGP2a+
	hzsEF/EGDNbi50vsViS+yWc=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4hdl1L48P7zcbN0;
	Mon,  7 Sep 2026 19:18:14 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 917894057A;
	Mon,  7 Sep 2026 19:29:09 +0800 (CST)
Received: from [10.67.109.254] (10.67.109.254) by
 kwepemk200008.china.huawei.com (7.202.194.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 7 Sep 2026 19:29:07 +0800
Message-ID: <75aeca50-74bf-4888-9dc8-7ac3c5af32ca@huawei.com>
Date: Mon, 7 Sep 2026 19:29:06 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/8] Convert barrier pairs to acquire/release for
 better performance
To: Petr Mladek <pmladek@suse.com>
CC: <bcrl@kvack.org>, <viro@zeniv.linux.org.uk>, <brauner@kernel.org>,
	<jack@suse.cz>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>,
	<libaokun@linux.alibaba.com>, <ojaswin@linux.ibm.com>,
	<ritesh.list@gmail.com>, <yi.zhang@huawei.com>, <sforshee@kernel.org>,
	<akpm@linux-foundation.org>, <rostedt@goodmis.org>,
	<andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>,
	<senozhatsky@chromium.org>, <kees@kernel.org>, <tglx@kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-aio@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-ext4@vger.kernel.org>,
	<linux-riscv@lists.infradead.org>
References: <20260902074805.398540-1-ruanjinjie@huawei.com>
 <apq5iLOF8lAQ_ZVU@pathway.suse.cz>
From: Jinjie Ruan <ruanjinjie@huawei.com>
In-Reply-To: <apq5iLOF8lAQ_ZVU@pathway.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemk200008.china.huawei.com (7.202.194.74)



在 2026/9/4 20:28, Petr Mladek 写道:
> Adding Risc-V list into Cc.
> 
> On Wed 2026-09-02 15:47:57, Jinjie Ruan wrote:
>> Hi,
>>
>> This series converts some existing smp_wmb()/smp_rmb() barrier pairs to
>> smp_store_release()/smp_load_acquire() across various subsystems.
>>
>> Background
>> ==========
>>
>> Many architectures support load acquire and store release instructions
>> which can replace explicit memory barriers and save cycles. As noted
>> in the ARM architecture reference [1]:
>>
>>   "Weaker ordering requirements that are imposed by Load-Acquire and
>>    Store-Release instructions allow for micro-architectural
>>    optimizations, which could reduce some of the performance impacts
>>    that are otherwise imposed by an explicit memory barrier.
>>
>>    If the ordering requirement is satisfied using either a Load-Acquire
>>    or Store-Release, then it would be preferable to use these
>>    instructions instead of a DMB."
>>
>> On arm64, a typical seqcount [2] read loop requires 13 cycles with DMB
>> barriers. Replacing the read barrier with smp_load_acquire() reduces
>> this to 8 cycles on an Ampere Altra.
> 
> I wonder if this is true on all other architectures:
> 
>   + It seems that Arm gets the gain because the instruction
>     does both load/store + barrier. It helps even when
>     the barrier is full.
> 
>   + Some other architectures need two instructions. One for the
>     load/store and the other for the barrier. But the barrier
>     is weaker, it synchronizes just reads or just writes.
> 
> For example, I see the following in riscv/include/asm/barrier.h:
> 
> <paste riscv/include/asm/barrier.h>
> #define smp_mb()	RISCV_FENCE(rw, rw)
> #define smp_rmb()	RISCV_FENCE(r, r)
> #define smp_wmb()	RISCV_FENCE(w, w)
> 
> #define smp_store_release(p, v)						\
> do {									\
> 	RISCV_FENCE(rw, w);						\
> 	WRITE_ONCE(*p, v);						\
> } while (0)
> 
> #define smp_load_acquire(p)						\
> ({									\
> 	typeof(*p) ___p1 = READ_ONCE(*p);				\
> 	RISCV_FENCE(r, rw);						\
> 	___p1;								\
> })
> </paste riscv/include/asm/barrier.h>
> 
> I wonder whether:
> 
>   + RISCV_FENCE(r, r) is faster than RISCV_FENCE(r, rw)
>   + RISCV_FENCE(w, w) is faster than RISCV_FENCE(rw, w)
> 
> so it might cause performance regression there...

Hi Petr,

Thanks for the detailed analysis. You're right that on some
architectures the acquire/release variants use a slightly heavier
fence than the plain smp_wmb()/smp_rmb() pair. The full picture by
architecture:

  arm64:    Improvement   (DMB ISHST/ISHLD + STR/LDR → STLR/LDAR)
  x86:      Neutral       (both are compiler barriers)
  s390:     Neutral       (both are compiler barriers)
  ppc64:    Neutral       (both use lwsync)
  loongarch: Slightly heavier fence (DBAR(o_w_w) → DBAR(orw_w),
                           DBAR(or_r_) → DBAR(or_rw))
  riscv:    Slightly heavier fence (fence w,w → fence rw,w,
                           fence r,r → fence r,rw)

So on Loongarch and Riscv, there may be a slight performance regression.

Regards,
Jinjie

> 
> Best Regards,
> Petr
> 
>> We also observed significant barrier overhead while profiling Unxibench
>> syscall test on arm64: a single getuid() call is ~8ns slower than on
>> a comparable x86 system, with the dominant cost in map_id_up()'s smp_rmb(),
>> which is a DMB ISHLD on arm64. Converting it to smp_load_acquire() allows
>> the use of LDAR, eliminating the measurable overhead.
>>
>> This motivated a broader search for existing barrier pairs that can
>> be converted to the lighter acquire/release semantics.
>>
>> Changes
>> =======
>>
>> Each patch in this series targets a specific barrier pair where the
>> publish/subscribe pattern is already present:
>>
>> - Writers populate data, then publish a flag/count/pointer via
>>   smp_store_release()
>>
>> - Readers load the flag/count/pointer via smp_load_acquire(), then
>>   consume the data
>>
>> This preserves the existing memory ordering guarantees while allowing
>> architectures with native acquire/release instructions (e.g. arm64's
>> STLR/LDAR) to avoid the cost of full one-way barriers (DMB ISHST/ISHLD).
>> On architectures without native support, the generated code is
>> generally no worse than the explicit barrier pair.
>>
>> The conversions are mechanical and no functional change is intended.
>>
>> Testing (Kunpeng HIP09 arm64 server)
>> ====================================
>>
>> 1. UNIXBENCH syscall
>> 	Baseline: 715.27
>> 	Patched:  718.83
>> 	Improvement: +0.50%
>>
>> 2. fs/aio (fio + null_blk, 4 jobs):
>> 	Baseline: 1441k IOPS, 86.46us
>> 	Patched:  1452k IOPS, 85.80us
>> 	Improvement: ~0.8%
>>
>> Both improvements are consistent across runs and align with the
>> expected savings from replacing DMB with LDAR/STLR on arm64.
>>
>> [1]: https://support.arm.com/documentation/102336/0100/Load-Acquire-and-Store-Release-instructions
>> [2]: https://github.com/torvalds/linux/commit/d0dd066a0fa26d55c19ace9e89dedd9504c5bcba
>>
>> Changes in v3:
>> - Add Reviewed-by.
>> - Split out network patch set as Kuniyuki suggested.
>> - Link to v2: https://lore.kernel.org/all/20260901024234.135119-1-ruanjinjie@huawei.com/
>>
>> Changes in v2:
>> - Fix pre-existing issue for ext4 and 8021q [3].
>> - Fix missing copy_mnt_idmap() udapte [3].
>> - Drop nacked isotp patch.
>> - Add test data.
>> - Add Reviewed-by and update fs patch as Jan suggested.
>>
>> [3]: https://sashiko.dev/#/patchset/20260825095422.3166067-1-ruanjinjie%40huawei.com
>>
>> Jinjie Ruan (8):
>>   user_namespace: Use acquire/release for nr_extents synchronization
>>   lib/vsprintf: Use acquire/release for ptr_key publication
>>   fs: aio: Use acquire/release for ring->tail publication
>>   fs: Use acquire/release for fdtable resize synchronization
>>   pidfs: Use test_bit_acquire() for attr flag tests
>>   super: Use acquire for SB_BORN check in super_cache_count()
>>   ext4: Fix out-of-bounds read in ext4_get_group_info()
>>   ext4: Convert group-count barrier protocol to acquire/release
>>
>>  fs/aio.c                | 10 ++++------
>>  fs/ext4/balloc.c        |  2 +-
>>  fs/ext4/ext4.h          | 10 +++-------
>>  fs/ext4/mballoc.c       |  6 ++----
>>  fs/ext4/resize.c        | 19 +++++++++++--------
>>  fs/file.c               | 10 ++++------
>>  fs/mnt_idmapping.c      |  5 ++---
>>  fs/pidfs.c              |  6 ++----
>>  fs/super.c              |  6 ++----
>>  kernel/user_namespace.c | 24 +++++++++++++-----------
>>  lib/vsprintf.c          | 11 ++++-------
>>  11 files changed, 48 insertions(+), 61 deletions(-)
>>
>> -- 
>> 2.34.1

