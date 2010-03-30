From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] ext4/jbd2: fix io-barrier logic in case of
	external journal
Date: Tue, 30 Mar 2010 03:47:00 +0200
Message-ID: <20100330014700.GD18791@atrey.karlin.mff.cuni.cz>
References: <1268414810-17289-1-git-send-email-dmonakhov@openvz.org> <20100322012000.GD11560@thunk.org> <87iq8o4fmk.fsf@openvz.org> <20100322150342.GG11560@thunk.org> <87d3yw49m2.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ksp.mff.cuni.cz ([195.113.26.206]:60670 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754447Ab0C3BrC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Mar 2010 21:47:02 -0400
Content-Disposition: inline
In-Reply-To: <87d3yw49m2.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> tytso@mit.edu writes:
> 
> > On Mon, Mar 22, 2010 at 05:04:19PM +0300, Dmitry Monakhov wrote:
> >> tytso@mit.edu writes:
> >> 
> >> > On Fri, Mar 12, 2010 at 08:26:49PM +0300, Dmitry Monakhov wrote:
> >> >>  start_journal_io:
> >> >> +			if (bufs)
> >> >> +				commit_transaction->t_flushed_data_blocks = 1;
> >> >> +
> >> >
> >> > I'm not convinced this is right.
> >> >
> >> > From your test case, the problem isn't because we have journaled
> >> > metadata blocks (which is what bufs) counts, but because fsync()
> >> > depends on data blocks also getting flushed out to disks.
> >> >
> >> > However, if we aren't closing the transaction because of fsync(), I
> >> > don't think we need to do a barrier in the case of an external
> >> > journal.  So instead of effectively unconditionally setting
> >> > t_flushed_data_blocks (since bufs is nearly always going to be
> >> > non-zero), I think the better fix is to test to see if the journal
> >> > device != to the fs data device in fsync(), and if so, start the
> >> > barrier operation there.
> >> >
> >> > Do you agree?
> >> Yes.
> >
> > Just to be clear, since I realized I wrote fsync() when I should have
> > written fs/ext4/fsync.c, my proposal was to put this check in
> > ext4_sync_file().
> This means that we will end up with two io-barriers in a row
> for external journal case:
> ext4_sync_file()
>   ->jbd2_log_start_commit()
>      ->blkdev_issue_flush(j_fs_dev)
>   /* seems following flush is mandatory to guarantee the metadata
>    * consistency */
>   ->blkdev_issue_flush(j_fs_dev)
> 
> may be it will be better to pass some sort of barrier flag to
> jbd2_log_start_commit() this function mark journal->j_commit_request
> with ->t_flushed_data_blocks = 1, so io-carrier will be issued
> even if transaction has only metadata
> Advantages:
> 1) approach will works for all data modes
> 2) only one io-barrier is needed to guarantee the data and
>    metadata consiscency.
> 3) changes not so complicated.
> 
> I've already started to work with the patch but was surprised with
> commit logic. 
> ->__jbd2_log_start_commit(target)
>    journal->j_commit_request = target
>    ->wake_up(&journal->j_wait_commit)
> ->kjournald2
>    transaction = journal->j_running_transaction
>    ->jbd2_journal_commit_transaction(journal);
>      commit_transaction = journal->j_running_transaction
>      ...
>      /* So j_commit_request is used only for comparison. But actually
>         committing journal->j_running_transaction->t_tid transaction
>         instead of j_commit_request. Why?
>       */
  Remember: There is always at most one running transaction and at most one
transaction in the committing state - all the JBD2 and ext4 code heavily relies
on this. So in this case, because kjournald isn't committing any transaction,
we know that there is no committing transaction and at most one running
transaction whose tid = journal->j_commit_sequence + 1. So actually the only
trasaction we can commit is the running one and it does not even make sence to
try committing another one (the check in log_start_commit actually makes sure
that j_commit_request cannot be set to a lower value than it is and the code in
kjournald2 makes sure that j_commit_request >= j_commit_sequence.  So I think
the code works right (although I agree it's hard to read - it's an old legacy
;).

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
