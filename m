From: Josef Bacik <jbacik@redhat.com>
Subject: Re: transaction batching performance & multi-threaded synchronous
	writers
Date: Tue, 15 Jul 2008 08:51:27 -0400
Message-ID: <20080715125127.GA30311@unused.rdu.redhat.com>
References: <487B7B9B.3020001@gmail.com> <20080714165858.GA10268@unused.rdu.redhat.com> <20080715075832.GD6239@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <jbacik@redhat.com>,
	Ric Wheeler <ricwheeler@gmail.com>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:58588 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754766AbYGONKU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Jul 2008 09:10:20 -0400
Content-Disposition: inline
In-Reply-To: <20080715075832.GD6239@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 15, 2008 at 01:58:32AM -0600, Andreas Dilger wrote:
> On Jul 14, 2008  12:58 -0400, Josef Bacik wrote:
> > Perhaps we track the average time a commit takes to occur, and then if
> > the current transaction start time is < than the avg commit time we sleep
> > and wait for more things to join the transaction, and then we commit.
> > How does that idea sound?  Thanks,
> 
> The drawback of this approach is that if the thread waits an extra "average
> transaction time" for the transaction to commit then this will increase the
> average transaction time each time, and it still won't tell you if there
> needs to be a wait at all.
>

I'm not talking about the average transaction life, as you say it would be
highly dependant on random things that have nothing to do with the transaction
time (waiting for locks and such).  I'm measuring the time it takes for the
actual commit to take place, so I record the start time in
journal_commit_transaction when we set running_transaction = NULL, and then the
end time right before the wakeup() at the end of journal_commit_transaction,
that way there is an idea of how long the committing of a transaction to disk
happens.  If we only have two threads doing work and fsyncing, its going to be a
constant time, because we'll only be writing a certain number of buffers each
time.
 
> What might be more interesting is tracking how many processes had sync
> handles on the previous transaction(s), and once that number of processes
> have done that work, or the timeout reached, the transaction is committed.
> 
> While this might seem like a hack for the particular benchmark, this
> will also optimize real-world workloads like mailserver, NFS/fileserver,
> http where the number of threads running at one time is generally fixed.
> 
> The best way to do that would be to keep a field in the task struct to
> track whether a given thread has participated in transaction "T" when
> it starts a new handle, and if not then increment the "number of sync
> threads on this transaction" counter.
> 
> In journal_stop() if t_num_sync_thr >= prev num_sync_thr then
> the transaction can be committed earlier, and if not then it does a
> wait_event_interruptible_timeout(cur_num_sync_thr >= prev_num_sync_thr, 1).
> 
> While the number of sync threads is growing or constant the commits will 
> be rapid, and any "slow" threads will block on the next transaction and
> increment its num_sync_thr until the thread count stabilizes (i.e. a small
> number of transactions at startup).  After that the wait will be exactly
> as long as needed for each thread to participate.  If some threads are
> too slow, or stop processing then there will be a single sleep and the
> next transaction will wait for fewer threads the next time.
>

This idea is good, but I'm wondering about the normal user use case, ie where
syslog is the only thing that does fsync.  If we get into a position where
prev_num_sync_thr is always 1, we'll just bypass sleeping and waiting for other
stuff to join the transaction and sync whenever syslog pleases, which will
likely affect most normal users, especially if they are like me and have crappy
wireless cards that like to spit stuff into syslog constantly ;).  Thanks much,

Josef 
