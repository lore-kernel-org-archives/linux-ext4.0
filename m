Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C948E4CB8A7
	for <linux-ext4@vger.kernel.org>; Mon,  7 Sep 2026 12:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788786007; cv=none; b=RyyHGO3+sigtu2G9zAw/KFJzVpH4J9Cq1xgMAGXgC5agAj63P3PYE1r7zs49BDtYlqUb9kcFJM6YfoM9XaZk1eZrO9+62C37HJgi0J0soRX8YSIi4j5moP3XjdGvStIL0bLzHGVf5DpXNsLbpwrC92+2WNT2r7dXv8pUNf3U2dQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788786007; c=relaxed/simple;
	bh=MsqzCNMXKgqeUkLsZ9coMgcq3LkVtrXXQE4c14xpLRQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KbFq3rCdZavr+LiqaC/ZEZyXMlgKUIYs3LzUZnzNef3V6tJVhXrDbSsIyKLw4HoV/JDax14FPyweT9SmJgz6Iolm3C/65VRqUVjQ9sxueK6MQarucURI0ZGLbJBV8tGoNUqwKgdYJML0VjLVvo4HssN+zhHnVl5Cw0awNXnQjbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EsvfzIpD; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EsvfzIpD"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-49a97714f5dso33601985e9.0
        for <linux-ext4@vger.kernel.org>; Mon, 07 Sep 2026 05:59:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788785989; x=1789390789; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Fedd1Lk8v7XqLnYfi6ACsWWe1EX73jfitPVMPywY8zQ=;
        b=EsvfzIpDk1Gg9gKQ3ZOoXw3mDHedpnFH68K1g2JEzvuenU5jWodHUgfrCXWAEaVorU
         CQHxb6dOnuVXeHohrRXqzSjtn9CNiuCfyhejsTyE9ni2cQsGhoLg1T730cFBIBW4hdW8
         Gc43SSPhQQndZMVwULTWP47r6KEXUddCgWR6EQqdy9sv+50Nvz9AEllRUXQQEsKgbmSa
         sjt5Tn0yO6Jbo//Tmg5SXyTp3y+Y1gr1dscH99VF+EeDSUDrF/Dp2Z2QJlZG68xDphfy
         M8Eurth/LM5OETfLN0nfjHtyE98chFhUkcIO4ZL7J/cFJuWtgVQTYu+NNMm0iUlLDWo1
         4v9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788785989; x=1789390789;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Fedd1Lk8v7XqLnYfi6ACsWWe1EX73jfitPVMPywY8zQ=;
        b=EX375GqQToicWgDzYzvMGy3VnBiM9LjlJBvspEo+mK5R0Qu6Q5ayLk05+kGc6NC5C2
         2H+CJuFZ13HCYP+w1G+/AXJsrXnLGnFehifxZDRhE62hKDG4CKB+J4ulyrKIktTH5SPt
         JUDrKW3cr9v2JhoG7vGC9KFN4pnRZHdVMMrfi/6vlAniRPA5Q9+Km7YeRaC6cbQeS3cP
         g/kB2cDgT/HrsGueDMGZdICNa3xaAdlLZm/WAU/5bxTZikVKTzOmiwsp5xmb0g1eC+nH
         6PHe28V3MBHucB1elW19Aqp5iZpG9IwJfLNuxp2YbbKsV0MjLmGEi3GTfO6IXjEwOwZn
         Ymhg==
X-Forwarded-Encrypted: i=1; AKwUvBymrdYKmRoB9ZXXO5AR9wEURChT+fG3YQp2EEvQF3xYR5ZWcY2c9PYstFszpy8GTVZSWI+vQ8Qhe6ex@vger.kernel.org
X-Gm-Message-State: AFuF++mccU5M89V0h14iRlSPea/EMtynNo3+GKLCLaW9Oafp9HEcpffe
	c0LNU4ksEjEuldNe62lBdSCMO3feBT+NCitrap1Y2REmvT/jTye/djNR
