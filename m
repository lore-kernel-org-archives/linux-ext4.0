From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH -V3 06/11] ext4: Update meta-data reservation with
	delalloc.
Date: Thu, 28 Aug 2008 14:03:16 -0700
Message-ID: <1219957396.6384.25.camel@mingming-laptop>
References: <1219850916-8986-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1219850916-8986-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1219850916-8986-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1219850916-8986-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1219850916-8986-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1219850916-8986-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:52071 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540AbYH1VDS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Aug 2008 17:03:18 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7SL3HoB023900
	for <linux-ext4@vger.kernel.org>; Thu, 28 Aug 2008 17:03:17 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7SL3HbX184666
	for <linux-ext4@vger.kernel.org>; Thu, 28 Aug 2008 15:03:17 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7SL3G7Y010515
	for <linux-ext4@vger.kernel.org>; Thu, 28 Aug 2008 15:03:17 -0600
In-Reply-To: <1219850916-8986-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-08-27=E4=B8=89=E7=9A=84 20:58 +0530=EF=BC=8CAneesh Kumar=
 K.V=E5=86=99=E9=81=93=EF=BC=9A
> This makes the meta-data reservation simpler. The logic
> followed is simpler. After each block allocation request
> if we have allocated some meta-data blocks subtract the
> same from the reserved meta-data blocks. If the total
> reserved data blocks after allocation is zero, free the
> remaining meta-data blocks reserved.=20

With this change ext4 keeps unnecessary blocks reserved for metadata
blocks for a longer time (untilall dirty data have been flushed), I am
concerned this will leads to early ENOSPC.

The current metadata reservation logic is a little complex, but it's no=
t
that bad. It's there to make sure we don't over-reserve the metadata.
I'd say it worth the effort.=20

