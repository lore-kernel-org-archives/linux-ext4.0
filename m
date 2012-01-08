From: Wu Fengguang <wfg@linux.intel.com>
Subject: Re: 3.2.0-rc5 NULL dereference BUG
Date: Sun, 8 Jan 2012 22:06:41 +0800
Message-ID: <20120108140641.GA5170@localhost>
References: <20111218055359.GA17182@localhost>
 <20111218063054.GA4979@localhost>
 <CAGBYx2bxdnkXcZF+A1iOvnsW=xdtDJR7Fx3Rz-HWeWH5n0ByKg@mail.gmail.com>
 <20111218113237.GA1359@localhost>
 <20120105015609.GA7913@localhost>
 <CAGBYx2ZyiKrbsQmiC3YxB7sKjhEQVeznUM2cGrXMyQuXPZ5o1Q@mail.gmail.com>
 <20120105023424.GA12242@localhost>
 <CAGBYx2ZuL3j-T5nPermw3GZz4AWf-FsWcdj1+CT10TLAZBdUqw@mail.gmail.com>
 <20120105024312.GA13069@localhost>
 <CAGBYx2bP-ES0eg6KdfJFAfd4cNw61RDhWz=vHE-mTKFCVWwMHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:24889 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875Ab2AHOGr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 8 Jan 2012 09:06:47 -0500
Content-Disposition: inline
In-Reply-To: <CAGBYx2bP-ES0eg6KdfJFAfd4cNw61RDhWz=vHE-mTKFCVWwMHQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 05, 2012 at 10:45:09AM +0800, Yongqiang Yang wrote:
> On Thu, Jan 5, 2012 at 10:43 AM, Wu Fengguang <fengguang.wu@intel.com=
> wrote:
> > On Thu, Jan 05, 2012 at 10:37:15AM +0800, Yongqiang Yang wrote:
> >> On Thu, Jan 5, 2012 at 10:34 AM, Wu Fengguang <fengguang.wu@intel.=
com> wrote:
> >> > Yongqiang,
> >> >
> >> > I noticed that Linus's master does not contain your initial fix
> >> >
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0ext4: do not reference pa_inode from =
group_pa
> >> >
> >> > Is that *replaced* by the patches you mentioned below?
> >> nope. =C2=A0 They are different stories. =C2=A0=C2=A0[ext4: do not=
 reference pa_inode
> >> from group_pa] is merged into Ted's tree and has not been pushed t=
o
> >> Linus. =C2=A0You can have a loot at Ted's tree
> >> http://git.kernel.org/?p=3Dlinux/kernel/git/tytso/ext4.git;a=3Dsum=
mary
> >>
> >> [ext4: do not reference pa_inode from group_pa] is merged after th=
e
> >> following patches.
> >
> > Thanks for the explanation. Is it planned to be pushed before the 3=
=2E2
> > release?
> I am not sure.  I am guessing it will be pushed before 3.2 release:-)=
=2E

This bug appears again in 3.2. I'd recommend to send the patch to
-stable once it hits 3.3-rcX.

Thanks,
=46engguang

[  613.505459] BUG: unable to handle kernel NULL pointer dereference at=
 0000000000000028
