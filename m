From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 12/29] jbd2: Transaction reservation support
Date: Sun, 5 May 2013 17:39:39 +0800
Message-ID: <20130505093939.GA27346@gmail.com>
References: <1365456754-29373-1-git-send-email-jack@suse.cz>
 <1365456754-29373-13-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:50538 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab3EEJWD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 5 May 2013 05:22:03 -0400
Received: by mail-pa0-f52.google.com with SMTP id bg2so1571251pad.11
        for <linux-ext4@vger.kernel.org>; Sun, 05 May 2013 02:22:01 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1365456754-29373-13-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 08, 2013 at 11:32:17PM +0200, Jan Kara wrote:
> In some cases we cannot start a transaction because of locking constraints and
> passing started transaction into those places is not handy either because we
> could block transaction commit for too long. Transaction reservation is
> designed to solve these issues. It reserves a handle with given number of
> credits in the journal and the handle can be later attached to the running
> transaction without blocking on commit or checkpointing. Reserved handles do
> not block transaction commit in any way, they only reduce maximum size of the
> running transaction (because we have to always be prepared to accomodate
> request for attaching reserved handle).
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Some minor nits below.  Otherwise the patch looks good to me.
Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>

> ---
>  fs/jbd2/commit.c      |    6 +
>  fs/jbd2/journal.c     |    2 +
>  fs/jbd2/transaction.c |  289 +++++++++++++++++++++++++++++++++++++------------
>  include/linux/jbd2.h  |   21 ++++-
>  4 files changed, 245 insertions(+), 73 deletions(-)
> 
> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> index 4863f5b..59c572e 100644
> --- a/fs/jbd2/commit.c
> +++ b/fs/jbd2/commit.c
> @@ -522,6 +522,12 @@ void jbd2_journal_commit_transaction(journal_t *journal)
>  	 */
>  	jbd2_journal_switch_revoke_table(journal);
>  
> +	/*
> +	 * Reserved credits cannot be claimed anymore, free them
> +	 */
> +	atomic_sub(atomic_read(&journal->j_reserved_credits),
> +		   &commit_transaction->t_outstanding_credits);
> +
>  	trace_jbd2_commit_flushing(journal, commit_transaction);
>  	stats.run.rs_flushing = jiffies;
>  	stats.run.rs_locked = jbd2_time_diff(stats.run.rs_locked,
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 63e2929..04c52ac 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -1001,6 +1001,7 @@ static journal_t * journal_init_common (void)
>  	init_waitqueue_head(&journal->j_wait_done_commit);
>  	init_waitqueue_head(&journal->j_wait_commit);
>  	init_waitqueue_head(&journal->j_wait_updates);
> +	init_waitqueue_head(&journal->j_wait_reserved);
>  	mutex_init(&journal->j_barrier);
>  	mutex_init(&journal->j_checkpoint_mutex);
>  	spin_lock_init(&journal->j_revoke_lock);
> @@ -1010,6 +1011,7 @@ static journal_t * journal_init_common (void)
>  	journal->j_commit_interval = (HZ * JBD2_DEFAULT_MAX_COMMIT_AGE);
>  	journal->j_min_batch_time = 0;
>  	journal->j_max_batch_time = 15000; /* 15ms */
> +	atomic_set(&journal->j_reserved_credits, 0);
>  
>  	/* The journal is marked for error until we succeed with recovery! */
>  	journal->j_flags = JBD2_ABORT;
> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> index 9639e47..036c01c 100644
> --- a/fs/jbd2/transaction.c
> +++ b/fs/jbd2/transaction.c
> @@ -89,7 +89,8 @@ jbd2_get_transaction(journal_t *journal, transaction_t *transaction)
>  	transaction->t_expires = jiffies + journal->j_commit_interval;
>  	spin_lock_init(&transaction->t_handle_lock);
>  	atomic_set(&transaction->t_updates, 0);
> -	atomic_set(&transaction->t_outstanding_credits, 0);
> +	atomic_set(&transaction->t_outstanding_credits,
> +		   atomic_read(&journal->j_reserved_credits));
>  	atomic_set(&transaction->t_handle_count, 0);
>  	INIT_LIST_HEAD(&transaction->t_inode_list);
>  	INIT_LIST_HEAD(&transaction->t_private_list);
> @@ -141,6 +142,91 @@ static inline void update_t_max_wait(transaction_t *transaction,
>  }
>  
>  /*
> + * Wait until running transaction passes T_LOCKED state. Also starts the commit
> + * if needed. The function expects running transaction to exist and releases
> + * j_state_lock.
> + */
> +static void wait_transaction_locked(journal_t *journal)
> +	__releases(journal->j_state_lock)
> +{
> +	DEFINE_WAIT(wait);
> +	int need_to_start;
> +	tid_t tid = journal->j_running_transaction->t_tid;
> +
> +	prepare_to_wait(&journal->j_wait_transaction_locked, &wait,
> +			TASK_UNINTERRUPTIBLE);
> +	need_to_start = !tid_geq(journal->j_commit_request, tid);
> +	read_unlock(&journal->j_state_lock);
> +	if (need_to_start)
> +		jbd2_log_start_commit(journal, tid);
> +	schedule();
> +	finish_wait(&journal->j_wait_transaction_locked, &wait);
> +}
> +
> +/*
> + * Wait until we can add credits for handle to the running transaction.  Called
> + * with j_state_lock held for reading. Returns 0 if handle joined the running
> + * transaction. Returns 1 if we had to wait, j_state_lock is dropped, and
> + * caller must retry.
> + */
> +static int add_transaction_credits(journal_t *journal, handle_t *handle)
> +{
> +	transaction_t *t = journal->j_running_transaction;
> +	int nblocks = handle->h_buffer_credits;
> +	int needed;
> +
> +	/*
> +	 * If the current transaction is locked down for commit, wait
> +	 * for the lock to be released.
> +	 */
> +	if (t->t_state == T_LOCKED) {
> +		wait_transaction_locked(journal);
> +		return 1;
> +	}
> +
> +	/*
> +	 * If there is not enough space left in the log to write all
> +	 * potential buffers requested by this operation, we need to
> +	 * stall pending a log checkpoint to free some more log space.
> +	 */
> +	needed = atomic_add_return(nblocks, &t->t_outstanding_credits);
> +	if (needed > journal->j_max_transaction_buffers) {
> +		/*
> +		 * If the current transaction is already too large,
> +		 * then start to commit it: we can then go back and
> +		 * attach this handle to a new transaction.
> +		 */
> +		jbd_debug(2, "Handle %p starting new commit...\n", handle);
> +		atomic_sub(nblocks, &t->t_outstanding_credits);
> +		wait_transaction_locked(journal);
> +		return 1;
> +	}
> +
> +	/*
> +	 * The commit code assumes that it can get enough log space
> +	 * without forcing a checkpoint.  This is *critical* for
> +	 * correctness: a checkpoint of a buffer which is also
> +	 * associated with a committing transaction creates a deadlock,
> +	 * so commit simply cannot force through checkpoints.
> +	 *
> +	 * We must therefore ensure the necessary space in the journal
> +	 * *before* starting to dirty potentially checkpointed buffers
> +	 * in the new transaction.
> +	 */
> +	if (jbd2_log_space_left(journal) < jbd2_space_needed(journal)) {
> +		jbd_debug(2, "Handle %p waiting for checkpoint...\n", handle);
> +		atomic_sub(nblocks, &t->t_outstanding_credits);
> +		read_unlock(&journal->j_state_lock);
> +		write_lock(&journal->j_state_lock);
> +		if (jbd2_log_space_left(journal) < jbd2_space_needed(journal))
> +			__jbd2_log_wait_for_space(journal);
> +		write_unlock(&journal->j_state_lock);
> +		return 1;
> +	}
> +	return 0;
> +}
> +
> +/*
>   * start_this_handle: Given a handle, deal with any locking or stalling
>   * needed to make sure that there is enough journal space for the handle
>   * to begin.  Attach the handle to a transaction and set up the
> @@ -151,12 +237,14 @@ static int start_this_handle(journal_t *journal, handle_t *handle,
>  			     gfp_t gfp_mask)
>  {
>  	transaction_t	*transaction, *new_transaction = NULL;
> -	tid_t		tid;
> -	int		needed, need_to_start;
>  	int		nblocks = handle->h_buffer_credits;
>  	unsigned long ts = jiffies;
>  
> -	if (nblocks > journal->j_max_transaction_buffers) {
> +	/*
> +	 * 1/2 of transaction can be reserved so we can practically handle
> +	 * only 1/2 of maximum transaction size per operation
> +	 */

Sorry, but I don't understand here why we only reserve 1/2 of maximum
transaction size.

> +	if (nblocks > journal->j_max_transaction_buffers / 2) {
>  		printk(KERN_ERR "JBD2: %s wants too many credits (%d > %d)\n",
>  		       current->comm, nblocks,
>  		       journal->j_max_transaction_buffers);
> @@ -223,75 +311,18 @@ repeat:
>  
>  	transaction = journal->j_running_transaction;
>  
> -	/*
> -	 * If the current transaction is locked down for commit, wait for the
> -	 * lock to be released.
> -	 */
> -	if (transaction->t_state == T_LOCKED) {
> -		DEFINE_WAIT(wait);
> -
> -		prepare_to_wait(&journal->j_wait_transaction_locked,
> -					&wait, TASK_UNINTERRUPTIBLE);
> -		read_unlock(&journal->j_state_lock);
> -		schedule();
> -		finish_wait(&journal->j_wait_transaction_locked, &wait);
> -		goto repeat;
> -	}
> -
> -	/*
> -	 * If there is not enough space left in the log to write all potential
> -	 * buffers requested by this operation, we need to stall pending a log
> -	 * checkpoint to free some more log space.
> -	 */
> -	needed = atomic_add_return(nblocks,
> -				   &transaction->t_outstanding_credits);
> -
> -	if (needed > journal->j_max_transaction_buffers) {
> +	if (!handle->h_reserved) {

Maybe we need to add a comment here because we release j_state_lock in
add_transaction_credits.

Regards,
                                                - Zheng

> +		if (add_transaction_credits(journal, handle))
> +			goto repeat;
> +	} else {
>  		/*
> -		 * If the current transaction is already too large, then start
> -		 * to commit it: we can then go back and attach this handle to
> -		 * a new transaction.
> +		 * We have handle reserved so we are allowed to join T_LOCKED
> +		 * transaction and we don't have to check for transaction size
> +		 * and journal space.
>  		 */
> -		DEFINE_WAIT(wait);
> -
> -		jbd_debug(2, "Handle %p starting new commit...\n", handle);
> -		atomic_sub(nblocks, &transaction->t_outstanding_credits);
> -		prepare_to_wait(&journal->j_wait_transaction_locked, &wait,
> -				TASK_UNINTERRUPTIBLE);
> -		tid = transaction->t_tid;
> -		need_to_start = !tid_geq(journal->j_commit_request, tid);
> -		read_unlock(&journal->j_state_lock);
> -		if (need_to_start)
> -			jbd2_log_start_commit(journal, tid);
> -		schedule();
> -		finish_wait(&journal->j_wait_transaction_locked, &wait);
> -		goto repeat;
> -	}
> -
> -	/*
> -	 * The commit code assumes that it can get enough log space
> -	 * without forcing a checkpoint.  This is *critical* for
> -	 * correctness: a checkpoint of a buffer which is also
> -	 * associated with a committing transaction creates a deadlock,
> -	 * so commit simply cannot force through checkpoints.
> -	 *
> -	 * We must therefore ensure the necessary space in the journal
> -	 * *before* starting to dirty potentially checkpointed buffers
> -	 * in the new transaction.
> -	 *
> -	 * The worst part is, any transaction currently committing can
> -	 * reduce the free space arbitrarily.  Be careful to account for
> -	 * those buffers when checkpointing.
> -	 */
> -	if (jbd2_log_space_left(journal) < jbd2_space_needed(journal)) {
> -		jbd_debug(2, "Handle %p waiting for checkpoint...\n", handle);
> -		atomic_sub(nblocks, &transaction->t_outstanding_credits);
> -		read_unlock(&journal->j_state_lock);
> -		write_lock(&journal->j_state_lock);
> -		if (jbd2_log_space_left(journal) < jbd2_space_needed(journal))
> -			__jbd2_log_wait_for_space(journal);
> -		write_unlock(&journal->j_state_lock);
> -		goto repeat;
> +		atomic_sub(nblocks, &journal->j_reserved_credits);
> +		wake_up(&journal->j_wait_reserved);
> +		handle->h_reserved = 0;
>  	}
>  
>  	/* OK, account for the buffers that this operation expects to
> @@ -390,6 +421,122 @@ handle_t *jbd2_journal_start(journal_t *journal, int nblocks)
>  }
>  EXPORT_SYMBOL(jbd2_journal_start);
>  
> +/**
> + * handle_t *jbd2_journal_reserve(journal_t *journal, int nblocks)
> + * @journal: journal to reserve transaction on.
> + * @nblocks: number of blocks we might modify
> + *
> + * This function reserves transaction with @nblocks blocks in @journal.  The
> + * function waits for enough journal space to be available and possibly also
> + * for some reservations to be converted to real transactions if there are too
> + * many of them. Note that this means that calling this function while having
> + * another transaction started or reserved can cause deadlock. The returned
> + * handle cannot be used for anything until it is started using
> + * jbd2_journal_start_reserved().
> + */
> +handle_t *jbd2_journal_reserve(journal_t *journal, int nblocks,
> +			       unsigned int type, unsigned int line_no)
> +{
> +	handle_t *handle;
> +	unsigned long wanted;
> +
> +	handle = new_handle(nblocks);
> +	if (!handle)
> +		return ERR_PTR(-ENOMEM);
> +	handle->h_journal = journal;
> +	handle->h_reserved = 1;
> +	handle->h_type = type;
> +	handle->h_line_no = line_no;
> +
> +repeat:
> +	/*
> +	 * We need j_state_lock early to avoid transaction creation to race
> +	 * with us and using elevated j_reserved_credits.
> +	 */
> +	read_lock(&journal->j_state_lock);
> +	wanted = atomic_add_return(nblocks, &journal->j_reserved_credits);
> +	/* We allow at most half of a transaction to be reserved */
> +	if (wanted > journal->j_max_transaction_buffers / 2) {
> +		atomic_sub(nblocks, &journal->j_reserved_credits);
> +		read_unlock(&journal->j_state_lock);
> +		wait_event(journal->j_wait_reserved,
> +			   atomic_read(&journal->j_reserved_credits) + nblocks
> +			   <= journal->j_max_transaction_buffers / 2);
> +		goto repeat;
> +	}
> +	if (journal->j_running_transaction) {
> +		transaction_t *t = journal->j_running_transaction;
> +
> +		wanted = atomic_add_return(nblocks,
> +					   &t->t_outstanding_credits);
> +		if (wanted > journal->j_max_transaction_buffers) {
> +			atomic_sub(nblocks, &t->t_outstanding_credits);
> +			atomic_sub(nblocks, &journal->j_reserved_credits);
> +			wait_transaction_locked(journal);
> +			goto repeat;
> +		}
> +	}
> +	read_unlock(&journal->j_state_lock);
> +
> +	return handle;
> +}
> +EXPORT_SYMBOL(jbd2_journal_reserve);
> +
> +void jbd2_journal_free_reserved(handle_t *handle)
> +{
> +	journal_t *journal = handle->h_journal;
> +
> +	atomic_sub(handle->h_buffer_credits, &journal->j_reserved_credits);
> +	wake_up(&journal->j_wait_reserved);
> +	jbd2_free_handle(handle);
> +}
> +EXPORT_SYMBOL(jbd2_journal_free_reserved);
> +
> +/**
> + * int jbd2_journal_start_reserved(handle_t *handle) - start reserved handle
> + * @handle: handle to start
> + *
> + * Start handle that has been previously reserved with jbd2_journal_reserve().
> + * This attaches @handle to the running transaction (or creates one if there's
> + * not transaction running). Unlike jbd2_journal_start() this function cannot
> + * block on journal commit, checkpointing, or similar stuff. It can block on
> + * memory allocation or frozen journal though.
> + *
> + * Return 0 on success, non-zero on error - handle is freed in that case.
> + */
> +int jbd2_journal_start_reserved(handle_t *handle)
> +{
> +	journal_t *journal = handle->h_journal;
> +	int ret = -EIO;
> +
> +	if (WARN_ON(!handle->h_reserved)) {
> +		/* Someone passed in normal handle? Just stop it. */
> +		jbd2_journal_stop(handle);
> +		return ret;
> +	}
> +	/*
> +	 * Usefulness of mixing of reserved and unreserved handles is
> +	 * questionable. So far nobody seems to need it so just error out.
> +	 */
> +	if (WARN_ON(current->journal_info)) {
> +		jbd2_journal_free_reserved(handle);
> +		return ret;
> +	}
> +
> +	handle->h_journal = NULL;
> +	current->journal_info = handle;
> +	/*
> +	 * GFP_NOFS is here because callers are likely from writeback or
> +	 * similarly constrained call sites
> +	 */
> +	ret = start_this_handle(journal, handle, GFP_NOFS);
> +	if (ret < 0) {
> +		current->journal_info = NULL;
> +		jbd2_journal_free_reserved(handle);
> +	}
> +	return ret;
> +}
> +EXPORT_SYMBOL(jbd2_journal_start_reserved);
>  
>  /**
>   * int jbd2_journal_extend() - extend buffer credits.
> diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
> index ad4b3bb..b3c1283 100644
> --- a/include/linux/jbd2.h
> +++ b/include/linux/jbd2.h
> @@ -410,8 +410,12 @@ struct jbd2_revoke_table_s;
>  
>  struct jbd2_journal_handle
>  {
> -	/* Which compound transaction is this update a part of? */
> -	transaction_t		*h_transaction;
> +	union {
> +		/* Which compound transaction is this update a part of? */
> +		transaction_t	*h_transaction;
> +		/* Which journal handle belongs to - used iff h_reserved set */
> +		journal_t	*h_journal;
> +	};
>  
>  	/* Number of remaining buffers we are allowed to dirty: */
>  	int			h_buffer_credits;
> @@ -426,6 +430,7 @@ struct jbd2_journal_handle
>  	/* Flags [no locking] */
>  	unsigned int	h_sync:		1;	/* sync-on-close */
>  	unsigned int	h_jdata:	1;	/* force data journaling */
> +	unsigned int	h_reserved:	1;	/* handle with reserved credits */
>  	unsigned int	h_aborted:	1;	/* fatal error on handle */
>  	unsigned int	h_type:		8;	/* for handle statistics */
>  	unsigned int	h_line_no:	16;	/* for handle statistics */
> @@ -689,6 +694,7 @@ jbd2_time_diff(unsigned long start, unsigned long end)
>   * @j_wait_done_commit: Wait queue for waiting for commit to complete
>   * @j_wait_commit: Wait queue to trigger commit
>   * @j_wait_updates: Wait queue to wait for updates to complete
> + * @j_wait_reserved: Wait queue to wait for reserved buffer credits to drop
>   * @j_checkpoint_mutex: Mutex for locking against concurrent checkpoints
>   * @j_head: Journal head - identifies the first unused block in the journal
>   * @j_tail: Journal tail - identifies the oldest still-used block in the
> @@ -702,6 +708,7 @@ jbd2_time_diff(unsigned long start, unsigned long end)
>   *     journal
>   * @j_fs_dev: Device which holds the client fs.  For internal journal this will
>   *     be equal to j_dev
> + * @j_reserved_credits: Number of buffers reserved from the running transaction
>   * @j_maxlen: Total maximum capacity of the journal region on disk.
>   * @j_list_lock: Protects the buffer lists and internal buffer state.
>   * @j_inode: Optional inode where we store the journal.  If present, all journal
> @@ -800,6 +807,9 @@ struct journal_s
>  	/* Wait queue to wait for updates to complete */
>  	wait_queue_head_t	j_wait_updates;
>  
> +	/* Wait queue to wait for reserved buffer credits to drop */
> +	wait_queue_head_t	j_wait_reserved;
> +
>  	/* Semaphore for locking against concurrent checkpoints */
>  	struct mutex		j_checkpoint_mutex;
>  
> @@ -854,6 +864,9 @@ struct journal_s
>  	/* Total maximum capacity of the journal region on disk. */
>  	unsigned int		j_maxlen;
>  
> +	/* Number of buffers reserved from the running transaction */
> +	atomic_t		j_reserved_credits;
> +
>  	/*
>  	 * Protects the buffer lists and internal buffer state.
>  	 */
> @@ -1094,6 +1107,10 @@ extern handle_t *jbd2__journal_start(journal_t *, int nblocks, gfp_t gfp_mask,
>  				     unsigned int type, unsigned int line_no);
>  extern int	 jbd2_journal_restart(handle_t *, int nblocks);
>  extern int	 jbd2__journal_restart(handle_t *, int nblocks, gfp_t gfp_mask);
> +extern handle_t *jbd2_journal_reserve(journal_t *, int nblocks,
> +				      unsigned int type, unsigned int line_no);
> +extern int	 jbd2_journal_start_reserved(handle_t *handle);
> +extern void	 jbd2_journal_free_reserved(handle_t *handle);
>  extern int	 jbd2_journal_extend (handle_t *, int nblocks);
>  extern int	 jbd2_journal_get_write_access(handle_t *, struct buffer_head *);
>  extern int	 jbd2_journal_get_create_access (handle_t *, struct buffer_head *);
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
