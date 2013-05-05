From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 11/29] jbd2: Remove unused waitqueues
Date: Sun, 5 May 2013 16:41:23 +0800
Message-ID: <20130505084123.GA24483@gmail.com>
References: <1365456754-29373-1-git-send-email-jack@suse.cz>
 <1365456754-29373-12-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:37927 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab3EEIXq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 5 May 2013 04:23:46 -0400
Received: by mail-pb0-f41.google.com with SMTP id mc17so1539801pbc.28
        for <linux-ext4@vger.kernel.org>; Sun, 05 May 2013 01:23:45 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1365456754-29373-12-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 08, 2013 at 11:32:16PM +0200, Jan Kara wrote:
> j_wait_logspace and j_wait_checkpoint are unused. Remove them.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
Regards,
                                                - Zheng

> ---
>  fs/jbd2/checkpoint.c |    4 ----
>  fs/jbd2/journal.c    |    2 --
>  include/linux/jbd2.h |    8 --------
>  3 files changed, 0 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
> index a572383..75a15f3 100644
> --- a/fs/jbd2/checkpoint.c
> +++ b/fs/jbd2/checkpoint.c
> @@ -625,10 +625,6 @@ int __jbd2_journal_remove_checkpoint(struct journal_head *jh)
>  
>  	__jbd2_journal_drop_transaction(journal, transaction);
>  	jbd2_journal_free_transaction(transaction);
> -
> -	/* Just in case anybody was waiting for more transactions to be
> -           checkpointed... */
> -	wake_up(&journal->j_wait_logspace);
>  	ret = 1;
>  out:
>  	return ret;
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index e6f14e0..63e2929 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -998,9 +998,7 @@ static journal_t * journal_init_common (void)
>  		return NULL;
>  
>  	init_waitqueue_head(&journal->j_wait_transaction_locked);
> -	init_waitqueue_head(&journal->j_wait_logspace);
>  	init_waitqueue_head(&journal->j_wait_done_commit);
> -	init_waitqueue_head(&journal->j_wait_checkpoint);
>  	init_waitqueue_head(&journal->j_wait_commit);
>  	init_waitqueue_head(&journal->j_wait_updates);
>  	mutex_init(&journal->j_barrier);
> diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
> index 9197d1b..ad4b3bb 100644
> --- a/include/linux/jbd2.h
> +++ b/include/linux/jbd2.h
> @@ -686,9 +686,7 @@ jbd2_time_diff(unsigned long start, unsigned long end)
>   *  waiting for checkpointing
>   * @j_wait_transaction_locked: Wait queue for waiting for a locked transaction
>   *  to start committing, or for a barrier lock to be released
> - * @j_wait_logspace: Wait queue for waiting for checkpointing to complete
>   * @j_wait_done_commit: Wait queue for waiting for commit to complete
> - * @j_wait_checkpoint:  Wait queue to trigger checkpointing
>   * @j_wait_commit: Wait queue to trigger commit
>   * @j_wait_updates: Wait queue to wait for updates to complete
>   * @j_checkpoint_mutex: Mutex for locking against concurrent checkpoints
> @@ -793,15 +791,9 @@ struct journal_s
>  	 */
>  	wait_queue_head_t	j_wait_transaction_locked;
>  
> -	/* Wait queue for waiting for checkpointing to complete */
> -	wait_queue_head_t	j_wait_logspace;
> -
>  	/* Wait queue for waiting for commit to complete */
>  	wait_queue_head_t	j_wait_done_commit;
>  
> -	/* Wait queue to trigger checkpointing */
> -	wait_queue_head_t	j_wait_checkpoint;
> -
>  	/* Wait queue to trigger commit */
>  	wait_queue_head_t	j_wait_commit;
>  
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
