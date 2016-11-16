From: Nikolay Borisov <kernel@kyup.com>
Subject: Re: ext4 corruption causing a crash
Date: Wed, 16 Nov 2016 15:03:35 +0200
Message-ID: <6afc40e8-50fd-0019-a172-03e52028ba25@kyup.com>
References: <f4fcebfd-292e-5238-b592-65fa605f1445@kyup.com>
 <d2aea076-15c1-2131-faca-0fb977f3d082@kyup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>, bp@alien8.de
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:35523 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751277AbcKPNDj (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Nov 2016 08:03:39 -0500
Received: by mail-wm0-f49.google.com with SMTP id a197so238085986wmd.0
        for <linux-ext4@vger.kernel.org>; Wed, 16 Nov 2016 05:03:38 -0800 (PST)
In-Reply-To: <d2aea076-15c1-2131-faca-0fb977f3d082@kyup.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On 11/16/2016 10:12 AM, Nikolay Borisov wrote:
> 
> 
> On 11/16/2016 09:57 AM, Nikolay Borisov wrote:
>> Hello, 
>>
>> Recently I saw the following report : http://www.securityfocus.com/archive/1/539661
>>
>> I've been testing that image and even on latest 4.9-rc4 I'm able to reproduce a crash. 
>> This seems rather indetermenistic in that it causes double/triple faults which causes 
>> my qemu guest to completely hang or reboot. However, on 4.9-rc4 with errors=panic 
>> mount options the crash looks like : 
>>
>> [   47.172026] BUG: unable to handle kernel NULL pointer dereference at 000000000000090f
>> [   47.172215] IP: [<ffffffff81090e3f>] update_curr+0x2f/0x210
>> [   47.172342] PGD 0 [   47.172389] 
>> [   47.172438] Oops: 0000 [#1] SMP
>> [   47.172521] Modules linked in:
>> [   47.172627] CPU: 0 PID: 1108 Comm: mount Tainted: G        W       4.9.0-rc4-clouder1 #30
>> [   47.172777] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.8.1-0-g4adadbd-20150316_085822-nilsson.home.kraxel.org 04/01/2014
>> [   47.173008] task: ffff8800068ec100 task.stack: ffff880006648000
>> [   47.173008] RIP: 0010:[<ffffffff81090e3f>]  [<ffffffff81090e3f>] update_curr+0x2f/0x210
>> [   47.173008] RSP: 0018:ffff880007c03d68  EFLAGS: 00010082
>> [   47.173008] RAX: ffffffffffffffff RBX: ffff880006630000 RCX: 0000000afbabb8be
>> [   47.173008] RDX: 0000000000000000 RSI: ffff8800068ec100 RDI: ffff880006630000
>> [   47.173008] RBP: ffff880007c03da8 R08: 0000000000000022 R09: 0000000000000026
>> [   47.173008] R10: 00000000005acec3 R11: 0000000000000000 R12: 0000000000016300
>> [   47.173008] R13: ffffffffffffffff R14: ffff880006630000 R15: 0000000000000000
>> [   47.173008] FS:  00007f08d69e97e0(0000) GS:ffff880007c00000(0000) knlGS:0000000000000000
>> [   47.173008] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [   47.173008] CR2: 000000000000090f CR3: 000000000665e000 CR4: 00000000000006f0
>> [   47.173008] Stack:
>> [   47.173008]  fffffffffffffed4 ffffffff820368e0 fffffffffffffed4 ffff8800068ec180
>> [   47.173008]  0000000000016300 0000000000000000 ffff880006630000 0000000000000000
>> [   47.173008]  ffff880007c03e18 ffffffff81097c84 ffff880007c03df8 ffff880007c16dc0
>> [   47.173008] Call Trace:
>> [   47.173008]  <IRQ> [   47.173008]  [<ffffffff81097c84>] task_tick_fair+0x2a4/0x3f0
>> [   47.173008]  [<ffffffff81084fa8>] scheduler_tick+0x68/0xe0
>> [   47.173008]  [<ffffffff810c1c81>] update_process_times+0x51/0x70
>> [   47.173008]  [<ffffffff810d2bf8>] tick_sched_timer+0x58/0x180
>> [   47.173008]  [<ffffffff810c3678>] ? __remove_hrtimer+0x58/0x90
>> [   47.173008]  [<ffffffff810c3f07>] __hrtimer_run_queues+0xd7/0x290
>> [   47.173008]  [<ffffffff810d2ba0>] ? tick_setup_sched_timer+0x100/0x100
>> [   47.173008]  [<ffffffff8103b14d>] ? lapic_next_event+0x1d/0x30
>> [   47.173008]  [<ffffffff810ca54b>] ? ktime_get_update_offsets_now+0x5b/0x120
>> [   47.173008]  [<ffffffff8106100f>] ? __local_bh_enable+0x3f/0x70
>> [   47.173008]  [<ffffffff810c4252>] hrtimer_interrupt+0xa2/0x1e0
>> [   47.173008]  [<ffffffff8103b8d9>] local_apic_timer_interrupt+0x39/0x60
>> [   47.173008]  [<ffffffff816ac3a1>] smp_apic_timer_interrupt+0x41/0x55
>> [   47.173008]  [<ffffffff816ab699>] apic_timer_interrupt+0x89/0x90
>> [   47.173008]  <EOI> [   47.173008]  [<ffffffff8127d834>] ? ext4_calculate_overhead+0x264/0x470
>> [   47.173008]  [<ffffffff8127d81e>] ? ext4_calculate_overhead+0x24e/0x470
>> [   47.173008]  [<ffffffff8128b979>] ext4_fill_super+0x2019/0x3270
>> [   47.173008]  [<ffffffff81344483>] ? pointer+0x2a3/0x400
>> [   47.173008]  [<ffffffff811d0477>] mount_bdev+0x187/0x1d0
>> [   47.173008]  [<ffffffff81170a65>] ? __alloc_percpu+0x15/0x20
>> [   47.173008]  [<ffffffff81289960>] ? ext4_alloc_flex_bg_array+0x110/0x110
>> [   47.173008]  [<ffffffff8127aec5>] ext4_mount+0x15/0x20
>> [   47.173008]  [<ffffffff811cf3d3>] mount_fs+0x43/0x170
>> [   47.173008]  [<ffffffff811ef6d6>] vfs_kern_mount+0x76/0x130
>> [   47.173008]  [<ffffffff811f05f6>] do_mount+0x226/0xcb0
>> [   47.173008]  [<ffffffff8116a707>] ? memdup_user+0x57/0x90
>> [   47.173008]  [<ffffffff811f10fa>] SyS_mount+0x7a/0xc0
>> [   47.173008]  [<ffffffff816a9dea>] entry_SYSCALL_64_fastpath+0x18/0xa8
>>


Ok so with the help of bpetkov we managed to get to the bottom it, 
essentially what happens is that we overflow the page allocated in 
ext4_calculate_overhead while working in the following loop in count_overhead: 

for (j = ext4_bg_num_gdb(sb, grp); j > 0; j--) {
	ext4_set_bit(EXT4_B2C(sbi, s++), buf);
	count++;
}

so ext4_bg_num_gdb returns a big number - 32768 and since sbi->s_cluster_bits 
is 0 the result of EXT4_B2C(sbi, s++) becomes just s, which incremented on 
every iteration and eventually becomes a large number. This causes to overflow 
the page used as a buf. This can be seen easily from the crash produced when 
debug_pagealloc is enabled: 

[   18.607773] BUG: unable to handle kernel paging request at ffff880005bcb000
[   18.607948] IP: [<ffffffff8127caad>] ext4_calculate_overhead+0x51d/0x540
[   18.608097] PGD 206f067 
[   18.608097] PUD 2070067 
[   18.608097] PMD 7dd3067 
[   18.608097] PTE 8000000005bcb060
[   18.608097] 
[   18.608097] Oops: 0002 [#1] SMP DEBUG_PAGEALLOC
[   18.608097] Modules linked in:
[   18.608097] CPU: 0 PID: 1164 Comm: mount Tainted: G        W       4.9.0-rc4-clouder1 #40
[   18.608097] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.8.1-0-g4adadbd-20150316_085822-nilsson.home.kraxel.org 04/01/2014
[   18.608097] task: ffff88000632d8c0 task.stack: ffffc900002e4000
[   18.608097] RIP: 0010:[<ffffffff8127caad>]  [<ffffffff8127caad>] ext4_calculate_overhead+0x51d/0x540
[   18.608097] RSP: 0018:ffffc900002e7b68  EFLAGS: 00010296
[   18.608097] RAX: 0000000000000020 RBX: 0000000000008001 RCX: ffffffff81c40e28
[   18.608097] RDX: 0000000000000001 RSI: 0000000000000282 RDI: ffffffff81e35060
[   18.608097] RBP: ffffc900002e7bf8 R08: 0000000000008000 R09: 000000000000048c
[   18.608097] R10: 0000000000000000 R11: 0000000000000002 R12: ffff880005bca000
[   18.608097] R13: ffff880005f95d28 R14: ffff880005f953d8 R15: 0000000000008004
[   18.608097] FS:  00007f90c676e7e0(0000) GS:ffff880007a00000(0000) knlGS:0000000000000000
[   18.608097] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   18.608097] CR2: ffff880005bcb000 CR3: 00000000054ee000 CR4: 00000000000006f0
[   18.608097] Stack:
[   18.608097]  ffffc90000000001 ffffffff00008000 0000000000001fff 0000000000000000
[   18.608097]  3231b20100000000 ffff880005bca001 00000000002e7be8 0000000000000000
[   18.608097]  ffff880005f95d28 00000001812a88fd 0000000000000000 0000000000000001
[   18.608097] Call Trace:
[   18.608097]  [<ffffffff8128aa19>] ext4_fill_super+0x2019/0x3270
[   18.608097]  [<ffffffff813434f3>] ? pointer+0x2a3/0x400
[   18.608097]  [<ffffffff811cf427>] mount_bdev+0x187/0x1d0
[   18.608097]  [<ffffffff811711b5>] ? __alloc_percpu+0x15/0x20
[   18.608097]  [<ffffffff81288a00>] ? ext4_alloc_flex_bg_array+0x110/0x110
[   18.608097]  [<ffffffff81279e85>] ext4_mount+0x15/0x20
[   18.608097]  [<ffffffff811ce383>] mount_fs+0x43/0x170
[   18.608097]  [<ffffffff811ee686>] vfs_kern_mount+0x76/0x130
[   18.608097]  [<ffffffff811ef5a6>] do_mount+0x226/0xcb0
[   18.608097]  [<ffffffff81083e53>] ? __might_sleep+0x53/0xa0
[   18.608097]  [<ffffffff8117c9d1>] ? __might_fault+0x31/0x40
[   18.608097]  [<ffffffff8116ae57>] ? memdup_user+0x57/0x90
[   18.608097]  [<ffffffff8116aee3>] ? strndup_user+0x53/0x70
[   18.608097]  [<ffffffff811f00aa>] SyS_mount+0x7a/0xc0
[   18.608097]  [<ffffffff816a23ea>] entry_SYSCALL_64_fastpath+0x18/0xa8


The crashing code: 

2b:*	49 0f ab 0c 24       	bts    %rcx,(%r12)		<-- trapping instruction

so RCX is the bit we want to set and r12 would be the page: 
R12: ffff880005940000 
RCX: 0000000000008000

However, the faulting address is actually the next page, following the 
one we allocated in ext4_calculate_overhead: 
CR2: ffff880005941000

Given this is a crafted image I guess there is inadequate validation 
of the s_cluster_bit as well as the values in ext4_bg_num_gdb, since this
function is used to get the number of iterations in calculate_overhead. 



Regards, 
Nikolay 




