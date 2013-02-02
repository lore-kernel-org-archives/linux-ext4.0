From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 2/2] jbd2: commit as soon as possible after log_start_commit
Date: Sat, 2 Feb 2013 12:33:43 -0700
Message-ID: <6D3A8DA5-0101-4EC2-A317-CF3A6EF4248F@dilger.ca>
References: <20130130052658.GE25006@thunk.org> <1359524369-31234-1-git-send-email-tytso@mit.edu> <1359524369-31234-2-git-send-email-tytso@mit.edu>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Eric Sandeen <sandeen@redhat.com>,
	Sedat Dilek <sedat.dilek@gmail.com>, mszeredi@suse.cz
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:59602 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758065Ab3BBTdp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Feb 2013 14:33:45 -0500
Received: by mail-pb0-f41.google.com with SMTP id ro12so2628039pbb.28
        for <linux-ext4@vger.kernel.org>; Sat, 02 Feb 2013 11:33:45 -0800 (PST)
In-Reply-To: <1359524369-31234-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2013-01-29, at 10:39 PM, Theodore Ts'o wrote:
> Once a transaction has been requested to be committed, don't let any
> other handles start under that transaction, and don't allow any
> pending transactions to be extended (i.e., in the case of
> unlink/ftruncate).
> 
> The idea is once the transaction has had log_start_commit() called on
> it, at least one thread is blocked waiting for that transaction to
> commit, and over time, more and more threads will end up getting
> blocked.  In order to avoid high variability in file system operations
> getting blocked behind the a blocked start_this_handle(), we should
> try to get the commit started as soon as possible.

I was thinking this could break transaction batching from multiple
threads, which would hurt performance significantly in a multi-
threaded sync-heavy workload.

However, it seems that jbd2_journal_stop() blocks the h_sync thread
before it calls jbd2_log_start_commit(), so it looks like it should
be OK.

You can add my:

Acked-by: Andreas Dilger <adilger@dilger.ca>

> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Eric Sandeen <sandeen@redhat.com>
> Cc: Sedat Dilek <sedat.dilek@gmail.com>
> Cc: mszeredi@suse.cz
> ---
> fs/jbd2/commit.c      | 3 ++-
> fs/jbd2/journal.c     | 1 +
> fs/jbd2/transaction.c | 6 ++++--
> include/linux/jbd2.h  | 1 +
> 4 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> index 3091d42..fd2ac94 100644
> --- a/fs/jbd2/commit.c
> +++ b/fs/jbd2/commit.c
> @@ -424,7 +424,8 @@ void jbd2_journal_commit_transaction(journal_t *journal)
> 	J_ASSERT(journal->j_committing_transaction == NULL);
> 
> 	commit_transaction = journal->j_running_transaction;
> -	J_ASSERT(commit_transaction->t_state == T_RUNNING);
> +	J_ASSERT(commit_transaction->t_state == T_REQUESTED ||
> +		 commit_transaction->t_state == T_RUNNING);
> 
> 	trace_jbd2_start_commit(journal, commit_transaction);
> 	jbd_debug(1, "JBD2: starting commit of transaction %d\n",
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 1a80e31..c22773b 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -533,6 +533,7 @@ int __jbd2_log_start_commit(journal_t *journal, tid_t target)
> 		jbd_debug(1, "JBD2: requesting commit %d/%d\n",
> 			  journal->j_commit_request,
> 			  journal->j_commit_sequence);
> +		journal->j_running_transaction->t_state = T_REQUESTED;
> 		wake_up(&journal->j_wait_commit);
> 		return 1;
> 	} else if (!tid_geq(journal->j_commit_request, target))
> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> index df9f297..6daff29 100644
> --- a/fs/jbd2/transaction.c
> +++ b/fs/jbd2/transaction.c
> @@ -224,7 +224,8 @@ repeat:
> 	 * If the current transaction is locked down for commit, wait for the
> 	 * lock to be released.
> 	 */
> -	if (transaction->t_state == T_LOCKED) {
> +	if ((transaction->t_state == T_LOCKED) ||
> +	    (transaction->t_state == T_REQUESTED)) {
> 		DEFINE_WAIT(wait);
> 
> 		prepare_to_wait(&journal->j_wait_transaction_locked,
> @@ -2179,7 +2180,8 @@ void __jbd2_journal_refile_buffer(struct journal_head *jh)
> 	else
> 		jlist = BJ_Reserved;
> 	__jbd2_journal_file_buffer(jh, jh->b_transaction, jlist);
> -	J_ASSERT_JH(jh, jh->b_transaction->t_state == T_RUNNING);
> +	J_ASSERT_JH(jh, (jh->b_transaction->t_state == T_RUNNING ||
> +			 jh->b_transaction->t_state == T_REQUESTED));
> 
> 	if (was_dirty)
> 		set_buffer_jbddirty(bh);
> diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
> index e30b663..920a8d0 100644
> --- a/include/linux/jbd2.h
> +++ b/include/linux/jbd2.h
> @@ -493,6 +493,7 @@ struct transaction_s
> 	 */
> 	enum {
> 		T_RUNNING,
> +		T_REQUESTED,
> 		T_LOCKED,
> 		T_FLUSH,
> 		T_COMMIT,
> -- 
> 1.7.12.rc0.22.gcdd159b
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

