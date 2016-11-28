From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/5] mbcache: correctly handle 'e_referenced' bit
Date: Mon, 28 Nov 2016 11:44:20 +0100
Message-ID: <20161128104420.GF2590@quack2.suse.cz>
References: <1480227481-98535-1-git-send-email-ebiggers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Andreas Gruenbacher <agruenba@redhat.com>
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39253 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754384AbcK1KoW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 28 Nov 2016 05:44:22 -0500
Content-Disposition: inline
In-Reply-To: <1480227481-98535-1-git-send-email-ebiggers@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat 26-11-16 22:17:57, Eric Biggers wrote:
> mbcache entries have an 'e_referenced' bit which users can set with
> mb_cache_entry_touch() to indicate that an entry should be given another
> pass through the LRU list before the shrinker can delete it.  However,
> mb_cache_shrink() actually would, when seeing an e_referenced entry at
> the front of the list (the least-recently used end), place it right at
> the front of the list again.  The next iteration would then remove the
> entry from the list and delete it.  Consequently, e_referenced had
> essentially no effect, so ext2/ext4 xattr blocks would sometimes not be
> reused as often as expected.
> 
> Fix this by making the shrinker move e_referenced entries to the back of
> the list rather than the front.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Bah, good spotting. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

BTW, how did you find out?

								Honza
> ---
>  fs/mbcache.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/mbcache.c b/fs/mbcache.c
> index c5bd19f..31e54c2 100644
> --- a/fs/mbcache.c
> +++ b/fs/mbcache.c
> @@ -286,7 +286,7 @@ static unsigned long mb_cache_shrink(struct mb_cache *cache,
>  					 struct mb_cache_entry, e_list);
>  		if (entry->e_referenced) {
>  			entry->e_referenced = 0;
> -			list_move_tail(&cache->c_list, &entry->e_list);
> +			list_move_tail(&entry->e_list, &cache->c_list);
>  			continue;
>  		}
>  		list_del_init(&entry->e_list);
> -- 
> 2.8.0.rc3.226.g39d4020
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
