Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00AEB43E9C4;
	Tue,  1 Sep 2026 03:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788232562; cv=none; b=AUYoFpCYSNhaytgvV7kfiK5cbEBYxr00JGviePUNE1q1otNnGGh0samiBihFkRQLIrvXRPVYh+70Lr/V/UAi8+6TcyE8yuJC6u0frnTw5531SD80PSPrSg2KqQ96Yf8Ss5uV2aLvJjz1RgbfiGrEPraWaERe2QCf13lcPLMU/VA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788232562; c=relaxed/simple;
	bh=V1bUC+/lDCCo4l7b2hK3qfnCxXY0H+tuM3jjVfYzVwM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=mYbPFsogl7u6qt7elQ78i9nnFXiPbv8zBJV1UIc/CEq+FaAQLBYUo1x7ZC33Xotq3ZpfyJ/+PZwrRNQk6dOheryo0+9uaMO2SFvjEERAXWd2exTOsm9lVBTedHFKrqBBafw+I93pJ44QTUserZItrH6g/yQrU1IyntPtu6X965I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=V/yAA/Ix; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="V/yAA/Ix"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=oUQ/YTa/1mG2j39KLvS1EbbceLawdW30azQdvmyUyzY=;
	b=V/yAA/IxI9uN3fPx8l6sxvfsOVZy5FI8qZTClwaQpVQkzkp/xs+l4Mrh1Ld1SrWYlXW5G4+6l
	p9LjsrblNLNlG8PwOFsWwm48id2Ap6h+0cWB8mcYKzd0yXkIHDKPOAtDgc/DaYZqkQR3gxrjVH6
	SxgdpobUTZwNOsECONAeKBE=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4hYrMB4GpMzcb1N;
	Tue,  1 Sep 2026 11:05:10 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id E476B40561;
	Tue,  1 Sep 2026 11:15:53 +0800 (CST)
Received: from [10.67.109.254] (10.67.109.254) by
 dggpemf500011.china.huawei.com (7.185.36.131) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 1 Sep 2026 11:15:51 +0800
Message-ID: <64b8c520-808c-4d0f-aaa5-cb388f473ecf@huawei.com>
Date: Tue, 1 Sep 2026 11:15:50 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/12] Convert barrier pairs to acquire/release for
 better performance
To: Kuniyuki Iwashima <kuniyu@google.com>
CC: <viro@zeniv.linux.org.uk>, <brauner@kernel.org>, <jack@suse.cz>,
	<bcrl@kvack.org>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>,
	<libaokun@linux.alibaba.com>, <ojaswin@linux.ibm.com>,
	<ritesh.list@gmail.com>, <yi.zhang@huawei.com>, <sforshee@kernel.org>,
	<pmladek@suse.com>, <rostedt@goodmis.org>,
	<andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>,
	<senozhatsky@chromium.org>, <akpm@linux-foundation.org>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <horms@kernel.org>, <willemb@google.com>,
	<jhs@mojatatu.com>, <jiri@resnulli.us>, <kees@kernel.org>,
	<cyphar@cyphar.com>, <tglx@kernel.org>, <sdf@fomichev.me>, <nb@tipi-net.de>,
	<liuhangbin@gmail.com>, <da-x@monatomic.org>, <jeff@garzik.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-aio@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-ext4@vger.kernel.org>,
	<netdev@vger.kernel.org>
References: <20260901024234.135119-1-ruanjinjie@huawei.com>
 <CAAVpQUAR93t6CDrUzXt-v9qECSFHwYoofR4qinV5mty6LS7mJA@mail.gmail.com>
From: Jinjie Ruan <ruanjinjie@huawei.com>
In-Reply-To: <CAAVpQUAR93t6CDrUzXt-v9qECSFHwYoofR4qinV5mty6LS7mJA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf500011.china.huawei.com (7.185.36.131)



在 2026/9/1 11:06, Kuniyuki Iwashima 写道:
> On Mon, Aug 31, 2026 at 7:42 PM Jinjie Ruan <ruanjinjie@huawei.com> wrote:
>>
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
>>
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
>> Testing (arm64 Kunpeng HIP09 server)
>> ================
>>
>> 1. UNIXBENCH syscall
>>         Baseline: 715.27
>>         Patched:  718.83
>>         Improvement: +0.50%
>>
>> 2. fs/aio (fio + null_blk, 4 jobs):
>>         Baseline: 1441k IOPS, 86.46us
>>         Patched:  1452k IOPS, 85.80us
>>         Improvement: ~0.8%
>>
>> 3. soreuseport (wrk, 8 servers):
>>         Baseline: 162.6k req/s, 452.5us
>>         Patched:  164.2k req/s, 449.4us
>>         Improvement: ~1.0%
>>
>> Both improvements are consistent across runs and align with the
>> expected savings from replacing DMB with LDAR/STLR on arm64.
>>
>> [1]: https://support.arm.com/documentation/102336/0100/Load-Acquire-and-Store-Release-instructions
>> [2]: https://github.com/torvalds/linux/commit/d0dd066a0fa26d55c19ace9e89dedd9504c5bcba
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
>> Jinjie Ruan (12):
>>   user_namespace: Use acquire/release for nr_extents synchronization
>>   lib/vsprintf: Use acquire/release for ptr_key publication
>>   fs: aio: Use acquire/release for ring->tail publication
>>   fs: Use acquire/release for fdtable resize synchronization
>>   pidfs: Use test_bit_acquire() for attr flag tests
>>   super: Use acquire for SB_BORN check in super_cache_count()
>>   ext4: Fix out-of-bounds read in ext4_get_group_info()
>>   ext4: Convert group-count barrier protocol to acquire/release
>>   soreuseport: publish num_socks with acquire/release
>>   net: sched: act_gact: use acquire/release for tcfg_ptype
>>   8021q: Fix data race when publishing vlan net_device pointers
>>   8021q: publish vlan_devices_arrays entries with acquire/release
> 
> Please post networking patches separately with the target tree specified:
> 
>   Subject: [PATCH vX net-next] soreuseport: ...
> 
> 8021q changes can be posted a series.

Thanks for the review. I will split the series as suggested — the
networking patches will be posted separately.

