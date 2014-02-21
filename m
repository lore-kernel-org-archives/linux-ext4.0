From: Jan Kara <jack@suse.cz>
Subject: Re: [patch] ext3: remove unneeded check in ext3_ordered_writepage()
Date: Fri, 21 Feb 2014 10:08:09 +0100
Message-ID: <20140221090809.GA12506@quack.suse.cz>
References: <20140221085854.GC13185@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140221085854.GC13185@elgon.mountain>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri 21-02-14 11:58:54, Dan Carpenter wrote:
> We already know "ret" is zero so there is no need to do:
> 
> 		if (!ret)
> 			ret = err;
> 
> We can just assign ret directly instead.
  Thanks. I've added the patch to my tree.

								Honza

> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
> index 384b6ebb655f..491f022c476a 100644
> --- a/fs/ext3/inode.c
> +++ b/fs/ext3/inode.c
> @@ -1673,12 +1673,9 @@ static int ext3_ordered_writepage(struct page *page,
>  	 * block_write_full_page() succeeded.  Otherwise they are unmapped,
>  	 * and generally junk.
>  	 */
> -	if (ret == 0) {
> -		err = walk_page_buffers(handle, page_bufs, 0, PAGE_CACHE_SIZE,
> +	if (ret == 0)
> +		ret = walk_page_buffers(handle, page_bufs, 0, PAGE_CACHE_SIZE,
>  					NULL, journal_dirty_data_fn);
> -		if (!ret)
> -			ret = err;
> -	}
>  	walk_page_buffers(handle, page_bufs, 0,
>  			PAGE_CACHE_SIZE, NULL, bput_one);
>  	err = ext3_journal_stop(handle);
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
