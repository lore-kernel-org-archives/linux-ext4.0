From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] percpu_counter: Fix __percpu_counter_sum()
Date: Mon, 08 Dec 2008 14:44:39 -0800
Message-ID: <1228776279.6372.18.camel@mingming-laptop>
References: <4936D287.6090206@cosmosbay.com>
	 <4936EB04.8000609@cosmosbay.com>
	 <20081206202233.3b74febc.akpm@linux-foundation.org>
	 <493BCF60.1080409@cosmosbay.com>
	 <20081207092854.f6bcbfae.akpm@linux-foundation.org>
	 <493C0F40.7040304@cosmosbay.com>
	 <20081207205250.dbb7fe4b.akpm@linux-foundation.org>
	 <20081208221241.GA2501@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Eric Dumazet <dada1@cosmosbay.com>,
	linux kernel <linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:48685 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbYLHWom (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Dec 2008 17:44:42 -0500
In-Reply-To: <20081208221241.GA2501@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-12-08=E4=B8=80=E7=9A=84 17:12 -0500=EF=BC=8CTheodore Tso=
=E5=86=99=E9=81=93=EF=BC=9A
> On Sun, Dec 07, 2008 at 08:52:50PM -0800, Andrew Morton wrote:
> >=20
> > The first patch which was added (pre-2.6.27) was "percpu_counter: n=
ew
> > function percpu_counter_sum_and_set".  This added the broken-by-des=
ign
> > percpu_counter_sum_and_set() function, **and used it in ext4**.
> >=20
>=20
> Mea culpa, I was the one who reviewed Mingming's patch, and missed
> this.  Part of the problem was that percpu_counter.c isn't well
> documented, and I so saw the spinlock, but didn't realize it only
> protected reference counter, and not the per-cpu array.  I should hav=
e
> read through code more thoroughly before approving the patch.
>=20
> I suppose if we wanted we could add a rw spinlock which mediates
> access to a "foreign" cpu counter (i.e., percpu_counter_add gets a
> shared lock, and percpu_counter_set needs an exclusive lock) but it's
> probably not worth it.
>=20
> Actually, if all popular architectures had a hardware-implemented
> atomic_t, I wonder how much ext4 really needs the percpu counter,
> especially given ext4's multiblock allocator;

Delayed allocation will makes multiple block allocation possible for
buffered IO. =20

However, we still need to check the percpu counter on write_begin() tim=
e
for every single possible block allocation (this is to make sure fs is
not overbooked), unless write_begin() could cluster the write requests
and maps multiple blocks in a single shot. So in reality in ext4 the
free blocks percpu_counter check and the s_dirty_blocks (percpu counter
too, for delayed blocks) only takes 1 block at a time:(


Mingming

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
