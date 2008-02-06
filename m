From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] jbd: fix assertion failure in journal_next_log_block
Date: Wed, 06 Feb 2008 10:47:17 -0800
Message-ID: <1202323637.4112.6.camel@localhost.localdomain>
References: <20080131161417.GA29679@unused.rdu.redhat.com>
	 <20080205172731.GD29130@atrey.karlin.mff.cuni.cz>
	 <200802051359.05758.jbacik@redhat.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48073 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753033AbYBFSrR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Feb 2008 13:47:17 -0500
In-Reply-To: <200802051359.05758.jbacik@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 2008-02-05 at 13:59 -0500, Josef Bacik wrote:
> On Tuesday 05 February 2008 12:27:31 pm Jan Kara wrote:
> >   Hello,
> >
> >   Sorry for replying a bit late but I'm currently falling behind in
> > maling-list reading...
> >
> > > The way jbd tries to determine if there is enough space left on the
> > > journal in order to start a new transaction is looking at the space left
> > > in the journal and the space needed for the committing transaction, which
> > > is 1/4 of the journal + the number of t_outstanding_credits for that
> > > transaction.  In this case its assumed that t_outstanding_credits
> > > accurately represents the number of credits
> >
> >   Yes.
> >
> > > waiting to be written to the journal, but this sometimes isn't the case. 
> > > The transaction has two counters for buffers, t_outstanding_credits which
> > > is used in conjunction with handles that are added to the transaction,
> > > and t_nr_buffers which is only incremented/decremented when buffers are
> > > added/removed from the transaction and are actually destined to be
> > > journaled.  Normally these two
> >
> >   t_nr_buffers actually represents number of buffers on BJ_Metadata list
> > and nobody uses it (except for the assertion in
> > __journal_temp_unlink_buffer()). t_outstanding_credits is supposed to be
> > *the* counter making sure we don't write more than we have credits for.
> >
> > > counters are the same, however there are cases where the committing
> > > transaction can have buffers moved to the next running transaction, for
> > > example any buffers on the committing transactions t_reserved list would
> > > be moved to the next (running) transaction, and if it had been dirtied in
> > > the process it would immediately make it onto the t_updates list, which
> > > would increment t_nr_buffers
> >
> >   You probably mean t_buffers list here...
> >
> > > but not t_outstanding_credits.  So you get into this situation where
> >
> >   But which moving and dirtying do you mean? The caller which dirties
> > the buffer must make sure that he has acquired enough credits for the
> > transaction where the buffer ends up... So if there were not enough
> > buffers in the running transaction where we refiled the buffer it is a
> > bug in the caller which dirties the buffer.
> >
> 
> You know now that you say that I feel like an idiot, you are right the only way 
> for something to actually end up on that list was if somebody dirtied it and if 
> they did it would have had to been accounted for at some point on the running 
> transaction.
> 
> > > t_nr_buffers (the actual number of buffers that are on the transaction)
> > > is greater than the number of buffers accounted for via
> > > t_outstanding_credits. This presents a problem since as we loop through
> > > writting buffers to the journal, we decrement t_outstanding_credits, and
> > > if t_nr_buffers is more than t_outstanding_credits then we end up with a
> > > negative number for
> > > t_outstanding_credits, which means we start saying we need less than 1/4
> > > of the journal for our committing transaction and allow more transactions
> > > than we can handle to start, and then bam we fail because
> > > journal_next_log_block doesn't have enough free blocks in order to handle
> > > the request.  This has been tested and fixes the issue (which could not
> > > be reproduced by me but several other people could get it to reproduce
> > > using postmark), and although I couldn't reproduce the assertion, I could
> > > very easily reproduce the situation where t_outstanding_credits was <
> > > than t_nr_buffers.
> >
> >   I suppose you see the assertion J_ASSERT(journal->j_free > 1); to
> > fail, right? I don't see how your patch could help avoid that assertion.
> > You've just removed accounting of t_outstanding_credits which has no
> > impact on the real number of free blocks in the journal stored in
> > j_free. Anyway, if you can reproduce t_outstanding_credits <
> > t_nr_buffers, then there's something fishy. Are you able to reproduce it
> > also with a current kernel?
> >   Thanks for looking into the problem :)
> >
> 
> Well my patch helped avoid the assertion because t_outstanding_credits was going 
> negative therefore we were letting transactions start when we shouldn't be, and 
> eventually we would end up with too much of the journal in use and we'd assert.  
> Course I can't reproduce where t_outstanding_credits < t_nr_buffers upstream 
> (again I feel like an idiot, should have tested that first).  Thanks for 
> looking at this Jan.
> 
> Mingming, would you mind pulling this patch out of the patch queue please since 
> its wrong?  Thanks much,
> 

Sure, done!

Mingming
