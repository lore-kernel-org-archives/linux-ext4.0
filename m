From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] ext4: limit nrblocks properly with non extent format
Date: Tue, 19 Aug 2008 11:07:30 -0700
Message-ID: <1219169250.6416.0.camel@mingming-laptop>
References: <1219128494-10402-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:55677 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752391AbYHSSHx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Aug 2008 14:07:53 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7JIAGHf030730
	for <linux-ext4@vger.kernel.org>; Tue, 19 Aug 2008 14:10:16 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7JI7W4E223052
	for <linux-ext4@vger.kernel.org>; Tue, 19 Aug 2008 14:07:32 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7JI7V7m028894
	for <linux-ext4@vger.kernel.org>; Tue, 19 Aug 2008 14:07:32 -0400
In-Reply-To: <1219128494-10402-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-08-19=E4=BA=8C=E7=9A=84 12:18 +0530=EF=BC=8CAneesh Kumar=
 K.V=E5=86=99=E9=81=93=EF=BC=9A
> We need to make sure adding new buffer_head to the
> contiguous block extent doesn't result in nrblocks
> greater than EXT4_MAX_TRANS_DATA. We only have
> enought credit to insert EXT4_MAX_TRANS_DATA blocks.
>=20
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Reviewed-by: Mingming Cao <cmm@us.ibm.com>
> ---
>  fs/ext4/inode.c |   38 +++++++++++++++++++++++++-------------
>  1 files changed, 25 insertions(+), 13 deletions(-)
>=20
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index dcd1337..a10f8e5 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1909,27 +1909,39 @@ static int  mpage_da_map_blocks(struct mpage_=
da_data *mpd)
>  static void mpage_add_bh_to_extent(struct mpage_da_data *mpd,
>  				   sector_t logical, struct buffer_head *bh)
>  {
> -	struct buffer_head *lbh =3D &mpd->lbh;
>  	sector_t next;
> +	size_t b_size =3D bh->b_size;
> +	struct buffer_head *lbh =3D &mpd->lbh;
>  	int nrblocks =3D lbh->b_size >> mpd->inode->i_blkbits;
>=20
>  	/* check if thereserved journal credits might overflow */
> -	if (!(EXT4_I(mpd->inode)->i_flags & EXT4_EXTENTS_FL) &&
> -	     (nrblocks >=3D EXT4_MAX_TRANS_DATA))
> -		/*
> -		 * With noextent format we are limited by the journal
> -		 * credit available. Total credit needed to insert
> -		 * nrblocks contiguous blocks is dependent on the
> -		 * nrblocks. So limit nrblocks.
> -		 */
> -		goto flush_it;
> -
> +	if (!(EXT4_I(mpd->inode)->i_flags & EXT4_EXTENTS_FL)) {
> +		if (nrblocks >=3D EXT4_MAX_TRANS_DATA) {
> +			/*
> +			 * With noextent format we are limited by the journal
> +			 * credit available. Total credit needed to insert
> +			 * nrblocks contiguous blocks is dependent on the
> +			 * nrblocks. So limit nrblocks.
> +			 */
> +			goto flush_it;
> +		} else if ((nrblocks + (b_size >> mpd->inode->i_blkbits)) >
> +				EXT4_MAX_TRANS_DATA) {
> +			/*
> +			 * Adding the new buffer_head would make it cross the
> +			 * allowed limit for which we have journal credit
> +			 * reserved. So limit the new bh->b_size
> +			 */
> +			b_size =3D (EXT4_MAX_TRANS_DATA - nrblocks) <<
> +						mpd->inode->i_blkbits;
> +			/* we will do mpage_da_submit_io in the next loop */
> +		}
> +	}
>  	/*
>  	 * First block in the extent
>  	 */
>  	if (lbh->b_size =3D=3D 0) {
>  		lbh->b_blocknr =3D logical;
> -		lbh->b_size =3D bh->b_size;
> +		lbh->b_size =3D b_size;
>  		lbh->b_state =3D bh->b_state & BH_FLAGS;
>  		return;
>  	}
> @@ -1939,7 +1951,7 @@ static void mpage_add_bh_to_extent(struct mpage=
_da_data *mpd,
>  	 * Can we merge the block to our big extent?
>  	 */
>  	if (logical =3D=3D next && (bh->b_state & BH_FLAGS) =3D=3D lbh->b_s=
tate) {
> -		lbh->b_size +=3D bh->b_size;
> +		lbh->b_size +=3D b_size;
>  		return;
>  	}
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
