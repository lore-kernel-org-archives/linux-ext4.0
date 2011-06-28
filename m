From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 0/3] block: Fix fsync slowness with CFQ cgroups
Date: Tue, 28 Jun 2011 12:47:38 +1000
Message-ID: <20110628024738.GJ32466@dastard>
References: <1309205864-13124-1-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, jaxboe@fusionio.com,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	khlebnikov@openvz.org, jmoyer@redhat.com
To: Vivek Goyal <vgoyal@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1309205864-13124-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jun 27, 2011 at 04:17:41PM -0400, Vivek Goyal wrote:
> Hi,
> 
> Konstantin reported that fsync is very slow with ext4 if fsyncing process
> is in a separate cgroup and one is using CFQ IO scheduler.
> 
> https://lkml.org/lkml/2011/6/23/269
> 
> Issue seems to be that fsync process is in a separate cgroup and journalling
> thread is in root cgroup. After every IO from fsync, CFQ idles on fysnc
> process queue waiting for more requests to come. But this process is now
> waiting for IO to finish from journaling thread. After waiting for 8ms
> fsync's queue gives way to jbd's queue. Then we start idling on jbd
> thread and new IO from fsync is sitting in a separate queue in a separate
> group.
> 
> Bottom line, that after every IO we end up idling on fysnc and jbd thread
> so much that if somebody is doing fsync after every 4K of IO, throughput
> nose dives.
> 
> Similar issue had issue come up with-in same cgroup also when "fsync"
> and "jbd" thread were being queued on differnt service trees and idling
> was killing. At that point of time two solutions were proposed. One
> from Jeff Moyer and one from Corrado Zoccolo.
> 
> Jeff came up with the idea of coming with block layer API to yield the
> queue if explicitly told by file system, hence cutting down on idling.
> 
> https://lkml.org/lkml/2010/7/2/277
> 
> Corrado, came up with a simpler approach of keeping jbd and fsync processes
> on same service tree by parsing RQ_NOIDLE flag. By queuing on same service
> tree, one queue preempts other queue hence cutting down on idling time.
> Upstream went ahead with simpler approach to fix the issue.
> 
> commit 749ef9f8423054e326f3a246327ed2db4b6d395f
> Author: Corrado Zoccolo <czoccolo@gmail.com>
> Date:   Mon Sep 20 15:24:50 2010 +0200
> 
>     cfq: improve fsync performance for small files
> 
> 
> Now with cgroups, same problem resurfaces but this time we can not queue
> both the processes on same service tree and take advantage of preemption
> as separate cgroups have separate service trees and both processes
> belong to separate cgroups. We do not allow cross cgroup preemption 
> as that wil break down the isolation between groups.
> 
> So this patch series resurrects Jeff's solution of file system specifying
> the IO dependencies between threads explicitly to the block layer/ioscheduler.
> One ioscheduler knows that current queue we are idling on is dependent on
> IO from some other queue, CFQ allows dispatch of requests from that other
> queue in the context of current active queue.

Vivek, I'm not sure this is a general solution. If we hand journal
IO off to a workqueue, then we've got no idea what the "dependent
task" is.

I bring this up as I have a current patchset that moves all the XFS
journal IO out of process context into a workqueue to solve
process-visible operation latency (e.g. 1000 mkdir syscalls run at
1ms each, the 1001st triggers a journal checkpoint and takes 500ms)
and background checkpoint submission races.  This effectively means
that XFS will trigger the same bad CFQ behaviour on fsync, but have
no means of avoiding it because we don't have a specific task to
yield to.

And FWIW, we're going to be using workqueues more and more in XFS
for asynchronous processing of operations. I'm looking to use WQs
for speculative readahead of inodes, all our delayed metadata
writeback, log IO submission, free space allocation requests,
background inode allocation, background inode freeing, background
EOF truncation, etc to process as much work asynchronously outside
syscall context as possible (let's use all those CPU cores we
have!).

All of these things will push potentially dependent IO operations
outside of the bounds of the process actually doing the operation,
so some general solution to the "dependent IO in an undefined thread
context" problem really needs to be solved sooner rather than
later...

As it is, I don't have any good ideas of how to solve this, but I
thought it is worth bringing to your attention while you are trying
to solve a similar issue.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
