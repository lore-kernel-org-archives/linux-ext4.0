From: Jan Kara <jack@suse.cz>
Subject: Re: [patch 4/6] jbd: remove dependency on __GFP_NOFAIL
Date: Tue, 17 Aug 2010 11:51:03 +0200
Message-ID: <20100817095103.GA3557@quack.suse.cz>
References: <alpine.DEB.2.00.1008161953430.17924@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1008161956190.17924@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: David Rientjes <rientjes@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51266 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750961Ab0HQJvo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Aug 2010 05:51:44 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1008161956190.17924@chino.kir.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 16-08-10 19:58:01, David Rientjes wrote:
> Removes the dependency on __GFP_NOFAIL by looping indefinitely in the
> caller.
> 
> The error handling when kzalloc() returns NULL in start_this_handle()
> was removed since it was unreachable.
  Thanks! I've added the patch to my tree. Since rc1 is over, I think this
is a material for the next merge window, right? I can take care of pushing
it. If you want to push the change yourself, feel free to add
  Acked-by: Jan Kara <jack@suse.cz>

								Honza
> 
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  fs/jbd/journal.c     |    5 ++++-
>  fs/jbd/transaction.c |   14 ++++++--------
>  2 files changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
> --- a/fs/jbd/journal.c
> +++ b/fs/jbd/journal.c
> @@ -301,7 +301,10 @@ int journal_write_metadata_buffer(transaction_t *transaction,
>  	 */
>  	J_ASSERT_BH(bh_in, buffer_jbddirty(bh_in));
>  
> -	new_bh = alloc_buffer_head(GFP_NOFS|__GFP_NOFAIL);
> +	do {
> +		/* FIXME: this may potentially loop forever */
> +		new_bh = alloc_buffer_head(GFP_NOFS);
> +	} while (!new_bh);
>  	/* keep subsequent assertions sane */
>  	new_bh->b_state = 0;
>  	init_buffer(new_bh, NULL, NULL);
> diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
> --- a/fs/jbd/transaction.c
> +++ b/fs/jbd/transaction.c
> @@ -98,14 +98,12 @@ static int start_this_handle(journal_t *journal, handle_t *handle)
>  	}
>  
>  alloc_transaction:
> -	if (!journal->j_running_transaction) {
> -		new_transaction = kzalloc(sizeof(*new_transaction),
> -						GFP_NOFS|__GFP_NOFAIL);
> -		if (!new_transaction) {
> -			ret = -ENOMEM;
> -			goto out;
> -		}
> -	}
> +	if (!journal->j_running_transaction)
> +		do {
> +			/* FIXME: this may potentially loop forever */
> +			new_transaction = kzalloc(sizeof(*new_transaction),
> +								GFP_NOFS);
> +		} while (!new_transaction);
>  
>  	jbd_debug(3, "New handle %p going live.\n", handle);
>  
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
