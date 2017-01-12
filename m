From: "George Spelvin" <linux@sciencehorizons.net>
Subject: Re: [PATCH 0/4] ext4 inline cleanup patches
Date: 12 Jan 2017 04:12:54 -0500
Message-ID: <20170112091254.31257.qmail@ns.sciencehorizons.net>
References: <20170112034938.5934-1-tytso@mit.edu>
Cc: linux@sciencehorizons.net
To: linux-ext4@vger.kernel.org, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns.sciencehorizons.net ([71.41.210.147]:34376 "HELO
        ns.sciencehorizons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1750822AbdALJTi (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Jan 2017 04:19:38 -0500
In-Reply-To: <20170112034938.5934-1-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

It *seems* to work, although it doesn't apply to v4.9.x (because
ext4_truncate returns void in that version), and I ran into two
unrelared bugs in v4.10-rc3 before I was able to test.

I'll probably go back to v4.9.x and leave off patch 4/4.

[   32.928704] BUG: unable to handle kernel paging request at ffffc90003ed5000
[   32.928820] IP: memcpy_erms+0x6/0x10
[   32.928926] PGD 42d41b067 
[   32.928926] PUD 42d41c067 
[   32.929264] PMD 428b6d067 
[   32.929634] PTE 0

[   32.930000] Oops: 0000 [#1] SMP
[   32.930000] Modules linked in: twofish_generic twofish_avx_x86_64 ablk_helper twofish_x86_64_3way twofish_x86_64 twofish_common cmac xcbc x86_pkg_temp_thermal crc32_pclmul crc32c_intel via_velocity
[   32.930000] CPU: 2 PID: 2442 Comm: microcode_ctl Not tainted 4.10.0-rc3-00129-g9ce34823-dirty #590
[   32.930000] Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./X79-UP4, BIOS F7 03/19/2014
[   32.930000] task: ffff8804226d4080 task.stack: ffffc90003ece000
[   32.930000] RIP: 0010:memcpy_erms+0x6/0x10
[   32.930000] RSP: 0018:ffffc90003ecfcc8 EFLAGS: 00010286
[   32.930000] RAX: ffff880422700000 RBX: 0000000000005c00 RCX: 0000000000001c00
[   32.930000] RDX: 0000000000005c00 RSI: ffffc90003ed5000 RDI: ffff880422704000
[   32.930000] RBP: ffffc90003ecfce0 R08: 000000000001a358 R09: 0000000000000000
[   32.930000] R10: 0000000000000000 R11: 0000000000000000 R12: ffffc90003ed1000
[   32.930000] R13: ffffc90003ed1000 R14: 0000000000005c00 R15: ffffffff81c2ab20
[   32.930000] FS:  0000000000000000(0000) GS:ffff88042f280000(0063) knlGS:00000000f77467c0
[   32.930000] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
[   32.930000] CR2: ffffc90003ed5000 CR3: 0000000428f9f000 CR4: 00000000001406e0
[   32.930000] Call Trace:
[   32.930000]  ? kmemdup+0x31/0x40
[   32.930000]  __alloc_microcode_buf+0x3a/0x60
[   32.930000]  save_microcode_patch+0xaa/0x100
[   32.930000]  generic_load_microcode+0x1b7/0x240
[   32.930000]  ? get_ucode_fw+0x10/0x10
[   32.930000]  request_microcode_user+0x10/0x20
[   32.930000]  microcode_write+0x8f/0xf0
[   32.930000]  __vfs_write+0x23/0x120
[   32.930000]  ? debug_check_no_locks_freed+0xb1/0x140
[   32.930000]  ? trace_hardirqs_on_caller+0xed/0x1b0
[   32.930000]  ? trace_hardirqs_on+0xd/0x10
[   32.930000]  vfs_write+0xc4/0x220
[   32.930000]  ? putname+0x4e/0x60
[   32.930000]  SyS_write+0x44/0xa0
[   32.930000]  do_fast_syscall_32+0x94/0x210
[   32.930000]  entry_SYSENTER_compat+0x51/0x60
[   32.930000] RIP: 0023:0xf7749af9
[   32.930000] RSP: 002b:00000000ffaa6268 EFLAGS: 00000246 ORIG_RAX: 0000000000000004
[   32.930000] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00000000f7560008
[   32.930000] RDX: 0000000000096c00 RSI: 0000000000040000 RDI: 0000000000096c00
[   32.930000] RBP: 00000000f7560008 R08: 0000000000000000 R09: 0000000000000000
[   32.930000] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[   32.930000] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[   32.930000] Code: 90 90 90 90 90 eb 1e 0f 1f 00 48 89 f8 48 89 d1 48 c1 e9 03 83 e2 07 f3 48 a5 89 d1 f3 a4 c3 66 0f 1f 44 00 00 48 89 f8 48 89 d1 <f3> a4 c3 0f 1f 80 00 00 00 00 48 89 f8 48 83 fa 20 72 7e 40 38 
[   32.930000] RIP: memcpy_erms+0x6/0x10 RSP: ffffc90003ecfcc8
[   32.930000] CR2: ffffc90003ed5000
[   32.930000] ---[ end trace aa4a28ed3683fb12 ]---
[   32.930000] BUG: sleeping function called from invalid context at ./include/linux/sched.h:3153
[   32.930000] in_atomic(): 0, irqs_disabled(): 1, pid: 2442, name: microcode_ctl
[   32.930000] INFO: lockdep is turned off.
[   32.930000] irq event stamp: 7732
[   32.930000] hardirqs last  enabled at (7731): [<ffffffff8112ffcb>] get_page_from_freelist+0x37b/0x910
[   32.930000] hardirqs last disabled at (7732): [<ffffffff817b8b5f>] error_entry+0x6f/0xc0
[   32.930000] softirqs last  enabled at (7230): [<ffffffff810830b7>] __do_softirq+0x1f7/0x260
[   32.930000] softirqs last disabled at (7215): [<ffffffff810832ae>] irq_exit+0xbe/0xd0
[   32.930000] CPU: 2 PID: 2442 Comm: microcode_ctl Tainted: G      D         4.10.0-rc3-00129-g9ce34823-dirty #590
[   32.930000] Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./X79-UP4, BIOS F7 03/19/2014
[   32.930000] Call Trace:
[   32.930000]  dump_stack+0x68/0x93
[   32.930000]  ___might_sleep+0x16b/0x230
[   32.930000]  __might_sleep+0x45/0x80
[   32.930000]  exit_signals+0x1f/0x110
[   32.930000]  do_exit+0x9f/0xaa0
[   32.930000]  rewind_stack_do_exit+0x17/0x20
[   32.930000] RIP: 0023:0xf7749af9
[   32.930000] RSP: 002b:00000000ffaa6268 EFLAGS: 00000246 ORIG_RAX: 0000000000000004
[   32.930000] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00000000f7560008
[   32.930000] RDX: 0000000000096c00 RSI: 0000000000040000 RDI: 0000000000096c00
[   32.930000] RBP: 00000000f7560008 R08: 0000000000000000 R09: 0000000000000000
[   32.930000] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[   32.930000] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
