From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH V3 2/3] quota: Add quota claim and release reserved
	quota
Date: Mon, 08 Dec 2008 17:49:22 -0800
Message-ID: <1228787362.6372.41.camel@mingming-laptop>
References: <20081203190639.GD12803@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20081203190639.GD12803@duck.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


=E5=9C=A8 2008-12-03=E4=B8=89=E7=9A=84 20:06 +0100=EF=BC=8CJan Kara=E5=86=
=99=E9=81=93=EF=BC=9A
> Hmm, I can't find the email with this patch so I've just copied it fr=
om
> some mail archive ;). Sorry if the CC's are wrong.
>=20
> > quota: Add quota reservation claim and released operations
> >=20
> > Reserved quota will be claimed at the block allocation time. Over-b=
ooked
> > quota could be returned back with the release callback function.
> >=20
> > Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> > ---
> >  fs/dquot.c               |   87 ++++++++++++++++++++++++++++++++++=
+++++++++++++
> >  include/linux/quota.h    |    4 +-
> >  include/linux/quotaops.h |   55 +++++++++++++++++++++++++++++
> >  3 files changed, 145 insertions(+), 1 deletion(-)
> >=20
> > Index: linux-2.6.28-rc2/include/linux/quota.h
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux-2.6.28-rc2.orig/include/linux/quota.h	2008-11-06 13:36:42=
=2E000000000 -0800
> > +++ linux-2.6.28-rc2/include/linux/quota.h	2008-11-06 14:03:52.0000=
00000 -0800
> > @@ -292,7 +292,9 @@ struct dquot_operations {
> >  	int (*release_dquot) (struct dquot *);		/* Quota is going to be d=
eleted from disk */
> >  	int (*mark_dirty) (struct dquot *);		/* Dquot is marked dirty */
> >  	int (*write_info) (struct super_block *, int);	/* Write of quota =
"superblock" */
> > -	int (*reserve_space) (struct inode *, qsize_t, int); /* reserve q=
uota for delayed block allocation */
> > +	int (*reserve_space) (struct inode *, qsize_t, int); /* reserve q=
uota for delayed alloc */
> > +	int (*claim_space) (struct inode *, qsize_t); /* claim reserved q=
uota for delayed alloc */
> > +	void (*release_rsv) (struct inode *, qsize_t); /* release rsved q=
uota for delayed alloc */
> >  };
> > =20
> >  /* Operations handling requests from userspace */
> > Index: linux-2.6.28-rc2/include/linux/quotaops.h
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux-2.6.28-rc2.orig/include/linux/quotaops.h	2008-11-06 13:37=
:04.000000000 -0800
> > +++ linux-2.6.28-rc2/include/linux/quotaops.h	2008-11-06 14:03:52.0=
00000000 -0800
> > @@ -28,6 +28,11 @@ int dquot_drop(struct inode *inode);
> >  int dquot_alloc_space(struct inode *inode, qsize_t number, int pre=
alloc);
> >  int dquot_alloc_inode(const struct inode *inode, qsize_t number);
> > =20
> > +int dquot_reserve_space(struct inode *inode, qsize_t number, int p=
realloc);
> > +int dquot_claim_space(struct inode *inode, qsize_t number);
> > +void dquot_release_reserved_space(struct inode *inode, qsize_t num=
ber);
> > +
> > +
> >  int dquot_free_space(struct inode *inode, qsize_t number);
> >  int dquot_free_inode(const struct inode *inode, qsize_t number);
> > =20
> > @@ -196,6 +201,31 @@ static inline int vfs_dq_alloc_inode(str
> >  	return 0;
> >  }
> > =20
> > +/*
> > + * Convert in-memory reserved quotas to real consumed quotas
> > + */
> > +static inline int vfs_dq_claim_space(struct inode *inode, qsize_t =
nr)
> > +{
> > +	if (sb_any_quota_active(inode->i_sb)) {
> > +		if (inode->i_sb->dq_op->claim_space(inode, nr) =3D=3D NO_QUOTA)
> > +			return 1;
> > +	} else
> > +		inode_add_bytes(inode, nr);
> > +
> > +	mark_inode_dirty(inode);
> > +	return 0;
> > +}
> > +
> > +/*
> > + * Release reserved (in-memory) quotas
> > + */
> > +static inline
> > +void vfs_dq_release_reservation_space(struct inode *inode, qsize_t=
 nr)
