From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 03/10 v5] ext4: let ext4_ext_map_blocks return
 EXT4_MAP_UNWRITTEN flag
Date: Fri, 8 Feb 2013 16:41:04 +0100
Message-ID: <20130208154104.GC10226@quack.suse.cz>
References: <1360313046-9876-1-git-send-email-wenqing.lz@taobao.com>
 <1360313046-9876-4-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>,
	Theodore Ts'o <tytso@mit.edu>, Jan kara <jack@suse.cz>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36944 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760020Ab3BHPlQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Feb 2013 10:41:16 -0500
Content-Disposition: inline
In-Reply-To: <1360313046-9876-4-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 08-02-13 16:43:59, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> This commit lets ext4_ext_map_blocks return EXT4_MAP_UNWRITTEN flag
> because in later commit ext4_map_blocks needs to use this flag to
> determine the extent status.
  The patch looks good. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> 
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Jan kara <jack@suse.cz>
> ---
>  fs/ext4/extents.c |  6 +++++-
>  fs/ext4/inode.c   | 12 +++---------
>  2 files changed, 8 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index f7bf616..d92947f 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3657,6 +3657,7 @@ ext4_ext_handle_uninitialized_extents(handle_t *handle, struct inode *inode,
>  			ext4_set_io_unwritten_flag(inode, io);
>  		else
>  			ext4_set_inode_state(inode, EXT4_STATE_DIO_UNWRITTEN);
> +		map->m_flags |= EXT4_MAP_UNWRITTEN;
>  		if (ext4_should_dioread_nolock(inode))
>  			map->m_flags |= EXT4_MAP_UNINIT;
>  		goto out;
> @@ -3678,8 +3679,10 @@ ext4_ext_handle_uninitialized_extents(handle_t *handle, struct inode *inode,
>  	 * repeat fallocate creation request
>  	 * we already have an unwritten extent
>  	 */
> -	if (flags & EXT4_GET_BLOCKS_UNINIT_EXT)
> +	if (flags & EXT4_GET_BLOCKS_UNINIT_EXT) {
> +		map->m_flags |= EXT4_MAP_UNWRITTEN;
>  		goto map_out;
> +	}
>  
>  	/* buffered READ or buffered write_begin() lookup */
>  	if ((flags & EXT4_GET_BLOCKS_CREATE) == 0) {
> @@ -4109,6 +4112,7 @@ got_allocated_blocks:
>  	/* Mark uninitialized */
>  	if (flags & EXT4_GET_BLOCKS_UNINIT_EXT){
>  		ext4_ext_mark_uninitialized(&newex);
> +		map->m_flags |= EXT4_MAP_UNWRITTEN;
>  		/*
>  		 * io_end structure was created for every IO write to an
>  		 * uninitialized extent. To avoid unnecessary conversion,
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 7fb00d8..c7e9665 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -560,16 +560,10 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
>  		return retval;
>  
>  	/*
> -	 * When we call get_blocks without the create flag, the
> -	 * BH_Unwritten flag could have gotten set if the blocks
> -	 * requested were part of a uninitialized extent.  We need to
> -	 * clear this flag now that we are committed to convert all or
> -	 * part of the uninitialized extent to be an initialized
> -	 * extent.  This is because we need to avoid the combination
> -	 * of BH_Unwritten and BH_Mapped flags being simultaneously
> -	 * set on the buffer_head.
> +	 * Here we clear m_flags because after allocating an new extent,
> +	 * it will be set again.
>  	 */
> -	map->m_flags &= ~EXT4_MAP_UNWRITTEN;
> +	map->m_flags &= ~EXT4_MAP_FLAGS;
>  
>  	/*
>  	 * New blocks allocate and/or writing to uninitialized extent
> -- 
> 1.7.12.rc2.18.g61b472e
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