[  613.506004] IP: [<ffffffff81208933>] perf_trace_ext4_mb_release_grou=
p_pa+0x81/0xd6
[  613.506004] PGD 203e2e067 PUD 203e2d067 PMD 0
[  613.506004] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[  613.506004] CPU 1
[  613.506004] Modules linked in:
[  613.506004]
[  613.506004] Pid: 4112, comm: flush-8:80 Not tainted 3.2.0 #313 Super=
micro X7DW3/X7DWN
[  613.506004] RIP: 0010:[<ffffffff81208933>]  [<ffffffff81208933>] per=
f_trace_ext4_mb_release_group_pa+0x81/0xd6
[  613.506004] RSP: 0018:ffff880211981590  EFLAGS: 00010286
[  613.506004] RAX: ffffe8ffff0091e8 RBX: ffff8801c5517e70 RCX: ffff880=
211954500
[  613.506004] RDX: 0000000000000000 RSI: 0000000000000286 RDI: ffffe8f=
fff0091e8
[  613.506004] RBP: ffff880211981670 R08: ffff8802119815b0 R09: 0000000=
000000000
[  613.506004] R10: ffffe8fffee087b0 R11: ffffffff8121fba3 R12: fffffff=
f81f62ff8
[  613.506004] R13: ffff880211981720 R14: ffff8802080ece50 R15: ffff880=
211981740
[  613.506004] FS:  0000000000000000(0000) GS:ffff880226000000(0000) kn=
lGS:0000000000000000
[  613.506004] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  613.506004] CR2: 0000000000000028 CR3: 00000001efa02000 CR4: 0000000=
0000006e0
[  613.506004] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
[  613.506004] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000=
000000400
[  613.506004] Process flush-8:80 (pid: 4112, threadinfo ffff8802119800=
00, task ffff880211954520)
[  613.506004] Stack:
[  613.506004]  0000000000000000 0000000000000003 ffff880211981620 ffff=
8802119815b0
[  613.506004]  0000000000000000 0000000000000000 0000000000000000 0000=
000000000000
[  613.506004]  ffff8802119816c0 0000000000000000 0000000000000000 0000=
000000000000
[  613.506004] Call Trace:
[  613.506004]  [<ffffffff8121d110>] ? ext4_mb_release_group_pa+0x40/0x=
fe
[  613.506004]  [<ffffffff8121d110>] ext4_mb_release_group_pa+0x40/0xfe
[  613.506004]  [<ffffffff8121fbe3>] ext4_mb_discard_group_preallocatio=
ns+0x355/0x3eb
[  613.506004]  [<ffffffff81222b32>] ext4_mb_new_blocks+0x2fd/0x422
[  613.506004]  [<ffffffff8121a495>] ext4_ext_map_blocks+0x146f/0x1969
[  613.506004]  [<ffffffff810a3339>] ? local_clock+0x41/0x5a
[  613.506004]  [<ffffffff810aec1b>] ? __lock_acquire+0x564/0x932
[  613.506004]  [<ffffffff810aec1b>] ? __lock_acquire+0x564/0x932
[  613.506004]  [<ffffffff811f601b>] ? ext4_map_blocks+0x103/0x221
[  613.506004]  [<ffffffff811f604c>] ext4_map_blocks+0x134/0x221
[  613.506004]  [<ffffffff811f9857>] mpage_da_map_and_submit+0xef/0x404
[  613.506004]  [<ffffffff811fa2cc>] ext4_da_writepages+0x350/0x505
[  613.506004]  [<ffffffff8103c24b>] ? sched_clock+0x9/0xd
[  613.506004]  [<ffffffff810ae168>] ? lock_release_holdtime+0xa3/0xac
[  613.506004]  [<ffffffff811137b4>] do_writepages+0x24/0x2d
[  613.506004]  [<ffffffff811786a5>] writeback_single_inode+0x126/0x2b4
[  613.506004]  [<ffffffff81178f03>] writeback_sb_inodes+0x17f/0x229
[  613.506004]  [<ffffffff81179657>] wb_writeback+0x130/0x23a
[  613.506004]  [<ffffffff81179982>] wb_do_writeback+0x8f/0x1b7
[  613.506004]  [<ffffffff81179b5d>] ? bdi_writeback_thread+0xb3/0x215
[  613.506004]  [<ffffffff81179b36>] bdi_writeback_thread+0x8c/0x215
[  613.506004]  [<ffffffff81179aaa>] ? wb_do_writeback+0x1b7/0x1b7
[  613.506004]  [<ffffffff8109db30>] kthread+0x8e/0x96
[  613.506004]  [<ffffffff819ec584>] kernel_thread_helper+0x4/0x10
[  613.506004]  [<ffffffff819e3974>] ? retint_restore_args+0x13/0x13
[  613.506004]  [<ffffffff8109daa2>] ? __init_kthread_worker+0x5b/0x5b
[  613.506004]  [<ffffffff819ec580>] ? gs_change+0x13/0x13
[  613.506004] Code: 89 c2 4c 89 85 38 ff ff ff 48 8d 4d ec 41 0f b7 74=
 24 48 e8 ed 06 7e 00 4c 8b 85 38 ff ff ff 48 85 c0 74 50 48 8b 93 a0 0=
