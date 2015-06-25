From: Nikolay Borisov <kernel@kyup.com>
Subject: Re: Lockup in wait_transaction_locked under memory pressure
Date: Thu, 25 Jun 2015 16:29:31 +0300
Message-ID: <558C023B.1040204@kyup.com>
References: <558BD447.1010503@kyup.com> <558BD507.9070002@kyup.com> <20150625112116.GC17237@dhcp22.suse.cz> <558BE96E.7080101@kyup.com> <20150625115025.GD17237@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Marian Marinov <mm@1h.com>
To: Michal Hocko <mhocko@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.siteground.com ([67.19.240.234]:52877 "EHLO
	mail.siteground.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbbFYN3e (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Jun 2015 09:29:34 -0400
In-Reply-To: <20150625115025.GD17237@dhcp22.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I couldn't find any particular OOM which stands out, here how a typical 
one looks like: 

alxc9 kernel: Memory cgroup out of memory (oom_kill_allocating_task): Kill process 9703 (postmaster) score 0 or sacrifice child
alxc9 kernel: Killed process 9703 (postmaster) total-vm:205800kB, anon-rss:1128kB, file-rss:0kB
alxc9 kernel: php invoked oom-killer: gfp_mask=0xd0, order=0, oom_score_adj=0
alxc9 kernel: php cpuset=cXXXX mems_allowed=0-1
alxc9 kernel: CPU: 12 PID: 1000 Comm: php Not tainted 4.0.0-clouder9+ #31
alxc9 kernel: Hardware name: Supermicro X9DRD-7LN4F(-JBOD)/X9DRD-EF/X9DRD-7LN4F, BIOS 3.2 01/16/2015
alxc9 kernel: ffff8805d8440400 ffff88208d863c78 ffffffff815aaca3 ffff8820b947c750
alxc9 kernel: ffff8820b947c750 ffff88208d863cc8 ffffffff81123b2e ffff882000000000
alxc9 kernel: ffffffff000000d0 ffff8805d8440400 ffff8820b947c750 ffff8820b947cee0
alxc9 kernel: Call Trace:
alxc9 kernel: [<ffffffff815aaca3>] dump_stack+0x48/0x5d
alxc9 kernel: [<ffffffff81123b2e>] dump_header+0x8e/0xe0
alxc9 kernel: [<ffffffff81123fa7>] oom_kill_process+0x1d7/0x3c0
alxc9 kernel: [<ffffffff810d85a1>] ? cpuset_mems_allowed_intersects+0x21/0x30
alxc9 kernel: [<ffffffff8118c2bd>] mem_cgroup_out_of_memory+0x2bd/0x370
alxc9 kernel: [<ffffffff81189b37>] ? mem_cgroup_iter+0x177/0x390
alxc9 kernel: [<ffffffff8118c5d7>] mem_cgroup_oom_synchronize+0x267/0x290
alxc9 kernel: [<ffffffff811874f0>] ? mem_cgroup_wait_acct_move+0x140/0x140
alxc9 kernel: [<ffffffff81124504>] pagefault_out_of_memory+0x24/0xe0
alxc9 kernel: [<ffffffff81041927>] mm_fault_error+0x47/0x160
alxc9 kernel: [<ffffffff81041db0>] __do_page_fault+0x340/0x3c0
alxc9 kernel: [<ffffffff81041e6c>] do_page_fault+0x3c/0x90
alxc9 kernel: [<ffffffff815b1758>] page_fault+0x28/0x30
alxc9 kernel: Task in /lxc/cXXXX killed as a result of limit of /lxc/cXXXX
alxc9 kernel: memory: usage 2097152kB, limit 2097152kB, failcnt 7832302
alxc9 kernel: memory+swap: usage 2097152kB, limit 2621440kB, failcnt 0
alxc9 kernel: kmem: usage 0kB, limit 9007199254740988kB, failcnt 0
alxc9 kernel: Memory cgroup stats for /lxc/cXXXX: cache:22708KB rss:2074444KB rss_huge:0KB 
mapped_file:19960KB writeback:4KB swap:0KB inactive_anon:20364KB active_anon:2074896KB 
inactive_file:1236KB active_file:464KB unevictable:0KB

The backtrace for other processes is exactly the same. 


On 06/25/2015 02:50 PM, Michal Hocko wrote:
> On Thu 25-06-15 14:43:42, Nikolay Borisov wrote:
>> I do have several OOM reports unfortunately I don't think I can
>> correlate them in any sensible way to be able to answer the question
>> "Which was the process that was writing prior to the D state occuring".
>> Maybe you can be more specific as to what am I likely looking for?
> 
> Is the system still in this state? If yes I would check the last few OOM
> reports which will tell you the pid of the oom victim and then I would
> check sysrq+t whether they are still alive. And if yes check their stack
> traces to see whether they are still in the allocation path or they got
> stuck somewhere else or maybe they are not related at all...
> 
> sysrq+t might be useful even when this is not oom related because it can
> pinpoint the task which is blocking your waiters.
> 
