Return-Path: <SRS0=hSPz=NR=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50752 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387921AbeKFTrE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 6 Nov 2018 14:47:04 -0500
Date: Tue, 6 Nov 2018 11:22:30 +0100
From: Jan Kara <jack@suse.cz>
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH] jbd2: Avoid long hold times of j_state_lock while
 committing a transaction
Message-ID: <20181106102230.GC25414@quack2.suse.cz>
References: <20181016094248.21359-1-jack@suse.cz>
 <20181106052051.GD6416@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181106052051.GD6416@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 06-11-18 00:20:51, Theodore Y. Ts'o wrote:
> On Tue, Oct 16, 2018 at 11:42:48AM +0200, Jan Kara wrote:
> > We can hold j_state_lock for writing at the beginning of
> > jbd2_journal_commit_transaction() for a rather long time (reportedly for
> > 30 ms) due cleaning revoke bits of all revoked buffers under it. The
> > handling of revoke tables as well as cleaning of t_reserved_list, and
> > checkpoint lists does not need j_state_lock for anything. Furthermore
> > the transaction is in T_LOCKED state and we waited for all outstanding
> > handles so nobody is going to be adding anything to the transaction.
> > 
> > Just drop the lock for unnecessary operations.
> > 
> > Reported-and-tested-by: Adrian Hunter <adrian.hunter@intel.com>
> > Suggested-by: "Theodore Y. Ts'o" <tytso@mit.edu>
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> Unfortunately, this patch is causing a regression in generic/241 in
> the dioread_nolock configuration.   To reproduce:
> 
> % gce-xftests -c dioread_nolock generic/241
> 
> which will result in the decoded stack trace:
> 
> [   42.926455] run fstests generic/241 at 2018-11-06 00:12:30
> [   51.091678] JBD2: assertion failure: h_type=11 h_line_no=4921 block_no=524337 jlist=3

So the buffer is on BJ_Shadow list while the assertion in
jbd2_journal_dirty_metadata() expects it to be in BJ_Metadata list. This is
really weird as we have also checked that jh->b_transaction ==
handle->h_transaction so the transaction couldn't have passed to commit
phase... Oh, I see, the code in start_this_handle() got racy with the
removal of j_state_lock protection from journal_commit_transaction() so now
transaction can start even though there are handles outstanding! I'll think
about the best solution for this. Thanks for report!

								Honza

