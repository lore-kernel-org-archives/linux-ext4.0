From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd: Remove j_barrier mutex
Date: Mon, 2 Jan 2012 20:49:45 +0100
Message-ID: <20120102194945.GD3626@quack.suse.cz>
References: <1324562865-4720-1-git-send-email-jack@suse.cz>
 <20111227185100.GA30094@dhcp-172-17-9-228.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, akmp@suse.cz,
	rjw@sisk.pl, Andrew Morton <akpm@linux-foundation.org>
To: Joel Becker <jlbec@evilplan.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59131 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251Ab2ABTts (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Jan 2012 14:49:48 -0500
Content-Disposition: inline
In-Reply-To: <20111227185100.GA30094@dhcp-172-17-9-228.mtv.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 27-12-11 10:51:00, Joel Becker wrote:
> On Thu, Dec 22, 2011 at 03:07:45PM +0100, Jan Kara wrote:
> > j_barrier mutex is used for serializing different journal lock operations.  The
> > problem with it is that e.g. FIFREEZE ioctl results in process leaving kernel
> > with j_barrier mutex held which makes lockdep freak out. Also hibernation code
> > wants to freeze filesystem but it cannot do so because it then cannot hibernate
> > the system because of mutex being locked.
> > 
> > So we remove j_barrier mutex and use direct wait on j_barrier_count instead.
> > Since locking journal is a rare operation we don't have to care about fairness
> > or such things.
> > 
> > CC: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> Strikes me as pretty reasonable.
> 
> >  void journal_lock_updates(journal_t *journal)
> >  {
> >  	DEFINE_WAIT(wait);
> >  
> > +wait:
> > +	/* Wait for previous locked operation to finish */
> > +	wait_event(journal->j_wait_transaction_locked,
> > +		   journal->j_barrier_count == 0);
> > +
> >  	spin_lock(&journal->j_state_lock);
> > +	/*
> > +	 * Check reliably under the lock whether we are the ones winning the race
> > +	 * and locking the journal
> > +	 */
> > +	if (journal->j_barrier_count > 0) {
> > +		spin_unlock(&journal->j_state_lock);
> > +		goto wait;
> > +	}
> 
> I suppose I'd prefer:
> 
> 	do {
> 		wait_event(journal->j_wait_transaction_locked,
> 			   journal->j_barrier_count == 0);
> 
> 		spin_lock(&journal->j_state_lock);
> 		if (journal->j_barrier_count == 0)
> 			break;
> 		spin_unlock(&journal->j_state_lock);
> 	} while (1);
>   	++journal->j_barrier_count;
> 
> because I hate using goto for trivial loops, but that's a nitpick.
  Frankly, I'm more used to parsing simple goto loops like mine than
infinite-loop + break statements in cases like this. So I'll take the
liberty of being a maintainer and keep the goto. But thanks for the
suggestion anyway.

> ACK.
  Thanks for review!

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
