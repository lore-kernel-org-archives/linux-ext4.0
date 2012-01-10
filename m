From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd: clear b_modified before moving the jh to a
 different transaction
Date: Tue, 10 Jan 2012 21:17:06 +0100
Message-ID: <20120110201706.GD4516@quack.suse.cz>
References: <1326219175-4529-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	jack@suse.cz
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46074 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932622Ab2AJURJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Jan 2012 15:17:09 -0500
Content-Disposition: inline
In-Reply-To: <1326219175-4529-1-git-send-email-josef@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 10-01-12 13:12:55, Josef Bacik wrote:
> If we are journalling data (ie journal=data or big symlinks) we can discard
> buffers and move them to different transactions to make sure they get cleaned up
> properly.  The problem is b_modified could still be set from the last
> transaction that touched it, so putting it on the currently running transaction
> or setting it up to be put on the next transaction will run into problems if the
> buffer gets reused in that transaction as the space accounting logic won't be
> done, which will result in panics at commit time because t_nr_buffers will end
> up being more than t_outstanding_credits.  Thanks to Jan Kara for pointing out
> the other part of this problem a few months ago.  Thanks,
  Ho hum, I'm inclined to apply this just because it makes sense. But I
still don't see how a transaction can reuse a buffer from BJ_Forget list.
We attach there only truncated buffers and their underlying block can be
reallocated only after the transaction freeing them is committed. So have
you some incentive that this patch indeed fixes the t_outstanding_credits
assertion you were hunting?

								Honza

> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
>  fs/jbd/transaction.c  |    5 ++++-
>  fs/jbd2/transaction.c |    5 ++++-
>  2 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
> index 7e59c6e..c968788 100644
> --- a/fs/jbd/transaction.c
> +++ b/fs/jbd/transaction.c
> @@ -1784,6 +1784,7 @@ static int __dispose_buffer(struct journal_head *jh, transaction_t *transaction)
>  		 */
>  		clear_buffer_dirty(bh);
>  		__journal_file_buffer(jh, transaction, BJ_Forget);
> +		jh->b_modified = 0;
>  		may_free = 0;
>  	} else {
>  		JBUFFER_TRACE(jh, "on running transaction");
> @@ -1952,8 +1953,10 @@ static int journal_unmap_buffer(journal_t *journal, struct buffer_head *bh)
>  		 * clear dirty bits when it is done with the buffer.
>  		 */
>  		set_buffer_freed(bh);
> -		if (journal->j_running_transaction && buffer_jbddirty(bh))
> +		if (journal->j_running_transaction && buffer_jbddirty(bh)) {
> +			jh->b_modified = 0;
>  			jh->b_next_transaction = journal->j_running_transaction;
> +		}
>  		journal_put_journal_head(jh);
>  		spin_unlock(&journal->j_list_lock);
>  		jbd_unlock_bh_state(bh);
> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> index a0e41a4..094dcd8 100644
> --- a/fs/jbd2/transaction.c
> +++ b/fs/jbd2/transaction.c
> @@ -1756,6 +1756,7 @@ static int __dispose_buffer(struct journal_head *jh, transaction_t *transaction)
>  		 * __journal_file_buffer
>  		 */
>  		clear_buffer_dirty(bh);
> +		jh->b_modified = 0;
>  		__jbd2_journal_file_buffer(jh, transaction, BJ_Forget);
>  		may_free = 0;
>  	} else {
> @@ -1917,8 +1918,10 @@ static int journal_unmap_buffer(journal_t *journal, struct buffer_head *bh)
>  		 * clear dirty bits when it is done with the buffer.
>  		 */
>  		set_buffer_freed(bh);
> -		if (journal->j_running_transaction && buffer_jbddirty(bh))
> +		if (journal->j_running_transaction && buffer_jbddirty(bh)) {
> +			jh->b_modified = 0;
>  			jh->b_next_transaction = journal->j_running_transaction;
> +		}
>  		jbd2_journal_put_journal_head(jh);
>  		spin_unlock(&journal->j_list_lock);
>  		jbd_unlock_bh_state(bh);
> -- 
> 1.7.5.2
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
