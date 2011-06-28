From: Shaohua Li <shaohua.li@intel.com>
Subject: Re: [RFC PATCH 0/3] block: Fix fsync slowness with CFQ cgroups
Date: Tue, 28 Jun 2011 10:03:54 +0800
Message-ID: <1309226634.15392.197.camel@sli10-conroe>
References: <1309205864-13124-1-git-send-email-vgoyal@redhat.com>
	 <1309223932.15392.186.camel@sli10-conroe>
	 <20110628014039.GA15850@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"jaxboe@fusionio.com" <jaxboe@fusionio.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"khlebnikov@openvz.org" <khlebnikov@openvz.org>,
	"jmoyer@redhat.com" <jmoyer@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:53454 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755413Ab1F1CD7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Jun 2011 22:03:59 -0400
In-Reply-To: <20110628014039.GA15850@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 2011-06-28 at 09:40 +0800, Vivek Goyal wrote:
> On Tue, Jun 28, 2011 at 09:18:52AM +0800, Shaohua Li wrote:
> > On Tue, 2011-06-28 at 04:17 +0800, Vivek Goyal wrote:
> > > Hi,
> > > 
> > > Konstantin reported that fsync is very slow with ext4 if fsyncing process
> > > is in a separate cgroup and one is using CFQ IO scheduler.
> > > 
> > > https://lkml.org/lkml/2011/6/23/269
> > > 
> > > Issue seems to be that fsync process is in a separate cgroup and journalling
> > > thread is in root cgroup. After every IO from fsync, CFQ idles on fysnc
> > > process queue waiting for more requests to come. But this process is now
> > > waiting for IO to finish from journaling thread. After waiting for 8ms
> > > fsync's queue gives way to jbd's queue. Then we start idling on jbd
> > > thread and new IO from fsync is sitting in a separate queue in a separate
> > > group.
> > > 
> > > Bottom line, that after every IO we end up idling on fysnc and jbd thread
> > > so much that if somebody is doing fsync after every 4K of IO, throughput
> > > nose dives.
> > > 
> > > Similar issue had issue come up with-in same cgroup also when "fsync"
> > > and "jbd" thread were being queued on differnt service trees and idling
> > > was killing. At that point of time two solutions were proposed. One
> > > from Jeff Moyer and one from Corrado Zoccolo.
> > > 
> > > Jeff came up with the idea of coming with block layer API to yield the
> > > queue if explicitly told by file system, hence cutting down on idling.
> > > 
> > > https://lkml.org/lkml/2010/7/2/277
> > > 
> > > Corrado, came up with a simpler approach of keeping jbd and fsync processes
> > > on same service tree by parsing RQ_NOIDLE flag. By queuing on same service
> > > tree, one queue preempts other queue hence cutting down on idling time.
> > > Upstream went ahead with simpler approach to fix the issue.
> > > 
> > > commit 749ef9f8423054e326f3a246327ed2db4b6d395f
> > > Author: Corrado Zoccolo <czoccolo@gmail.com>
> > > Date:   Mon Sep 20 15:24:50 2010 +0200
> > > 
> > >     cfq: improve fsync performance for small files
> > > 
> > > 
> > > Now with cgroups, same problem resurfaces but this time we can not queue
> > > both the processes on same service tree and take advantage of preemption
> > > as separate cgroups have separate service trees and both processes
> > > belong to separate cgroups. We do not allow cross cgroup preemption 
> > > as that wil break down the isolation between groups.
> > > 
> > > So this patch series resurrects Jeff's solution of file system specifying
> > > the IO dependencies between threads explicitly to the block layer/ioscheduler.
> > > One ioscheduler knows that current queue we are idling on is dependent on
> > > IO from some other queue, CFQ allows dispatch of requests from that other
> > > queue in the context of current active queue.
> > > 
> > > So if fysnc thread specifies the dependency on journalling thread, then
> > > when time slice of fsync thread is running, it allows dispatch from
> > > jbd in the time slice of fsync thread. Hence cutting down on idling.
> > > 
> > > This patch series seems to be working for me. I did testing for ext4 only.
> > > This series is based on for-3.1/core branch of Jen's block tree.
> > > Konstantin, can you please give it a try and see if it fixes your
> > > issue.
> > > 
> > > Any feedback on how to solve this issue is appreciated.
> > Hi Vivek,
> > can we introduce a group think time check in cfq? say in a group the
> > last queue is backed for the group and the queue is a non-idle queue, if
> > the group think time is big, we don't allow the group idle and preempt
> > could happen. The fsync thread is a non-idle queue with Corrado's patch,
> > this allows fast group switch.
> 
> In this case regular queue idle is hitting and not group idle. So some
> kind of think time stats probably might be useful for group idle check
> but not necessarily for queue idle.
I thought your problem is group idle issue. fsync uses WRITE_SYNC, which
will make the queue be sync-non-idle because REQ_NOIDLE is set. This is
exactly what Corrado's patch for. a fsync queue itself isn't idle unless
it's the last queue in a group. Am I missing anything?

> Secondly, for this case think time will change. If you stop idling on
> fsync and jbd threads, both will be dispatching IOs fast and both will
> have small thinktime. We will think that thinktime is small so we
> will enable idle. Then there think time will increase as both will
> get blocked behind each other. And then we will removing idling. So
> looks like we will be oscillating between enabling and disabling
> think time.
That is possible, the think time check (even for queues) always has such
issue. Not sure how severe the issue is. Assume jbd will dispatch
several requests and this will make fsync thread think time big.

> If we don't allow idling on sync-no-idle queues, then basic CFQ will
> be broken.
Hmm, CFQ only allows idling on sync queues, sync-no-idle queue isn't
allowed idling.

Thanks,
Shaohua

