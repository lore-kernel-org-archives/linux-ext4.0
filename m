From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 1/2] jbd: Provide function to check whether transaction will issue data barrier
Date: Tue, 27 Apr 2010 07:42:49 +0400
Message-ID: <87eii1d0hy.fsf@openvz.org>
References: <1272312659-16468-1-git-send-email-jack@suse.cz>
	<1272312659-16468-2-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:56544 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027Ab0D0Dmy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Apr 2010 23:42:54 -0400
Received: by bwz19 with SMTP id 19so109817bwz.21
        for <linux-ext4@vger.kernel.org>; Mon, 26 Apr 2010 20:42:52 -0700 (PDT)
In-Reply-To: <1272312659-16468-2-git-send-email-jack@suse.cz> (Jan Kara's
	message of "Mon, 26 Apr 2010 22:10:58 +0200")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Kara <jack@suse.cz> writes:

> Provide a function which returns whether a transaction with given tid
> will send a barrier to the filesystem device. The function will be used
> by ext3 to detect whether fsync needs to send a separate barrier or not.
Agree. Except the fact that in case of j_dev != j_fs_dev jbd is still
broken. I'm plan to post back-port from jbd2 which makes
journal_trans_will_send_data_barrier() more complex. It have to analyze
commit_transaction->t_flushed_data_blocks.
>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/jbd/commit.c     |    8 +++++++-
>  fs/jbd/journal.c    |   33 +++++++++++++++++++++++++++++++++
>  include/linux/jbd.h |    3 ++-
>  3 files changed, 42 insertions(+), 2 deletions(-)
>
> diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
> index ecb44c9..28a9dda 100644
> --- a/fs/jbd/commit.c
> +++ b/fs/jbd/commit.c
> @@ -786,6 +786,12 @@ wait_for_iobuf:
>  
>  	jbd_debug(3, "JBD: commit phase 6\n");
>  
> +	/* All metadata is written, now write commit record and do cleanup */
> +	spin_lock(&journal->j_state_lock);
> +	J_ASSERT(commit_transaction->t_state == T_COMMIT);
> +	commit_transaction->t_state = T_COMMIT_RECORD;
> +	spin_unlock(&journal->j_state_lock);
> +
>  	if (journal_write_commit_record(journal, commit_transaction))
>  		err = -EIO;
>  
> @@ -923,7 +929,7 @@ restart_loop:
>  
>  	jbd_debug(3, "JBD: commit phase 8\n");
>  
> -	J_ASSERT(commit_transaction->t_state == T_COMMIT);
> +	J_ASSERT(commit_transaction->t_state == T_COMMIT_RECORD);
>  
>  	commit_transaction->t_state = T_FINISHED;
>  	J_ASSERT(commit_transaction == journal->j_committing_transaction);
> diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
> index bd224ee..99c7194 100644
> --- a/fs/jbd/journal.c
> +++ b/fs/jbd/journal.c
> @@ -565,6 +565,38 @@ int log_wait_commit(journal_t *journal, tid_t tid)
>  }
>  
>  /*
> + * Return 1 if a given transaction has not yet sent barrier request
> + * connected with a transaction commit. If 0 is returned, transaction
> + * may or may not have sent the barrier. Used to avoid sending barrier
> + * twice in common cases.
> + */
> +int journal_trans_will_send_data_barrier(journal_t *journal, tid_t tid)
> +{
> +	int ret = 0;
> +	transaction_t *commit_trans;
> +
> +	if (!(journal->j_flags & JFS_BARRIER))
> +		return 0;
> +	spin_lock(&journal->j_state_lock);
> +	/* Transaction already committed? */
> +	if (tid_geq(journal->j_commit_sequence, tid))
> +		goto out;
> +	/*
> +	 * Transaction is being committed and we already proceeded to
> +	 * writing commit record?
> +	 */
> +	commit_trans = journal->j_committing_transaction;
> +	if (commit_trans && commit_trans->t_tid == tid &&
> +	    commit_trans->t_state >= T_COMMIT_RECORD)
> +		goto out;
> +	ret = 1;
> +out:
> +	spin_unlock(&journal->j_state_lock);
> +	return ret;
> +}
> +EXPORT_SYMBOL(journal_commit_will_send_barrier);
> +
> +/*
>   * Log buffer allocation routines:
>   */
>  
> @@ -1157,6 +1189,7 @@ int journal_destroy(journal_t *journal)
>  {
>  	int err = 0;
>  
> +	
>  	/* Wait for the commit thread to wake up and die. */
>  	journal_kill_thread(journal);
>  
> diff --git a/include/linux/jbd.h b/include/linux/jbd.h
> index 516a2a2..e069650 100644
> --- a/include/linux/jbd.h
> +++ b/include/linux/jbd.h
> @@ -427,9 +427,9 @@ struct transaction_s
>  	enum {
>  		T_RUNNING,
>  		T_LOCKED,
> -		T_RUNDOWN,
>  		T_FLUSH,
>  		T_COMMIT,
> +		T_COMMIT_RECORD,
>  		T_FINISHED
>  	}			t_state;
>  
> @@ -991,6 +991,7 @@ int journal_start_commit(journal_t *journal, tid_t *tid);
>  int journal_force_commit_nested(journal_t *journal);
>  int log_wait_commit(journal_t *journal, tid_t tid);
>  int log_do_checkpoint(journal_t *journal);
> +int journal_trans_will_send_data_barrier(journal_t *journal, tid_t tid);
>  
>  void __log_wait_for_space(journal_t *journal);
>  extern void	__journal_drop_transaction(journal_t *, transaction_t *);
