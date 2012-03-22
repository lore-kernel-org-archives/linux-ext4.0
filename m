From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v1 0/9] do not use s_dirt in ext4
Date: Thu, 22 Mar 2012 09:35:21 -0400
Message-ID: <20120322133521.GA25897@thunk.org>
References: <1332254489-2300-1-git-send-email-dedekind1@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49911 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752294Ab2CVNfY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 Mar 2012 09:35:24 -0400
Content-Disposition: inline
In-Reply-To: <1332254489-2300-1-git-send-email-dedekind1@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Artem,

Just as a quick FYI, I tried applying your patch series on top of my
development tree, and ran into problems when I ran the regression test
(using xfstests).  When I backed out your changes and reran, the tests
completed without any problems.

I'm rerunning the tests since the first failure looks like it might
not be related to your patch series (and yet it went away once I
backed out your patch).  The second failure however looks definitely
related to your changes.  It looks like you don't wait to make sure
the workqueue is flushed out before the file system gets unmounted,
and that can lead to a panic.

Since we're already in the 3.3 has already been released, I suspect
this patch series will probably need to wait until the next merge
window.  We might be able to pull in some of the obviously safe
patches, however.

Regards,

						- Ted


BEGIN TEST: Ext4 4k block Wed Mar 21 22:47:17 EDT 2012
Device: /dev/vdb
mke2fs options: -q
mount options: -o block_validity
000 - unknown test, ignored
FSTYP         -- ext4
PLATFORM      -- Linux/i686 candygram 3.3.0-rc2-00592-gc56a0b2
MKFS_OPTIONS  -- -q /dev/vdc
MOUNT_OPTIONS -- -o acl,user_xattr -o block_validity /dev/vdc /vdc
...

