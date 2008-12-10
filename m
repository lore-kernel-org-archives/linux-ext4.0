From: Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [PATCH] percpu_counter: Fix __percpu_counter_sum()
Date: Wed, 10 Dec 2008 23:56:37 +0100
Message-ID: <49404925.7090902@cosmosbay.com>
References: <4936D287.6090206@cosmosbay.com>	<4936EB04.8000609@cosmosbay.com>	<20081206202233.3b74febc.akpm@linux-foundation.org>	<493BCF60.1080409@cosmosbay.com>	<20081207092854.f6bcbfae.akpm@linux-foundation.org>	<493C0F40.7040304@cosmosbay.com>	<20081207205250.dbb7fe4b.akpm@linux-foundation.org>	<20081208221241.GA2501@mit.edu>	<1228774836.16244.22.camel@lappy.programming.kicks-ass.net>	<20081208230047.GC2501@mit.edu>	<1228777500.12729.4.camel@twins>	<493E2884.6010600@cosmosbay.com>	<1228811653.6809.26.camel@twins>	<493F4EF4.4080205@cosmosbay.com> <20081209214921.b3944687.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Theodore Tso <tytso@mit.edu>,
	linux kernel <linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org,
	Christoph Lameter <clameter@sgi.com>,
	Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gw1.cosmosbay.com ([86.65.150.130]:58749 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbYLJW5t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Dec 2008 17:57:49 -0500
In-Reply-To: <20081209214921.b3944687.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andrew Morton a =E9crit :
> On Wed, 10 Dec 2008 06:09:08 +0100 Eric Dumazet <dada1@cosmosbay.com>=
 wrote:
>=20
>> Now percpu_counter_sum() is 'fixed', what about "percpu_counter_add(=
)" ?
>>
>> void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s3=
2 batch)
>> {
>>         s64 count;
>>         s32 *pcount;
>>         int cpu =3D get_cpu();
>>
>>         pcount =3D per_cpu_ptr(fbc->counters, cpu);
>>         count =3D *pcount + amount;
>>         if (count >=3D batch || count <=3D -batch) {
>>                 spin_lock(&fbc->lock);
>>                 fbc->count +=3D count;
>>                 *pcount =3D 0;
>>                 spin_unlock(&fbc->lock);
>>         } else {
>>                 *pcount =3D count;
>>         }
>>         put_cpu();
>> }
>>
>>
>> If I read this well, this is not IRQ safe.
>=20
> Sure.  It's racy against interrupts on this cpu, it'll deadlock over
> the non-irq-safe spinlock and lockdep will have a coronary over it.
>=20
>> get_cpu() only disables preemption IMHO
>=20
> yes
>=20
>> For nr_files, nr_dentry, nr_inodes, it should not be a problem.
>=20
> yes
>=20
>> But for network counters (only in net-next-2.6)=20
>> and lib/proportions.c, we have a problem ?
>=20
> yes
>=20
>> Using local_t instead of s32 for cpu=20
>> local counter here is possible, so that fast path doesnt have=20
>> to disable interrupts
>>
>> (use a local_t instead of s32 for fbc->counters)
>>
>> void __percpu_counter_add_irqsafe(struct percpu_counter *fbc, s64 am=
ount, s32 batch)
>> {
>>         long count;
>>         local_t *pcount;
>>
>> 	/* following code only matters on 32bit arches */
>> 	if (sizeof(amount) !=3D sizeof(local_t)) {
>> 		if (unlikely(amount >=3D batch || amount <=3D -batch))) {
>>         	        spin_lock_irqsave(&fbc->lock, flags);
>>                 	fbc->count +=3D amount;
>>                 	spin_unlock_irqrestore(&fbc->lock, flags);
>> 			return;
>> 		}
>> 	}
>>         pcount =3D per_cpu_ptr(fbc->counters, get_cpu());
>>         count =3D local_add_return((long)amount, pcount);
>>         if (unlikely(count >=3D batch || count <=3D -batch)) {
>> 		unsigned long flags;
>>
>> 		local_sub(count, pcount);
>>                 spin_lock_irqsave(&fbc->lock, flags);
>>                 fbc->count +=3D count;
>>                 spin_unlock_irqrestore(&fbc->lock, flags);
>>         }
>>         put_cpu();
>> }
>=20
>=20
> I think it's reasonable.  If the batching is working as intended, the
> increased cost of s/spin_lock/spin_lock_irqsave/ should be
> insignificant.
>=20
> In fact, if *at all* possible it would be best to make percpu_counter=
s
> irq-safe under all circumstances and avoid fattening and complicating=
 the
> interface.
>=20
>=20
>=20
> But before adding more dependencies on local_t I do think we should
> refresh ourselves on Christoph's objections to them - I remember
> finding them fairly convincing at the time, but I don't recall the
> details.
>=20
> <searches for a long time>
>=20
> Here, I think:
> http://lkml.indiana.edu/hypermail/linux/kernel/0805.3/2482.html
>=20
> Rusty, Christoph: talk to me.  If we add a new user of local_t in cor=
e
> kernel, will we regret it?
>=20

__percpu_counter_add() already disables preemption (calling get_cpu())


But then, some (all but x86 ;) ) arches dont have true local_t and we f=
allback
to plain atomic_long_t, and this is wrong because it would add a LOCKED
instruction in fast path.

I remember Christoph added FAST_CMPXCHG_LOCAL, but no more uses of it i=
n current
tree.


Ie : using local_t only if CONFIG_FAST_CMPXCHG_LOCAL, else something li=
ke :

void __percpu_counter_add_irqsafe(struct percpu_counter *fbc, s64 amoun=
t, s32 batch)
{
        s64 count;
        s32 *pcount =3D per_cpu_ptr(fbc->counters, get_cpu());
        unsigned long flags;

        local_irq_save(flags);
        count =3D *pcount + amount;
        if (unlikely(count >=3D batch || count <=3D -batch)) {
                spin_lock(&fbc->lock);
                fbc->count +=3D count;
                spin_unlock(&fbc->lock);
                count =3D 0;
        }
        *pcount =3D count;
        local_irq_restore(flags);
        put_cpu();
}
EXPORT_SYMBOL(__percpu_counter_add_irqsafe);

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
