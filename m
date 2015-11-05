From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC] ext4: remove unused page_idx
Date: Thu, 5 Nov 2015 16:42:27 +0100
Message-ID: <20151105154227.GD23628@quack.suse.cz>
References: <1446624219-27190-1-git-send-email-yalin.wang2010@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: yalin wang <yalin.wang2010@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1446624219-27190-1-git-send-email-yalin.wang2010@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 04-11-15 16:03:39, yalin wang wrote:
> Signed-off-by: yalin wang <yalin.wang2010@gmail.com>
> ---
>  fs/ext4/readpage.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> ignore my previous patch

Ah, ignore my previous review ;) But next time it is good to reply to that
patch that you are withdrawing it to so that people can immediately see it.

This patch look good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.com>

								Honza

> 
> diff --git a/fs/ext4/readpage.c b/fs/ext4/readpage.c
> index 5dc5e95..2cc2760 100644
> --- a/fs/ext4/readpage.c
> +++ b/fs/ext4/readpage.c
> @@ -135,7 +135,6 @@ int ext4_mpage_readpages(struct address_space *mapping,
>  			 unsigned nr_pages)
>  {
>  	struct bio *bio = NULL;
> -	unsigned page_idx;
>  	sector_t last_block_in_bio = 0;
>  
>  	struct inode *inode = mapping->host;
> @@ -157,7 +156,7 @@ int ext4_mpage_readpages(struct address_space *mapping,
>  	map.m_len = 0;
>  	map.m_flags = 0;
>  
> -	for (page_idx = 0; nr_pages; page_idx++, nr_pages--) {
> +	for (; nr_pages; nr_pages--) {
>  		int fully_mapped = 1;
>  		unsigned first_hole = blocks_per_page;
>  
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
