From: Josef Bacik <jbacik@redhat.com>
Subject: Re: [PATCH 2/2] improve ext3 fsync batching
Date: Tue, 19 Aug 2008 15:18:01 -0400
Message-ID: <20080819191800.GA21749@unused.rdu.redhat.com>
References: <20080806190819.GH27394@unused.rdu.redhat.com> <20080806191536.GI27394@unused.rdu.redhat.com> <20080818213128.3a76d1e8.akpm@linux-foundation.org> <20080819054414.GM3392@webber.adilger.int> <48AAA7F7.5090501@redhat.com> <20080819105638.aae4086f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: rwheeler@redhat.com, Andreas Dilger <adilger@sun.com>,
	Josef Bacik <jbacik@redhat.com>, linux-kernel@vger.kernel.org,
	tglx@linutronix.de, linux-fsdevel@vger.kernel.org,
	chris.mason@oracle.com, linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080819105638.aae4086f.akpm@linux-foundation.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Aug 19, 2008 at 10:56:38AM -0700, Andrew Morton wrote:
> On Tue, 19 Aug 2008 07:01:11 -0400 Ric Wheeler <rwheeler@redhat.com> wrote:
> 
> > It would be great to be able to use this batching technique for faster 
> > devices, but we currently sleep 3-4 times longer waiting to batch for an 
> > array than it takes to complete the transaction.
> 
> Obviously, tuning that delay down to the minimum necessary is a good
> thing.  But doing it based on commit-time seems indirect at best.  What
> happens on a slower disk when commit times are in the tens of
> milliseconds?  When someone runs a concurrent `dd if=/dev/zero of=foo'
> when commit times go up to seconds?
>
> Perhaps a better scheme would be to tune it based on how many other
> processes are joining that transaction.  If it's "zero" then decrease
> the timeout.  But one would need to work out how to increase it, which
> perhaps could be done by detecting the case where process A runs an
> fsync when a commit is currently in progress, and that commit was
> caused by process B's fsync.
> 
> But before doing all that I would recommend/ask that the following be
> investigated:
> 
> - How effective is the present code?
> 
>   - What happens when it is simply removed?
> 
>   - Add instrumentation (a counter and a printk) to work out how
>     many other tasks are joining this task's transaction.
> 
>     - If the answer is "zero" or "small", work out why.
> 
>   - See if we can increase its effectiveness.
> 
> Because it could be that the code broke.  There might be issues with
> higher-level locks which are preventing the batching.  For example, if
> all the files which the test app is syncing are in the same directory,
> perhaps all the tasks are piling up on that directory's i_mutex?

There is no problem with the current code on normal desktop boxes with sata
drives.  This optimization is fantastic and greatly increases throughput.  The
problem is that in the case of low latency drives where sleeping for 1 jiffie
(depending on HZ) is entirely too long based on the latency of the disk.  I had
thought about doing the number of syncing threads per transaction, but I'm
worried about the normal case of a running box, ie where the only thing running
fsync is syslog.  In that case the "average fsyncing threads" count would be 1,
so when syslog ran fsync we'd bypass the sleep and just commit, which would
result in utter crap performance from the current code.  Measuring the time it
takes to commit a transaction was a nice uniform way to figure out how long we
may need to wait in order for a usefull amount of stuff to be added to the
transaction, and it would be self tuning to the underlying disk.  The goal was
to maintain the awesome performance we currently get with high latency devices
while at the same time fixing the crappy performance we see with low latency
disks.  I hope that helps.  Thanks,

Josef
