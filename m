From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: ext4 dbench performance with CONFIG_PREEMPT_RT
Date: Thu, 08 Apr 2010 15:37:17 -0700
Message-ID: <1270766237.2662.3.camel@mingming-laptop>
References: <1270682478.3755.58.camel@localhost.localdomain>
	 <20100408034631.GB23188@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: john stultz <johnstul@us.ibm.com>, linux-ext4@vger.kernel.org,
	keith maanthey <kmannth@us.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>, Darren Hart <dvhltc@us.ibm.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:33111 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933331Ab0DHWha (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Apr 2010 18:37:30 -0400
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com [9.17.195.228])
	by e32.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id o38MUhW5021073
	for <linux-ext4@vger.kernel.org>; Thu, 8 Apr 2010 16:30:43 -0600
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o38MbKsB037690
	for <linux-ext4@vger.kernel.org>; Thu, 8 Apr 2010 16:37:24 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o38FbJ97002574
	for <linux-ext4@vger.kernel.org>; Thu, 8 Apr 2010 09:37:20 -0600
In-Reply-To: <20100408034631.GB23188@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2010-04-07 at 23:46 -0400, tytso@mit.edu wrote:
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

Seems so, I verified the code, looks we could drop the j_state_lock()
there.


Also, I wonder if we could make the journal->j_average_commit_time as
atomic, so we could drop the j_state_lock() more in jbd2_journal_stop()?
Not sure how much this will improve the rt kernel, but might be worth
doing since j_state_lock() seems to be the hottest one.


Mingming
> So I ***think*** the following might be safe.  WARNING!  WARNING!!  No
> real testing done on this patch, other than "it compiles!  ship it!!".
> 
> I'll let other people review it, and maybe you could give this a run
> and see what happens with this patch?
> 
> 					- Ted
> 
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


