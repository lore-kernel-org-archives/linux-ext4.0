From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] jbd2: fold __wait_cp_io into jbd2_log_do_checkpoint()
Date: Tue, 2 Sep 2014 18:30:33 +0200
Message-ID: <20140902163033.GC19412@quack.suse.cz>
References: <1409624051-6902-1-git-send-email-tytso@mit.edu>
 <1409624051-6902-2-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46467 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751666AbaIBQah (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Sep 2014 12:30:37 -0400
Content-Disposition: inline
In-Reply-To: <1409624051-6902-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 01-09-14 22:14:11, Ted Tso wrote:
> __wait_cp_io() is only called by jbd2_log_do_checkpoint().  Fold it in
> to make it a bit easier to understand.
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
  Hum, is this really such a win? Unlike __process_buffer(), this function
is well separated so IMHO the code is better readable before the folding.

								Honza

> ---
>  fs/jbd2/checkpoint.c | 87 +++++++++++++++++++---------------------------------
>  1 file changed, 31 insertions(+), 56 deletions(-)
> 
> diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
> index 993a187..22fcd50 100644
> --- a/fs/jbd2/checkpoint.c
> +++ b/fs/jbd2/checkpoint.c
> @@ -183,58 +183,6 @@ void __jbd2_log_wait_for_space(journal_t *journal)
>  	}
>  }
>  
> -/*
> - * Clean up transaction's list of buffers submitted for io.
> - * We wait for any pending IO to complete and remove any clean
> - * buffers. Note that we take the buffers in the opposite ordering
> - * from the one in which they were submitted for IO.
> - *
> - * Return 0 on success, and return <0 if some buffers have failed
> - * to be written out.
> - *
> - * Called with j_list_lock held.
> - */
> -static int __wait_cp_io(journal_t *journal, transaction_t *transaction)
> -{
> -	struct journal_head *jh;
> -	struct buffer_head *bh;
> -	tid_t this_tid;
> -	int released = 0;
> -	int ret = 0;
> -
> -	this_tid = transaction->t_tid;
> -restart:
> -	/* Did somebody clean up the transaction in the meanwhile? */
> -	if (journal->j_checkpoint_transactions != transaction ||
> -			transaction->t_tid != this_tid)
> -		return ret;
> -	while (!released && transaction->t_checkpoint_io_list) {
> -		jh = transaction->t_checkpoint_io_list;
> -		bh = jh2bh(jh);
> -		get_bh(bh);
> -		if (buffer_locked(bh)) {
> -			spin_unlock(&journal->j_list_lock);
> -			wait_on_buffer(bh);
> -			/* the journal_head may have gone by now */
> -			BUFFER_TRACE(bh, "brelse");
> -			__brelse(bh);
> -			spin_lock(&journal->j_list_lock);
> -			goto restart;
> -		}
> -		if (unlikely(buffer_write_io_error(bh)))
> -			ret = -EIO;
> -
> -		/*
> -		 * Now in whatever state the buffer currently is, we know that
> -		 * it has been written out and so we can drop it from the list
> -		 */
> -		released = __jbd2_journal_remove_checkpoint(jh);
> -		__brelse(bh);
> -	}
> -
> -	return ret;
> -}
> -
>  static void
>  __flush_batch(journal_t *journal, int *batch_count)
>  {
> @@ -268,7 +216,7 @@ int jbd2_log_do_checkpoint(journal_t *journal)
>  	struct buffer_head	*bh;
>  	transaction_t		*transaction;
>  	tid_t			this_tid;
> -	int			err, result, batch_count = 0;
> +	int			result, batch_count = 0, done = 0;
>  
>  	jbd_debug(1, "Start checkpoint\n");
>  
> @@ -384,9 +332,36 @@ restart:
>  	 * Now we issued all of the transaction's buffers, let's deal
>  	 * with the buffers that are out for I/O.
>  	 */
> -	err = __wait_cp_io(journal, transaction);
> -	if (!result)
> -		result = err;
> +restart2:
> +	/* Did somebody clean up the transaction in the meanwhile? */
> +	if (journal->j_checkpoint_transactions != transaction ||
> +	    transaction->t_tid != this_tid)
> +		goto out;
> +
> +	while (!done && transaction->t_checkpoint_io_list) {
> +		jh = transaction->t_checkpoint_io_list;
> +		bh = jh2bh(jh);
> +		get_bh(bh);
> +		if (buffer_locked(bh)) {
> +			spin_unlock(&journal->j_list_lock);
> +			wait_on_buffer(bh);
> +			/* the journal_head may have gone by now */
> +			BUFFER_TRACE(bh, "brelse");
> +			__brelse(bh);
> +			spin_lock(&journal->j_list_lock);
> +			goto restart2;
> +		}
> +		if (unlikely(buffer_write_io_error(bh)) && !result)
> +			result = -EIO;
> +
> +		/*
> +		 * Now in whatever state the buffer currently is, we
> +		 * know that it has been written out and so we can
> +		 * drop it from the list
> +		 */
> +		done = __jbd2_journal_remove_checkpoint(jh);
> +		__brelse(bh);
> +	}
>  out:
>  	spin_unlock(&journal->j_list_lock);
>  	if (result < 0)
> -- 
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
