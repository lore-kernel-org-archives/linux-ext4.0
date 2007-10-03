From: Ric Wheeler <ric@emc.com>
Subject: Re: batching support for transactions
Date: Wed, 03 Oct 2007 06:42:35 -0400
Message-ID: <4703721B.9050600@emc.com>
References: <47024051.2030303@emc.com> <20071003071653.GE5578@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Ric Wheeler <ric@emc.com>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, reiserfs-devel@vger.kernel.org,
	"Feld, Andy" <Feld_Andy@emc.com>,
	Jens Axboe <jens.axboe@oracle.com>
Return-path: <reiserfs-devel-owner@vger.kernel.org>
In-Reply-To: <20071003071653.GE5578@schatzie.adilger.int>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andreas Dilger wrote:
> On Oct 02, 2007  08:57 -0400, Ric Wheeler wrote:
>> One thing that jumps out is that the way we currently batch synchronous 
>> work loads into transactions does really horrible things to performance 
>> for storage devices which have really low latency.
>>
>> For example, one a mid-range clariion box, we can use a single thread to 
>> write around 750 (10240 byte) files/sec to a single directory in ext3. 
>> That gives us an average time around 1.3ms per file.
>>
>> With 2 threads writing to the same directory, we instantly drop down to 
>> 234 files/sec.
> 
> Is this with HZ=250?

Yes - I assume that with HZ=1000 the batching would start to work again 
since the penalty for batching would only be 1ms which would add a 0.3ms 
overhead while waiting for some other thread to join.


> 
>> The culprit seems to be the assumptions in journal_stop() which throw in 
>> a call to schedule_timeout_uninterruptible(1):
>>
>>         pid = current->pid;
>>         if (handle->h_sync && journal->j_last_sync_writer != pid) {
>>                 journal->j_last_sync_writer = pid;
>>                 do {
>>                         old_handle_count = transaction->t_handle_count;
>>                         schedule_timeout_uninterruptible(1);
>>                 } while (old_handle_count != transaction->t_handle_count);
>>         }
> 
> It would seem one of the problems is that we shouldn't really be
> scheduling for a fixed 1 jiffie timeout, but rather only until the
> other threads have a chance to run and join the existing transaction.

This is really very similar to the domain of the IO schedulers - when do 
you hold off an IO and/or try to combine it.

It is hard to predict the future need of threads that will be wanting to 
do IO, but you can dynamically measure the average time it takes a 
transaction to commit.

Would it work to keep this average commit time is less than say 80% of 
the timeout?  Using the 1000HZ example, 1ms wait for the average commit 
time of 1.2 or 1.3 ms?

> 
>> What seems to be needed here is either a static per file system/storage 
>> device tunable to allow us to change this timeout (maybe with "0" 
>> defaulting back to the old reiserfs trick of simply doing a yield()?)
> 
> Tunables are to be avoided if possible, since they will usually not be
> set except by the .00001% of people who actually understand them.  Using
> yield() seems like the right thing, but Andrew Morton added this code and
> my guess would be that yield() doesn't block the first thread long enough
> for the second one to get into the transaction (e.g. on an 2-CPU system
> with 2 threads, yield() will likely do nothing).

I agree that tunables are a bad thing.  It might be nice to dream about 
having mkfs do some test timings (issues and time the average 
synchronous IOs/sec) and setting this in the superblock.

Andy tried playing with yield() and it did not do well. Note this this 
server is a dual CPU box, so your intuition is most likely correct.

The balance is that the batching does work well for "normal" slow disks, 
especially when using the write barriers (giving us an average commit 
time closer to 20ms).

>> or a more dynamic, per device way to keep track of the average time it 
>> takes to commit a transaction to disk. Based on that rate, we could 
>> dynamically adjust our logic to account for lower latency devices.
> 
> It makes sense to track not only the time to commit a single synchronous
> transaction, but also the time between sync transactions to decide if
> the initial transaction should be held to allow later ones.

Yes, that is what I was trying to suggest with the rate. Even if we are 
relatively slow, if the IO's are being synched at a low rate, we are 
effectively adding a potentially nasty latency for each IO.

That would give us two measurements to track per IO device - average 
commit time and this average IO's/sec rate. That seems very doable.

> Alternately, it might be possible to check if a new thread is trying to
> start a sync handle when the previous one was also synchronous and had
> only a single handle in it, then automatically enable the delay in that case.

I am not sure that this avoids the problem with the current defaults at 
250HZ where each wait is sufficient to do 3 fully independent 
transactions ;-)

ric

