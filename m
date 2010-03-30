From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] ext4/jbd2: fix io-barrier logic in case of
	external journal
Date: Tue, 30 Mar 2010 04:14:38 +0200
Message-ID: <20100330021438.GE18791@atrey.karlin.mff.cuni.cz>
References: <1268414810-17289-1-git-send-email-dmonakhov@openvz.org> <20100322012000.GD11560@thunk.org> <87iq8o4fmk.fsf@openvz.org> <20100322150342.GG11560@thunk.org> <87d3yw49m2.fsf@openvz.org> <20100322202251.GJ11560@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ksp.mff.cuni.cz ([195.113.26.206]:58460 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755109Ab0C3COk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Mar 2010 22:14:40 -0400
Content-Disposition: inline
In-Reply-To: <20100322202251.GJ11560@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On Mon, Mar 22, 2010 at 07:14:13PM +0300, Dmitry Monakhov wrote:
> > >
> > > Just to be clear, since I realized I wrote fsync() when I should have
> > > written fs/ext4/fsync.c, my proposal was to put this check in
> > > ext4_sync_file().
> > This means that we will end up with two io-barriers in a row
> > for external journal case:
> > ext4_sync_file()
> >   ->jbd2_log_start_commit()
> >      ->blkdev_issue_flush(j_fs_dev)
> >   /* seems following flush is mandatory to guarantee the metadata
> >    * consistency */
> >   ->blkdev_issue_flush(j_fs_dev)
> 
> Well, not if we only issue a barrier in the external barrier case....
> but I agree the logic may start getting ugly.
> 
> > I've already started to work with the patch but was surprised with
> > commit logic. 
> > ->__jbd2_log_start_commit(target)
> >    journal->j_commit_request = target
> >    ->wake_up(&journal->j_wait_commit)
> > ->kjournald2
> >    transaction = journal->j_running_transaction
> >    ->jbd2_journal_commit_transaction(journal);
> >      commit_transaction = journal->j_running_transaction
> >      ...
> >      /* So j_commit_request is used only for comparison. But actually
> >         committing journal->j_running_transaction->t_tid transaction
> >         instead of j_commit_request. Why?
> >       */
> 
> Yeah, I don't think jbd2_log_start_commit() has the semantics that are
> currently documented.  We will return 0 if we wake up the commit
> thread, yes --- but since we only check j_commit_request, and it's a
> geq test, it might very well be the case that the transaction was
> committed long ago, and so we end up kicking off a transaction commit
> when one is not needed.  Or, it may be that a transaction is just
> already being committed (and in fact is just about to be completed),
> and so the wake_up() call is a no-op, and so we don't get a barrier
> when one is needed (and expected) by ext4_sync_file().
> 
> We need to look at this very closely, but I think
> jbd2_log_start_commit() needs to check to see whether there is a
> current committing transaction, and whether it is the one which is
> that has been requested as a target.  If so, and a barrier is
> requested, I think we need to have jbd2_log_start_commit() do the
> barrier.  There is a risk of having a double barrier in that case, but
> modifying the flag on the currently committing transaction has the
> danger of being lost by kjournald --- or I guess alternatively we
> could have kjournald check that flag while holding j_state_lock, which
> might be better.
  But still if you happen to set the flag after commit code has checked
it, you have lost the race. Given the bug you describe below, I think
we should provide a new call from JBD2 that will do all the necessary
magic for given TID - something like:
	data_barrier = 0;
	if (journal->j_commit_sequence > tid)
		data_barrier = 1;
	else if (journal->j_committing_transaction &&
		 journal->j_committing_transaction->t_tid == tid) {
		/* Here we could be more clever and set the barrier
		 * flag of the transaction if according to its state
		 * it has not yet issued data barrier */
		data_barrier = 1;
	} else {
		journal->j_running_transaction->has_data = 1;
		jbd2_log_start_commit(journal, tid);
	}
	jbd2_log_wait_commit(journal, tid);
	if (data_barrier)
		blk_dev_issue_flush(journal->j_fs_dev);

  What do you think?

> If the currently running transaction is the requested target, then
> that's easy; we can set the flag, and then wake up the j_wait_commit
> wait queue.  
> 
> In any case, log_start_commit() doesn't currently distinguish between
> whether the targetted commit is the running or the committing
> transaction when it returns 0, and I think that's a problem.
  Yeah, I agree this is a problem and it could cause ext4_sync_file not
properly wait. The simplest fix is to call jbd2_log_wait_commit
unconditionally. But I'd maybe go with the above approach.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
