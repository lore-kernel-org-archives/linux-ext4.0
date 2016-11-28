From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/5] mbcache: remove unnecessary module_get/module_put
Date: Mon, 28 Nov 2016 14:12:47 +0100
Message-ID: <20161128131247.GJ2590@quack2.suse.cz>
References: <1480227481-98535-1-git-send-email-ebiggers@google.com>
 <1480227481-98535-3-git-send-email-ebiggers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Andreas Gruenbacher <agruenba@redhat.com>
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34786 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754190AbcK1NMu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 28 Nov 2016 08:12:50 -0500
Content-Disposition: inline
In-Reply-To: <1480227481-98535-3-git-send-email-ebiggers@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat 26-11-16 22:17:59, Eric Biggers wrote:
> When mbcache is built as a module, any modules that use it (ext2 and/or
> ext4) will depend on its symbols directly, incrementing its reference
> count.  Therefore, there is no need to do module_get/module_put.
> 
> Also note that since the module_get/module_put were in the mbcache
> module itself, executing those lines of code was already dependent on
> another reference to the mbcache module being held.

Correct. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  fs/mbcache.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/fs/mbcache.c b/fs/mbcache.c
> index c56ab21..07c5d7d 100644
> --- a/fs/mbcache.c
> +++ b/fs/mbcache.c
> @@ -344,9 +344,6 @@ struct mb_cache *mb_cache_create(int bucket_bits)
>  	int bucket_count = 1 << bucket_bits;
>  	int i;
>  
> -	if (!try_module_get(THIS_MODULE))
> -		return NULL;
> -
>  	cache = kzalloc(sizeof(struct mb_cache), GFP_KERNEL);
>  	if (!cache)
>  		goto err_out;
> @@ -377,7 +374,6 @@ struct mb_cache *mb_cache_create(int bucket_bits)
>  	return cache;
>  
>  err_out:
> -	module_put(THIS_MODULE);
>  	return NULL;
>  }
>  EXPORT_SYMBOL(mb_cache_create);
> @@ -411,7 +407,6 @@ void mb_cache_destroy(struct mb_cache *cache)
>  	}
>  	kfree(cache->c_hash);
>  	kfree(cache);
> -	module_put(THIS_MODULE);
>  }
>  EXPORT_SYMBOL(mb_cache_destroy);
>  
> -- 
> 2.8.0.rc3.226.g39d4020
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