> [   51.101179] ------------[ cut here ]------------
> [   51.106191] kernel BUG at fs/jbd2/transaction.c:1372!
> [   51.111716] invalid opcode: 0000 [#1] SMP PTI
> [   51.116198] CPU: 0 PID: 177 Comm: kworker/u4:2 Not tainted 4.19.0-rc6-xfstests-00022-g895dc4ba4f98 #730
> [   51.125809] Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> [   51.135375] Workqueue: ext4-rsv-conversion ext4_end_io_rsv_work
> [   51.141433] RIP: 0010:jbd2_journal_dirty_metadata.cold.7 (??:?) 
> [ 51.147867] Code: c1 ea 0c 66 c1 ee 04 0f b7 d2 40 0f b6 f6 e8 c4 64 de ff 4d 39 6c 24 28 0f 85 22 f4 ff ff 41 83 7c 24 0c 01 0f 84 16 f4 ff ff <0f> 0b 4d 85 c9 74 2c 41 8b 41 08 44 8b 41 08 49 8d b7 c8 05 00 00
> All code
> ========
>    0:	c1 ea 0c             	shr    $0xc,%edx
>    3:	66 c1 ee 04          	shr    $0x4,%si
>    7:	0f b7 d2             	movzwl %dx,%edx
>    a:	40 0f b6 f6          	movzbl %sil,%esi
>    e:	e8 c4 64 de ff       	callq  0xffffffffffde64d7
>   13:	4d 39 6c 24 28       	cmp    %r13,0x28(%r12)
>   18:	0f 85 22 f4 ff ff    	jne    0xfffffffffffff440
>   1e:	41 83 7c 24 0c 01    	cmpl   $0x1,0xc(%r12)
>   24:	0f 84 16 f4 ff ff    	je     0xfffffffffffff440
>   2a:*	0f 0b                	ud2    		<-- trapping instruction
>   2c:	4d 85 c9             	test   %r9,%r9
>   2f:	74 2c                	je     0x5d
>   31:	41 8b 41 08          	mov    0x8(%r9),%eax
>   35:	44 8b 41 08          	mov    0x8(%rcx),%r8d
>   39:	49 8d b7 c8 05 00 00 	lea    0x5c8(%r15),%rsi
> 
> Code starting with the faulting instruction
> ===========================================
>    0:	0f 0b                	ud2    
>    2:	4d 85 c9             	test   %r9,%r9
>    5:	74 2c                	je     0x33
>    7:	41 8b 41 08          	mov    0x8(%r9),%eax
>    b:	44 8b 41 08          	mov    0x8(%rcx),%r8d
>    f:	49 8d b7 c8 05 00 00 	lea    0x5c8(%r15),%rsi
> [   51.166848] RSP: 0018:ffffb08481573c60 EFLAGS: 00010202
> [   51.172195] RAX: 0000000000000049 RBX: ffff8e72c98e6c98 RCX: 0000000000000000
> [   51.179737] RDX: 0000000000000000 RSI: ffff8e72dfbd54c8 RDI: ffff8e72dfbd54c8
> [   51.187020] RBP: ffff8e72d3247600 R08: 0000001969fa2eee R09: 0000000000000000
> [   51.194639] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8e72c21b22a0
> [   51.201985] R13: ffff8e72c224ce00 R14: 0000000000000000 R15: ffff8e72d2dc9000
> [   51.209795] FS:  0000000000000000(0000) GS:ffff8e72dfa00000(0000) knlGS:0000000000000000
> [   51.218109] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   51.224006] CR2: 00007f67fc9bc420 CR3: 0000000174612001 CR4: 00000000001606f0
> [   51.232026] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   51.240026] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [   51.247810] Call Trace:
> [   51.250394] __ext4_handle_dirty_metadata (include/linux/jbd2.h:1501 fs/ext4/ext4_jbd2.c:271) 
> [   51.255691] ext4_do_update_inode.isra.11 (fs/ext4/inode.c:5324) 
> [   51.261187] ? __ext4_journal_get_write_access (fs/ext4/ext4_jbd2.c:170) 
> [   51.266943] ? ext4_convert_unwritten_extents (fs/ext4/extents.c:4951) 
> [   51.272984] ext4_mark_iloc_dirty (fs/ext4/inode.c:5849) 
> [   51.277389] ext4_mark_inode_dirty (fs/ext4/inode.c:6028) 
> [   51.282260] ext4_convert_unwritten_extents (fs/ext4/extents.c:4951) 
> [   51.287900] ext4_end_io_rsv_work (fs/ext4/page-io.c:161 fs/ext4/page-io.c:234 fs/ext4/page-io.c:248) 
> [   51.292523] process_one_work (arch/x86/include/asm/jump_label.h:36 include/linux/jump_label.h:142 include/trace/events/workqueue.h:114 kernel/workqueue.c:2158) 
> [   51.296937] worker_thread (include/linux/compiler.h:188 include/linux/list.h:203 kernel/workqueue.c:2297) 
> [   51.301379] ? process_one_work (kernel/workqueue.c:2239) 
> [   51.305700] kthread (kernel/kthread.c:246) 
> [   51.309048] ? kthread_park (kernel/kthread.c:206) 
> [   51.312836] ret_from_fork (arch/x86/entry/entry_64.S:419) 
> [   51.316531] Modules linked in: sg
> [   51.320170] ---[ end trace 14f78710c7a5d90b ]---
> [   51.325121] RIP: 0010:jbd2_journal_dirty_metadata.cold.7 (??:?) 
> [ 51.331516] Code: c1 ea 0c 66 c1 ee 04 0f b7 d2 40 0f b6 f6 e8 c4 64 de ff 4d 39 6c 24 28 0f 85 22 f4 ff ff 41 83 7c 24 0c 01 0f 84 16 f4 ff ff <0f> 0b 4d 85 c9 74 2c 41 8b 41 08 44 8b 41 08 49 8d b7 c8 05 00 00
> All code
> ========
>    0:	c1 ea 0c             	shr    $0xc,%edx
>    3:	66 c1 ee 04          	shr    $0x4,%si
>    7:	0f b7 d2             	movzwl %dx,%edx
>    a:	40 0f b6 f6          	movzbl %sil,%esi
>    e:	e8 c4 64 de ff       	callq  0xffffffffffde64d7
>   13:	4d 39 6c 24 28       	cmp    %r13,0x28(%r12)
>   18:	0f 85 22 f4 ff ff    	jne    0xfffffffffffff440
>   1e:	41 83 7c 24 0c 01    	cmpl   $0x1,0xc(%r12)
>   24:	0f 84 16 f4 ff ff    	je     0xfffffffffffff440
>   2a:*	0f 0b                	ud2    		<-- trapping instruction
>   2c:	4d 85 c9             	test   %r9,%r9
>   2f:	74 2c                	je     0x5d
>   31:	41 8b 41 08          	mov    0x8(%r9),%eax
>   35:	44 8b 41 08          	mov    0x8(%rcx),%r8d
>   39:	49 8d b7 c8 05 00 00 	lea    0x5c8(%r15),%rsi
> 
> Code starting with the faulting instruction
> ===========================================
>    0:	0f 0b                	ud2    
>    2:	4d 85 c9             	test   %r9,%r9
>    5:	74 2c                	je     0x33
>    7:	41 8b 41 08          	mov    0x8(%r9),%eax
>    b:	44 8b 41 08          	mov    0x8(%rcx),%r8d
>    f:	49 8d b7 c8 05 00 00 	lea    0x5c8(%r15),%rsi
> [   51.350792] RSP: 0018:ffffb08481573c60 EFLAGS: 00010202
> [   51.356407] RAX: 0000000000000049 RBX: ffff8e72c98e6c98 RCX: 0000000000000000
> [   51.363778] RDX: 0000000000000000 RSI: ffff8e72dfbd54c8 RDI: ffff8e72dfbd54c8
> [   51.371485] RBP: ffff8e72d3247600 R08: 0000001969fa2eee R09: 0000000000000000
> [   51.378856] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8e72c21b22a0
> [   51.386323] R13: ffff8e72c224ce00 R14: 0000000000000000 R15: ffff8e72d2dc9000
> [   51.393775] FS:  0000000000000000(0000) GS:ffff8e72dfa00000(0000) knlGS:0000000000000000
> [   51.402416] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   51.408605] CR2: 00007f67fc9bc420 CR3: 0000000174612001 CR4: 00000000001606f0
> [   51.416057] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   51.423596] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [   51.431668] BUG: sleeping function called from invalid context at include/linux/percpu-rwsem.h:34
> [   51.441028] in_atomic(): 1, irqs_disabled(): 0, pid: 177, name: kworker/u4:2
> [   51.448399] INFO: lockdep is turned off.
> [   51.452644] CPU: 0 PID: 177 Comm: kworker/u4:2 Tainted: G      D           4.19.0-rc6-xfstests-00022-g895dc4ba4f98 #730
> [   51.464004] Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> [   51.473697] Workqueue: ext4-rsv-conversion ext4_end_io_rsv_work
> [   51.479745] Call Trace:
> [   51.482499] dump_stack (lib/dump_stack.c:115) 
> [   51.486326] ___might_sleep.cold.12 (kernel/sched/core.c:6145) 
> [   51.491043] exit_signals (include/linux/percpu-rwsem.h:36 include/linux/percpu-rwsem.h:59 include/linux/cgroup-defs.h:691 kernel/signal.c:2598) 
> [   51.494749] do_exit (kernel/exit.c:818) 
> [   51.498387] ? process_one_work (kernel/workqueue.c:2239) 
> [   51.502698] ? kthread (kernel/kthread.c:246) 
> [   51.506218] rewind_stack_do_exit (??:?) 
> [   51.510639] note: kworker/u4:2[177] exited with preempt_count 1
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
