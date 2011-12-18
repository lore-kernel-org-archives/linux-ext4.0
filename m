From: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: 3.2.0-rc5 NULL dereference BUG
Date: Sun, 18 Dec 2011 14:30:54 +0800
Message-ID: <20111218063054.GA4979@localhost>
References: <20111218055359.GA17182@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20111218055359.GA17182@localhost>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Dec 18, 2011 at 01:53:59PM +0800, Wu Fengguang wrote:
> This is very reproducible. It occurs in two of my test cases, with
> different panic messages.
> 
> It also shows up in 3.2.0-rc3. Kernel config is attached.

Oh well, it happens even in 3.1. Here is the dmesg:

[  210.758668] ------------[ cut here ]------------
[  210.764665] WARNING: at /c/wfg/linux/kernel/lockdep.c:690 __lock_acquire+0x155/0x938()
[  210.774369] Hardware name: SandyBridge Platform
[  210.779898] Modules linked in:
[  210.783852] Pid: 4409, comm: dd Not tainted 3.1.0+ #299
[  210.790158] Call Trace:
[  210.793359]  [<ffffffff810734ec>] warn_slowpath_common+0x85/0x9d
[  210.800538]  [<ffffffff8107351e>] warn_slowpath_null+0x1a/0x1c
[  210.807523]  [<ffffffff810a1900>] __lock_acquire+0x155/0x938
[  210.814312]  [<ffffffff810a21c0>] lock_acquire+0xdd/0x10a
[  210.820815]  [<ffffffff81063568>] ? double_rq_lock+0x45/0x57
[  210.827607]  [<ffffffff8199a23b>] _raw_spin_lock+0x36/0x69
[  210.834145]  [<ffffffff81063568>] ? double_rq_lock+0x45/0x57
[  210.840927]  [<ffffffff81063568>] double_rq_lock+0x45/0x57
[  210.847528]  [<ffffffff8106d57c>] load_balance+0x1f1/0x69b
[  210.854085]  [<ffffffff810a1d12>] ? __lock_acquire+0x567/0x938
[  210.861076]  [<ffffffff810a1265>] ? lock_release_holdtime+0xa3/0xac
[  210.868548]  [<ffffffff81997390>] __schedule+0x39a/0x937
[  210.874952]  [<ffffffff81997309>] ? __schedule+0x313/0x937
[  210.881556]  [<ffffffff810a1d12>] ? __lock_acquire+0x567/0x938
[  210.888548]  [<ffffffff8103bebe>] ? native_sched_clock+0x2d/0x5f
[  210.895733]  [<ffffffff81998180>] ? schedule_timeout+0x242/0x274
[  210.902904]  [<ffffffff81096611>] ? local_clock+0x41/0x5a
[  210.909395]  [<ffffffff810a1265>] ? lock_release_holdtime+0xa3/0xac
[  210.916814]  [<ffffffff81998180>] ? schedule_timeout+0x242/0x274
[  210.923995]  [<ffffffff81997beb>] schedule+0x5a/0x5c
[  210.929943]  [<ffffffff81998185>] schedule_timeout+0x247/0x274
[  210.936933]  [<ffffffff810812e0>] ? del_timer+0xc8/0xc8
[  210.943246]  [<ffffffff81997ed4>] io_schedule_timeout+0x98/0xe9
[  210.950271]  [<ffffffff81102e41>] balance_dirty_pages_ratelimited_nr+0x4d2/0x686
[  210.959399]  [<ffffffff810f9354>] generic_file_buffered_write+0x1c9/0x22d
[  210.967400]  [<ffffffff810782c2>] ? current_fs_time+0x27/0x2e
[  210.974295]  [<ffffffff810fadbd>] __generic_file_aio_write+0x32e/0x35e
[  210.981993]  [<ffffffff810fae53>] generic_file_aio_write+0x66/0xc1
[  210.989370]  [<ffffffff811deb83>] ext4_file_write+0x1f6/0x24f
[  210.996212]  [<ffffffff8103bebe>] ? native_sched_clock+0x2d/0x5f
[  211.003399]  [<ffffffff8117729a>] ? fsnotify+0x216/0x26f
[  211.009805]  [<ffffffff81096611>] ? local_clock+0x41/0x5a
[  211.016310]  [<ffffffff81144e86>] do_sync_write+0xcb/0x108
[  211.022918]  [<ffffffff81145550>] vfs_write+0xb8/0x157
[  211.029125]  [<ffffffff81145807>] sys_write+0x4d/0x77
[  211.035228]  [<ffffffff819a1802>] system_call_fastpath+0x16/0x1b
[  211.042370] ---[ end trace a682372b42c1df33 ]---
[  443.558240] BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
[  443.567910] IP: [<ffffffff811f2e62>] perf_trace_ext4_mb_release_group_pa+0x81/0xd6
[  443.577206] PGD 80e790067 PUD 8133be067 PMD 0
[  443.582895] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[  443.588602] CPU 11
[  443.590821] Modules linked in:
[  443.595323]
[  443.597439] Pid: 4252, comm: flush-8:16 Tainted: G        W   3.1.0+ #299 Intel Corporation SandyBridge Platform/To be filled by O.E.M.
[  443.612154] RIP: 0010:[<ffffffff811f2e62>]  [<ffffffff811f2e62>] perf_trace_ext4_mb_release_group_pa+0x81/0xd6
[  443.624266] RSP: 0018:ffff88041eb695d0  EFLAGS: 00010282
[  443.630679] RAX: ffffe8fffc407380 RBX: ffff880815c061f8 RCX: ffff88041d9e4500
[  443.639117] RDX: 0000000000000000 RSI: 0000000000000282 RDI: ffffe8fffc407380
[  443.647564] RBP: ffff88041eb696b0 R08: ffff88041eb695f0 R09: 0000000000000000
[  443.656006] R10: ffffe8fffc006ea0 R11: ffffffff8120745f R12: ffffffff81f07698
[  443.664382] R13: ffff88041eb69760 R14: ffff88081f709750 R15: ffff88080a1a29d8
[  443.672828] FS:  0000000000000000(0000) GS:ffff88082b400000(0000) knlGS:0000000000000000
[  443.682722] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  443.689600] CR2: 0000000000000028 CR3: 00000008133bf000 CR4: 00000000000406e0
[  443.697984] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  443.706430] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  443.714820] Process flush-8:16 (pid: 4252, threadinfo ffff88041eb68000, task ffff88041d9e45e0)
[  443.725298] Stack:
[  443.728009]  0000000000000000 0000000000000004 ffff88041eb69660 ffff88041eb695f0
[  443.737474]  0000000000000000 0000000000000000 0000000000000000 0000000000000000
[  443.746928]  ffff88041eb69700 0000000000000000 0000000000000000 0000000000000000
[  443.756380] Call Trace:
[  443.759585]  [<ffffffff81204abe>] ? ext4_mb_release_group_pa+0x40/0xfe
[  443.767347]  [<ffffffff81204abe>] ext4_mb_release_group_pa+0x40/0xfe
[  443.774916]  [<ffffffff8120749f>] ext4_mb_discard_group_preallocations+0x355/0x3eb
[  443.784233]  [<ffffffff8120a3a5>] ext4_mb_new_blocks+0x2de/0x3f4
[  443.791414]  [<ffffffff812021c8>] ext4_ext_map_blocks+0xf63/0x1331
[  443.798796]  [<ffffffff811e2810>] ? ext4_map_blocks+0xf5/0x1fa
[  443.805782]  [<ffffffff811e2841>] ext4_map_blocks+0x126/0x1fa
[  443.812671]  [<ffffffff811e5d56>] mpage_da_map_and_submit+0xec/0x3b2
[  443.820241]  [<ffffffff811e6742>] ext4_da_writepages+0x316/0x4b0
[  443.827429]  [<ffffffff810a3359>] ? lock_release_non_nested+0x22c/0x293
[  443.835299]  [<ffffffff81103272>] do_writepages+0x24/0x2d
[  443.851241]  [<ffffffff811675c9>] writeback_single_inode+0x135/0x2c3
[  443.858809]  [<ffffffff81167e23>] writeback_sb_inodes+0x182/0x22c
[  443.866078]  [<ffffffff81168371>] __writeback_inodes_wb+0x78/0xb9
[  443.873355]  [<ffffffff8116851f>] wb_writeback+0x16d/0x276
[  443.879951]  [<ffffffff8116897b>] wb_do_writeback+0x1c8/0x1e3
[  443.886831]  [<ffffffff810812e0>] ? del_timer+0xc8/0xc8
[  443.893136]  [<ffffffff81168a22>] bdi_writeback_thread+0x8c/0x215
[  443.900413]  [<ffffffff81168996>] ? wb_do_writeback+0x1e3/0x1e3
[  443.907490]  [<ffffffff81090930>] kthread+0x8e/0x96
[  443.913355]  [<ffffffff819a3a04>] kernel_thread_helper+0x4/0x10
[  443.920403]  [<ffffffff8199ae74>] ? retint_restore_args+0x13/0x13
[  443.927626]  [<ffffffff810908a2>] ? __init_kthread_worker+0x5b/0x5b
[  443.935099]  [<ffffffff819a3a00>] ? gs_change+0x13/0x13
[  443.941388] Code: 89 c2 4c 89 85 38 ff ff ff 48 8d 4d ec 41 0f b7 74 24 48 e8 3a d6 7a 00 4c 8b 85 38 ff ff ff 48 85 c0 74 50 48 8b 93 a0 00 00 00
[  443.960015]  8b 52 28 8b 52 10 89 50 0c 48 8b 93 80 00 00 00 48 89 50 10
[  443.970522] RIP  [<ffffffff811f2e62>] perf_trace_ext4_mb_release_group_pa+0x81/0xd6
[  443.980029]  RSP <ffff88041eb695d0>
[  443.984374] CR2: 0000000000000028
[  443.988542] BUG: unable to handle kernel
[  443.988745] ---[ end trace a682372b42c1df34 ]---
[  443.999169] NULL pointer dereference at 0000000000000028
[  444.005637] IP: [<ffffffff811f2e62>] perf_trace_ext4_mb_release_group_pa+0x81/0xd6
[  444.014987] PGD 810faa067 PUD 8110f6067 PMD 0
[  444.020575] Oops: 0000 [#2] SMP DEBUG_PAGEALLOC
[  444.026317] CPU 1
[  444.028441] Modules linked in:
[  444.032997]
[  444.035107] Pid: 5480, comm: dd Tainted: G      D W   3.1.0+ #299 Intel Corporation SandyBridge Platform/To be filled by O.E.M.
[  444.049013] RIP: 0010:[<ffffffff811f2e62>]  [<ffffffff811f2e62>] perf_trace_ext4_mb_release_group_pa+0x81/0xd6
[  444.061108] RSP: 0018:ffff880809f252e8  EFLAGS: 00010282
[  444.067494] RAX: ffffe8fbfd007380 RBX: ffff880811f6f458 RCX: ffff880809862200
[  444.075922] RDX: 0000000000000000 RSI: 0000000000000282 RDI: ffffe8fbfd007380
[  444.084349] RBP: ffff880809f253c8 R08: ffff880809f25308 R09: 0000000000000000
[  444.092776] R10: ffffe8fffd206ea0 R11: ffffffff8120745f R12: ffffffff81f07698
[  444.101194] R13: ffff880809f25478 R14: ffff88081f709750 R15: ffff880811f42930
[  444.109607] FS:  00007f2265a23700(0000) GS:ffff88042c000000(0000) knlGS:0000000000000000
[  444.119477] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  444.126350] CR2: 0000000000000028 CR3: 00000008110d3000 CR4: 00000000000406e0
[  444.134777] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  444.143205] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  444.151633] Process dd (pid: 5480, threadinfo ffff880809f24000, task ffff8808098622f0)
[  444.161311] Stack:
[  444.164001]  ffff880809f25358 0000000000000000 ffff88081d13a650 ffff880809f25308
[  444.173422]  0000000000000000 0000000000000000 0000000000000000 0000000000000000
[  444.178355]  ffff880809f25418 0000000000000000 0000000000000000 0000000000000000
[  444.178358] Call Trace:
[  444.178364]  [<ffffffff81204abe>] ? ext4_mb_release_group_pa+0x40/0xfe
[  444.178367]  [<ffffffff81204abe>] ext4_mb_release_group_pa+0x40/0xfe
[  444.178370]  [<ffffffff8120749f>] ext4_mb_discard_group_preallocations+0x355/0x3eb
[  444.178374]  [<ffffffff8120a3a5>] ext4_mb_new_blocks+0x2de/0x3f4
[  444.178378]  [<ffffffff812021c8>] ext4_ext_map_blocks+0xf63/0x1331
[  444.178382]  [<ffffffff811e2810>] ? ext4_map_blocks+0xf5/0x1fa
[  444.178385]  [<ffffffff811e2841>] ext4_map_blocks+0x126/0x1fa
[  444.178388]  [<ffffffff811e5d56>] mpage_da_map_and_submit+0xec/0x3b2
[  444.178391]  [<ffffffff811e6742>] ext4_da_writepages+0x316/0x4b0
[  444.178396]  [<ffffffff81103272>] do_writepages+0x24/0x2d
[  444.178400]  [<ffffffff811675c9>] writeback_single_inode+0x135/0x2c3
[  444.178403]  [<ffffffff81167e23>] writeback_sb_inodes+0x182/0x22c
[  444.178406]  [<ffffffff81168371>] __writeback_inodes_wb+0x78/0xb9
[  444.178409]  [<ffffffff81168799>] writeback_inodes_wb+0x62/0x7c
[  444.178412]  [<ffffffff81102d4b>] balance_dirty_pages_ratelimited_nr+0x3dc/0x686
[  444.178417]  [<ffffffff810f9354>] generic_file_buffered_write+0x1c9/0x22d
[  444.178421]  [<ffffffff810782c2>] ? current_fs_time+0x27/0x2e
[  444.178424]  [<ffffffff810fadbd>] __generic_file_aio_write+0x32e/0x35e
[  444.178428]  [<ffffffff810fae53>] generic_file_aio_write+0x66/0xc1
[  444.178431]  [<ffffffff811deb83>] ext4_file_write+0x1f6/0x24f
[  444.178435]  [<ffffffff8103bebe>] ? native_sched_clock+0x2d/0x5f
[  444.178439]  [<ffffffff8117729a>] ? fsnotify+0x216/0x26f
[  444.178443]  [<ffffffff81096611>] ? local_clock+0x41/0x5a
[  444.178448]  [<ffffffff81144e86>] do_sync_write+0xcb/0x108
[  444.178451]  [<ffffffff81145550>] vfs_write+0xb8/0x157
[  444.178453]  [<ffffffff81145807>] sys_write+0x4d/0x77
[  444.178456]  [<ffffffff819a1802>] system_call_fastpath+0x16/0x1b
[  444.178458] Code: 89 c2 4c 89 85 38 ff ff ff 48 8d 4d ec 41 0f b7 74 24 48 e8 3a d6 7a 00 4c 8b 85 38 ff ff ff 48 85 c0 74 50 48 8b 93 a0 00 00 00
[  444.178471]  8b 52 28 8b 52 10 89 50 0c 48 8b 93 80 00 00 00 48 89 50 10
[  444.178477] RIP  [<ffffffff811f2e62>] perf_trace_ext4_mb_release_group_pa+0x81/0xd6
[  444.178481]  RSP <ffff880809f252e8>
[  444.178482] CR2: 0000000000000028
[  444.178933] ---[ end trace a682372b42c1df35 ]---
[  444.178940] ------------[ cut here ]------------
[  444.178944] WARNING: at /c/wfg/linux/kernel/exit.c:900 do_exit+0x67/0x771()
[  444.178949] Hardware name: SandyBridge Platform
[  444.178956] Modules linked in:
[  444.178962] Pid: 5480, comm: dd Tainted: G      D W   3.1.0+ #299
[  444.178966] Call Trace:
[  444.178972]  [<ffffffff810734ec>] warn_slowpath_common+0x85/0x9d
[  444.178979]  [<ffffffff81074c7a>] ? kmsg_dump+0x8a/0x10c
[  444.178983]  [<ffffffff8107351e>] warn_slowpath_null+0x1a/0x1c
[  444.178990]  [<ffffffff81076bab>] do_exit+0x67/0x771
[  444.178996]  [<ffffffff81074ceb>] ? kmsg_dump+0xfb/0x10c
[  444.179001]  [<ffffffff81074c7a>] ? kmsg_dump+0x8a/0x10c
[  444.179013]  [<ffffffff8199bd4c>] oops_end+0xbe/0xc6
[  444.179022]  [<ffffffff81055e86>] no_context+0x1f9/0x208
[  444.179029]  [<ffffffff8105605e>] __bad_area_nosemaphore+0x1c9/0x1e9
[  444.179035]  [<ffffffff810560dd>] bad_area+0x4a/0x51
[  444.179041]  [<ffffffff8199dece>] do_page_fault+0x27e/0x431
[  444.179049]  [<ffffffff810f810c>] ? perf_output_copy+0x71/0x71
[  444.179055]  [<ffffffff810f5d7f>] ? perf_swevent_overflow+0x90/0xaa
[  444.179072]  [<ffffffff813e985d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[  444.179162]  [<ffffffff8120745f>] ? ext4_mb_discard_group_preallocations+0x315/0x3eb
[  444.179174]  [<ffffffff8199b085>] page_fault+0x25/0x30
[  444.179178]  [<ffffffff8120745f>] ? ext4_mb_discard_group_preallocations+0x315/0x3eb
[  444.179222]  [<ffffffff811f2e62>] ? perf_trace_ext4_mb_release_group_pa+0x81/0xd6
[  444.179248]  [<ffffffff811f2e4f>] ? perf_trace_ext4_mb_release_group_pa+0x6e/0xd6
[  444.179261]  [<ffffffff81204abe>] ? ext4_mb_release_group_pa+0x40/0xfe
[  444.179271]  [<ffffffff81204abe>] ext4_mb_release_group_pa+0x40/0xfe
[  444.179276]  [<ffffffff8120749f>] ext4_mb_discard_group_preallocations+0x355/0x3eb
[  444.179282]  [<ffffffff8120a3a5>] ext4_mb_new_blocks+0x2de/0x3f4
[  444.179288]  [<ffffffff812021c8>] ext4_ext_map_blocks+0xf63/0x1331
[  444.179295]  [<ffffffff811e2810>] ? ext4_map_blocks+0xf5/0x1fa
[  444.179300]  [<ffffffff811e2841>] ext4_map_blocks+0x126/0x1fa
[  444.179306]  [<ffffffff811e5d56>] mpage_da_map_and_submit+0xec/0x3b2
[  444.179311]  [<ffffffff811e6742>] ext4_da_writepages+0x316/0x4b0
[  444.179317]  [<ffffffff81103272>] do_writepages+0x24/0x2d
[  444.179477]  [<ffffffff811675c9>] writeback_single_inode+0x135/0x2c3
[  444.179505]  [<ffffffff81167e23>] writeback_sb_inodes+0x182/0x22c
[  444.179515]  [<ffffffff81168371>] __writeback_inodes_wb+0x78/0xb9
[  444.179521]  [<ffffffff81168799>] writeback_inodes_wb+0x62/0x7c
[  444.179526]  [<ffffffff81102d4b>] balance_dirty_pages_ratelimited_nr+0x3dc/0x686
[  444.179532]  [<ffffffff810f9354>] generic_file_buffered_write+0x1c9/0x22d
[  444.179535]  [<ffffffff810782c2>] ? current_fs_time+0x27/0x2e
[  444.179541]  [<ffffffff810fadbd>] __generic_file_aio_write+0x32e/0x35e
[  444.179549]  [<ffffffff810fae53>] generic_file_aio_write+0x66/0xc1
[  444.179555]  [<ffffffff811deb83>] ext4_file_write+0x1f6/0x24f
[  444.179560]  [<ffffffff8103bebe>] ? native_sched_clock+0x2d/0x5f
[  444.179563]  [<ffffffff8117729a>] ? fsnotify+0x216/0x26f
[  444.179569]  [<ffffffff81096611>] ? local_clock+0x41/0x5a
[  444.179577]  [<ffffffff81144e86>] do_sync_write+0xcb/0x108
[  444.179581]  [<ffffffff81145550>] vfs_write+0xb8/0x157
[  444.179586]  [<ffffffff81145807>] sys_write+0x4d/0x77
[  444.179593]  [<ffffffff819a1802>] system_call_fastpath+0x16/0x1b
[  444.179597] ---[ end trace a682372b42c1df36 ]---
[  444.179888] dd used greatest stack depth: 2088 bytes left
[  504.787849] INFO: rcu_sched_state detected stall on CPU 14 (t=60000 jiffies)
[  504.787854] INFO: rcu_sched_state detected stall on CPU 27 (t=60000 jiffies)
[  539.837210] BUG: spinlock lockup on CPU#14, dd/4796, ffff88081103c180
[  539.845293] Pid: 4796, comm: dd Tainted: G      D W   3.1.0+ #299
[  539.852582] Call Trace:
[  539.855792]  [<ffffffff813edf90>] do_raw_spin_lock+0x10c/0x137
[  539.862796]  [<ffffffff8199a25b>] _raw_spin_lock+0x56/0x69
[  539.869412]  [<ffffffff81208578>] ? ext4_mb_find_by_goal+0xdb/0x1ce
[  539.876900]  [<ffffffff81208578>] ext4_mb_find_by_goal+0xdb/0x1ce
[  539.883455] BUG: spinlock lockup on CPU#27, dd/5336, ffff88081103c080
[  539.883458] Pid: 5336, comm: dd Tainted: G      D W   3.1.0+ #299
[  539.883459] Call Trace:
[  539.883464]  [<ffffffff813edf90>] do_raw_spin_lock+0x10c/0x137
[  539.883467]  [<ffffffff8199a25b>] _raw_spin_lock+0x56/0x69
[  539.883471]  [<ffffffff81208578>] ? ext4_mb_find_by_goal+0xdb/0x1ce
[  539.883474]  [<ffffffff81208578>] ext4_mb_find_by_goal+0xdb/0x1ce
[  539.883477]  [<ffffffff81205856>] ? ext4_mb_normalize_request+0x2f4/0x480
[  539.883480]  [<ffffffff81208c6f>] ext4_mb_regular_allocator+0x59/0x312
[  539.883484]  [<ffffffff8120a25e>] ext4_mb_new_blocks+0x197/0x3f4
[  539.883487]  [<ffffffff811ff836>] ? ext4_ext_find_extent+0x130/0x2fb
[  539.883490]  [<ffffffff8199ac03>] ? _raw_spin_unlock+0x2b/0x2f
[  539.883493]  [<ffffffff812021c8>] ext4_ext_map_blocks+0xf63/0x1331
[  539.883499]  [<ffffffff811e2810>] ? ext4_map_blocks+0xf5/0x1fa
[  539.883502]  [<ffffffff811e2841>] ext4_map_blocks+0x126/0x1fa
[  539.883504]  [<ffffffff811e5d56>] mpage_da_map_and_submit+0xec/0x3b2
[  539.883507]  [<ffffffff811e6742>] ext4_da_writepages+0x316/0x4b0
[  539.883513]  [<ffffffff81103272>] do_writepages+0x24/0x2d
[  539.883520]  [<ffffffff811675c9>] writeback_single_inode+0x135/0x2c3
[  539.883523]  [<ffffffff81167e23>] writeback_sb_inodes+0x182/0x22c
[  539.883526]  [<ffffffff81168371>] __writeback_inodes_wb+0x78/0xb9
[  539.883528]  [<ffffffff81168799>] writeback_inodes_wb+0x62/0x7c
[  539.883532]  [<ffffffff81102d4b>] balance_dirty_pages_ratelimited_nr+0x3dc/0x686
[  539.883534]  [<ffffffff8116809e>] ? __mark_inode_dirty+0x2e/0x1cf
[  539.883539]  [<ffffffff810f9354>] generic_file_buffered_write+0x1c9/0x22d
[  539.883545]  [<ffffffff810782c2>] ? current_fs_time+0x27/0x2e
[  539.883548]  [<ffffffff810fadbd>] __generic_file_aio_write+0x32e/0x35e
[  539.883552]  [<ffffffff810fae53>] generic_file_aio_write+0x66/0xc1
[  539.883555]  [<ffffffff811deb83>] ext4_file_write+0x1f6/0x24f
[  539.883559]  [<ffffffff8117729a>] ? fsnotify+0x216/0x26f
[  539.883565]  [<ffffffff81144e86>] do_sync_write+0xcb/0x108
[  539.883567]  [<ffffffff81145550>] vfs_write+0xb8/0x157
[  539.883570]  [<ffffffff81145807>] sys_write+0x4d/0x77
[  539.883574]  [<ffffffff819a1802>] system_call_fastpath+0x16/0x1b
[  540.125746]  [<ffffffff81205856>] ? ext4_mb_normalize_request+0x2f4/0x480
[  540.133817]  [<ffffffff81208c6f>] ext4_mb_regular_allocator+0x59/0x312
[  540.133820]  [<ffffffff8120a25e>] ext4_mb_new_blocks+0x197/0x3f4
[  540.133823]  [<ffffffff811ff836>] ? ext4_ext_find_extent+0x130/0x2fb
[  540.133829]  [<ffffffff8199ac03>] ? _raw_spin_unlock+0x2b/0x2f
[  540.133831]  [<ffffffff812021c8>] ext4_ext_map_blocks+0xf63/0x1331
[  540.133838]  [<ffffffff811e2810>] ? ext4_map_blocks+0xf5/0x1fa
[  540.133840]  [<ffffffff811e2841>] ext4_map_blocks+0x126/0x1fa
[  540.133843]  [<ffffffff811e5d56>] mpage_da_map_and_submit+0xec/0x3b2
[  540.133845]  [<ffffffff811e6742>] ext4_da_writepages+0x316/0x4b0
[  540.133854]  [<ffffffff81103272>] do_writepages+0x24/0x2d
[  540.133861]  [<ffffffff811675c9>] writeback_single_inode+0x135/0x2c3
[  540.133863]  [<ffffffff81167e23>] writeback_sb_inodes+0x182/0x22c
[  540.133866]  [<ffffffff81168371>] __writeback_inodes_wb+0x78/0xb9
[  540.133869]  [<ffffffff81168799>] writeback_inodes_wb+0x62/0x7c
[  540.133872]  [<ffffffff81102d4b>] balance_dirty_pages_ratelimited_nr+0x3dc/0x686
[  540.133875]  [<ffffffff8116809e>] ? __mark_inode_dirty+0x2e/0x1cf
[  540.133880]  [<ffffffff810f9354>] generic_file_buffered_write+0x1c9/0x22d
[  540.133886]  [<ffffffff810782c2>] ? current_fs_time+0x27/0x2e
[  540.133889]  [<ffffffff810fadbd>] __generic_file_aio_write+0x32e/0x35e
[  540.133892]  [<ffffffff810fae53>] generic_file_aio_write+0x66/0xc1
[  540.133896]  [<ffffffff811deb83>] ext4_file_write+0x1f6/0x24f
[  540.133900]  [<ffffffff8117729a>] ? fsnotify+0x216/0x26f
[  540.133905]  [<ffffffff81144e86>] do_sync_write+0xcb/0x108
[  540.133908]  [<ffffffff81145550>] vfs_write+0xb8/0x157
[  540.133910]  [<ffffffff81145807>] sys_write+0x4d/0x77
[  540.133914]  [<ffffffff819a1802>] system_call_fastpath+0x16/0x1b
[  684.729866] INFO: rcu_sched_state detected stall on CPU 27 (t=240030 jiffies)
[  684.730858] INFO: rcu_sched_state detected stall on CPU 14 (t=240030 jiffies)
[  864.673871] INFO: rcu_sched_state detected stall on CPU 27 (t=420061 jiffies)
[  864.673877] INFO: rcu_sched_state detected stall on CPU 14 (t=420061 jiffies)
[ 1044.615889] INFO: rcu_sched_state detected stall on CPU 27 (t=600092 jiffies)
[ 1044.616884] INFO: rcu_sched_state detected stall on CPU 14 (t=600092 jiffies)
[ 1224.558902] INFO: rcu_sched_state detected stall on CPU 27 (t=780123 jiffies)
[ 1224.559899] INFO: rcu_sched_state detected stall on CPU 14 (t=780123 jiffies)
[ 1404.501917] INFO: rcu_sched_state detected stall on CPU 14 (t=960154 jiffies)
[ 1404.501922] INFO: rcu_sched_state detected stall on CPU 27 (t=960154 jiffies)
[ 1584.443929] INFO: rcu_sched_state detected stall on CPU 27 (t=1140184 jiffies)
[ 1584.443935] INFO: rcu_sched_state detected stall on CPU 14 (t=1140184 jiffies)
[ 1764.386941] INFO: rcu_sched_state detected stall on CPU 14 (t=1320214 jiffies)
[ 1764.386944] INFO: rcu_sched_state detected stall on CPU 27 (t=1320215 jiffies)
[ 1944.328956] INFO: rcu_sched_state detected stall on CPU 14 (t=1500245 jiffies)
[ 1944.328960] INFO: rcu_sched_state detected stall on CPU 27 (t=1500245 jiffies)
[ 2124.270971] INFO: rcu_sched_state detected stall on CPU 14 (t=1680275 jiffies)
[ 2124.270976] INFO: rcu_sched_state detected stall on CPU 27 (t=1680275 jiffies)
[ 2304.212984] INFO: rcu_sched_state detected stall on CPU 14 (t=1860305 jiffies)
[ 2304.213983] INFO: rcu_sched_state detected stall on CPU 27 (t=1860306 jiffies)
[ 2484.155998] INFO: rcu_sched_state detected stall on CPU 27 (t=2040336 jiffies)
[ 2484.156998] INFO: rcu_sched_state detected stall on CPU 14 (t=2040337 jiffies)

