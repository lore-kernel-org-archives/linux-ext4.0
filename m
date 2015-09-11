From: Andrey Konovalov <andreyknvl@google.com>
Subject: Out-of-bounds in crc16 (ext4_group_desc_csum)
Date: Fri, 11 Sep 2015 15:17:17 +0200
Message-ID: <CAAeHK+wtN+tQYekxs6EXoAksnSG8KmjRWCSM8sHXvXP4s_WorQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Dmitry Vyukov <dvyukov@google.com>,
	Alexander Potapenko <glider@google.com>,
	Kostya Serebryany <kcc@google.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi!

While fuzzing the kernel (b8889c4fc6) with KASAN and Trinity I got the
following report:
(There are many similar reports after this one with accessed addressed
being increased)

==================================================================
BUG: KASan: out of bounds access in crc16+0x24/0x60 at addr ffff880034b1c078
Read of size 1 by task kworker/u2:1/13
=============================================================================
BUG kernfs_node_cache (Tainted: G        W      ): kasan: bad access detected
-----------------------------------------------------------------------------

Disabling lock debugging due to kernel taint
INFO: Allocated in __kernfs_new_node+0x4c/0x120 age=965348 cpu=0 pid=1
[<      none      >] __slab_alloc+0x44a/0x480 mm/slub.c:2402
[<     inline     >] slab_alloc mm/slub.c:2470
[<      none      >] kmem_cache_alloc+0x10d/0x140 mm/slub.c:2517
[<      none      >] __kernfs_new_node+0x4c/0x120 dir.c:0
[<      none      >] kernfs_new_node+0x4a/0x80 ??:0
[<      none      >] __kernfs_create_file+0x27/0xe0 ??:0
[<      none      >] sysfs_add_file_mode_ns+0xfa/0x230 ??:0
[<      none      >] internal_create_group+0x172/0x400 group.c:0
[<      none      >] sysfs_create_group+0xe/0x10 ??:0
[<      none      >] sysfs_slab_add+0x165/0x1d0 mm/slub.c:5290
[<      none      >] __kmem_cache_create+0x42b/0x720 mm/slub.c:3869
[<     inline     >] do_kmem_cache_create mm/slab_common.c:342
[<      none      >] kmem_cache_create+0x11d/0x210 mm/slab_common.c:421
[<      none      >] mb_cache_create+0x20d/0x350 fs/mbcache.c:357
[<      none      >] ext4_xattr_create_cache+0xe/0x10 ??:0
[<      none      >] ext4_fill_super+0x30ab/0x54e0 fs/ext4/super.c:4097
[<      none      >] mount_bdev+0x1c8/0x210 ??:0
[<      none      >] ext4_mount+0x10/0x20 fs/ext4/super.c:5521
INFO: Slab 0xffffea0000d2c700 objects=9 used=9 fp=0x          (null)
flags=0x100000000000080
INFO: Object 0xffff880034b1c000 @offset=0 fp=0x0000000000000003

Object ffff880034b1c000: 03 00 00 00 00 00 00 00 e0 16 b1 34 00 88 ff
ff  ...........4....
Object ffff880034b1c010: c3 99 fc 81 ff ff ff ff b1 d8 b1 34 00 88 ff
ff  ...........4....
Object ffff880034b1c020: 18 f0 b1 34 00 88 ff ff 00 00 00 00 00 00 00
00  ...4............
Object ffff880034b1c030: 00 00 00 00 00 00 00 00 fc 64 25 55 00 00 00
00  .........d%U....
Object ffff880034b1c040: 00 05 e2 81 ff ff ff ff 00 00 00 00 00 00 00
00  ................
Object ffff880034b1c050: 00 10 00 00 00 00 00 00 00 00 00 00 00 00 00
00  ................
Object ffff880034b1c060: 40 8a 25 82 ff ff ff ff 52 00 00 81 27 30 00
00  @.%.....R...'0..
Object ffff880034b1c070: 00 00 00 00 00 00 00 00
   ........
Redzone ffff880034b1c078: cc cc cc cc cc cc cc cc
    ........
Padding ffff880034b1c1b0: 00 00 00 00 00 00 00 00
    ........
CPU: 0 PID: 13 Comm: kworker/u2:1 Tainted: G    B   W       4.2.0-kasan #7
Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2007
Workqueue: writeback wb_workfn (flush-8:0)
 ffff880034b18400 ffff8800363e7480 ffffffff814a293c ffff88003613c900
 ffff8800363e74b0 ffffffff81209758 ffff88003613c900 ffffea0000d2c700
 ffff880034b1c000 0000000000003bed ffff8800363e74d8 ffffffff8120e5b1
