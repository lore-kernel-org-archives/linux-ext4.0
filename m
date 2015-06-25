From: Michal Hocko <mhocko@suse.cz>
Subject: Re: Lockup in wait_transaction_locked under memory pressure
Date: Thu, 25 Jun 2015 15:45:58 +0200
Message-ID: <20150625134558.GF17237@dhcp22.suse.cz>
References: <558BD447.1010503@kyup.com>
 <558BD507.9070002@kyup.com>
 <20150625112116.GC17237@dhcp22.suse.cz>
 <558BE96E.7080101@kyup.com>
 <20150625115025.GD17237@dhcp22.suse.cz>
 <558C023B.1040204@kyup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Marian Marinov <mm@1h.com>
To: Nikolay Borisov <kernel@kyup.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50226 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213AbbFYNp7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Jun 2015 09:45:59 -0400
Content-Disposition: inline
In-Reply-To: <558C023B.1040204@kyup.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 25-06-15 16:29:31, Nikolay Borisov wrote:
> I couldn't find any particular OOM which stands out, here how a typical 
> one looks like: 
> 
> alxc9 kernel: Memory cgroup out of memory (oom_kill_allocating_task): Kill process 9703 (postmaster) score 0 or sacrifice child
> alxc9 kernel: Killed process 9703 (postmaster) total-vm:205800kB, anon-rss:1128kB, file-rss:0kB
> alxc9 kernel: php invoked oom-killer: gfp_mask=0xd0, order=0, oom_score_adj=0
> alxc9 kernel: php cpuset=cXXXX mems_allowed=0-1
> alxc9 kernel: CPU: 12 PID: 1000 Comm: php Not tainted 4.0.0-clouder9+ #31
> alxc9 kernel: Hardware name: Supermicro X9DRD-7LN4F(-JBOD)/X9DRD-EF/X9DRD-7LN4F, BIOS 3.2 01/16/2015
> alxc9 kernel: ffff8805d8440400 ffff88208d863c78 ffffffff815aaca3 ffff8820b947c750
> alxc9 kernel: ffff8820b947c750 ffff88208d863cc8 ffffffff81123b2e ffff882000000000
> alxc9 kernel: ffffffff000000d0 ffff8805d8440400 ffff8820b947c750 ffff8820b947cee0
> alxc9 kernel: Call Trace:
> alxc9 kernel: [<ffffffff815aaca3>] dump_stack+0x48/0x5d
> alxc9 kernel: [<ffffffff81123b2e>] dump_header+0x8e/0xe0
> alxc9 kernel: [<ffffffff81123fa7>] oom_kill_process+0x1d7/0x3c0
> alxc9 kernel: [<ffffffff810d85a1>] ? cpuset_mems_allowed_intersects+0x21/0x30
> alxc9 kernel: [<ffffffff8118c2bd>] mem_cgroup_out_of_memory+0x2bd/0x370
> alxc9 kernel: [<ffffffff81189b37>] ? mem_cgroup_iter+0x177/0x390
> alxc9 kernel: [<ffffffff8118c5d7>] mem_cgroup_oom_synchronize+0x267/0x290
> alxc9 kernel: [<ffffffff811874f0>] ? mem_cgroup_wait_acct_move+0x140/0x140
> alxc9 kernel: [<ffffffff81124504>] pagefault_out_of_memory+0x24/0xe0
> alxc9 kernel: [<ffffffff81041927>] mm_fault_error+0x47/0x160
> alxc9 kernel: [<ffffffff81041db0>] __do_page_fault+0x340/0x3c0
> alxc9 kernel: [<ffffffff81041e6c>] do_page_fault+0x3c/0x90
> alxc9 kernel: [<ffffffff815b1758>] page_fault+0x28/0x30
> alxc9 kernel: Task in /lxc/cXXXX killed as a result of limit of /lxc/cXXXX
> alxc9 kernel: memory: usage 2097152kB, limit 2097152kB, failcnt 7832302
> alxc9 kernel: memory+swap: usage 2097152kB, limit 2621440kB, failcnt 0
> alxc9 kernel: kmem: usage 0kB, limit 9007199254740988kB, failcnt 0
> alxc9 kernel: Memory cgroup stats for /lxc/cXXXX: cache:22708KB rss:2074444KB rss_huge:0KB 
> mapped_file:19960KB writeback:4KB swap:0KB inactive_anon:20364KB active_anon:2074896KB 
> inactive_file:1236KB active_file:464KB unevictable:0KB
> 
> The backtrace for other processes is exactly the same. 

OK, so this is not the global OOM killer. That wasn't clear from your
previous description. It makes a difference because it means that the
system is still healthy globaly and allocation requests will not loop
for ever in the allocator. Memcg charging path will not get blocked
until the OOM resolves and return ENOMEM when not called from the page
fault path.

memcg oom killer ignores oom_kill_allocating_task so the victim might be
different from the current task. That means the victim might get stuck
behind a lock held by somebody else. If the ext4 journaling code depends
on memcg charges and retry endlessly then the waiters would get stuck as
well.

I can see some calls to find_or_create_page from fs/ext4/mballoc.c but
AFAIU they are handling ENOMEM and lead to transaction abort - but I am
not familiar with this code enough so somebody familiar with ext4 should
double check that.

This all suggests that your lockup is caused by something else than OOM
most probably.
-- 
Michal Hocko
SUSE Labs
