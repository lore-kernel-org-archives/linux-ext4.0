Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE07B483BE6
	for <linux-ext4@vger.kernel.org>; Fri,  4 Sep 2026 12:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788524947; cv=none; b=rOKRjrzwgUk8Dqq3OwRvaaOO8SoZfiavwiVZPOomx9hDfiCbxOpHOaJb7KsylqNdo5BGjKu2Wico7+wefhv3vU2trv8CCDOfrdI3JeC9rnNX7ASgc+kk7gtbTulCP3qvDY6pv3f7j4zTnihC0G5nZC5SNoiX68xcZcFtdeO7kis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788524947; c=relaxed/simple;
	bh=kINVtp9Tcy1uzfSPCqgfZTuR0AXIWvwWWaRfnsIc6rA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fUYxJprMb71euTxxEqoYhalwpDeVf56nKEHIa6jbiocuZNw6KA2S3Gx/6EjZlZRWZbWRHquy9Urjh8W5+7TfiWwmHIHmYqvMXyfI5e7lfInJ9GXDBad6YbFb7y+84H+VDF2P52S33MOTErK5rQ5jo3+PDDTrfg6apTaXpdvKNZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=FLRum3bq; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="FLRum3bq"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-49557167508so10887045e9.1
        for <linux-ext4@vger.kernel.org>; Fri, 04 Sep 2026 05:29:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788524943; x=1789129743; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wkKTYWKeG6QUBS922LjHNIJ7+OwGoSgdldmULUcOoY0=;
        b=FLRum3bq1lZ3U2Gd6coMiXmJFGW9qU5xja7kx5zuN9ok69HeBwY7dguWoZeh+1Mvv3
         6uX3G81Lc83NRC/CS8JoVpfcZhdkqvgAZg8Mo0Tg7eD5Enc0keuwB3bzaoMLFy5XmH+N
         FsRyQO+b/NAEeKSlV3JHudCYjpKnDy+YOMLk7DS6tESNL5XYvBGsLOXdmQMrzgejQRW2
         Y22yq1vhe0UoW1DyYFRlU0WIQR8P1vjO86uI4Pgl7MvybychsK3nt8oPAzhxkQnjGwgQ
         WhM8cKkUr1yfMx0ScnxcCHjRcMtnpnGAD15yhBdr8ezEt33dJ0mY7Ton+SZQu/IwPhZQ
         lJXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788524943; x=1789129743;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wkKTYWKeG6QUBS922LjHNIJ7+OwGoSgdldmULUcOoY0=;
        b=SFQhmZknff+BQfOqKDvg/k+OWNeX132IyNfSkm0ce2kjWEdMAIGunHVa+7v2srp7B4
         oxkPwZqoe83One5FdNLZltoRp/sslfcM3iOqu/p9DJpNgmWAapcYqgVIoY1SFqWTAlq8
         VPOAf1k3rnUt7KBPQJpv0EESrLWghp6HNfVeh+thnyc70MxavUWHhOFeIIZLALwlLQ4o
         GA4720ug8ayKnGgJUDmSr3G7YIBAn2VBCHT8D6evMr7jschtHRf5hVbGvZTrrIJr3vmF
         +xITXOfWO9I4Cf2WDE3i1Su+qQlNe8lZKoDIqCZNr2J2ovGX7VIJKcQwVRRtMIoQ6qgD
         vGxw==
X-Forwarded-Encrypted: i=1; AKwUvBytamL4u895Fiss8ShPhiP2M38LiNMau+gibwqVXeWaxMpKgSncn4oBb5YU9Z+pEiXe66AUHnoQdO3X@vger.kernel.org
X-Gm-Message-State: AFuF++kwctWPor9nUkUAtrBrUzs3aM2/oU+lvMCxlbmu3xv3TRi9H7N2
	SbwFEmj77lyVtZBREopsQ1sKbnI94sBE7qw9bm9h2Fue4z2sfYYc7DFGrC1259yPgcw=