0 00 00 <48> 8b 52 28 8b 52 10 89 50 0c 48 8b 93 80 00 00 00 48 89 50 1=
0
[  613.506004] RIP  [<ffffffff81208933>] perf_trace_ext4_mb_release_gro=
up_pa+0x81/0xd6
[  613.876032]  RSP <ffff880211981590>
[  613.876032] CR2: 0000000000000028
[  613.882620] ---[ end trace af3c59e20d0fb446 ]---
[  613.882624] ------------[ cut here ]------------
[  613.882630] WARNING: at /c/wfg/linux/kernel/exit.c:898 do_exit+0x67/=
0x76e()
[  613.882632] Hardware name: X7DW3
[  613.882633] Modules linked in:
[  613.882636] Pid: 4112, comm: flush-8:80 Tainted: G      D      3.2.0=
 #313
[  613.882638] Call Trace:
[  613.882643]  [<ffffffff8107dca4>] warn_slowpath_common+0x85/0x9d
[  613.882646]  [<ffffffff8107f42e>] ? kmsg_dump+0x8a/0x10c
[  613.882649]  [<ffffffff8107dcd6>] warn_slowpath_null+0x1a/0x1c
[  613.882651]  [<ffffffff81081417>] do_exit+0x67/0x76e
[  613.882653]  [<ffffffff8107f49f>] ? kmsg_dump+0xfb/0x10c
[  613.882656]  [<ffffffff8107f42e>] ? kmsg_dump+0x8a/0x10c
[  613.882660]  [<ffffffff819e4629>] oops_end+0xbe/0xc6
[  613.882664]  [<ffffffff81056e15>] no_context+0x184/0x193
[  613.882667]  [<ffffffff81056fed>] __bad_area_nosemaphore+0x1c9/0x1e9
[  613.882670]  [<ffffffff8103c24b>] ? sched_clock+0x9/0xd
[  613.882674]  [<ffffffff810a315b>] ? sched_clock_local+0x12/0x75
[  613.882677]  [<ffffffff81057020>] bad_area_nosemaphore+0x13/0x15
[  613.882679]  [<ffffffff819e69e7>] do_page_fault+0x213/0x431
[  613.882684]  [<ffffffff811084fc>] ? perf_output_begin+0x1c2/0x1f5
[  613.882686]  [<ffffffff8103c1fb>] ? native_sched_clock+0x29/0x70
[  613.882688]  [<ffffffff8103c24b>] ? sched_clock+0x9/0xd
[  613.882693]  [<ffffffff8140a92d>] ? trace_hardirqs_off_thunk+0x3a/0x=
3c
[  613.882696]  [<ffffffff8121fba3>] ? ext4_mb_discard_group_preallocat=
ions+0x315/0x3eb
[  613.882699]  [<ffffffff819e3b85>] page_fault+0x25/0x30
[  613.882702]  [<ffffffff8121fba3>] ? ext4_mb_discard_group_preallocat=
ions+0x315/0x3eb
[  613.882705]  [<ffffffff81208933>] ? perf_trace_ext4_mb_release_group=
_pa+0x81/0xd6
[  613.882708]  [<ffffffff8121d110>] ? ext4_mb_release_group_pa+0x40/0x=
fe
[  613.882710]  [<ffffffff8121d110>] ext4_mb_release_group_pa+0x40/0xfe
[  613.882712]  [<ffffffff8121fbe3>] ext4_mb_discard_group_preallocatio=
ns+0x355/0x3eb
[  613.882716]  [<ffffffff81222b32>] ext4_mb_new_blocks+0x2fd/0x422
[  613.882719]  [<ffffffff8121a495>] ext4_ext_map_blocks+0x146f/0x1969
[  613.882721]  [<ffffffff810a3339>] ? local_clock+0x41/0x5a
[  613.882725]  [<ffffffff810aec1b>] ? __lock_acquire+0x564/0x932
[  613.882728]  [<ffffffff810aec1b>] ? __lock_acquire+0x564/0x932
[  613.882731]  [<ffffffff811f601b>] ? ext4_map_blocks+0x103/0x221
[  613.882733]  [<ffffffff811f604c>] ext4_map_blocks+0x134/0x221
[  613.882736]  [<ffffffff811f9857>] mpage_da_map_and_submit+0xef/0x404
[  613.882739]  [<ffffffff811fa2cc>] ext4_da_writepages+0x350/0x505
[  613.882741]  [<ffffffff8103c24b>] ? sched_clock+0x9/0xd
[  613.882744]  [<ffffffff810ae168>] ? lock_release_holdtime+0xa3/0xac
[  613.882747]  [<ffffffff811137b4>] do_writepages+0x24/0x2d
[  613.882751]  [<ffffffff811786a5>] writeback_single_inode+0x126/0x2b4
[  613.882753]  [<ffffffff81178f03>] writeback_sb_inodes+0x17f/0x229
[  613.882756]  [<ffffffff81179657>] wb_writeback+0x130/0x23a
[  613.882759]  [<ffffffff81179982>] wb_do_writeback+0x8f/0x1b7
[  613.882761]  [<ffffffff81179b5d>] ? bdi_writeback_thread+0xb3/0x215
[  613.882764]  [<ffffffff81179b36>] bdi_writeback_thread+0x8c/0x215
[  613.882767]  [<ffffffff81179aaa>] ? wb_do_writeback+0x1b7/0x1b7
[  613.882769]  [<ffffffff8109db30>] kthread+0x8e/0x96
[  613.882773]  [<ffffffff819ec584>] kernel_thread_helper+0x4/0x10
[  613.882776]  [<ffffffff819e3974>] ? retint_restore_args+0x13/0x13
[  613.882779]  [<ffffffff8109daa2>] ? __init_kthread_worker+0x5b/0x5b
[  613.882782]  [<ffffffff819ec580>] ? gs_change+0x13/0x13
[  613.882783] ---[ end trace af3c59e20d0fb447 ]---
[  613.882796] flush-8:80 used greatest stack depth: 2352 bytes left
[  614.468204] BUG: unable to handle kernel NULL pointer dereference at=
 0000000000000028
