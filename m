From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [PATCH 2/2] improve ext3 fsync batching
Date: Tue, 19 Aug 2008 14:08:31 -0400
Message-ID: <48AB0C1F.1040104@redhat.com>
References: <20080806190819.GH27394@unused.rdu.redhat.com>	<20080806191536.GI27394@unused.rdu.redhat.com>	<20080818213128.3a76d1e8.akpm@linux-foundation.org>	<20080819054414.GM3392@webber.adilger.int>	<48AAA7F7.5090501@redhat.com> <20080819105638.aae4086f.akpm@linux-foundation.org>
Reply-To: rwheeler@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>, Josef Bacik <jbacik@redhat.com>,
	linux-kernel@vger.kernel.org, tglx@linutronix.de,
	linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
	linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:34761 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582AbYHSSIq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Aug 2008 14:08:46 -0400
In-Reply-To: <20080819105638.aae4086f.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

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

Transactions on that busier drive would take longer, we would sleep 
longer which would allow us to batch up more into one transaction. That 
should be a good result and it should reset when the drive gets less 
busy (and transactions shorter) to a shorter sleep time.

> Perhaps a better scheme would be to tune it based on how many other
> processes are joining that transaction.  If it's "zero" then decrease
> the timeout.  But one would need to work out how to increase it, which
> perhaps could be done by detecting the case where process A runs an
> fsync when a commit is currently in progress, and that commit was
> caused by process B's fsync.
>   
This is really, really a property of the device's latency at any given 
point in time. If there are no other processes running, we could do an 
optimization and not wait.

> But before doing all that I would recommend/ask that the following be
> investigated:
>
> - How effective is the present code?
>   

It causes the most expensive storage (arrays) to run 3-4 times slower 
than they should on a synchronous write workload (NFS server, mail 
server?) with more than 1 thread. For example, against a small EMC 
array, I saw single threaded write rates of 720 files/sec against ext3 
with 1 thread, 225 (if I remember correctly) with 2 ;-)

>   - What happens when it is simply removed?
>   
If you remove the code, you will not see the throughput rise when you go 
multithreaded on existing slow devices (S-ATA/ATA for example). Faster 
devices will not see that 2 threaded drop.

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

I have to admit that I don't see the down side here - we have shown a 
huge increase for arrays (embarrassingly huge  increase for RAM disks) 
and see no degradation for the S-ATA/ATA case.

The code is not broken (having been there and done the performance 
tuning on the original code), it just did not account for the widely 
varying average response times for different classes of storage ;-)

ric


