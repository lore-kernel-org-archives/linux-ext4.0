From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: ENOSPC returned during writepages
Date: Thu, 21 Aug 2008 09:56:37 -0700
Message-ID: <1219337797.6342.4.camel@mingming-laptop>
References: <20080820054339.GB6381@skywalker>
	 <20080820104644.GA11267@skywalker> <20080820115331.GA9965@mit.edu>
	 <20080821151257.GB6509@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:45699 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbYHUQ4j (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Aug 2008 12:56:39 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7LGuc5F021087
	for <linux-ext4@vger.kernel.org>; Thu, 21 Aug 2008 12:56:38 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7LGucNg208598
	for <linux-ext4@vger.kernel.org>; Thu, 21 Aug 2008 12:56:38 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7LGucsl015636
	for <linux-ext4@vger.kernel.org>; Thu, 21 Aug 2008 12:56:38 -0400
In-Reply-To: <20080821151257.GB6509@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-08-21=E5=9B=9B=E7=9A=84 20:42 +0530=EF=BC=8CAneesh Kumar=
 K.V=E5=86=99=E9=81=93=EF=BC=9A

> This is what i am testing now. It is much better. I am getting few
> errors now. But I guess that may be due to our meta-data block
> reservation going wrong. Still debugging.
>=20
> -aneesh
>=20
> commit be0a76f17f45b1009c40b2adb7d95f93dfdbb95a
> Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Date:   Thu Aug 21 15:56:19 2008 +0530
>=20
>    ENOSPC handling=20
>=20
> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index dfe2d4f..5d0a676 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -1602,6 +1602,64 @@ ext4_try_to_allocate_with_rsv(struct super_blo=
ck *sb, handle_t *handle,
>  	return ret;
>  }
>=20
> +int ext4_claim_free_blocks(struct ext4_sb_info *sbi,
> +						ext4_fsblk_t nblocks)
> +{
> +	int cpu;
> +	s64 free_blocks;
> +	ext4_fsblk_t root_blocks =3D 0;
> +	struct percpu_counter *fbc =3D &sbi->s_freeblocks_counter;
> +
> +	free_blocks =3D percpu_counter_read(fbc);
> +
> +	if (!capable(CAP_SYS_RESOURCE) &&
> +		sbi->s_resuid !=3D current->fsuid &&
> +		(sbi->s_resgid =3D=3D 0 || !in_group_p(sbi->s_resgid)))
> +		root_blocks =3D ext4_r_blocks_count(sbi->s_es);
> +#ifdef CONFIG_SMP
> +	/* Each CPU can accumulate FBC_BATCH blocks in their local
> +	 * counters. So we need to make sure we have free blocks more
> +	 * than FBC_BATCH  * nr_cpu_ids. Also add a window of 4 times.
> +	 */
> +	if (free_blocks - (nblocks + root_blocks) <
> +			(4 * (FBC_BATCH * nr_cpu_ids))) {
> +		/*
> +		 * We need to sum and claim under lock
> +		 * This is the slow patch which will be
> +		 * taken when we are very low on free blocks
> +		 */
> +		spin_lock(&fbc->lock);
> +		free_blocks =3D fbc->count;
> +		for_each_online_cpu(cpu) {
> +			s32 *pcount =3D per_cpu_ptr(fbc->counters, cpu);
> +			free_blocks +=3D *pcount;
> +			*pcount =3D 0;
> +		}
> +		fbc->count =3D free_blocks;
> +		if (free_blocks <=3D root_blocks) {
> +			/* we don't have free space */
> +			spin_unlock(&fbc->lock);
> +			return -ENOSPC;
> +		}
> +		if (free_blocks - root_blocks < nblocks) {
> +			spin_unlock(&fbc->lock);
> +			return -ENOSPC;
> +		}
> +		fbc->count -=3D nblocks;
> +		spin_unlock(&fbc->lock);
> +		return 0;
> +	}
> +#endif
> +	if (free_blocks <=3D root_blocks)
> +		/* we don't have free space */
> +		return -ENOSPC;
> +	if (free_blocks - root_blocks < nblocks)
> +		return -ENOSPC;
> +	/* reduce fs free blocks counter */
> +	percpu_counter_sub(fbc, nblocks);
> +	return 0;
> +}
> +

Like I proposed earlier, I would prefer create a new percpu counter API
to do the percpu_counter_sum_and_sub(), hide the CONFIG_SMP there,
rather than expose the percpu counter implementation details in ext4 fs
code here.

It also be nice and sane to define

#define  EXT4_FREEBLOCKS_LOW_WATERMARK		4* nr_cpu_ids * nr_cpu_ids


Other than this, patch looks good.


Mingming
>  /**
>   * ext4_has_free_blocks()
>   * @sbi:	in-core super block structure.
> @@ -1624,9 +1682,15 @@ ext4_fsblk_t ext4_has_free_blocks(struct ext4_=
sb_info *sbi,
>  		(sbi->s_resgid =3D=3D 0 || !in_group_p(sbi->s_resgid)))
>  		root_blocks =3D ext4_r_blocks_count(sbi->s_es);
>  #ifdef CONFIG_SMP
> -	if (free_blocks - root_blocks < FBC_BATCH)
> +	/* Each CPU can accumulate FBC_BATCH blocks in their local
> +	 * counters. So we need to make sure we have free blocks more
> +	 * than FBC_BATCH  * nr_cpu_ids. Also add a window of 4 times.
> +	 */
> +	if (free_blocks - (nblocks + root_blocks) <
> +					(4 * (FBC_BATCH * nr_cpu_ids))) {
>  		free_blocks =3D
>  			percpu_counter_sum_and_set(&sbi->s_freeblocks_counter);
> +	}
>  #endif
>  	if (free_blocks <=3D root_blocks)
>  		/* we don't have free space */
> @@ -1634,7 +1698,7 @@ ext4_fsblk_t ext4_has_free_blocks(struct ext4_s=
b_info *sbi,
>  	if (free_blocks - root_blocks < nblocks)
>  		return free_blocks - root_blocks;
>  	return nblocks;
> - }
> +}
>=20
>=20
>  /**
> @@ -1713,14 +1777,11 @@ ext4_fsblk_t ext4_old_new_blocks(handle_t *ha=
ndle, struct inode *inode,
>  		/*
>  		 * With delalloc we already reserved the blocks
>  		 */
> -		*count =3D ext4_has_free_blocks(sbi, *count);
> -	}
> -	if (*count =3D=3D 0) {
> -		*errp =3D -ENOSPC;
> -		return 0;	/*return with ENOSPC error */
> +		if (ext4_claim_free_blocks(sbi, *count)) {
> +			*errp =3D -ENOSPC;
> +			return 0;	/*return with ENOSPC error */
> +		}
>  	}
> -	num =3D *count;
> -
>  	/*
>  	 * Check quota for allocation of this block.
>  	 */
> @@ -1915,9 +1976,13 @@ ext4_fsblk_t ext4_old_new_blocks(handle_t *han=
dle, struct inode *inode,
>  	le16_add_cpu(&gdp->bg_free_blocks_count, -num);
>  	gdp->bg_checksum =3D ext4_group_desc_csum(sbi, group_no, gdp);
>  	spin_unlock(sb_bgl_lock(sbi, group_no));
> -	if (!EXT4_I(inode)->i_delalloc_reserved_flag)
> -		percpu_counter_sub(&sbi->s_freeblocks_counter, num);
> -
> +	if (!EXT4_I(inode)->i_delalloc_reserved_flag && (*count !=3D num)) =
{
> +		/*
> +		 * we allocated less blocks than we
> +		 * claimed. Add the difference back.
> +		 */
> +		percpu_counter_add(&sbi->s_freeblocks_counter, *count - num);
> +	}
>  	if (sbi->s_log_groups_per_flex) {
>  		ext4_group_t flex_group =3D ext4_flex_group(sbi, group_no);
>  		spin_lock(sb_bgl_lock(sbi, flex_group));
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 7f11b25..3738039 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1047,6 +1047,8 @@ extern ext4_fsblk_t ext4_new_blocks(handle_t *h=
andle, struct inode *inode,
>  					unsigned long *count, int *errp);
>  extern ext4_fsblk_t ext4_old_new_blocks(handle_t *handle, struct ino=
de *inode,
>  			ext4_fsblk_t goal, unsigned long *count, int *errp);
> +extern int ext4_claim_free_blocks(struct ext4_sb_info *sbi,
> +						ext4_fsblk_t nblocks);
>  extern ext4_fsblk_t ext4_has_free_blocks(struct ext4_sb_info *sbi,
>  						ext4_fsblk_t nblocks);
>  extern void ext4_free_blocks (handle_t *handle, struct inode *inode,
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 1c289c1..d965a05 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1537,13 +1537,10 @@ static int ext4_da_reserve_space(struct inode=
 *inode, int nrblocks)
>  	md_needed =3D mdblocks - EXT4_I(inode)->i_reserved_meta_blocks;
>  	total =3D md_needed + nrblocks;
>=20
> -	if (ext4_has_free_blocks(sbi, total) < total) {
> +	if (ext4_claim_free_blocks(sbi, total)) {
>  		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
>  		return -ENOSPC;
>  	}
> -	/* reduce fs free blocks counter */
> -	percpu_counter_sub(&sbi->s_freeblocks_counter, total);
> -
>  	EXT4_I(inode)->i_reserved_data_blocks +=3D nrblocks;
>  	EXT4_I(inode)->i_reserved_meta_blocks =3D mdblocks;
>=20
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 5267efc..7d94119 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -2977,9 +2977,15 @@ ext4_mb_mark_diskspace_used(struct ext4_alloca=
tion_context *ac,
>  	 * at write_begin() time for delayed allocation
>  	 * do not double accounting
>  	 */
> -	if (!(ac->ac_flags & EXT4_MB_DELALLOC_RESERVED))
> -		percpu_counter_sub(&sbi->s_freeblocks_counter,
> -					ac->ac_b_ex.fe_len);
> +	if (!(ac->ac_flags & EXT4_MB_DELALLOC_RESERVED) &&
> +			ac->ac_o_ex.fe_len !=3D ac->ac_b_ex.fe_len) {
> +		/*
> +		 * we allocated less blocks than we calimed
> +		 * Add the difference back
> +		 */
> +		percpu_counter_add(&sbi->s_freeblocks_counter,
> +				ac->ac_o_ex.fe_len -ac->ac_b_ex.fe_len);
> +	}
>=20
>  	if (sbi->s_log_groups_per_flex) {
>  		ext4_group_t flex_group =3D ext4_flex_group(sbi,
> @@ -4392,14 +4398,11 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *han=
dle,
>  		/*
>  		 * With delalloc we already reserved the blocks
>  		 */
> -		ar->len =3D ext4_has_free_blocks(sbi, ar->len);
> -	}
> -
> -	if (ar->len =3D=3D 0) {
> -		*errp =3D -ENOSPC;
> -		return 0;
> +		if (ext4_claim_free_blocks(sbi, ar->len)) {
> +			*errp =3D -ENOSPC;
> +			return 0;
> +		}
>  	}
> -
>  	while (ar->len && DQUOT_ALLOC_BLOCK(ar->inode, ar->len)) {
>  		ar->flags |=3D EXT4_MB_HINT_NOPREALLOC;
>  		ar->len--;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
