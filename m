From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] jbd: abort instead of waiting for nonexistent
 transactions
Date: Mon, 4 Aug 2008 18:42:28 -0700
Message-ID: <20080804184228.5964b1fd.akpm@linux-foundation.org>
References: <1217898321-3514-1-git-send-email-duaneg@dghda.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, sct@redhat.com,
	linux-ext4@vger.kernel.org, Sami Liedes <sliedes@cc.hut.fi>
To: "Duane Griffin" <duaneg@dghda.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58638 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751147AbYHEBmy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Aug 2008 21:42:54 -0400
In-Reply-To: <1217898321-3514-1-git-send-email-duaneg@dghda.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue,  5 Aug 2008 02:05:20 +0100 "Duane Griffin" <duaneg@dghda.com> wrote:

> The __log_wait_for_space function sits in a loop checkpointing transactions
> until there is sufficient space free in the journal. However, if there are
> no transactions to be processed (e.g. because the free space calculation is
> wrong due to a corrupted filesystem) it will never progress.
> 
> Check for space being required when no transactions are outstanding and
> abort the journal instead of endlessly looping.
> 
> This patch fixes the bug reported by Sami Liedes at:
> http://bugzilla.kernel.org/show_bug.cgi?id=10976
> 
> Signed-off-by: Duane Griffin <duaneg@dghda.com>
> ---
> diff --git a/fs/jbd/checkpoint.c b/fs/jbd/checkpoint.c
> index a5432bb..af2b554 100644
> --- a/fs/jbd/checkpoint.c
> +++ b/fs/jbd/checkpoint.c
> @@ -126,13 +126,24 @@ void __log_wait_for_space(journal_t *journal)
>  
>  		/*
>  		 * Test again, another process may have checkpointed while we
> -		 * were waiting for the checkpoint lock
> +		 * were waiting for the checkpoint lock. If there are no
> +		 * outstanding transactions there is nothing to checkpoint and
> +		 * we can't make progress. Abort the journal in this case.
>  		 */
>  		spin_lock(&journal->j_state_lock);
>  		nblocks = jbd_space_needed(journal);
>  		if (__log_space_left(journal) < nblocks) {
> +			int chkpt = journal->j_checkpoint_transactions != NULL;
> +
>  			spin_unlock(&journal->j_state_lock);
> -			log_do_checkpoint(journal);
> +			if (chkpt) {
> +				log_do_checkpoint(journal);
> +			} else {
> +				printk(KERN_ERR "%s: no transactions\n",
> +				       __func__);
> +				journal_abort(journal, 0);
> +			}
> +
>  			spin_lock(&journal->j_state_lock);
>  		}
>  		mutex_unlock(&journal->j_checkpoint_mutex);

umm, OK, but...

There's not really a lot of point in testing
journal->j_checkpoint_transactions inside j_state_lock, is there? 
Hence local variable chkpt isn't really needed.

But log_do_checkpoint() already checks to see if there are any
checkpointing transactions upon which to operate, so rather than doing
log_do_checkpoint()'s work for it, perhaps it would be cleaner to teach
log_do_checkpoint() to tell the caller whether it manage to do any
work?

The nice thing about that is that even if
journal->j_checkpoint_transactions is NULL, log_do_checkpoint() might
still be able to do some useful work in cleanup_journal_tail().

otoh, two existing callers of log_do_checkpoint() already test
journal->j_checkpoint_transactions before calling log_do_checkpoint(),
so maybe that's pretty pointless.

otoh2, those existing callers do the seemingly-unneeded
spin_lock(j_list_lock).  hrm.  So if we're playing match-the-existing
code, we should go with your first patches.

ho hum, I guess I'll do "otoh2".
