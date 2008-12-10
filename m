From: Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [PATCH] percpu_counter: Fix __percpu_counter_sum()
Date: Wed, 10 Dec 2008 06:09:08 +0100
Message-ID: <493F4EF4.4080205@cosmosbay.com>
References: <4936D287.6090206@cosmosbay.com>	 <4936EB04.8000609@cosmosbay.com>	 <20081206202233.3b74febc.akpm@linux-foundation.org>	 <493BCF60.1080409@cosmosbay.com>	 <20081207092854.f6bcbfae.akpm@linux-foundation.org>	 <493C0F40.7040304@cosmosbay.com>	 <20081207205250.dbb7fe4b.akpm@linux-foundation.org>	 <20081208221241.GA2501@mit.edu>	 <1228774836.16244.22.camel@lappy.programming.kicks-ass.net>	 <20081208230047.GC2501@mit.edu> <1228777500.12729.4.camel@twins>	 <493E2884.6010600@cosmosbay.com> <1228811653.6809.26.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux kernel <linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Theodore Tso <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gw1.cosmosbay.com ([86.65.150.130]:55411 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbYLJFJn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Dec 2008 00:09:43 -0500
In-Reply-To: <1228811653.6809.26.camel@twins>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Now percpu_counter_sum() is 'fixed', what about "percpu_counter_add()" ?

void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch)
{
        s64 count;
        s32 *pcount;
        int cpu = get_cpu();

        pcount = per_cpu_ptr(fbc->counters, cpu);
        count = *pcount + amount;
        if (count >= batch || count <= -batch) {
                spin_lock(&fbc->lock);
                fbc->count += count;
                *pcount = 0;
                spin_unlock(&fbc->lock);
        } else {
                *pcount = count;
        }
        put_cpu();
}


If I read this well, this is not IRQ safe.

get_cpu() only disables preemption IMHO

For nr_files, nr_dentry, nr_inodes, it should not be a problem.

But for network counters (only in net-next-2.6) 
and lib/proportions.c, we have a problem ?

Using local_t instead of s32 for cpu 
local counter here is possible, so that fast path doesnt have 
to disable interrupts

(use a local_t instead of s32 for fbc->counters)

void __percpu_counter_add_irqsafe(struct percpu_counter *fbc, s64 amount, s32 batch)
{
        long count;
        local_t *pcount;

	/* following code only matters on 32bit arches */
	if (sizeof(amount) != sizeof(local_t)) {
		if (unlikely(amount >= batch || amount <= -batch))) {
        	        spin_lock_irqsave(&fbc->lock, flags);
                	fbc->count += amount;
                	spin_unlock_irqrestore(&fbc->lock, flags);
			return;
		}
	}
        pcount = per_cpu_ptr(fbc->counters, get_cpu());
        count = local_add_return((long)amount, pcount);
        if (unlikely(count >= batch || count <= -batch)) {
		unsigned long flags;

		local_sub(count, pcount);
                spin_lock_irqsave(&fbc->lock, flags);
                fbc->count += count;
                spin_unlock_irqrestore(&fbc->lock, flags);
        }
        put_cpu();
}