X-Gm-Gg: AYBFou2HR1KNdAwgH3v/w/lUk5Ei/zQ7u/UXh0sDVkDHY39S0OFVj5TmA4oDy+srBKw
	1ItZjlB/ZsQK01Xoybyij5k9AAHK/tVT8KjNA3I/N3I9HHl4ZBvLu2uWFaiO6H9VEToB/8HU+lw
	VpdcLsK2OvQ53wwG3hzrWf9rtomOmg42KNlHtkWINUWb4j2NOoLYYSk2hTYAiTjDBcTN7Ia+fum
	QJoXWhDPe1CrJRZcd5VJiN/H3kB96b3o47yvD5FGAF9a7vKqjU3dAJscBMM0N2HRpcBagHU7Cu5
	MaZkLS0i8iN8lhfW1GcOXEP8yrfHl4O86QfBB91KyshI70E/OiKctc10BbWc9pVNcMmJJbqRZgl
	DXz8AjfmazEpldkMSqxOfJ84mjRw8duI66/aMvRaqwfIv3OL2pGnKks/NMHjlW5d15IZ21sNsk+
	e94bfrateSNp7tU0EjiJyNoBtjwAqIEhUwRh17arPlFrF64IzGyVoC38i4s88vig==
X-Received: by 2002:a05:600c:6087:b0:49c:d52e:d0ea with SMTP id 5b1f17b1804b1-49cf81e3454mr99528635e9.4.1788524939473;
        Fri, 04 Sep 2026 05:28:59 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cee5f912esm153375065e9.4.2026.09.04.05.28.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 05:28:58 -0700 (PDT)
Date: Fri, 4 Sep 2026 14:28:56 +0200
From: Petr Mladek <pmladek@suse.com>
To: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: bcrl@kvack.org, viro@zeniv.linux.org.uk, brauner@kernel.org,
	jack@suse.cz, tytso@mit.edu, adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com, ojaswin@linux.ibm.com,
	ritesh.list@gmail.com, yi.zhang@huawei.com, sforshee@kernel.org,
	akpm@linux-foundation.org, rostedt@goodmis.org,
	andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk,
	senozhatsky@chromium.org, kees@kernel.org, tglx@kernel.org,
	linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-riscv@lists.infradead.org
Subject: Re: [PATCH v3 0/8] Convert barrier pairs to acquire/release for
 better performance
Message-ID: <apq5iLOF8lAQ_ZVU@pathway.suse.cz>
References: <20260902074805.398540-1-ruanjinjie@huawei.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902074805.398540-1-ruanjinjie@huawei.com>

Adding Risc-V list into Cc.

On Wed 2026-09-02 15:47:57, Jinjie Ruan wrote:
> Hi,
> 
> This series converts some existing smp_wmb()/smp_rmb() barrier pairs to
> smp_store_release()/smp_load_acquire() across various subsystems.
> 
> Background
> ==========
> 
> Many architectures support load acquire and store release instructions
> which can replace explicit memory barriers and save cycles. As noted
> in the ARM architecture reference [1]:
> 
>   "Weaker ordering requirements that are imposed by Load-Acquire and
>    Store-Release instructions allow for micro-architectural
>    optimizations, which could reduce some of the performance impacts
>    that are otherwise imposed by an explicit memory barrier.
> 
>    If the ordering requirement is satisfied using either a Load-Acquire
>    or Store-Release, then it would be preferable to use these
>    instructions instead of a DMB."
> 
> On arm64, a typical seqcount [2] read loop requires 13 cycles with DMB
> barriers. Replacing the read barrier with smp_load_acquire() reduces
> this to 8 cycles on an Ampere Altra.

I wonder if this is true on all other architectures:

  + It seems that Arm gets the gain because the instruction
    does both load/store + barrier. It helps even when
    the barrier is full.

  + Some other architectures need two instructions. One for the
    load/store and the other for the barrier. But the barrier
    is weaker, it synchronizes just reads or just writes.

For example, I see the following in riscv/include/asm/barrier.h:

<paste riscv/include/asm/barrier.h>
#define smp_mb()	RISCV_FENCE(rw, rw)
#define smp_rmb()	RISCV_FENCE(r, r)
#define smp_wmb()	RISCV_FENCE(w, w)

#define smp_store_release(p, v)						\
do {									\
	RISCV_FENCE(rw, w);						\
	WRITE_ONCE(*p, v);						\
} while (0)

#define smp_load_acquire(p)						\
({									\
	typeof(*p) ___p1 = READ_ONCE(*p);				\
	RISCV_FENCE(r, rw);						\
	___p1;								\
})
</paste riscv/include/asm/barrier.h>

