From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] ext4: Fix buffer dirtying in data=journal mode
Date: Wed, 21 Jul 2010 16:32:38 +0200
Message-ID: <20100721143238.GA1215@atrey.karlin.mff.cuni.cz>
References: <1277116973-4183-1-git-send-email-jack@suse.cz> <1277116973-4183-3-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ksp.mff.cuni.cz ([195.113.26.206]:39138 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758618Ab0GUOcl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Jul 2010 10:32:41 -0400
Content-Disposition: inline
In-Reply-To: <1277116973-4183-3-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> block_prepare_write() can dirty freshly created buffer. This is a problem
> for data=journal mode because data buffers shouldn't be dirty unless they
> are undergoing checkpoint. So we have to tweak get_block function for
> data=journal mode to catch the case when block_prepare_write would dirty
> the buffer, do the work instead of block_prepare_write, and properly handle
> dirty buffer as data=journal mode requires it.
> 
> It might be cleaner to avoid using block_prepare_write() for data=journal
> mode writes but that would require us to duplicate most of the function
> which isn't nice either...
  Ted, how about this patch? Do you agree with it? Thanks.

								Honza

> CC: tytso@mit.edu
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/inode.c |   47 +++++++++++++++++++++++++++++++++++++++++++----
>  1 files changed, 43 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 81d6054..526404b 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1388,6 +1388,43 @@ out:
>  	return ret;
>  }
>  
> +static int ext4_journalled_get_block(struct inode *inode, sector_t iblock,
> +				     struct buffer_head *bh, int create)
> +{
> +	handle_t *handle = ext4_journal_current_handle();
> +	int ret;
> +
> +	/* This function should ever be used only for real buffers */
> +	BUG_ON(!bh->b_page);
> +
> +	ret = ext4_get_blocks(handle, inode, iblock, 1, bh,
> +			      create ? EXT4_GET_BLOCKS_CREATE : 0);
> +	if (ret > 0) {
> +		if (buffer_new(bh)) {
> +			struct page *page = bh->b_page;
> +
> +			/*
> +			 * This is a terrible hack to avoid block_prepare_write
> +			 * marking our buffer as dirty
> +			 */
> +			if (PageUptodate(page)) {
> +				ret = ext4_journal_get_write_access(handle, bh);
> +				if (ret < 0)
> +					return ret;
> +				unmap_underlying_metadata(bh->b_bdev,
> +							  bh->b_blocknr);
> +				clear_buffer_new(bh);
> +				set_buffer_uptodate(bh);
> +				ret = jbd2_journal_dirty_metadata(handle, bh);
> +				if (ret < 0)
> +					return ret;
> +			}
> +		}
> +		ret = 0;
> +	}
> +	return ret;
> +}
> +
>  /*
>   * `handle' can be NULL if create is zero
>   */
> @@ -1599,12 +1636,14 @@ retry:
>  	if (ext4_should_dioread_nolock(inode))
>  		ret = block_write_begin(file, mapping, pos, len, flags, pagep,
>  				fsdata, ext4_get_block_write);
> -	else
> +	else if (!ext4_should_journal_data(inode))
>  		ret = block_write_begin(file, mapping, pos, len, flags, pagep,
>  				fsdata, ext4_get_block);
> -
> -	if (!ret && ext4_should_journal_data(inode)) {
> -		ret = walk_page_buffers(handle, page_buffers(page),
> +	else {
> +		ret = block_write_begin(file, mapping, pos, len, flags, pagep,
> +				fsdata, ext4_journalled_get_block);
> +		if (!ret)
> +			ret = walk_page_buffers(handle, page_buffers(page),
>  				from, to, NULL, do_journal_get_write_access);
>  	}
>  
> -- 
> 1.6.4.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
