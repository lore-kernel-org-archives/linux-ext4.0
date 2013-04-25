From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] jbd: use kmem_cache_zalloc instead of
 kmem_cache_alloc/memset
Date: Thu, 25 Apr 2013 18:12:49 +0800
Message-ID: <20130425101249.GA16770@gmail.com>
References: <1365769446-22034-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:55492 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab3DYJza (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Apr 2013 05:55:30 -0400
Received: by mail-pa0-f41.google.com with SMTP id kq12so1001329pab.14
        for <linux-ext4@vger.kernel.org>; Thu, 25 Apr 2013 02:55:29 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1365769446-22034-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 12, 2013 at 08:24:06PM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> Now jbd_alloc_handle is only called by new_handle.  So this commit
> uses kmem_cache_zalloc instead of kmem_cache_alloc/memset.
> 
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>

Hi Jan,

Sorry, I forgot to Cc you.  Could you please take a look at this patch?

Thanks,
                                                - Zheng

> ---
>  fs/jbd/transaction.c | 1 -
>  include/linux/jbd.h  | 2 +-
>  2 files changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
> index 071d690..e3e255c 100644
> --- a/fs/jbd/transaction.c
> +++ b/fs/jbd/transaction.c
> @@ -245,7 +245,6 @@ static handle_t *new_handle(int nblocks)
>  	handle_t *handle = jbd_alloc_handle(GFP_NOFS);
>  	if (!handle)
>  		return NULL;
> -	memset(handle, 0, sizeof(*handle));
>  	handle->h_buffer_credits = nblocks;
>  	handle->h_ref = 1;
>  
> diff --git a/include/linux/jbd.h b/include/linux/jbd.h
> index c8f3297..7e0b622 100644
> --- a/include/linux/jbd.h
> +++ b/include/linux/jbd.h
> @@ -887,7 +887,7 @@ extern struct kmem_cache *jbd_handle_cache;
>  
>  static inline handle_t *jbd_alloc_handle(gfp_t gfp_flags)
>  {
> -	return kmem_cache_alloc(jbd_handle_cache, gfp_flags);
> +	return kmem_cache_zalloc(jbd_handle_cache, gfp_flags);
>  }
>  
>  static inline void jbd_free_handle(handle_t *handle)
> -- 
> 1.7.12.rc2.18.g61b472e
> 
