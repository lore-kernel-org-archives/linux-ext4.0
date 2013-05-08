From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 19/29] ext4: Remove buffer_uninit handling
Date: Wed, 8 May 2013 14:56:39 +0800
Message-ID: <20130508065639.GA20599@gmail.com>
References: <1365456754-29373-1-git-send-email-jack@suse.cz>
 <1365456754-29373-20-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f41.google.com ([209.85.210.41]:43116 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327Ab3EHGi6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 May 2013 02:38:58 -0400
Received: by mail-da0-f41.google.com with SMTP id y19so808067dan.14
        for <linux-ext4@vger.kernel.org>; Tue, 07 May 2013 23:38:58 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1365456754-29373-20-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 08, 2013 at 11:32:24PM +0200, Jan Kara wrote:
> There isn't any need for setting BH_Uninit on buffers anymore. It was
> only used to signal we need to mark io_end as needing extent conversion
> in add_bh_to_extent() but now we can mark the io_end directly when
> mapping extent.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
Regards,
                                                - Zheng

> ---
>  fs/ext4/ext4.h    |   15 ++++++---------
>  fs/ext4/inode.c   |    4 ++--
>  fs/ext4/page-io.c |    2 --
>  3 files changed, 8 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index cb1ba1c..3c3827a 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -2606,20 +2606,17 @@ extern void ext4_mmp_csum_set(struct super_block *sb, struct mmp_struct *mmp);
>  extern int ext4_mmp_csum_verify(struct super_block *sb,
>  				struct mmp_struct *mmp);
>  
> -/* BH_Uninit flag: blocks are allocated but uninitialized on disk */
> +/*
> + * Note that these flags will never ever appear in a buffer_head's state flag.
> + * See EXT4_MAP_... to see where this is used.
> + */
>  enum ext4_state_bits {
>  	BH_Uninit	/* blocks are allocated but uninitialized on disk */
> -	  = BH_JBDPrivateStart,
> +	 = BH_JBDPrivateStart,
>  	BH_AllocFromCluster,	/* allocated blocks were part of already
> -				 * allocated cluster. Note that this flag will
> -				 * never, ever appear in a buffer_head's state
> -				 * flag. See EXT4_MAP_FROM_CLUSTER to see where
> -				 * this is used. */
> +				 * allocated cluster. */
>  };
>  
> -BUFFER_FNS(Uninit, uninit)
> -TAS_BUFFER_FNS(Uninit, uninit)
> -
>  /*
>   * Add new method to test whether block and inode bitmaps are properly
>   * initialized. With uninit_bg reading the block from disk is not enough
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 5c191a3..0602a09 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1924,8 +1924,6 @@ static int mpage_map_and_submit_buffers(struct mpage_da_data *mpd)
>  					clear_buffer_delay(bh);
>  					bh->b_blocknr = pblock++;
>  				}
> -				if (mpd->map.m_flags & EXT4_MAP_UNINIT)
> -					set_buffer_uninit(bh);
>  				clear_buffer_unwritten(bh);
>  			} while (lblk++, (bh = bh->b_this_page) != head);
>  
> @@ -1975,6 +1973,8 @@ static int mpage_map_one_extent(handle_t *handle, struct mpage_da_data *mpd)
>  	err = ext4_map_blocks(handle, inode, map, get_blocks_flags);
>  	if (err < 0)
>  		return err;
> +	if (map->m_flags & EXT4_MAP_UNINIT)
> +		ext4_set_io_unwritten_flag(inode, mpd->io_submit.io_end);
>  
>  	BUG_ON(map->m_len == 0);
>  	if (map->m_flags & EXT4_MAP_NEW) {
> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index efdf0a5..cc59cd9 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c
> @@ -377,8 +377,6 @@ submit_and_retry:
>  	if (ret != bh->b_size)
>  		goto submit_and_retry;
>  	io_end = io->io_end;
> -	if (test_clear_buffer_uninit(bh))
> -		ext4_set_io_unwritten_flag(inode, io_end);
>  	io_end->size += bh->b_size;
>  	io->io_next_block++;
>  	return 0;
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
