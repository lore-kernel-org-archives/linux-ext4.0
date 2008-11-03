From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] improve jbd fsync batching
Date: Mon, 3 Nov 2008 12:27:29 -0800
Message-ID: <20081103122729.60582692.akpm@linux-foundation.org>
References: <20081028201614.GA21600@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, rwheeler@redhat.com
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50473 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754126AbYKCU2M (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Nov 2008 15:28:12 -0500
In-Reply-To: <20081028201614.GA21600@unused.rdu.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 28 Oct 2008 16:16:15 -0400
Josef Bacik <jbacik@redhat.com> wrote:

> Hello,
> 
> This is a rework of the patch I did a few months ago, taking into account some
> comments from Andrew and using the new schedule_hrtimeout function (thanks
> Arjan!).
> 
> There is a flaw with the way jbd handles fsync batching.  If we fsync() a file
> and we were not the last person to run fsync() on this fs then we automatically
> sleep for 1 jiffie in order to wait for new writers to join into the transaction
> before forcing the commit.  The problem with this is that with really fast
> storage (ie a Clariion) the time it takes to commit a transaction to disk is way
> faster than 1 jiffie in most cases, so sleeping means waiting longer with
> nothing to do than if we just committed the transaction and kept going.  Ric
> Wheeler noticed this when using fs_mark with more than 1 thread, the throughput
> would plummet as he added more threads.
> 
> ...
>
> ...
>  
> @@ -49,6 +50,7 @@ get_transaction(journal_t *journal, transaction_t *transaction)
>  {
>  	transaction->t_journal = journal;
>  	transaction->t_state = T_RUNNING;
> +	transaction->t_start_time = ktime_get();
>  	transaction->t_tid = journal->j_transaction_sequence++;
>  	transaction->t_expires = jiffies + journal->j_commit_interval;
>  	spin_lock_init(&transaction->t_handle_lock);
> @@ -1371,7 +1373,7 @@ int journal_stop(handle_t *handle)
>  {
>  	transaction_t *transaction = handle->h_transaction;
>  	journal_t *journal = transaction->t_journal;
> -	int old_handle_count, err;
> +	int err;
>  	pid_t pid;
>  
>  	J_ASSERT(journal_current_handle() == handle);
> @@ -1407,11 +1409,26 @@ int journal_stop(handle_t *handle)
>  	 */
>  	pid = current->pid;
>  	if (handle->h_sync && journal->j_last_sync_writer != pid) {

It would be nice to have a comment here explaining the overall design. 
it's a bit opaque working that out from the raw implementation.

> +		u64 commit_time, trans_time;
> +
>  		journal->j_last_sync_writer = pid;
> -		do {
> -			old_handle_count = transaction->t_handle_count;
> -			schedule_timeout_uninterruptible(1);
> -		} while (old_handle_count != transaction->t_handle_count);
> +
> +		spin_lock(&journal->j_state_lock);
> +		commit_time = journal->j_average_commit_time;
> +		spin_unlock(&journal->j_state_lock);

OK, the lock is needed on 32-bit machines, I guess.


> +		trans_time = ktime_to_ns(ktime_sub(ktime_get(),
> +						   transaction->t_start_time));
> +
> +		commit_time = min_t(u64, commit_time,
> +				    1000*jiffies_to_usecs(1));

OK.  The multiplication of an unsigned by 1000 could overflow, but only
if HZ is less than 0.25.  I don't think we need worry about that ;)


> +		if (trans_time < commit_time) {
> +			ktime_t expires = ktime_add_ns(ktime_get(),
> +						       commit_time);
> +			set_current_state(TASK_UNINTERRUPTIBLE);
> +			schedule_hrtimeout(&expires, HRTIMER_MODE_ABS);

We should have schedule_hrtimeout_uninterruptible(), but we don't.

> +		}
>  	}
>  
>  	current->journal_info = NULL;
> diff --git a/include/linux/jbd.h b/include/linux/jbd.h
> index 346e2b8..d842230 100644
> --- a/include/linux/jbd.h
> +++ b/include/linux/jbd.h
> @@ -543,6 +543,11 @@ struct transaction_s
>  	unsigned long		t_expires;
>  
>  	/*
> +	 * When this transaction started, in nanoseconds [no locking]
> +	 */
> +	ktime_t			t_start_time;
> +
> +	/*
>  	 * How many handles used this transaction? [t_handle_lock]
>  	 */
>  	int t_handle_count;
> @@ -800,6 +805,8 @@ struct journal_s
>  
>  	pid_t			j_last_sync_writer;
>  
> +	u64			j_average_commit_time;

Every field in that structure is carefully documented (except for
j_last_sync_writer - what vandal did that?)

please fix.
