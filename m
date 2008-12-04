From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] ext4: Fix s_dirty_blocks_counter if block allocation
	failed with nodelalloc
Date: Thu, 04 Dec 2008 10:19:29 -0800
Message-ID: <1228414769.7319.5.camel@mingming-laptop>
References: <1228399465-6749-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:46449 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754797AbYLDSTk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Dec 2008 13:19:40 -0500
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e33.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id mB4IJ2X3017971
	for <linux-ext4@vger.kernel.org>; Thu, 4 Dec 2008 11:19:02 -0700
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mB4IJd7c191398
	for <linux-ext4@vger.kernel.org>; Thu, 4 Dec 2008 11:19:39 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mB4IJU16017523
	for <linux-ext4@vger.kernel.org>; Thu, 4 Dec 2008 11:19:37 -0700
In-Reply-To: <1228399465-6749-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-12-04=E5=9B=9B=E7=9A=84 19:34 +0530=EF=BC=8CAneesh Kumar=
 K.V=E5=86=99=E9=81=93=EF=BC=9A
> With nodelalloc option we need to update the dirty block counter on
> block allocation failure. This is needed because we increment the
> dirty block counter early in the block allocation phase. Without
> the patch s_dirty_blocks_counter goes wrong so that filesystem's
> free blocks decreases incorrectly.
>=20

Reviewed by: Mingming Cao <cmm@us.ibm.com>

> Tested-by: Akira Fujita <a-fujita@rs.jp.nec.com>
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext4/mballoc.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
>=20
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index bacc2f4..22d31c3 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -4550,7 +4550,7 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handl=
e,
>  	}
>  	if (ar->len =3D=3D 0) {
>  		*errp =3D -EDQUOT;
> -		return 0;
> +		goto out3;
>  	}
>  	inquota =3D ar->len;
>=20
> @@ -4623,6 +4623,13 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *hand=
le,
>  out1:
>  	if (ar->len < inquota)
>  		DQUOT_FREE_BLOCK(ar->inode, inquota - ar->len);
> +out3:
> +	if (!ar->len) {
> +		if (!EXT4_I(ar->inode)->i_delalloc_reserved_flag)
> +			/* release all the reserved blocks if non delalloc */
> +			percpu_counter_sub(&sbi->s_dirtyblocks_counter,
> +						reserv_blks);
> +	}
>=20
>  	return block;
>  }

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
