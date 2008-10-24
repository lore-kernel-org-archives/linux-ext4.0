From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH 2/2] delay capable() check in ext4_has_free_blocks(
Date: Fri, 24 Oct 2008 13:48:01 -0700
Message-ID: <1224881281.6379.8.camel@mingming-laptop>
References: <49022FB7.9050608@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Eric Paris <eparis@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:35443 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbYJXUsD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 24 Oct 2008 16:48:03 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m9OKm2QX031991
	for <linux-ext4@vger.kernel.org>; Fri, 24 Oct 2008 16:48:02 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m9OKm2Lr148974
	for <linux-ext4@vger.kernel.org>; Fri, 24 Oct 2008 14:48:02 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m9OKlW5r005318
	for <linux-ext4@vger.kernel.org>; Fri, 24 Oct 2008 14:47:32 -0600
In-Reply-To: <49022FB7.9050608@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-10-24=E4=BA=94=E7=9A=84 15:27 -0500=EF=BC=8CEric Sandeen=
=E5=86=99=E9=81=93=EF=BC=9A
> As reported by Eric Paris, the capable() check in ext4_has_free_block=
s()
> sometimes causes SELinux denials.
>=20
> We can rearrange the logic so that we only try to use the root-reserv=
ed
> blocks when necessary, and even then we can move the capable() test
> to last, to avoid the check most of the time.
>=20
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Reviewed-by: Mingming Cao <cmm@us.ibm.com>
> --
>=20
> Index: linux-2.6/fs/ext4/balloc.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/fs/ext4/balloc.c	2008-10-24 14:43:11.103063953 -05=
00
> +++ linux-2.6/fs/ext4/balloc.c	2008-10-24 14:43:18.082063765 -0500
> @@ -596,23 +596,19 @@ void ext4_free_blocks(handle_t *handle,=20
>   *
>   * Check if filesystem has free blocks available for allocation.
>   * Return the number of blocks avaible for allocation for this reque=
st
> - * On success, return nblocks
> + * On success, return 1, on failure, return 0.
>   */
>  int ext4_has_free_blocks(struct ext4_sb_info *sbi,
>  						s64 nblocks)
>  {
> -	s64 free_blocks, dirty_blocks;
> -	s64 root_blocks =3D 0;
> +	s64 free_blocks, dirty_blocks, root_blocks;
>  	struct percpu_counter *fbc =3D &sbi->s_freeblocks_counter;
>  	struct percpu_counter *dbc =3D &sbi->s_dirtyblocks_counter;
>=20
>  	free_blocks  =3D percpu_counter_read_positive(fbc);
>  	dirty_blocks =3D percpu_counter_read_positive(dbc);
> +	root_blocks =3D ext4_r_blocks_count(sbi->s_es);
>=20
> -	if (!capable(CAP_SYS_RESOURCE) &&
> -		sbi->s_resuid !=3D current->fsuid &&
> -		(sbi->s_resgid =3D=3D 0 || !in_group_p(sbi->s_resgid)))
> -		root_blocks =3D ext4_r_blocks_count(sbi->s_es);
>=20
>  	if (free_blocks - (nblocks + root_blocks + dirty_blocks) <
>  						EXT4_FREEBLOCKS_WATERMARK) {
> @@ -625,13 +621,20 @@ int ext4_has_free_blocks(struct ext4_sb_
>  		}
>  	}
>  	/* Check whether we have space after
> -	 * accounting for current dirty blocks
> +	 * accounting for current dirty blocks & root reserved blocks.
>  	 */
> -	if (free_blocks < ((root_blocks + nblocks) + dirty_blocks))
> -		/* we don't have free space */
> -		return 0;
> +	if (free_blocks >=3D ((root_blocks + nblocks) + dirty_blocks))
> +		return 1;
>=20
> -	return 1;
> +	/* Hm, nope.  Are (enough) root reserved blocks available? */
> +	if (sbi->s_resuid =3D=3D current->fsuid ||
> +	    ((sbi->s_resgid !=3D 0) && in_group_p(sbi->s_resgid)) ||
> +	    capable(CAP_SYS_RESOURCE)) {
> +		if (free_blocks >=3D (nblocks + dirty_blocks))
> +			return 1;
> +	}
> +
> +	return 0;
>  }
>=20
>  int ext4_claim_free_blocks(struct ext4_sb_info *sbi,
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
