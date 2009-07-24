From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Fallocate and DirectIO
Date: Fri, 24 Jul 2009 23:32:25 +0530
Message-ID: <20090724180225.GA29851@skywalker>
References: <20090612123112.GB25239@skywalker> <20090612173301.GC6417@mit.edu> <6601abe90907211827l57a04f8asba906e508535f1b9@mail.gmail.com> <6601abe90907230856q3ee5abe5jc1f7a71d10c5f695@mail.gmail.com> <1248396972.1354.47.camel@mingming-laptop> <6601abe90907240930t5232329byb1c2c6930abcb473@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Mingming <cmm@us.ibm.com>, Theodore Tso <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Eric Sandeen <sandeen@redhat.com>,
	Andreas Dilger <adilger@sun.com>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp09.in.ibm.com ([59.145.155.9]:43035 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768AbZGXSCe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 24 Jul 2009 14:02:34 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp09.in.ibm.com (8.14.3/8.13.1) with ESMTP id n6OH9CiR028028
	for <linux-ext4@vger.kernel.org>; Fri, 24 Jul 2009 22:39:12 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n6OI2UrD2359548
	for <linux-ext4@vger.kernel.org>; Fri, 24 Jul 2009 23:32:30 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id n6OI2T9U027800
	for <linux-ext4@vger.kernel.org>; Fri, 24 Jul 2009 23:32:30 +0530
Content-Disposition: inline
In-Reply-To: <6601abe90907240930t5232329byb1c2c6930abcb473@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 24, 2009 at 09:30:08AM -0700, Curt Wohlgemuth wrote:
> On Thu, Jul 23, 2009 at 5:56 PM, Mingming<cmm@us.ibm.com> wrote:
> > On Thu, 2009-07-23 at 08:56 -0700, Curt Wohlgemuth wrote:
> >> On Tue, Jul 21, 2009 at 6:27 PM, Curt Wohlgemuth<curtw@google.com>=
 wrote:
> >> > I spent a bit of time looking at this today.
> >> >
> >> > On Fri, Jun 12, 2009 at 10:33 AM, Theodore Tso<tytso@mit.edu> wr=
ote:
> >> >> On Fri, Jun 12, 2009 at 06:01:12PM +0530, Aneesh Kumar K.V wrot=
e:
> >> >>> Hi,
> >> >>>
> >> >>> I noticed yesterday that a write to fallocate
> >> >>> space via directIO results in fallback to buffer_IO. ie the us=
erspace
> >> >>> pages get copied to the page cache and then call a sync.
> >> >>>
> >> >>> I guess this defeat the purpose of using directIO. May be we s=
hould
> >> >>> consider this a high priority bug.
> >> >
> >> > My simple experiment -- without a journal -- shows that you're
> >> > observation is correct. =A0*Except* if FALLOC_FL_KEEP_SIZE is us=
ed in
> >> > the fallocate() call, in which case the page cache is *not* used=
=2E
> >> >
> >> > Pseudo-code example:
> >> >
> >> > =A0open(O_DIRECT)
> >> > =A0fallocate(mode, 512MB)
> >> > =A0while (! written 100MB)
> >> > =A0 =A0 write(64K)
> >> > =A0close()
> >> >
> >> > If mode =3D=3D FALLOC_FL_KEEP_SIZE, then no page cache is used.
> >> > Otherwise, we *do* go through the page cache.
> >> >
> >> > It comes down to the fact that, since the i_size is not updated =
with
> >> > KEEP_SIZE, then ext4_get_block() is called with create =3D 1, si=
nce the
> >> > block that's needed is "beyond" the file end.
> >>
> > I think so.
> > In the case of KEEP_SIZE, get_block() is called with create=3D1 bef=
ore dio
> > submit the real data IO, thus dio get a chance to convert the
> > uninitalized extents to initialized before returns back to the call=
er.
>=20
> Ah, I see this now in ext4_direct_IO().  Thanks.
>=20
> > But in the case of non KEEP_SIZE, i.e. updating i_size after falloc=
ate()
> > case, we now have to fall back to buffered IO to ensure the extents
> > conversion is happened in an ordering. Because if we convert the ex=
tents
> > before submit the IO, and this conversion reached to disk, if syste=
m
> > crash before the real data IO finished, then it could expose the st=
ale
> > data out, as the extent has already marked "initialized".
>=20
> Yes, that makes sense -- since i_size already covers the formerly
> uninitialized, now initialized, extents.
>=20
> >> Ted, given your concerns over the performance impact of updating t=
he
> >> extents during direct I/O writes, it would seem that the fact that
> >> when KEEP_SIZE is specified we do the DMA (and don't go through th=
e
> >> page cache) would be a problem/bug. =A0At least, it seems that the
> >> performance issue is the same regardless of whether KEEP_SIZE is u=
sed
> >> on the fallocate or not: in both we're dealing with an uninitializ=
ed
> >> extent. =A0Do you agree?
> >
> > Here is what I thought...
> >
> > I think updating the extents itself is not a big performance concer=
n, In
> > the non KEEP_SIZE case, if we don't want to fall back to buffered I=
O,
> > ext4 DIO has to wait for the journal to commit the transaction whic=
h
> > converts extents to complete, before DIO could return back apps, th=
is
> > could be a big latency. That seems what xfs does.
>=20
> Wouldn't this still be an exposure to stale data?  The only way for
> this to work, if i_size already covers the uninit extents, is to make
> sure the data goes to disk before the extents get converted and
> committed.  Since the extents are converted in the ext4_get_block()
> path, before DIO actually performs the data write, this seems to be
> too late.
>=20
> > For KEEP_SIZE case, The conversion actually could happen before the
> > related IO reach to disk, I guess the oraph inode list protects sta=
le
> > data get exposed in this case.
>=20
> I'm sorry, I don't follow you here.
>=20
> >> I'm exploring (a) what this performance penalty is for the journal
> >> commit; and (b) can we at least avoid the page cache if your
> >> conditions above (no journal commit; no new extent blocks) are met=
=2E
> >
> > In fact, in the case of no journal, as long as the extents conversi=
on
> > happens after the data IO reach to disk, it should be safe, am I ri=
ght?
> > If system crash before the extent conversion finish, we only lost
> > recently updated IO, but won't expose the stale data out, as the ex=
tents
> > is still marked as uninitialized.
>=20
> But again, the extent conversion (and mark_inode_dirty()) happens at
> get_block time, before the data goes to disk.
>=20
> For KEEP_SIZE, this isn't an exposure because i_size prevents the dat=
a
> from being read.  But without KEEP_SIZE, this would seem to be a
> problem, right?
>=20
> (From a practical perspective, there's also a problem getting real DI=
O
> to work without KEEP_SIZE in the fallocate():  the decision to send
> "create=3D0" to ext4_get_block() happens in VFS code, and there's no =
way
> to tell in the get_block path that "this is a 'no create' for a write=
,
> vs. a read.)

What we need is to track I/O's untill they hit the disk. This will
help us to do data=3Dguarded and also help in the above case. So
for directIO we should use blockdev_direct_IO_own_locking and the get_b=
lock
used should split the uninit extent the needed way but still mark it
uninit. That would make sure a read will see the uninit extent and retu=
rn
zero as expected. Now on IO completion we should mark split uninit exte=
nt
as init.

-aneesh
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
