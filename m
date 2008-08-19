From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] improve ext3 fsync batching
Date: Tue, 19 Aug 2008 14:18:31 -0700
Message-ID: <20080819141831.f695dc9c.akpm@linux-foundation.org>
References: <20080806190819.GH27394@unused.rdu.redhat.com>
	<20080806191536.GI27394@unused.rdu.redhat.com>
	<20080818213128.3a76d1e8.akpm@linux-foundation.org>
	<20080819054414.GM3392@webber.adilger.int>
	<48AAA7F7.5090501@redhat.com>
	<20080819105638.aae4086f.akpm@linux-foundation.org>
	<48AB0C1F.1040104@redhat.com>
	<20080819132914.6fcc9f29.akpm@linux-foundation.org>
	<48AB3353.5000308@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: adilger@sun.com, jbacik@redhat.com, linux-kernel@vger.kernel.org,
	tglx@linutronix.de, linux-fsdevel@vger.kernel.org,
	chris.mason@oracle.com, linux-ext4@vger.kernel.org
To: rwheeler@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34173 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752845AbYHSVTO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Aug 2008 17:19:14 -0400
In-Reply-To: <48AB3353.5000308@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 19 Aug 2008 16:55:47 -0400
Ric Wheeler <rwheeler@redhat.com> wrote:

> >   
> >>> Perhaps a better scheme would be to tune it based on how many other
> >>> processes are joining that transaction.  If it's "zero" then decrease
> >>> the timeout.  But one would need to work out how to increase it, which
> >>> perhaps could be done by detecting the case where process A runs an
> >>> fsync when a commit is currently in progress, and that commit was
> >>> caused by process B's fsync.
> >>>   
> >>>       
> >> This is really, really a property of the device's latency at any given 
> >> point in time. If there are no other processes running, we could do an 
> >> optimization and not wait.
> >>     
> >
> > well yes.  This represents yet another attempt to predict future
> > application behaviour.  The way in which we _usually_ do that is by
> > monitoring past application behaviour.
> >   
> This whole area is very similar to the IO elevator area where some of 
> the same device characteristics are measured.
> 
> 
> > Only this patch didn't do that (directly) and I'm wondering why not.
> >   
> 
> The average transaction commit time is a direct measurement of the past 
> behaviour, right?

Of commit time, yes.  Somewhat - it has obvious failures during
transients.

But there's an assumption here that commit time is usefully correlated
with "mean time between fsync()s", which might introduce further
inaccuracies.

> >   
> >>> But before doing all that I would recommend/ask that the following be
> >>> investigated:
> >>>
> >>> - How effective is the present code?
> >>>   
> >>>       
> >> It causes the most expensive storage (arrays) to run 3-4 times slower 
> >> than they should on a synchronous write workload (NFS server, mail 
> >> server?) with more than 1 thread. For example, against a small EMC 
> >> array, I saw single threaded write rates of 720 files/sec against ext3 
> >> with 1 thread, 225 (if I remember correctly) with 2 ;-)
> >>     
> >
> > Current code has:
> >
> > 	/*
> > 	 * Implement synchronous transaction batching.  If the handle
> > 	 * was synchronous, don't force a commit immediately.  Let's
> > 	 * yield and let another thread piggyback onto this transaction.
> > 	 * Keep doing that while new threads continue to arrive.
> > 	 * It doesn't cost much - we're about to run a commit and sleep
> > 	 * on IO anyway.  Speeds up many-threaded, many-dir operations
> > 	 * by 30x or more...
> > 	 *
> > 	 * But don't do this if this process was the most recent one to
> > 	 * perform a synchronous write.  We do this to detect the case where a
> > 	 * single process is doing a stream of sync writes.  No point in waiting
> > 	 * for joiners in that case.
> > 	 */
> >
> > has the 30x been reproduced?  If not, what broke?  If so, what effect
> > did the proposed change have upon it?
> >   
> 
> The huge gain was only in the case of a RAM disk test which I assume was 
> not tested against the original patch early on. Against an array (with a 
> 250HZ kernel), we saw a 2.5x speedup with the new code.

You only answered question 3/3 ;)

I am concerned that the current code is no longer working correctly. 
If so then apart from the obvious we-should-fix-that issue, there's
also the possibility that we're adding more stuff on top of the broken
stuff rather than fixing the broken stuff.

> >   
> >>>   - What happens when it is simply removed?
> >>>   
> >>>       
> >> If you remove the code, you will not see the throughput rise when you go 
> >> multithreaded on existing slow devices (S-ATA/ATA for example). Faster 
> >> devices will not see that 2 threaded drop.
> >>     
> >
> > See above - has this been tested and confirmed?
> >   
> 
> Yes - we (back at EMC) did remove the logic and the fast devices will 
> write at least at their starting rate (700+ files/sec).

Did you observe the effect upon slower devices?

> >   
> >>>   - Add instrumentation (a counter and a printk) to work out how
> >>>     many other tasks are joining this task's transaction.
> >>>
> >>>     - If the answer is "zero" or "small", work out why.
> >>>
> >>>   - See if we can increase its effectiveness.
> >>>
> >>> Because it could be that the code broke.  There might be issues with
> >>> higher-level locks which are preventing the batching.  For example, if
> >>> all the files which the test app is syncing are in the same directory,
> >>> perhaps all the tasks are piling up on that directory's i_mutex?
> >>>   
> >>>       
> >> I have to admit that I don't see the down side here - we have shown a 
> >> huge increase for arrays (embarrassingly huge  increase for RAM disks) 
> >> and see no degradation for the S-ATA/ATA case.
> >>
> >> The code is not broken (having been there and done the performance 
> >> tuning on the original code), it just did not account for the widely 
> >> varying average response times for different classes of storage ;-)
> >>     
> >
> > Well, as I said - last time I checked, it did seem to be broken.  By
> > what means did you confirm that it is still effective, and what were
> > the results?
> >
> >   
> 
> I think Josef posted those results for S-ATA earlier in the thread and 
> they were still working. We can repost/rerun to give more detail...

Yes please.
