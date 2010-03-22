From: tytso@mit.edu
Subject: Re: [PATCH 1/2] ext4/jbd2: fix io-barrier logic in case of
 external journal
Date: Mon, 22 Mar 2010 11:03:42 -0400
Message-ID: <20100322150342.GG11560@thunk.org>
References: <1268414810-17289-1-git-send-email-dmonakhov@openvz.org>
 <20100322012000.GD11560@thunk.org>
 <87iq8o4fmk.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59634 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750861Ab0CVPD6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Mar 2010 11:03:58 -0400
Content-Disposition: inline
In-Reply-To: <87iq8o4fmk.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 22, 2010 at 05:04:19PM +0300, Dmitry Monakhov wrote:
> tytso@mit.edu writes:
> 
> > On Fri, Mar 12, 2010 at 08:26:49PM +0300, Dmitry Monakhov wrote:
> >>  start_journal_io:
> >> +			if (bufs)
> >> +				commit_transaction->t_flushed_data_blocks = 1;
> >> +
> >
> > I'm not convinced this is right.
> >
> > From your test case, the problem isn't because we have journaled
> > metadata blocks (which is what bufs) counts, but because fsync()
> > depends on data blocks also getting flushed out to disks.
> >
> > However, if we aren't closing the transaction because of fsync(), I
> > don't think we need to do a barrier in the case of an external
> > journal.  So instead of effectively unconditionally setting
> > t_flushed_data_blocks (since bufs is nearly always going to be
> > non-zero), I think the better fix is to test to see if the journal
> > device != to the fs data device in fsync(), and if so, start the
> > barrier operation there.
> >
> > Do you agree?
> Yes.

Just to be clear, since I realized I wrote fsync() when I should have
written fs/ext4/fsync.c, my proposal was to put this check in
ext4_sync_file().

> BTW Would it be correct to update j_tail in
> jbd2_journal_commit_transaction() to something more recent
> if we have issued an io-barrier to j_fs_dev?
> This will helps to reduce journal_recovery time which may be really
> painful in some slow devices.

Um, maybe.  We are already calling __jbd2_journal_clean_checkpoint_list(),
and the barrier operation *is* expensive.

On the other hand, updating the journal superblock on every sync is
another seek that would have to made before the barrier operation, and
I'm a bit concerned that this seek would be noticeable.  If it is
noticeable, is it worth it to optimize for the uncommon case (a power
failure requiring a journal replay) when it might cost us something,
however, small, on every single journal update?

Do we really think the journal replay time is really something that is
a major pain point.  I can think of optimizations that involve
skipping writes that will get updated later in future transactions,
but it means complicating the replay code, which has been stable for a
long time, and it's not clear to me that the costs are worth the
benefits.

> I've take a look at async commit logic: fs/jbd2/commit.c
> void jbd2_journal_commit_transaction(journal_t *journal)
> {
> 725:    /* Done it all: now write the commit record asynchronously. */
>         if (JBD2_HAS_INCOMPAT_FEATURE(journal,
>                                       JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT))
>                                       {
>                 err = journal_submit_commit_record(journal,
>                 commit_transaction,
>                                                  &cbh, crc32_sum);
>                 if (err)
>                         __jbd2_journal_abort_hard(journal);
>                 if (journal->j_flags & JBD2_BARRIER)
>                         blkdev_issue_flush(journal->j_dev, NULL);
> <<< blkdev_issue_flush is wait for barrier to complete by default, but
> <<< in fact we don't have to wait for barrier here. I've prepared a
> <<< patch wich add flags to control blkdev_issue_flush() wait
> <<< behavior, and this is the place for no-wait variant.

I think that's right, as long as we're confident that subsequent
writes won't get scheduled before the no-wait barrier.  If it did, it
would be a bug in the block I/O layer, so it should be OK.

      	       	      	    	- Ted
 
