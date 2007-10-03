From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: batching support for transactions
Date: Wed, 3 Oct 2007 15:02:56 -0600
Message-ID: <20071003210256.GO5578@schatzie.adilger.int>
References: <47024051.2030303@emc.com> <20071003071653.GE5578@schatzie.adilger.int> <4703721B.9050600@emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	reiserfs-devel@vger.kernel.org, "Feld, Andy" <Feld_Andy@emc.com>,
	Jens Axboe <jens.axboe@oracle.com>
To: Ric Wheeler <ric@emc.com>
Return-path: <reiserfs-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4703721B.9050600@emc.com>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Oct 03, 2007  06:42 -0400, Ric Wheeler wrote:
> >>With 2 threads writing to the same directory, we instantly drop down to 
> >>234 files/sec.
> >
> >Is this with HZ=250?
> 
> Yes - I assume that with HZ=1000 the batching would start to work again 
> since the penalty for batching would only be 1ms which would add a 0.3ms 
> overhead while waiting for some other thread to join.

This is probably the easiest solution, but at the same time using HZ=1000
adds overhead to the server because of extra interrupts, etc.

> >It would seem one of the problems is that we shouldn't really be
> >scheduling for a fixed 1 jiffie timeout, but rather only until the
> >other threads have a chance to run and join the existing transaction.
> 
> This is really very similar to the domain of the IO schedulers - when do 
> you hold off an IO and/or try to combine it.

I was thinking the same.

> >my guess would be that yield() doesn't block the first thread long enough
> >for the second one to get into the transaction (e.g. on an 2-CPU system
> >with 2 threads, yield() will likely do nothing).
> 
> Andy tried playing with yield() and it did not do well. Note this this 
> server is a dual CPU box, so your intuition is most likely correct.

How many threads did you try?

> >It makes sense to track not only the time to commit a single synchronous
> >transaction, but also the time between sync transactions to decide if
> >the initial transaction should be held to allow later ones.
> 
> Yes, that is what I was trying to suggest with the rate. Even if we are 
> relatively slow, if the IO's are being synched at a low rate, we are 
> effectively adding a potentially nasty latency for each IO.
> 
> That would give us two measurements to track per IO device - average 
> commit time and this average IO's/sec rate. That seems very doable.

Agreed.

> >Alternately, it might be possible to check if a new thread is trying to
> >start a sync handle when the previous one was also synchronous and had
> >only a single handle in it, then automatically enable the delay in that 
> >case.
> 
> I am not sure that this avoids the problem with the current defaults at 
> 250HZ where each wait is sufficient to do 3 fully independent 
> transactions ;-)

I was trying to think if there was some way to non-busy-wait that is
less than 1 jiffie.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

