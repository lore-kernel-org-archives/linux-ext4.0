From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH V3 1/3] quota: Add reservation support for delayed
	block allocation
Date: Mon, 08 Dec 2008 17:24:44 -0800
Message-ID: <1228785884.6372.26.camel@mingming-laptop>
References: <1226014475.6430.57.camel@mingming-laptop>
	 <20081203172833.GB12803@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andrew Morton <akpm@linux-foundation.org>, tytso <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:34639 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbYLIBYy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Dec 2008 20:24:54 -0500
In-Reply-To: <20081203172833.GB12803@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Jan,

=E5=9C=A8 2008-12-03=E4=B8=89=E7=9A=84 18:33 +0100=EF=BC=8CJan Kara=E5=86=
=99=E9=81=93=EF=BC=9A
> Hi Mingming,
>=20
> On Thu 06-11-08 15:34:35, Mingming Cao wrote:
> > Quota: Add quota reservation support
> >=20
> > Delayed allocation defers the block allocation at the dirty pages
> > flush-out time, doing quota charge/check at that time is too late.
> > But we can't charge the quota blocks until blocks are really alloca=
ted,
> > otherwise users could get overcharged after reboot from system cras=
h.
> >=20
> > This patch adds quota reservation for delayed allocation. Quota blo=
cks
> > are reserved in memory, inode and quota won't gets dirtied until la=
ter
> > block allocation time.
> >=20
> > Signed-off-by: Mingming Cao <cmm@us.ibm.com>
>   I've finally got to reading your patches (I hope this is the last v=
ersion
> - at least it's the latest version I have ;). Sorry it took so long.

