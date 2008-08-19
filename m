From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [PATCH 2/2] improve ext3 fsync batching
Date: Tue, 19 Aug 2008 14:43:27 -0400
Message-ID: <48AB144F.1070606@redhat.com>
References: <20080806190819.GH27394@unused.rdu.redhat.com>	<20080806191536.GI27394@unused.rdu.redhat.com>	<20080818213128.3a76d1e8.akpm@linux-foundation.org>	<20080819054414.GM3392@webber.adilger.int>	<48AAA7F7.5090501@redhat.com> <20080819105638.aae4086f.akpm@linux-foundation.org>
Reply-To: rwheeler@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: rwheeler@redhat.com, Andreas Dilger <adilger@sun.com>,
	Josef Bacik <jbacik@redhat.com>, linux-kernel@vger.kernel.org,
	tglx@linutronix.de, linux-fsdevel@vger.kernel.org,
	chris.mason@oracle.com, linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20080819105638.aae4086f.akpm@linux-foundation.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andrew Morton wrote:
> On Tue, 19 Aug 2008 07:01:11 -0400 Ric Wheeler <rwheeler@redhat.com> wrote:
>
>   
>> It would be great to be able to use this batching technique for faster 
>> devices, but we currently sleep 3-4 times longer waiting to batch for an 
>> array than it takes to complete the transaction.
>>     
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
>   

One other way to think about this is as a fairly normal queuing problem:

    (1) arrival rate is the rate at which we see new tasks coming into 
the code
    (2) service time is basically the time spent committing the 
transaction to storage

and we have the assumption that some number of tasks can join a 
transaction more or less for "free."

What the existing code assumes is that all devices have an equal service 
time. That worked well as long as we only looked at devices that were 
roughly equal (10-20 ms latencies) or used a higher HZ for the kernel 
(1000HZ and you don't see this as much as with 100HZ).

The two key issues that Josef's code tried to address are that first 
assumption that all devices have a similar service time and the tie 
between how long we wait and the HZ. It would seem to be generically 
useful to be able to sleep for less than 1 jiffie, not just for file 
systems, but maybe also in some other contexts?

ric