[  614.469003] IP: [<ffffffff81208933>] perf_trace_ext4_mb_release_grou=
p_pa+0x81/0xd6
[  614.469003] PGD 211942067 PUD 21be9d067 PMD 0
[  614.469003] Oops: 0000 [#2] SMP DEBUG_PAGEALLOC
[  614.469003] CPU 3
[  614.469003] Modules linked in:
[  614.469003]
[  614.469003] Pid: 4117, comm: flush-8:160 Tainted: G      D W    3.2.=
0 #313 Supermicro X7DW3/X7DWN
[  614.469003] RIP: 0010:[<ffffffff81208933>]  [<ffffffff81208933>] per=
f_trace_ext4_mb_release_group_pa+0x81/0xd6
[  614.469003] RSP: 0018:ffff880211a17590  EFLAGS: 00010286
[  614.469003] RAX: ffffe8ffff4091e8 RBX: ffff8801c55179d8 RCX: ffff880=
2119b2200
[  614.469003] RDX: 0000000000000000 RSI: 0000000000000286 RDI: ffffe8f=
fff4091e8
[  614.469003] RBP: ffff880211a17670 R08: ffff880211a175b0 R09: 0000000=
000000000
[  614.469003] R10: ffffe8fffee08ff8 R11: ffffffff8121fba3 R12: fffffff=
f81f62ff8
[  614.469003] R13: ffff880211a17720 R14: ffff8802080ece50 R15: ffff880=
1c5478000
[  614.560062] FS:  0000000000000000(0000) GS:ffff880226400000(0000) kn=
lGS:0000000000000000
[  614.560062] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  614.560062] CR2: 0000000000000028 CR3: 0000000211945000 CR4: 0000000=
0000006e0
[  614.560062] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
[  614.560062] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000=
000000400
[  614.560062] Process flush-8:160 (pid: 4117, threadinfo ffff880211a16=
000, task ffff8802119b2290)
[  614.610013] Stack:
[  614.610013]  ffff880218a5a020 0000000000000000 ffff8801f88d9858 ffff=
880211a175b0
[  614.610013]  0000000000000000 0000000000000000 0000000000000000 0000=
000000000000
[  614.610013]  ffff880211a176c0 0000000000000000 0000000000000000 0000=
000000000000
[  614.610013] Call Trace:
[  614.610013]  [<ffffffff8121d110>] ? ext4_mb_release_group_pa+0x40/0x=
fe
[  614.610013]  [<ffffffff8121d110>] ext4_mb_release_group_pa+0x40/0xfe
[  614.610013]  [<ffffffff8121fbe3>] ext4_mb_discard_group_preallocatio=
ns+0x355/0x3eb
[  614.610013]  [<ffffffff81222b32>] ext4_mb_new_blocks+0x2fd/0x422
[  614.610013]  [<ffffffff8121a495>] ext4_ext_map_blocks+0x146f/0x1969
[  614.610013]  [<ffffffff81404010>] ? radix_tree_gang_lookup_tag_slot+=
0x81/0xa2
[  614.610013]  [<ffffffff811f5f5f>] ? ext4_map_blocks+0x47/0x221
[  614.610013]  [<ffffffff811f601b>] ? ext4_map_blocks+0x103/0x221
[  614.610013]  [<ffffffff811f604c>] ext4_map_blocks+0x134/0x221
[  614.610013]  [<ffffffff811f9857>] mpage_da_map_and_submit+0xef/0x404
[  614.610013]  [<ffffffff811fa2cc>] ext4_da_writepages+0x350/0x505
[  614.610013]  [<ffffffff811137b4>] do_writepages+0x24/0x2d
[  614.610013]  [<ffffffff811786a5>] writeback_single_inode+0x126/0x2b4
[  614.610013]  [<ffffffff81178f03>] writeback_sb_inodes+0x17f/0x229
[  614.610013]  [<ffffffff81179657>] wb_writeback+0x130/0x23a
[  614.610013]  [<ffffffff81179982>] wb_do_writeback+0x8f/0x1b7
[  614.610013]  [<ffffffff81179b5d>] ? bdi_writeback_thread+0xb3/0x215
[  614.610013]  [<ffffffff81179b36>] bdi_writeback_thread+0x8c/0x215
[  614.610013]  [<ffffffff81179aaa>] ? wb_do_writeback+0x1b7/0x1b7
[  614.610013]  [<ffffffff8109db30>] kthread+0x8e/0x96
[  614.610013]  [<ffffffff819ec584>] kernel_thread_helper+0x4/0x10
[  614.610013]  [<ffffffff819e3974>] ? retint_restore_args+0x13/0x13
[  614.610013]  [<ffffffff8109daa2>] ? __init_kthread_worker+0x5b/0x5b
[  614.610013]  [<ffffffff819ec580>] ? gs_change+0x13/0x13
[  614.610013] Code: 89 c2 4c 89 85 38 ff ff ff 48 8d 4d ec 41 0f b7 74=
 24 48 e8 ed 06 7e 00 4c 8b 85 38 ff ff ff 48 85 c0 74 50 48 8b 93 a0 0=
