From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2 take2] jbd2: delete spin_lock(t_handle_lock) inside
 wirte_lock(j_state_lock)
Date: Tue, 3 Jan 2012 16:35:04 +0100
Message-ID: <20120103153504.GF31457@quack.suse.cz>
References: <20111216201915.4a012154.toshi.okajima@jp.fujitsu.com>
 <CAGBYx2YZ4M8QwwOcnLAaf+934WAcZoNS_pPrw8j3Nkr3=6fA5g@mail.gmail.com>
 <4EF066F0.5010809@jp.fujitsu.com>
 <20111222203639.4200538e.toshi.okajima@jp.fujitsu.com>
 <20111222210007.ca8fb54f.toshi.okajima@jp.fujitsu.com>
 <CAGBYx2YBq_=N0Gnky7RhNHhyTybhP1fLB6Fzzp-GLhEy6Lyekw@mail.gmail.com>
 <4EF7BDE2.4000309@jp.fujitsu.com>
 <20111226101727.1ca09119.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, adilger.kernel@dilger.ca,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	linux-ext4@vger.kernel.org
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55493 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782Ab2ADRA2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Jan 2012 12:00:28 -0500
Content-Disposition: inline
In-Reply-To: <20111226101727.1ca09119.toshi.okajima@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 26-12-11 10:17:27, Toshiyuki Okajima wrote:
> Delete all spin_lock(t_handle_lock) statements inside write_lock(j_state_lock) 
> because the critical code sections can be protected by write_lock(j_state_lock)
> only.
> 
> Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
> Reported-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
  The patch looks good. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/jbd2/commit.c      |    4 ----
>  fs/jbd2/transaction.c |    6 +-----
>  2 files changed, 1 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> index 68d704d..1030d47 100644
> --- a/fs/jbd2/commit.c
> +++ b/fs/jbd2/commit.c
> @@ -364,22 +364,18 @@ void jbd2_journal_commit_transaction(journal_t *journal)
>  	stats.run.rs_running = jbd2_time_diff(commit_transaction->t_start,
>  					      stats.run.rs_locked);
>  
> -	spin_lock(&commit_transaction->t_handle_lock);
>  	while (atomic_read(&commit_transaction->t_updates)) {
>  		DEFINE_WAIT(wait);
>  
>  		prepare_to_wait(&journal->j_wait_updates, &wait,
>  					TASK_UNINTERRUPTIBLE);
>  		if (atomic_read(&commit_transaction->t_updates)) {
> -			spin_unlock(&commit_transaction->t_handle_lock);
>  			write_unlock(&journal->j_state_lock);
>  			schedule();
>  			write_lock(&journal->j_state_lock);
> -			spin_lock(&commit_transaction->t_handle_lock);
>  		}
>  		finish_wait(&journal->j_wait_updates, &wait);
>  	}
> -	spin_unlock(&commit_transaction->t_handle_lock);
>  
>  	J_ASSERT (atomic_read(&commit_transaction->t_outstanding_credits) <=
>  			journal->j_max_transaction_buffers);
> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> index 76f2eca..c418ed9 100644
> --- a/fs/jbd2/transaction.c
> +++ b/fs/jbd2/transaction.c
> @@ -516,14 +516,10 @@ void jbd2_journal_lock_updates(journal_t *journal)
>  		if (!transaction)
>  			break;
>  
> -		spin_lock(&transaction->t_handle_lock);
> -		if (!atomic_read(&transaction->t_updates)) {
> -			spin_unlock(&transaction->t_handle_lock);
> +		if (!atomic_read(&transaction->t_updates))
>  			break;
> -		}
>  		prepare_to_wait(&journal->j_wait_updates, &wait,
>  				TASK_UNINTERRUPTIBLE);
> -		spin_unlock(&transaction->t_handle_lock);
>  		write_unlock(&journal->j_state_lock);
>  		schedule();
>  		finish_wait(&journal->j_wait_updates, &wait);
> -- 
> 1.5.5.6
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