Not a problem, thanks for your comments..
> Here are some comments:
>=20
> > Index: linux-2.6.28-rc2/fs/dquot.c
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux-2.6.28-rc2.orig/fs/dquot.c	2008-11-06 13:36:21.000000000 =
-0800
> > +++ linux-2.6.28-rc2/fs/dquot.c	2008-11-06 14:04:10.000000000 -0800
> > @@ -841,6 +841,11 @@ static inline void dquot_incr_space(stru
> >  	dquot->dq_dqb.dqb_curspace +=3D number;
> >  }
> > =20
> > +static inline void dquot_resv_space(struct dquot *dquot, qsize_t n=
umber)
> > +{
> > +	dquot->dq_dqb.dqb_rsvspace +=3D number;
> > +}
> > +
> >  static inline void dquot_decr_inodes(struct dquot *dquot, qsize_t =
number)
> >  {
> >  	if (dquot->dq_dqb.dqb_curinodes > number)
> > @@ -1069,13 +1074,18 @@ static int check_idq(struct dquot *dquot
> >  /* needs dq_data_lock */
> >  static int check_bdq(struct dquot *dquot, qsize_t space, int preal=
loc, char *warntype)
> >  {
> > +	qsize_t tspace;
> > +
> >  	*warntype =3D QUOTA_NL_NOWARN;
> >  	if (!sb_has_quota_limits_enabled(dquot->dq_sb, dquot->dq_type) ||
> >  	    test_bit(DQ_FAKE_B, &dquot->dq_flags))
> >  		return QUOTA_OK;
> > =20
> > +	tspace =3D dquot->dq_dqb.dqb_curspace + dquot->dq_dqb.dqb_rsvspac=
e
> > +		+ space;
> > +
> >  	if (dquot->dq_dqb.dqb_bhardlimit &&
> > -	    dquot->dq_dqb.dqb_curspace + space > dquot->dq_dqb.dqb_bhardl=
imit &&
> > +	    tspace > dquot->dq_dqb.dqb_bhardlimit &&
> >              !ignore_hardlimit(dquot)) {
> >  		if (!prealloc)
> >  			*warntype =3D QUOTA_NL_BHARDWARN;
> > @@ -1083,7 +1093,7 @@ static int check_bdq(struct dquot *dquot
> >  	}
> > =20
> >  	if (dquot->dq_dqb.dqb_bsoftlimit &&
> > -	    dquot->dq_dqb.dqb_curspace + space > dquot->dq_dqb.dqb_bsoftl=
imit &&
> > +	    tspace > dquot->dq_dqb.dqb_bsoftlimit &&
> >  	    dquot->dq_dqb.dqb_btime && get_seconds() >=3D dquot->dq_dqb.d=
qb_btime &&
> >              !ignore_hardlimit(dquot)) {
> >  		if (!prealloc)
> > @@ -1092,7 +1102,7 @@ static int check_bdq(struct dquot *dquot
> >  	}
> > =20
> >  	if (dquot->dq_dqb.dqb_bsoftlimit &&
> > -	    dquot->dq_dqb.dqb_curspace + space > dquot->dq_dqb.dqb_bsoftl=
imit &&
> > +	    tspace > dquot->dq_dqb.dqb_bsoftlimit &&
> >  	    dquot->dq_dqb.dqb_btime =3D=3D 0) {
> >  		if (!prealloc) {
> >  			*warntype =3D QUOTA_NL_BSOFTWARN;
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
> > +		else
> > +			dquot_incr_space(inode->i_dquot[cnt], number);
> >  	}
> > -	inode_add_bytes(inode, number);
> > -	ret =3D QUOTA_OK;
> > -warn_put_all:
> > +out_unlock:
> > +	flush_warnings(inode->i_dquot, warntype);
> >  	spin_unlock(&dq_data_lock);
> > +	return ret;
> > +}
> > +
> > +int dquot_alloc_space(struct inode *inode, qsize_t number, int war=
n)
> > +{
> > +	int cnt, ret =3D QUOTA_OK;
> > +
> > +	/*
> > +	 * First test before acquiring mutex - solves deadlocks when we
> > +	 * re-enter the quota code and are already holding the mutex
> > +	 */
> > +	if (IS_NOQUOTA(inode))
> > +		goto out;
> > +
> > +	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> > +	if (IS_NOQUOTA(inode))
> > +		goto out_unlock;
> > +
> > +	ret =3D __dquot_alloc_space(inode, number, warn, 0);
> > +	if (ret =3D=3D NO_QUOTA)
> > +		goto out_unlock;
> > +
> > +	/* Dirtify all the dquots - this can block when journalling */
> > +	for (cnt =3D 0; cnt < MAXQUOTAS; cnt++)
> > +		if (inode->i_dquot[cnt])
> > +			mark_dquot_dirty(inode->i_dquot[cnt]);
> > +out_unlock:
> > +	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> > +out:
> >  	if (ret =3D=3D QUOTA_OK)
> > -		/* Dirtify all the dquots - this can block when journalling */
> > -		for (cnt =3D 0; cnt < MAXQUOTAS; cnt++)
> > -			if (inode->i_dquot[cnt])
> > -				mark_dquot_dirty(inode->i_dquot[cnt]);
> > -	flush_warnings(inode->i_dquot, warntype);
> > +		inode_add_bytes(inode, number);
> > +	return ret;
> > +}
>   Doing inode_add_bytes() here can cause some trouble - we have to ma=
ke
> sure that the amount of space quota knows (in dqb_space) about and th=
e amount
> of space in i_blocks is always the same. We have to keep this invaria=
nt
> because of concurrent write() and chown/chgrp() calls. So we use dq_d=
ata_lock
> and make both the change to quota usage and i_blocks under that spinl=
ock.
> And you've moved the change of i_blocks outside of dq_data_lock. In
> practice this need not be a problem since other locks (i_mutex) might
> provide enough synchronization but I'd rather see inode_add_bytes() i=
nside
> the dq_data_lock together with the quota usage change.
>=20

Ok,  I could move i_blocks update under the protection of dq_data_lock.
I wasn't clear if we need that protection before.:)  The intention to
move inode_add_bytes(inode, number) out of the __dquot_alloc_space() is
to avoid doing i_blocks update for dquot block reservation.


> > +
> > +int dquot_reserve_space(struct inode *inode, qsize_t number, int w=
arn)
> > +{
> > +	int ret =3D QUOTA_OK;
> > +
> > +	if (IS_NOQUOTA(inode))
> > +		goto out;
> > +
> > +	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> > +	if (IS_NOQUOTA(inode))
> > +		goto out_unlock;
> > +
> > +	ret =3D __dquot_alloc_space(inode, number, warn, 1);
> > +out_unlock:
> >  	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> > +out:
> >  	return ret;
> >  }
> > =20
> > @@ -1958,7 +2004,7 @@ static void do_get_dqblk(struct dquot *d
> >  	spin_lock(&dq_data_lock);
> >  	di->dqb_bhardlimit =3D stoqb(dm->dqb_bhardlimit);
> >  	di->dqb_bsoftlimit =3D stoqb(dm->dqb_bsoftlimit);
> > -	di->dqb_curspace =3D dm->dqb_curspace;
> > +	di->dqb_curspace =3D dm->dqb_curspace + dm->dqb_rsvspace;
> >  	di->dqb_ihardlimit =3D dm->dqb_ihardlimit;
> >  	di->dqb_isoftlimit =3D dm->dqb_isoftlimit;
> >  	di->dqb_curinodes =3D dm->dqb_curinodes;
>   OK, but you should probably subtract dqb_rsvspace from the amount
> provided by userspace in do_set_dqblk(). Setting usage is inherently
> dangerous thing if fs is used and admin should know what he's doing b=
ut
> I think setting it so that "total used space" is what admin meant is =
the
> way of the least surprise.
>=20

Thanks for point this out, I will make the change.

> > @@ -2297,6 +2343,7 @@ EXPORT_SYMBOL(dquot_alloc_space);
> >  EXPORT_SYMBOL(dquot_alloc_inode);
> >  EXPORT_SYMBOL(dquot_free_space);
> >  EXPORT_SYMBOL(dquot_free_inode);
> > +EXPORT_SYMBOL(dquot_reserve_space);
> >  EXPORT_SYMBOL(dquot_transfer);
> >  EXPORT_SYMBOL(vfs_dq_transfer);
> >  EXPORT_SYMBOL(vfs_dq_quota_on_remount);
> > Index: linux-2.6.28-rc2/include/linux/quota.h
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux-2.6.28-rc2.orig/include/linux/quota.h	2008-11-06 13:36:21=
=2E000000000 -0800
> > +++ linux-2.6.28-rc2/include/linux/quota.h	2008-11-06 14:04:01.0000=
00000 -0800
> > @@ -186,6 +186,7 @@ struct mem_dqblk {
> >  	qsize_t dqb_bhardlimit;	/* absolute limit on disk blks alloc */
> >  	qsize_t dqb_bsoftlimit;	/* preferred limit on disk blks */
> >  	qsize_t dqb_curspace;	/* current used space */
> > +	qsize_t dqb_rsvspace;   /* current reserved space for delalloc*/
> >  	qsize_t dqb_ihardlimit;	/* absolute limit on allocated inodes */
> >  	qsize_t dqb_isoftlimit;	/* preferred inode limit */
> >  	qsize_t dqb_curinodes;	/* current # allocated inodes */
> > @@ -291,6 +292,7 @@ struct dquot_operations {
> >  	int (*release_dquot) (struct dquot *);		/* Quota is going to be d=
eleted from disk */
> >  	int (*mark_dirty) (struct dquot *);		/* Dquot is marked dirty */
> >  	int (*write_info) (struct super_block *, int);	/* Write of quota =
"superblock" */
> > +	int (*reserve_space) (struct inode *, qsize_t, int); /* reserve q=
uota for delayed block allocation */
> >  };
> > =20
> >  /* Operations handling requests from userspace */
> > Index: linux-2.6.28-rc2/include/linux/quotaops.h
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux-2.6.28-rc2.orig/include/linux/quotaops.h	2008-11-06 13:36=
:21.000000000 -0800
> > +++ linux-2.6.28-rc2/include/linux/quotaops.h	2008-11-06 14:04:10.0=
00000000 -0800
> > @@ -176,6 +176,16 @@ static inline int vfs_dq_alloc_space(str
> >  	return ret;
> >  }
> > =20
> > +static inline int vfs_dq_reserve_space(struct inode *inode, qsize_=
t nr)
> > +{
> > +	if (sb_any_quota_active(inode->i_sb)) {
> > +		/* Used space is updated in alloc_space() */
> > +		if (inode->i_sb->dq_op->reserve_space(inode, nr, 0) =3D=3D NO_QU=
OTA)
> > +			return 1;
> > +	}
> > +	return 0;
> > +}
> > +
> >  static inline int vfs_dq_alloc_inode(struct inode *inode)
> >  {
> >  	if (sb_any_quota_active(inode->i_sb)) {
> > @@ -327,6 +337,11 @@ static inline int vfs_dq_alloc_space(str
> >  	return 0;
> >  }
> > =20
> > +static inline int vfs_dq_reserve_space(struct inode *inode, qsize_=
t nr)
> > +{
> > +	return 0;
> > +}
> > +
> >  static inline void vfs_dq_free_space_nodirty(struct inode *inode, =
qsize_t nr)
> >  {
> >  	inode_sub_bytes(inode, nr);
> > @@ -358,12 +373,19 @@ static inline int vfs_dq_alloc_block_nod
> >  			nr << inode->i_sb->s_blocksize_bits);
> >  }
> > =20
> > +
> >  static inline int vfs_dq_alloc_block(struct inode *inode, qsize_t =
nr)
> >  {
> >  	return vfs_dq_alloc_space(inode,
> >  			nr << inode->i_sb->s_blocksize_bits);
> >  }
> > =20
> > +static inline int vfs_dq_reserve_block(struct inode *inode, qsize_=
t nr)
> > +{
> > +	return vfs_dq_reserve_space(inode,
> > +			nr << inode->i_blkbits);
> > +}
> > +
> >  static inline void vfs_dq_free_block_nodirty(struct inode *inode, =
qsize_t nr)
> >  {
> >  	vfs_dq_free_space_nodirty(inode, nr << inode->i_sb->s_blocksize_b=
its);
> > @@ -392,6 +414,7 @@ static inline void vfs_dq_free_block(str
> >  #define DQUOT_ALLOC_BLOCK_NODIRTY(inode, nr) \
> >  				vfs_dq_alloc_block_nodirty(inode, nr)
> >  #define DQUOT_ALLOC_BLOCK(inode, nr) vfs_dq_alloc_block(inode, nr)
> > +#define DQUOT_RESERVE_BLOCK(inode, nr) vfs_dq_reserve_block(inode,=
 nr)
>   These defines should go away as soon as I get to grepping all the
> filesystems and converting them to new lowercase function names. So t=
here's
> no need of adding this one.
>=20

Will do.

> >  #define DQUOT_ALLOC_INODE(inode) vfs_dq_alloc_inode(inode)
> >  #define DQUOT_FREE_SPACE_NODIRTY(inode, nr) \
> >  				vfs_dq_free_space_nodirty(inode, nr)
> >=20
>=20
> 									Honza

Thanks again for your feedback.

Mingming

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
