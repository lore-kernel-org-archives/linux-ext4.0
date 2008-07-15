From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] Ext4: Fix delalloc enospace handling counter update
	race
Date: Tue, 15 Jul 2008 08:42:02 +0530
Message-ID: <20080715031202.GB4624@skywalker>
References: <200807130626.m6D6QMvj007916@imap1.linux-foundation.org> <20080714010828.GD7938@mit.edu> <1216052897.7937.1.camel@mingming-laptop> <20080714165324.GA3545@skywalker> <1216058076.6468.11.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:39964 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431AbYGODML (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Jul 2008 23:12:11 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id m6F3BW1u032716
	for <linux-ext4@vger.kernel.org>; Tue, 15 Jul 2008 13:11:32 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6F3C9dt2121808
	for <linux-ext4@vger.kernel.org>; Tue, 15 Jul 2008 13:12:09 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6F3C8gZ013454
	for <linux-ext4@vger.kernel.org>; Tue, 15 Jul 2008 13:12:08 +1000
Content-Disposition: inline
In-Reply-To: <1216058076.6468.11.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 14, 2008 at 10:54:36AM -0700, Mingming Cao wrote:
>=20
> =E5=9C=A8 2008-07-14=E4=B8=80=E7=9A=84 22:23 +0530=EF=BC=8CAneesh Kum=
ar K.V=E5=86=99=E9=81=93=EF=BC=9A
> > On Mon, Jul 14, 2008 at 09:28:17AM -0700, Mingming Cao wrote:
> > >=20
> > > Ext4: Fix delalloc enospace handling counter update race
> > >=20
> > > From: Mingming Cao <cmm@us.ibm.com>
>=20
> > > Also in the case of truncate, we should not clear the per-allocat=
ion allocated
> > > metablocks counter as that may be in-use by parallel allocation. =
The patch
> > > only clear the per-allocation allocated metablocks when allocatio=
n is successfully returned.
> > >=20
> > >=20
> > > Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> >=20
> > Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
>=20
>=20
> > > @@ -1519,7 +1529,8 @@ void ext4_da_release_space(struct inode=20
> > >=20
> > >  	BUG_ON(mdb > EXT4_I(inode)->i_reserved_meta_blocks);
> > >  	EXT4_I(inode)->i_reserved_meta_blocks =3D mdb;
> > > -	EXT4_I(inode)->i_allocated_meta_blocks =3D 0;
> > > +	if (used)
> > > +		EXT4_I(inode)->i_allocated_meta_blocks =3D 0;
> > >  	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> > >  }
> > >=20
>=20
> After think again, this part of race fix may not needed, when the fir=
st
> part of patch is applied. Since truncate is also hold the i_data_sem,=
 so
> it could be assured that when truncate is releasing the page's  reser=
ved
> blocks, there is no parallel block allocation.

But truncate calls invalidate_page without holding i_data_sem.

vmtruncate -> truncate_inode_pages -> invalidate_page.


-aneesh
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
