From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH V3 3/3]ext4: quota handling for delayed allocation
Date: Mon, 08 Dec 2008 17:50:22 -0800
Message-ID: <1228787422.6372.43.camel@mingming-laptop>
References: <1226014745.6430.64.camel@mingming-laptop>
	 <20081203201105.GE12803@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andrew Morton <akpm@linux-foundation.org>, tytso <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20081203201105.GE12803@duck.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


=E5=9C=A8 2008-12-03=E4=B8=89=E7=9A=84 21:11 +0100=EF=BC=8CJan Kara=E5=86=
=99=E9=81=93=EF=BC=9A
> Hi,
>=20
> On Thu 06-11-08 15:39:05, Mingming Cao wrote:
> > ext4: quota reservation for delayed allocation
> >=20
> > Uses quota reservation/claim/release to handle quota properly for d=
elayed
> > allocation in the three steps: 1) quotas are reserved when data bei=
ng copied
> > to cache when block allocation is defered 2) when new blocks are al=
located.
> > reserved quotas are converted to the real allocated quota, 2) over-=
booked
> > quotas for metadata blocks are released back.
> >=20
> >=20
> > Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> > ---
> >  fs/ext4/inode.c   |   29 ++++++++++++++++++++++++++---
> >  fs/ext4/mballoc.c |   42 +++++++++++++++++++++++++----------------=
-
> >  fs/ext4/super.c   |    3 +++
> >  3 files changed, 54 insertions(+), 20 deletions(-)
> >=20
> > Index: linux-2.6.28-rc2/fs/ext4/inode.c
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux-2.6.28-rc2.orig/fs/ext4/inode.c	2008-11-06 13:36:16.00000=
0000 -0800
> > +++ linux-2.6.28-rc2/fs/ext4/inode.c	2008-11-06 14:03:35.000000000 =
-0800
> > @@ -994,7 +994,9 @@ static void ext4_da_update_reserve_space
> >  {
> >  	struct ext4_sb_info *sbi =3D EXT4_SB(inode->i_sb);
> >  	int total, mdb, mdb_free;
> > +	int claim_quota, free_quota =3D 0;
> > =20
> > +	claim_quota =3D used;
> >  	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
> >  	/* recalculate the number of metablocks still need to be reserved=
 */
> >  	total =3D EXT4_I(inode)->i_reserved_data_blocks - used;
> > @@ -1007,6 +1009,8 @@ static void ext4_da_update_reserve_space
> >  	if (mdb_free) {
> >  		/* Account for allocated meta_blocks */
> >  		mdb_free -=3D EXT4_I(inode)->i_allocated_meta_blocks;
> > +		free_quota =3D mdb_free;
> > +		claim_quota +=3D EXT4_I(inode)->i_allocated_meta_blocks;
> > =20
> >  		/* update fs dirty blocks counter */
> >  		percpu_counter_sub(&sbi->s_dirtyblocks_counter, mdb_free);
> > @@ -1017,8 +1021,14 @@ static void ext4_da_update_reserve_space
> >  	/* update per-inode reservations */
> >  	BUG_ON(used  > EXT4_I(inode)->i_reserved_data_blocks);
> >  	EXT4_I(inode)->i_reserved_data_blocks -=3D used;
> > -
> >  	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> > +
> > +	/*
> > +	 * free those over-booking quota for metadata blocks
> > +	 */
> > +
> > +	if (free_quota)
> > +		DQUOT_RELEASE_RSV_BLOCK(inode, free_quota);
>   claim_quota seems to be unused here and I'm not sure we need it for
> anything...
>=20

Thanks for catching this, I will remove that variable.

> >  }
> > =20
> >  /*
> > @@ -1514,8 +1524,8 @@ static int ext4_journalled_write_end(str
> >  static int ext4_da_reserve_space(struct inode *inode, int nrblocks=
)
> >  {
> >  	int retries =3D 0;
> > -       struct ext4_sb_info *sbi =3D EXT4_SB(inode->i_sb);
> > -       unsigned long md_needed, mdblocks, total =3D 0;
> > +	struct ext4_sb_info *sbi =3D EXT4_SB(inode->i_sb);
> > +	unsigned long md_needed, mdblocks, total =3D 0;
> > =20
> >  	/*
> >  	 * recalculate the amount of metadata blocks to reserve
> > @@ -1531,12 +1541,23 @@ repeat:
> >  	md_needed =3D mdblocks - EXT4_I(inode)->i_reserved_meta_blocks;
> >  	total =3D md_needed + nrblocks;
> > =20
> > +	/*
> > +	 * Make quota reservation here to prevent quota overflow
> > +	 * later. Real quota accounting is done at pages writeout
> > +	 * time.
> > +	 */
> > +	if (DQUOT_RESERVE_BLOCK(inode, total)) {
> > +		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> > +		return -EDQUOT;
> > +	}
> > +
> >  	if (ext4_claim_free_blocks(sbi, total)) {
> >  		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> >  		if (ext4_should_retry_alloc(inode->i_sb, &retries)) {
> >  			yield();
> >  			goto repeat;
> >  		}
> > +		DQUOT_RELEASE_RSV_BLOCK(inode, total);
> >  		return -ENOSPC;
> >  	}
> >  	EXT4_I(inode)->i_reserved_data_blocks +=3D nrblocks;
> > @@ -1590,6 +1611,8 @@ static void ext4_da_release_space(struct
> >  	BUG_ON(mdb > EXT4_I(inode)->i_reserved_meta_blocks);
> >  	EXT4_I(inode)->i_reserved_meta_blocks =3D mdb;
> >  	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> > +
> > +	DQUOT_RELEASE_RSV_BLOCK(inode, release);
> >  }
> > =20
> >  static void ext4_da_page_release_reservation(struct page *page,
> > Index: linux-2.6.28-rc2/fs/ext4/super.c
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux-2.6.28-rc2.orig/fs/ext4/super.c	2008-11-06 13:36:16.00000=
0000 -0800
> > +++ linux-2.6.28-rc2/fs/ext4/super.c	2008-11-06 14:02:57.000000000 =
-0800
> > @@ -795,6 +795,9 @@ static struct dquot_operations ext4_quot
> >  	.initialize	=3D ext4_dquot_initialize,
> >  	.drop		=3D ext4_dquot_drop,
> >  	.alloc_space	=3D dquot_alloc_space,
> > +	.reserve_space	=3D dquot_reserve_space,
> > +	.claim_space	=3D dquot_claim_space,
> > +	.release_rsv	=3D dquot_release_reserved_space,
> >  	.alloc_inode	=3D dquot_alloc_inode,
> >  	.free_space	=3D dquot_free_space,
> >  	.free_inode	=3D dquot_free_inode,
> > Index: linux-2.6.28-rc2/fs/ext4/mballoc.c
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux-2.6.28-rc2.orig/fs/ext4/mballoc.c	2008-11-06 13:36:16.000=
000000 -0800
> > +++ linux-2.6.28-rc2/fs/ext4/mballoc.c	2008-11-06 14:03:35.00000000=
0 -0800
> > @@ -2887,9 +2887,11 @@ ext4_mb_mark_diskspace_used(struct ext4_
> >  	if (!(ac->ac_flags & EXT4_MB_DELALLOC_RESERVED))
> >  		/* release all the reserved blocks if non delalloc */
> >  		percpu_counter_sub(&sbi->s_dirtyblocks_counter, reserv_blks);
> > -	else
> > +	else {
> >  		percpu_counter_sub(&sbi->s_dirtyblocks_counter,
> >  						ac->ac_b_ex.fe_len);
> > +		DQUOT_CLAIM_BLOCK(ac->ac_inode, ac->ac_b_ex.fe_len);
> > +	}
> > =20
> >  	if (sbi->s_log_groups_per_flex) {
> >  		ext4_group_t flex_group =3D ext4_flex_group(sbi,
> > @@ -4286,15 +4288,24 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t
> >  	struct ext4_sb_info *sbi;
> >  	struct super_block *sb;
> >  	ext4_fsblk_t block =3D 0;
> > -	unsigned long inquota;
> > +	unsigned long inquota =3D 0;
> >  	unsigned long reserv_blks =3D 0;
> > =20
> >  	sb =3D ar->inode->i_sb;
> >  	sbi =3D EXT4_SB(sb);
> > =20
> > -	if (!EXT4_I(ar->inode)->i_delalloc_reserved_flag) {
> > +	/*
> > +	 * For delayed allocation, we could skip the ENOSPC and
> > +	 * EDQUOT check, as blocks and quotas have been already
> > +	 * reserved when data being copied into pagecache.
> > +	 */
> > +	if (EXT4_I(ar->inode)->i_delalloc_reserved_flag)
> > +		ar->flags |=3D EXT4_MB_DELALLOC_RESERVED;
> > +	else {
> >  		/*
> > -		 * With delalloc we already reserved the blocks
> > +		 * Without delayed allocation we need to verify
> > +		 * there is enough free blocks to do block allocation
> > +		 * and verify allocation doesn't exceed the quota limits.
> >  		 */
> >  		while (ar->len && ext4_claim_free_blocks(sbi, ar->len)) {
> >  			/* let others to free the space */
> > @@ -4306,19 +4317,16 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t
> >  			return 0;
> >  		}
> >  		reserv_blks =3D ar->len;
> > +		while (ar->len && DQUOT_ALLOC_BLOCK(ar->inode, ar->len)) {
> > +			ar->flags |=3D EXT4_MB_HINT_NOPREALLOC;
> > +			ar->len--;
> > +		}
> > +		if (ar->len =3D=3D 0) {
> > +			*errp =3D -EDQUOT;
> > +			return 0;
> > +		}
> > +		inquota =3D ar->len;
> >  	}
> > -	while (ar->len && DQUOT_ALLOC_BLOCK(ar->inode, ar->len)) {
> > -		ar->flags |=3D EXT4_MB_HINT_NOPREALLOC;
> > -		ar->len--;
> > -	}
> > -	if (ar->len =3D=3D 0) {
> > -		*errp =3D -EDQUOT;
> > -		return 0;
> > -	}
> > -	inquota =3D ar->len;
> > -
> > -	if (EXT4_I(ar->inode)->i_delalloc_reserved_flag)
> > -		ar->flags |=3D EXT4_MB_DELALLOC_RESERVED;
> > =20
> >  	ac =3D kmem_cache_alloc(ext4_ac_cachep, GFP_NOFS);
> >  	if (!ac) {
> > @@ -4380,7 +4388,7 @@ repeat:
> >  out2:
> >  	kmem_cache_free(ext4_ac_cachep, ac);
> >  out1:
> > -	if (ar->len < inquota)
> > +	if (inquota && ar->len < inquota)
> >  		DQUOT_FREE_BLOCK(ar->inode, inquota - ar->len);
> > =20
> >  	return block;
> >=20
> >=20
>=20
> 									Honza

--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
