From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH V4 1/3] quota: Add reservation support for delayed
	block allocation
Date: Mon, 05 Jan 2009 20:32:24 -0800
Message-ID: <1231216344.9267.7.camel@mingming-laptop>
References: <1229114856.7646.25.camel@mingming-laptop>
	 <20081215131608.GC15464@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andrew Morton <akpm@linux-foundation.org>, tytso <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:43169 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbZAFEc2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Jan 2009 23:32:28 -0500
In-Reply-To: <20081215131608.GC15464@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-12-15=E4=B8=80=E7=9A=84 14:16 +0100=EF=BC=8CJan Kara=E5=86=
=99=E9=81=93=EF=BC=9A
> Hi Minming,
>=20
> On Fri 12-12-08 12:47:36, Mingming Cao wrote:
> > Quota: Add quota reservation support
> >=20
> > Delayed allocation defers the block allocation at the dirty pages
> > flush-out time, doing quota charge/check at that time is too late.
> > But we can't charge the quota blocks until blocks are really alloca=
ted,
> > otherwise users could get overcharged after reboot from system cras=
h.
> >=20
> > This patch adds quota reservation for delayed llocation. Quota bloc=
ks
> > are reserved in memory, inode and quota won't gets dirtied until la=
ter
> > block allocation time.
> >=20
> > Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> >=20
> >=20
> > ---
> >  fs/dquot.c               |  109 +++++++++++++++++++++++++++++++++-=
-------------
> >  include/linux/quota.h    |    2=20
> >  include/linux/quotaops.h |   22 +++++++++
> >  3 files changed, 102 insertions(+), 31 deletions(-)
> >=20
> > Index: linux-2.6.28-rc2/fs/dquot.c
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux-2.6.28-rc2.orig/fs/dquot.c	2008-11-06 13:36:21.000000000 =
-0800
> > +++ linux-2.6.28-rc2/fs/dquot.c	2008-12-12 12:20:45.000000000 -0800
> <snip>
> > @@ -1227,49 +1237,85 @@ void vfs_dq_drop(struct inode *inode)
> >  /*
> >   * This operation can block, but only after everything is updated
> >   */
> > -int dquot_alloc_space(struct inode *inode, qsize_t number, int war=
n)
> > +int __dquot_alloc_space(struct inode *inode, qsize_t number,
> > +			int warn, int reserve)
> >  {
> > -	int cnt, ret =3D NO_QUOTA;
> > +	int cnt, ret =3D QUOTA_OK;
> >  	char warntype[MAXQUOTAS];
> > =20
> > -	/* First test before acquiring mutex - solves deadlocks when we
> > -         * re-enter the quota code and are already holding the mut=
ex */
> > -	if (IS_NOQUOTA(inode)) {
> > -out_add:
> > -		inode_add_bytes(inode, number);
> > -		return QUOTA_OK;
> > -	}
> >  	for (cnt =3D 0; cnt < MAXQUOTAS; cnt++)
> >  		warntype[cnt] =3D QUOTA_NL_NOWARN;
> > =20
> > -	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> > -	if (IS_NOQUOTA(inode)) {	/* Now we can do reliable test... */
> > -		up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> > -		goto out_add;
> > -	}
> >  	spin_lock(&dq_data_lock);
> >  	for (cnt =3D 0; cnt < MAXQUOTAS; cnt++) {
> >  		if (inode->i_dquot[cnt] =3D=3D NODQUOT)
> >  			continue;
> > -		if (check_bdq(inode->i_dquot[cnt], number, warn, warntype+cnt) =3D=
=3D NO_QUOTA)
> > -			goto warn_put_all;
> > +		if (check_bdq(inode->i_dquot[cnt], number, warn, warntype+cnt)
> > +		    =3D=3D NO_QUOTA) {
> > +			ret =3D NO_QUOTA;
> > +			goto out_unlock;
> > +		}
> >  	}
> >  	for (cnt =3D 0; cnt < MAXQUOTAS; cnt++) {
> >  		if (inode->i_dquot[cnt] =3D=3D NODQUOT)
> >  			continue;
> > -		dquot_incr_space(inode->i_dquot[cnt], number);
> > +		if (reserve)
> > +			dquot_resv_space(inode->i_dquot[cnt], number);
> > +		else{
>                     ^ here is missing space
>=20

Okay, will fix that.
> > +			dquot_incr_space(inode->i_dquot[cnt], number);
> > +			inode_add_bytes(inode, number);
> > +		}
> >  	}
> > -	inode_add_bytes(inode, number);
> > -	ret =3D QUOTA_OK;
> > -warn_put_all:
> > -	spin_unlock(&dq_data_lock);
> > -	if (ret =3D=3D QUOTA_OK)
> > -		/* Dirtify all the dquots - this can block when journalling */
> > -		for (cnt =3D 0; cnt < MAXQUOTAS; cnt++)
> > -			if (inode->i_dquot[cnt])
> > -				mark_dquot_dirty(inode->i_dquot[cnt]);
> > +out_unlock:
> >  	flush_warnings(inode->i_dquot, warntype);
> > +	spin_unlock(&dq_data_lock);
>   We can't do flush_warnings() inside the spinlock - that function ca=
n
> sleep. Please move the call outside the lock.
>=20

Ok, Will do.

Mingming

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
