From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH-v2] JBD: Fix race between free buffer and commit trasanction
Date: Sun, 25 May 2008 00:44:47 +0200
Message-ID: <20080524224447.GE20563@atrey.karlin.mff.cuni.cz>
References: <1210947250.3608.18.camel@localhost.localdomain> <1210957976.4231.31.camel@badari-desktop> <1210971693.3608.46.camel@localhost.localdomain> <20080518223739.GB11006@atrey.karlin.mff.cuni.cz> <1211227158.3663.25.camel@localhost.localdomain> <20080519132553.de9b78b0.akpm@linux-foundation.org> <1211234829.3663.39.camel@localhost.localdomain> <1211306575.3664.19.camel@localhost.localdomain> <20080520235303.GB23521@atrey.karlin.mff.cuni.cz> <1211390093.5571.16.camel@BVR-FS.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>, pbadari@us.ibm.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jens Axboe <jens.axboe@oracle.com>
To: Mingming <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [195.113.26.193] ([195.113.26.193]:46177 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750802AbYEXWos (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 24 May 2008 18:44:48 -0400
Content-Disposition: inline
In-Reply-To: <1211390093.5571.16.camel@BVR-FS.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On Wed, 2008-05-21 at 01:53 +0200, Jan Kara wrote:
> > >  fs/jbd/transaction.c |   55 +++++++++++++++++++++++++++++++++++++++++++++++++--
> > >  mm/filemap.c         |    3 --
> > >  2 files changed, 54 insertions(+), 4 deletions(-)
> > > 
> > > Index: linux-2.6.26-rc2/fs/jbd/transaction.c
> > > ===================================================================
> > > --- linux-2.6.26-rc2.orig/fs/jbd/transaction.c	2008-05-11 17:09:41.000000000 -0700
> > > +++ linux-2.6.26-rc2/fs/jbd/transaction.c	2008-05-19 16:16:41.000000000 -0700
> > > @@ -1648,12 +1648,39 @@ out:
> > >  	return;
> > >  }
> > >  
> > > +/*
> > > + * journal_try_to_free_buffers() could race with journal_commit_transaction()
> > > + * The later might still hold the reference count to the buffers when inspecting
> > > + * them on t_syncdata_list or t_locked_list.
> > > + *
> > > + * Journal_try_to_free_buffers() will call this function to
> > > + * wait for the current transaction to finish syncing data buffers, before
> > > + * try to free that buffer.
> > > + *
> > > + * Called with journal->j_state_lock hold.
> > > + */
> > > +static void journal_wait_for_transaction_sync_data(journal_t *journal)
> > > +{
> > > +	transaction_t *transaction = NULL;
> > > +	tid_t tid;
> > > +
> > > +	transaction = journal->j_committing_transaction;
> > > +
> > > +	if (!transaction)
> > > +		return;
> > > +
> > > +	tid = transaction->t_tid;
> > > +	spin_unlock(&journal->j_state_lock);
> > > +	log_wait_commit(journal, tid);
> > > +	spin_lock(&journal->j_state_lock);
> > > +}
> >   What is actually the point of entering the function with j_state_lock
> > held and also keeping it after return? It should be enough to take it
> > and release it just inside this function, shouldn't it?
> > 
> 
> I was worried about the case when we call try_to_free_buffers() again,
> it races with the current transaction commit again. Is it possible? I
> guess the question is whether it is possible to have buffers on the same
> page attached to different transaction.  If so, I think we need to keep
> the journal state lock while retry try_to_free_buffers(), so that the
> retry won't race with the commit transaction again...
  Well, but by the time log_wait_commit() finishes, it may well
happen that a new transaction is already started so your lock doesn't
help you much. And the page you are called on is actually locked, so
noone can really mess with it until you unlock it... So I think you can
just use the lock for obtaining tid and then drop it.

								Honza

PS: For JBD2 you'd need to be a bit more careful because you cannot call
log_wait_commit() while holding page lock (we have reversed locking
order for ext4) - but ordered-mode rewrite patch actually fixes this
problem and I'm going to submit the splitted patches on Monday or
Tuesday (I only need to test them that I didn't do something stupid
while porting them to ext4)...

-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
