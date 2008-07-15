From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: transaction batching performance & multi-threaded synchronous
 writers
Date: Tue, 15 Jul 2008 07:29:21 -0400
Message-ID: <487C8A11.3050801@redhat.com>
References: <487B7B9B.3020001@gmail.com> <20080714165858.GA10268@unused.rdu.redhat.com> <20080715075832.GD6239@webber.adilger.int>
Reply-To: rwheeler@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Josef Bacik <jbacik@redhat.com>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:44709 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036AbYGOL3f (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Jul 2008 07:29:35 -0400
In-Reply-To: <20080715075832.GD6239@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On Jul 14, 2008  12:58 -0400, Josef Bacik wrote:
>   
>> Perhaps we track the average time a commit takes to occur, and then if
>> the current transaction start time is < than the avg commit time we sleep
>> and wait for more things to join the transaction, and then we commit.
>> How does that idea sound?  Thanks,
>>     
>
> The drawback of this approach is that if the thread waits an extra "average
> transaction time" for the transaction to commit then this will increase the
> average transaction time each time, and it still won't tell you if there
> needs to be a wait at all.
>
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
>
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
>
>   
This really sounds like one of those math problems (queuing theory?) 
that I never was able to completely wrap my head around back at 
university, but the basic things that we we have are:

    (1) the average time it takes to complete an independent 
transaction. This will be different for each target device and will 
possibly change over time (specific odd case is a shared disk, like an 
array).
    (2) the average cost it takes to add "one more" thread to a 
transaction. I think that the assumption is that this cost is close to zero.
    (3) the rate of arrival of threads trying to join a transaction.
    (4) come knowledge of the history of which threads did the past 
transactions. It is quite reasonable to never wait if a single thread is 
the author of the last (most of the last?) sequence which is the good 
thing in there now.
    (5) the minimum time we can effectively wait with a given mechanism 
(4ms or 1ms for example depending on the HZ in the code today)

I think the trick here is to try and get a heuristic that works without 
going nuts in complexity.

The obvious thing we need to keep is the heuristic to not wait if we 
detect a single thread workload.

It would seem reasonable not to wait if the latency of the device (1 
above) is lower than the time the chosen mechanism can wait (5). For 
example, if transactions are done in microseconds like for a ramdisk, 
just blast away ;-)

What would be left would be the need to figure out if (3) arrival rate 
would predict a new thread will come along before we would be able to 
finish the current transaction without waiting.

Does this make any sense? This sounds close to the idea that Josef 
proposed above, we would just tweak his proposal to avoid sleeping in 
the single threaded case.

Ric




