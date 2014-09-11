From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd2: remove __jbd2_journal_clean_checkpoint_list to
 solve scalability issue
Date: Thu, 11 Sep 2014 15:51:47 +0200
Message-ID: <20140911135147.GD30901@quack.suse.cz>
References: <1410430193-6112-1-git-send-email-yuanhan.liu@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36120 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306AbaIKNvu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Sep 2014 09:51:50 -0400
Content-Disposition: inline
In-Reply-To: <1410430193-6112-1-git-send-email-yuanhan.liu@linux.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 11-09-14 18:09:53, Yuanhan Liu wrote:
> Firstly, if I read the code correctly(I have a feeling I missed something),
> __jbd2_journal_clean_checkpoint_list is not necessary. jbd2_log_do_checkpoint
> will remove them for the checkpointed transaction. In another word,
> __jbd2_journal_clean_checkpoint_list can't drop an transaction if it's not
> checkpointed.
  Yes, that's correct. __jbd2_journal_clean_checkpoint_list() is there only
to free up buffers that were already checkpointed.
 
> Secondly, I noticed severe scalability limit caused by this function with fsmark:
>    $ fs_mark  -d  /fs/ram0/1  -D  2  -N  2560  -n  1000000  -L  1  -S  1  -s  4096
> 
> It mainly writes tons of small files, each with 4K, and calls fsync after
> each write. It's one thread only, and it's tested on a 32G memory disk(brd).
> 
> "perf top" shows that journal_clean_one_cp_list() is very hot, like 40%.
> However, that function is quite cheap, actually. But __jbd2_journal_clean_checkpoint_list()
> will repeatedly call it for each transaction on the j_checkpoint_transactions.
> The list becomes longer and longer in linear with time. It soon grows to
> a list with 3,000 and more transactions. What's worse, we will iterate all
> those transactions on this list every time before committing a transaction,
> aka, fsync a file in our case.
  OK, this is kind of a pathological workload (generating lots of tiny
transactions) but it's not insane. I'd also note that we should eventually
reach a steady state once the journal fills up and we will be forced to
checkpoint transactions from the journal to make space for new ones.
However at that point we will have few thousands of transactions in the
journal and I agree it takes a while to scan them in
__jbd2_journal_clean_checkpoint_list().

I'm not yet convinced that just dropping
__jbd2_journal_clean_checkpoint_list() is the right thing to do. Some
periodic cleaning of checkpointed entries would seem reasonable so that we
don't save all that work for the moment we run out of space in the journal.
I'll think how to do that in a more efficient way...

								Honza

