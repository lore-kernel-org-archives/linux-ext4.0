From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd: remove unneeded semicolon
Date: Thu, 4 Jul 2013 00:59:08 +0200
Message-ID: <20130703225908.GA30822@quack.suse.cz>
References: <1372884741.11138.0.camel@lizardlounge>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: akpm@linux-foundation.org, jack@suse.cz,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53181 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755195Ab3GCW7K (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Jul 2013 18:59:10 -0400
Content-Disposition: inline
In-Reply-To: <1372884741.11138.0.camel@lizardlounge>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 03-07-13 13:52:21, Nathaniel Yazdani wrote:
> This patch removes an unnecessary semicolon that was placed after the closing
> bracket of an inline JBD wrapper function.
  Thanks. Added to my tree.

								Honza
> 
> Signed-off-by: Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com>
> ---
> diff --git a/include/linux/jbd.h b/include/linux/jbd.h
> index 7e0b622..9d789a9 100644
> --- a/include/linux/jbd.h
> +++ b/include/linux/jbd.h
> @@ -78,7 +78,7 @@ static inline void *jbd_alloc(size_t size, gfp_t flags)
>  static inline void jbd_free(void *ptr, size_t size)
>  {
>  	free_pages((unsigned long)ptr, get_order(size));
> -};
> +}
>  
>  #define JFS_MIN_JOURNAL_BLOCKS 1024
>  
> 
> 
> 
> 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
