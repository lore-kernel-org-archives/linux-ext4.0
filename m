From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] percpu_counter: Fix __percpu_counter_sum()
Date: Tue, 9 Dec 2008 21:49:21 -0800
Message-ID: <20081209214921.b3944687.akpm@linux-foundation.org>
References: <4936D287.6090206@cosmosbay.com>
	<4936EB04.8000609@cosmosbay.com>
	<20081206202233.3b74febc.akpm@linux-foundation.org>
	<493BCF60.1080409@cosmosbay.com>
	<20081207092854.f6bcbfae.akpm@linux-foundation.org>
	<493C0F40.7040304@cosmosbay.com>
	<20081207205250.dbb7fe4b.akpm@linux-foundation.org>
	<20081208221241.GA2501@mit.edu>
	<1228774836.16244.22.camel@lappy.programming.kicks-ass.net>
	<20081208230047.GC2501@mit.edu>
	<1228777500.12729.4.camel@twins>
	<493E2884.6010600@cosmosbay.com>
	<1228811653.6809.26.camel@twins>
	<493F4EF4.4080205@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Theodore Tso <tytso@mit.edu>,
	linux kernel <linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org,
	Christoph Lameter <clameter@sgi.com>,
	Rusty Russell <rusty@rustcorp.com.au>
To: Eric Dumazet <dada1@cosmosbay.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46350 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750736AbYLJFuC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Dec 2008 00:50:02 -0500
In-Reply-To: <493F4EF4.4080205@cosmosbay.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 10 Dec 2008 06:09:08 +0100 Eric Dumazet <dada1@cosmosbay.com> wrote:

> Now percpu_counter_sum() is 'fixed', what about "percpu_counter_add()" ?
> 
> void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch)
> {
>         s64 count;
>         s32 *pcount;
>         int cpu = get_cpu();
> 
>         pcount = per_cpu_ptr(fbc->counters, cpu);
>         count = *pcount + amount;
>         if (count >= batch || count <= -batch) {
>                 spin_lock(&fbc->lock);
>                 fbc->count += count;
>                 *pcount = 0;
>                 spin_unlock(&fbc->lock);
>         } else {
>                 *pcount = count;
>         }
>         put_cpu();
> }
> 
> 
> If I read this well, this is not IRQ safe.

Sure.  It's racy against interrupts on this cpu, it'll deadlock over
the non-irq-safe spinlock and lockdep will have a coronary over it.

> get_cpu() only disables preemption IMHO

yes

> For nr_files, nr_dentry, nr_inodes, it should not be a problem.

yes

> But for network counters (only in net-next-2.6) 
> and lib/proportions.c, we have a problem ?

yes

> Using local_t instead of s32 for cpu 
> local counter here is possible, so that fast path doesnt have 
> to disable interrupts
> 
> (use a local_t instead of s32 for fbc->counters)
> 
> void __percpu_counter_add_irqsafe(struct percpu_counter *fbc, s64 amount, s32 batch)
> {
>         long count;
>         local_t *pcount;
> 
> 	/* following code only matters on 32bit arches */
> 	if (sizeof(amount) != sizeof(local_t)) {
> 		if (unlikely(amount >= batch || amount <= -batch))) {
>         	        spin_lock_irqsave(&fbc->lock, flags);
>                 	fbc->count += amount;
>                 	spin_unlock_irqrestore(&fbc->lock, flags);
> 			return;
> 		}
> 	}
>         pcount = per_cpu_ptr(fbc->counters, get_cpu());
>         count = local_add_return((long)amount, pcount);
>         if (unlikely(count >= batch || count <= -batch)) {
> 		unsigned long flags;
> 
> 		local_sub(count, pcount);
>                 spin_lock_irqsave(&fbc->lock, flags);
>                 fbc->count += count;
>                 spin_unlock_irqrestore(&fbc->lock, flags);
>         }
>         put_cpu();
> }


I think it's reasonable.  If the batching is working as intended, the
increased cost of s/spin_lock/spin_lock_irqsave/ should be
insignificant.

In fact, if *at all* possible it would be best to make percpu_counters
irq-safe under all circumstances and avoid fattening and complicating the
interface.



But before adding more dependencies on local_t I do think we should
refresh ourselves on Christoph's objections to them - I remember
finding them fairly convincing at the time, but I don't recall the
details.

<searches for a long time>

Here, I think:
http://lkml.indiana.edu/hypermail/linux/kernel/0805.3/2482.html

Rusty, Christoph: talk to me.  If we add a new user of local_t in core
kernel, will we regret it?

Thanks.
