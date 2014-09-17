From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: Re: [PATCH] jbd2: remove __jbd2_journal_clean_checkpoint_list to
 solve scalability issue
Date: Wed, 17 Sep 2014 16:14:10 +0800
Message-ID: <20140917081410.GU3052@yliu-dev.sh.intel.com>
References: <1410430193-6112-1-git-send-email-yuanhan.liu@linux.intel.com>
 <20140911135147.GD30901@quack.suse.cz>
 <20140911154539.GK3052@yliu-dev.sh.intel.com>
 <20140912094054.GA5958@quack.suse.cz>
 <20140915033852.GL3052@yliu-dev.sh.intel.com>
 <20140916110525.GB1205@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:36083 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751892AbaIQIOF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Sep 2014 04:14:05 -0400
Content-Disposition: inline
In-Reply-To: <20140916110525.GB1205@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 16, 2014 at 01:05:25PM +0200, Jan Kara wrote:
...
> > As drop_transaction() doesn't happen frequently as __buffer_unlink(jh),
> > it should alleviate the lock contention a bit.
>   Yes, drop_transaction() isn't really an issue. But when doing
> __buffer_unlink() during IO completion, making the checkpoint list lock
> per-transaction one won't help the contention for the common case where
> transactions are reasonably large.

Good point.

> 
> I was thinking about it for a while. I was thinking about various clever
> solutions but in the end what I think would be the best is just
> to change __jbd2_journal_clean_checkpoint_list() to bail out once it spots
> a transaction it cannot free. That will deal with the pointless scanning of
> checkpointing lists you are hitting with your workload, it will also do all
> the cleanup that is necessary for transactions to be eventually cleaned up
> from the journal without having to wait in log_do_checkpoint().
> 
> Attached are two patches - lightly tested only. Can you try whether they
> fix the contention for you? Thanks!

Yes, it fixs the contention as expected. So, feel free to add:

  Tested-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>


Thanks.

	--yliu
> 
> 								Honza
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR

