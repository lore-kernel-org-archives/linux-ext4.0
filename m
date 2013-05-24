From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/4] jbd2: make shure that we do not miss aborted state
Date: Fri, 24 May 2013 15:09:07 +0200
Message-ID: <20130524130907.GA11493@quack.suse.cz>
References: <1368707290-26185-1-git-send-email-dmonakhov@openvz.org>
 <1368707290-26185-3-git-send-email-dmonakhov@openvz.org>
 <20130521162114.GF11616@quack.suse.cz>
 <87mwrn75gt.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50678 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754860Ab3EXNJK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 May 2013 09:09:10 -0400
Content-Disposition: inline
In-Reply-To: <87mwrn75gt.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 22-05-13 13:02:10, Dmitry Monakhov wrote:
> On Tue, 21 May 2013 18:21:14 +0200, Jan Kara <jack@suse.cz> wrote:
> > On Thu 16-05-13 16:28:09, Dmitry Monakhov wrote:
> > > 
> > > Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> >   Can you elaborate a bit more on how the aborted state could be missed so
> > that it would cause any problems?
> Fairly to say this was fix of hypothetical issue.
> Since we  j_state_lock goes trough lock/unlock after wait_event()
> we should not miss an error for the certain tid we are interested in.
> But this patch makes code looks cleaner. 
  Well, we often check is_journal_aborted() without holding any lock so
moving it inside the lock in this case doesn't make much sence to me. So at
least for jbd I'm not inclined to take it as it seems as an unnecessary
churn. For jbd2 it's Ted's choice...

								Honza

> > > ---
> > >  fs/jbd2/journal.c |    3 +--
> > >  1 files changed, 1 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> > > index 886ec2f..57b9120 100644
> > > --- a/fs/jbd2/journal.c
> > > +++ b/fs/jbd2/journal.c
> > > @@ -700,12 +700,11 @@ int jbd2_log_wait_commit(journal_t *journal, tid_t tid)
> > >  				!tid_gt(tid, journal->j_commit_sequence));
> > >  		read_lock(&journal->j_state_lock);
> > >  	}
> > > -	read_unlock(&journal->j_state_lock);
> > > -
> > >  	if (unlikely(is_journal_aborted(journal))) {
> > >  		printk(KERN_EMERG "journal commit I/O error\n");
> > >  		err = -EIO;
> > >  	}
> > > +	read_unlock(&journal->j_state_lock);
> > >  	return err;
> > >  }
> > >  
> > > -- 
> > > 1.7.1
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > -- 
> > Jan Kara <jack@suse.cz>
> > SUSE Labs, CR
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