X-Gm-Gg: AYBFou0D3G3g5wtKFF/hqgZsE9D717sfJqejq9pI+bzNgwJcUH/EKfK6NYe1y35pgf8
	q5lOZCe1wk5NZlgf/kmMf2HlciTwIdPwFqJEoKdAC2tFtx2U/WC8vY6+duNJavBbLn3yW8XYUUH
	UlHEOE8DeTFAeQWk6aGZ1YoO5cOQLL+O5jHF9FtsaqwojE3Ex20UNrIjh9ng0tEhfAB30OEEFzw
	Ipj95/34yu5CLjPbLm28ZpkftsQ0QCwguDv10TaDeje4Qnpio8g5iUODZA1Z6htQsAYzmgYVOiA
	PnHL2nzwjpiE/TmZGE2jMFaMbUM5Uku6yt2vaetfgBLEMoA8BVb0bgBneCibiTWipTbhItPtwU1
	3VxJPRco231bfgjkg3kfk/gB+gj2GJl2gbG0zz1GssrplVFlikxWEO2UtQxzBoWufpKXwg2k70b
	9fcehA323wrn87xR4d/ag5SpRpfb92JKA8e3qlmzk+fOCSOhkfCRy14ikKwaRWgt4oaRy8/75Ny
	TBpRsPkZDJIxcGijTHnyBnVug==
X-Received: by 2002:a05:600c:c162:b0:49d:16dc:e721 with SMTP id 5b1f17b1804b1-49d16dce7aamr16981995e9.24.1788785988330;
        Mon, 07 Sep 2026 05:59:48 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cf770fcf5sm306405115e9.6.2026.09.07.05.59.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 05:59:47 -0700 (PDT)
Date: Mon, 7 Sep 2026 13:59:46 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: Petr Mladek <pmladek@suse.com>, <bcrl@kvack.org>,
 <viro@zeniv.linux.org.uk>, <brauner@kernel.org>, <jack@suse.cz>,
 <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
 <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>, <yi.zhang@huawei.com>,
 <sforshee@kernel.org>, <akpm@linux-foundation.org>, <rostedt@goodmis.org>,
 <andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>,
 <senozhatsky@chromium.org>, <kees@kernel.org>, <tglx@kernel.org>,
 <linux-fsdevel@vger.kernel.org>, <linux-aio@kvack.org>,
 <linux-kernel@vger.kernel.org>, <linux-ext4@vger.kernel.org>,
 <linux-riscv@lists.infradead.org>
Subject: Re: [PATCH v3 0/8] Convert barrier pairs to acquire/release for
 better performance
Message-ID: <20260907135946.2541aa7e@pumpkin>
In-Reply-To: <75aeca50-74bf-4888-9dc8-7ac3c5af32ca@huawei.com>
References: <20260902074805.398540-1-ruanjinjie@huawei.com>
	<apq5iLOF8lAQ_ZVU@pathway.suse.cz>
	<75aeca50-74bf-4888-9dc8-7ac3c5af32ca@huawei.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 7 Sep 2026 19:29:06 +0800
Jinjie Ruan <ruanjinjie@huawei.com> wrote:

