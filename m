From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd: use kmem_cache_zalloc for allocating journal head
Date: Mon, 29 Apr 2013 14:34:42 +0200
Message-ID: <20130429123442.GA21982@quack.suse.cz>
References: <1367226531-3027-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>,
	Jan Kara <jack@suse.cz>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42565 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752634Ab3D2Mep (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Apr 2013 08:34:45 -0400
Content-Disposition: inline
In-Reply-To: <1367226531-3027-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 29-04-13 17:08:51, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> This commit tries to use kmem_cache_zalloc instead of kmem_cache_alloc/
> memset when a new journal head is alloctated.
  Thanks. Merged.

								Honza
> 
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> Cc: Jan Kara <jack@suse.cz>
> ---
> Hi Jan,
> 
> This patch could be folded into the commit that you have applied:
>   jbd: use kmem_cache_zalloc instead of kmem_cache_alloc/memset
> 
> Regards,
> 						- Zheng
> 
>  fs/jbd/journal.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
> index 81cc7ea..c5a6926 100644
> --- a/fs/jbd/journal.c
> +++ b/fs/jbd/journal.c
> @@ -1845,7 +1845,7 @@ static struct journal_head *journal_alloc_journal_head(void)
>  #ifdef CONFIG_JBD_DEBUG
>  	atomic_inc(&nr_journal_heads);
>  #endif
> -	ret = kmem_cache_alloc(journal_head_cache, GFP_NOFS);
> +	ret = kmem_cache_zalloc(journal_head_cache, GFP_NOFS);
>  	if (ret == NULL) {
>  		jbd_debug(1, "out of memory for journal_head\n");
>  		printk_ratelimited(KERN_NOTICE "ENOMEM in %s, retrying.\n",
> @@ -1853,7 +1853,7 @@ static struct journal_head *journal_alloc_journal_head(void)
>  
>  		while (ret == NULL) {
>  			yield();
> -			ret = kmem_cache_alloc(journal_head_cache, GFP_NOFS);
> +			ret = kmem_cache_zalloc(journal_head_cache, GFP_NOFS);
>  		}
>  	}
>  	return ret;
> @@ -1915,10 +1915,8 @@ struct journal_head *journal_add_journal_head(struct buffer_head *bh)
>  	struct journal_head *new_jh = NULL;
>  
>  repeat:
> -	if (!buffer_jbd(bh)) {
> +	if (!buffer_jbd(bh))
>  		new_jh = journal_alloc_journal_head();
> -		memset(new_jh, 0, sizeof(*new_jh));
> -	}
>  
>  	jbd_lock_bh_journal_head(bh);
>  	if (buffer_jbd(bh)) {
> -- 
> 1.7.12.rc2.18.g61b472e
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
