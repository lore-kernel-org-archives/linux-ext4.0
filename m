From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd2: Fix forever sleeping process in
 do_get_write_access()
Date: Thu, 5 May 2011 16:11:14 +0200
Message-ID: <20110505141114.GG5323@quack.suse.cz>
References: <1304597439-7185-1-git-send-email-jack@suse.cz>
 <4DC2AADA.9070708@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, tytso@mit.edu, Tao Ma <tm@tao.ma>,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35367 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755199Ab1EEOL0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 May 2011 10:11:26 -0400
Content-Disposition: inline
In-Reply-To: <4DC2AADA.9070708@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 05-05-11 08:49:14, Eric Sandeen wrote:
> On 5/5/11 7:10 AM, Jan Kara wrote:
> > In do_get_write_access() we wait on BH_Unshadow bit for buffer to get
> > from shadow state. The waking code in journal_commit_transaction() has
> > a bug because it does not issue a memory barrier after the buffer is moved
> > from the shadow state and before wake_up_bit() is called. Thus a waitqueue
> > check can happen before the buffer is actually moved from the shadow state
> > and waiting process may never be woken. Fix the problem by issuing proper
> > barrier.
> 
> needed for jbd/commit.c as well, I guess?
  Yes, I was already queued in my tree. I just sent it to the list as well.

								Honza
> > diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> > index 2e5d370..3a958c7 100644
> > --- a/fs/jbd2/commit.c
> > +++ b/fs/jbd2/commit.c
> > @@ -768,8 +768,13 @@ wait_for_iobuf:
> >                     required. */
> >  		JBUFFER_TRACE(jh, "file as BJ_Forget");
> >  		jbd2_journal_file_buffer(jh, commit_transaction, BJ_Forget);
> > -		/* Wake up any transactions which were waiting for this
> > -		   IO to complete */
> > +		/*
> > +		 * Wake up any transactions which were waiting for this IO to
> > +		 * complete. The barrier must be here so that changes by
> > +		 * jbd2_journal_file_buffer() take effect before wake_up_bit()
> > +		 * does the waitqueue check.
> > +		 */
> > +		smp_mb();
> >  		wake_up_bit(&bh->b_state, BH_Unshadow);
> >  		JBUFFER_TRACE(jh, "brelse shadowed buffer");
> >  		__brelse(bh);
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
