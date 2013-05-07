From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 17/29] ext4: Better estimate credits needed for
 ext4_da_writepages()
Date: Tue, 7 May 2013 14:33:47 +0800
Message-ID: <20130507063347.GA19271@gmail.com>
References: <1365456754-29373-1-git-send-email-jack@suse.cz>
 <1365456754-29373-18-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f49.google.com ([209.85.210.49]:57189 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506Ab3EGGQJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 May 2013 02:16:09 -0400
Received: by mail-da0-f49.google.com with SMTP id p5so140938dak.22
        for <linux-ext4@vger.kernel.org>; Mon, 06 May 2013 23:16:08 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1365456754-29373-18-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 08, 2013 at 11:32:22PM +0200, Jan Kara wrote:
> We limit the number of blocks written in a single loop of
> ext4_da_writepages() to 64 when inode uses indirect blocks. That is
> unnecessary as credit estimates for mapping logically continguous run of
> blocks is rather low even for inode with indirect blocks. So just lift
> this limitation and properly calculate the number of necessary credits.
> 
> This better credit estimate will also later allow us to always write at
> least a single page in one iteration.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

A minor comment below.  Otherwise the patch looks good to me.
Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>

> ---
>  fs/ext4/ext4.h    |    3 +-
>  fs/ext4/extents.c |   16 ++++++--------
>  fs/ext4/inode.c   |   58 ++++++++++++++++++++--------------------------------
>  3 files changed, 30 insertions(+), 47 deletions(-)
...
>  static int ext4_da_writepages_trans_blocks(struct inode *inode)
>  {
> -	int max_blocks = EXT4_I(inode)->i_reserved_data_blocks;
> -
> -	/*
> -	 * With non-extent format the journal credit needed to
> -	 * insert nrblocks contiguous block is dependent on
> -	 * number of contiguous block. So we will limit
> -	 * number of contiguous block to a sane value
> -	 */
> -	if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)) &&
> -	    (max_blocks > EXT4_MAX_TRANS_DATA))
> -		max_blocks = EXT4_MAX_TRANS_DATA;
> +	int bpp = ext4_journal_blocks_per_page(inode);
>  
> -	return ext4_chunk_trans_blocks(inode, max_blocks);
> +	return ext4_meta_trans_blocks(inode,
> +				MAX_WRITEPAGES_EXTENT_LEN + bpp - 1, bpp);

FWIW, MAX_WRITEPAGES_EXTENT_LEN is defined at patch 18/29.  So after
applied this patch, we will get a build error.  So that would be great
if MAX_WRITEPAGES_EXTENT_LEN can be define in this commit.

Regards,
                                                - Zheng

>  }
>  
>  /*
> @@ -4396,11 +4389,12 @@ int ext4_getattr(struct vfsmount *mnt, struct dentry *dentry,
>  	return 0;
>  }
>  
> -static int ext4_index_trans_blocks(struct inode *inode, int nrblocks, int chunk)
> +static int ext4_index_trans_blocks(struct inode *inode, int lblocks,
> +				   int pextents)
>  {
>  	if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
> -		return ext4_ind_trans_blocks(inode, nrblocks);
> -	return ext4_ext_index_trans_blocks(inode, nrblocks, chunk);
> +		return ext4_ind_trans_blocks(inode, lblocks);
> +	return ext4_ext_index_trans_blocks(inode, pextents);
>  }
>  
>  /*
> @@ -4414,7 +4408,8 @@ static int ext4_index_trans_blocks(struct inode *inode, int nrblocks, int chunk)
>   *
>   * Also account for superblock, inode, quota and xattr blocks
>   */
> -static int ext4_meta_trans_blocks(struct inode *inode, int nrblocks, int chunk)
> +static int ext4_meta_trans_blocks(struct inode *inode, int lblocks,
> +				  int pextents)
>  {
>  	ext4_group_t groups, ngroups = ext4_get_groups_count(inode->i_sb);
>  	int gdpblocks;
> @@ -4422,14 +4417,10 @@ static int ext4_meta_trans_blocks(struct inode *inode, int nrblocks, int chunk)
>  	int ret = 0;
>  
>  	/*
> -	 * How many index blocks need to touch to modify nrblocks?
> -	 * The "Chunk" flag indicating whether the nrblocks is
> -	 * physically contiguous on disk
> -	 *
> -	 * For Direct IO and fallocate, they calls get_block to allocate
> -	 * one single extent at a time, so they could set the "Chunk" flag
> +	 * How many index blocks need to touch to map @lblocks logical blocks
> +	 * to @pextents physical extents?
>  	 */
> -	idxblocks = ext4_index_trans_blocks(inode, nrblocks, chunk);
> +	idxblocks = ext4_index_trans_blocks(inode, lblocks, pextents);
>  
>  	ret = idxblocks;
>  
> @@ -4437,12 +4428,7 @@ static int ext4_meta_trans_blocks(struct inode *inode, int nrblocks, int chunk)
>  	 * Now let's see how many group bitmaps and group descriptors need
>  	 * to account
>  	 */
> -	groups = idxblocks;
> -	if (chunk)
> -		groups += 1;
> -	else
> -		groups += nrblocks;
> -
> +	groups = idxblocks + pextents;
>  	gdpblocks = groups;
>  	if (groups > ngroups)
>  		groups = ngroups;
> @@ -4473,7 +4459,7 @@ int ext4_writepage_trans_blocks(struct inode *inode)
>  	int bpp = ext4_journal_blocks_per_page(inode);
>  	int ret;
>  
> -	ret = ext4_meta_trans_blocks(inode, bpp, 0);
> +	ret = ext4_meta_trans_blocks(inode, bpp, bpp);
>  
>  	/* Account for data blocks for journalled mode */
>  	if (ext4_should_journal_data(inode))
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
