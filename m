From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: ENOSPC returned during writepages
Date: Thu, 21 Aug 2008 10:17:07 -0700
Message-ID: <1219339027.6342.19.camel@mingming-laptop>
References: <20080820054339.GB6381@skywalker>
	 <20080820104644.GA11267@skywalker> <20080820115331.GA9965@mit.edu>
	 <1219269325.7895.45.camel@mingming-laptop>
	 <20080821151815.GD6509@skywalker>  <20080821153558.GJ16634@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:47242 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752339AbYHURR0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Aug 2008 13:17:26 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7LHHIOQ008072
	for <linux-ext4@vger.kernel.org>; Thu, 21 Aug 2008 13:17:18 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7LHH88K205752
	for <linux-ext4@vger.kernel.org>; Thu, 21 Aug 2008 13:17:08 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7LHH8ig029893
	for <linux-ext4@vger.kernel.org>; Thu, 21 Aug 2008 13:17:08 -0400
In-Reply-To: <20080821153558.GJ16634@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-08-21=E5=9B=9B=E7=9A=84 11:35 -0400=EF=BC=8CTheodore Tso=
=E5=86=99=E9=81=93=EF=BC=9A
> On Thu, Aug 21, 2008 at 08:48:15PM +0530, Aneesh Kumar K.V wrote:
> > > I have a feeling that we did not try very hard before invalidate =
the
> > > dirty page which fail to map to disks. Perhaps we should try a fe=
w more
> > > times before give up. Also in that case, perhaps we should turn o=
ff
> > > delalloc fs wide, so the new writers won't take the subsequently =
made
> > > avaible free blocks away from this unlucky delalloc da writepages=
=2E
> >=20
> > How do we try hard ? The mballoc already try had to allocate blocks=
=2E So I
> > am not sure what do we achieve by requesting for block allocation a=
gain.
>=20
> So here's the problem that we face.  If we have a situation where the
> disk fills temporarily, but then subsequently space gets freed up, it
> would be preferable if the dirty page isn't invalidated, and so
> periodically (or perhaps via "there's-free-space-now notifier") we
> retry the delayed allocation so we don't lose data during a transient
> disk full situation.  But at the same time, we don't want an fsync()
> on the entire filesystem, or a umount on the filesystem, to hang
> forever.
>=20

This situation (disk fills temporarily) is not new, we handled this in
ext4_write_begin() (and other places)  by retry allocation three times
in case of ENOSPC error. we could do the same retry  in
ext4_da_writepages().

Mingming
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
