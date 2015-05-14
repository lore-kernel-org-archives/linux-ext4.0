From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2] ext4: fix NULL pointer dereference when journal
 restart fails
Date: Thu, 14 May 2015 11:24:57 +0200
Message-ID: <20150514092457.GB13656@quack.suse.cz>
References: <1431594186-29043-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Jan Kara <jack@suse.cz>, stable@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1431594186-29043-1-git-send-email-lczerner@redhat.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu 14-05-15 11:03:06, Lukas Czerner wrote:
> Currently when journal restart fails, we'll have the h_transaction of
> the handle set to NULL to indicate that the handle has been effectively
> aborted. We handle this situation quietly in the jbd2_journal_stop() and just
> free the handle and exit because everything else has been done before we
> attempted (and failed) to restart the journal.
> 
> Unfortunately there are a number of problems with that approach
> introduced with commit
> 
> 41a5b913197c "jbd2: invalidate handle if jbd2_journal_restart()
> fails"
> 
> First of all in ext4 jbd2_journal_stop() will be called through
> __ext4_journal_stop() where we would try to get a hold of the superblock
> by dereferencing h_transaction which in this case would lead to NULL
> pointer dereference and crash.
> 
> In addition we're going to free the handle regardless of the refcount
> which is bad as well, because others up the call chain will still
> reference the handle so we might potentially reference already freed
> memory.
> 
> Moreover it's expected that we'll get aborted handle as well as detached
> handle in some of the journalling function as the error propagates up
> the stack, so it's unnecessary to call WARN_ON every time we get
> detached handle.
> 
> And finally we might leak some memory by forgetting to free reserved
> handle in jbd2_journal_stop() in the case where handle was detached from
> the transaction (h_transaction is NULL).
> 
> Fix the NULL pointer dereference in __ext4_journal_stop() by just
> calling jbd2_journal_stop() quietly as suggested by Jan Kara. Also fix
> the potential memory leak in jbd2_journal_stop() and use proper
> handle refcounting before we attempt to free it to avoid use-after-free
> issues.
> 
> And finally remove all WARN_ON(!transaction) from the code so that we do
> not get random traces when something goes wrong because when journal
> restart fails we will get to some of those functions.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> Cc: stable@vger.kernel.org
> ---
> v2: As Jan Kara pointed out setting h_transaction to NULL is actually
> desirable because the handle was detached from that transaction.

The patch looks good, you can add:

Reviewed-by: Jan Kara <jack@suse.cz>

  Just one small nit below:

...
> @@ -1530,8 +1524,22 @@ int jbd2_journal_stop(handle_t *handle)
>  	tid_t tid;
>  	pid_t pid;
>  
> -	if (!transaction)
> -		goto free_and_exit;
> +	if (!transaction) {
> +		/*
> +		 * Handle is already detached from the transaction so
> +		 * there is nothing to do other than decrease a refcount,
> +		 * or free the handle if refcount drops to zero
> +		 */
> +		if (--handle->h_ref > 0) {
> +			jbd_debug(4, "h_ref %d -> %d\n", handle->h_ref + 1,
> +							 handle->h_ref);
> +			return err;
> +		} else {
> +			if (handle->h_rsv_handle)
> +				jbd2_free_handle(handle->h_rsv_handle);
> +			goto free_and_exit;

It would we nicer if you just moved free_and_exit label before freeing of
the reserved handle instead of duplicating the code here. Also it is more
future proof if we add more places jumping to the label...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