0 00 00 <48> 8b 52 28 8b 52 10 89 50 0c 48 8b 93 80 00 00 00 48 89 50 1=
0
[  614.610013] RIP  [<ffffffff81208933>] perf_trace_ext4_mb_release_gro=
up_pa+0x81/0xd6
[  614.610013]  RSP <ffff880211a17590>
[  614.610013] CR2: 0000000000000028
[  614.615263] ---[ end trace af3c59e20d0fb448 ]---
[  614.615266] ------------[ cut here ]------------
[  614.615271] WARNING: at /c/wfg/linux/kernel/exit.c:898 do_exit+0x67/=
0x76e()
[  614.615272] Hardware name: X7DW3
[  614.615273] Modules linked in:
[  614.615276] Pid: 4117, comm: flush-8:160 Tainted: G      D W    3.2.=
0 #313
[  614.615278] Call Trace:
[  614.615282]  [<ffffffff8107dca4>] warn_slowpath_common+0x85/0x9d
[  614.615285]  [<ffffffff8107f42e>] ? kmsg_dump+0x8a/0x10c
[  614.615287]  [<ffffffff8107dcd6>] warn_slowpath_null+0x1a/0x1c
[  614.615289]  [<ffffffff81081417>] do_exit+0x67/0x76e
[  614.615292]  [<ffffffff8107f49f>] ? kmsg_dump+0xfb/0x10c
[  614.615294]  [<ffffffff8107f42e>] ? kmsg_dump+0x8a/0x10c
[  614.615298]  [<ffffffff819e4629>] oops_end+0xbe/0xc6
[  614.615302]  [<ffffffff81056e15>] no_context+0x184/0x193
[  614.615305]  [<ffffffff81056fed>] __bad_area_nosemaphore+0x1c9/0x1e9
[  614.615307]  [<ffffffff81057020>] bad_area_nosemaphore+0x13/0x15
[  614.615310]  [<ffffffff819e69e7>] do_page_fault+0x213/0x431
[  614.615314]  [<ffffffff8110833a>] ? perf_output_copy+0x74/0x74
[  614.615318]  [<ffffffff8140a92d>] ? trace_hardirqs_off_thunk+0x3a/0x=
3c
[  614.615321]  [<ffffffff8121fba3>] ? ext4_mb_discard_group_preallocat=
ions+0x315/0x3eb
[  614.615323]  [<ffffffff819e3b85>] page_fault+0x25/0x30
[  614.615326]  [<ffffffff8121fba3>] ? ext4_mb_discard_group_preallocat=
ions+0x315/0x3eb
[  614.615328]  [<ffffffff81208933>] ? perf_trace_ext4_mb_release_group=
_pa+0x81/0xd6
[  614.615331]  [<ffffffff8121d110>] ? ext4_mb_release_group_pa+0x40/0x=
fe
[  614.615333]  [<ffffffff8121d110>] ext4_mb_release_group_pa+0x40/0xfe
[  614.615336]  [<ffffffff8121fbe3>] ext4_mb_discard_group_preallocatio=
ns+0x355/0x3eb
[  614.615339]  [<ffffffff81222b32>] ext4_mb_new_blocks+0x2fd/0x422
[  614.615342]  [<ffffffff8121a495>] ext4_ext_map_blocks+0x146f/0x1969
[  614.615346]  [<ffffffff81404010>] ? radix_tree_gang_lookup_tag_slot+=
0x81/0xa2
[  614.615348]  [<ffffffff811f5f5f>] ? ext4_map_blocks+0x47/0x221
[  614.615350]  [<ffffffff811f601b>] ? ext4_map_blocks+0x103/0x221
[  614.615353]  [<ffffffff811f604c>] ext4_map_blocks+0x134/0x221
[  614.615355]  [<ffffffff811f9857>] mpage_da_map_and_submit+0xef/0x404
[  614.615358]  [<ffffffff811fa2cc>] ext4_da_writepages+0x350/0x505
[  614.615361]  [<ffffffff811137b4>] do_writepages+0x24/0x2d
[  614.615364]  [<ffffffff811786a5>] writeback_single_inode+0x126/0x2b4
[  614.615366]  [<ffffffff81178f03>] writeback_sb_inodes+0x17f/0x229
[  614.615369]  [<ffffffff81179657>] wb_writeback+0x130/0x23a
[  614.615372]  [<ffffffff81179982>] wb_do_writeback+0x8f/0x1b7
[  614.615374]  [<ffffffff81179b5d>] ? bdi_writeback_thread+0xb3/0x215
[  614.615377]  [<ffffffff81179b36>] bdi_writeback_thread+0x8c/0x215
[  614.615379]  [<ffffffff81179aaa>] ? wb_do_writeback+0x1b7/0x1b7
[  614.615382]  [<ffffffff8109db30>] kthread+0x8e/0x96
[  614.615385]  [<ffffffff819ec584>] kernel_thread_helper+0x4/0x10
[  614.615388]  [<ffffffff819e3974>] ? retint_restore_args+0x13/0x13
[  614.615391]  [<ffffffff8109daa2>] ? __init_kthread_worker+0x5b/0x5b
[  614.615393]  [<ffffffff819ec580>] ? gs_change+0x13/0x13
[  614.615395] ---[ end trace af3c59e20d0fb449 ]---
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
