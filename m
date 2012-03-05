From: Jan Kara <jack@suse.cz>
Subject: Re: [linux-pm] [Patch] JBD and JBD2 missing set_freezable()
Date: Mon, 5 Mar 2012 11:28:00 +0100
Message-ID: <20120305102800.GB6643@quack.suse.cz>
References: <4F2BA1FD.3030302@tuxonice.net>
 <201203042351.07405.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-pm@lists.linux-foundation.org,
	Nigel Cunningham <nigel@tuxonice.net>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38380 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756469Ab2CEK2D (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Mar 2012 05:28:03 -0500
Content-Disposition: inline
In-Reply-To: <201203042351.07405.rjw@sisk.pl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun 04-03-12 23:51:07, Rafael J. Wysocki wrote:
> On Friday, February 03, 2012, Nigel Cunningham wrote:
> > Hi all.
> > 
> > With the latest and greatest changes to the freezer, I started seeing
> > panics that were caused by jbd2 running post-process freezing and
> > hitting the canary BUG_ON for non-TuxOnIce I/O submission. I've traced
> > this back to a lack of set_freezable calls in both jbd and jbd2. Since
> > they're clearly meant to be frozen (there are tests for freezing()), I
> > submit the following patch to add the missing calls.
> > 
> > Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>
> 
> Well, I wonder what the filesystems people think about that.
  Nigel is right that threads are meant to be freezable. If below patch
is needed for that, you have my ack.

  Just two notes:
1) Freezing the journal thread will effectively block filesystem activity
(not immediately but once transaction fills up) so you should better make
sure you don't need to do anything with the filesystem after freezing the
thread.

2) Is freezing journal thread still needed when we freeze filesystem in
suspend code? Because no IO should happen once filesystem is frozen...

								Honza
> 
> Thanks,
> Rafael
> 
> 
> > diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
> > index 59c09f9..89cd985 100644
> > --- a/fs/jbd/journal.c
> > +++ b/fs/jbd/journal.c
> > @@ -129,6 +129,8 @@ static int kjournald(void *arg)
> >  	setup_timer(&journal->j_commit_timer, commit_timeout,
> >  			(unsigned long)current);
> > 
> > +	set_freezable();
> > +
> >  	/* Record that the journal thread is running */
> >  	journal->j_task = current;
> >  	wake_up(&journal->j_wait_done_commit);
> > diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> > index c0a5f9f..663e47c 100644
> > --- a/fs/jbd2/journal.c
> > +++ b/fs/jbd2/journal.c
> > @@ -139,6 +139,8 @@ static int kjournald2(void *arg)
> >  	setup_timer(&journal->j_commit_timer, commit_timeout,
> >  			(unsigned long)current);
> > 
> > +	set_freezable();
> > +
> >  	/* Record that the journal thread is running */
> >  	journal->j_task = current;
> >  	wake_up(&journal->j_wait_done_commit);
> > 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