075	[  808.872903] 
[  808.873567] ======================================================
[  808.875933] [ INFO: possible circular locking dependency detected ]
[  808.875933] 3.3.0-rc2-00592-gc56a0b2 #32 Not tainted
[  808.875933] -------------------------------------------------------
[  808.875933] fsx/13769 is trying to acquire lock:
[  808.875933]  (&sb->s_type->i_mutex_key#3){+.+.+.}, at: [<c028d900>] ext4_ext_punch_hole+0x2b8/0x382
[  808.875933] 
[  808.875933] but task is already holding lock:
[  808.875933]  (jbd2_handle){+.+...}, at: [<c02a5995>] start_this_handle+0x4e4/0x51a
[  808.875933] 
[  808.875933] which lock already depends on the new lock.
[  808.875933] 
[  808.875933] 
[  808.875933] the existing dependency chain (in reverse order) is:
[  808.875933] 
[  808.875933] -> #1 (jbd2_handle){+.+...}:
[  808.875933]        [<c019789d>] lock_acquire+0x99/0xbd
[  808.875933]        [<c02a59b7>] start_this_handle+0x506/0x51a
[  808.875933]        [<c02a5ba6>] jbd2__journal_start+0xae/0xda
[  808.875933]        [<c02a5be4>] jbd2_journal_start+0x12/0x14
[  808.875933]        [<c0284fb8>] ext4_journal_start_sb+0x11e/0x126
[  808.875933]        [<c0277661>] ext4_unlink+0x82/0x1e5
[  808.875933]        [<c02127e1>] vfs_unlink+0x61/0xaf
[  808.875933]        [<c02147b5>] do_unlinkat+0xa0/0x112
[  808.875933]        [<c0214946>] sys_unlinkat+0x30/0x37
[  808.875933]        [<c06d8c5d>] syscall_call+0x7/0xb
[  808.875933] 
[  808.875933] -> #0 (&sb->s_type->i_mutex_key#3){+.+.+.}:
[  808.875933]        [<c0197598>] __lock_acquire+0x989/0xbf5
[  808.875933]        [<c019789d>] lock_acquire+0x99/0xbd
[  808.875933]        [<c06d65f4>] __mutex_lock_common+0x30/0x316
[  808.875933]        [<c06d6988>] mutex_lock_nested+0x26/0x2f
[  808.875933]        [<c028d900>] ext4_ext_punch_hole+0x2b8/0x382
[  808.875933]        [<c026e316>] ext4_punch_hole+0x5f/0x70
[  808.875933]        [<c028fbce>] ext4_fallocate+0x63/0x469
[  808.875933]        [<c0208974>] do_fallocate+0xe7/0x105
[  808.875933]        [<c02089c3>] sys_fallocate+0x31/0x46
[  808.875933]        [<c06d8c5d>] syscall_call+0x7/0xb
[  808.875933] 
[  808.875933] other info that might help us debug this:
[  808.875933] 
[  808.875933]  Possible unsafe locking scenario:
[  808.875933] 
[  808.875933]        CPU0                    CPU1
[  808.875933]        ----                    ----
[  808.875933]   lock(jbd2_handle);
[  808.875933]                                lock(&sb->s_type->i_mutex_key#3);
[  808.875933]                                lock(jbd2_handle);
[  808.875933]   lock(&sb->s_type->i_mutex_key#3);
[  808.875933] 
[  808.875933]  *** DEADLOCK ***
[  808.875933] 
[  808.875933] 1 lock held by fsx/13769:
[  808.875933]  #0:  (jbd2_handle){+.+...}, at: [<c02a5995>] start_this_handle+0x4e4/0x51a
[  808.875933] 
[  808.875933] stack backtrace:
[  808.875933] Pid: 13769, comm: fsx Not tainted 3.3.0-rc2-00592-gc56a0b2 #32
[  808.875933] Call Trace:
[  808.875933]  [<c01954fb>] print_circular_bug+0x194/0x1a1
[  808.875933]  [<c0197598>] __lock_acquire+0x989/0xbf5
[  808.875933]  [<c019789d>] lock_acquire+0x99/0xbd
[  808.875933]  [<c028d900>] ? ext4_ext_punch_hole+0x2b8/0x382
[  808.875933]  [<c06d65f4>] __mutex_lock_common+0x30/0x316
[  808.875933]  [<c028d900>] ? ext4_ext_punch_hole+0x2b8/0x382
[  808.875933]  [<c017d53a>] ? local_clock+0x3d/0x55
[  808.875933]  [<c01942de>] ? lock_release_holdtime+0x2b/0xcd
[  808.875933]  [<c028d8d9>] ? ext4_ext_punch_hole+0x291/0x382
[  808.875933]  [<c06d6988>] mutex_lock_nested+0x26/0x2f
[  808.875933]  [<c028d900>] ? ext4_ext_punch_hole+0x2b8/0x382
[  808.875933]  [<c028d900>] ext4_ext_punch_hole+0x2b8/0x382
[  808.875933]  [<c026e316>] ext4_punch_hole+0x5f/0x70
[  808.875933]  [<c028fbce>] ext4_fallocate+0x63/0x469
[  808.875933]  [<c017d4ed>] ? sched_clock_cpu+0x134/0x144
[  808.875933]  [<c023473e>] ? fsnotify+0x1e8/0x202
[  808.875933]  [<c01940d5>] ? trace_hardirqs_off+0xb/0xd
[  808.875933]  [<c017d53a>] ? local_clock+0x3d/0x55
[  808.875933]  [<c020a873>] ? fget+0x57/0x71
[  808.875933]  [<c0208974>] do_fallocate+0xe7/0x105
[  808.875933]  [<c02089c3>] sys_fallocate+0x31/0x46
[  808.875933]  [<c06d8c5d>] syscall_call+0x7/0xb
[  808.875933]  [<c06d0000>] ? init_intel+0x1aa/0x370

I also saw the following in nojournal mode:

BEGIN TEST: Ext4 4k block w/ no journal Wed Mar 21 23:26:48 EDT 2012
Device: /dev/vdb
mke2fs options: -q -O ^has_journal
mount options: -o block_validity,noload
000 - unknown test, ignored
[ 2409.975802] EXT4-fs (vdb): mounted filesystem with ordered data mode. Opts: (null)
FSTYP         -- ext4
PLATFORM      -- Linux/i686 candygram 3.3.0-rc2-00592-gc56a0b2
MKFS_OPTIONS  -- -q -O ^has_journal /dev/vdc
MOUNT_OPTIONS -- -o acl,user_xattr -o block_validity,noload /dev/vdc /vdc

[ 2410.270742] EXT4-fs (vdc): mounted filesystem without journal. Opts: acl,user_xattr,block_validity,noload
[ 2443.856170] EXT4-fs (vdb): mounted filesystem without journal. Opts: acl,user_xattr,block_validity,noload
001 6s ... 6s
[ 2454.241371] BUG: unable to handle kernel paging request at 0063e408
[ 2454.244611] IP: [<c016bdd4>] __queue_work+0x1f8/0x2a8
[ 2454.244611] *pdpt = 0000000001247001 *pde = 0000000000000000 
[ 2454.244611] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[ 2454.244611] Modules linked in:
[ 2454.244611] 
[ 2454.244611] Pid: 0, comm: swapper/0 Not tainted 3.3.0-rc2-00592-gc56a0b2 #32 Bochs Bochs
[ 2454.244611] EIP: 0060:[<c016bdd4>] EFLAGS: 00010046 CPU: 0
[ 2454.244611] EIP is at __queue_work+0x1f8/0x2a8
[ 2454.244611] EAX: ef022404 EBX: 0063e400 ECX: ef022400 EDX: c016bd5a
[ 2454.244611] ESI: f6c02a40 EDI: ca524d00 EBP: f680df68 ESP: f680df44
[ 2454.244611]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[ 2454.244611] Process swapper/0 (pid: 0, ti=f680c000 task=c09cd020 task.ti=c09c6000)
[ 2454.244611] Stack:
[ 2454.244611]  00000000 c01630bb 00000000 00000000 ef022400 00000246 ccc37e00 ef022474
[ 2454.244611]  f680dfbc f680df74 c016beaa ef022428 f680dfd0 c016312f f680dfbc f680dfa4
[ 2454.244611]  ef022400 c0c84774 c0c84574 c0c84374 c0c84174 c016be84 00000100 c0c83940
[ 2454.244611] Call Trace:
[ 2454.244611]  [<c01630bb>] ? run_timer_softirq+0x11b/0x24a
[ 2454.244611]  [<c016beaa>] delayed_work_timer_fn+0x26/0x29
[ 2454.244611]  [<c016312f>] run_timer_softirq+0x18f/0x24a
[ 2454.244611]  [<c016be84>] ? __queue_work+0x2a8/0x2a8
[ 2454.244611]  [<c015cbb3>] __do_softirq+0xb1/0x17a
[ 2454.244611]  [<c015cb02>] ? irq_enter+0x5e/0x5e
[ 2454.244611]  <IRQ> 
[ 2454.244611]  [<c015c969>] ? irq_exit+0x43/0xa3
[ 2454.244611]  [<c0146f4f>] ? smp_apic_timer_interrupt+0x71/0x7f
[ 2454.244611]  [<c06d9107>] ? apic_timer_interrupt+0x2f/0x34
[ 2454.244611]  [<c013783e>] ? default_idle+0x5c/0xa5
[ 2454.244611]  [<c01b007b>] ? audit_log_exit+0x5d4/0xbff
[ 2454.244611]  [<c014d1f3>] ? native_safe_halt+0x5/0x7
[ 2454.244611]  [<c0137843>] ? default_idle+0x61/0xa5
[ 2454.244611]  [<c0130eba>] ? cpu_idle+0x61/0x83
[ 2454.244611]  [<c06bcdaa>] ? rest_init+0x92/0x97
[ 2454.244611]  [<c0a467c5>] ? start_kernel+0x303/0x308
[ 2454.244611]  [<c0a460a0>] ? i386_start_kernel+0xa0/0xa7
[ 2454.244611] Code: ff 74 16 8b 47 04 89 d9 ff 75 ec 8b 55 e8 ff 17 83 c7 08 83 3f 00 58 eb e8 8b 45 ec 8b 4d ec 83 c0 04 39 
41 04 74 04 0f 0b eb fe <8b> 43 08 ff 44 83 10 8b 4b 08 8b 43 4c c1 e1 04 3b 43 50 7d 75 
[ 2454.244611] EIP: [<c016bdd4>] __queue_work+0x1f8/0x2a8 SS:ESP 0068:f680df44
[ 2454.244611] CR2: 000000000063e408
[ 2454.244611] ---[ end trace 59443e013535cdda ]---
[ 2454.244611] Kernel panic - not syncing: Fatal exception in interrupt
[ 2455.000233] BUG: spinlock lockup on CPU#0, swapper/0/0
[ 2455.000233]  lock: f6c02a40, .magic: dead4ead, .owner: swapper/0/0, .owner_cpu: 0
[ 2455.000233] Pid: 0, comm: swapper/0 Tainted: G      D      3.3.0-rc2-00592-gc56a0b2 #32
[ 2455.000233] Call Trace:
[ 2455.000233]  [<c038eb17>] spin_dump+0x70/0x7a
[ 2455.000233]  [<c038ec89>] do_raw_spin_lock+0xd5/0xf3
[ 2455.000233]  [<c016bd5a>] ? __queue_work+0x17e/0x2a8
[ 2455.000233]  [<c06d8520>] _raw_spin_lock_irqsave+0x56/0x6a
[ 2455.000233]  [<c016bd5a>] __queue_work+0x17e/0x2a8
[ 2455.000233]  [<c01940d5>] ? trace_hardirqs_off+0xb/0xd
[ 2455.000233]  [<c016bec9>] queue_work_on+0x1c/0x24
[ 2455.000233]  [<c016bfe2>] queue_work+0x1a/0x1d
[ 2455.000233]  [<c036d2e5>] kblockd_schedule_work+0x12/0x14
[ 2455.000233]  [<c037e175>] cfq_schedule_dispatch+0x35/0x3a
[ 2455.000233]  [<c037f300>] cfq_completed_request+0x44f/0x46c
[ 2455.000233]  [<c036d556>] ? blk_add_request_payload+0x52/0x52
[ 2455.000233]  [<c0369ab2>] elv_completed_request+0x46/0x49
[ 2455.000233]  [<c036dc26>] __blk_put_request+0x25/0x91
[ 2455.000233]  [<c036de51>] blk_finish_request+0x1bf/0x1c7
[ 2455.000233]  [<c036e9b8>] __blk_end_bidi_request+0x28/0x31
[ 2455.000233]  [<c036e9e2>] __blk_end_request_all+0x21/0x2f
[ 2455.000233]  [<c0476c58>] blk_done+0x80/0xd4
[ 2455.000233]  [<c03f0aed>] vring_interrupt+0x6a/0x76
[ 2455.000233]  [<c01b360b>] handle_irq_event_percpu+0x4e/0x167
[ 2455.000233]  [<c01b3755>] handle_irq_event+0x31/0x48
[ 2455.000233]  [<c01b5590>] ? handle_percpu_irq+0x40/0x40
[ 2455.000233]  [<c01b561f>] handle_edge_irq+0x8f/0xb1
[ 2455.000233]  <IRQ>  [<c0132530>] ? do_IRQ+0x3c/0x95
[ 2455.000233]  [<c06de82e>] ? common_interrupt+0x2e/0x34
[ 2455.000233]  [<c06d8b2a>] ? _raw_spin_unlock_irq+0x27/0x30
[ 2455.000233]  [<c06d8b2c>] ? _raw_spin_unlock_irq+0x29/0x30
[ 2455.000233]  [<c06d76bb>] ? __schedule+0x53f/0x56f
[ 2455.000233]  [<c0157eaa>] ? console_unlock+0x188/0x1de
[ 2455.000233]  [<c01a1dec>] ? crash_kexec+0x1a/0xac
[ 2455.000233]  [<c0195541>] ? print_lock_contention_bug+0x11/0xc1
[ 2455.000233]  [<c06d777d>] ? _cond_resched+0x30/0x49
[ 2455.000233]  [<c02053cb>] ? slab_pre_alloc_hook+0x1d/0x22
[ 2455.000233]  [<c0206a70>] ? kmem_cache_alloc_trace+0x25/0xb6
[ 2455.000233]  [<c0133a7f>] ? register_nmi_handler+0x3f/0xf4
[ 2455.000233]  [<c01497e7>] ? default_get_apic_id+0x17/0x37
[ 2455.000233]  [<c0145c2b>] ? native_nmi_stop_other_cpus+0xdc/0xdc
[ 2455.000233]  [<c0133a7f>] ? register_nmi_handler+0x3f/0xf4
[ 2455.000233]  [<c0145ba7>] ? native_nmi_stop_other_cpus+0x58/0xdc
[ 2455.000233]  [<c06d60ce>] ? panic+0x8d/0x175
[ 2455.000233]  [<c06d99db>] ? oops_end+0x97/0xa6
[ 2455.000233]  [<c014e2e7>] ? no_context+0x18b/0x195
[ 2455.000233]  [<c014e3ef>] ? __bad_area_nosemaphore+0xfe/0x108
[ 2455.000233]  [<c06db4fe>] ? spurious_fault+0x104/0x104
[ 2455.000233]  [<c014e40b>] ? bad_area_nosemaphore+0x12/0x15
[ 2455.000233]  [<c06db6b8>] ? do_page_fault+0x1ba/0x36a
[ 2455.000233]  [<c06db4fe>] ? spurious_fault+0x104/0x104
[ 2455.000233]  [<c06d9317>] ? error_code+0x5f/0x64
[ 2455.000233]  [<c016bd5a>] ? __queue_work+0x17e/0x2a8
[ 2455.000233]  [<c06d00d8>] ? init_intel+0x282/0x370
[ 2455.000233]  [<c06db4fe>] ? spurious_fault+0x104/0x104
[ 2455.000233]  [<c016bdd4>] ? __queue_work+0x1f8/0x2a8
[ 2455.000233]  [<c01630bb>] ? run_timer_softirq+0x11b/0x24a
[ 2455.000233]  [<c016beaa>] ? delayed_work_timer_fn+0x26/0x29
[ 2455.000233]  [<c016312f>] ? run_timer_softirq+0x18f/0x24a
[ 2455.000233]  [<c016be84>] ? __queue_work+0x2a8/0x2a8
[ 2455.000233]  [<c015cbb3>] ? __do_softirq+0xb1/0x17a
[ 2455.000233]  [<c015cb02>] ? irq_enter+0x5e/0x5e
[ 2455.000233]  <IRQ>  [<c015c969>] ? irq_exit+0x43/0xa3
[ 2455.000233]  [<c0146f4f>] ? smp_apic_timer_interrupt+0x71/0x7f
[ 2455.000233]  [<c06d9107>] ? apic_timer_interrupt+0x2f/0x34
[ 2455.000233]  [<c013783e>] ? default_idle+0x5c/0xa5
[ 2455.000233]  [<c01b007b>] ? audit_log_exit+0x5d4/0xbff
[ 2455.000233]  [<c014d1f3>] ? native_safe_halt+0x5/0x7
[ 2455.000233]  [<c0137843>] ? default_idle+0x61/0xa5
[ 2455.000233]  [<c0130eba>] ? cpu_idle+0x61/0x83
[ 2455.000233]  [<c06bcdaa>] ? rest_init+0x92/0x97
[ 2455.000233]  [<c0a467c5>] ? start_kernel+0x303/0x308
[ 2455.000233]  [<c0a460a0>] ? i386_start_kernel+0xa0/0xa7

On Tue, Mar 20, 2012 at 04:41:20PM +0200, Artem Bityutskiy wrote:
> This patch-set makes ext4 independent of the VFS superblock management
> services. Namely, ext4 does not require to register the 'write_super()' VFS
> call-back.
> 
> The reason of this exercises is to get rid of the 'sync_supers()' kernel thread
> which wakes up every 5 seconds (by default) even if all superblocks are clean.
> This is wasteful from power management POW (unnecessary wake-ups).
> 
> Note, I tried to optimize 'sync_supers()' instead in 2010, but Al wanted me
> to get rid of it instead. See https://lkml.org/lkml/2010/6/6/87
> And I think this is right because many file-systems do not need this, for
> example btrfs does not use VFS superblock management services at all, so on a
> btrfs-based system we currently end-up useless periodic wake-ups source.
> 
> Changes for other file-systems are coming later.
> 
> The patch-set structure.
> 1. patches 1,2,3 are independent ext4 cleanups and I ask Ted to merge them as
>    soon/long as they are OK. I sent them also independently in order to get
>    early comments, but did not get so far, so re-sending.
> 2. patch 4 exports 'dirty_writeback_interval' and it would be very useful to
>    have it merged ASAP to simplify further work
> 3. patch 5 is also and independent VFS clean-up
> 4. patches 6-9 actually make ext4 independent on the 'sync_supers()' thread.
> 
> Thanks,
> Artem.
