From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/5] ext4: fix data integrity for ext4_sync_fs
Date: Mon, 15 Apr 2013 15:59:31 +0200
Message-ID: <20130415135931.GG2299@quack.suse.cz>
References: <1365966097-8968-1-git-send-email-dmonakhov@openvz.org>
 <1365966097-8968-3-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jack@suse.cz
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42061 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935863Ab3DPQgY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Apr 2013 12:36:24 -0400
Content-Disposition: inline
In-Reply-To: <1365966097-8968-3-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun 14-04-13 23:01:35, Dmitry Monakhov wrote:
> Inode's data or non journaled quota may be written w/o jounral so we must
> send a barrier at the end of ext4_sync_fs. But it can be skipped if journal
> commit will do it for us.
> 
> Also fix data integrity for nojournal mode.
  Looks good, just some nits below.

> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index cfe0aca..35de8a0 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -668,14 +668,30 @@ int jbd2_journal_start_commit(journal_t *journal, tid_t *ptid)
>   * may or may not have sent the barrier. Used to avoid sending barrier
>   * twice in common cases.
>   */
> -int jbd2_trans_will_send_data_barrier(journal_t *journal, tid_t tid)
> +int jbd2_trans_will_send_data_barrier(journal_t *journal, tid_t *wait_tid)
  I don't like the pointer for wait_tid. It looks somewhat confusing. Can't
we just either create a function to return the last transaction's tid and
pass that value to jbd2_trans_will_send_data_barrier() or create another
function without 'tid' argument which would take the last transaction?

								Honza
>  {
>  	int ret = 0;
>  	transaction_t *commit_trans;
> +	tid_t tid;
>  
>  	if (!(journal->j_flags & JBD2_BARRIER))
>  		return 0;
>  	read_lock(&journal->j_state_lock);
> +
> +	/* Caller want to wait some specific transaction? */
> +	if (wait_tid)
> +		tid = *wait_tid;
> +	else  {
> +		/* Most recent uncommitted transaction */
> +		if (journal->j_running_transaction) {
> +			ret = 1;
> +			goto out;
> +		}
> +		if (!journal->j_commit_sequence) {
> +			goto out;
> +		}
> +		tid = journal->j_commit_sequence;
> +	}
>  	/* Transaction already committed? */
>  	if (tid_geq(journal->j_commit_sequence, tid))
>  		goto out;
> diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
> index 7b38517..8d77790 100644
> --- a/include/linux/jbd2.h
> +++ b/include/linux/jbd2.h
> @@ -1203,7 +1203,7 @@ int jbd2_journal_start_commit(journal_t *journal, tid_t *tid);
>  int jbd2_log_wait_commit(journal_t *journal, tid_t tid);
>  int jbd2_complete_transaction(journal_t *journal, tid_t tid);
>  int jbd2_log_do_checkpoint(journal_t *journal);
> -int jbd2_trans_will_send_data_barrier(journal_t *journal, tid_t tid);
> +int jbd2_trans_will_send_data_barrier(journal_t *journal, tid_t *tid);
>  
>  void __jbd2_log_wait_for_space(journal_t *journal);
>  extern void __jbd2_journal_drop_transaction(journal_t *, transaction_t *);
> -- 
> 1.7.1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
