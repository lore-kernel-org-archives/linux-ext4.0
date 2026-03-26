Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FABE275B15
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 11:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774526286; cv=none; b=mhzv1I7mg3SuOburr7w8teVlcYfHIzYLFnAAX6//0Ujc0wck22Sn1nPFMbCDxb8Z+FReUqey3oNkk3/8vgiED7EnZBwz37YVdgOAL+6UZ4qOhx/Q+beSY8Yj3puSJlmNA74AvMbIMSk5rgovYC2hRm7YJWiKlN6f6/KyAe+lUQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774526286; c=relaxed/simple;
	bh=x4bNBQYRI/JAxRMDh79hNTTMf69TAFj4oByYiq1owH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JcbHuTXe6BHSFDJRUN0WpkoYmuKPKTSs1X1JVwzxU9gnrmMLdVWme7phNnInDjDm8XopCbCHoz2Ybgt50IcS/cr1Mds/ErzI7dyqkZdWg9v4sQATBBJcCB1PkjNWeMDJqk1Dv5nLWao2cXEiL0mc61APlrCBTGyhbXvGEbH3Pwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=PAmKY8eW; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="PAmKY8eW"
Received: from trampoline.thunk.org (pool-173-48-121-153.bstnma.fios.verizon.net [173.48.121.153])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 62QBvvv1020392
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 26 Mar 2026 07:57:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1774526278; bh=KBqyVQ63BWfpHdFjV6ef8LJgchG4hpcTW5bTGPHFAY0=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=PAmKY8eWIn37RpMUUKCmm2X5AMt2byE4H0qDoVdk47t+/nwuMCohA1i6Tk3xxlBMS
	 0aBD93K60/VSqjF02L4/MkEeNLnRmjXFPBkU7aWqpovx16joKX/jGieGh6SsjxCwUy
	 lPBqn682OX8aY0ulQKm3pmiYrswBVQvk+o0hxuYEjvwD4TKEoQqWWSsVz4jQCvG4sT
	 4cDom6xx/8OSXFgBbdvwvFI80drmGlF8Kddv+Iy0QYar07DanY3fQ+3AjRy+pb94Km
	 TjOVvgvqKen4hZmd1A7yjdnoPobLQAXO2mwu6zm8BAazHhcrj++RQwAhN0msmCN2WD
	 Z/uZbJ4/jTq+A==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id F13052E00DB; Thu, 26 Mar 2026 07:57:56 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Ojaswin Mujoo <ojaswin@linux.ibm.com>
Subject: Re: [PATCH] ext4: kunit: extents-test: Fix percpu_counters list corruption
Date: Thu, 26 Mar 2026 07:57:47 -0400
Message-ID: <177452625030.1205486.5434085458135808874.b4-ty@b4>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <5bb9041471dab8ce870c191c19cbe4df57473be8.1772381213.git.ritesh.list@gmail.com>
References: <5bb9041471dab8ce870c191c19cbe4df57473be8.1772381213.git.ritesh.list@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Sun, 01 Mar 2026 21:44:26 +0530, Ritesh Harjani (IBM) wrote:
> commit 82f80e2e3b23 ("ext4: add extent status cache support to kunit tests"),
> added ext4_es_register_shrinker() in extents_kunit_init() function but
> failed to add the unregister shrinker routine in extents_kunit_exit().
> 
> This could cause the following percpu_counters list corruption bug.
> 
>          ok 1 split unwrit extent to 2 extents and convert 1st half writ
>   slab kmalloc-4k start c0000002007ff000 pointer offset 1448 size 4096
>  list_add corruption. next->prev should be prev (c000000004bc9e60), but was 0000000000000000. (next=c0000002007ff5a8).
>  ------------[ cut here ]------------
>  kernel BUG at lib/list_debug.c:29!
> cpu 0x2: Vector: 700 (Program Check) at [c000000241927a30]
>     pc: c000000000f26ed0: __list_add_valid_or_report+0x120/0x164
>     lr: c000000000f26ecc: __list_add_valid_or_report+0x11c/0x164
>     sp: c000000241927cd0
>    msr: 800000000282b033
>   current = 0xc000000241215200
>   paca    = 0xc0000003fffff300   irqmask: 0x03   irq_happened: 0x09
>     pid   = 258, comm = kunit_try_catch
> kernel BUG at lib/list_debug.c:29!
> enter ? for help
>  __percpu_counter_init_many+0x148/0x184
>  ext4_es_register_shrinker+0x74/0x23c
>  extents_kunit_init+0x100/0x308
>  kunit_try_run_case+0x78/0x1f8
>  kunit_generic_run_threadfn_adapter+0x40/0x70
>  kthread+0x190/0x1a0
>  start_kernel_thread+0x14/0x18
> 2:mon>
> 
> [...]

Applied, thanks!

[1/1] ext4: kunit: extents-test: Fix percpu_counters list corruption
      commit: bd7f1a0278d2d1fe88a734c3b8273c1a62db35cc

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
