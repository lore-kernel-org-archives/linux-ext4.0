From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH -V3 02/11] ext4: Make sure all the block allocation
	paths reserve blocks
Date: Thu, 28 Aug 2008 13:41:33 -0700
Message-ID: <1219956093.6384.1.camel@mingming-laptop>
References: <1219850916-8986-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1219850916-8986-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:36665 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113AbYH1Ull (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Aug 2008 16:41:41 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7SKfeYV012370
	for <linux-ext4@vger.kernel.org>; Thu, 28 Aug 2008 16:41:40 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7SKfYQF068714
	for <linux-ext4@vger.kernel.org>; Thu, 28 Aug 2008 14:41:35 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7SKfYVx018664
	for <linux-ext4@vger.kernel.org>; Thu, 28 Aug 2008 14:41:34 -0600
In-Reply-To: <1219850916-8986-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-08-27=E4=B8=89=E7=9A=84 20:58 +0530=EF=BC=8CAneesh Kumar=
 K.V=E5=86=99=E9=81=93=EF=BC=9A
> With delayed allocation we need to make sure block are reserved
> before we attempt to allocate them. Otherwise we get block
> allocation failure (ENOSPC) during writepages which cannot
> be handled. This would mean silent data loss (We do a printk
> stating data will be lost). This patch update the DIO
> and fallocate code path to do block reservation before block
> allocation. This is needed to make sure parallel DIO and
> fallocate request doesn't take block out of delayed reserve
> space.
>=20
> When free blocks count go below a threshold we switch to
> a slow patch which looks at other CPU's accumulated percpu
> counter values.
>=20

Added this patch to patch queue.=20

> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext4/balloc.c  |   58 ++++++++++++++++++++++++++++++++++++++-----=
---------
>  fs/ext4/ext4.h    |   13 +++++++++++
>  fs/ext4/inode.c   |    5 +---
>  fs/ext4/mballoc.c |   23 +++++++++++---------
>  4 files changed, 69 insertions(+), 30 deletions(-)
>=20
> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index cfed283..dc10bfd 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -1602,6 +1602,32 @@ ext4_try_to_allocate_with_rsv(struct super_blo=
ck *sb, handle_t *handle,
>  	return ret;
>  }
>=20
> +int ext4_claim_free_blocks(struct ext4_sb_info *sbi,
> +						ext4_fsblk_t nblocks)
> +{
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
> +
> +	if (free_blocks - (nblocks + root_blocks) < EXT4_FREEBLOCKS_WATERMA=
RK)
> +		free_blocks =3D percpu_counter_sum(&sbi->s_freeblocks_counter);
> +
> +	if (free_blocks < (root_blocks + nblocks))
> +		/* we don't have free space */
> +		return -ENOSPC;
> +
> +	/* reduce fs free blocks counter */
> +	percpu_counter_sub(fbc, nblocks);
> +	return 0;
> +}
> +

Any reason that we don't do percpu_counter_sum_and_sub() together? I
thought this fixed the parallel reservation race before.

>  /**
>   * ext4_has_free_blocks()
>   * @sbi:	in-core super block structure.
> @@ -1623,18 +1649,17 @@ ext4_fsblk_t ext4_has_free_blocks(struct ext4=
_sb_info *sbi,
>  		sbi->s_resuid !=3D current->fsuid &&
>  		(sbi->s_resgid =3D=3D 0 || !in_group_p(sbi->s_resgid)))
>  		root_blocks =3D ext4_r_blocks_count(sbi->s_es);
> -#ifdef CONFIG_SMP
> -	if (free_blocks - root_blocks < FBC_BATCH)
> -		free_blocks =3D
> -			percpu_counter_sum(&sbi->s_freeblocks_counter);
> -#endif
> +
> +	if (free_blocks - (nblocks + root_blocks) < EXT4_FREEBLOCKS_WATERMA=
RK)
> +		free_blocks =3D percpu_counter_sum_positive(&sbi->s_freeblocks_cou=
nter);
> +
>  	if (free_blocks <=3D root_blocks)
>  		/* we don't have free space */
>  		return 0;
>  	if (free_blocks - root_blocks < nblocks)
>  		return free_blocks - root_blocks;
>  	return nblocks;
> - }
> +}
>=20
>=20
>  /**
> @@ -1713,14 +1738,11 @@ ext4_fsblk_t ext4_old_new_blocks(handle_t *ha=
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
> @@ -1915,9 +1937,13 @@ ext4_fsblk_t ext4_old_new_blocks(handle_t *han=
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
> index 7f11b25..71a4fde 100644
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
> @@ -1295,6 +1297,17 @@ do {								\
>  		__ext4_std_error((sb), __func__, (errno));	\
>  } while (0)
>=20
> +#ifdef CONFIG_SMP
> +/* Each CPU can accumulate FBC_BATCH blocks in their local
> + * counters. So we need to make sure we have free blocks more
> + * than FBC_BATCH  * nr_cpu_ids. Also add a window of 4 times.
> + */
> +#define EXT4_FREEBLOCKS_WATERMARK (4 * (FBC_BATCH * nr_cpu_ids))
> +#else
> +#define EXT4_FREEBLOCKS_WATERMARK 0
> +#endif
> +
> +
>  /*
>   * Inodes and files operations
>   */
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
> index 82dd0e4..4404b46 100644
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
> +				ac->ac_o_ex.fe_len - ac->ac_b_ex.fe_len);
> +	}
>=20
>  	if (sbi->s_log_groups_per_flex) {
>  		ext4_group_t flex_group =3D ext4_flex_group(sbi,
> @@ -4391,14 +4397,11 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *han=
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

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
