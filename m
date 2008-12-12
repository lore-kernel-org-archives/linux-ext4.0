From: Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [PATCH] percpu_counter: Fix __percpu_counter_sum()
Date: Fri, 12 Dec 2008 09:22:58 +0100
Message-ID: <49421F62.8000401@cosmosbay.com>
References: <4936D287.6090206@cosmosbay.com> <20081209214921.b3944687.akpm@linux-foundation.org> <49404925.7090902@cosmosbay.com> <200812121847.06432.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Theodore Tso <tytso@mit.edu>,
	linux kernel <linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org,
	Christoph Lameter <clameter@sgi.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gw1.cosmosbay.com ([86.65.150.130]:36419 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbYLLIXg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Dec 2008 03:23:36 -0500
In-Reply-To: <200812121847.06432.rusty@rustcorp.com.au>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Rusty Russell a =E9crit :
> On Thursday 11 December 2008 09:26:37 Eric Dumazet wrote:
>> But then, some (all but x86 ;) ) arches dont have true local_t and w=
e fallback
>> to plain atomic_long_t, and this is wrong because it would add a LOC=
KED
>> instruction in fast path.
>>
>> I remember Christoph added FAST_CMPXCHG_LOCAL, but no more uses of i=
t in current
>> tree.
>>
>> Ie : using local_t only if CONFIG_FAST_CMPXCHG_LOCAL, else something=
 like :
>>
>> void __percpu_counter_add_irqsafe(struct percpu_counter *fbc, s64 am=
ount, s32 batch)
>> {
>>         s64 count;
>>         s32 *pcount =3D per_cpu_ptr(fbc->counters, get_cpu());
>>         unsigned long flags;
>>
>>         local_irq_save(flags);
>>         count =3D *pcount + amount;
>=20
> This is dumb though.  If local_irq_save(), add, local_irq_restore() i=
s faster
> than atomic_long_add on some arch, *that* is what that arch's local_a=
dd()
> should do!
>=20
> Open coding it like this is obviously wrong.

Hum... so you vote for using local_t instead of s32 then ?

>=20
> Now, archs local.h need attention (x86-32 can be optimized today, for
> example), but that's not directly related.
>=20
> Hope that clarifies,
> Rusty.
> PS.  Yes, I should produce a documentation patch and fix the x86 vers=
ion.
> Added to TODO list.
>=20

Thanks


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
