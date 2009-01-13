From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH V5 1/5] quota: Add reservation support for delayed
	block allocation
Date: Tue, 13 Jan 2009 10:53:17 -0800
Message-ID: <1231872797.8719.6.camel@mingming-laptop>
References: <1231216808.9267.22.camel@mingming-laptop>
	 <20090106100645.GH10705@duck.suse.cz>
	 <1231805946.6752.17.camel@mingming-laptop>
	 <20090113153748.GE10064@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andrew Morton <akpm@linux-foundation.org>, tytso <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:38844 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698AbZAMSxU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Jan 2009 13:53:20 -0500
In-Reply-To: <20090113153748.GE10064@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2009-01-13=E4=BA=8C=E7=9A=84 16:37 +0100=EF=BC=8CJan Kara=E5=86=
=99=E9=81=93=EF=BC=9A
> On Mon 12-01-09 16:19:06, Mingming Cao wrote:
> > Thanks for your review and suggestions. All points are taken. I hav=
e
> > updated the quota patches.I am attaching the updated patch here jus=
t for
> > your review.
> >=20
> > I am waiting for the ext4 tree to updated to rebase the whole serie=
s
> > against 2.6.29-rc1 plus ext4 patch queue. =20
> >=20
>   <snip>
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
>   The patch is fine. You can add
>=20
>   Acked-by: Jan Kara <jack@suse.cz>
>=20
>   How do you want to merge the patches? Via ext4 patch queue?
> There's one generic quota patch that I also need to push to fix some =
OCFS2
> issue and it collides with your patchset. And also there're further
> cleanups in quota code which are long overdue which I want to base on=
 all
> other patches. So I've decided to setup quota git tree. I'll pull in =
your
> two VFS quota patches. Will that work for you?

I think a quota tree is the best place to hold all these quota changes.
The ext4 part probably make sense to stay together with the vfs changes=
,
but it will need to coordinate with Ted's ext4 tree.  Ted, what do you
think?

BTW, there are other two quota cleanup patches that you have already
acked. I will sent the 2.6.29-rc1 based version.

>   The tree should be soon at:
> git.kernel.org/pub/scm/linux/kernel/git/jack/linux-quota-2.6.git
>   The branch you can pull from is for_next (or for_mm if there'll be
> some more long term experimental stuff but I'm not aware of anything =
like
> that now).
>=20
> 								Honza
>=20
> > ---
> >  fs/dquot.c               |  117 ++++++++++++++++++++++++++++++++++=
-------------
> >  include/linux/quota.h    |    3 +
> >  include/linux/quotaops.h |   21 ++++++++
> >  3 files changed, 110 insertions(+), 31 deletions(-)
> >=20
> > Index: linux-2.6.28-git7/fs/dquot.c
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux-2.6.28-git7.orig/fs/dquot.c	2009-01-06 10:55:08.000000000=
 -0800