> During reservation
> if the total reserved blocks need more meta-data blocks
> add the extra meta-data blocks needed to the reserve_meta_blocks
>=20
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext4/inode.c |   75 +++++++++++++++++++++++++++------------------=
----------
>  1 files changed, 37 insertions(+), 38 deletions(-)
>=20
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index a45121f..3ef0822 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1019,31 +1019,34 @@ static int ext4_calc_metadata_amount(struct i=
node *inode, int blocks)
>  static void ext4_da_update_reserve_space(struct inode *inode, int us=
ed)
>  {
>  	struct ext4_sb_info *sbi =3D EXT4_SB(inode->i_sb);
> -	int total, mdb, mdb_free;
>=20
>  	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
> -	/* recalculate the number of metablocks still need to be reserved *=
/
> -	total =3D EXT4_I(inode)->i_reserved_data_blocks - used;
> -	mdb =3D ext4_calc_metadata_amount(inode, total);
> -
> -	/* figure out how many metablocks to release */
> -	BUG_ON(mdb > EXT4_I(inode)->i_reserved_meta_blocks);
> -	mdb_free =3D EXT4_I(inode)->i_reserved_meta_blocks - mdb;
> -
> -	if (mdb_free) {
> -		/* Account for allocated meta_blocks */
> -		mdb_free -=3D EXT4_I(inode)->i_allocated_meta_blocks;
> -
> -		/* update fs dirty blocks counter */
> -		percpu_counter_sub(&sbi->s_dirtyblocks_counter, mdb_free);
> +	if (EXT4_I(inode)->i_allocated_meta_blocks) {
> +		/* update the reseved meta- blocks */
> +		BUG_ON(EXT4_I(inode)->i_allocated_meta_blocks >
> +			EXT4_I(inode)->i_reserved_meta_blocks);
> +		EXT4_I(inode)->i_reserved_meta_blocks -=3D
> +			EXT4_I(inode)->i_allocated_meta_blocks;
>  		EXT4_I(inode)->i_allocated_meta_blocks =3D 0;
> -		EXT4_I(inode)->i_reserved_meta_blocks =3D mdb;
> +		/*
> +		 * We already updated the percpu dirty
> +		 * block counter in the block allocation path.
> +		 */
>  	}
> -
>  	/* update per-inode reservations */
>  	BUG_ON(used  > EXT4_I(inode)->i_reserved_data_blocks);
>  	EXT4_I(inode)->i_reserved_data_blocks -=3D used;
> +	if (!EXT4_I(inode)->i_reserved_data_blocks) {
> +		/*
> +		 * If we don't have any reserved data blocks
> +		 * release all the resered meta data blocks
> +		 * update percpu dirty block counter also.
> +		 */
> +		percpu_counter_sub(&sbi->s_dirtyblocks_counter,
> +				EXT4_I(inode)->i_reserved_meta_blocks);
> +		EXT4_I(inode)->i_reserved_meta_blocks =3D 0;
>=20
> +	}
>  	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
>  }
>=20
> @@ -1524,7 +1527,7 @@ static int ext4_da_reserve_space(struct inode *=
inode, int nrblocks)
>  {
>  	int retries =3D 0;
>         struct ext4_sb_info *sbi =3D EXT4_SB(inode->i_sb);
> -       unsigned long md_needed, mdblocks, total =3D 0;
> +       unsigned long md_needed =3D 0, mdblocks, total =3D 0;
>=20
>  	/*
>  	 * recalculate the amount of metadata blocks to reserve
> @@ -1535,9 +1538,9 @@ static int ext4_da_reserve_space(struct inode *=
inode, int nrblocks)
>  	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
>  	total =3D EXT4_I(inode)->i_reserved_data_blocks + nrblocks;
>  	mdblocks =3D ext4_calc_metadata_amount(inode, total);
> -	BUG_ON(mdblocks < EXT4_I(inode)->i_reserved_meta_blocks);
> +	if (mdblocks > EXT4_I(inode)->i_reserved_meta_blocks)
> +		md_needed =3D mdblocks - EXT4_I(inode)->i_reserved_meta_blocks;
>=20
> -	md_needed =3D mdblocks - EXT4_I(inode)->i_reserved_meta_blocks;
>  	total =3D md_needed + nrblocks;
>=20
>  	if (ext4_claim_free_blocks(sbi, total)) {
> @@ -1549,7 +1552,7 @@ static int ext4_da_reserve_space(struct inode *=
inode, int nrblocks)
>  		return -ENOSPC;
>  	}
>  	EXT4_I(inode)->i_reserved_data_blocks +=3D nrblocks;
> -	EXT4_I(inode)->i_reserved_meta_blocks =3D mdblocks;
> +	EXT4_I(inode)->i_reserved_meta_blocks +=3D md_needed;
>=20
>  	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
>  	return 0;       /* success */
> @@ -1558,13 +1561,12 @@ static int ext4_da_reserve_space(struct inode=
 *inode, int nrblocks)
>  static void ext4_da_release_space(struct inode *inode, int to_free)
>  {
>  	struct ext4_sb_info *sbi =3D EXT4_SB(inode->i_sb);
> -	int total, mdb, mdb_free, release;
> +	int release, mdb_free =3D 0;
>=20
>  	if (!to_free)
>  		return;		/* Nothing to release, exit */
>=20
>  	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
> -
>  	if (!EXT4_I(inode)->i_reserved_data_blocks) {
>  		/*
>  		 * if there is no reserved blocks, but we try to free some
> @@ -1578,26 +1580,23 @@ static void ext4_da_release_space(struct inod=
e *inode, int to_free)
>  		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
>  		return;
>  	}
> +	/* update per-inode reservations */
> +	BUG_ON(to_free > EXT4_I(inode)->i_reserved_data_blocks);
> +	EXT4_I(inode)->i_reserved_data_blocks -=3D to_free;
> +	if (!EXT4_I(inode)->i_reserved_data_blocks) {
> +		/*
> +		 * If we don't have any reserved data blocks
> +		 * release all the resered meta data blocks
> +		 * update percpu dirty block counter also.
> +		 */
> +		mdb_free =3D EXT4_I(inode)->i_reserved_meta_blocks;
> +		EXT4_I(inode)->i_reserved_meta_blocks =3D 0;
>=20
> -	/* recalculate the number of metablocks still need to be reserved *=
/
> -	total =3D EXT4_I(inode)->i_reserved_data_blocks - to_free;
> -	mdb =3D ext4_calc_metadata_amount(inode, total);
> -
> -	/* figure out how many metablocks to release */
> -	BUG_ON(mdb > EXT4_I(inode)->i_reserved_meta_blocks);
> -	mdb_free =3D EXT4_I(inode)->i_reserved_meta_blocks - mdb;
> -
> +	}
>  	release =3D to_free + mdb_free;
>=20
>  	/* update fs dirty blocks counter for truncate case */
>  	percpu_counter_sub(&sbi->s_dirtyblocks_counter, release);
> -
> -	/* update per-inode reservations */
> -	BUG_ON(to_free > EXT4_I(inode)->i_reserved_data_blocks);
> -	EXT4_I(inode)->i_reserved_data_blocks -=3D to_free;
> -
> -	BUG_ON(mdb > EXT4_I(inode)->i_reserved_meta_blocks);
> -	EXT4_I(inode)->i_reserved_meta_blocks =3D mdb;
>  	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
>  }
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
