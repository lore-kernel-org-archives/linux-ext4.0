From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd: fix assertion failure in journal_next_log_block
Date: Tue, 5 Feb 2008 18:27:31 +0100
Message-ID: <20080205172731.GD29130@atrey.karlin.mff.cuni.cz>
References: <20080131161417.GA29679@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756048AbYBER1p@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080131161417.GA29679@unused.rdu.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hello,

  Sorry for replying a bit late but I'm currently falling behind in
maling-list reading...

> The way jbd tries to determine if there is enough space left on the journal in
> order to start a new transaction is looking at the space left in the journal and
> the space needed for the committing transaction, which is 1/4 of the journal +
> the number of t_outstanding_credits for that transaction.  In this case its
> assumed that t_outstanding_credits accurately represents the number of credits
  Yes.

> waiting to be written to the journal, but this sometimes isn't the case.  The
> transaction has two counters for buffers, t_outstanding_credits which is used in
> conjunction with handles that are added to the transaction, and t_nr_buffers
> which is only incremented/decremented when buffers are added/removed from the
> transaction and are actually destined to be journaled.  Normally these two
  t_nr_buffers actually represents number of buffers on BJ_Metadata list
and nobody uses it (except for the assertion in
__journal_temp_unlink_buffer()). t_outstanding_credits is supposed to be *the*
counter making sure we don't write more than we have credits for.

> counters are the same, however there are cases where the committing transaction
> can have buffers moved to the next running transaction, for example any buffers
> on the committing transactions t_reserved list would be moved to the next
> (running) transaction, and if it had been dirtied in the process it would
> immediately make it onto the t_updates list, which would increment t_nr_buffers
  You probably mean t_buffers list here...
> but not t_outstanding_credits.  So you get into this situation where
  But which moving and dirtying do you mean? The caller which dirties
the buffer must make sure that he has acquired enough credits for the
transaction where the buffer ends up... So if there were not enough
buffers in the running transaction where we refiled the buffer it is a
bug in the caller which dirties the buffer.

> t_nr_buffers (the actual number of buffers that are on the transaction) is
> greater than the number of buffers accounted for via t_outstanding_credits.
> This presents a problem since as we loop through writting buffers to the
> journal, we decrement t_outstanding_credits, and if t_nr_buffers is more than
> t_outstanding_credits then we end up with a negative number for
> t_outstanding_credits, which means we start saying we need less than 1/4 of the
> journal for our committing transaction and allow more transactions than we can
> handle to start, and then bam we fail because journal_next_log_block doesn't
> have enough free blocks in order to handle the request.  This has been tested
> and fixes the issue (which could not be reproduced by me but several other
> people could get it to reproduce using postmark), and although I couldn't
> reproduce the assertion, I could very easily reproduce the situation where
> t_outstanding_credits was < than t_nr_buffers.
  I suppose you see the assertion J_ASSERT(journal->j_free > 1); to
fail, right? I don't see how your patch could help avoid that assertion.
You've just removed accounting of t_outstanding_credits which has no
impact on the real number of free blocks in the journal stored in
j_free. Anyway, if you can reproduce t_outstanding_credits <
t_nr_buffers, then there's something fishy. Are you able to reproduce it
also with a current kernel?
  Thanks for looking into the problem :)

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