> =E5=9C=A8 2026/9/4 20:28, Petr Mladek =E5=86=99=E9=81=93:
> > Adding Risc-V list into Cc.
> >=20
> > On Wed 2026-09-02 15:47:57, Jinjie Ruan wrote: =20
> >> Hi,
> >>
> >> This series converts some existing smp_wmb()/smp_rmb() barrier pairs to
> >> smp_store_release()/smp_load_acquire() across various subsystems.
> >>
> >> Background
> >> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>
> >> Many architectures support load acquire and store release instructions
> >> which can replace explicit memory barriers and save cycles. As noted
> >> in the ARM architecture reference [1]:
> >>
> >>   "Weaker ordering requirements that are imposed by Load-Acquire and
> >>    Store-Release instructions allow for micro-architectural
> >>    optimizations, which could reduce some of the performance impacts
> >>    that are otherwise imposed by an explicit memory barrier.
> >>
> >>    If the ordering requirement is satisfied using either a Load-Acquire
> >>    or Store-Release, then it would be preferable to use these
> >>    instructions instead of a DMB."
> >>
> >> On arm64, a typical seqcount [2] read loop requires 13 cycles with DMB
> >> barriers. Replacing the read barrier with smp_load_acquire() reduces
> >> this to 8 cycles on an Ampere Altra. =20
> >=20
> > I wonder if this is true on all other architectures:
> >=20
> >   + It seems that Arm gets the gain because the instruction
> >     does both load/store + barrier. It helps even when
> >     the barrier is full.
> >=20
> >   + Some other architectures need two instructions. One for the
> >     load/store and the other for the barrier. But the barrier
> >     is weaker, it synchronizes just reads or just writes.
> >=20
> > For example, I see the following in riscv/include/asm/barrier.h:
> >=20
> > <paste riscv/include/asm/barrier.h>
> > #define smp_mb()	RISCV_FENCE(rw, rw)
> > #define smp_rmb()	RISCV_FENCE(r, r)
> > #define smp_wmb()	RISCV_FENCE(w, w)
> >=20
> > #define smp_store_release(p, v)						\
> > do {									\
> > 	RISCV_FENCE(rw, w);						\
> > 	WRITE_ONCE(*p, v);						\
> > } while (0)
> >=20
> > #define smp_load_acquire(p)						\
> > ({									\
> > 	typeof(*p) ___p1 =3D READ_ONCE(*p);				\
> > 	RISCV_FENCE(r, rw);						\
> > 	___p1;								\
> > })
> > </paste riscv/include/asm/barrier.h>
> >=20
> > I wonder whether:
> >=20
> >   + RISCV_FENCE(r, r) is faster than RISCV_FENCE(r, rw)
> >   + RISCV_FENCE(w, w) is faster than RISCV_FENCE(rw, w)
> >=20
> > so it might cause performance regression there... =20
>=20
> Hi Petr,
>=20
> Thanks for the detailed analysis. You're right that on some
> architectures the acquire/release variants use a slightly heavier
> fence than the plain smp_wmb()/smp_rmb() pair. The full picture by
> architecture:
>=20
>   arm64:    Improvement   (DMB ISHST/ISHLD + STR/LDR =E2=86=92 STLR/LDAR)
>   x86:      Neutral       (both are compiler barriers)
>   s390:     Neutral       (both are compiler barriers)
>   ppc64:    Neutral       (both use lwsync)
>   loongarch: Slightly heavier fence (DBAR(o_w_w) =E2=86=92 DBAR(orw_w),
>                            DBAR(or_r_) =E2=86=92 DBAR(or_rw))
>   riscv:    Slightly heavier fence (fence w,w =E2=86=92 fence rw,w,
>                            fence r,r =E2=86=92 fence r,rw)
>=20
> So on Loongarch and Riscv, there may be a slight performance regression.

Is that a bug in the riscv definitions?
Nothing in the commit messages seems to indicate why the stronger barriers
are used.
The original commit 8d235b17 was done to avoid the rw,rw barrier in the
generic code (which might since have been relaxed).

David

