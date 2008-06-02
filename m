From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/5] jbd: fix error handling for checkpoint io
Date: Mon, 2 Jun 2008 14:44:09 +0200
Message-ID: <20080602124409.GL30613@duck.suse.cz>
References: <4843CE15.6080506@hitachi.com> <4843CFBD.7040706@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: akpm@linux-foundation.org, sct@redhat.com, adilger@clusterfs.com,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	jack@suse.cz, jbacik@redhat.com, cmm@us.ibm.com, tytso@mit.edu,
	sugita <yumiko.sugita.yf@hitachi.com>,
	Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:41796 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755248AbYFBMoL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Jun 2008 08:44:11 -0400
Content-Disposition: inline
In-Reply-To: <4843CFBD.7040706@hitachi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 02-06-08 19:47:25, Hidehiro Kawai wrote:
> Subject: [PATCH 4/5] jbd: fix error handling for checkpoint io
> 
> When a checkpointing IO fails, current JBD code doesn't check the
> error and continue journaling.  This means latest metadata can be
> lost from both the journal and filesystem.
> 
> This patch leaves the failed metadata blocks in the journal space
> and aborts journaling in the case of log_do_checkpoint().
> To achieve this, we need to do:
> 
> 1. don't remove the failed buffer from the checkpoint list where in
>    the case of __try_to_free_cp_buf() because it may be released or
>    overwritten by a later transaction
> 2. log_do_checkpoint() is the last chance, remove the failed buffer
>    from the checkpoint list and abort the journal
> 3. when checkpointing fails, don't update the journal super block to
>    prevent the journaled contents from being cleaned.  For safety,
>    don't update j_tail and j_tail_sequence either
> 4. when checkpointing fails, notify this error to the ext3 layer so
>    that ext3 don't clear the needs_recovery flag, otherwise the
>    journaled contents are ignored and cleaned in the recovery phase
> 5. if the recovery fails, keep the needs_recovery flag
> 6. prevent cleanup_journal_tail() from being called between
>    __journal_drop_transaction() and journal_abort() (a race issue
>    between journal_flush() and __log_wait_for_space()
> 
> Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
  Just a few minor comments:

> 
> Index: linux-2.6.26-rc4/fs/jbd/checkpoint.c
> ===================================================================
> --- linux-2.6.26-rc4.orig/fs/jbd/checkpoint.c
> +++ linux-2.6.26-rc4/fs/jbd/checkpoint.c

<snip>

> @@ -318,6 +331,7 @@ int log_do_checkpoint(journal_t *journal
>  	 * OK, we need to start writing disk blocks.  Take one transaction
>  	 * and write it.
>  	 */
> +	result = 0;
>  	spin_lock(&journal->j_list_lock);
>  	if (!journal->j_checkpoint_transactions)
>  		goto out;
> @@ -334,7 +348,7 @@ restart:
>  		int batch_count = 0;
>  		struct buffer_head *bhs[NR_BATCH];
>  		struct journal_head *jh;
> -		int retry = 0;
> +		int retry = 0, err;
>  
>  		while (!retry && transaction->t_checkpoint_list) {
>  			struct buffer_head *bh;
> @@ -347,6 +361,8 @@ restart:
>  				break;
>  			}
>  			retry = __process_buffer(journal, jh, bhs,&batch_count);
> +			if (retry < 0)
> +				result = retry;
  Here you update result whenever retry is < 0 and below when result == 0.
I think it's better to have these two consistent (not that it would be
currently any functional difference).

>  			if (!retry && (need_resched() ||
>  				spin_needbreak(&journal->j_list_lock))) {
>  				spin_unlock(&journal->j_list_lock);
> @@ -371,14 +387,18 @@ restart:
>  		 * Now we have cleaned up the first transaction's checkpoint
>  		 * list. Let's clean up the second one
>  		 */
> -		__wait_cp_io(journal, transaction);
> +		err = __wait_cp_io(journal, transaction);
> +		if (!result)
> +			result = err;
>  	}

> @@ -1360,10 +1370,16 @@ int journal_flush(journal_t *journal)
>  	spin_lock(&journal->j_list_lock);
>  	while (!err && journal->j_checkpoint_transactions != NULL) {
>  		spin_unlock(&journal->j_list_lock);
> +		mutex_lock(&journal->j_checkpoint_mutex);
>  		err = log_do_checkpoint(journal);
> +		mutex_unlock(&journal->j_checkpoint_mutex);
>  		spin_lock(&journal->j_list_lock);
>  	}
>  	spin_unlock(&journal->j_list_lock);
> +
> +	if (is_journal_aborted(journal))
> +		return -EIO;
> +
>  	cleanup_journal_tail(journal);
>  
>  	/* Finally, mark the journal as really needing no recovery.
  OK, so this way you've basically serialized all users of
log_do_checkpoint(). That should be fine because performance-wise interesting
is only log_wait_for_space() and that was already serialized before. So
this change is fine with me. Only please add a comment in front of
log_do_checkpoint() that it's supposed to be called with j_checkpoint_mutex
held so that EIO propagation works correctly.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
