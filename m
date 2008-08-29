From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH -V3 09/11] ext4: Fix ext4 nomballoc allocator for ENOSPC
Date: Thu, 28 Aug 2008 22:02:10 -0700
Message-ID: <1219986130.16004.5.camel@mingming-laptop>
References: <1219850916-8986-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1219850916-8986-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1219850916-8986-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1219850916-8986-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1219850916-8986-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1219850916-8986-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1219850916-8986-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1219850916-8986-9-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1219960669.6384.58.camel@mingming-laptop>
	 <20080829034451.GA6444@skywalker>  <20080829041202.GB6444@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:37733 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbYH2FCN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Aug 2008 01:02:13 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7T52CwL019222
	for <linux-ext4@vger.kernel.org>; Fri, 29 Aug 2008 01:02:12 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7T52Cbd193024
	for <linux-ext4@vger.kernel.org>; Thu, 28 Aug 2008 23:02:12 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7T52Bm1008688
	for <linux-ext4@vger.kernel.org>; Thu, 28 Aug 2008 23:02:12 -0600
In-Reply-To: <20080829041202.GB6444@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-08-29=E4=BA=94=E7=9A=84 09:44 +0530=EF=BC=8CAneesh Kumar=
 K.V=E5=86=99=E9=81=93=EF=BC=9A
> On Fri, Aug 29, 2008 at 09:14:51AM +0530, Aneesh Kumar K.V wrote:
> > On Thu, Aug 28, 2008 at 02:57:49PM -0700, Mingming Cao wrote:
> > >=20
> > > From: Mingming Cao <cmm@us.ibm.com>
> > >=20
> > > ext4: Fix ext4 nomballoc allocator for ENOSPC
> > >    =20
> > > We run into ENOSPC error on nonmballoc ext4, even when there is f=
ree blocks
> > > on the filesystem.
> > >=20
> > > The problem is triggered in the case the goal block group has 0 f=
ree blocks
> > > , and the rest block groups are skipped due to the check of "free=
_blocks=20
> > > < windowsz/2".
> >=20
> > The goal block group had free blocks < windowsz .
> >=20
> >=20
>=20
> Ok how about this. The Final change is same to what you have done.
> But it make the code easier to understand. I also added a comment
> explaining the details
>=20

=46ine with me, I will update the patch in the ext4 patch queue with
additional comment.  But Andrew has already took ext2/3 version to mm
tree, I am not sure if it worth to resend with an patch against origina=
l
patch.

> commit 0216ee1ac13270c1ab7b7517d41775727f7da02d
> Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Date:   Fri Aug 29 09:35:15 2008 +0530
>=20
>     ext4: Fix ext4 nomballoc allocator for ENOSPC
>    =20
>     We run into ENOSPC error on nonmballoc ext4, even when there is f=
ree blocks
>     on the filesystem.
>    =20
>     The patch include two changes
>    =20
>     a) Set reservation to NULL if we trying to allocate near group_ta=
rget_block
>     from the goal group if the free block in the group is less than w=
indowsz.
>     This should give us a better chance to allocate near group_target=
_block.
>     This also ensures that if we are not allocating near group_target=
_block
>     then we don't trun off reservation. This should enable us to allo=
cate
>     with reservation from other groups that have large free blocks co=
unt.
>    =20
>     b) we don't need to check the window size if the block reservatio=
n is off.
>    =20
>     Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
>     Signed-off-by: Mingming Cao <cmm@us.ibm.com>
>=20
> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index cfe01b4..399bec5 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -1802,15 +1802,17 @@ ext4_fsblk_t ext4_old_new_blocks(handle_t *ha=
ndle, struct inode *inode,
>  		goto io_error;
>=20
>  	free_blocks =3D le16_to_cpu(gdp->bg_free_blocks_count);
> -	/*
> -	 * if there is not enough free blocks to make a new resevation
> -	 * turn off reservation for this allocation
> -	 */
> -	if (my_rsv && (free_blocks < windowsz)
> -		&& (rsv_is_empty(&my_rsv->rsv_window)))
> -		my_rsv =3D NULL;
>=20
>  	if (free_blocks > 0) {
> +		/*
> +		 * try to allocate with group target block
> +		 * in the goal group. If we have low free_blocks
> +		 * count turn off reservation
> +		 */
> +		if (my_rsv && (free_blocks < windowsz)
> +			&& (rsv_is_empty(&my_rsv->rsv_window)))
> +			my_rsv =3D NULL;
> +
>  		bitmap_bh =3D ext4_read_block_bitmap(sb, group_no);
>  		if (!bitmap_bh)
>  			goto io_error;
> @@ -1843,7 +1845,7 @@ ext4_fsblk_t ext4_old_new_blocks(handle_t *hand=
le, struct inode *inode,
>  		 * free blocks is less than half of the reservation
>  		 * window size.
>  		 */
> -		if (free_blocks <=3D (windowsz/2))
> +		if (my_rsv && (free_blocks <=3D (windowsz/2)))
>  			continue;
>=20
>  		brelse(bitmap_bh);

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
