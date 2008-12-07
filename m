From: Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [PATCH] percpu_counter: Fix __percpu_counter_sum()
Date: Sun, 07 Dec 2008 19:00:32 +0100
Message-ID: <493C0F40.7040304@cosmosbay.com>
References: <4936D287.6090206@cosmosbay.com>	<4936EB04.8000609@cosmosbay.com>	<20081206202233.3b74febc.akpm@linux-foundation.org>	<493BCF60.1080409@cosmosbay.com> <20081207092854.f6bcbfae.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux kernel <linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Mingming Cao <cmm@us.ibm.com>, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gw1.cosmosbay.com ([86.65.150.130]:56696 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbYLGSGE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 7 Dec 2008 13:06:04 -0500
In-Reply-To: <20081207092854.f6bcbfae.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andrew Morton a =E9crit :
> On Sun, 07 Dec 2008 14:28:00 +0100 Eric Dumazet <dada1@cosmosbay.com>=
 wrote:
>=20
>> Andrew Morton a __crit :
>>> On Wed, 03 Dec 2008 21:24:36 +0100 Eric Dumazet <dada1@cosmosbay.co=
m> wrote:
>>>
>>>> Eric Dumazet a __crit :
>>>>
>>>> 1) __percpu_counter_sum() is buggy, it should not write
>>>> on per_cpu_ptr(fbc->counters, cpu), or another cpu
>>>> could get its changes lost.
>>>>
>>>> __percpu_counter_sum should be read only (const struct percpu_coun=
ter *fbc),
>>>> and no locking needed.
>>> No, we can't do this - it will break ext4.
>>>
>>> Take a closer look at 1f7c14c62ce63805f9574664a6c6de3633d4a354 and =
at
>>> e8ced39d5e8911c662d4d69a342b9d053eaaac4e.
>>>
>>> I suggest that what we do is to revert both those changes.  We can
>>> worry about the possibly-unneeded spin_lock later, in a separate pa=
tch.
>>>
>>> It should have been a separate patch anyway.  It's conceptually
>>> unrelated and is not a bugfix, but it was mixed in with a bugfix.
>>>
>>> Mingming, this needs urgent consideration, please.  Note that I had=
 to
>>> make additional changes to ext4 due to the subsequent introduction =
of
>>> the dirty_blocks counter.
>>>
>>>
>>> Please read the below changelogs carefully and check that I have go=
t my
>>> head around this correctly - I may not have done.
>>>
>>
>> Hum... e8ced39d5e8911c662d4d69a342b9d053eaaac4e is probably followin=
g
>> the wrong path, but I see the intent. Even in the 'nr_files' case, i=
t could
>> help to reduce excessive calls to percpu_counter_sum()
>>
>=20
> We should fix this in 2.6.28 - right now percpu_counter_sum() is subt=
ly
> corrupting the counter's value.
>=20
> I sent two revert patches which I hope to merge into 2.6.28.  Could y=
ou
> guys please read/review/maybe-test them?

Your revert patches have the same effect than my first patch : No write=
s
in percpu_counter_sum()

I am lost here Andrew...



--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