> > +++ linux-2.6.28-git7/fs/dquot.c	2009-01-06 15:42:31.000000000 -080=
0
> > @@ -898,6 +898,11 @@ static inline void dquot_incr_space(stru
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
> >  	if (sb_dqopt(dquot->dq_sb)->flags & DQUOT_NEGATIVE_USAGE ||
> > @@ -1067,7 +1072,11 @@ err_out:
> >  	kfree_skb(skb);
> >  }
> >  #endif
> > -
> > +/*
> > + * Write warnings to the console and send warning messages over ne=
tlink.
> > + *
> > + * Note that this function can sleep.
> > + */
> >  static inline void flush_warnings(struct dquot * const *dquots, ch=
ar *warntype)
> >  {
> >  	int i;
> > @@ -1128,13 +1137,18 @@ static int check_idq(struct dquot *dquot
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
> > @@ -1142,7 +1156,7 @@ static int check_bdq(struct dquot *dquot
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
> > @@ -1151,7 +1165,7 @@ static int check_bdq(struct dquot *dquot
> >  	}
> > =20
> >  	if (dquot->dq_dqb.dqb_bsoftlimit &&
> > -	    dquot->dq_dqb.dqb_curspace + space > dquot->dq_dqb.dqb_bsoftl=
imit &&
> > +	    tspace > dquot->dq_dqb.dqb_bsoftlimit &&
> >  	    dquot->dq_dqb.dqb_btime =3D=3D 0) {
> >  		if (!prealloc) {
> >  			*warntype =3D QUOTA_NL_BSOFTWARN;
> > @@ -1292,51 +1306,92 @@ void vfs_dq_drop(struct inode *inode)
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
> > +	if (!reserve)
> > +		inode_add_bytes(inode, number);
> > +out_unlock:
> >  	spin_unlock(&dq_data_lock);
> > -	if (ret =3D=3D QUOTA_OK)
> > -		/* Dirtify all the dquots - this can block when journalling */
> > -		for (cnt =3D 0; cnt < MAXQUOTAS; cnt++)
> > -			if (inode->i_dquot[cnt])
> > -				mark_dquot_dirty(inode->i_dquot[cnt]);
> >  	flush_warnings(inode->i_dquot, warntype);
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
> > +	if (IS_NOQUOTA(inode)) {
> > +		inode_add_bytes(inode, number);
> > +		goto out;
> > +	}
> > +
> > +	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> > +	if (IS_NOQUOTA(inode)) {
> > +		inode_add_bytes(inode, number);
> > +		goto out_unlock;
> > +	}
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
> >  	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> > +out:
> > +	return ret;
> > +}
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
> > +	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> > +out:
> >  	return ret;
> >  }
> > +EXPORT_SYMBOL(dquot_reserve_space);
> > =20
> >  /*
> >   * This operation can block, but only after everything is updated
> > @@ -2025,7 +2080,7 @@ static void do_get_dqblk(struct dquot *d
> >  	spin_lock(&dq_data_lock);
> >  	di->dqb_bhardlimit =3D stoqb(dm->dqb_bhardlimit);
> >  	di->dqb_bsoftlimit =3D stoqb(dm->dqb_bsoftlimit);
> > -	di->dqb_curspace =3D dm->dqb_curspace;
> > +	di->dqb_curspace =3D dm->dqb_curspace + dm->dqb_rsvspace;
> >  	di->dqb_ihardlimit =3D dm->dqb_ihardlimit;
> >  	di->dqb_isoftlimit =3D dm->dqb_isoftlimit;
> >  	di->dqb_curinodes =3D dm->dqb_curinodes;
> > @@ -2067,7 +2122,7 @@ static int do_set_dqblk(struct dquot *dq
> > =20
> >  	spin_lock(&dq_data_lock);
> >  	if (di->dqb_valid & QIF_SPACE) {
> > -		dm->dqb_curspace =3D di->dqb_curspace;
> > +		dm->dqb_curspace =3D di->dqb_curspace - dm->dqb_rsvspace;
> >  		check_blim =3D 1;
> >  		__set_bit(DQ_LASTSET_B + QIF_SPACE_B, &dquot->dq_flags);
> >  	}
> > Index: linux-2.6.28-git7/include/linux/quota.h
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux-2.6.28-git7.orig/include/linux/quota.h	2009-01-06 10:55:0=
8.000000000 -0800
> > +++ linux-2.6.28-git7/include/linux/quota.h	2009-01-06 15:40:14.000=
000000 -0800
> > @@ -198,6 +198,7 @@ struct mem_dqblk {
> >  	qsize_t dqb_bhardlimit;	/* absolute limit on disk blks alloc */
> >  	qsize_t dqb_bsoftlimit;	/* preferred limit on disk blks */
> >  	qsize_t dqb_curspace;	/* current used space */
> > +	qsize_t dqb_rsvspace;   /* current reserved space for delalloc*/
> >  	qsize_t dqb_ihardlimit;	/* absolute limit on allocated inodes */
> >  	qsize_t dqb_isoftlimit;	/* preferred inode limit */
> >  	qsize_t dqb_curinodes;	/* current # allocated inodes */
> > @@ -308,6 +309,8 @@ struct dquot_operations {
> >  	int (*release_dquot) (struct dquot *);		/* Quota is going to be d=
eleted from disk */
> >  	int (*mark_dirty) (struct dquot *);		/* Dquot is marked dirty */
> >  	int (*write_info) (struct super_block *, int);	/* Write of quota =
"superblock" */
> > +	/* reserve quota for delayed block allocation */
> > +	int (*reserve_space) (struct inode *, qsize_t, int);
> >  };
> > =20
> >  /* Operations handling requests from userspace */
> > Index: linux-2.6.28-git7/include/linux/quotaops.h
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux-2.6.28-git7.orig/include/linux/quotaops.h	2009-01-06 10:5=
5:08.000000000 -0800
> > +++ linux-2.6.28-git7/include/linux/quotaops.h	2009-01-06 15:40:14.=
000000000 -0800
> > @@ -185,6 +185,16 @@ static inline int vfs_dq_alloc_space(str
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
> > @@ -341,6 +351,11 @@ static inline int vfs_dq_alloc_space(str
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
> > @@ -378,6 +393,12 @@ static inline int vfs_dq_alloc_block(str
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
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
