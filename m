From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] Fix EXT4FS_DEBUG build: use ext4_free_blks_count and
	%u instead of %lu
Date: Mon, 26 Jan 2009 17:06:22 -0800
Message-ID: <1233018382.7240.8.camel@mingming-laptop>
References: <1232679163-4176-1-git-send-email-cascardo@holoscopio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:58270 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbZA0BGZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Jan 2009 20:06:25 -0500
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e38.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n0R14kmn001977
	for <linux-ext4@vger.kernel.org>; Mon, 26 Jan 2009 18:04:46 -0700
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id n0R16NpP201358
	for <linux-ext4@vger.kernel.org>; Mon, 26 Jan 2009 18:06:23 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n0R16MuY026810
	for <linux-ext4@vger.kernel.org>; Mon, 26 Jan 2009 18:06:22 -0700
In-Reply-To: <1232679163-4176-1-git-send-email-cascardo@holoscopio.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2009-01-23=E4=BA=94=E7=9A=84 00:52 -0200=EF=BC=8CThadeu Lima =
de Souza Cascardo=E5=86=99=E9=81=93=EF=BC=9A
> When bg_free_blocks_count was renamed to bg_free_blocks_count_lo in
> 560671a0, its uses under EXT4FS_DEBUG were not changed to the helper
> ext4_free_blks_count.
>=20
> Another commit, 498e5f24, also did not change everything needed under
> EXT4FS_DEBUG, thus making it spill some warnings related to printing
> format.
>=20
> This commit fix both issues and make ext4 build again when EXT4FS_DEB=
UG
> is set.
>=20

Reviewed-by: Mingming Cao <cmm@us.ibm.com>

> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com=
>
> ---
>  fs/ext4/balloc.c  |    6 +++---
>  fs/ext4/extents.c |    2 +-
>  fs/ext4/mballoc.c |    2 +-
>  3 files changed, 5 insertions(+), 5 deletions(-)
>=20
> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index 6bba06b..9a50b80 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -684,15 +684,15 @@ ext4_fsblk_t ext4_count_free_blocks(struct supe=
r_block *sb)
>  		gdp =3D ext4_get_group_desc(sb, i, NULL);
>  		if (!gdp)
>  			continue;
> -		desc_count +=3D le16_to_cpu(gdp->bg_free_blocks_count);
> +		desc_count +=3D ext4_free_blks_count(sb, gdp);
>  		brelse(bitmap_bh);
>  		bitmap_bh =3D ext4_read_block_bitmap(sb, i);
>  		if (bitmap_bh =3D=3D NULL)
>  			continue;
>=20
>  		x =3D ext4_count_free(bitmap_bh, sb->s_blocksize);
> -		printk(KERN_DEBUG "group %lu: stored =3D %d, counted =3D %u\n",
> -			i, le16_to_cpu(gdp->bg_free_blocks_count), x);
> +		printk(KERN_DEBUG "group %u: stored =3D %d, counted =3D %u\n",
> +			i, ext4_free_blks_count(sb, gdp), x);
>  		bitmap_count +=3D x;
>  	}
>  	brelse(bitmap_bh);
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 54bf062..e2eab19 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3048,7 +3048,7 @@ retry:
>  			WARN_ON(ret <=3D 0);
>  			printk(KERN_ERR "%s: ext4_ext_get_blocks "
>  				    "returned error inode#%lu, block=3D%u, "
> -				    "max_blocks=3D%lu", __func__,
> +				    "max_blocks=3D%u", __func__,
>  				    inode->i_ino, block, max_blocks);
>  #endif
>  			ext4_mark_inode_dirty(handle, inode);
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 918aec0..deba54f 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -3025,7 +3025,7 @@ ext4_mb_mark_diskspace_used(struct ext4_allocat=
ion_context *ac,
>  		goto out_err;
>=20
>  	ext4_debug("using block group %u(%d)\n", ac->ac_b_ex.fe_group,
> -			gdp->bg_free_blocks_count);
> +			ext4_free_blks_count(sb, gdp));
>=20
>  	err =3D ext4_journal_get_write_access(handle, gdp_bh);
>  	if (err)

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
