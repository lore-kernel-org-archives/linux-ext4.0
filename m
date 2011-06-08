From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd2:Make journal transaction allocations come from
 its own cache.
Date: Wed, 8 Jun 2011 18:49:03 +0200
Message-ID: <20110608164903.GG5361@quack.suse.cz>
References: <1307262510-16376-1-git-send-email-mkatiyar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, tytso@mit.edu, linux-ext4@vger.kernel.org
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38246 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986Ab1FHQtG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 8 Jun 2011 12:49:06 -0400
Content-Disposition: inline
In-Reply-To: <1307262510-16376-1-git-send-email-mkatiyar@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun 05-06-11 01:28:30, Manish Katiyar wrote:
> Add a cache for jbd2 journal transaction allocations. This also
> helps to leverage fault-injection framework to test various memory
> allocation failures in the jbd2 layer.
> 
> Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
> ---
>  fs/jbd2/checkpoint.c  |    2 +-
>  fs/jbd2/commit.c      |    2 +-
>  fs/jbd2/journal.c     |   25 +++++++++++++++++++++++++
>  fs/jbd2/transaction.c |    7 ++++---
>  include/linux/jbd2.h  |   21 +++++++++++++++++++++
>  5 files changed, 52 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
> index 6a79fd0..6f554ce 100644
> --- a/fs/jbd2/checkpoint.c
> +++ b/fs/jbd2/checkpoint.c
> @@ -716,7 +716,7 @@ int __jbd2_journal_remove_checkpoint(struct journal_head *jh)
>  				    transaction->t_tid, stats);
>  
>  	__jbd2_journal_drop_transaction(journal, transaction);
> -	kfree(transaction);
> +	jbd2_free_transaction(transaction);
>  
>  	/* Just in case anybody was waiting for more transactions to be
>             checkpointed... */
> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> index 7f21cf3..8e33d84 100644
> --- a/fs/jbd2/commit.c
> +++ b/fs/jbd2/commit.c
> @@ -1037,7 +1037,7 @@ restart_loop:
>  	jbd_debug(1, "JBD: commit %d complete, head %d\n",
>  		  journal->j_commit_sequence, journal->j_tail_sequence);
>  	if (to_free)
> -		kfree(commit_transaction);
> +		jbd2_free_transaction(commit_transaction);
>  
>  	wake_up(&journal->j_wait_done_commit);
>  }
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 9a78269..c0ec463 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -95,6 +95,7 @@ EXPORT_SYMBOL(jbd2_journal_init_jbd_inode);
>  EXPORT_SYMBOL(jbd2_journal_release_jbd_inode);
>  EXPORT_SYMBOL(jbd2_journal_begin_ordered_truncate);
>  EXPORT_SYMBOL(jbd2_inode_cache);
> +EXPORT_SYMBOL(jbd2_transaction_cache);
>  
>  static int journal_convert_superblock_v1(journal_t *, journal_superblock_t *);
>  static void __journal_abort_soft (journal_t *journal, int errno);
> @@ -2371,6 +2372,27 @@ static void jbd2_journal_destroy_handle_cache(void)
>  
>  }
>  
> +struct kmem_cache *jbd2_transaction_cache;
> +
> +static int journal_init_transaction_cache(void)
> +{
> +	J_ASSERT(jbd2_transaction_cache == NULL);
> +	jbd2_transaction_cache = kmem_cache_create("jbd2_transaction",
> +						   sizeof(transaction_t),
> +						   0, SLAB_TEMPORARY, NULL);
  Transactions are not really short-lived in the memory-management sense I
think. They usually live for seconds while I'd understand 'short-lived' to
mean a milisecond or less. So just drop this flag (it doesn't do anything
these days anyway).

> +	if (jbd2_transaction_cache == NULL) {
> +		printk(KERN_EMERG "JBD2: failed to create transaction cache\n");
> +		return -ENOMEM;
> +	}
> +	return 0;
> +}
> +
> +static void jbd2_journal_destroy_transaction_cache(void)
> +{
> +	if (jbd2_transaction_cache)
  How can this happen?

> +		kmem_cache_destroy(jbd2_transaction_cache);
> +}
> +
>  /*
>   * Module startup and shutdown
>   */
> @@ -2384,6 +2406,8 @@ static int __init journal_init_caches(void)
>  		ret = journal_init_jbd2_journal_head_cache();
>  	if (ret == 0)
>  		ret = journal_init_handle_cache();
> +	if (ret == 0)
> +		ret = journal_init_transaction_cache();
>  	return ret;
>  }
>  
> @@ -2392,6 +2416,7 @@ static void jbd2_journal_destroy_caches(void)
>  	jbd2_journal_destroy_revoke_caches();
>  	jbd2_journal_destroy_jbd2_journal_head_cache();
>  	jbd2_journal_destroy_handle_cache();
> +	jbd2_journal_destroy_transaction_cache();
>  	jbd2_journal_destroy_slabs();
>  }
>  
> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> index 3eec82d..58fbec7 100644
> --- a/fs/jbd2/transaction.c
> +++ b/fs/jbd2/transaction.c
> @@ -131,7 +131,7 @@ static int start_this_handle(journal_t *journal, handle_t *handle,
>  
>  alloc_transaction:
>  	if (!journal->j_running_transaction) {
> -		new_transaction = kzalloc(sizeof(*new_transaction), gfp_mask);
> +		new_transaction = jbd2_alloc_transaction(gfp_mask);
>  		if (!new_transaction) {
>  			/*
>  			 * If __GFP_FS is not present, then we may be
> @@ -160,7 +160,7 @@ repeat:
>  	if (is_journal_aborted(journal) ||
>  	    (journal->j_errno != 0 && !(journal->j_flags & JBD2_ACK_ERR))) {
>  		read_unlock(&journal->j_state_lock);
> -		kfree(new_transaction);
> +		jbd2_free_transaction(new_transaction);
>  		return -EROFS;
>  	}
>  
> @@ -282,7 +282,8 @@ repeat:
>  	read_unlock(&journal->j_state_lock);
>  
>  	lock_map_acquire(&handle->h_lockdep_map);
> -	kfree(new_transaction);
> +	jbd2_free_transaction(new_transaction);
> +
>  	return 0;
>  }
>  
> diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
> index 4ecb7b1..df7f101 100644
> --- a/include/linux/jbd2.h
> +++ b/include/linux/jbd2.h
> @@ -1184,6 +1184,27 @@ static inline void jbd2_free_handle(handle_t *handle)
>  }
>  
>  /*
> + * transaction management
> + */
> +extern struct kmem_cache *jbd2_transaction_cache;
> +
> +static inline transaction_t *jbd2_alloc_transaction(gfp_t gfp_flags)
> +{
> +	return kmem_cache_zalloc(jbd2_transaction_cache, gfp_flags);
> +}
> +
> +static inline void jbd2_free_transaction(transaction_t *transaction)
> +{
> +	if (transaction) {
> +#ifdef CONFIG_JBD2_DEBUG
> +		memset(transaction, JBD2_POISON_FREE, sizeof(*transaction));
> +#endif
  No need for this - CONFIG_DEBUG_SLAB does this for you...

> +		kmem_cache_free(jbd2_transaction_cache, transaction);
> +	}
> +}
> +
> +
> +/*
>   * jbd2_inode management (optional, for those file systems that want to use
>   * dynamically allocated jbd2_inode structures)
>   */
  Otherwise the patch looks OK to me.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