> >From ee5a1b87e267a8ae8935952c3c6971fa6cc41c63 Mon Sep 17 00:00:00 2001
> From: Jan Kara <jack@suse.cz>
> Date: Tue, 16 Sep 2014 12:25:20 +0200
> Subject: [PATCH 1/2] jbd2: Avoid pointless scanning of checkpoint lists
> 
> Yuanhan has reported that when he is running fsync(2) heavy workload
> creating new files over ramdisk, significant amount of time is spent in
> __jbd2_journal_clean_checkpoint_list() trying to clean old transactions
> (but they cannot be cleaned up because flusher hasn't yet checkpointed
> those buffers).
> 
> Reduce the amount of scanning by stopping to scan the transaction list
> once we find a transaction that cannot be checkpointed. Note that this
> way of cleaning is still enough to keep freeing space in the journal
> after fully checkpointed transactions.
> 
> Reported-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/jbd2/checkpoint.c | 32 ++++++++++++++++++--------------
>  1 file changed, 18 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
> index 7f34f4716165..e39b2d0e1079 100644
> --- a/fs/jbd2/checkpoint.c
> +++ b/fs/jbd2/checkpoint.c
> @@ -478,7 +478,6 @@ int jbd2_cleanup_journal_tail(journal_t *journal)
>   * Find all the written-back checkpoint buffers in the given list and
>   * release them.
>   *
> - * Called with the journal locked.
>   * Called with j_list_lock held.
>   * Returns number of buffers reaped (for debug)
>   */
> @@ -498,12 +497,12 @@ static int journal_clean_one_cp_list(struct journal_head *jh, int *released)
>  		jh = next_jh;
>  		next_jh = jh->b_cpnext;
>  		ret = __try_to_free_cp_buf(jh);
> -		if (ret) {
> -			freed++;
> -			if (ret == 2) {
> -				*released = 1;
> -				return freed;
> -			}
> +		if (!ret)
> +			return freed;
> +		freed++;
> +		if (ret == 2) {
> +			*released = 1;
> +			return freed;
>  		}
>  		/*
>  		 * This function only frees up some memory
> @@ -523,7 +522,6 @@ static int journal_clean_one_cp_list(struct journal_head *jh, int *released)
>   *
>   * Find all the written-back checkpoint buffers in the journal and release them.
>   *
> - * Called with the journal locked.
>   * Called with j_list_lock held.
>   * Returns number of buffers reaped (for debug)
>   */
> @@ -531,7 +529,8 @@ static int journal_clean_one_cp_list(struct journal_head *jh, int *released)
>  int __jbd2_journal_clean_checkpoint_list(journal_t *journal)
>  {
>  	transaction_t *transaction, *last_transaction, *next_transaction;
> -	int ret = 0;
> +	int ret;
> +	int freed = 0;
>  	int released;
>  
>  	transaction = journal->j_checkpoint_transactions;
> @@ -543,17 +542,21 @@ int __jbd2_journal_clean_checkpoint_list(journal_t *journal)
>  	do {
>  		transaction = next_transaction;
>  		next_transaction = transaction->t_cpnext;
> -		ret += journal_clean_one_cp_list(transaction->
> +		ret = journal_clean_one_cp_list(transaction->
>  				t_checkpoint_list, &released);
>  		/*
>  		 * This function only frees up some memory if possible so we
>  		 * dont have an obligation to finish processing. Bail out if
>  		 * preemption requested:
>  		 */
> -		if (need_resched())
> +		if (need_resched()) {
> +			freed += ret;
>  			goto out;
> -		if (released)
> +		}
> +		if (released) {
> +			freed += ret;
>  			continue;
> +		}
>  		/*
>  		 * It is essential that we are as careful as in the case of
>  		 * t_checkpoint_list with removing the buffer from the list as
> @@ -561,11 +564,12 @@ int __jbd2_journal_clean_checkpoint_list(journal_t *journal)
>  		 */
>  		ret += journal_clean_one_cp_list(transaction->
>  				t_checkpoint_io_list, &released);
> -		if (need_resched())
> +		freed += ret;
> +		if (need_resched() || !ret)
>  			goto out;
>  	} while (transaction != last_transaction);
>  out:
> -	return ret;
> +	return freed;
>  }
>  
>  /*
> -- 
> 1.8.1.4
> 

> >From 8e17e25b044489429ef27433ee83066950a202b3 Mon Sep 17 00:00:00 2001
> From: Jan Kara <jack@suse.cz>
> Date: Tue, 16 Sep 2014 12:46:34 +0200
> Subject: [PATCH 2/2] jbd2: Simplify calling convention around
>  __jbd2_journal_clean_checkpoint_list
> 
> __jbd2_journal_clean_checkpoint_list() returns number of buffers it
> freed but noone was using the value so just stop doing that. This
> also allows for simplifying the calling convention for
> journal_clean_once_cp_list().
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/jbd2/checkpoint.c | 56 ++++++++++++++++++++++------------------------------
>  include/linux/jbd2.h |  2 +-
>  2 files changed, 25 insertions(+), 33 deletions(-)
> 
> diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
> index e39b2d0e1079..ef23d6f4a6a2 100644
> --- a/fs/jbd2/checkpoint.c
> +++ b/fs/jbd2/checkpoint.c
> @@ -479,16 +479,15 @@ int jbd2_cleanup_journal_tail(journal_t *journal)
>   * release them.
>   *
>   * Called with j_list_lock held.
> - * Returns number of buffers reaped (for debug)
> + * Returns 1 if we freed the transaction, 0 otherwise.
>   */
> -
> -static int journal_clean_one_cp_list(struct journal_head *jh, int *released)
> +static int journal_clean_one_cp_list(struct journal_head *jh)
>  {
>  	struct journal_head *last_jh;
>  	struct journal_head *next_jh = jh;
> -	int ret, freed = 0;
> +	int ret;
> +	int freed = 0;
>  
> -	*released = 0;
>  	if (!jh)
>  		return 0;
>  
> @@ -499,11 +498,9 @@ static int journal_clean_one_cp_list(struct journal_head *jh, int *released)
>  		ret = __try_to_free_cp_buf(jh);
>  		if (!ret)
>  			return freed;
> -		freed++;
> -		if (ret == 2) {
> -			*released = 1;
> -			return freed;
> -		}
> +		if (ret == 2)
> +			return 1;
> +		freed = 1;
>  		/*
>  		 * This function only frees up some memory
>  		 * if possible so we dont have an obligation
> @@ -523,53 +520,48 @@ static int journal_clean_one_cp_list(struct journal_head *jh, int *released)
>   * Find all the written-back checkpoint buffers in the journal and release them.
>   *
>   * Called with j_list_lock held.
> - * Returns number of buffers reaped (for debug)
>   */
> -
> -int __jbd2_journal_clean_checkpoint_list(journal_t *journal)
> +void __jbd2_journal_clean_checkpoint_list(journal_t *journal)
>  {
>  	transaction_t *transaction, *last_transaction, *next_transaction;
>  	int ret;
> -	int freed = 0;
> -	int released;
>  
>  	transaction = journal->j_checkpoint_transactions;
>  	if (!transaction)
> -		goto out;
> +		return;
>  
>  	last_transaction = transaction->t_cpprev;
>  	next_transaction = transaction;
>  	do {
>  		transaction = next_transaction;
>  		next_transaction = transaction->t_cpnext;
> -		ret = journal_clean_one_cp_list(transaction->
> -				t_checkpoint_list, &released);
> +		ret = journal_clean_one_cp_list(transaction->t_checkpoint_list);
>  		/*
>  		 * This function only frees up some memory if possible so we
>  		 * dont have an obligation to finish processing. Bail out if
>  		 * preemption requested:
>  		 */
> -		if (need_resched()) {
> -			freed += ret;
> -			goto out;
> -		}
> -		if (released) {
> -			freed += ret;
> +		if (need_resched())
> +			return;
> +		if (ret)
>  			continue;
> -		}
>  		/*
>  		 * It is essential that we are as careful as in the case of
>  		 * t_checkpoint_list with removing the buffer from the list as
>  		 * we can possibly see not yet submitted buffers on io_list
>  		 */
> -		ret += journal_clean_one_cp_list(transaction->
> -				t_checkpoint_io_list, &released);
> -		freed += ret;
> -		if (need_resched() || !ret)
> -			goto out;
> +		ret = journal_clean_one_cp_list(transaction->
> +				t_checkpoint_io_list);
> +		if (need_resched())
> +			return;
> +		/*
> +		 * Stop scanning if we couldn't free the transaction. This
> +		 * avoids pointless scanning of transactions which still
> +		 * weren't checkpointed.
> +		 */
> + 		if (!ret)
> +			return;
>  	} while (transaction != last_transaction);
> -out:
> -	return freed;
>  }
>  
>  /*
> diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
> index 0dae71e9971c..704b9a599b26 100644
> --- a/include/linux/jbd2.h
> +++ b/include/linux/jbd2.h
> @@ -1042,7 +1042,7 @@ void jbd2_update_log_tail(journal_t *journal, tid_t tid, unsigned long block);
>  extern void jbd2_journal_commit_transaction(journal_t *);
>  
>  /* Checkpoint list management */
> -int __jbd2_journal_clean_checkpoint_list(journal_t *journal);
> +void __jbd2_journal_clean_checkpoint_list(journal_t *journal);
>  int __jbd2_journal_remove_checkpoint(struct journal_head *);
>  void __jbd2_journal_insert_checkpoint(struct journal_head *, transaction_t *);
>  
> -- 
> 1.8.1.4
> 