I wonder whether:

  + RISCV_FENCE(r, r) is faster than RISCV_FENCE(r, rw)
  + RISCV_FENCE(w, w) is faster than RISCV_FENCE(rw, w)

so it might cause performance regression there...

Best Regards,
Petr

> We also observed significant barrier overhead while profiling Unxibench
> syscall test on arm64: a single getuid() call is ~8ns slower than on
> a comparable x86 system, with the dominant cost in map_id_up()'s smp_rmb(),
> which is a DMB ISHLD on arm64. Converting it to smp_load_acquire() allows
> the use of LDAR, eliminating the measurable overhead.
> 
> This motivated a broader search for existing barrier pairs that can
> be converted to the lighter acquire/release semantics.
> 
> Changes
> =======
> 
> Each patch in this series targets a specific barrier pair where the
> publish/subscribe pattern is already present:
> 
> - Writers populate data, then publish a flag/count/pointer via
>   smp_store_release()
> 
> - Readers load the flag/count/pointer via smp_load_acquire(), then
>   consume the data
> 
> This preserves the existing memory ordering guarantees while allowing
> architectures with native acquire/release instructions (e.g. arm64's
> STLR/LDAR) to avoid the cost of full one-way barriers (DMB ISHST/ISHLD).
> On architectures without native support, the generated code is
> generally no worse than the explicit barrier pair.
> 
> The conversions are mechanical and no functional change is intended.
> 
> Testing (Kunpeng HIP09 arm64 server)
> ====================================
> 
> 1. UNIXBENCH syscall
> 	Baseline: 715.27
> 	Patched:  718.83
> 	Improvement: +0.50%
> 
> 2. fs/aio (fio + null_blk, 4 jobs):
> 	Baseline: 1441k IOPS, 86.46us
> 	Patched:  1452k IOPS, 85.80us
> 	Improvement: ~0.8%
> 
> Both improvements are consistent across runs and align with the
> expected savings from replacing DMB with LDAR/STLR on arm64.
> 
> [1]: https://support.arm.com/documentation/102336/0100/Load-Acquire-and-Store-Release-instructions
> [2]: https://github.com/torvalds/linux/commit/d0dd066a0fa26d55c19ace9e89dedd9504c5bcba
> 
> Changes in v3:
> - Add Reviewed-by.
> - Split out network patch set as Kuniyuki suggested.
> - Link to v2: https://lore.kernel.org/all/20260901024234.135119-1-ruanjinjie@huawei.com/
> 
> Changes in v2:
> - Fix pre-existing issue for ext4 and 8021q [3].
> - Fix missing copy_mnt_idmap() udapte [3].
> - Drop nacked isotp patch.
> - Add test data.
> - Add Reviewed-by and update fs patch as Jan suggested.
> 
> [3]: https://sashiko.dev/#/patchset/20260825095422.3166067-1-ruanjinjie%40huawei.com
> 
> Jinjie Ruan (8):
>   user_namespace: Use acquire/release for nr_extents synchronization
>   lib/vsprintf: Use acquire/release for ptr_key publication
>   fs: aio: Use acquire/release for ring->tail publication
>   fs: Use acquire/release for fdtable resize synchronization
>   pidfs: Use test_bit_acquire() for attr flag tests
>   super: Use acquire for SB_BORN check in super_cache_count()
>   ext4: Fix out-of-bounds read in ext4_get_group_info()
>   ext4: Convert group-count barrier protocol to acquire/release
> 
>  fs/aio.c                | 10 ++++------
>  fs/ext4/balloc.c        |  2 +-
>  fs/ext4/ext4.h          | 10 +++-------
>  fs/ext4/mballoc.c       |  6 ++----
>  fs/ext4/resize.c        | 19 +++++++++++--------
>  fs/file.c               | 10 ++++------
>  fs/mnt_idmapping.c      |  5 ++---
>  fs/pidfs.c              |  6 ++----
>  fs/super.c              |  6 ++----
>  kernel/user_namespace.c | 24 +++++++++++++-----------
>  lib/vsprintf.c          | 11 ++++-------
>  11 files changed, 48 insertions(+), 61 deletions(-)
> 
> -- 
> 2.34.1
