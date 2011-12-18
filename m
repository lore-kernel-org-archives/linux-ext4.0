From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: 3.2.0-rc5 NULL dereference BUG
Date: Sun, 18 Dec 2011 15:17:18 +0800
Message-ID: <CAGBYx2bxdnkXcZF+A1iOvnsW=xdtDJR7Fx3Rz-HWeWH5n0ByKg@mail.gmail.com>
References: <20111218055359.GA17182@localhost>
	<20111218063054.GA4979@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20111218063054.GA4979@localhost>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Fengguang,

Could you try the patch [ext4: do not reference pa_inode from group_pa]=
?

Thanks,
Yongqiang.

On Sun, Dec 18, 2011 at 2:30 PM, Wu Fengguang <fengguang.wu@intel.com> =
wrote:
> On Sun, Dec 18, 2011 at 01:53:59PM +0800, Wu Fengguang wrote:
>> This is very reproducible. It occurs in two of my test cases, with
>> different panic messages.
>>
>> It also shows up in 3.2.0-rc3. Kernel config is attached.
>
> Oh well, it happens even in 3.1. Here is the dmesg:
>
> [ =A0210.758668] ------------[ cut here ]------------
> [ =A0210.764665] WARNING: at /c/wfg/linux/kernel/lockdep.c:690 __lock=
_acquire+0x155/0x938()
> [ =A0210.774369] Hardware name: SandyBridge Platform
> [ =A0210.779898] Modules linked in:
> [ =A0210.783852] Pid: 4409, comm: dd Not tainted 3.1.0+ #299
> [ =A0210.790158] Call Trace:
> [ =A0210.793359] =A0[<ffffffff810734ec>] warn_slowpath_common+0x85/0x=
9d
> [ =A0210.800538] =A0[<ffffffff8107351e>] warn_slowpath_null+0x1a/0x1c
> [ =A0210.807523] =A0[<ffffffff810a1900>] __lock_acquire+0x155/0x938
> [ =A0210.814312] =A0[<ffffffff810a21c0>] lock_acquire+0xdd/0x10a
> [ =A0210.820815] =A0[<ffffffff81063568>] ? double_rq_lock+0x45/0x57
> [ =A0210.827607] =A0[<ffffffff8199a23b>] _raw_spin_lock+0x36/0x69
> [ =A0210.834145] =A0[<ffffffff81063568>] ? double_rq_lock+0x45/0x57
> [ =A0210.840927] =A0[<ffffffff81063568>] double_rq_lock+0x45/0x57
> [ =A0210.847528] =A0[<ffffffff8106d57c>] load_balance+0x1f1/0x69b
> [ =A0210.854085] =A0[<ffffffff810a1d12>] ? __lock_acquire+0x567/0x938
> [ =A0210.861076] =A0[<ffffffff810a1265>] ? lock_release_holdtime+0xa3=
/0xac
> [ =A0210.868548] =A0[<ffffffff81997390>] __schedule+0x39a/0x937
> [ =A0210.874952] =A0[<ffffffff81997309>] ? __schedule+0x313/0x937
> [ =A0210.881556] =A0[<ffffffff810a1d12>] ? __lock_acquire+0x567/0x938
> [ =A0210.888548] =A0[<ffffffff8103bebe>] ? native_sched_clock+0x2d/0x=
5f
> [ =A0210.895733] =A0[<ffffffff81998180>] ? schedule_timeout+0x242/0x2=
74
> [ =A0210.902904] =A0[<ffffffff81096611>] ? local_clock+0x41/0x5a
> [ =A0210.909395] =A0[<ffffffff810a1265>] ? lock_release_holdtime+0xa3=
/0xac
> [ =A0210.916814] =A0[<ffffffff81998180>] ? schedule_timeout+0x242/0x2=
74
> [ =A0210.923995] =A0[<ffffffff81997beb>] schedule+0x5a/0x5c
> [ =A0210.929943] =A0[<ffffffff81998185>] schedule_timeout+0x247/0x274
> [ =A0210.936933] =A0[<ffffffff810812e0>] ? del_timer+0xc8/0xc8
> [ =A0210.943246] =A0[<ffffffff81997ed4>] io_schedule_timeout+0x98/0xe=
9
> [ =A0210.950271] =A0[<ffffffff81102e41>] balance_dirty_pages_ratelimi=
ted_nr+0x4d2/0x686
> [ =A0210.959399] =A0[<ffffffff810f9354>] generic_file_buffered_write+=
0x1c9/0x22d
> [ =A0210.967400] =A0[<ffffffff810782c2>] ? current_fs_time+0x27/0x2e
> [ =A0210.974295] =A0[<ffffffff810fadbd>] __generic_file_aio_write+0x3=
2e/0x35e
> [ =A0210.981993] =A0[<ffffffff810fae53>] generic_file_aio_write+0x66/=
0xc1
> [ =A0210.989370] =A0[<ffffffff811deb83>] ext4_file_write+0x1f6/0x24f
> [ =A0210.996212] =A0[<ffffffff8103bebe>] ? native_sched_clock+0x2d/0x=
5f
> [ =A0211.003399] =A0[<ffffffff8117729a>] ? fsnotify+0x216/0x26f
> [ =A0211.009805] =A0[<ffffffff81096611>] ? local_clock+0x41/0x5a
> [ =A0211.016310] =A0[<ffffffff81144e86>] do_sync_write+0xcb/0x108
> [ =A0211.022918] =A0[<ffffffff81145550>] vfs_write+0xb8/0x157
> [ =A0211.029125] =A0[<ffffffff81145807>] sys_write+0x4d/0x77
> [ =A0211.035228] =A0[<ffffffff819a1802>] system_call_fastpath+0x16/0x=
1b
> [ =A0211.042370] ---[ end trace a682372b42c1df33 ]---
> [ =A0443.558240] BUG: unable to handle kernel NULL pointer dereferenc=
e at 0000000000000028
> [ =A0443.567910] IP: [<ffffffff811f2e62>] perf_trace_ext4_mb_release_=
group_pa+0x81/0xd6
> [ =A0443.577206] PGD 80e790067 PUD 8133be067 PMD 0
> [ =A0443.582895] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
> [ =A0443.588602] CPU 11
> [ =A0443.590821] Modules linked in:
> [ =A0443.595323]
> [ =A0443.597439] Pid: 4252, comm: flush-8:16 Tainted: G =A0 =A0 =A0 =A0=
W =A0 3.1.0+ #299 Intel Corporation SandyBridge Platform/To be filled b=
y O.E.M.
> [ =A0443.612154] RIP: 0010:[<ffffffff811f2e62>] =A0[<ffffffff811f2e62=
>] perf_trace_ext4_mb_release_group_pa+0x81/0xd6
> [ =A0443.624266] RSP: 0018:ffff88041eb695d0 =A0EFLAGS: 00010282
> [ =A0443.630679] RAX: ffffe8fffc407380 RBX: ffff880815c061f8 RCX: fff=
f88041d9e4500
> [ =A0443.639117] RDX: 0000000000000000 RSI: 0000000000000282 RDI: fff=
fe8fffc407380
> [ =A0443.647564] RBP: ffff88041eb696b0 R08: ffff88041eb695f0 R09: 000=
0000000000000
> [ =A0443.656006] R10: ffffe8fffc006ea0 R11: ffffffff8120745f R12: fff=
fffff81f07698
> [ =A0443.664382] R13: ffff88041eb69760 R14: ffff88081f709750 R15: fff=
f88080a1a29d8
> [ =A0443.672828] FS: =A00000000000000000(0000) GS:ffff88082b400000(00=
00) knlGS:0000000000000000
> [ =A0443.682722] CS: =A00010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ =A0443.689600] CR2: 0000000000000028 CR3: 00000008133bf000 CR4: 000=
00000000406e0
> [ =A0443.697984] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000=
0000000000000
> [ =A0443.706430] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 000=
0000000000400
> [ =A0443.714820] Process flush-8:16 (pid: 4252, threadinfo ffff88041e=
b68000, task ffff88041d9e45e0)
> [ =A0443.725298] Stack:
> [ =A0443.728009] =A00000000000000000 0000000000000004 ffff88041eb6966=
0 ffff88041eb695f0
> [ =A0443.737474] =A00000000000000000 0000000000000000 000000000000000=
0 0000000000000000
> [ =A0443.746928] =A0ffff88041eb69700 0000000000000000 000000000000000=
0 0000000000000000
> [ =A0443.756380] Call Trace:
> [ =A0443.759585] =A0[<ffffffff81204abe>] ? ext4_mb_release_group_pa+0=
x40/0xfe
> [ =A0443.767347] =A0[<ffffffff81204abe>] ext4_mb_release_group_pa+0x4=
0/0xfe
> [ =A0443.774916] =A0[<ffffffff8120749f>] ext4_mb_discard_group_preall=
ocations+0x355/0x3eb
> [ =A0443.784233] =A0[<ffffffff8120a3a5>] ext4_mb_new_blocks+0x2de/0x3=
f4
> [ =A0443.791414] =A0[<ffffffff812021c8>] ext4_ext_map_blocks+0xf63/0x=
1331
> [ =A0443.798796] =A0[<ffffffff811e2810>] ? ext4_map_blocks+0xf5/0x1fa
> [ =A0443.805782] =A0[<ffffffff811e2841>] ext4_map_blocks+0x126/0x1fa
> [ =A0443.812671] =A0[<ffffffff811e5d56>] mpage_da_map_and_submit+0xec=
/0x3b2
> [ =A0443.820241] =A0[<ffffffff811e6742>] ext4_da_writepages+0x316/0x4=
b0
> [ =A0443.827429] =A0[<ffffffff810a3359>] ? lock_release_non_nested+0x=
22c/0x293
> [ =A0443.835299] =A0[<ffffffff81103272>] do_writepages+0x24/0x2d
> [ =A0443.851241] =A0[<ffffffff811675c9>] writeback_single_inode+0x135=
/0x2c3
> [ =A0443.858809] =A0[<ffffffff81167e23>] writeback_sb_inodes+0x182/0x=
22c
> [ =A0443.866078] =A0[<ffffffff81168371>] __writeback_inodes_wb+0x78/0=
xb9
> [ =A0443.873355] =A0[<ffffffff8116851f>] wb_writeback+0x16d/0x276
> [ =A0443.879951] =A0[<ffffffff8116897b>] wb_do_writeback+0x1c8/0x1e3
> [ =A0443.886831] =A0[<ffffffff810812e0>] ? del_timer+0xc8/0xc8
> [ =A0443.893136] =A0[<ffffffff81168a22>] bdi_writeback_thread+0x8c/0x=
215
> [ =A0443.900413] =A0[<ffffffff81168996>] ? wb_do_writeback+0x1e3/0x1e=
3
> [ =A0443.907490] =A0[<ffffffff81090930>] kthread+0x8e/0x96
> [ =A0443.913355] =A0[<ffffffff819a3a04>] kernel_thread_helper+0x4/0x1=
0
> [ =A0443.920403] =A0[<ffffffff8199ae74>] ? retint_restore_args+0x13/0=
x13
> [ =A0443.927626] =A0[<ffffffff810908a2>] ? __init_kthread_worker+0x5b=
/0x5b
> [ =A0443.935099] =A0[<ffffffff819a3a00>] ? gs_change+0x13/0x13
> [ =A0443.941388] Code: 89 c2 4c 89 85 38 ff ff ff 48 8d 4d ec 41 0f b=
7 74 24 48 e8 3a d6 7a 00 4c 8b 85 38 ff ff ff 48 85 c0 74 50 48 8b 93 =
a0 00 00 00
> [ =A0443.960015] =A08b 52 28 8b 52 10 89 50 0c 48 8b 93 80 00 00 00 4=
8 89 50 10
> [ =A0443.970522] RIP =A0[<ffffffff811f2e62>] perf_trace_ext4_mb_relea=
se_group_pa+0x81/0xd6
> [ =A0443.980029] =A0RSP <ffff88041eb695d0>
> [ =A0443.984374] CR2: 0000000000000028
> [ =A0443.988542] BUG: unable to handle kernel
> [ =A0443.988745] ---[ end trace a682372b42c1df34 ]---
> [ =A0443.999169] NULL pointer dereference at 0000000000000028
> [ =A0444.005637] IP: [<ffffffff811f2e62>] perf_trace_ext4_mb_release_=
group_pa+0x81/0xd6
> [ =A0444.014987] PGD 810faa067 PUD 8110f6067 PMD 0
> [ =A0444.020575] Oops: 0000 [#2] SMP DEBUG_PAGEALLOC
> [ =A0444.026317] CPU 1
> [ =A0444.028441] Modules linked in:
> [ =A0444.032997]
> [ =A0444.035107] Pid: 5480, comm: dd Tainted: G =A0 =A0 =A0D W =A0 3.=
1.0+ #299 Intel Corporation SandyBridge Platform/To be filled by O.E.M.
> [ =A0444.049013] RIP: 0010:[<ffffffff811f2e62>] =A0[<ffffffff811f2e62=
>] perf_trace_ext4_mb_release_group_pa+0x81/0xd6
> [ =A0444.061108] RSP: 0018:ffff880809f252e8 =A0EFLAGS: 00010282
> [ =A0444.067494] RAX: ffffe8fbfd007380 RBX: ffff880811f6f458 RCX: fff=
f880809862200
> [ =A0444.075922] RDX: 0000000000000000 RSI: 0000000000000282 RDI: fff=
fe8fbfd007380
> [ =A0444.084349] RBP: ffff880809f253c8 R08: ffff880809f25308 R09: 000=
0000000000000
> [ =A0444.092776] R10: ffffe8fffd206ea0 R11: ffffffff8120745f R12: fff=
fffff81f07698
> [ =A0444.101194] R13: ffff880809f25478 R14: ffff88081f709750 R15: fff=
f880811f42930
> [ =A0444.109607] FS: =A000007f2265a23700(0000) GS:ffff88042c000000(00=
00) knlGS:0000000000000000
> [ =A0444.119477] CS: =A00010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ =A0444.126350] CR2: 0000000000000028 CR3: 00000008110d3000 CR4: 000=
00000000406e0
> [ =A0444.134777] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000=
0000000000000
> [ =A0444.143205] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 000=
0000000000400
> [ =A0444.151633] Process dd (pid: 5480, threadinfo ffff880809f24000, =
task ffff8808098622f0)
> [ =A0444.161311] Stack:
> [ =A0444.164001] =A0ffff880809f25358 0000000000000000 ffff88081d13a65=
0 ffff880809f25308
> [ =A0444.173422] =A00000000000000000 0000000000000000 000000000000000=
0 0000000000000000
> [ =A0444.178355] =A0ffff880809f25418 0000000000000000 000000000000000=
0 0000000000000000
> [ =A0444.178358] Call Trace:
> [ =A0444.178364] =A0[<ffffffff81204abe>] ? ext4_mb_release_group_pa+0=
x40/0xfe
> [ =A0444.178367] =A0[<ffffffff81204abe>] ext4_mb_release_group_pa+0x4=
0/0xfe
> [ =A0444.178370] =A0[<ffffffff8120749f>] ext4_mb_discard_group_preall=
ocations+0x355/0x3eb
> [ =A0444.178374] =A0[<ffffffff8120a3a5>] ext4_mb_new_blocks+0x2de/0x3=
f4
> [ =A0444.178378] =A0[<ffffffff812021c8>] ext4_ext_map_blocks+0xf63/0x=
1331
> [ =A0444.178382] =A0[<ffffffff811e2810>] ? ext4_map_blocks+0xf5/0x1fa
> [ =A0444.178385] =A0[<ffffffff811e2841>] ext4_map_blocks+0x126/0x1fa
> [ =A0444.178388] =A0[<ffffffff811e5d56>] mpage_da_map_and_submit+0xec=
/0x3b2
> [ =A0444.178391] =A0[<ffffffff811e6742>] ext4_da_writepages+0x316/0x4=
b0
> [ =A0444.178396] =A0[<ffffffff81103272>] do_writepages+0x24/0x2d
> [ =A0444.178400] =A0[<ffffffff811675c9>] writeback_single_inode+0x135=
/0x2c3
> [ =A0444.178403] =A0[<ffffffff81167e23>] writeback_sb_inodes+0x182/0x=
22c
> [ =A0444.178406] =A0[<ffffffff81168371>] __writeback_inodes_wb+0x78/0=
xb9
> [ =A0444.178409] =A0[<ffffffff81168799>] writeback_inodes_wb+0x62/0x7=
c
> [ =A0444.178412] =A0[<ffffffff81102d4b>] balance_dirty_pages_ratelimi=
ted_nr+0x3dc/0x686
> [ =A0444.178417] =A0[<ffffffff810f9354>] generic_file_buffered_write+=
0x1c9/0x22d
> [ =A0444.178421] =A0[<ffffffff810782c2>] ? current_fs_time+0x27/0x2e
> [ =A0444.178424] =A0[<ffffffff810fadbd>] __generic_file_aio_write+0x3=
2e/0x35e
> [ =A0444.178428] =A0[<ffffffff810fae53>] generic_file_aio_write+0x66/=
0xc1
> [ =A0444.178431] =A0[<ffffffff811deb83>] ext4_file_write+0x1f6/0x24f
> [ =A0444.178435] =A0[<ffffffff8103bebe>] ? native_sched_clock+0x2d/0x=
5f
> [ =A0444.178439] =A0[<ffffffff8117729a>] ? fsnotify+0x216/0x26f
> [ =A0444.178443] =A0[<ffffffff81096611>] ? local_clock+0x41/0x5a
> [ =A0444.178448] =A0[<ffffffff81144e86>] do_sync_write+0xcb/0x108
> [ =A0444.178451] =A0[<ffffffff81145550>] vfs_write+0xb8/0x157
> [ =A0444.178453] =A0[<ffffffff81145807>] sys_write+0x4d/0x77
> [ =A0444.178456] =A0[<ffffffff819a1802>] system_call_fastpath+0x16/0x=
1b
> [ =A0444.178458] Code: 89 c2 4c 89 85 38 ff ff ff 48 8d 4d ec 41 0f b=
7 74 24 48 e8 3a d6 7a 00 4c 8b 85 38 ff ff ff 48 85 c0 74 50 48 8b 93 =
a0 00 00 00
> [ =A0444.178471] =A08b 52 28 8b 52 10 89 50 0c 48 8b 93 80 00 00 00 4=
8 89 50 10
> [ =A0444.178477] RIP =A0[<ffffffff811f2e62>] perf_trace_ext4_mb_relea=
se_group_pa+0x81/0xd6
> [ =A0444.178481] =A0RSP <ffff880809f252e8>
> [ =A0444.178482] CR2: 0000000000000028
> [ =A0444.178933] ---[ end trace a682372b42c1df35 ]---
> [ =A0444.178940] ------------[ cut here ]------------
> [ =A0444.178944] WARNING: at /c/wfg/linux/kernel/exit.c:900 do_exit+0=
x67/0x771()
> [ =A0444.178949] Hardware name: SandyBridge Platform
> [ =A0444.178956] Modules linked in:
> [ =A0444.178962] Pid: 5480, comm: dd Tainted: G =A0 =A0 =A0D W =A0 3.=
1.0+ #299
> [ =A0444.178966] Call Trace:
> [ =A0444.178972] =A0[<ffffffff810734ec>] warn_slowpath_common+0x85/0x=
9d
> [ =A0444.178979] =A0[<ffffffff81074c7a>] ? kmsg_dump+0x8a/0x10c
> [ =A0444.178983] =A0[<ffffffff8107351e>] warn_slowpath_null+0x1a/0x1c
> [ =A0444.178990] =A0[<ffffffff81076bab>] do_exit+0x67/0x771
> [ =A0444.178996] =A0[<ffffffff81074ceb>] ? kmsg_dump+0xfb/0x10c
> [ =A0444.179001] =A0[<ffffffff81074c7a>] ? kmsg_dump+0x8a/0x10c
> [ =A0444.179013] =A0[<ffffffff8199bd4c>] oops_end+0xbe/0xc6
> [ =A0444.179022] =A0[<ffffffff81055e86>] no_context+0x1f9/0x208
> [ =A0444.179029] =A0[<ffffffff8105605e>] __bad_area_nosemaphore+0x1c9=
/0x1e9
> [ =A0444.179035] =A0[<ffffffff810560dd>] bad_area+0x4a/0x51
> [ =A0444.179041] =A0[<ffffffff8199dece>] do_page_fault+0x27e/0x431
> [ =A0444.179049] =A0[<ffffffff810f810c>] ? perf_output_copy+0x71/0x71
> [ =A0444.179055] =A0[<ffffffff810f5d7f>] ? perf_swevent_overflow+0x90=
/0xaa
> [ =A0444.179072] =A0[<ffffffff813e985d>] ? trace_hardirqs_off_thunk+0=
x3a/0x3c
> [ =A0444.179162] =A0[<ffffffff8120745f>] ? ext4_mb_discard_group_prea=
llocations+0x315/0x3eb
> [ =A0444.179174] =A0[<ffffffff8199b085>] page_fault+0x25/0x30
> [ =A0444.179178] =A0[<ffffffff8120745f>] ? ext4_mb_discard_group_prea=
llocations+0x315/0x3eb
> [ =A0444.179222] =A0[<ffffffff811f2e62>] ? perf_trace_ext4_mb_release=
_group_pa+0x81/0xd6
> [ =A0444.179248] =A0[<ffffffff811f2e4f>] ? perf_trace_ext4_mb_release=
_group_pa+0x6e/0xd6
> [ =A0444.179261] =A0[<ffffffff81204abe>] ? ext4_mb_release_group_pa+0=
x40/0xfe
> [ =A0444.179271] =A0[<ffffffff81204abe>] ext4_mb_release_group_pa+0x4=
0/0xfe
> [ =A0444.179276] =A0[<ffffffff8120749f>] ext4_mb_discard_group_preall=
ocations+0x355/0x3eb
> [ =A0444.179282] =A0[<ffffffff8120a3a5>] ext4_mb_new_blocks+0x2de/0x3=
f4
> [ =A0444.179288] =A0[<ffffffff812021c8>] ext4_ext_map_blocks+0xf63/0x=
1331
> [ =A0444.179295] =A0[<ffffffff811e2810>] ? ext4_map_blocks+0xf5/0x1fa
> [ =A0444.179300] =A0[<ffffffff811e2841>] ext4_map_blocks+0x126/0x1fa
> [ =A0444.179306] =A0[<ffffffff811e5d56>] mpage_da_map_and_submit+0xec=
/0x3b2
> [ =A0444.179311] =A0[<ffffffff811e6742>] ext4_da_writepages+0x316/0x4=
b0
> [ =A0444.179317] =A0[<ffffffff81103272>] do_writepages+0x24/0x2d
> [ =A0444.179477] =A0[<ffffffff811675c9>] writeback_single_inode+0x135=
/0x2c3
> [ =A0444.179505] =A0[<ffffffff81167e23>] writeback_sb_inodes+0x182/0x=
22c
> [ =A0444.179515] =A0[<ffffffff81168371>] __writeback_inodes_wb+0x78/0=
xb9
> [ =A0444.179521] =A0[<ffffffff81168799>] writeback_inodes_wb+0x62/0x7=
c
> [ =A0444.179526] =A0[<ffffffff81102d4b>] balance_dirty_pages_ratelimi=
ted_nr+0x3dc/0x686
> [ =A0444.179532] =A0[<ffffffff810f9354>] generic_file_buffered_write+=
0x1c9/0x22d
> [ =A0444.179535] =A0[<ffffffff810782c2>] ? current_fs_time+0x27/0x2e
> [ =A0444.179541] =A0[<ffffffff810fadbd>] __generic_file_aio_write+0x3=
2e/0x35e
> [ =A0444.179549] =A0[<ffffffff810fae53>] generic_file_aio_write+0x66/=
0xc1
> [ =A0444.179555] =A0[<ffffffff811deb83>] ext4_file_write+0x1f6/0x24f
> [ =A0444.179560] =A0[<ffffffff8103bebe>] ? native_sched_clock+0x2d/0x=
5f
> [ =A0444.179563] =A0[<ffffffff8117729a>] ? fsnotify+0x216/0x26f
> [ =A0444.179569] =A0[<ffffffff81096611>] ? local_clock+0x41/0x5a
> [ =A0444.179577] =A0[<ffffffff81144e86>] do_sync_write+0xcb/0x108
> [ =A0444.179581] =A0[<ffffffff81145550>] vfs_write+0xb8/0x157
> [ =A0444.179586] =A0[<ffffffff81145807>] sys_write+0x4d/0x77
> [ =A0444.179593] =A0[<ffffffff819a1802>] system_call_fastpath+0x16/0x=
1b
> [ =A0444.179597] ---[ end trace a682372b42c1df36 ]---
> [ =A0444.179888] dd used greatest stack depth: 2088 bytes left
> [ =A0504.787849] INFO: rcu_sched_state detected stall on CPU 14 (t=3D=
60000 jiffies)
> [ =A0504.787854] INFO: rcu_sched_state detected stall on CPU 27 (t=3D=
60000 jiffies)
> [ =A0539.837210] BUG: spinlock lockup on CPU#14, dd/4796, ffff8808110=
3c180
> [ =A0539.845293] Pid: 4796, comm: dd Tainted: G =A0 =A0 =A0D W =A0 3.=
1.0+ #299
> [ =A0539.852582] Call Trace:
> [ =A0539.855792] =A0[<ffffffff813edf90>] do_raw_spin_lock+0x10c/0x137
> [ =A0539.862796] =A0[<ffffffff8199a25b>] _raw_spin_lock+0x56/0x69
> [ =A0539.869412] =A0[<ffffffff81208578>] ? ext4_mb_find_by_goal+0xdb/=
0x1ce
> [ =A0539.876900] =A0[<ffffffff81208578>] ext4_mb_find_by_goal+0xdb/0x=
1ce
> [ =A0539.883455] BUG: spinlock lockup on CPU#27, dd/5336, ffff8808110=
3c080
> [ =A0539.883458] Pid: 5336, comm: dd Tainted: G =A0 =A0 =A0D W =A0 3.=
1.0+ #299
> [ =A0539.883459] Call Trace:
> [ =A0539.883464] =A0[<ffffffff813edf90>] do_raw_spin_lock+0x10c/0x137
> [ =A0539.883467] =A0[<ffffffff8199a25b>] _raw_spin_lock+0x56/0x69
> [ =A0539.883471] =A0[<ffffffff81208578>] ? ext4_mb_find_by_goal+0xdb/=
0x1ce
> [ =A0539.883474] =A0[<ffffffff81208578>] ext4_mb_find_by_goal+0xdb/0x=
1ce
> [ =A0539.883477] =A0[<ffffffff81205856>] ? ext4_mb_normalize_request+=
0x2f4/0x480
> [ =A0539.883480] =A0[<ffffffff81208c6f>] ext4_mb_regular_allocator+0x=
59/0x312
> [ =A0539.883484] =A0[<ffffffff8120a25e>] ext4_mb_new_blocks+0x197/0x3=
f4
> [ =A0539.883487] =A0[<ffffffff811ff836>] ? ext4_ext_find_extent+0x130=
/0x2fb
> [ =A0539.883490] =A0[<ffffffff8199ac03>] ? _raw_spin_unlock+0x2b/0x2f
> [ =A0539.883493] =A0[<ffffffff812021c8>] ext4_ext_map_blocks+0xf63/0x=
1331
> [ =A0539.883499] =A0[<ffffffff811e2810>] ? ext4_map_blocks+0xf5/0x1fa
> [ =A0539.883502] =A0[<ffffffff811e2841>] ext4_map_blocks+0x126/0x1fa
> [ =A0539.883504] =A0[<ffffffff811e5d56>] mpage_da_map_and_submit+0xec=
/0x3b2
> [ =A0539.883507] =A0[<ffffffff811e6742>] ext4_da_writepages+0x316/0x4=
b0
> [ =A0539.883513] =A0[<ffffffff81103272>] do_writepages+0x24/0x2d
> [ =A0539.883520] =A0[<ffffffff811675c9>] writeback_single_inode+0x135=
/0x2c3
> [ =A0539.883523] =A0[<ffffffff81167e23>] writeback_sb_inodes+0x182/0x=
22c
> [ =A0539.883526] =A0[<ffffffff81168371>] __writeback_inodes_wb+0x78/0=
xb9
> [ =A0539.883528] =A0[<ffffffff81168799>] writeback_inodes_wb+0x62/0x7=
c
> [ =A0539.883532] =A0[<ffffffff81102d4b>] balance_dirty_pages_ratelimi=
ted_nr+0x3dc/0x686
> [ =A0539.883534] =A0[<ffffffff8116809e>] ? __mark_inode_dirty+0x2e/0x=
1cf
> [ =A0539.883539] =A0[<ffffffff810f9354>] generic_file_buffered_write+=
0x1c9/0x22d
> [ =A0539.883545] =A0[<ffffffff810782c2>] ? current_fs_time+0x27/0x2e
> [ =A0539.883548] =A0[<ffffffff810fadbd>] __generic_file_aio_write+0x3=
2e/0x35e
> [ =A0539.883552] =A0[<ffffffff810fae53>] generic_file_aio_write+0x66/=
0xc1
> [ =A0539.883555] =A0[<ffffffff811deb83>] ext4_file_write+0x1f6/0x24f
> [ =A0539.883559] =A0[<ffffffff8117729a>] ? fsnotify+0x216/0x26f
> [ =A0539.883565] =A0[<ffffffff81144e86>] do_sync_write+0xcb/0x108
> [ =A0539.883567] =A0[<ffffffff81145550>] vfs_write+0xb8/0x157
> [ =A0539.883570] =A0[<ffffffff81145807>] sys_write+0x4d/0x77
> [ =A0539.883574] =A0[<ffffffff819a1802>] system_call_fastpath+0x16/0x=
1b
> [ =A0540.125746] =A0[<ffffffff81205856>] ? ext4_mb_normalize_request+=
0x2f4/0x480
> [ =A0540.133817] =A0[<ffffffff81208c6f>] ext4_mb_regular_allocator+0x=
59/0x312
> [ =A0540.133820] =A0[<ffffffff8120a25e>] ext4_mb_new_blocks+0x197/0x3=
f4
> [ =A0540.133823] =A0[<ffffffff811ff836>] ? ext4_ext_find_extent+0x130=
/0x2fb
> [ =A0540.133829] =A0[<ffffffff8199ac03>] ? _raw_spin_unlock+0x2b/0x2f
> [ =A0540.133831] =A0[<ffffffff812021c8>] ext4_ext_map_blocks+0xf63/0x=
1331
> [ =A0540.133838] =A0[<ffffffff811e2810>] ? ext4_map_blocks+0xf5/0x1fa
> [ =A0540.133840] =A0[<ffffffff811e2841>] ext4_map_blocks+0x126/0x1fa
> [ =A0540.133843] =A0[<ffffffff811e5d56>] mpage_da_map_and_submit+0xec=
/0x3b2
> [ =A0540.133845] =A0[<ffffffff811e6742>] ext4_da_writepages+0x316/0x4=
b0
> [ =A0540.133854] =A0[<ffffffff81103272>] do_writepages+0x24/0x2d
> [ =A0540.133861] =A0[<ffffffff811675c9>] writeback_single_inode+0x135=
/0x2c3
> [ =A0540.133863] =A0[<ffffffff81167e23>] writeback_sb_inodes+0x182/0x=
22c
> [ =A0540.133866] =A0[<ffffffff81168371>] __writeback_inodes_wb+0x78/0=
xb9
> [ =A0540.133869] =A0[<ffffffff81168799>] writeback_inodes_wb+0x62/0x7=
c
> [ =A0540.133872] =A0[<ffffffff81102d4b>] balance_dirty_pages_ratelimi=
ted_nr+0x3dc/0x686
> [ =A0540.133875] =A0[<ffffffff8116809e>] ? __mark_inode_dirty+0x2e/0x=
1cf
> [ =A0540.133880] =A0[<ffffffff810f9354>] generic_file_buffered_write+=
0x1c9/0x22d
> [ =A0540.133886] =A0[<ffffffff810782c2>] ? current_fs_time+0x27/0x2e
> [ =A0540.133889] =A0[<ffffffff810fadbd>] __generic_file_aio_write+0x3=
2e/0x35e
> [ =A0540.133892] =A0[<ffffffff810fae53>] generic_file_aio_write+0x66/=
0xc1
> [ =A0540.133896] =A0[<ffffffff811deb83>] ext4_file_write+0x1f6/0x24f
> [ =A0540.133900] =A0[<ffffffff8117729a>] ? fsnotify+0x216/0x26f
> [ =A0540.133905] =A0[<ffffffff81144e86>] do_sync_write+0xcb/0x108
> [ =A0540.133908] =A0[<ffffffff81145550>] vfs_write+0xb8/0x157
> [ =A0540.133910] =A0[<ffffffff81145807>] sys_write+0x4d/0x77
> [ =A0540.133914] =A0[<ffffffff819a1802>] system_call_fastpath+0x16/0x=
1b
> [ =A0684.729866] INFO: rcu_sched_state detected stall on CPU 27 (t=3D=
240030 jiffies)
> [ =A0684.730858] INFO: rcu_sched_state detected stall on CPU 14 (t=3D=
240030 jiffies)
> [ =A0864.673871] INFO: rcu_sched_state detected stall on CPU 27 (t=3D=
420061 jiffies)
> [ =A0864.673877] INFO: rcu_sched_state detected stall on CPU 14 (t=3D=
420061 jiffies)
> [ 1044.615889] INFO: rcu_sched_state detected stall on CPU 27 (t=3D60=
0092 jiffies)
> [ 1044.616884] INFO: rcu_sched_state detected stall on CPU 14 (t=3D60=
0092 jiffies)
> [ 1224.558902] INFO: rcu_sched_state detected stall on CPU 27 (t=3D78=
0123 jiffies)
> [ 1224.559899] INFO: rcu_sched_state detected stall on CPU 14 (t=3D78=
0123 jiffies)
> [ 1404.501917] INFO: rcu_sched_state detected stall on CPU 14 (t=3D96=
0154 jiffies)
> [ 1404.501922] INFO: rcu_sched_state detected stall on CPU 27 (t=3D96=
0154 jiffies)
> [ 1584.443929] INFO: rcu_sched_state detected stall on CPU 27 (t=3D11=
40184 jiffies)
> [ 1584.443935] INFO: rcu_sched_state detected stall on CPU 14 (t=3D11=
40184 jiffies)
> [ 1764.386941] INFO: rcu_sched_state detected stall on CPU 14 (t=3D13=
20214 jiffies)
> [ 1764.386944] INFO: rcu_sched_state detected stall on CPU 27 (t=3D13=
20215 jiffies)
> [ 1944.328956] INFO: rcu_sched_state detected stall on CPU 14 (t=3D15=
00245 jiffies)
> [ 1944.328960] INFO: rcu_sched_state detected stall on CPU 27 (t=3D15=
00245 jiffies)
> [ 2124.270971] INFO: rcu_sched_state detected stall on CPU 14 (t=3D16=
80275 jiffies)
> [ 2124.270976] INFO: rcu_sched_state detected stall on CPU 27 (t=3D16=
80275 jiffies)
> [ 2304.212984] INFO: rcu_sched_state detected stall on CPU 14 (t=3D18=
60305 jiffies)
> [ 2304.213983] INFO: rcu_sched_state detected stall on CPU 27 (t=3D18=
60306 jiffies)
> [ 2484.155998] INFO: rcu_sched_state detected stall on CPU 27 (t=3D20=
40336 jiffies)
> [ 2484.156998] INFO: rcu_sched_state detected stall on CPU 14 (t=3D20=
40337 jiffies)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
