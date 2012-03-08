From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH, RFC] Don't do page stablization if
 !CONFIG_BLKDEV_INTEGRITY
Date: Thu, 8 Mar 2012 13:09:51 -0500
Message-ID: <20120308180951.GB29510@shiny>
References: <E1S5QTU-0005Cc-Kl@tytso-glaptop.cam.corp.google.com>
 <4F57F523.3020703@redhat.com>
 <4F581BF6.8000305@zabbo.net>
 <20120308155419.GB6777@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zach Brown <zab@zabbo.net>, Eric Sandeen <sandeen@redhat.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:49040 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318Ab2CHSJ5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Mar 2012 13:09:57 -0500
Content-Disposition: inline
In-Reply-To: <20120308155419.GB6777@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 08, 2012 at 10:54:19AM -0500, Ted Ts'o wrote:
> On Wed, Mar 07, 2012 at 09:39:50PM -0500, Zach Brown wrote:
> > 
> > >Can you devise a non-secret testcase that demonstrates this?
> > 
> > Hmm.  I bet you could get fio to do it.  Giant file, random mmap()
> > writes, spin until the CPU overwhelms writeback?
> 
> Kick off a bunch of fio processes, each in separate I/O cgroups set up
> so that each of the processes get a "fair" amount of the I/O
> bandwidth.  (This is quite common in cloud deployments where you are
> packing a huge number of tasks onto a single box; whether the tasks
> are inside virtual machines or containers don't really matter for the
> purpose of this exercise.  We basically need to simulate a system
> where the disks are busy.)
> 
> Then in one of those cgroups, create a process which is constantly
> appending to a file using buffered I/O; this could be a log file, or
> an application-level journal file; and measure the latency of that
> write system call.  Every so often, writeback will push the dirty
> pages corresponding to the log/journal file to disk.  When that
> happens, and page stablization is enabled, the latency of that write
> system call will spike.
> 
> And any time you have a distributed system where you are depending on
> a large number of RPC/SOAP/Service Oriented Architecture Enterpise
> Service Bus calls (I don't really care which buzzword you use, but IBM
> and Oracle really like the last one :-), long-tail latencies are what
> kill your responsiveness and predictability.  Especially when a thread
> goes away for a second or more...

But, why are we writeback for a second or more?  Aren't there other
parts of this we would want to fix as well?

I'm not against only turning on stable pages when they are needed, but
the code that isn't the default tends to be somewhat less used.  So it
does increase testing burden when we do want stable pages, and it tends
to make for awkward bugs that are hard to reproduce because someone
neglects to mention it.

IMHO it's much more important to nail down the 2 second writeback
latency. That's not good.

-chris

