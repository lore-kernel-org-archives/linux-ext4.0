From: Josef Bacik <jbacik@redhat.com>
Subject: Re: [RFC][PATCH] fix journal overflow problem
Date: Fri, 22 Feb 2008 11:51:50 -0500
Message-ID: <200802221151.50732.jbacik@redhat.com>
References: <200802211358.56015.jbacik@redhat.com> <20080222100847.GB12908@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:49497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759804AbYBVRBq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Feb 2008 12:01:46 -0500
In-Reply-To: <20080222100847.GB12908@duck.suse.cz>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Friday 22 February 2008 5:08:47 am Jan Kara wrote:
>   Hello,
>
> On Thu 21-02-08 13:58:55, Josef Bacik wrote:
> > This is related to that jbd patch I sent a few weeks ago.  I originally
> > found that the problem where t_nr_buffers would be > than
> > t_outstanding_credits wouldn't happen upstream, but apparently I'm an
> > idiot and I was just missing my messsages, and the problem does exist.
> > Now for the entirely too long of a description of whats going wrong.
> >
> > Say we have a transaction dirty a bitmap buffer and go to flush it to the
> > disk.  Then ext3 goes to get write access to that buffer via
> > journal_get_undo_access(), finds out it doesn't need it, and then
> > subsequently does a journal_release_buffer() and then proceeds to never
> > touch that buffer again.  Then the original committing transaction will
> > go through and add its buffers to the checkpointing list, and refile the
> > buffer.  Because we did a journal_get_undo_access(), the
> > jh->b_next_transaction is set to our currently running transaction, and
> > that buffer because it was set BH_JBDDirty by the committing transaction
> > is filed onto the running transactions BJ_Metadata list, which increments
> > our t_nr_buffers counter.  Because we never actually dirtied this buffer
> > ourselves, we never accounted for the credit, and we end up with
> > t_outstanding_credits being less than t_nr_buffers.
>
>   Thanks for the debugging. You're right that such situation can happen
> and we then miscount the transactions credits. Actually, we miscount the
> credits whenever we do journal_get_write_access() on a jbd_dirty buffer
> that isn't yet in our transaction and don't call journal_dirty_metadata()
> later.
>

Right.

> > This is a problem because while we are writing out the metadata blocks to
> > the journal, we do a t_outstanding_credits-- for each buffer.  If
> > t_outstanding_credits is less than the number of buffers we have then
> > t_outstanding_credits will eventually become negative, which means that
> > jbd_space_needed will eventually start saying it needs way less credits
> > than it actually does, and will allow transactions to grow huge and
> > eventually we'll overflow the journal (albeit this is a bitch to try and
> > reproduce).
>
>   Yes, actually, how much negative t_outstanding_credits grow? I'd expect
> that this is not too common situation...
>

I've seen it get to where we have like 300 extra buffer heads, which by itself 
isn't bad, but you get a couple of transactions who are allowed to grow to 300 
more buffers than what they normally would and things go boom.  But you are 
right, its not too common of a situation, for the most part it just works, and 
only screws the handfull of people who can hit it every time.

> > So my approach is to have a counter that is incremented each time the
> > transaction calls do_get_write_access (or journal_get_create_access) so
> > we can keep track of how many people are currently trying to modify that
> > buffer.  So in the case where we do a
> > journal_get_undo_access()+journal_release_buffer() and nobody else ever
> > touches the buffer, we can then set jh->b_next_transaction to NULL in
> > journal_release_buffer() and avoid having the buffer filed onto our
> > transaction.  If somebody else is modifying the journal head then we know
> > to leave it alone because chances are it will be dirtied and the credit
> > will be accounted for.
>
>   But the race is still possibly there in case we refile the buffer from
> t_forget list just between do_get_write_access() and
> journal_release_buffer(), isn't it?
>   And it would be quite hard to get rid of such races. So maybe how about
> the following: In do_get_write_access() (or journal_get_create_access())
> when we see the buffer is jbddirty and we set j_next_transaction to our
> transaction, we also set j_modified to 1. That should fix the accounting of
> transaction credits. I agree that sometimes we needlessly refile some
> buffers from the previous transaction but as I said above, it shouldn't be
> that much (and we did it up to now anyway).
>

The only problem with this approach is we end up using credits we can't really 
afford.  So for example, we have gotten write access for several different 
bitmap blocks trying to find room to allocate (and therefore decremented 
h_buffer_credits in order to account for those buffers which will be refiled 
onto the transaction later), and then we end up overflowing the handle because 
ext3 only accounted for having to use 1 credit for modifying 1 bitmap, and we 
assert when h_buffer_credits goes negative.

Instead what if in __journal_refile_buffer instead of checking buffer_jbddirty 
to see if it was dirty, instead just check j_modified, and if j_modified is 1 
then go ahead and file it onto b_next_transaction's BJ_Metadata list, and if 
not put it on b_next_transaction's BJ_Reserved list.  So if we do end up 
dirtying it the credit is accounted for, and we move it appropriately, and if 
we don't end up modifying it, the credit doesn't get accounted for and it stays 
on the reserved list and gets unlinked at the begginning of b_next_transactions 
commit phase.  How does that sound?

> > There is also a slight change to how we reset b_modified.  I originally
> > reset b_nr_access (my access counter) in the same way b_modified was
> > reset, but I didn't really like this because we were only taking the
> > j_list_lock instead of the jbd_buffer lock, so we could race and still
> > end up in the same situation (which is in fact what happened).  So I've
>
>   Yes, that is a good catch.
>
> > changed how we reset b_modified.  Instead of looping through all of the
> > buffers for the transaction, which is a little innefficient anyway, we
> > reset it in do_get_write_access in the cases where we know that this is
> > the first time that this transaction has accessed the buffer (ie when
> > b_next_transaction != transaction && b_transaction != transaction).  I
> > reset b_nr_access in the same way.  I ran tests with this patch and
> > verified that we no longer got into the situation where
> > t_outstanding_credits was less than t_nr_buffers.
> >
> > This is just my patch that I was using, I plan on cleaning it up if this
> > is an acceptable way to fix the problem.  I'd also like to put an ASSERT
> > before we process the t_buffers list for the case where
> > t_outstanding_credits is less than t_nr_buffers.  If my particular
> > solution isn't acceptable I'm open to suggestions, however I still think
> > that resetting b_modified should be changed the way I have it as its a
> > potential race condition and innefficient.  Thanks much,
>
>   I agree with the b_modified change, but please send it as a separate
> patch. For the credit accounting I'd rather go by the route I've suggested
> above.
>

Sounds good I will do that.  Thanks much,

Josef
