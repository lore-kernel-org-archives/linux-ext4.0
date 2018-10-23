Return-Path: <SRS0=2u2A=ND=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48830 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728231AbeJWWwA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 23 Oct 2018 18:52:00 -0400
Date: Tue, 23 Oct 2018 10:28:04 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: syzbot <syzbot+a50c7541a4a55cd49b02@syzkaller.appspotmail.com>
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        linux-fsdevel@vger.kernel.org, tj@kernel.org,
        jiangshanlai@gmail.com
Subject: Re: possible deadlock in flush_workqueue (2)
Message-ID: <20181023142804.GC6850@thunk.org>
References: <000000000000bfd4270578abe88b@google.com>
 <0000000000009bcd4a0578e22ebd@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000009bcd4a0578e22ebd@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 23, 2018 at 02:42:03AM -0700, syzbot wrote:
> syzbot has found a reproducer for the following crash on:
> 
> HEAD commit:    ca9eb48fe01f Merge tag 'regulator-v5.0' of git://git.kerne..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=11a60939400000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=963b24abf3f7c2d8
> dashboard link: https://syzkaller.appspot.com/bug?extid=a50c7541a4a55cd49b02
> compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12097f03400000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10b55ac5400000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+a50c7541a4a55cd49b02@syzkaller.appspotmail.com

This is a false positive in lockdep, but it's not clear to me what's
the best way to fix it.  It's not ext4-specific, so I've added
linux-fsdevel, Tejun, and Lai to the cc.

The problem is that when we first start doing direct I/O in a
particular file system, we use a lockless technique to allocate the
dio workqueue.  From fs/direct-io.c:

int sb_init_dio_done_wq(struct super_block *sb)
{
	struct workqueue_struct *old;
	struct workqueue_struct *wq = alloc_workqueue("dio/%s",
						      WQ_MEM_RECLAIM, 0,
						      sb->s_id);
	if (!wq)
		return -ENOMEM;
	/*
	 * This has to be atomic as more DIOs can race to create the workqueue
	 */
	old = cmpxchg(&sb->s_dio_done_wq, NULL, wq);
	/* Someone created workqueue before us? Free ours... */
	if (old)
		destroy_workqueue(wq);
	return 0;
}

If we have multiple DIO writers racing to initialize
sb->s_dio_done_wq, the losers of the race will destroy the fresly
created workqueue.  Because it's freshly created, there's nothing to
drain --- but lockdep doesn't know that.

One way I suppose we could solve this is to call sb_init_dio_done_wq
on open if the O_DIRECT flag is set.  But now if we have multiple
threads racing to open files with O_DIRECT we'll still hit this
particular race.

The other, and I think better way, we could fix this is to have an
alternate destroy_never_used_workqueue() function which skips the
drain_workqueue().

What do people think?

The annotated lockdep is attached below.

						- Ted