>=20
> Regards,
> Jinjie
>=20
> >=20
> > Best Regards,
> > Petr
> >  =20
> >> We also observed significant barrier overhead while profiling Unxibench
> >> syscall test on arm64: a single getuid() call is ~8ns slower than on
> >> a comparable x86 system, with the dominant cost in map_id_up()'s smp_r=
mb(),
> >> which is a DMB ISHLD on arm64. Converting it to smp_load_acquire() all=
ows
> >> the use of LDAR, eliminating the measurable overhead.
> >>
> >> This motivated a broader search for existing barrier pairs that can
> >> be converted to the lighter acquire/release semantics.
> >>
> >> Changes
> >> =3D=3D=3D=3D=3D=3D=3D
> >>
> >> Each patch in this series targets a specific barrier pair where the
> >> publish/subscribe pattern is already present:
> >>
> >> - Writers populate data, then publish a flag/count/pointer via
> >>   smp_store_release()
> >>
> >> - Readers load the flag/count/pointer via smp_load_acquire(), then
> >>   consume the data
> >>
> >> This preserves the existing memory ordering guarantees while allowing
> >> architectures with native acquire/release instructions (e.g. arm64's
> >> STLR/LDAR) to avoid the cost of full one-way barriers (DMB ISHST/ISHLD=
).
> >> On architectures without native support, the generated code is
> >> generally no worse than the explicit barrier pair.
> >>
> >> The conversions are mechanical and no functional change is intended.
> >>
> >> Testing (Kunpeng HIP09 arm64 server)
> >> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>
> >> 1. UNIXBENCH syscall
> >> 	Baseline: 715.27
> >> 	Patched:  718.83
> >> 	Improvement: +0.50%
> >>
> >> 2. fs/aio (fio + null_blk, 4 jobs):
> >> 	Baseline: 1441k IOPS, 86.46us
> >> 	Patched:  1452k IOPS, 85.80us
> >> 	Improvement: ~0.8%
> >>
> >> Both improvements are consistent across runs and align with the
> >> expected savings from replacing DMB with LDAR/STLR on arm64.
> >>
> >> [1]: https://support.arm.com/documentation/102336/0100/Load-Acquire-an=
d-Store-Release-instructions
> >> [2]: https://github.com/torvalds/linux/commit/d0dd066a0fa26d55c19ace9e=
89dedd9504c5bcba
> >>
> >> Changes in v3:
> >> - Add Reviewed-by.
> >> - Split out network patch set as Kuniyuki suggested.
> >> - Link to v2: https://lore.kernel.org/all/20260901024234.135119-1-ruan=
jinjie@huawei.com/
> >>
> >> Changes in v2:
> >> - Fix pre-existing issue for ext4 and 8021q [3].
> >> - Fix missing copy_mnt_idmap() udapte [3].
> >> - Drop nacked isotp patch.
> >> - Add test data.
> >> - Add Reviewed-by and update fs patch as Jan suggested.
> >>
> >> [3]: https://sashiko.dev/#/patchset/20260825095422.3166067-1-ruanjinji=
e%40huawei.com
> >>
> >> Jinjie Ruan (8):
> >>   user_namespace: Use acquire/release for nr_extents synchronization
> >>   lib/vsprintf: Use acquire/release for ptr_key publication
> >>   fs: aio: Use acquire/release for ring->tail publication
> >>   fs: Use acquire/release for fdtable resize synchronization
> >>   pidfs: Use test_bit_acquire() for attr flag tests
> >>   super: Use acquire for SB_BORN check in super_cache_count()
> >>   ext4: Fix out-of-bounds read in ext4_get_group_info()
> >>   ext4: Convert group-count barrier protocol to acquire/release
> >>
> >>  fs/aio.c                | 10 ++++------
> >>  fs/ext4/balloc.c        |  2 +-
> >>  fs/ext4/ext4.h          | 10 +++-------
> >>  fs/ext4/mballoc.c       |  6 ++----
> >>  fs/ext4/resize.c        | 19 +++++++++++--------
> >>  fs/file.c               | 10 ++++------
> >>  fs/mnt_idmapping.c      |  5 ++---
> >>  fs/pidfs.c              |  6 ++----
> >>  fs/super.c              |  6 ++----
> >>  kernel/user_namespace.c | 24 +++++++++++++-----------
> >>  lib/vsprintf.c          | 11 ++++-------
> >>  11 files changed, 48 insertions(+), 61 deletions(-)
> >>
> >> --=20
> >> 2.34.1 =20
>=20
>=20

