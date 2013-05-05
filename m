From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 10/29] jbd2: Fix race in t_outstanding_credits update in
 jbd2_journal_extend()
Date: Sun, 5 May 2013 16:37:01 +0800
Message-ID: <20130505083701.GA24022@gmail.com>
References: <1365456754-29373-1-git-send-email-jack@suse.cz>
 <1365456754-29373-11-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:48382 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab3EEIT0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 5 May 2013 04:19:26 -0400
Received: by mail-pd0-f175.google.com with SMTP id y14so1536382pdi.6
        for <linux-ext4@vger.kernel.org>; Sun, 05 May 2013 01:19:25 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1365456754-29373-11-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 08, 2013 at 11:32:15PM +0200, Jan Kara wrote:
> jbd2_journal_extend() first checked whether transaction can accept extending
> handle with more credits and then added credits to t_outstanding_credits.
> This can race with start_this_handle() adding another handle to a transaction
> and thus overbooking a transaction. Make jbd2_journal_extend() use
> atomic_add_return() to close the race.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
Regards,
                                                - Zheng

> ---
>  fs/jbd2/transaction.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> index aee40c9..9639e47 100644
> --- a/fs/jbd2/transaction.c
> +++ b/fs/jbd2/transaction.c
> @@ -434,11 +434,13 @@ int jbd2_journal_extend(handle_t *handle, int nblocks)
>  	}
>  
>  	spin_lock(&transaction->t_handle_lock);
> -	wanted = atomic_read(&transaction->t_outstanding_credits) + nblocks;
> +	wanted = atomic_add_return(nblocks,
> +				   &transaction->t_outstanding_credits);
>  
>  	if (wanted > journal->j_max_transaction_buffers) {
>  		jbd_debug(3, "denied handle %p %d blocks: "
>  			  "transaction too large\n", handle, nblocks);
> +		atomic_sub(nblocks, &transaction->t_outstanding_credits);
>  		goto unlock;
>  	}
>  
> @@ -446,6 +448,7 @@ int jbd2_journal_extend(handle_t *handle, int nblocks)
>  	    jbd2_log_space_left(journal)) {
>  		jbd_debug(3, "denied handle %p %d blocks: "
>  			  "insufficient log space\n", handle, nblocks);
> +		atomic_sub(nblocks, &transaction->t_outstanding_credits);
>  		goto unlock;
>  	}
>  
> @@ -457,7 +460,6 @@ int jbd2_journal_extend(handle_t *handle, int nblocks)
>  
>  	handle->h_buffer_credits += nblocks;
>  	handle->h_requested_credits += nblocks;
> -	atomic_add(nblocks, &transaction->t_outstanding_credits);
>  	result = 0;
>  
>  	jbd_debug(3, "extended handle %p by %d\n", handle, nblocks);
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
