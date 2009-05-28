From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: Get rid of EXTEND_DISKSIZE flag of
	ext4_get_blocks_handle()
Date: Thu, 28 May 2009 11:51:17 +0200
Message-ID: <20090528095117.GH29199@duck.suse.cz>
References: <1243377638-20620-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:53556 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbZE1JvR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 May 2009 05:51:17 -0400
Content-Disposition: inline
In-Reply-To: <1243377638-20620-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 27-05-09 00:40:38, Jan Kara wrote:
> Get rid of EXTEND_DISKSIZE flag of ext4_get_blocks_handle(). This seems to be a
> relict from some old days and setting disksize in this function does not make
> much sence. Currently it was set only by ext4_getblk().  Since the parameter
> has some effect only if create == 1, it is easy to check by grepping through
> the sources that the three callers which end up calling ext4_getblk() with
> create == 1 (ext4_append, ext4_quota_write, ext4_mkdir) do the right thing and
> set disksize themselves.
  Ted, did you get this patch?

								Bye
									Honza
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/ext4.h    |    6 ++----
>  fs/ext4/extents.c |    8 --------
>  fs/ext4/inode.c   |   20 +++-----------------
>  3 files changed, 5 insertions(+), 29 deletions(-)
> 
>  The patch should be against ext4 patch queue now. Ted, will you merge it
> please? Thanks.
> 									Honza
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index d164f12..7915f7b 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -323,15 +323,13 @@ struct ext4_new_group_data {
>  #define EXT4_GET_BLOCKS_UNINIT_EXT		0x0002
>  #define EXT4_GET_BLOCKS_CREATE_UNINIT_EXT	(EXT4_GET_BLOCKS_UNINIT_EXT|\
>  						 EXT4_GET_BLOCKS_CREATE)
> -	/* Update the ext4_inode_info i_disksize field */
> -#define EXT4_GET_BLOCKS_EXTEND_DISKSIZE		0x0004
>  	/* Caller is from the delayed allocation writeout path,
>  	   so set the magic i_delalloc_reserve_flag after taking the 
>  	   inode allocation semaphore for */
> -#define EXT4_GET_BLOCKS_DELALLOC_RESERVE	0x0008
> +#define EXT4_GET_BLOCKS_DELALLOC_RESERVE	0x0004
>  	/* Call ext4_da_update_reserve_space() after successfully 
>  	   allocating the blocks */
> -#define EXT4_GET_BLOCKS_UPDATE_RESERVE_SPACE	0x0010
> +#define EXT4_GET_BLOCKS_UPDATE_RESERVE_SPACE	0x0008
>  
>  
>  /*
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index a3781c6..938be36 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -2983,14 +2983,6 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
>  	newblock = ext_pblock(&newex);
>  	allocated = ext4_ext_get_actual_len(&newex);
>  outnew:
> -	if (flags & EXT4_GET_BLOCKS_EXTEND_DISKSIZE) {
> -		disksize = ((loff_t) iblock + ar.len) << inode->i_blkbits;
> -		if (disksize > i_size_read(inode))
> -			disksize = i_size_read(inode);
> -		if (disksize > EXT4_I(inode)->i_disksize)
> -			EXT4_I(inode)->i_disksize = disksize;
> -	}
> -
>  	set_buffer_new(bh_result);
>  
>  	/* Cache only when it is _not_ an uninitialized extent */
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 431b470..c86dccd 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1002,19 +1002,7 @@ static int ext4_ind_get_blocks(handle_t *handle, struct inode *inode,
>  	if (!err)
>  		err = ext4_splice_branch(handle, inode, iblock,
>  					partial, indirect_blks, count);
> -	/*
> -	 * i_disksize growing is protected by i_data_sem.  Don't forget to
> -	 * protect it if you're about to implement concurrent
> -	 * ext4_get_block() -bzzz
> -	*/
> -	if (!err && (flags & EXT4_GET_BLOCKS_EXTEND_DISKSIZE)) {
> -		disksize = ((loff_t) iblock + count) << inode->i_blkbits;
> -		if (disksize > i_size_read(inode))
> -			disksize = i_size_read(inode);
> -		if (disksize > ei->i_disksize)
> -			ei->i_disksize = disksize;
> -	}
> -	if (err)
> +	else 
>  		goto cleanup;
>  
>  	set_buffer_new(bh_result);
> @@ -1293,7 +1281,7 @@ struct buffer_head *ext4_getblk(handle_t *handle, struct inode *inode,
>  {
>  	struct buffer_head dummy;
>  	int fatal = 0, err;
> -	int flags = EXT4_GET_BLOCKS_EXTEND_DISKSIZE;
> +	int flags = 0;
>  
>  	J_ASSERT(handle != NULL || create == 0);
>  
> @@ -2104,9 +2092,7 @@ static int mpage_da_map_blocks(struct mpage_da_data *mpd)
>  	}
>  
>  	/*
> -	 * Update on-disk size along with block allocation we don't
> -	 * use EXT4_GET_BLOCKS_EXTEND_DISKSIZE as size may change
> -	 * within already allocated block -bzzz
> +	 * Update on-disk size along with block allocation.
>  	 */
>  	disksize = ((loff_t) next + blks) << mpd->inode->i_blkbits;
>  	if (disksize > i_size_read(mpd->inode))
> -- 
> 1.6.0.2
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