[  263.210408] EXT4-fs (vdc): mounted filesystem without journal. Opts: acl,user_xattr,d
[  263.227896]
[  263.229118] ======================================================
[  263.231370] WARNING: possible circular locking dependency detected
[  263.232950] 4.19.0-rc6-xfstests-00021-g33458eaba4df #706 Not tainted
[  263.234762] ------------------------------------------------------
[  263.236915] kworker/1:3/1371 is trying to acquire lock:
[  263.238630] 00000000f97c1367 (&sb->s_type->i_mutex_key#11){+.+.}, at: __generic_file0
[  263.241115]
[  263.241115] but task is already holding lock:
[  263.243121] 000000008f473d52 ((work_completion)(&dio->complete_work)){+.+.}, at: pro0
[  263.246910]
[  263.246910] which lock already depends on the new lock.
[  263.246910]
[  263.249597]
[  263.249597] the existing dependency chain (in reverse order) is:
[  263.252024]
[  263.252024] -> #2 ((work_completion)(&dio->complete_work)){+.+.}:
[  263.254384] process_one_work (/arch/x86/include/asm/jump_label.h:36 /include/linux/jump_label.h:142 /include/trace/events/workqueue.h:89 /kernel/workqueue.c:2152) 
[  263.255835] worker_thread (/include/linux/compiler.h:188 /include/linux/list.h:203 /kernel/workqueue.c:2297) 
[  263.257180] kthread (/kernel/kthread.c:246) 
[  263.258310] ret_from_fork (/arch/x86/entry/entry_64.S:419) 
[  263.259449]
[  263.259449] -> #1 ((wq_completion)"dio/%s"sb->s_id){+.+.}:
[  263.260991] flush_workqueue (/kernel/workqueue.c:2655) 
[  263.262024] drain_workqueue (/kernel/workqueue.c:2822) 
[  263.263076] destroy_workqueue (/kernel/workqueue.c:4158) 
[  263.264177] sb_init_dio_done_wq (/fs/direct-io.c:636) 
[  263.265131] __blockdev_direct_IO (/fs/direct-io.c:1283 /fs/direct-io.c:1417) 
[  263.266248] ext4_direct_IO (/fs/ext4/inode.c:3778 /fs/ext4/inode.c:3901) 
[  263.267184] generic_file_direct_write (/mm/filemap.c:3057) 
[  263.268164] __generic_file_write_iter (/mm/filemap.c:3229) 
[  263.269173] ext4_file_write_iter (/include/linux/fs.h:743 /fs/ext4/file.c:267) 
[  263.270052] aio_write (/fs/aio.c:1473 /fs/aio.c:1561) 
[  263.270821] io_submit_one (/fs/aio.c:1836) 
[  263.272136] __se_sys_io_submit (/fs/aio.c:1916 /fs/aio.c:1887) 
[  263.273565] do_syscall_64 (/arch/x86/entry/common.c:290) 
[  263.274831] entry_SYSCALL_64_after_hwframe (/arch/x86/entry/entry_64.S:240) 
[  263.276514]
[  263.276514] -> #0 (&sb->s_type->i_mutex_key#11){+.+.}:
[  263.278492] lock_acquire (/arch/x86/include/asm/paravirt.h:788 /kernel/locking/lockdep.c:3903) 
[  263.279690] down_write (/arch/x86/include/asm/rwsem.h:160 /kernel/locking/rwsem.c:72) 
[  263.280812] __generic_file_fsync (/fs/libfs.c:982) 
[  263.282156] ext4_sync_file (/fs/ext4/fsync.c:121) 
[  263.283400] dio_complete (/include/linux/fs.h:2733 /fs/direct-io.c:329) 
[  263.284629] process_one_work (/arch/x86/include/asm/jump_label.h:36 /include/linux/jump_label.h:142 /include/trace/events/workqueue.h:114 /kernel/workqueue.c:2158) 
[  263.285916] worker_thread (/include/linux/compiler.h:188 /include/linux/list.h:203 /kernel/workqueue.c:2297) 
[  263.287114] kthread (/kernel/kthread.c:246) 
[  263.288198] ret_from_fork (/arch/x86/entry/entry_64.S:419) 
[  263.289394]
[  263.289394] other info that might help us debug this:
[  263.289394]
[  263.291805] Chain exists of:
[  263.291805]   &sb->s_type->i_mutex_key#11 --> (wq_completion)"dio/%s"sb->s_id --> (w)
[  263.291805]
[  263.294392]  Possible unsafe locking scenario:
[  263.294392]
[  263.295398]        CPU0                    CPU1
[  263.296171]        ----                    ----
[  263.296949]   lock((work_completion)(&dio->complete_work));
[  263.298481]                                lock((wq_completion)"dio/%s"sb->s_id);
[  263.300579]                                lock((work_completion)(&dio->complete_wor;
[  263.302856]   lock(&sb->s_type->i_mutex_key#11);
[  263.304175]
[  263.304175]  *** DEADLOCK ***
[  263.304175]
[  263.305861] 2 locks held by kworker/1:3/1371:
[  263.307097]  #0: 000000004a793a56 ((wq_completion)"dio/%s"sb->s_id){+.+.}, at: proce0
[  263.309761]  #1: 000000008f473d52 ((work_completion)(&dio->complete_work)){+.+.}, at0
[  263.312663]
[  263.312663] stack backtrace:
[  263.313881] CPU: 1 PID: 1371 Comm: kworker/1:3 Not tainted 4.19.0-rc6-xfstests-000216
[  263.316541] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.11.1-1 04/4
[  263.318894] Workqueue: dio/vdc dio_aio_complete_work
[  263.320303] Call Trace:
[  263.321038] dump_stack (/lib/dump_stack.c:115) 
[  263.322010] print_circular_bug.isra.19.cold.39 (/kernel/locking/lockdep.c:1221) 
[  263.323581] check_prev_add.constprop.27 (/kernel/locking/lockdep.c:1861) 
[  263.324991] __lock_acquire (/kernel/locking/lockdep.c:1975 /kernel/locking/lockdep.c:2415 /kernel/locking/lockdep.c:3411) 
[  263.326054] lock_acquire (/arch/x86/include/asm/paravirt.h:788 /kernel/locking/lockdep.c:3903) 
[  263.327086] ? __generic_file_fsync (/fs/libfs.c:982) 
[  263.328349] down_write (/arch/x86/include/asm/rwsem.h:160 /kernel/locking/rwsem.c:72) 
[  263.329300] ? __generic_file_fsync (/fs/libfs.c:982) 
[  263.330504] __generic_file_fsync (/fs/libfs.c:982) 
[  263.331663] ext4_sync_file (/fs/ext4/fsync.c:121) 
[  263.332722] dio_complete (/include/linux/fs.h:2733 /fs/direct-io.c:329) 
[  263.333772] process_one_work (/arch/x86/include/asm/jump_label.h:36 /include/linux/jump_label.h:142 /include/trace/events/workqueue.h:114 /kernel/workqueue.c:2158) 
[  263.334719] worker_thread (/include/linux/compiler.h:188 /include/linux/list.h:203 /kernel/workqueue.c:2297) 
[  263.335482] ? process_one_work (/kernel/workqueue.c:2239) 
[  263.336241] kthread (/kernel/kthread.c:246) 
[  263.336826] ? kthread_park (/kernel/kthread.c:206) 
[  263.337548] ret_from_fork (/arch/x86/entry/entry_64.S:419) 
