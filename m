From: Nikolay Borisov <kernel@kyup.com>
Subject: Re: ext4 corruption causing a crash
Date: Wed, 16 Nov 2016 10:12:21 +0200
Message-ID: <d2aea076-15c1-2131-faca-0fb977f3d082@kyup.com>
References: <f4fcebfd-292e-5238-b592-65fa605f1445@kyup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>, bigeasy@linutronix.de
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:38474 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752352AbcKPIM0 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Nov 2016 03:12:26 -0500
Received: by mail-wm0-f46.google.com with SMTP id f82so55313337wmf.1
        for <linux-ext4@vger.kernel.org>; Wed, 16 Nov 2016 00:12:25 -0800 (PST)
In-Reply-To: <f4fcebfd-292e-5238-b592-65fa605f1445@kyup.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On 11/16/2016 09:57 AM, Nikolay Borisov wrote:
> Hello, 
> 
> Recently I saw the following report : http://www.securityfocus.com/archive/1/539661
> 
> I've been testing that image and even on latest 4.9-rc4 I'm able to reproduce a crash. 
> This seems rather indetermenistic in that it causes double/triple faults which causes 
> my qemu guest to completely hang or reboot. However, on 4.9-rc4 with errors=panic 
> mount options the crash looks like : 
> 
> [   47.172026] BUG: unable to handle kernel NULL pointer dereference at 000000000000090f
> [   47.172215] IP: [<ffffffff81090e3f>] update_curr+0x2f/0x210
> [   47.172342] PGD 0 [   47.172389] 
> [   47.172438] Oops: 0000 [#1] SMP
> [   47.172521] Modules linked in:
> [   47.172627] CPU: 0 PID: 1108 Comm: mount Tainted: G        W       4.9.0-rc4-clouder1 #30
> [   47.172777] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.8.1-0-g4adadbd-20150316_085822-nilsson.home.kraxel.org 04/01/2014
> [   47.173008] task: ffff8800068ec100 task.stack: ffff880006648000
> [   47.173008] RIP: 0010:[<ffffffff81090e3f>]  [<ffffffff81090e3f>] update_curr+0x2f/0x210
> [   47.173008] RSP: 0018:ffff880007c03d68  EFLAGS: 00010082
> [   47.173008] RAX: ffffffffffffffff RBX: ffff880006630000 RCX: 0000000afbabb8be
> [   47.173008] RDX: 0000000000000000 RSI: ffff8800068ec100 RDI: ffff880006630000
> [   47.173008] RBP: ffff880007c03da8 R08: 0000000000000022 R09: 0000000000000026
> [   47.173008] R10: 00000000005acec3 R11: 0000000000000000 R12: 0000000000016300
> [   47.173008] R13: ffffffffffffffff R14: ffff880006630000 R15: 0000000000000000
> [   47.173008] FS:  00007f08d69e97e0(0000) GS:ffff880007c00000(0000) knlGS:0000000000000000
> [   47.173008] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   47.173008] CR2: 000000000000090f CR3: 000000000665e000 CR4: 00000000000006f0
> [   47.173008] Stack:
> [   47.173008]  fffffffffffffed4 ffffffff820368e0 fffffffffffffed4 ffff8800068ec180
> [   47.173008]  0000000000016300 0000000000000000 ffff880006630000 0000000000000000
> [   47.173008]  ffff880007c03e18 ffffffff81097c84 ffff880007c03df8 ffff880007c16dc0
> [   47.173008] Call Trace:
> [   47.173008]  <IRQ> [   47.173008]  [<ffffffff81097c84>] task_tick_fair+0x2a4/0x3f0
> [   47.173008]  [<ffffffff81084fa8>] scheduler_tick+0x68/0xe0
> [   47.173008]  [<ffffffff810c1c81>] update_process_times+0x51/0x70
> [   47.173008]  [<ffffffff810d2bf8>] tick_sched_timer+0x58/0x180
> [   47.173008]  [<ffffffff810c3678>] ? __remove_hrtimer+0x58/0x90
> [   47.173008]  [<ffffffff810c3f07>] __hrtimer_run_queues+0xd7/0x290
> [   47.173008]  [<ffffffff810d2ba0>] ? tick_setup_sched_timer+0x100/0x100
> [   47.173008]  [<ffffffff8103b14d>] ? lapic_next_event+0x1d/0x30
> [   47.173008]  [<ffffffff810ca54b>] ? ktime_get_update_offsets_now+0x5b/0x120
> [   47.173008]  [<ffffffff8106100f>] ? __local_bh_enable+0x3f/0x70
> [   47.173008]  [<ffffffff810c4252>] hrtimer_interrupt+0xa2/0x1e0
> [   47.173008]  [<ffffffff8103b8d9>] local_apic_timer_interrupt+0x39/0x60
> [   47.173008]  [<ffffffff816ac3a1>] smp_apic_timer_interrupt+0x41/0x55
> [   47.173008]  [<ffffffff816ab699>] apic_timer_interrupt+0x89/0x90
> [   47.173008]  <EOI> [   47.173008]  [<ffffffff8127d834>] ? ext4_calculate_overhead+0x264/0x470
> [   47.173008]  [<ffffffff8127d81e>] ? ext4_calculate_overhead+0x24e/0x470
> [   47.173008]  [<ffffffff8128b979>] ext4_fill_super+0x2019/0x3270
> [   47.173008]  [<ffffffff81344483>] ? pointer+0x2a3/0x400
> [   47.173008]  [<ffffffff811d0477>] mount_bdev+0x187/0x1d0
> [   47.173008]  [<ffffffff81170a65>] ? __alloc_percpu+0x15/0x20
> [   47.173008]  [<ffffffff81289960>] ? ext4_alloc_flex_bg_array+0x110/0x110
> [   47.173008]  [<ffffffff8127aec5>] ext4_mount+0x15/0x20
> [   47.173008]  [<ffffffff811cf3d3>] mount_fs+0x43/0x170
> [   47.173008]  [<ffffffff811ef6d6>] vfs_kern_mount+0x76/0x130
> [   47.173008]  [<ffffffff811f05f6>] do_mount+0x226/0xcb0
> [   47.173008]  [<ffffffff8116a707>] ? memdup_user+0x57/0x90
> [   47.173008]  [<ffffffff811f10fa>] SyS_mount+0x7a/0xc0
> [   47.173008]  [<ffffffff816a9dea>] entry_SYSCALL_64_fastpath+0x18/0xa8
> 
> Without it I usually get a DF in the PF handler (ouch). However, Sebastian 
> reported that on his 4.9-rc4 it doesn't crash: 
> http://paste.debian.net/hidden/6fae7231/
> 
> PeterZ, ffffffff81090e3f is 
> kernel/sched/fair.c:2727 - val >>= local_n / LOAD_AVG_PERIOD; in decay_load
> kernel/sched/fair.c:2850
> kernel/sched/fair.c:3053

This is the result with KASAN enabled, without the IP is a bit different
it shows:

/home/projects/linux-stable/kernel/sched/fair.c:281
/home/projects/linux-stable/kernel/sched/fair.c:3070
/home/projects/linux-stable/kernel/sched/fair.c:3678
/home/projects/linux-stable/kernel/sched/fair.c:8599

line 281 being cfs_rq_of, meaning sched_entity pointer is corrupted.

> 
> the 2727 line code seems very suspicious in that it doesn't work with 
> any global memory hmmm...
> 
> On older 4.4.x based kernel the symptoms range from DF/TF to memory 
> corruption in the scheduler, to a crash on the last return statement in 
> count_overhead. It's still puzzling how come ext4 can cause such a far reaching
> memory corruption that scheduler data structures are affected. 
> 
> Nikolay
> 
> 
> 
> 
> 
