From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [BUG][Bigalloc] applictions will be blocked for more than 120s
 when we run xfstests #083
Date: Fri, 8 Mar 2013 20:49:40 +0800
Message-ID: <20130308124940.GB18949@gmail.com>
References: <20130307121149.GB2800@gmail.com>
 <alpine.LFD.2.00.1303071457150.24359@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f43.google.com ([209.85.160.43]:43821 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315Ab3CHMe1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Mar 2013 07:34:27 -0500
Received: by mail-pb0-f43.google.com with SMTP id md12so1165805pbc.2
        for <linux-ext4@vger.kernel.org>; Fri, 08 Mar 2013 04:34:26 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1303071457150.24359@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 07, 2013 at 03:07:25PM +0100, Luk=C3=A1=C5=A1 Czerner wrote=
:
[snip]
>=20
> Yes, I can confirm that. The problem is that when we have delayed
> write into unwritten extent we do not reserve any space, which is ok
> because the data has already been allocated, however we might need
> metadata blocks to cover unwritten extent conversion which we do not
> have reserved.
>=20
> Then in writeback time when the extent splic actually happen we
> might not have enough space to allocate metadata blocks hence
> ext4_map_blocks() in mpage_da_map_and_submit() will return -ENOSPC
> to the ext4_da_writepages() caller.
>=20
> However we're in writeback and we do not expect allocation to fail
> because of ENOSPC at all because we should have reserved everything
> we need to complete successfully so in the loop we'll force the
> journal commit hoping that some blocks will be released and retry
> the allocation again...and we'll be stuck in this loop forever.
>=20
> Now here is patch which fixes the problem for me, however it still
> needs some testing. Also we should probably do something about the
> infinite loop in the ext4_da_writepages() - at least warn the user
> if we try too many times so we at least know what's happening
> because it was not easy to find this out.
>=20
> Hopefully I'll send the proper patch soon, but feel free to test the
> fix yourself.

I have seen that you have sent the patch series to the mailing list, an=
d
I will take a close look at them.

=46or this patch, I can confirm that xfstests #083 never hang, and I on=
ly
see the warning from ext4_da_update_reserve_space() in #269.  I guess
that has been fixed by your patch series.  Thanks for fixing it.
Tested-by: Zheng Liu <wenqing.lz@taobao.com>

Regards,
                                                - Zheng

>=20
> Thanks!
> -Lukas
>=20
> ---
>  fs/ext4/ext4.h  |    1 +
>  fs/ext4/inode.c |   76 +++++++++++++++++++++++++++++++++++++++++++++=
++++-----
>  2 files changed, 70 insertions(+), 7 deletions(-)
>=20
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 6e16c18..c20efe2 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -581,6 +581,7 @@ enum {
>  #define EXT4_GET_BLOCKS_NO_LOCK			0x0100
>  	/* Do not put hole in extent cache */
>  #define EXT4_GET_BLOCKS_NO_PUT_HOLE		0x0200
> +#define EXT4_GET_BLOCKS_METADATA_RESERVED	0x0400
> =20
>  /*
>   * Flags used by ext4_free_blocks
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 9ea0cde..46cc739 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -606,7 +606,8 @@ found:
>  	 * let the underlying get_block() function know to
>  	 * avoid double accounting
>  	 */
> -	if (flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE)
> +	if ((flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE) ||
> +	    (flags & EXT4_GET_BLOCKS_METADATA_RESERVED))
>  		ext4_set_inode_state(inode, EXT4_STATE_DELALLOC_RESERVED);
>  	/*
>  	 * We need to check for EXT4 here because migrate
> @@ -636,7 +637,8 @@ found:
>  			(flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE))
>  			ext4_da_update_reserve_space(inode, retval, 1);
>  	}
> -	if (flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE)
> +	if ((flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE) ||
> +	    (flags & EXT4_GET_BLOCKS_METADATA_RESERVED))
>  		ext4_clear_inode_state(inode, EXT4_STATE_DELALLOC_RESERVED);
> =20
>  	if (retval > 0) {
> @@ -1215,6 +1217,56 @@ static int ext4_journalled_write_end(struct fi=
le *file,
>  	return ret ? ret : copied;
>  }
> =20
> +
> +/*
> + * Reserve a metadata for a single block located at lblock
> + */
> +static int ext4_da_reserve_metadata(struct inode *inode, ext4_lblk_t=
 lblock)
> +{
> +	int retries =3D 0;
> +	struct ext4_sb_info *sbi =3D EXT4_SB(inode->i_sb);
> +	struct ext4_inode_info *ei =3D EXT4_I(inode);
> +	unsigned int md_needed;
> +	ext4_lblk_t save_last_lblock;
> +	int save_len;
> +
> +	/*
> +	 * recalculate the amount of metadata blocks to reserve
> +	 * in order to allocate nrblocks
> +	 * worse case is one extent per block
> +	 */
> +repeat:
> +	spin_lock(&ei->i_block_reservation_lock);
> +	/*
> +	 * ext4_calc_metadata_amount() has side effects, which we have
> +	 * to be prepared undo if we fail to claim space.
> +	 */
> +	save_len =3D ei->i_da_metadata_calc_len;
> +	save_last_lblock =3D ei->i_da_metadata_calc_last_lblock;
> +	md_needed =3D EXT4_NUM_B2C(sbi,
> +				 ext4_calc_metadata_amount(inode, lblock));
> +	trace_ext4_da_reserve_space(inode, md_needed);
> +
> +	/*
> +	 * We do still charge estimated metadata to the sb though;
> +	 * we cannot afford to run out of free blocks.
> +	 */
> +	if (ext4_claim_free_clusters(sbi, md_needed, 0)) {
> +		ei->i_da_metadata_calc_len =3D save_len;
> +		ei->i_da_metadata_calc_last_lblock =3D save_last_lblock;
> +		spin_unlock(&ei->i_block_reservation_lock);
> +		if (ext4_should_retry_alloc(inode->i_sb, &retries)) {
> +			yield();
> +			goto repeat;
> +		}
> +		return -ENOSPC;
> +	}
> +	ei->i_reserved_meta_blocks +=3D md_needed;
> +	spin_unlock(&ei->i_block_reservation_lock);
> +
> +	return 0;       /* success */
> +}
> +
>  /*
>   * Reserve a single cluster located at lblock
>   */
> @@ -1601,7 +1653,8 @@ static void mpage_da_map_and_submit(struct mpag=
e_da_data *mpd)
>  	 */
>  	map.m_lblk =3D next;
>  	map.m_len =3D max_blocks;
> -	get_blocks_flags =3D EXT4_GET_BLOCKS_CREATE;
> +	get_blocks_flags =3D EXT4_GET_BLOCKS_CREATE |
> +			   EXT4_GET_BLOCKS_METADATA_RESERVED;
>  	if (ext4_should_dioread_nolock(mpd->inode))
>  		get_blocks_flags |=3D EXT4_GET_BLOCKS_IO_CREATE_EXT;
>  	if (mpd->b_state & (1 << BH_Delay))
> @@ -1766,7 +1819,7 @@ static int ext4_da_map_blocks(struct inode *ino=
de, sector_t iblock,
>  			      struct buffer_head *bh)
>  {
>  	struct extent_status es;
> -	int retval;
> +	int retval, ret;
>  	sector_t invalid_block =3D ~((sector_t) 0xffff);
> =20
>  	if (invalid_block < ext4_blocks_count(EXT4_SB(inode->i_sb)->s_es))
> @@ -1804,9 +1857,19 @@ static int ext4_da_map_blocks(struct inode *in=
ode, sector_t iblock,
>  		map->m_len =3D retval;
>  		if (ext4_es_is_written(&es))
>  			map->m_flags |=3D EXT4_MAP_MAPPED;
> -		else if (ext4_es_is_unwritten(&es))
> +		else if (ext4_es_is_unwritten(&es)) {
> +			/*
> +			 * We have delalloc write into the unwritten extent
> +			 * which means that we have to reserve metadata
> +			 * potentially required for converting unwritten
> +			 * extent.
> +			 */
> +			ret =3D ext4_da_reserve_metadata(inode, iblock);
> +			if (ret)
> +				/* not enough space to reserve */
> +				retval =3D ret;
>  			map->m_flags |=3D EXT4_MAP_UNWRITTEN;
> -		else
> +		} else
>  			BUG_ON(1);
> =20
>  		return retval;
> @@ -1838,7 +1901,6 @@ static int ext4_da_map_blocks(struct inode *ino=
de, sector_t iblock,
> =20
>  add_delayed:
>  	if (retval =3D=3D 0) {
> -		int ret;
>  		/*
>  		 * XXX: __block_prepare_write() unmaps passed block,
>  		 * is it OK?
> --=20
> 1.7.7.6
>=20
>=20
>=20
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
