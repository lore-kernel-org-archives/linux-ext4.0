From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [RFC PATCH -v2] ext4: Retry block reservation
Date: Mon, 25 Aug 2008 14:06:33 -0700
Message-ID: <1219698393.6394.11.camel@mingming-laptop>
References: <1219663233-21849-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1219663233-21849-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1219663233-21849-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:48682 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753538AbYHYVGi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Aug 2008 17:06:38 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7PL6YE0002222
	for <linux-ext4@vger.kernel.org>; Mon, 25 Aug 2008 17:06:34 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7PL6YQ2211842
	for <linux-ext4@vger.kernel.org>; Mon, 25 Aug 2008 17:06:34 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7PL6X7E022347
	for <linux-ext4@vger.kernel.org>; Mon, 25 Aug 2008 17:06:34 -0400
In-Reply-To: <1219663233-21849-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-08-25=E4=B8=80=E7=9A=84 16:50 +0530=EF=BC=8CAneesh Kumar=
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
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext4/balloc.c  |    8 +++++++-
>  fs/ext4/inode.c   |   33 ++++++++++++++++++++++++++++++---
>  fs/ext4/mballoc.c |    7 ++++++-
>  3 files changed, 43 insertions(+), 5 deletions(-)
>=20
> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index 4a53541..b7d1347 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -1760,10 +1760,16 @@ ext4_fsblk_t ext4_old_new_blocks(handle_t *ha=
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

Could   ext4_claim_free_blocks() returns the total number of blocks
shortage, so that we don't need to "guess" how much to attempt to
allocate?


>  			*errp =3D -ENOSPC;
>  			return 0;	/*return with ENOSPC error */
>  		}
> +		num =3D *count;
>  	}
>  	/*
>  	 * Check quota for allocation of this block.
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index d965a05..72a4a71 100644
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
> @@ -1813,6 +1819,26 @@ static void ext4_da_block_invalidatepages(stru=
ct mpage_da_data *mpd,
>  	return;
>  }
>=20
> +static void ext4_print_free_blocks(struct super_block *sb)
> +{
> +#ifdef EXT4FS_DEBUG
> +	ext4_group_t i;
> +	struct ext4_group_desc *gdp;
> +	ext4_group_t ngroups =3D EXT4_SB(sb)->s_groups_count;
> +	printk(KERN_DEBUG "Free blocks details\n");
> +	for (i =3D 0; i < ngroups; i++) {
> +		gdp =3D ext4_get_group_desc(sb, i, NULL);
> +		if (!gdp)
> +			continue;
> +		printk(KERN_DEBUG "Free blocks in group %lu is %d\n",
> +				i, le16_to_cpu(gdp->bg_free_blocks_count));
> +	}
> +#endif
> +	printk(KERN_CRIT "Total free blocks count %lld\n",
> +			ext4_count_free_blocks(sb));
> +	return;
> +}
> +

Ext4_count_free_blocks() has the extra debugging code too. I think you
could calling ext4_count_free_blocks() directly and don't need the new
function ext4_print_free_blocks().
>  /*
>   * mpage_da_map_blocks - go through given space
>   *
> @@ -1825,20 +1851,18 @@ static void ext4_da_block_invalidatepages(str=
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
> @@ -1871,6 +1895,9 @@ static int  mpage_da_map_blocks(struct mpage_da=
_data *mpd)
>  				  lbh->b_size >> mpd->inode->i_blkbits, err);
>  		printk(KERN_EMERG "This should not happen.!! "
>  					"Data will be lost\n");

could we print out the error code with the warning message here?

> +		if (err =3D=3D -ENOSPC) {
> +			ext4_print_free_blocks(mpd->inode->i_sb);
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
