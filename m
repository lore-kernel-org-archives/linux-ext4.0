From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Fallocate and DirectIO
Date: Sat, 25 Jul 2009 00:10:48 +0530
Message-ID: <20090724184048.GA31141@skywalker>
References: <20090612123112.GB25239@skywalker> <20090612173301.GC6417@mit.edu> <6601abe90907211827l57a04f8asba906e508535f1b9@mail.gmail.com> <6601abe90907230856q3ee5abe5jc1f7a71d10c5f695@mail.gmail.com> <1248396972.1354.47.camel@mingming-laptop> <6601abe90907240930t5232329byb1c2c6930abcb473@mail.gmail.com> <20090724180225.GA29851@skywalker> <6601abe90907241118u57370bf0j53a8c22147a892f0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Mingming <cmm@us.ibm.com>, Theodore Tso <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Eric Sandeen <sandeen@redhat.com>,
	Andreas Dilger <adilger@sun.com>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:49412 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbZGXSk7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 24 Jul 2009 14:40:59 -0400
Received: from d23relay02.au.ibm.com (d23relay02.au.ibm.com [202.81.31.244])
	by e23smtp06.au.ibm.com (8.14.3/8.13.1) with ESMTP id n6OIeshm003680
	for <linux-ext4@vger.kernel.org>; Sat, 25 Jul 2009 04:40:54 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay02.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n6OIeufI1273938
	for <linux-ext4@vger.kernel.org>; Sat, 25 Jul 2009 04:40:56 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n6OIetbY017931
	for <linux-ext4@vger.kernel.org>; Sat, 25 Jul 2009 04:40:56 +1000
Content-Disposition: inline
In-Reply-To: <6601abe90907241118u57370bf0j53a8c22147a892f0@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 24, 2009 at 11:18:38AM -0700, Curt Wohlgemuth wrote:
> >>
> >> But again, the extent conversion (and mark_inode_dirty()) happens =
at
> >> get_block time, before the data goes to disk.
> >>
> >> For KEEP_SIZE, this isn't an exposure because i_size prevents the =
data
> >> from being read. =A0But without KEEP_SIZE, this would seem to be a
> >> problem, right?
> >>
> >> (From a practical perspective, there's also a problem getting real=
 DIO
> >> to work without KEEP_SIZE in the fallocate(): =A0the decision to s=
end
> >> "create=3D0" to ext4_get_block() happens in VFS code, and there's =
no way
> >> to tell in the get_block path that "this is a 'no create' for a wr=
ite,
> >> vs. a read.)
> >
> > What we need is to track I/O's untill they hit the disk. This will
> > help us to do data=3Dguarded and also help in the above case. So
> > for directIO we should use blockdev_direct_IO_own_locking and the g=
et_block
> > used should split the uninit extent the needed way but still mark i=
t
> > uninit. That would make sure a read will see the uninit extent and =
return
> > zero as expected. Now on IO completion we should mark split uninit =
extent
> > as init.
>=20
> I can see how using DIO_OWN_LOCKING would allow a write to send
> "create=3D1" to ext4_get_block().  That would be cool.
>=20
> Are you then saying that we would need to postpone the
> ext4_ext_convert_to_initialized() call in ext4_ext_get_blocks(), and
> then have ext4_direct_IO() do this conversion on return from
> blockdev_direct_IO_own_locking()?  That would seem to be required...
>=20

We still need to do split of uninit extent. Only marking the new exetnt
as init should be postponed. We need to split the uninit extent to actu=
ally
copy the user space data to blocks.

-aneesh
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
