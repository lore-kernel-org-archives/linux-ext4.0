From: Jan Kara <jack@suse.cz>
Subject: Re: ext4 dbench performance with CONFIG_PREEMPT_RT
Date: Mon, 12 Apr 2010 21:46:28 +0200
Message-ID: <20100412194628.GI12238@atrey.karlin.mff.cuni.cz>
References: <1270682478.3755.58.camel@localhost.localdomain> <20100408034631.GB23188@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: john stultz <johnstul@us.ibm.com>, linux-ext4@vger.kernel.org,
	Mingming Cao <cmm@us.ibm.com>,
	keith maanthey <kmannth@us.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>, Darren Hart <dvhltc@us.ibm.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ksp.mff.cuni.cz ([195.113.26.206]:48280 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752499Ab0DLTq3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Apr 2010 15:46:29 -0400
Content-Disposition: inline
In-Reply-To: <20100408034631.GB23188@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On Wed, Apr 07, 2010 at 04:21:18PM -0700, john stultz wrote:
> > Further using lockstat I was able to isolate it the contention down to
> > the journal j_state_lock, and then adding some lock owner tracking, I
> > was able to see that the lock owners were almost always in
> > start_this_handle, and jbd2_journal_stop when we saw contention (with
> > the freq breakdown being about 55% in jbd2_journal_stop and 45% in
> > start_this_handle).
> 
> Hmm....  I've taken a very close look at jbd2_journal_stop(), and I
> don't think we need to take j_state_lock() at all except if we need to
> call jbd2_log_start_commit().  t_outstanding_credits,
> h_buffer_credits, and t_updates are all documented (and verified by
> me) to be protected by the t_handle_lock spinlock.
> 
> So I ***think*** the following might be safe.  WARNING!  WARNING!!  No
> real testing done on this patch, other than "it compiles!  ship it!!".
> 
> I'll let other people review it, and maybe you could give this a run
> and see what happens with this patch?
  I had a look and it really seems that t_handle_lock is enough for
all we do in jbd2_journal_stop (except for jbd2_log_start_commit). So
I think your patch is fine.
  I also had a look at jbd2_journal_start. What probably makes things bad there
is that lots of threads accumulate waiting for transaction to get out of
T_LOCKED state. When that happens, all the threads are woken up and start
pondering at j_state_lock which creates contention. This is just a theory and I
might be completely wrong... Some lockstat data would be useful to confirm /
refute this.

								Honza

> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> index bfc70f5..e214d68 100644
> --- a/fs/jbd2/transaction.c
> +++ b/fs/jbd2/transaction.c
> @@ -1311,7 +1311,6 @@ int jbd2_journal_stop(handle_t *handle)
>  	if (handle->h_sync)
>  		transaction->t_synchronous_commit = 1;
>  	current->journal_info = NULL;
> -	spin_lock(&journal->j_state_lock);
>  	spin_lock(&transaction->t_handle_lock);
>  	transaction->t_outstanding_credits -= handle->h_buffer_credits;
>  	transaction->t_updates--;
> @@ -1340,8 +1339,7 @@ int jbd2_journal_stop(handle_t *handle)
>  		jbd_debug(2, "transaction too old, requesting commit for "
>  					"handle %p\n", handle);
>  		/* This is non-blocking */
> -		__jbd2_log_start_commit(journal, transaction->t_tid);
> -		spin_unlock(&journal->j_state_lock);
> +		jbd2_log_start_commit(journal, transaction->t_tid);
>  
>  		/*
>  		 * Special case: JBD2_SYNC synchronous updates require us
> @@ -1351,7 +1349,6 @@ int jbd2_journal_stop(handle_t *handle)
>  			err = jbd2_log_wait_commit(journal, tid);
>  	} else {
>  		spin_unlock(&transaction->t_handle_lock);
> -		spin_unlock(&journal->j_state_lock);
>  	}
>  
>  	lock_map_release(&handle->h_lockdep_map);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
