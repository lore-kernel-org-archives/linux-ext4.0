From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC] ext4: fix a BUG in ext4_mpage_readpages()
Date: Thu, 5 Nov 2015 16:40:31 +0100
Message-ID: <20151105154031.GC23628@quack.suse.cz>
References: <1446623914-9367-1-git-send-email-yalin.wang2010@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: yalin wang <yalin.wang2010@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1446623914-9367-1-git-send-email-yalin.wang2010@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 04-11-15 15:58:34, yalin wang wrote:
> The last block should be the total read pages last block,
> need adjust the block number when caculate every page.
> 
> Signed-off-by: yalin wang <yalin.wang2010@gmail.com>
> ---
>  fs/ext4/readpage.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/readpage.c b/fs/ext4/readpage.c
> index 5dc5e95..d20c39d 100644
> --- a/fs/ext4/readpage.c
> +++ b/fs/ext4/readpage.c
> @@ -174,7 +174,7 @@ int ext4_mpage_readpages(struct address_space *mapping,
>  			goto confused;
>  
>  		block_in_file = (sector_t)page->index << (PAGE_CACHE_SHIFT - blkbits);
> -		last_block = block_in_file + nr_pages * blocks_per_page;
> +		last_block = block_in_file + (nr_pages - page_idx) * blocks_per_page;

I don't think your patch is correct. The for loop decrements nr_pages at each
iteration so the original code looks fine... Or which problems do you
observe?

								Honza

>  		last_block_in_file = (i_size_read(inode) + blocksize - 1) >> blkbits;
>  		if (last_block > last_block_in_file)
>  			last_block = last_block_in_file;
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