Call Trace:
 [<ffffffff814a293c>] dump_stack+0x44/0x58 lib/dump_stack.c:15
 [<ffffffff81209758>] print_trailer+0xf8/0x150 mm/slub.c:650
 [<ffffffff8120e5b1>] object_err+0x31/0x40 mm/slub.c:657
 [<ffffffff812108f5>] kasan_report_error+0x1e5/0x3f0 ??:0
 [<ffffffff810e793b>] ? vprintk_emit+0x3eb/0x500 kernel/printk/printk.c:1820
 [<ffffffff81210ee4>] kasan_report+0x34/0x40 ??:0
 [<ffffffff814cd544>] ? crc16+0x24/0x60 ??:0
 [<ffffffff8120f7fb>] __asan_load1+0x4b/0x70 ??:0
 [<ffffffff814cd544>] crc16+0x24/0x60 ??:0
 [<ffffffff812f0d39>] ext4_group_desc_csum+0x259/0x2b0 fs/ext4/super.c:2069
 [<ffffffff8107bbf5>] ? warn_slowpath_null+0x15/0x20 kernel/panic.c:480
 [<ffffffff81303fa8>] ext4_group_desc_csum_set+0x68/0x90 fs/ext4/super.c:2093
 [<ffffffff8132848f>] ext4_mb_mark_diskspace_used+0x33f/0x790
fs/ext4/mballoc.c:2963
 [<ffffffff8132a90f>] ext4_mb_new_blocks+0x52f/0x910 fs/ext4/mballoc.c:4499
 [<ffffffff81311363>] ? ext4_ext_search_right+0x103/0x460 fs/ext4/extents.c:1538
 [<ffffffff8131a7c7>] ext4_ext_map_blocks+0xfc7/0x1490 fs/ext4/extents.c:4462
 [<ffffffff812c0001>] ? kernfs_fop_open+0x491/0x530 file.c:0
 [<ffffffff812d1198>] ext4_map_blocks+0x1e8/0x7b0 fs/ext4/inode.c:593
 [<ffffffff8131d954>] ? __ext4_journal_start_sb+0x84/0x120 ??:0
 [<     inline     >] mpage_map_one_extent fs/ext4/inode.c:2110
 [<     inline     >] mpage_map_and_submit_extent fs/ext4/inode.c:2166
 [<ffffffff812d61e6>] ext4_writepages+0x876/0x1280 fs/ext4/inode.c:2509
 [<ffffffff81498f68>] ? cfq_prio_tree_add+0x178/0x180 block/cfq-iosched.c:2224
 [<ffffffff811b39e6>] do_writepages+0x46/0x70 mm/page-writeback.c:2332
 [<ffffffff81256575>] __writeback_single_inode+0x65/0x400 fs/fs-writeback.c:1259
 [<     inline     >] ? list_empty include/linux/list.h:189
 [<     inline     >] ? waitqueue_active include/linux/wait.h:107
 [<ffffffff810d2a51>] ? __wake_up_bit+0x31/0x60 kernel/sched/wait.c:459
 [<ffffffff81256c18>] writeback_sb_inodes+0x308/0x5c0 fs/fs-writeback.c:1518
 [<ffffffff8125717a>] wb_writeback+0x19a/0x390 fs/fs-writeback.c:1667
 [<     inline     >] wb_do_writeback fs/fs-writeback.c:1804
 [<ffffffff81257bf0>] wb_workfn+0x1b0/0x610 fs/fs-writeback.c:1855
 [<ffffffff810af5cf>] ? finish_task_switch+0x7f/0x230
include/linux/compiler.h:218
 [<ffffffff8109c546>] process_one_work+0x276/0x630 kernel/workqueue.c:2030
 [<ffffffff8109d328>] worker_thread+0x98/0x720 kernel/workqueue.c:2162
 [<ffffffff8109d290>] ? rescuer_thread+0x510/0x510 kernel/workqueue.c:2317
 [<ffffffff810a496f>] kthread+0x10f/0x130 kthread.c:0
 [<ffffffff810a4860>] ? kthread_park+0x70/0x70 ??:0
 [<ffffffff81d48e1f>] ret_from_fork+0x3f/0x70 arch/x86/entry/entry_64.S:472
 [<ffffffff810a4860>] ? kthread_park+0x70/0x70 ??:0
Memory state around the buggy address:
 ffff880034b1bf00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff880034b1bf80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff880034b1c000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 fc
                                                                ^
 ffff880034b1c080: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff880034b1c100: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================

Thanks!
