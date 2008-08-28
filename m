From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH -V3 03/11] ext4: Retry block reservation
Date: Thu, 28 Aug 2008 13:42:35 -0700
Message-ID: <1219956155.6384.3.camel@mingming-laptop>
References: <1219850916-8986-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1219850916-8986-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1219850916-8986-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:38651 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315AbYH1Umj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Aug 2008 16:42:39 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7SKgcvV015017
	for <linux-ext4@vger.kernel.org>; Thu, 28 Aug 2008 16:42:38 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7SKgber139316
	for <linux-ext4@vger.kernel.org>; Thu, 28 Aug 2008 14:42:37 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7SKgaqC022935
	for <linux-ext4@vger.kernel.org>; Thu, 28 Aug 2008 14:42:36 -0600
In-Reply-To: <1219850916-8986-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-08-27=E4=B8=89=E7=9A=84 20:58 +0530=EF=BC=8CAneesh Kumar=
 K.V=E5=86=99=E9=81=93=EF=BC=9A
> During block reservation if we don't have enough
> blocks left, retry block reservation with smaller
> block count. This make sure we try fallocate
> and DIO with smaller request size and don't fail early.
> The delayed allocation reservation cannot try with smaller
> block count. So retry block reservation to handle temporary
> disk full conditions.  Also print free blocks details if we
> fail block allocation during writepages.
>=20
Added to patch queue.
Reviewed-by: Mingming Cao <cmm@us.ibm.com>
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext4/balloc.c  |    8 +++++++-
>  fs/ext4/inode.c   |   14 +++++++++++---
>  fs/ext4/mballoc.c |    7 ++++++-
>  3 files changed, 24 insertions(+), 5 deletions(-)
>=20
> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index dc10bfd..5767332 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -1738,10 +1738,16 @@ ext4_fsblk_t ext4_old_new_blocks(handle_t *ha=
ndle, struct inode *inode,
>  		/*
>  		 * With delalloc we already reserved the blocks
>  		 */
> -		if (ext4_claim_free_blocks(sbi, *count)) {
> +		while (*count && ext4_claim_free_blocks(sbi, *count)) {
> +			/* let others to free the space */
> +			yield();
> +			*count =3D *count >> 1;
> +		}
> +		if (!*count) {
>  			*errp =3D -ENOSPC;
>  			return 0;	/*return with ENOSPC error */
>  		}
> +		num =3D *count;
>  	}
>  	/*
>  	 * Check quota for allocation of this block.
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index d965a05..98a998b 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1521,6 +1521,7 @@ static int ext4_journalled_write_end(struct fil=
e *file,
>=20
>  static int ext4_da_reserve_space(struct inode *inode, int nrblocks)
>  {
> +	int retries =3D 0;
>         struct ext4_sb_info *sbi =3D EXT4_SB(inode->i_sb);
>         unsigned long md_needed, mdblocks, total =3D 0;
>=20
> @@ -1529,6 +1530,7 @@ static int ext4_da_reserve_space(struct inode *=
inode, int nrblocks)
>  	 * in order to allocate nrblocks
>  	 * worse case is one extent per block
>  	 */
> +repeat:
>  	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
>  	total =3D EXT4_I(inode)->i_reserved_data_blocks + nrblocks;
>  	mdblocks =3D ext4_calc_metadata_amount(inode, total);
> @@ -1539,6 +1541,10 @@ static int ext4_da_reserve_space(struct inode =
*inode, int nrblocks)
>=20
>  	if (ext4_claim_free_blocks(sbi, total)) {
>  		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> +		if (ext4_should_retry_alloc(inode->i_sb, &retries)) {
> +			yield();
> +			goto repeat;
> +		}
>  		return -ENOSPC;
>  	}
>  	EXT4_I(inode)->i_reserved_data_blocks +=3D nrblocks;
> @@ -1825,20 +1831,18 @@ static void ext4_da_block_invalidatepages(str=
uct mpage_da_data *mpd,
>  static int  mpage_da_map_blocks(struct mpage_da_data *mpd)
>  {
>  	int err =3D 0;
> +	struct buffer_head new;
>  	struct buffer_head *lbh =3D &mpd->lbh;
>  	sector_t next =3D lbh->b_blocknr;
> -	struct buffer_head new;
>=20
>  	/*
>  	 * We consider only non-mapped and non-allocated blocks
>  	 */
>  	if (buffer_mapped(lbh) && !buffer_delay(lbh))
>  		return 0;
> -
>  	new.b_state =3D lbh->b_state;
>  	new.b_blocknr =3D 0;
>  	new.b_size =3D lbh->b_size;
> -
>  	/*
>  	 * If we didn't accumulate anything
>  	 * to write simply return
> @@ -1871,6 +1875,10 @@ static int  mpage_da_map_blocks(struct mpage_d=
a_data *mpd)
>  				  lbh->b_size >> mpd->inode->i_blkbits, err);
>  		printk(KERN_EMERG "This should not happen.!! "
>  					"Data will be lost\n");
> +		if (err =3D=3D -ENOSPC) {
> +			printk(KERN_CRIT "Total free blocks count %lld\n",
> +				ext4_count_free_blocks(mpd->inode->i_sb));
> +		}
>  		/* invlaidate all the pages */
>  		ext4_da_block_invalidatepages(mpd, next,
>  				lbh->b_size >> mpd->inode->i_blkbits);
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 4404b46..419009f 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -4397,7 +4397,12 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *hand=
le,
>  		/*
>  		 * With delalloc we already reserved the blocks
>  		 */
> -		if (ext4_claim_free_blocks(sbi, ar->len)) {
> +		while (ar->len && ext4_claim_free_blocks(sbi, ar->len)) {
> +			/* let others to free the space */
> +			yield();
> +			ar->len =3D ar->len >> 1;
> +		}
> +		if (!ar->len) {
>  			*errp =3D -ENOSPC;
>  			return 0;
>  		}

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
