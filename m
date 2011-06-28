From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC PATCH 0/3] block: Fix fsync slowness with CFQ cgroups
Date: Tue, 28 Jun 2011 09:35:58 -0400
Message-ID: <20110628133557.GB17552@redhat.com>
References: <1309205864-13124-1-git-send-email-vgoyal@redhat.com>
 <20110628024738.GJ32466@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, jaxboe@fusionio.com,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	khlebnikov@openvz.org, jmoyer@redhat.com
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62976 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756719Ab1F1NgD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Jun 2011 09:36:03 -0400
Content-Disposition: inline
In-Reply-To: <20110628024738.GJ32466@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 28, 2011 at 12:47:38PM +1000, Dave Chinner wrote:
> 
> Vivek, I'm not sure this is a general solution. If we hand journal
> IO off to a workqueue, then we've got no idea what the "dependent
> task" is.
> 
> I bring this up as I have a current patchset that moves all the XFS
> journal IO out of process context into a workqueue to solve
> process-visible operation latency (e.g. 1000 mkdir syscalls run at
> 1ms each, the 1001st triggers a journal checkpoint and takes 500ms)
> and background checkpoint submission races.  This effectively means
> that XFS will trigger the same bad CFQ behaviour on fsync, but have
> no means of avoiding it because we don't have a specific task to
> yield to.
> 
> And FWIW, we're going to be using workqueues more and more in XFS
> for asynchronous processing of operations. I'm looking to use WQs
> for speculative readahead of inodes, all our delayed metadata
> writeback, log IO submission, free space allocation requests,
> background inode allocation, background inode freeing, background
> EOF truncation, etc to process as much work asynchronously outside
> syscall context as possible (let's use all those CPU cores we
> have!).
> 
> All of these things will push potentially dependent IO operations
> outside of the bounds of the process actually doing the operation,
> so some general solution to the "dependent IO in an undefined thread
> context" problem really needs to be solved sooner rather than
> later...
> 
> As it is, I don't have any good ideas of how to solve this, but I
> thought it is worth bringing to your attention while you are trying
> to solve a similar issue.

Dave,

Coule of thoughts.

- We can introduce anohter block layer call were dependencies are setup
  from worker thread context. So when the process schedules the work, it can
  save the task information somewhere and when the worker thread actually
  calls the specified funciton, that function can setup the dependency
  between worker thread and submitting task.

  Probably original process can tear down the dependency connection
  when IO is done. I am assuming that IO submitting process is waiting
  for all IO to finish.

  In current framework one can specify multiple processes being dependent
  on one thread but not vice-a-versa. I think we should be able to 
  handle that by maintaining a linked list of dependent queues instead
  of single pointer. So if a process submits a bunch of jobs with help
  of bunch of worker threads from multiple cpus, I think that case is
  manageable with some extension to current patches.

- Or we can also try to do something more exotic and that when we schedule
  a work, one should be able to tell which cgroup the worker should run in.
  When the worker actually runs, it can migrate itself to destination
  destination cgroup and submit IO. This does not take care of cases like
  journalling thread where multiple processes are dependent on single
  kernel thread. In that case above dependent queue solution should work
  well.

So I think above API can be extended to handle the case of work queues
also or we could look into migrating worker in user specified cgroup if
that turns out to be a better solution. 

Thanks
Vivek
