From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH -v2 1/3] jbd2: Use atomic variables to avoid taking
 t_handle_lock in jbd2_journal_stop
Date: Thu, 12 Aug 2010 00:16:24 +0200
Message-ID: <20100811221624.GC14762@quack.suse.cz>
References: <1280939957-3277-1-git-send-email-tytso@mit.edu>
 <1280939957-3277-2-git-send-email-tytso@mit.edu>
 <20100809170216.GB31969@atrey.karlin.mff.cuni.cz>
 <20100809190513.GF3635@thunk.org>
 <20100809194554.GB5356@quack.suse.cz>
 <20100810163046.GM3635@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	ocfs2-devel@oss.oracle.com, John Stultz <johnstul@us.ibm.com>,
	Keith Maanthey <kmannth@us.ibm.com>,
	Eric Whitney <eric.whitney@hp.com>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53307 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756550Ab0HKWSz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Aug 2010 18:18:55 -0400
Content-Disposition: inline
In-Reply-To: <20100810163046.GM3635@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 10-08-10 12:30:46, Ted Ts'o wrote:
> On Mon, Aug 09, 2010 at 09:45:55PM +0200, Jan Kara wrote:
> >   Ah, OK. You're right. I just thought we eventually want to remove the
> > lock but you're right that currently the code is fine. Sorry for the noise.
> 
> I would love to get rid of the j_state_lock, but looking through the
> code, I couldn't figure out how to do this safely.  Hence my
> conversion of the j_state_lock to a rwlock_t, with the downside of
> this causing more cache line bounces.  If someone can suggest a way to
> drop needing a global spinlock (whether it is an exclusive or rwlock)
> in start_this_handle(), I'd love to hear them.
  Thinking about this, I think there's a way:
1) Make transaction structures freed by RCU so when we get transaction
pointer from a journal we can operate on it without being afraid of
touching freed structure.
2) Increment t_updates count before doing anything else - with this, we are
sure that if a transaction is in LOCKED state or in some earlier state, it
won't proceed further before we drop our reference.
3) smp_mb() to get values from transaction structure after the ref count
increase.
4) Check that the transaction is actually running and  has enough credits.
5) The check
        if (__jbd2_log_space_left(journal) < jbd_space_needed(journal)) {
   seems just useless if you look at it more in detail. It just transforms
   to
     7/8*(journal->j_free-32) < journal->j_max_transaction_buffers +
                 journal->j_committing_transaction->t_outstanding_credits
   So it just doesn't seem to make sense to call it whenever we get a
handle. It should be enough to do the check only when we really start a
new transaction. If it is satisfied at that moment, it should be satisfied
during the whole lifetime of a transaction.

  This should make the fast path (when a transaction does not need to be
started) of start_this_handle() lockless. Of course when any of the checks
fails, we have to bite the bullet and take the lock.
  I can have a look into transforming this ideas into a patch but I'm not
sure when I get to it...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
