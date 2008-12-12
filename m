From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] percpu_counter: Fix __percpu_counter_sum()
Date: Fri, 12 Dec 2008 18:47:05 +1030
Message-ID: <200812121847.06432.rusty@rustcorp.com.au>
References: <4936D287.6090206@cosmosbay.com> <20081209214921.b3944687.akpm@linux-foundation.org> <49404925.7090902@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Theodore Tso <tytso@mit.edu>,
	linux kernel <linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org,
	Christoph Lameter <clameter@sgi.com>
To: Eric Dumazet <dada1@cosmosbay.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:35964 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703AbYLLIRO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 12 Dec 2008 03:17:14 -0500
In-Reply-To: <49404925.7090902@cosmosbay.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thursday 11 December 2008 09:26:37 Eric Dumazet wrote:
> But then, some (all but x86 ;) ) arches dont have true local_t and we fallback
> to plain atomic_long_t, and this is wrong because it would add a LOCKED
> instruction in fast path.
> 
> I remember Christoph added FAST_CMPXCHG_LOCAL, but no more uses of it in current
> tree.
> 
> Ie : using local_t only if CONFIG_FAST_CMPXCHG_LOCAL, else something like :
> 
> void __percpu_counter_add_irqsafe(struct percpu_counter *fbc, s64 amount, s32 batch)
> {
>         s64 count;
>         s32 *pcount = per_cpu_ptr(fbc->counters, get_cpu());
>         unsigned long flags;
> 
>         local_irq_save(flags);
>         count = *pcount + amount;

This is dumb though.  If local_irq_save(), add, local_irq_restore() is faster
than atomic_long_add on some arch, *that* is what that arch's local_add()
should do!

Open coding it like this is obviously wrong.

Now, archs local.h need attention (x86-32 can be optimized today, for
example), but that's not directly related.

Hope that clarifies,
Rusty.
PS.  Yes, I should produce a documentation patch and fix the x86 version.
Added to TODO list.
