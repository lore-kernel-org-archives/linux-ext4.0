From: Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [PATCH] percpu_counter: Fix __percpu_counter_sum()
Date: Tue, 09 Dec 2008 09:12:52 +0100
Message-ID: <493E2884.6010600@cosmosbay.com>
References: <4936D287.6090206@cosmosbay.com>	 <4936EB04.8000609@cosmosbay.com>	 <20081206202233.3b74febc.akpm@linux-foundation.org>	 <493BCF60.1080409@cosmosbay.com>	 <20081207092854.f6bcbfae.akpm@linux-foundation.org>	 <493C0F40.7040304@cosmosbay.com>	 <20081207205250.dbb7fe4b.akpm@linux-foundation.org>	 <20081208221241.GA2501@mit.edu>	 <1228774836.16244.22.camel@lappy.programming.kicks-ass.net>	 <20081208230047.GC2501@mit.edu> <1228777500.12729.4.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux kernel <linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gw1.cosmosbay.com ([86.65.150.130]:60243 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbYLIINZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Dec 2008 03:13:25 -0500
In-Reply-To: <1228777500.12729.4.camel@twins>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Peter Zijlstra a =E9crit :
> On Mon, 2008-12-08 at 18:00 -0500, Theodore Tso wrote:
>> On Mon, Dec 08, 2008 at 11:20:35PM +0100, Peter Zijlstra wrote:
>>> atomic_t is pretty good on all archs, but you get to keep the cache=
line
>>> ping-pong.
>>>
>> Stupid question --- if you're worried about cacheline ping-pongs, wh=
y
>> aren't each cpu's delta counter cacheline aligned?  With a 64-byte
>> cache-line, and a 32-bit counters entry, with less than 16 CPU's we'=
re
>> going to be getting cache ping-pong effects with percpu_counter's,
>> right?  Or am I missing something?
>=20
> sorta - a new per-cpu allocator is in the works, but we do cacheline
> align the per-cpu allocations (or used to), also, the allocations are
> node affine.
>=20

I did work on a 'light weight percpu counter', aka percpu_lcounter, for
all metrics that dont need 64 bits wide, but a plain 'long'
(network, nr_files, nr_dentry, nr_inodes, ...)

struct percpu_lcounter {
        atomic_long_t count;
#ifdef CONFIG_SMP
#ifdef CONFIG_HOTPLUG_CPU
        struct list_head list;  /* All percpu_counters are on a list */
#endif
        long *counters;
#endif
};

(No more spinlock)

Then I tried to have atomic_t  (or atomic_long_t) for 'counters', but g=
ot a
10% slow down of __percpu_lcounter_add(), even if never hitting the 'sl=
ow path'
atomic_long_add_return() is really expensiven, even on a non contended =
cache
line.

struct percpu_lcounter {
        atomic_long_t count;
#ifdef CONFIG_SMP
#ifdef CONFIG_HOTPLUG_CPU
        struct list_head list;  /* All percpu_counters are on a list */
#endif
        atomic_long_t *counters;
#endif
};

So I believe the percpu_clounter_sum() that tries to reset to 0 all cpu=
 local
 counts would be really too expensive, if it slows down _add() so much.

long percpu_lcounter_sum(struct percpu_lcounter *fblc)
{
        long acc =3D 0;
        int cpu;

        for_each_online_cpu(cpu)
                acc +=3D atomic_long_xchg(per_cpu_ptr(fblc->counters, c=
pu), 0);
        return atomic_long_add_return(acc, &fblc->count);
}

void __percpu_lcounter_add(struct percpu_lcounter *flbc, long amount, s=
32 batch)
{
        long count;
        atomic_long_t *pcount;

        pcount =3D per_cpu_ptr(flbc->counters, get_cpu());
        count =3D atomic_long_add_return(amount, pcount); /* way too ex=
pensive !!! */
        if (unlikely(count >=3D batch || count <=3D -batch)) {
                atomic_long_add(count, &flbc->count);
                atomic_long_sub(count, pcount);
        }
        put_cpu();
}

Just forget about it and let percpu_lcounter_sum() only read the values=
, and
let percpu_lcounter_add() not using atomic ops in fast path.

void __percpu_lcounter_add(struct percpu_lcounter *flbc, long amount, s=
32 batch)
{
        long count;
        long *pcount;

        pcount =3D per_cpu_ptr(flbc->counters, get_cpu());
        count =3D *pcount + amount;
        if (unlikely(count >=3D batch || count <=3D -batch)) {
                atomic_long_add(count, &flbc->count);
                count =3D 0;
        }
        *pcount =3D count;
        put_cpu();
}
EXPORT_SYMBOL(__percpu_lcounter_add);


Also, with upcoming NR_CPUS=3D4096, it may be time to design a hierarch=
ical percpu_counter,
to avoid hitting one shared "fbc->count" all the time a local counter o=
verflows.


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
