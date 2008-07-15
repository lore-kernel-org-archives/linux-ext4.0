From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] Ext4: Fix delalloc enospace handling counter update
	race
Date: Tue, 15 Jul 2008 14:12:49 -0700
Message-ID: <1216156369.8292.2.camel@mingming-laptop>
References: <200807130626.m6D6QMvj007916@imap1.linux-foundation.org>
	 <20080714010828.GD7938@mit.edu> <1216052897.7937.1.camel@mingming-laptop>
	 <20080714165324.GA3545@skywalker>
	 <1216058076.6468.11.camel@mingming-laptop>
	 <20080715031202.GB4624@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:46224 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbYGOVMv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Jul 2008 17:12:51 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m6FLCokS028982
	for <linux-ext4@vger.kernel.org>; Tue, 15 Jul 2008 17:12:50 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6FLCoKs220628
	for <linux-ext4@vger.kernel.org>; Tue, 15 Jul 2008 17:12:50 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6FLCo3L016380
	for <linux-ext4@vger.kernel.org>; Tue, 15 Jul 2008 17:12:50 -0400
In-Reply-To: <20080715031202.GB4624@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-07-15=E4=BA=8C=E7=9A=84 08:42 +0530=EF=BC=8CAneesh Kumar=
 K.V=E5=86=99=E9=81=93=EF=BC=9A
> On Mon, Jul 14, 2008 at 10:54:36AM -0700, Mingming Cao wrote:
> >=20
> > =E5=9C=A8 2008-07-14=E4=B8=80=E7=9A=84 22:23 +0530=EF=BC=8CAneesh K=
umar K.V=E5=86=99=E9=81=93=EF=BC=9A
> > > On Mon, Jul 14, 2008 at 09:28:17AM -0700, Mingming Cao wrote:
> > > >=20
> > > > Ext4: Fix delalloc enospace handling counter update race
> > > >=20
> > > > From: Mingming Cao <cmm@us.ibm.com>
> >=20
> > > > Also in the case of truncate, we should not clear the per-alloc=
ation allocated
> > > > metablocks counter as that may be in-use by parallel allocation=
=2E The patch
> > > > only clear the per-allocation allocated metablocks when allocat=
ion is successfully returned.
> > > >=20
> > > >=20
> > > > Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> > >=20
> > > Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> >=20
> >=20
> > > > @@ -1519,7 +1529,8 @@ void ext4_da_release_space(struct inode=20
> > > >=20
> > > >  	BUG_ON(mdb > EXT4_I(inode)->i_reserved_meta_blocks);
> > > >  	EXT4_I(inode)->i_reserved_meta_blocks =3D mdb;
> > > > -	EXT4_I(inode)->i_allocated_meta_blocks =3D 0;
> > > > +	if (used)
> > > > +		EXT4_I(inode)->i_allocated_meta_blocks =3D 0;
> > > >  	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> > > >  }
> > > >=20
> >=20
> > After think again, this part of race fix may not needed, when the f=
irst
> > part of patch is applied. Since truncate is also hold the i_data_se=
m, so
> > it could be assured that when truncate is releasing the page's  res=
erved
> > blocks, there is no parallel block allocation.
>=20
> But truncate calls invalidate_page without holding i_data_sem.
>=20
> vmtruncate -> truncate_inode_pages -> invalidate_page.
>=20

Just for the benefit of the readers on the list, we have discussed this
on IRC, the race between truncate and parallel allocation is probably
not cause incorrect free blocks accounting,  but the code is confusing
in the current way. So it's worth a seperate cleanup patch later.

Mingming

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
