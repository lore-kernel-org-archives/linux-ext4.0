From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Lockup in wait_transaction_locked under memory pressure
Date: Thu, 25 Jun 2015 10:45:53 -0400
Message-ID: <20150625144553.GA6596@thunk.org>
References: <558BD447.1010503@kyup.com>
 <558BD507.9070002@kyup.com>
 <20150625112116.GC17237@dhcp22.suse.cz>
 <558BE96E.7080101@kyup.com>
 <20150625115025.GD17237@dhcp22.suse.cz>
 <20150625133138.GH14324@thunk.org>
 <558C06F7.9050406@kyup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Michal Hocko <mhocko@suse.cz>, linux-ext4@vger.kernel.org,
	Marian Marinov <mm@1h.com>
To: Nikolay Borisov <kernel@kyup.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54719 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751952AbbFYOp5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Jun 2015 10:45:57 -0400
Content-Disposition: inline
In-Reply-To: <558C06F7.9050406@kyup.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 25, 2015 at 04:49:43PM +0300, Nikolay Borisov wrote:
> 
> You know it might be possible that I'm observing exactly this, 
> since the other places where processes are blocked (but I 
> omitted initially since I thought it's inconsequential) 
> is in the following code path:
>  
> Jun 24 11:22:59 alxc9 kernel: crond           D ffff8820b8affe58 14784 30568  30627 0x00000004
> Jun 24 11:22:59 alxc9 kernel: ffff8820b8affe58 ffff8820ca72b2f0 ffff882c3534b2f0 000000000000fe4e
> Jun 24 11:22:59 alxc9 kernel: ffff8820b8afc010 ffff882c3534b2f0 ffff8808d2d7e34c 00000000ffffffff
> Jun 24 11:22:59 alxc9 kernel: ffff8808d2d7e350 ffff8820b8affe78 ffffffff815ab76e ffff882c3534b2f0
> Jun 24 11:22:59 alxc9 kernel: Call Trace:
> Jun 24 11:22:59 alxc9 kernel: [<ffffffff815ab76e>] schedule+0x3e/0x90
> Jun 24 11:22:59 alxc9 kernel: [<ffffffff815ab9de>] schedule_preempt_disabled+0xe/0x10
> Jun 24 11:22:59 alxc9 kernel: [<ffffffff815ad505>] __mutex_lock_slowpath+0x95/0x110
> Jun 24 11:22:59 alxc9 kernel: [<ffffffff810a57d9>] ? rcu_eqs_exit+0x79/0xb0
> Jun 24 11:22:59 alxc9 kernel: [<ffffffff815ad59b>] mutex_lock+0x1b/0x30
> Jun 24 11:22:59 alxc9 kernel: [<ffffffff811b1fbd>] __fdget_pos+0x3d/0x50
> Jun 24 11:22:59 alxc9 kernel: [<ffffffff810119d7>] ? syscall_trace_leave+0xa7/0xf0
> Jun 24 11:22:59 alxc9 kernel: [<ffffffff81194bb3>] SyS_write+0x33/0xd0
> Jun 24 11:22:59 alxc9 kernel: [<ffffffff815afcc8>] ? int_check_syscall_exit_work+0x34/0x3d
> Jun 24 11:22:59 alxc9 kernel: [<ffffffff815afa89>] system_call_fastpath+0x12/0x17
> 
> Particularly, I can see a lot of processes locked up
> in __fdget_pos -> mutex_lock. And this all sounds very 
> similar to what you just described.

What we would need to do is to analyze the stack traces of *all* of
the processes.  It's clear that you have a lot of processes waiting on
something to clear, but we need to figure out what that might be.  We
could be waiting on some memory allocation to complete; we could be
waiting for disk I/O to complete (which could get throttled for any
number of different reasons, including a cgroup's disk I/O limits), etc. 

> How would you advise to rectify such situation?

In addition to trying to figure this out by analyzing all of the
kernel strace traces, you could also try to figure this out by
experimental methods.

Determine which containiners all of the processes that are stalled in
disk wait, and try relaxing the memory and disk and cpu contraints on
each of the containers, one at a time.  Say, add 50% to each limit, or
make it be unlimited.  I would suggest starting with containers that
contain processes that are trying to exit due to being OOM killed.

After you change each limit, see if it unclogs the system.  If it
does, then you'll know a bit more about what caused the system.  It
also suggest a terrible hack, namely a process which scrapes dmesg
output, and when it sees a process that has been oom killed, if it is
in a container, send kill signals to all of the processes in that
container (since if one process has exited, it's likely that container
isn't going to be functioning correctly anyway), and then unconstrain
the cgroup limits for all of the processes in that container.

The container manager can then restart the container, after it has
exited cleanly.  Yes, it's a kludge.  But it's a kludge that I bet
will work, which makes it a devops procedure.  :-)

						- Ted
