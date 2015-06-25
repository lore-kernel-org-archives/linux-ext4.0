From: Nikolay Borisov <kernel@kyup.com>
Subject: Re: Lockup in wait_transaction_locked under memory pressure
Date: Thu, 25 Jun 2015 16:49:43 +0300
Message-ID: <558C06F7.9050406@kyup.com>
References: <558BD447.1010503@kyup.com> <558BD507.9070002@kyup.com> <20150625112116.GC17237@dhcp22.suse.cz> <558BE96E.7080101@kyup.com> <20150625115025.GD17237@dhcp22.suse.cz> <20150625133138.GH14324@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Marian Marinov <mm@1h.com>
To: Theodore Ts'o <tytso@mit.edu>, Michal Hocko <mhocko@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.siteground.com ([67.19.240.234]:53048 "EHLO
	mail.siteground.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbbFYNtr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Jun 2015 09:49:47 -0400
In-Reply-To: <20150625133138.GH14324@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On 06/25/2015 04:31 PM, Theodore Ts'o wrote:
> On Thu, Jun 25, 2015 at 01:50:25PM +0200, Michal Hocko wrote:
>> On Thu 25-06-15 14:43:42, Nikolay Borisov wrote:
>>> I do have several OOM reports unfortunately I don't think I can
>>> correlate them in any sensible way to be able to answer the question
>>> "Which was the process that was writing prior to the D state occuring".
>>> Maybe you can be more specific as to what am I likely looking for?
>>
>> Is the system still in this state? If yes I would check the last few OOM
>> reports which will tell you the pid of the oom victim and then I would
>> check sysrq+t whether they are still alive. And if yes check their stack
>> traces to see whether they are still in the allocation path or they got
>> stuck somewhere else or maybe they are not related at all...
>>
>> sysrq+t might be useful even when this is not oom related because it can
>> pinpoint the task which is blocking your waiters.
> 
> In addition to sysrq+t, the other thing to do is to sample sysrq-p a
> few half-dozen times so we can see if there are any processes in some
> memory allocation retry loop.  Also useful is to enable soft lockup
> detection.
> 
> Something that perhaps we should have (and maybe GFP_NOFAIL should
> imply this) is for places where your choices are either (a) let the
> memory allocation succeed eventually, or (b) remount the file system
> read-only and/or panic the system, is in the case where we're under
> severe memory pressure due to cgroup settings, to simply allow the
> kmalloc to bypass the cgroup allocation limits, since otherwise the
> stall could end up impacting processes in other cgroups.
> 
> This is basically the same issue as a misconfigured cgroup which as
> very tiny disk I/O and memory allocated to it, such that when a
> process in that cgroup does a directory lookup, VFS locks the
> directory *before* calling into the file system layer, and then if
> cgroup isn't allow much in the way of memory and disk time, it's
> likely that the directory block has been pushed out of memory, and on
> a sufficiently busy system, the directory read might not happen for
> minutes or *hours* (both because of the disk I/O limits as well as the
> time needed to clean memory to allow the necessary memory allocation
> to succeed).
> 
> In the meantime, if a process in another cgroup, with plenty of
> disk-time and memory, tries to do anything else with that directory,
> it will run into locked directory mutex, and *wham*.  Priority
> inversion.  It gets even more amusing if this process is the overall
> docker or other cgroup manager, since then the entire system is out to
> lunch, and so then a watchdog daemon fires, and reboots the entire
> system....
> 

You know it might be possible that I'm observing exactly this, 
since the other places where processes are blocked (but I 
omitted initially since I thought it's inconsequential) 
is in the following code path:
 
Jun 24 11:22:59 alxc9 kernel: crond           D ffff8820b8affe58 14784 30568  30627 0x00000004
Jun 24 11:22:59 alxc9 kernel: ffff8820b8affe58 ffff8820ca72b2f0 ffff882c3534b2f0 000000000000fe4e
Jun 24 11:22:59 alxc9 kernel: ffff8820b8afc010 ffff882c3534b2f0 ffff8808d2d7e34c 00000000ffffffff
Jun 24 11:22:59 alxc9 kernel: ffff8808d2d7e350 ffff8820b8affe78 ffffffff815ab76e ffff882c3534b2f0
Jun 24 11:22:59 alxc9 kernel: Call Trace:
Jun 24 11:22:59 alxc9 kernel: [<ffffffff815ab76e>] schedule+0x3e/0x90
Jun 24 11:22:59 alxc9 kernel: [<ffffffff815ab9de>] schedule_preempt_disabled+0xe/0x10
Jun 24 11:22:59 alxc9 kernel: [<ffffffff815ad505>] __mutex_lock_slowpath+0x95/0x110
Jun 24 11:22:59 alxc9 kernel: [<ffffffff810a57d9>] ? rcu_eqs_exit+0x79/0xb0
Jun 24 11:22:59 alxc9 kernel: [<ffffffff815ad59b>] mutex_lock+0x1b/0x30
Jun 24 11:22:59 alxc9 kernel: [<ffffffff811b1fbd>] __fdget_pos+0x3d/0x50
Jun 24 11:22:59 alxc9 kernel: [<ffffffff810119d7>] ? syscall_trace_leave+0xa7/0xf0
Jun 24 11:22:59 alxc9 kernel: [<ffffffff81194bb3>] SyS_write+0x33/0xd0
Jun 24 11:22:59 alxc9 kernel: [<ffffffff815afcc8>] ? int_check_syscall_exit_work+0x34/0x3d
Jun 24 11:22:59 alxc9 kernel: [<ffffffff815afa89>] system_call_fastpath+0x12/0x17

Particularly, I can see a lot of processes locked up
in __fdget_pos -> mutex_lock. And this all sounds very 
similar to what you just described.

How would you advise to rectify such situation?

>        		       	      	  	  - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
