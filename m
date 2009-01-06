From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH V4 2/3] quota: Add quota claim and release reserved
	quota blocks operations
Date: Mon, 05 Jan 2009 20:32:43 -0800
Message-ID: <1231216363.9267.9.camel@mingming-laptop>
References: <1229114860.7646.26.camel@mingming-laptop>
	 <20081215134016.GD15464@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andrew Morton <akpm@linux-foundation.org>, tytso <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:37561 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbZAFEcs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Jan 2009 23:32:48 -0500
In-Reply-To: <20081215134016.GD15464@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Jan,

Thanks for your comments. Sorry for the late the response while holiday
in the way.

=E5=9C=A8 2008-12-15=E4=B8=80=E7=9A=84 14:40 +0100=EF=BC=8CJan Kara=E5=86=
=99=E9=81=93=EF=BC=9A
> Hi Mingming,
>=20
>   sorry I spoke to soon in my previous email. You tried to resolve th=
e
> issue with dquot_transfer(). I just thought it would belong to the fi=
rst
> patch...
>=20
> On Fri 12-12-08 12:47:40, Mingming Cao wrote:
> > quota: Add quota reservation claim and released operations
> >=20
> > Reserved quota will be claimed at the block allocation time. Over-b=
ooked
> > quota could be returned back with the release callback function.
> >=20
> > Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> > ---
> >  fs/dquot.c               |  101 ++++++++++++++++++++++++++++++++++=
+++++++++++--
> >  include/linux/quota.h    |    4 +
> >  include/linux/quotaops.h |   53 ++++++++++++++++++++++++
> >  3 files changed, 153 insertions(+), 5 deletions(-)
> >=20
>   <snip>
>=20
> > Index: linux-2.6.28-rc2/fs/dquot.c
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux-2.6.28-rc2.orig/fs/dquot.c	2008-12-12 12:20:45.000000000 =
-0800
> > +++ linux-2.6.28-rc2/fs/dquot.c	2008-12-12 12:21:49.000000000 -0800
>   <snip>
>=20
> > @@ -1448,7 +1532,8 @@ int dquot_free_inode(const struct inode=20
> >   */
> >  int dquot_transfer(struct inode *inode, struct iattr *iattr)
> >  {
> > -	qsize_t space;
> > +	qsize_t space, cur_space;
> > +	qsize_t rsv_space =3D 0;
> >  	struct dquot *transfer_from[MAXQUOTAS];
> >  	struct dquot *transfer_to[MAXQUOTAS];
> >  	int cnt, ret =3D NO_QUOTA, chuid =3D (iattr->ia_valid & ATTR_UID)=
 && inode->i_uid !=3D iattr->ia_uid,
> > @@ -1489,12 +1574,16 @@ int dquot_transfer(struct inode *inode,=20
> >  		}
> >  	}
> >  	spin_lock(&dq_data_lock);
> > -	space =3D inode_get_bytes(inode);
> > +	space =3D cur_space =3D inode_get_bytes(inode);
> >  	/* Build the transfer_from list and check the limits */
> >  	for (cnt =3D 0; cnt < MAXQUOTAS; cnt++) {
> >  		if (transfer_to[cnt] =3D=3D NODQUOT)
> >  			continue;
> >  		transfer_from[cnt] =3D inode->i_dquot[cnt];
> > +		if (!rsv_space) {
> > +			rsv_space =3D transfer_from[cnt]->dq_dqb.dqb_rsvspace;
> > +			space +=3D rsv_space;
>   Hmm, but you cannot simply transfer all the reserved space from one=
 user
> to another. You have to transfer just the amount reserved for this in=
ode
> (i.e. EXT4_I(inode)->i_reserved_data_blocks +
> EXT4_I(inode)->i_reserved_meta_blocks). The fact is this is not avail=
able
> to quota code. One possibility is to store this number in VFS inode (=
which I
> guess people would not like because it would increase every inode siz=
e by 8
> bytes). So probably more plausible is to provide a callback so that q=
uota
> code can find out how much space this inode has reserved. This is not=
 a
> performance critical operation so the cost of the function call is
> acceptable here IMO.
>=20


You are right,  that's what I was misunderstand before. I will send out
updated quota patches.


Mingming
> > +		}
> >  		if (check_idq(transfer_to[cnt], 1, warntype_to + cnt) =3D=3D
> >  		    NO_QUOTA || check_bdq(transfer_to[cnt], space, 0,
> >  		    warntype_to + cnt) =3D=3D NO_QUOTA)
> > @@ -1518,11 +1607,13 @@ int dquot_transfer(struct inode *inode,=20
> >  			warntype_from_space[cnt] =3D
> >  				info_bdq_free(transfer_from[cnt], space);
> >  			dquot_decr_inodes(transfer_from[cnt], 1);
> > -			dquot_decr_space(transfer_from[cnt], space);
> > +			dquot_decr_space(transfer_from[cnt], cur_space);
> > +			dquot_free_reserved_space(transfer_from[cnt], rsv_space);
> >  		}
> > =20
> >  		dquot_incr_inodes(transfer_to[cnt], 1);
> > -		dquot_incr_space(transfer_to[cnt], space);
> > +		dquot_incr_space(transfer_to[cnt], cur_space);
> > +		dquot_resv_space(transfer_to[cnt], rsv_space);
> > =20
> >  		inode->i_dquot[cnt] =3D transfer_to[cnt];
> >  	}
>=20
> 								Honza

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
