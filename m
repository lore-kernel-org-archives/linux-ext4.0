From: Nikolay Borisov <kernel@kyup.com>
Subject: Size of extent LRU
Date: Tue, 29 Mar 2016 11:35:06 +0300
Message-ID: <56FA3E3A.8000102@kyup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:33847 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbcC2IfK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Mar 2016 04:35:10 -0400
Received: by mail-wm0-f49.google.com with SMTP id p65so128596480wmp.1
        for <linux-ext4@vger.kernel.org>; Tue, 29 Mar 2016 01:35:09 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hello, 

I'd like to ask what should the average size of the sbi->s_es_lru be? 
I just had a server die on me due to rcu_scheds caused by list_sorting this 
list? What happened is that machine ran out of memory and the ext4 shrinker 
got activated and the following was printed in dmesg: 

[4226538.122788] list passed to list_sort() too long for efficiency

A lot of CPUs were stuck with the following backtrace: 
[4226563.504310] Call Trace:
[4226563.504316]  [<ffffffff8129afd2>] __ext4_es_shrink+0x42/0x300
[4226563.504319]  [<ffffffff8129bbe6>] ext4_es_scan+0x86/0x150
[4226563.504323]  [<ffffffff81152ffe>] shrink_slab_node+0x13e/0x2e0
[4226563.504326]  [<ffffffff8115322a>] shrink_slab+0x8a/0x140
[4226563.504329]  [<ffffffff81156095>] do_try_to_free_pages+0x445/0x580
[4226563.504331]  [<ffffffff8115646a>] try_to_free_pages+0x10a/0x1d0
[4226563.504336]  [<ffffffff811493aa>] __alloc_pages_nodemask+0x7ba/0xc20
[4226563.504341]  [<ffffffff81190df9>] ? kmem_cache_alloc_node+0x99/0x200
[4226563.504346]  [<ffffffff8108867f>] copy_process+0x18f/0x1920
[4226563.504350]  [<ffffffff811b64fb>] ? path_get+0x2b/0x40
[4226563.504354]  [<ffffffff811c8ebd>] ? __alloc_fd+0xed/0x160
[4226563.504356]  [<ffffffff8108a1ae>] do_fork+0x5e/0x370
[4226563.504361]  [<ffffffff8109e1b3>] ? __set_current_blocked+0x53/0x70
[4226563.504363]  [<ffffffff8108a4d6>] SyS_clone+0x16/0x20
[4226563.504366]  [<ffffffff8164c789>] stub_clone+0x69/0x90
[4226563.504368]  [<ffffffff8164c4b2>] ? system_call_fastpath+0x16/0x1b


Whereas the one which was allegedly working on the list looked like so: 

[4226563.509535] NMI backtrace for cpu 47
[4226563.509536] CPU: 47 PID: 22156 Comm: php Tainted: G           O 3.12.52-clouder2 #1
[4226563.509537] Hardware name: Supermicro X10DRi/X10DRi, BIOS 1.1 04/14/2015
[4226563.509539] task: ffff881f8d3d58b0 ti: ffff880039c74000 task.ti: ffff880039c74000
[4226563.509542] RIP: 0010:[<ffffffff8129ab4d>]  [<ffffffff8129ab4d>] ext4_inode_touch_time_cmp+0x5d/0x90
[4226563.509543] RSP: 0018:ffff880039c756e8  EFLAGS: 00000246
[4226563.509544] RAX: 0000100000000000 RBX: 0000000000000000 RCX: 000000011424ee1a
[4226563.509545] RDX: 000000011424fef0 RSI: ffff880338ef5658 RDI: ffff88018d720f20
[4226563.509546] RBP: ffff880039c756e8 R08: ffff880338ef5330 R09: 0000000000000040
[4226563.509546] R10: 0000000000000000 R11: 0000000000000001 R12: ffffffff8129aaf0
[4226563.509547] R13: ffff88018d721248 R14: ffff880338ef5658 R15: ffff88018d720e80
[4226563.509548] FS:  00002b195451fec0(0000) GS:ffff883fff4e0000(0000) knlGS:0000000000000000
[4226563.509549] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[4226563.509550] CR2: 000000000071ca9c CR3: 00000003fcb31000 CR4: 00000000001407e0
[4226563.509551] Stack:
[4226563.509555]  ffff880039c75828 ffffffff81334100 ffff880039c75778 ffff880039c75738
[4226563.509560]  0000000000000bc2 ffff881f295bf400 ffff883466ca7498 000000138066005d
[4226563.509565]  0000000000000013 ffff880039c757d0 0000000000000000 0000000000000000
[4226563.509565] Call Trace:
[4226563.509569]  [<ffffffff81334100>] list_sort+0xe0/0x3c0
[4226563.509573]  [<ffffffff8129b13c>] __ext4_es_shrink+0x1ac/0x300
[4226563.509576]  [<ffffffff816491ec>] ? __schedule+0x2dc/0x760
[4226563.509579]  [<ffffffff8129bbe6>] ext4_es_scan+0x86/0x150
[4226563.509581]  [<ffffffff81152ffe>] shrink_slab_node+0x13e/0x2e0
[4226563.509584]  [<ffffffff8115322a>] shrink_slab+0x8a/0x140
[4226563.509586]  [<ffffffff81156095>] do_try_to_free_pages+0x445/0x580
[4226563.509589]  [<ffffffff8115646a>] try_to_free_pages+0x10a/0x1d0
[4226563.509592]  [<ffffffff811493aa>] __alloc_pages_nodemask+0x7ba/0xc20
[4226563.509596]  [<ffffffff8119cc90>] ? mem_cgroup_update_page_stat+0x20/0x60
[4226563.509599]  [<ffffffff81188888>] alloc_pages_vma+0xa8/0x1c0
[4226563.509603]  [<ffffffff8116e712>] handle_mm_fault+0xe62/0x12f0
[4226563.509606]  [<ffffffff8117fb64>] ? free_pages_and_swap_cache+0xb4/0xe0
[4226563.509610]  [<ffffffff81082d31>] ? flush_tlb_mm_range+0x121/0x1b0
[4226563.509613]  [<ffffffff81169fcf>] ? tlb_flush_mmu+0x5f/0xa0
[4226563.509616]  [<ffffffff8107d685>] __do_page_fault+0x185/0x470
[4226563.509619]  [<ffffffff811cb212>] ? mntput_no_expire+0x42/0x140
[4226563.509622]  [<ffffffff811cb331>] ? mntput+0x21/0x30
[4226563.509624]  [<ffffffff811aca99>] ? __fput+0x199/0x250
[4226563.509627]  [<ffffffff8133043a>] ? trace_hardirqs_off_thunk+0x3a/0x6c
[4226563.509630]  [<ffffffff8107d97e>] do_page_fault+0xe/0x10
[4226563.509633]  [<ffffffff8164bca2>] page_fault+0x22/0x30

Is there a way to acquire the number of extents on the list at the time? 
(I have a full crash dump of that failure). 
