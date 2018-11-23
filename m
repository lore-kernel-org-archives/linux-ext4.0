Return-Path: <SRS0=kdxW=OC=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53300 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387941AbeKWV7I (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 23 Nov 2018 16:59:08 -0500
Date: Fri, 23 Nov 2018 12:15:15 +0100
From: Jan Kara <jack@suse.cz>
To: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4: fix deadlock while checkpoint thread waits commit
 thread to finish
Message-ID: <20181123111515.GA31877@quack2.suse.cz>
References: <20181114114935.5250-1-xiaoguang.wang@linux.alibaba.com>
 <20181122123601.GO9840@quack2.suse.cz>
 <7f9dab38-26f8-6fd8-299e-30d711ee61b8@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f9dab38-26f8-6fd8-299e-30d711ee61b8@linux.alibaba.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 23-11-18 10:45:20, Xiaoguang Wang wrote:
> hi,
> 
> > On Wed 14-11-18 19:49:35, Xiaoguang Wang wrote:
> > > This issue was found when I tried to put checkpoint work in a separate thread,
> > > the deadlock below happened:
> > >           Thread1                                |   Thread2
> > > __jbd2_log_wait_for_space                       |
> > > jbd2_log_do_checkpoint (hold j_checkpoint_mutex)|
> > >    if (jh->b_transaction != NULL)                |
> > >      ...                                         |
> > >      jbd2_log_start_commit(journal, tid);        |jbd2_update_log_tail
> > >                                                  |  will lock j_checkpoint_mutex,
> > >                                                  |  but will be blocked here.
> > >                                                  |
> > >      jbd2_log_wait_commit(journal, tid);         |
> > >      wait_event(journal->j_wait_done_commit,     |
> > >       !tid_gt(tid, journal->j_commit_sequence)); |
> > >       ...                                        |wake_up(j_wait_done_commit)
> > >    }                                             |
> > > 
> > > then deadlock occurs, Thread1 will never be waken up.
> > > 
> > > To fix this issue, drop j_checkpoint_mutex in jbd2_log_do_checkpoint()
> > > when we are going to wait for transaction commit.
> > > 
> > > Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> > 
> > Thanks for the patch! One comment below...
> > 
> > > diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
> > > index 26f8d7e46462..e728844f2f0e 100644
> > > --- a/fs/jbd2/checkpoint.c
> > > +++ b/fs/jbd2/checkpoint.c
> > > @@ -113,7 +113,7 @@ void __jbd2_log_wait_for_space(journal_t *journal)
> > >   	nblocks = jbd2_space_needed(journal);
> > >   	while (jbd2_log_space_left(journal) < nblocks) {
> > >   		write_unlock(&journal->j_state_lock);
> > > -		mutex_lock(&journal->j_checkpoint_mutex);
> > > +		mutex_lock_io(&journal->j_checkpoint_mutex);
> > >   		/*
> > >   		 * Test again, another process may have checkpointed while we
> > > @@ -241,8 +241,8 @@ int jbd2_log_do_checkpoint(journal_t *journal)
> > >   	 * done (maybe it's a new transaction, but it fell at the same
> > >   	 * address).
> > >   	 */
> > > -	if (journal->j_checkpoint_transactions != transaction ||
> > > -	    transaction->t_tid != this_tid)
> > > +	if (journal->j_checkpoint_transactions == NULL ||
> > > +	    journal->j_checkpoint_transactions->t_tid != this_tid)
> > >   		goto out;
> > 
> > Why did you change this? As far as I can tell there's no difference and the
> > previous condition makes it more obvious that we are still looking at the
> > same transaction.
> In this patch, we may drop j_checkpoint_mutex, then another thread may acquire
> this lock, do checkpoint work and freed current transaction, "transaction->t_tid"
> will cause an invalid pointer dereference.

That is exactly the reason why we check:

if (journal->j_checkpoint_transactions != transaction || ...

So if this test is false and so transaction->t_tid != this_tid gets
evaluated we are sure that j_checkpoint_transactions actually still points
to our transaction.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