> So, that's roughly the reason why journal_clean_one_cp_list() is hot. However,
> I'm wondering why the j_checkpoint_transactions list keeps growing. Is there
> a bug? I did more investigates, and I guess I found the root cause.
> 
> In this case, we invoke fsync after each write, so, it basically means one
> transaction for one file. One transaction normally contains few blocks of meta
> data, like bitmap, inode and so on. All files in same group shares one bitmap
> block. But one inode table block could contains 16 files. Hence, it's possible
> that 2 different file points to same meta blocks.
> 
> For example, if file A and B uses same meta blocks, and if we write A and B in
> following style:
>         write(A);
>         fsync(A);
> 
>         write(B);
>         fsync(B);
> 
> then, when we are about to commit transation for B, and assume transaction of A
> is not checkpointted yet, we can safely drop transaction A and replace it with
> transaction B. Hence, the j_checkpoint_transactions grows by 1 only.
> 
> And then assume A is the last inode in one inode block, hence, B will use another
> inode table block. Thus transaction A and B is different. Hence, both A and B are
> inserted to the j_checkpoint_transactions; the list grows by 2.
> 
> Here I also got the proves; I added a trace point in jbd2_log_do_checkpoint(),
> and here are some of them:
> 
>          fs_mark-2646  [000] ....     5.830990: jbd2_start_checkpoint: tid=20
>          fs_mark-2646  [000] ....     5.832391: jbd2_start_checkpoint: tid=36
>          fs_mark-2646  [000] ....     5.833794: jbd2_start_checkpoint: tid=52
>          fs_mark-2646  [000] ....     5.835153: jbd2_start_checkpoint: tid=68
>          fs_mark-2646  [000] ....     5.836517: jbd2_start_checkpoint: tid=84
>          fs_mark-2646  [000] ....     5.837982: jbd2_start_checkpoint: tid=100
>          fs_mark-2646  [000] ....     5.839464: jbd2_start_checkpoint: tid=116
>          fs_mark-2646  [000] ....     5.840820: jbd2_start_checkpoint: tid=132
> 
> As you can see, the tid jumps by 16 each time, and other transactions are just
> replaced by the way I described above.
> 
> Step by step like above, that list grows. And that's why journal_clean_one_cp_list() is hot.
> 
> It removes the scalability issue when I removed this function, and the fsmark
> result(Files/sec) jumps from 9000 to 16000, which is an increase about 80%.
> 
> Thoughts?
> 
> CC: Andi Kleen <ak@linux.intel.com>
> Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
> ---
>  fs/jbd2/checkpoint.c | 115 ---------------------------------------------------
>  fs/jbd2/commit.c     |   9 ----
>  include/linux/jbd2.h |   1 -
>  3 files changed, 125 deletions(-)
> 
> diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
> index 9ffb19c..31fce78 100644
> --- a/fs/jbd2/checkpoint.c
> +++ b/fs/jbd2/checkpoint.c
> @@ -83,26 +83,6 @@ static inline void __buffer_relink_io(struct journal_head *jh)
>  }
>  
>  /*
> - * Try to release a checkpointed buffer from its transaction.
> - * Returns 1 if we released it and 2 if we also released the
> - * whole transaction.
> - *
> - * Requires j_list_lock
> - */
> -static int __try_to_free_cp_buf(struct journal_head *jh)
> -{
> -	int ret = 0;
> -	struct buffer_head *bh = jh2bh(jh);
> -
> -	if (jh->b_transaction == NULL && !buffer_locked(bh) &&
> -	    !buffer_dirty(bh) && !buffer_write_io_error(bh)) {
> -		JBUFFER_TRACE(jh, "remove from checkpoint list");
> -		ret = __jbd2_journal_remove_checkpoint(jh) + 1;
> -	}
> -	return ret;
> -}
> -
> -/*
>   * __jbd2_log_wait_for_space: wait until there is space in the journal.
>   *
>   * Called under j-state_lock *only*.  It will be unlocked if we have to wait
> @@ -412,101 +392,6 @@ int jbd2_cleanup_journal_tail(journal_t *journal)
>  
>  /* Checkpoint list management */
>  
> -/*
> - * journal_clean_one_cp_list
> - *
> - * Find all the written-back checkpoint buffers in the given list and
> - * release them.
> - *
> - * Called with the journal locked.
> - * Called with j_list_lock held.
> - * Returns number of buffers reaped (for debug)
> - */
> -
> -static int journal_clean_one_cp_list(struct journal_head *jh, int *released)
> -{
> -	struct journal_head *last_jh;
> -	struct journal_head *next_jh = jh;
> -	int ret, freed = 0;
> -
> -	*released = 0;
> -	if (!jh)
> -		return 0;
> -
> -	last_jh = jh->b_cpprev;
> -	do {
> -		jh = next_jh;
> -		next_jh = jh->b_cpnext;
> -		ret = __try_to_free_cp_buf(jh);
> -		if (ret) {
> -			freed++;
> -			if (ret == 2) {
> -				*released = 1;
> -				return freed;
> -			}
> -		}
> -		/*
> -		 * This function only frees up some memory
> -		 * if possible so we dont have an obligation
> -		 * to finish processing. Bail out if preemption
> -		 * requested:
> -		 */
> -		if (need_resched())
> -			return freed;
> -	} while (jh != last_jh);
> -
> -	return freed;
> -}
> -
> -/*
> - * journal_clean_checkpoint_list
> - *
> - * Find all the written-back checkpoint buffers in the journal and release them.
> - *
> - * Called with the journal locked.
> - * Called with j_list_lock held.
> - * Returns number of buffers reaped (for debug)
> - */
> -
> -int __jbd2_journal_clean_checkpoint_list(journal_t *journal)
> -{
> -	transaction_t *transaction, *last_transaction, *next_transaction;
> -	int ret = 0;
> -	int released;
> -
> -	transaction = journal->j_checkpoint_transactions;
> -	if (!transaction)
> -		goto out;
> -
> -	last_transaction = transaction->t_cpprev;
> -	next_transaction = transaction;
> -	do {
> -		transaction = next_transaction;
> -		next_transaction = transaction->t_cpnext;
> -		ret += journal_clean_one_cp_list(transaction->
> -				t_checkpoint_list, &released);
> -		/*
> -		 * This function only frees up some memory if possible so we
> -		 * dont have an obligation to finish processing. Bail out if
> -		 * preemption requested:
> -		 */
> -		if (need_resched())
> -			goto out;
> -		if (released)
> -			continue;
> -		/*
> -		 * It is essential that we are as careful as in the case of
> -		 * t_checkpoint_list with removing the buffer from the list as
> -		 * we can possibly see not yet submitted buffers on io_list
> -		 */
> -		ret += journal_clean_one_cp_list(transaction->
> -				t_checkpoint_io_list, &released);
> -		if (need_resched())
> -			goto out;
> -	} while (transaction != last_transaction);
> -out:
> -	return ret;
> -}
>  
>  /*
>   * journal_remove_checkpoint: called after a buffer has been committed
> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> index b73e021..1ebdd70 100644
> --- a/fs/jbd2/commit.c
> +++ b/fs/jbd2/commit.c
> @@ -504,15 +504,6 @@ void jbd2_journal_commit_transaction(journal_t *journal)
>  		jbd2_journal_refile_buffer(journal, jh);
>  	}
>  
> -	/*
> -	 * Now try to drop any written-back buffers from the journal's
> -	 * checkpoint lists.  We do this *before* commit because it potentially
> -	 * frees some memory
> -	 */
> -	spin_lock(&journal->j_list_lock);
> -	__jbd2_journal_clean_checkpoint_list(journal);
> -	spin_unlock(&journal->j_list_lock);
> -
>  	jbd_debug(3, "JBD2: commit phase 1\n");
>  
>  	/*
> diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
> index 0dae71e..c41ab38 100644
> --- a/include/linux/jbd2.h
> +++ b/include/linux/jbd2.h
> @@ -1042,7 +1042,6 @@ void jbd2_update_log_tail(journal_t *journal, tid_t tid, unsigned long block);
>  extern void jbd2_journal_commit_transaction(journal_t *);
>  
>  /* Checkpoint list management */
> -int __jbd2_journal_clean_checkpoint_list(journal_t *journal);
>  int __jbd2_journal_remove_checkpoint(struct journal_head *);
>  void __jbd2_journal_insert_checkpoint(struct journal_head *, transaction_t *);
>  
> -- 
> 1.9.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
