From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH -V3 01/11] percpu_counters: make fbc->count read atomic
	on 32 bit architecture
Date: Thu, 28 Aug 2008 15:59:46 -0700
Message-ID: <1219964386.6384.63.camel@mingming-laptop>
References: <1219850916-8986-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <20080827120553.9c9d6690.akpm@linux-foundation.org>
	 <1219870912.6395.45.camel@twins>
	 <20080827142250.7397a1a7.akpm@linux-foundation.org>
	 <20080828035200.GB6440@skywalker>
	 <20080827210925.b4846037.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>, tytso@mit.edu,
	sandeen@redhat.com, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:57189 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525AbYH1W7s (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Aug 2008 18:59:48 -0400
In-Reply-To: <20080827210925.b4846037.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-08-27=E4=B8=89=E7=9A=84 21:09 -0700=EF=BC=8CAndrew Morto=
n=E5=86=99=E9=81=93=EF=BC=9A
> On Thu, 28 Aug 2008 09:22:00 +0530 "Aneesh Kumar K.V" <aneesh.kumar@l=
inux.vnet.ibm.com> wrote:
>=20
> > On Wed, Aug 27, 2008 at 02:22:50PM -0700, Andrew Morton wrote:
> > > On Wed, 27 Aug 2008 23:01:52 +0200
> > > Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > >=20
> > > > >=20
> > > > > > +static inline s64 percpu_counter_read(struct percpu_counte=
r *fbc)
> > > > > > +{
> > > > > > +	return fbc_count(fbc);
> > > > > > +}
> > > > >=20
> > > > > This change means that a percpu_counter_read() from interrupt=
 context
> > > > > on a 32-bit machine is now deadlockable, whereas it previousl=
y was not
> > > > > deadlockable on either 32-bit or 64-bit.
> > > > >=20
> > > > > This flows on to the lib/proportions.c, which uses
> > > > > percpu_counter_read() and also does spin_lock_irqsave() inter=
nally,
> > > > > indicating that it is (or was) designed to be used in IRQ con=
texts.
> > > >=20
> > > > percpu_counter() never was irq safe, which is why the proportio=
n stuff
> > > > does all the irq disabling bits by hand.
> > >=20
> > > percpu_counter_read() was irq-safe.  That changes here.  Needs ca=
reful
> > > review, changelogging and, preferably, runtime checks.  But perha=
ps
> > > they should be inside some CONFIG_thing which won't normally be d=
one in
> > > production.
> > >=20
> > > otoh, percpu_counter_read() is in fact a rare operation, so a bit=
 of
> > > overhead probably won't matter.
> > >=20
> > > (write-often, read-rarely is the whole point.  This patch's chang=
elog's
> > > assertion that "Since fbc->count is read more frequently and upda=
ted
> > > rarely" is probably wrong.  Most percpu_counters will have their
> > > fbc->count modified far more frequently than having it read from)=
=2E
> >=20
> > we may actually be doing percpu_counter_add. But that doesn't updat=
e
> > fbc->count. Only if the local percpu values cross FBC_BATCH we upda=
te
> > fbc->count. If we are modifying fbc->count more frequently than
> > reading fbc->count then i guess we would be contenting of fbc->lock=
 more.
> >=20
> >=20
>=20
> Yep.  The frequency of modification of fbc->count is of the order of =
a
> tenth or a hundredth of the frequency of
> precpu_counter_<modification>() calls.
>=20
> But in many cases the frequency of percpu_counter_read() calls is far
> far less than this.  For example, the percpu_counter_read() may only
> happen when userspace polls a /proc file.
>=20
>=20

The global counter is is much more frequently accessed with delalloc.:(

With delayed allocation, we have to do read the free blocks counter  at
each write_begin(),  to make sure there is enough free blocks to do
block reservation to prevent lately writepages returns ENOSPC.

Mingming

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
