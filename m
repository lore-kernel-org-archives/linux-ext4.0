Return-Path: <SRS0=c0SX=OB=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44646 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729105AbeKVXPP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 22 Nov 2018 18:15:15 -0500
Date: Thu, 22 Nov 2018 13:36:01 +0100
From: Jan Kara <jack@suse.cz>
To: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Cc: linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4: fix deadlock while checkpoint thread waits commit
 thread to finish
Message-ID: <20181122123601.GO9840@quack2.suse.cz>
References: <20181114114935.5250-1-xiaoguang.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181114114935.5250-1-xiaoguang.wang@linux.alibaba.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 14-11-18 19:49:35, Xiaoguang Wang wrote:
> This issue was found when I tried to put checkpoint work in a separate thread,
> the deadlock below happened:
>          Thread1                                |   Thread2
> __jbd2_log_wait_for_space                       |
> jbd2_log_do_checkpoint (hold j_checkpoint_mutex)|
>   if (jh->b_transaction != NULL)                |
>     ...                                         |
>     jbd2_log_start_commit(journal, tid);        |jbd2_update_log_tail
>                                                 |  will lock j_checkpoint_mutex,
>                                                 |  but will be blocked here.
>                                                 |
>     jbd2_log_wait_commit(journal, tid);         |
>     wait_event(journal->j_wait_done_commit,     |
>      !tid_gt(tid, journal->j_commit_sequence)); |
>      ...                                        |wake_up(j_wait_done_commit)
>   }                                             |
> 
> then deadlock occurs, Thread1 will never be waken up.
> 
> To fix this issue, drop j_checkpoint_mutex in jbd2_log_do_checkpoint()
> when we are going to wait for transaction commit.
> 
> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>

Thanks for the patch! One comment below...

> diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
> index 26f8d7e46462..e728844f2f0e 100644
> --- a/fs/jbd2/checkpoint.c
> +++ b/fs/jbd2/checkpoint.c
> @@ -113,7 +113,7 @@ void __jbd2_log_wait_for_space(journal_t *journal)
>  	nblocks = jbd2_space_needed(journal);
>  	while (jbd2_log_space_left(journal) < nblocks) {
>  		write_unlock(&journal->j_state_lock);
> -		mutex_lock(&journal->j_checkpoint_mutex);
> +		mutex_lock_io(&journal->j_checkpoint_mutex);
>  
>  		/*
>  		 * Test again, another process may have checkpointed while we
> @@ -241,8 +241,8 @@ int jbd2_log_do_checkpoint(journal_t *journal)
>  	 * done (maybe it's a new transaction, but it fell at the same
>  	 * address).
>  	 */
> -	if (journal->j_checkpoint_transactions != transaction ||
> -	    transaction->t_tid != this_tid)
> +	if (journal->j_checkpoint_transactions == NULL ||
> +	    journal->j_checkpoint_transactions->t_tid != this_tid)
>  		goto out;

Why did you change this? As far as I can tell there's no difference and the
previous condition makes it more obvious that we are still looking at the
same transaction.

Otherwise the patch looks good so after removing the above hunk feel free to
add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza


> @@ -276,9 +276,22 @@ int jbd2_log_do_checkpoint(journal_t *journal)
>  		"JBD2: %s: Waiting for Godot: block %llu\n",
>  		journal->j_devname, (unsigned long long) bh->b_blocknr);
>  
> +			if (batch_count)
> +				__flush_batch(journal, &batch_count);
>  			jbd2_log_start_commit(journal, tid);
> +			/*
> +			 * jbd2_journal_commit_transaction() may want
> +			 * to take the checkpoint_mutex if JBD2_FLUSHED
> +			 * is set, jbd2_update_log_tail() called by
> +			 * jbd2_journal_commit_transaction() may also take
> +			 * checkpoint_mutex.  So we need to temporarily
> +			 * drop it.
> +			 */
> +			mutex_unlock(&journal->j_checkpoint_mutex);
>  			jbd2_log_wait_commit(journal, tid);
> -			goto retry;
> +			mutex_lock_io(&journal->j_checkpoint_mutex);
> +			spin_lock(&journal->j_list_lock);
> +			goto restart;
>  		}
>  		if (!buffer_dirty(bh)) {
>  			if (unlikely(buffer_write_io_error(bh)) && !result)
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 8ef6b6daaa7a..88d8f22d2cba 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -2067,7 +2067,7 @@ int jbd2_journal_wipe(journal_t *journal, int write)
>  	err = jbd2_journal_skip_recovery(journal);
>  	if (write) {
>  		/* Lock to make assertions happy... */
> -		mutex_lock(&journal->j_checkpoint_mutex);
> +		mutex_lock_io(&journal->j_checkpoint_mutex);
>  		jbd2_mark_journal_empty(journal, REQ_SYNC | REQ_FUA);
>  		mutex_unlock(&journal->j_checkpoint_mutex);
>  	}
> -- 
> 2.17.2
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