> > +{
> > +	if (sb_any_quota_active(inode->i_sb))
> > +		inode->i_sb->dq_op->release_rsv(inode, nr);
> > +}
> > +
> >  static inline void vfs_dq_free_space_nodirty(struct inode *inode, =
qsize_t nr)
> >  {
> >  	if (sb_any_quota_active(inode->i_sb))
> > @@ -342,6 +372,17 @@ static inline int vfs_dq_reserve_space(s
> >  	return 0;
> >  }
> > =20
> > +static inline int vfs_dq_claim_space(struct inode *inode, qsize_t =
nr)
> > +{
> > +	return vfs_dq_alloc_space(inode, nr);
> > +}
> > +
> > +static inline
> > +int vfs_dq_release_reservation_space(struct inode *inode, qsize_t =
nr)
> > +{
> > +	return 0;
> > +}
> > +
> >  static inline void vfs_dq_free_space_nodirty(struct inode *inode, =
qsize_t nr)
> >  {
> >  	inode_sub_bytes(inode, nr);
> > @@ -386,6 +427,18 @@ static inline int vfs_dq_reserve_block(s
> >  			nr << inode->i_blkbits);
> >  }
> > =20
> > +static inline int vfs_dq_claim_block(struct inode *inode, qsize_t =
nr)
> > +{
> > +	return vfs_dq_claim_space(inode,
> > +			nr << inode->i_blkbits);
> > +}
> > +
> > +static inline
> > +void vfs_dq_release_reservation(struct inode *inode, qsize_t nr)
> > +{
> > +	vfs_dq_release_reservation_space(inode, nr << inode->i_blkbits);
> > +}
> > +
>   I guess the function should be called like vfs_dq_release_reservati=
on_block().
> It's ugly long but we should not omit the "block" part. Maybe we coul=
d shorten
> reservation everywhere in function names to rsv?
>=20
okay.

> >  static inline void vfs_dq_free_block_nodirty(struct inode *inode, =
qsize_t nr)
> >  {
> >  	vfs_dq_free_space_nodirty(inode, nr << inode->i_sb->s_blocksize_b=
its);
> > @@ -415,6 +468,8 @@ static inline void vfs_dq_free_block(str
> >  				vfs_dq_alloc_block_nodirty(inode, nr)
> >  #define DQUOT_ALLOC_BLOCK(inode, nr) vfs_dq_alloc_block(inode, nr)
> >  #define DQUOT_RESERVE_BLOCK(inode, nr) vfs_dq_reserve_block(inode,=
 nr)
> > +#define DQUOT_CLAIM_BLOCK(inode, nr) vfs_dq_claim_block(inode, nr)
> > +#define DQUOT_RELEASE_RSV_BLOCK(inode, nr) vfs_dq_release_reservat=
ion(inode, nr)
>   Please call lowercase variants from ext4 and don't define these fun=
ctions.
>=20
> >  #define DQUOT_ALLOC_INODE(inode) vfs_dq_alloc_inode(inode)
> >  #define DQUOT_FREE_SPACE_NODIRTY(inode, nr) \
> >  				vfs_dq_free_space_nodirty(inode, nr)
> > Index: linux-2.6.28-rc2/fs/dquot.c
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux-2.6.28-rc2.orig/fs/dquot.c	2008-11-06 13:37:04.000000000 =
-0800
> > +++ linux-2.6.28-rc2/fs/dquot.c	2008-11-06 14:03:52.000000000 -0800
> > @@ -846,6 +846,24 @@ static inline void dquot_resv_space(stru
> >  	dquot->dq_dqb.dqb_rsvspace +=3D number;
> >  }
> > =20
> > +/*
> > + * Claim reserved quota space
> > + */
> > +static int dquot_claim_reserved_space(struct dquot *dquot,
> > +						qsize_t number)
> > +{
> > +	if (dquot->dq_dqb.dqb_rsvspace < number) {
> > +		printk(KERN_WARNING "Reserved quota %llu is not enough for"
> > +			"request %llu bytes\n",
> > +			(unsigned long long)dquot->dq_dqb.dqb_rsvspace, number);
> > +		return 1;
>   Wouldn't a WARN_ON here be more appropriate? It's a filesystem bug =
to cause
> this AFAICS.
>=20
> > +	}
> > +
> > +	dquot->dq_dqb.dqb_curspace +=3D number;
> > +	dquot->dq_dqb.dqb_rsvspace -=3D number;
> > +	return 0;
> > +}
>   You should use dq_data_lock to protect these operations...
>=20

Yes, will do.

> > +
> >  static inline void dquot_decr_inodes(struct dquot *dquot, qsize_t =
number)
> >  {
> >  	if (dquot->dq_dqb.dqb_curinodes > number)
> > @@ -1319,6 +1337,73 @@ out:
> >  	return ret;
> >  }
> > =20
> > +int dquot_claim_space(struct inode *inode, qsize_t number)
> > +{
> > +	int cnt;
> > +	int ret =3D QUOTA_OK;
> > +
> > +	if (IS_NOQUOTA(inode)) {
> > +		inode_add_bytes(inode, number);
> > +		return ret;
> > +	}
> > +
> > +	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> > +	if (IS_NOQUOTA(inode))	{
> > +		up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> > +		inode_add_bytes(inode, number);
> > +		return ret;
> > +	}
> > +
> > +	/* Claim reserved quotas to allocated quotas */
> > +	for (cnt =3D 0; cnt < MAXQUOTAS; cnt++) {
> > +		if (inode->i_dquot[cnt] !=3D NODQUOT)
> > +			ret =3D dquot_claim_reserved_space(inode->i_dquot[cnt],
> > +							number);
> > +	}
> > +	if (ret =3D=3D NO_QUOTA) {
> > +		up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> > +		return ret;
> > +	}
>   It seems a bit silly to try to recover here from filesystem bugs. I=
'd just
> make dquot_claim_reserved_space() void and ignore possible failure he=
re.
> We won't do anything harmful like loosing data. Just counters might b=
ecome
> out of sync but given there's a bug in fs anyway it does not matter m=
uch.
>=20

I was worried about the counters get messed up if we allow the the
corrupted counters continue, and want to notify the fs if the vfs
detects the quota counters went wrong. But ext4 wasn't clear to dealwit=
h
the "too late quota" errors so, so I guess adding warning message and
let the dirty pages flushed-out is more important.

> > +	/* Dirtify all the dquots - this can block when journalling */
> > +	for (cnt =3D 0; cnt < MAXQUOTAS; cnt++)
> > +		if (inode->i_dquot[cnt])
> > +			mark_dquot_dirty(inode->i_dquot[cnt]);
> > +	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> > +
> > +	/* Update inode bytes */
> > +	inode_add_bytes(inode, number);
>   And this should be called from under dq_data_lock from
> dquot_claim_reserved_space().
>   BTW: This reminds me that you should also modify dquot_transfer() f=
unction.
> Because that should not only transfer i_blocks sectors from one user
> to another but it has to also transfer the amount reserved for that i=
node...
> I think the easiest way around this would be to change i_blocks alrea=
dy when
> reservation is acquired (and than substract it when some of it is giv=
en back).
>=20

I did looked at dquot_transfer() (not very deep though) before, I wasn'=
t
sure who is calling/needs dquot_transfer()? I noticed ext23 has the
transfer operation defined, but I dont see it's being used. Any hint?

Thanks,
Mingming

> > +	return ret;
> > +}
> > +
> > +/*
> > + * Release reserved quota space
> > + */
> > +void dquot_release_reserved_space(struct inode *inode, qsize_t num=
ber)
> > +{
> > +	int cnt;
> > +	struct dquot *dquot;
> > +
> > +	if (IS_NOQUOTA(inode))
> > +		goto out;
> > +
> > +	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> > +	if (IS_NOQUOTA(inode))
> > +		goto out_unlock;
> > +
> > +	/* Release reserved dquots */
> > +	for (cnt =3D 0; cnt < MAXQUOTAS; cnt++) {
> > +		if (inode->i_dquot[cnt] !=3D NODQUOT) {
> > +			dquot =3D inode->i_dquot[cnt];
> > +			dquot->dq_dqb.dqb_rsvspace -=3D number;
> > +		}
> > +	}
>   Again dq_data_lock...
>=20
> > +
> > +out_unlock:
> > +	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> > +out:
> > +	return;
> > +}
> > +
> >  /*
> >   * This operation can block, but only after everything is updated
> >   */
> > @@ -2344,6 +2429,8 @@ EXPORT_SYMBOL(dquot_alloc_inode);
> >  EXPORT_SYMBOL(dquot_free_space);
> >  EXPORT_SYMBOL(dquot_free_inode);
> >  EXPORT_SYMBOL(dquot_reserve_space);
> > +EXPORT_SYMBOL(dquot_claim_space);
> > +EXPORT_SYMBOL(dquot_release_reserved_space);
> >  EXPORT_SYMBOL(dquot_transfer);
> >  EXPORT_SYMBOL(vfs_dq_transfer);
> >  EXPORT_SYMBOL(vfs_dq_quota_on_remount);
>=20
> 										Honza

--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
