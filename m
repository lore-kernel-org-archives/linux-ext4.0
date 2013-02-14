From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH linux-next] jbd: start_this_handle(): remove kfree()
 redundant null check
Date: Thu, 14 Feb 2013 17:15:20 +0100
Message-ID: <20130214161520.GC31269@quack.suse.cz>
References: <1360693404-61617-1-git-send-email-tim.gardner@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Tim Gardner <tim.gardner@canonical.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45271 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757979Ab3BNQPW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Feb 2013 11:15:22 -0500
Content-Disposition: inline
In-Reply-To: <1360693404-61617-1-git-send-email-tim.gardner@canonical.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 12-02-13 11:23:24, Tim Gardner wrote:
> smatch analysis:
> 
> fs/jbd/transaction.c:236 start_this_handle() info: redundant null
>  check on new_transaction calling kfree()
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: linux-ext4@vger.kernel.org
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> ---
>  fs/jbd/transaction.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
> index 071d690..ee40b4e 100644
> --- a/fs/jbd/transaction.c
> +++ b/fs/jbd/transaction.c
> @@ -232,8 +232,7 @@ repeat_locked:
>  
>  	lock_map_acquire(&handle->h_lockdep_map);
>  out:
> -	if (unlikely(new_transaction))		/* It's usually NULL */
> -		kfree(new_transaction);
> +	kfree(new_transaction);
>  	return ret;
  Thanks for the patch but I actually think this is deliberate because
new_transaction is usually NULL while kfree() is optimized for passed
pointer to be usually != NULL.  Also we save a function call in the common
case. So I'm for the code to stay as is.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
