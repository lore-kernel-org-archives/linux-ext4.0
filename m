From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd2: Optimize jbd2_log_do_checkpoint() a bit
Date: Wed, 3 Sep 2014 18:03:26 +0200
Message-ID: <20140903160326.GB17066@quack.suse.cz>
References: <1409678310-11646-1-git-send-email-jack@suse.cz>
 <20140902215930.GJ6232@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38840 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756418AbaICQDb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Sep 2014 12:03:31 -0400
Content-Disposition: inline
In-Reply-To: <20140902215930.GJ6232@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 02-09-14 17:59:30, Ted Tso wrote:
> On Tue, Sep 02, 2014 at 07:18:30PM +0200, Jan Kara wrote:
> > When we discover written out buffer in transaction checkpoint list we
> > don't have to recheck validity of a transaction. Either this is the last
> > buffer in a transaction - and then we are done - or this isn't and then
> > we can just take another buffer from the checkpoint list without
> > dropping j_list_lock.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/jbd2/checkpoint.c | 13 ++++++++-----
> >  1 file changed, 8 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
> > index 993a187527f3..3722e2e53638 100644
> > --- a/fs/jbd2/checkpoint.c
> > +++ b/fs/jbd2/checkpoint.c
> > @@ -343,12 +343,15 @@ restart:
> >  		if (!buffer_dirty(bh)) {
> >  			if (unlikely(buffer_write_io_error(bh)) && !result)
> >  				result = -EIO;
> > -			get_bh(bh);
> >  			BUFFER_TRACE(bh, "remove from checkpoint");
> > -			__jbd2_journal_remove_checkpoint(jh);
> > -			spin_unlock(&journal->j_list_lock);
> > -			__brelse(bh);
> 
> Currently, all of the places which call
> __jbd2_jouranl_remove_checkpoint(jh) are doing so with an elevated
> b_count.  For example, see __try_to_free_cp_buf().
  I did a bit of archeology and commit
932bb305ba2a01cd62809644d569f004e77a4355 removed the need to hold buffer
reference when calling __jbd2_journal_remove_checkpoint(). So it should be
safe to remove that reference handling also from __try_to_free_cp_buf().

> After doing a lot of desk checking, I can't see any reason for holding
> the elevanted b_count, so I think it should be to remove it, but then
> we can simplify the other uses __try_to_free_cp_buf().  For example,
> in the loop that I folded from __wait_cp_io, we could drop the done
> variable and change:
> 
> 		done = __jbd2_journal_remove_checkpoint(jh);
> 		__brelse(bh);
> 
> to this:
> 
> 		__brelse(bh);
> 		if (__jbd2_journal_remove_checkpoint(jh))
> 			break;
  Well, we don't even need to grab bh reference unless we find the buffer
is locked and are going to wait for it. And yes, we can get rid of that
'done' variable.

> How much testing have you done of this optimization?  I'm tempted to
> try nuking all of the elevated b_counts around the call to
> __jbd2_journal_remove_checkpoint(), and then doing a test to see if
> anything blows up.
  Honestly, I didn't test much but I'm pretty confident we are safe to
remove those bh refs ;)

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
