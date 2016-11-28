From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/5] mbcache: don't BUG() if entry cache cannot be
 allocated
Date: Mon, 28 Nov 2016 13:09:20 +0100
Message-ID: <20161128120920.GG2590@quack2.suse.cz>
References: <1480227481-98535-1-git-send-email-ebiggers@google.com>
 <1480227481-98535-2-git-send-email-ebiggers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Andreas Gruenbacher <agruenba@redhat.com>
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52714 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754159AbcK1MJX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 28 Nov 2016 07:09:23 -0500
Content-Disposition: inline
In-Reply-To: <1480227481-98535-2-git-send-email-ebiggers@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat 26-11-16 22:17:58, Eric Biggers wrote:
> mbcache can be a module that is loaded long after startup, when someone
> asks to mount an ext2 or ext4 filesystem.  Therefore it should not BUG()
> if kmem_cache_create() fails, but rather just fail the module load.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Makes sense. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/mbcache.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/mbcache.c b/fs/mbcache.c
> index 31e54c2..c56ab21 100644
> --- a/fs/mbcache.c
> +++ b/fs/mbcache.c
> @@ -420,7 +420,8 @@ static int __init mbcache_init(void)
>  	mb_entry_cache = kmem_cache_create("mbcache",
>  				sizeof(struct mb_cache_entry), 0,
>  				SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD, NULL);
> -	BUG_ON(!mb_entry_cache);
> +	if (!mb_entry_cache)
> +		return -ENOMEM;
>  	return 0;
>  }
>  
> -- 
> 2.8.0.rc3.226.g39d4020
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
