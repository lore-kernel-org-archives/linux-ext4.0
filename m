From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd2: Silence warnings about non-uptodate buffers
Date: Thu, 29 May 2008 15:09:35 +0200
Message-ID: <20080529130935.GC29602@duck.suse.cz>
References: <12120117733479-git-send-email-jack@suse.cz> <12120117743119-git-send-email-jack@suse.cz> <20080528205913.10c31851.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:52120 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752507AbYE2NJg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 29 May 2008 09:09:36 -0400
Content-Disposition: inline
In-Reply-To: <20080528205913.10c31851.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 28-05-08 20:59:13, Andrew Morton wrote:
> On Wed, 28 May 2008 23:56:12 +0200 Jan Kara <jack@suse.cz> wrote:
> 
> > When underlying block device becomes unavailable (e.g. someone pulling an
> > USB stick from under us), kernel produces warning about non-uptodate buffer
> > (superblock) being marked dirty. Silence these warnings by making buffer
> > uptodate before marking it dirty.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/jbd2/journal.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> > index 2e24567..55de8f7 100644
> > --- a/fs/jbd2/journal.c
> > +++ b/fs/jbd2/journal.c
> > @@ -1261,6 +1261,7 @@ void jbd2_journal_update_superblock(journal_t *journal, int wait)
> >  	spin_unlock(&journal->j_state_lock);
> >  
> >  	BUFFER_TRACE(bh, "marking dirty");
> > +	set_buffer_uptodate(bh);
> >  	mark_buffer_dirty(bh);
> >  	if (wait)
> >  		sync_dirty_buffer(bh);
> 
> I have issues....
> 
> - Are we really really sure that we aren't about to wreck people's
>   filesystems when this happens?  I mean, a non-uptodate buffer might
>   have random garbage in it, and it would be sad to write that to disk.
  Well, as far as I've looked into the code, we already write the buffer
anyway. So far we just warned that we are writing non-uptodate buffer. So
in this regard, I don't think there's any difference with/without my patch.

>   Either way, I do think that potentially falsely setting BH_Uptodate
>   just to squish a WARN_ON_ONCE() is not a good solution.  Better to
>   set a new BH_Nowarn, or to call a new mark_buffer_dirty_nowarn() here.
> 
> - Did the reads of these buffers encounter an IO error?  If so,
>   perhaps we could set a new BH_GotIOError or something.
  I've changed only the "superblock buffers". Those have the property that
we read that just once during mount (and if this fails, we won't try to
write them anyway), keep pointer to them and occasionally try to write
them. Also we shouldn't really have garbage in them - they can be !uptodate
only because underlying device was not able to write them... For most other
buffers, when we fail to read them, we just bail out and don't try marking
them dirty, so we don't issue warning for them.

> Even if I'm completely wrong about everything as usual, I do think that
> the code change should at least include a comment explaining why the
> filesystem is doing set_buffer_uptodate() in such a weird place.
  Agreed, I'll add some comment to the code.

> One nice way of adding that comment would be to implement a new
> 
> /*
>  * comment goes here
>  */
> set_buffer_uptodate_for_mark_buffer_dirty(struct buffer_head *bh); /* needs better name */
> 
> and call that.
> 
> But I agree with me: this looks like abuse of buffer_uptodate(), and a
> mark_buffer_dirty_nowarn() would be a cleaner solution.
  OK. I've thought about one more option - if buffer isn't uptodate, just
avoid marking it dirty and writing it. That has the advantage that if the
spotted error is real bad block, then we won't retry writing it which
usually takes non-trivial time. But at the same time it is a disadvantage
because in case there's a transient error writing super-block, we'd never
retry writing it. So I decided to keep the current behavior...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
