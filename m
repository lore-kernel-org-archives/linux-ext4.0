From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [RFC PATCH 1/3] quota: Add reservation support for delayed
	block allocation
Date: Fri, 31 Oct 2008 14:22:46 -0700
Message-ID: <1225488166.7600.5.camel@mingming-laptop>
References: <1225328355.6405.34.camel@mingming-laptop>
	 <20081031081509.GF4476@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4 <linux-ext4@vger.kernel.org>, tytso <tytso@mit.edu>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:52261 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364AbYJaVWs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 31 Oct 2008 17:22:48 -0400
In-Reply-To: <20081031081509.GF4476@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-10-31=E4=BA=94=E7=9A=84 09:15 +0100=EF=BC=8CJan Kara=E5=86=
=99=E9=81=93=EF=BC=9A
> Hi Mingming,
>=20
>   I had a quick look at your patches and they look fine. I'm now leav=
ing
> on vacation for two weeks so I won't be responding for a while.
>=20

Thanks for the note. I will send version2 of the patches (mostly fix a
bug in the ext4 patch) and add to ext4 patch queue for more testing.
Overall the patches on top of yours does what's expected: keep quota
blocks consistent with file blocks before/after crash for delayed
allocation.

cheers,
Mingming
> 								Honza
>=20
> On Wed 29-10-08 17:59:15, Mingming Cao wrote:
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
> > ---
> >  fs/dquot.c               |  113 ++++++++++++++++++++++++++++++++++=
-------------
> >  include/linux/quota.h    |    2=20
> >  include/linux/quotaops.h |   30 ++++++++++++
> >  3 files changed, 115 insertions(+), 30 deletions(-)
> >=20
> > Index: linux-2.6.28-rc2/fs/dquot.c
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux-2.6.28-rc2.orig/fs/dquot.c	2008-10-28 16:01:44.000000000 =
-0700
> > +++ linux-2.6.28-rc2/fs/dquot.c	2008-10-28 16:34:36.000000000 -0700
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
> > @@ -1227,48 +1237,90 @@ void vfs_dq_drop(struct inode *inode)
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
> > -	spin_unlock(&dq_data_lock);
> > -	if (ret =3D=3D QUOTA_OK)
> > -		/* Dirtify all the dquots - this can block when journalling */
> > -		for (cnt =3D 0; cnt < MAXQUOTAS; cnt++)
> > -			if (inode->i_dquot[cnt])
> > -				mark_dquot_dirty(inode->i_dquot[cnt]);
> > +out_unlock:
> >  	flush_warnings(inode->i_dquot, warntype);
> > +	spin_unlock(&dq_data_lock);
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
> > +         * re-enter the quota code and are already holding the mut=
ex
> > +         */
> > +	if (IS_NOQUOTA(inode)) {
> > +		inode_add_bytes(inode, number);
> > +		return ret;
> > +	}
> > +
> > +	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> > +	if (IS_NOQUOTA(inode))	{
> > +		/* Now we can do reliable test... */
> > +		up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> > +		inode_add_bytes(inode, number);
> > +		return ret;
> > +	}
> > +
> > +	ret =3D __dquot_alloc_space(inode, number, warn, 0);
> > +	if (ret =3D=3D NO_QUOTA) {
> > +		up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> > +		return ret;
> > +	}
> > +
> > +	/* Dirtify all the dquots - this can block when journalling */
> > +	for (cnt =3D 0; cnt < MAXQUOTAS; cnt++)
> > +		if (inode->i_dquot[cnt])
> > +			mark_dquot_dirty(inode->i_dquot[cnt]);
> > +	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> > +	inode_add_bytes(inode, number);
> > +	return ret;
> > +}
> > +
> > +int dquot_reserve_space(struct inode *inode, qsize_t number, int w=
arn)
> > +{
> > +	int ret =3D QUOTA_OK;
> > +
> > +	if (IS_NOQUOTA(inode))
> > +		return ret;
> > +
> > +	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> > +	if (IS_NOQUOTA(inode))	{
> > +		/* Now we can do reliable test... */
> > +		up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> > +		return ret;
> > +	}
> > +
> > +	ret =3D __dquot_alloc_space(inode, number, warn, 1);
> >  	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> >  	return ret;
> >  }
> > @@ -1958,7 +2010,7 @@ static void do_get_dqblk(struct dquot *d
> >  	spin_lock(&dq_data_lock);
> >  	di->dqb_bhardlimit =3D stoqb(dm->dqb_bhardlimit);
> >  	di->dqb_bsoftlimit =3D stoqb(dm->dqb_bsoftlimit);
> > -	di->dqb_curspace =3D dm->dqb_curspace;
> > +	di->dqb_curspace =3D dm->dqb_curspace + dm->dqb_rsvspace;
> >  	di->dqb_ihardlimit =3D dm->dqb_ihardlimit;
> >  	di->dqb_isoftlimit =3D dm->dqb_isoftlimit;
> >  	di->dqb_curinodes =3D dm->dqb_curinodes;
> > @@ -2297,6 +2349,7 @@ EXPORT_SYMBOL(dquot_alloc_space);
> >  EXPORT_SYMBOL(dquot_alloc_inode);
> >  EXPORT_SYMBOL(dquot_free_space);
> >  EXPORT_SYMBOL(dquot_free_inode);
> > +EXPORT_SYMBOL (dquot_reserve_space);
> >  EXPORT_SYMBOL(dquot_transfer);
> >  EXPORT_SYMBOL(vfs_dq_transfer);
> >  EXPORT_SYMBOL(vfs_dq_quota_on_remount);
> > Index: linux-2.6.28-rc2/include/linux/quota.h
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux-2.6.28-rc2.orig/include/linux/quota.h	2008-10-28 16:01:46=
=2E000000000 -0700
> > +++ linux-2.6.28-rc2/include/linux/quota.h	2008-10-28 16:36:12.0000=
00000 -0700
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
> > --- linux-2.6.28-rc2.orig/include/linux/quotaops.h	2008-10-28 16:01=
:43.000000000 -0700
> > +++ linux-2.6.28-rc2/include/linux/quotaops.h	2008-10-28 16:39:38.0=
00000000 -0700
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
> > +			nr << inode->i_sb->s_blocksize_bits);
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
> >  #define DQUOT_ALLOC_INODE(inode) vfs_dq_alloc_inode(inode)
> >  #define DQUOT_FREE_SPACE_NODIRTY(inode, nr) \
> >  				vfs_dq_free_space_nodirty(inode, nr)
> >=20
> >=20

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
