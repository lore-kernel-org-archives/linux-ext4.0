From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH 1/2] merge ext4_claim_free_blocks & ext4_has_free_blocks
Date: Fri, 24 Oct 2008 13:45:38 -0700
Message-ID: <1224881138.6379.5.camel@mingming-laptop>
References: <49022FB3.7080002@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Eric Paris <eparis@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:49372 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752822AbYJXUpl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Oct 2008 16:45:41 -0400
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m9OKjeiF032093
	for <linux-ext4@vger.kernel.org>; Fri, 24 Oct 2008 16:45:40 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m9OKjcPF983070
	for <linux-ext4@vger.kernel.org>; Fri, 24 Oct 2008 16:45:39 -0400
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m9OKj9I2027412
	for <linux-ext4@vger.kernel.org>; Fri, 24 Oct 2008 14:45:09 -0600
In-Reply-To: <49022FB3.7080002@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-10-24=E4=BA=94=E7=9A=84 15:27 -0500=EF=BC=8CEric Sandeen=
=E5=86=99=E9=81=93=EF=BC=9A
> Mingming pointed out that ext4_claim_free_blocks & ext4_has_free_bloc=
ks
> are largely cut & pasted; they can be collapsed/merged as follows.
>=20
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>=20

Reviewed-by: Mingming Cao <cmm@us.ibm.com>

> Index: linux-2.6/fs/ext4/balloc.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/fs/ext4/balloc.c	2008-10-24 15:04:51.672001367 -05=
00
> +++ linux-2.6/fs/ext4/balloc.c	2008-10-24 15:07:28.369001684 -0500
> @@ -589,8 +589,15 @@ void ext4_free_blocks(handle_t *handle,=20
>  	return;
>  }
>=20
> -int ext4_claim_free_blocks(struct ext4_sb_info *sbi,
> -						s64 nblocks)
> +/**
> + * ext4_has_free_blocks()
> + * @sbi:	in-core super block structure.
> + * @nblocks:	number of needed blocks
> + *
> + * Check if filesystem has nblocks free & available for allocation.
> + * On success return 1, return 0 on failure.
> + */
> +int ext4_has_free_blocks(struct ext4_sb_info *sbi, s64 nblocks)
>  {
>  	s64 free_blocks, dirty_blocks;
>  	s64 root_blocks =3D 0;
> @@ -620,53 +627,21 @@ int ext4_claim_free_blocks(struct ext4_s
>  	 */
>  	if (free_blocks < ((root_blocks + nblocks) + dirty_blocks))
>  		/* we don't have free space */
> -		return -ENOSPC;
> +		return 0;
>=20
> -	/* Add the blocks to nblocks */
> -	percpu_counter_add(dbc, nblocks);
> -	return 0;
> +	return 1;
>  }
>=20
> -/**
> - * ext4_has_free_blocks()
> - * @sbi:	in-core super block structure.
> - * @nblocks:	number of neeed blocks
> - *
> - * Check if filesystem has free blocks available for allocation.
> - * Return the number of blocks avaible for allocation for this reque=
st
> - * On success, return nblocks
> - */
> -ext4_fsblk_t ext4_has_free_blocks(struct ext4_sb_info *sbi,
> +int ext4_claim_free_blocks(struct ext4_sb_info *sbi,
>  						s64 nblocks)
>  {
> -	s64 free_blocks, dirty_blocks;
> -	s64 root_blocks =3D 0;
> -	struct percpu_counter *fbc =3D &sbi->s_freeblocks_counter;
> -	struct percpu_counter *dbc =3D &sbi->s_dirtyblocks_counter;
> -
> -	free_blocks  =3D percpu_counter_read_positive(fbc);
> -	dirty_blocks =3D percpu_counter_read_positive(dbc);
> -
> -	if (!capable(CAP_SYS_RESOURCE) &&
> -		sbi->s_resuid !=3D current->fsuid &&
> -		(sbi->s_resgid =3D=3D 0 || !in_group_p(sbi->s_resgid)))
> -		root_blocks =3D ext4_r_blocks_count(sbi->s_es);
> -
> -	if (free_blocks - (nblocks + root_blocks + dirty_blocks) <
> -						EXT4_FREEBLOCKS_WATERMARK) {
> -		free_blocks  =3D percpu_counter_sum(fbc);
> -		dirty_blocks =3D percpu_counter_sum(dbc);
> -	}
> -	if (free_blocks <=3D (root_blocks + dirty_blocks))
> -		/* we don't have free space */
> +	if (ext4_has_free_blocks(sbi, nblocks)) {
> +		percpu_counter_add(&sbi->s_dirtyblocks_counter, nblocks);
>  		return 0;
> -
> -	if (free_blocks - (root_blocks + dirty_blocks) < nblocks)
> -		return free_blocks - (root_blocks + dirty_blocks);
> -	return nblocks;
> +	} else
> +		return -ENOSPC;
>  }
>=20
> -
>  /**
>   * ext4_should_retry_alloc()
>   * @sb:			super block
> Index: linux-2.6/fs/ext4/ext4.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/fs/ext4/ext4.h	2008-10-24 14:45:07.000000000 -0500
> +++ linux-2.6/fs/ext4/ext4.h	2008-10-24 15:05:22.227064688 -0500
> @@ -1003,8 +1003,7 @@ extern ext4_fsblk_t ext4_new_blocks(hand
>  					ext4_lblk_t iblock, ext4_fsblk_t goal,
>  					unsigned long *count, int *errp);
>  extern int ext4_claim_free_blocks(struct ext4_sb_info *sbi, s64 nblo=
cks);
> -extern ext4_fsblk_t ext4_has_free_blocks(struct ext4_sb_info *sbi,
> -					 s64 nblocks);
> +extern int ext4_has_free_blocks(struct ext4_sb_info *sbi, s64 nblock=
s);
>  extern void ext4_free_blocks(handle_t *handle, struct inode *inode,
>  			ext4_fsblk_t block, unsigned long count, int metadata);
>  extern void ext4_free_blocks_sb(handle_t *handle, struct super_block=
 *sb,
>=20
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
