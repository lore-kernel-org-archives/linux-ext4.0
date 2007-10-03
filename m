From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: batching support for transactions
Date: Wed, 3 Oct 2007 01:16:53 -0600
Message-ID: <20071003071653.GE5578@schatzie.adilger.int>
References: <47024051.2030303@emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	reiserfs-devel@vger.kernel.org, "Feld, Andy" <Feld_Andy@emc.com>,
	Jens Axboe <jens.axboe@oracle.com>
To: Ric Wheeler <ric@emc.com>
Return-path: <reiserfs-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <47024051.2030303@emc.com>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Oct 02, 2007  08:57 -0400, Ric Wheeler wrote:
> One thing that jumps out is that the way we currently batch synchronous 
> work loads into transactions does really horrible things to performance 
> for storage devices which have really low latency.
> 
> For example, one a mid-range clariion box, we can use a single thread to 
> write around 750 (10240 byte) files/sec to a single directory in ext3. 
> That gives us an average time around 1.3ms per file.
> 
> With 2 threads writing to the same directory, we instantly drop down to 
> 234 files/sec.

Is this with HZ=250?

> The culprit seems to be the assumptions in journal_stop() which throw in 
> a call to schedule_timeout_uninterruptible(1):
> 
>         pid = current->pid;
>         if (handle->h_sync && journal->j_last_sync_writer != pid) {
>                 journal->j_last_sync_writer = pid;
>                 do {
>                         old_handle_count = transaction->t_handle_count;
>                         schedule_timeout_uninterruptible(1);
>                 } while (old_handle_count != transaction->t_handle_count);
>         }

It would seem one of the problems is that we shouldn't really be
scheduling for a fixed 1 jiffie timeout, but rather only until the
other threads have a chance to run and join the existing transaction.

> What seems to be needed here is either a static per file system/storage 
> device tunable to allow us to change this timeout (maybe with "0" 
> defaulting back to the old reiserfs trick of simply doing a yield()?)

Tunables are to be avoided if possible, since they will usually not be
set except by the .00001% of people who actually understand them.  Using
yield() seems like the right thing, but Andrew Morton added this code and
my guess would be that yield() doesn't block the first thread long enough
for the second one to get into the transaction (e.g. on an 2-CPU system
with 2 threads, yield() will likely do nothing).

> or a more dynamic, per device way to keep track of the average time it 
> takes to commit a transaction to disk. Based on that rate, we could 
> dynamically adjust our logic to account for lower latency devices.

It makes sense to track not only the time to commit a single synchronous
transaction, but also the time between sync transactions to decide if
the initial transaction should be held to allow later ones.

Alternately, it might be possible to check if a new thread is trying to
start a sync handle when the previous one was also synchronous and had
only a single handle in it, then automatically enable the delay in that case.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

