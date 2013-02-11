From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 06/12] ext4: grab page before starting transaction
 handle in write_begin()
Date: Mon, 11 Feb 2013 17:35:49 +0100
Message-ID: <20130211163549.GO5318@quack.suse.cz>
References: <1360446832-12724-1-git-send-email-tytso@mit.edu>
 <1360446832-12724-7-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39269 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757785Ab3BKQfv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Feb 2013 11:35:51 -0500
Content-Disposition: inline
In-Reply-To: <1360446832-12724-7-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat 09-02-13 16:53:46, Ted Tso wrote:
> The grab_cache_page_write_begin() function can potentially sleep for a
> long time, since it may need to do memory allocation which can block
> if the system is under significant memory pressure, and because it may
> be blocked on page writeback.  If it does take a long time to grab the
> page, it's better that we not hold an active jbd2 handle.
> 
> So grab a handle on the page first, and _then_ start the transaction
> handle.
> 
> This commit fixes the following long transaction handle hold time:
> 
> postmark-2917  [000] ....   196.435786: jbd2_handle_stats: dev 254,32
>    tid 570 type 2 line_no 2541 interval 311 sync 0 requested_blocks 1
>    dirtied_blocks 0
  OK, the patch looks correct. ext4_write_begin() becomes a bit complex but
it's still well contained so I guess it's worth the improvement. You can
add:
  Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  fs/ext4/inode.c | 111 ++++++++++++++++++++++++++++++++++----------------------
>  1 file changed, 68 insertions(+), 43 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index c3c47e2..38164a8 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -906,32 +906,40 @@ static int ext4_write_begin(struct file *file, struct address_space *mapping,
>  		ret = ext4_try_to_write_inline_data(mapping, inode, pos, len,
>  						    flags, pagep);
>  		if (ret < 0)
> -			goto out;
> -		if (ret == 1) {
> -			ret = 0;
> -			goto out;
> -		}
> +			return ret;
> +		if (ret == 1)
> +			return 0;
>  	}
>  
> -retry:
> +	/*
> +	 * grab_cache_page_write_begin() can take a long time if the
> +	 * system is thrashing due to memory pressure, or if the page
> +	 * is being written back.  So grab it first before we start
> +	 * the transaction handle.  This also allows us to allocate
> +	 * the page (if needed) without using GFP_NOFS.
> +	 */
> +retry_grab:
> +	page = grab_cache_page_write_begin(mapping, index, flags);
> +	if (!page)
> +		return -ENOMEM;
> +	unlock_page(page);
> +
> +retry_journal:
>  	handle = ext4_journal_start(inode, EXT4_HT_WRITE_PAGE, needed_blocks);
>  	if (IS_ERR(handle)) {
> -		ret = PTR_ERR(handle);
> -		goto out;
> +		page_cache_release(page);
> +		return PTR_ERR(handle);
>  	}
>  
> -	/* We cannot recurse into the filesystem as the transaction is already
> -	 * started */
> -	flags |= AOP_FLAG_NOFS;
> -
> -	page = grab_cache_page_write_begin(mapping, index, flags);
> -	if (!page) {
> +	lock_page(page);
> +	if (page->mapping != mapping) {
> +		/* The page got truncated from under us */
> +		unlock_page(page);
> +		page_cache_release(page);
>  		ext4_journal_stop(handle);
> -		ret = -ENOMEM;
> -		goto out;
> +		goto retry_grab;
>  	}
> -
> -	*pagep = page;
> +	wait_on_page_writeback(page);
>  
>  	if (ext4_should_dioread_nolock(inode))
>  		ret = __block_write_begin(page, pos, len, ext4_get_block_write);
> @@ -946,7 +954,6 @@ retry:
>  
>  	if (ret) {
>  		unlock_page(page);
> -		page_cache_release(page);
>  		/*
>  		 * __block_write_begin may have instantiated a few blocks
>  		 * outside i_size.  Trim these off again. Don't need
> @@ -970,11 +977,14 @@ retry:
>  			if (inode->i_nlink)
>  				ext4_orphan_del(NULL, inode);
>  		}
> -	}
>  
> -	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
> -		goto retry;
> -out:
> +		if (ret == -ENOSPC &&
> +		    ext4_should_retry_alloc(inode->i_sb, &retries))
> +			goto retry_journal;
> +		page_cache_release(page);
> +		return ret;
> +	}
> +	*pagep = page;
>  	return ret;
>  }
>  
> @@ -2524,42 +2534,52 @@ static int ext4_da_write_begin(struct file *file, struct address_space *mapping,
>  						      pos, len, flags,
>  						      pagep, fsdata);
>  		if (ret < 0)
> -			goto out;
> -		if (ret == 1) {
> -			ret = 0;
> -			goto out;
> -		}
> +			return ret;
> +		if (ret == 1)
> +			return 0;
>  	}
>  
> -retry:
> +	/*
> +	 * grab_cache_page_write_begin() can take a long time if the
> +	 * system is thrashing due to memory pressure, or if the page
> +	 * is being written back.  So grab it first before we start
> +	 * the transaction handle.  This also allows us to allocate
> +	 * the page (if needed) without using GFP_NOFS.
> +	 */
> +retry_grab:
> +	page = grab_cache_page_write_begin(mapping, index, flags);
> +	if (!page)
> +		return -ENOMEM;
> +	unlock_page(page);
> +
>  	/*
>  	 * With delayed allocation, we don't log the i_disksize update
>  	 * if there is delayed block allocation. But we still need
>  	 * to journalling the i_disksize update if writes to the end
>  	 * of file which has an already mapped buffer.
>  	 */
> +retry_journal:
>  	handle = ext4_journal_start(inode, EXT4_HT_WRITE_PAGE, 1);
>  	if (IS_ERR(handle)) {
> -		ret = PTR_ERR(handle);
> -		goto out;
> +		page_cache_release(page);
> +		return PTR_ERR(handle);
>  	}
> -	/* We cannot recurse into the filesystem as the transaction is already
> -	 * started */
> -	flags |= AOP_FLAG_NOFS;
>  
> -	page = grab_cache_page_write_begin(mapping, index, flags);
> -	if (!page) {
> +	lock_page(page);
> +	if (page->mapping != mapping) {
> +		/* The page got truncated from under us */
> +		unlock_page(page);
> +		page_cache_release(page);
>  		ext4_journal_stop(handle);
> -		ret = -ENOMEM;
> -		goto out;
> +		goto retry_grab;
>  	}
> -	*pagep = page;
> +	/* In case writeback began while the page was unlocked */
> +	wait_on_page_writeback(page);
>  
>  	ret = __block_write_begin(page, pos, len, ext4_da_get_block_prep);
>  	if (ret < 0) {
>  		unlock_page(page);
>  		ext4_journal_stop(handle);
> -		page_cache_release(page);
>  		/*
>  		 * block_write_begin may have instantiated a few blocks
>  		 * outside i_size.  Trim these off again. Don't need
> @@ -2567,11 +2587,16 @@ retry:
>  		 */
>  		if (pos + len > inode->i_size)
>  			ext4_truncate_failed_write(inode);
> +
> +		if (ret == -ENOSPC &&
> +		    ext4_should_retry_alloc(inode->i_sb, &retries))
> +			goto retry_journal;
> +
> +		page_cache_release(page);
> +		return ret;
>  	}
>  
> -	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
> -		goto retry;
> -out:
> +	*pagep = page;
>  	return ret;
>  }
>  
> -- 
> 1.7.12.rc0.22.gcdd159b
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
