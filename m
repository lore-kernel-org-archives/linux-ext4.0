From: Nikolay Borisov <kernel@kyup.com>
Subject: Re: Lockup in wait_transaction_locked under memory pressure
Date: Thu, 25 Jun 2015 14:43:42 +0300
Message-ID: <558BE96E.7080101@kyup.com>
References: <558BD447.1010503@kyup.com> <558BD507.9070002@kyup.com> <20150625112116.GC17237@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Marian Marinov <mm@1h.com>
To: Michal Hocko <mhocko@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.siteground.com ([67.19.240.234]:51794 "EHLO
	mail.siteground.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbbFYLnp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Jun 2015 07:43:45 -0400
In-Reply-To: <20150625112116.GC17237@dhcp22.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I do have several OOM reports unfortunately I don't think I can
correlate them in any sensible way to be able to answer the question
"Which was the process that was writing prior to the D state occuring".
Maybe you can be more specific as to what am I likely looking for?

On 06/25/2015 02:21 PM, Michal Hocko wrote:
> On Thu 25-06-15 13:16:39, Nikolay Borisov wrote:
>> [Resending to linux-ext4 as the first try failed]
>>
>> On 06/25/2015 01:13 PM, Nikolay Borisov wrote:
>>> Hello,
>>>
>>> On a fairly busy server, running LXC I'm observing that sometimes
>>> the processes for a particular container lock up by going into D
>>> (uninterruptible sleep) state. Obtaining backtraces for those
>>> processes one thing which stands out is that they are all
>>> blocked in wait_transaction_locked (part of JBD2).
>>> This occurs sporadically when the particular container
>>> is under memory pressure and a process is selected by
>>> OOM for killing. I'm running kernel 4.0.0 and
>>> oom_kill_allocating_task is enabled.
> 
> Do you have the full OOM report?
> 
>>> Here are backtraces from multiple such processes:
>>>
>>>
>>> alxc9 kernel: nginx           D ffff8820a90b39a8 11496  9331  30627
>>> 0x00000004
>>> alxc9 kernel: ffff8820a90b39a8 ffff881ff284f010 ffff88396c6d1e90
>>> 0000000000000282
>>> alxc9 kernel: ffff8820a90b0010 ffff883ff12f3870 ffff883ff12f3800
>>> 0000000000027df1
>>> alxc9 kernel: ffff880413c08000 ffff8820a90b39c8 ffffffff815ab76e
>>> ffff883ff12f3870
>>> alxc9 kernel: Call Trace:
>>> alxc9 kernel: [<ffffffff815ab76e>] schedule+0x3e/0x90
>>> alxc9 kernel: [<ffffffff81264265>] wait_transaction_locked+0x85/0xc0
>>> alxc9 kernel: [<ffffffff810910d0>] ? woken_wake_function+0x20/0x20
>>> alxc9 kernel: [<ffffffff815ab18a>] ? __schedule+0x39a/0x870
>>> alxc9 kernel: [<ffffffff81264540>] add_transaction_credits+0xf0/0x250
>>> alxc9 kernel: [<ffffffff815ab76e>] ? schedule+0x3e/0x90
>>> alxc9 kernel: [<ffffffff815ae5e5>] ? schedule_timeout+0x165/0x1f0
>>> alxc9 kernel: [<ffffffff81264824>] start_this_handle+0x184/0x420
>>> alxc9 kernel: [<ffffffff810e0880>] ? __delayacct_blkio_end+0x30/0x50
>>> alxc9 kernel: [<ffffffff8117a48e>] ? kmem_cache_alloc+0xee/0x1c0
>>> alxc9 kernel: [<ffffffff81265220>] jbd2__journal_start+0x100/0x200
>>> alxc9 kernel: [<ffffffff8121da5c>] ? ext4_dirty_inode+0x3c/0x80
>>> alxc9 kernel: [<ffffffff8124bb49>] __ext4_journal_start_sb+0x79/0x100
>>> alxc9 kernel: [<ffffffff8121da5c>] ext4_dirty_inode+0x3c/0x80
>>> alxc9 kernel: [<ffffffff811be5c3>] __mark_inode_dirty+0x173/0x400
>>> alxc9 kernel: [<ffffffff811ae9c5>] generic_update_time+0x85/0xd0
>>> alxc9 kernel: [<ffffffff81120f5a>] ? filemap_map_pages+0x1ca/0x210
>>> alxc9 kernel: [<ffffffff811ae632>] file_update_time+0xb2/0x110
>>> alxc9 kernel: [<ffffffff811226c2>] __generic_file_write_iter+0x172/0x3a0
>>> alxc9 kernel: [<ffffffff81214814>] ext4_file_write_iter+0x134/0x460
>>> alxc9 kernel: [<ffffffff810ad910>] ? update_rmtp+0x80/0x80
>>> alxc9 kernel: [<ffffffff81194047>] new_sync_write+0x97/0xc0
>>> alxc9 kernel: [<ffffffff8119445e>] vfs_write+0xce/0x180
>>> alxc9 kernel: [<ffffffff81194bda>] SyS_write+0x5a/0xd0
>>> alxc9 kernel: [<ffffffff815afa89>] system_call_fastpath+0x12/0x17
>>>
>>> alxc9 kernel: mysqld          D ffff8821352638d8 11936  5176  30627
>>> 0x00000006
>>> alxc9 kernel: ffff8821352638d8 ffff881ff2848000 ffff8812d3d28a30
>>> 0000000000000286
>>> alxc9 kernel: ffff882135260010 ffff883ff12f3870 ffff883ff12f3800
>>> 0000000000027df1
>>> alxc9 kernel: ffff880413c08000 ffff8821352638f8 ffffffff815ab76e
>>> ffff883ff12f3870
>>> alxc9 kernel: Call Trace:
>>> alxc9 kernel: [<ffffffff815ab76e>] schedule+0x3e/0x90
>>> alxc9 kernel: [<ffffffff81264265>] wait_transaction_locked+0x85/0xc0
>>> alxc9 kernel: [<ffffffff810910d0>] ? woken_wake_function+0x20/0x20
>>> alxc9 kernel: [<ffffffff81264540>] add_transaction_credits+0xf0/0x250
>>> alxc9 kernel: [<ffffffff81264824>] start_this_handle+0x184/0x420
>>> alxc9 kernel: [<ffffffff8117a48e>] ? kmem_cache_alloc+0xee/0x1c0
>>> alxc9 kernel: [<ffffffff81265220>] jbd2__journal_start+0x100/0x200
>>> alxc9 kernel: [<ffffffff8121fa70>] ? ext4_evict_inode+0x190/0x490
>>> alxc9 kernel: [<ffffffff8124bb49>] __ext4_journal_start_sb+0x79/0x100
>>> alxc9 kernel: [<ffffffff8121fa70>] ext4_evict_inode+0x190/0x490
>>> alxc9 kernel: [<ffffffff811af6d8>] evict+0xb8/0x1a0
>>> alxc9 kernel: [<ffffffff811af8b6>] iput_final+0xf6/0x190
>>> alxc9 kernel: [<ffffffff811b0230>] iput+0xa0/0xe0
>>> alxc9 kernel: [<ffffffff811ab068>] dentry_iput+0xa8/0xf0
>>> alxc9 kernel: [<ffffffff811ac1c5>] __dentry_kill+0x85/0x130
>>> alxc9 kernel: [<ffffffff811ac42c>] dput+0x1bc/0x220
>>> alxc9 kernel: [<ffffffff811966b4>] __fput+0x144/0x200
>>> alxc9 kernel: [<ffffffff8119681e>] ____fput+0xe/0x10
>>> alxc9 kernel: [<ffffffff8106dc85>] task_work_run+0xd5/0x120
>>> alxc9 kernel: [<ffffffff810537d9>] do_exit+0x1b9/0x560
>>> alxc9 kernel: [<ffffffff810aebc2>] ? hrtimer_cancel+0x22/0x30
>>> alxc9 kernel: [<ffffffff81053bd6>] do_group_exit+0x56/0x100
>>> alxc9 kernel: [<ffffffff81061787>] get_signal+0x237/0x530
>>> alxc9 kernel: [<ffffffff81002d45>] do_signal+0x25/0x130
>>> alxc9 kernel: [<ffffffff810a57d9>] ? rcu_eqs_exit+0x79/0xb0
>>> alxc9 kernel: [<ffffffff810a5823>] ? rcu_user_exit+0x13/0x20
>>> alxc9 kernel: [<ffffffff81002ec8>] do_notify_resume+0x78/0xb0
>>> alxc9 kernel: [<ffffffff815afce3>] int_signal+0x12/0x17
>>>
>>> My hypotheses is that the OOM is killing a process while its performing
>>> a write to a transaction without it having a chance to complete it which
>>> leaves all other processes waiting to be woken up, which naturally never
>>> happens. I wonder whether such a failure scenario is even possible? If
>>> not then what could possibly force a transaction to stall for hours?
> 
> I am not familiar with ext4 code much but I assume that even if the oom
> victim was writing to the transaction and the allocation had failed then
> the transaction should have failed as well.
> It would be a bit different if that allocation was GFP_NOFAIL and the
> memory reserves were completely depleted then it would loop inside the
> allocator and never finish the write (until something else releases
> memory). You can increase min_free_kbytes to increase memory reserves.
> 
> But this is just a wild guess. sysrq+m would tell us more about the
> current state of the memory. It would be also good to check whether the
> OOM victim managed to die (oom report and sysrq+t).
> 
