From: Josef Bacik <jbacik@redhat.com>
Subject: Re: transaction batching performance & multi-threaded synchronous
	writers
Date: Tue, 15 Jul 2008 10:05:32 -0400
Message-ID: <20080715140532.GB30311@unused.rdu.redhat.com>
References: <487B7B9B.3020001@gmail.com> <20080714165858.GA10268@unused.rdu.redhat.com> <20080715075832.GD6239@webber.adilger.int> <20080715125127.GA30311@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>,
	Ric Wheeler <ricwheeler@gmail.com>, linux-ext4@vger.kernel.org
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:38029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761747AbYGOOYb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Jul 2008 10:24:31 -0400
Content-Disposition: inline
In-Reply-To: <20080715125127.GA30311@unused.rdu.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 15, 2008 at 08:51:27AM -0400, Josef Bacik wrote:
> On Tue, Jul 15, 2008 at 01:58:32AM -0600, Andreas Dilger wrote:
> > On Jul 14, 2008  12:58 -0400, Josef Bacik wrote:
> > > Perhaps we track the average time a commit takes to occur, and then if
> > > the current transaction start time is < than the avg commit time we sleep
> > > and wait for more things to join the transaction, and then we commit.
> > > How does that idea sound?  Thanks,
> > 
> > The drawback of this approach is that if the thread waits an extra "average
> > transaction time" for the transaction to commit then this will increase the
> > average transaction time each time, and it still won't tell you if there
> > needs to be a wait at all.
> >
> 
> I'm not talking about the average transaction life, as you say it would be
> highly dependant on random things that have nothing to do with the transaction
> time (waiting for locks and such).  I'm measuring the time it takes for the
> actual commit to take place, so I record the start time in
> journal_commit_transaction when we set running_transaction = NULL, and then the
> end time right before the wakeup() at the end of journal_commit_transaction,
> that way there is an idea of how long the committing of a transaction to disk
> happens.  If we only have two threads doing work and fsyncing, its going to be a
> constant time, because we'll only be writing a certain number of buffers each
> time.
>  

Hmm now that I think about it you are right, if the thread waits then the time
the transaction was running could be greater than the commit time and this
wouldn't help.  Though one would hope that dirtying pagecache would still be
several times faster than writing to disk so any amount of waiting wouldn't be
too much of a big deal, and waiting too long would hurt in our current case
anyway.  Thanks,

Josef
