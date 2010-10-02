From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 19502] New: 'losetup -c' on a mounted loopN device with ext[34]
 causes soft lockup
Date: Sat, 2 Oct 2010 10:33:01 GMT
Message-ID: <bug-19502-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:33800 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754315Ab0JBKdC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Oct 2010 06:33:02 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id o92AX1AC009019
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 2 Oct 2010 10:33:01 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=19502

           Summary: 'losetup -c' on a mounted loopN device with ext[34]
                    causes soft lockup
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.35.6, 2.6.35.7
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext3
        AssignedTo: fs_ext3@kernel-bugs.osdl.org
        ReportedBy: sliedes@cc.hut.fi
        Regression: No


(This log is from qemu, but I have reproduced this on real x86-64 hardware too)

*** Steps to reproduce ***

1. mkdir test
2. mount none test -t tmpfs
3. cd test
4. dd if=/dev/zero bs=1M count=128 >img
5. mkfs.ext3 img # OR ext4
6. mount img /media/ -o loop
7. cp ../.bashrc /media/
7b. OPTIONAL (here not done): dd if=/dev/zero bs=1M count=128 >>img
8. losetup -c /dev/loop0

*** Expected result ***

System remains functional, with the ext3 filesystem still functional on
/dev/loop0.

*** Actual result ***

After a few seconds, a soft lockup happens; after 60 seconds, a backtrace is
dumped.

*** Comments***

Doing losetup -c made sense to me with step 7b, since it seemed the way to
extend the device in preparation for running resize2fs /dev/loop0. So if I for
example wanted to extend the filesystem from 128 MiB to 256 MiB, I'd run step
7b and then losetup -c /dev/loop0. I see this as analogous to extending lvm
logical volumes (which seems to work with ext3 and ext4). After this I would
run resize2fs /dev/loop0 to resize the filesystem.

This lockup happens with both ext3 and ext4, and whether the image file is on
tmpfs or on an ext3 filesystem. As said, it also happens whether the image file
was extended or not.

*** Backtrace for ext3 ***

BUG: soft lockup - CPU#0 stuck for 61s! [kjournald:1098]
irq event stamp: 68314
hardirqs last  enabled at (68313): [<ffffffff815ce3ce>] restore_args+0x0/0x30
hardirqs last disabled at (68314): [<ffffffff810022f8>] save_args+0x68/0x70
softirqs last  enabled at (68310): [<ffffffff81037477>] __do_softirq+0xe7/0x130
softirqs last disabled at (68305): [<ffffffff810031da>] call_softirq+0x1a/0x30
CPU 0 
Pid: 1098, comm: kjournald Not tainted 2.6.35.7 #1 /Bochs
RIP: 0010:[<ffffffff81081812>]  [<ffffffff81081812>] find_lock_page+0x62/0x80
RSP: 0000:ffff88003e52dc38  EFLAGS: 00000246
RAX: ffffea0000d9a870 RBX: ffff88003e52dc80 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 000000000000013d RDI: ffffffff817a90ec
RBP: ffffffff81002e0e R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: ffff88003f8746d8 R12: ffff88003f424e78
R13: 0000000000003043 R14: 0000000000000000 R15: 0000000000000246
FS:  0000000000000000(0000) GS:ffffffff81a1c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000009c51008 CR3: 000000003eb53000 CR4: 00000000000006b0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kjournald (pid: 1098, threadinfo ffff88003e52c000, task
ffff88003f874000)
Stack:
 ffffffff81081dca 0000000000000010 0000005000000246 ffffea0000d9a870
<0> 0000000000000000 0000000000000400 ffff88003f424b00 ffff88003f424c90
<0> 000000000000c10c ffff88003e52dce0 ffffffff810d753e ffff88003e52dcb0
Call Trace:
 [<ffffffff81081dca>] ? find_or_create_page+0x3a/0xb0
 [<ffffffff810d753e>] ? __getblk+0xee/0x2f0
 [<ffffffff811ad325>] ? journal_get_descriptor_buffer+0x45/0xb0
 [<ffffffff811a82fe>] ? journal_commit_transaction+0x109e/0x17a0
 [<ffffffff815ce15b>] ? _raw_spin_unlock_irqrestore+0x3b/0x70
 [<ffffffff8105b87d>] ? trace_hardirqs_on_caller+0x13d/0x180
 [<ffffffff811ac5a9>] ? kjournald+0x109/0x3e0
 [<ffffffff81049a50>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff811ac4a0>] ? kjournald+0x0/0x3e0
 [<ffffffff8104964e>] ? kthread+0x9e/0xb0
 [<ffffffff8105b87d>] ? trace_hardirqs_on_caller+0x13d/0x180
 [<ffffffff810030e4>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff815ce3ce>] ? restore_args+0x0/0x30
 [<ffffffff810495b0>] ? kthread+0x0/0xb0
 [<ffffffff810030e0>] ? kernel_thread_helper+0x0/0x10
Code: ec 90 7a 81 e8 f0 7e fa ff 41 0f ba 6d 00 00 19 c0 85 c0 75 17 49 3b 5d
18 75 1b 4c 89 e8 48 8b 5d e8 4c 8b 65 f0 4c 8b 6d f8 c9 <c3> 4c 89 ef e8 e5 e6
ff ff eb df 4c 89 ef e8 2b e8 ff ff 4c 89 
Call Trace:
 [<ffffffff81081dca>] ? find_or_create_page+0x3a/0xb0
 [<ffffffff810d753e>] ? __getblk+0xee/0x2f0
 [<ffffffff811ad325>] ? journal_get_descriptor_buffer+0x45/0xb0
 [<ffffffff811a82fe>] ? journal_commit_transaction+0x109e/0x17a0
 [<ffffffff815ce15b>] ? _raw_spin_unlock_irqrestore+0x3b/0x70
 [<ffffffff8105b87d>] ? trace_hardirqs_on_caller+0x13d/0x180
 [<ffffffff811ac5a9>] ? kjournald+0x109/0x3e0
 [<ffffffff81049a50>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff811ac4a0>] ? kjournald+0x0/0x3e0
 [<ffffffff8104964e>] ? kthread+0x9e/0xb0
 [<ffffffff8105b87d>] ? trace_hardirqs_on_caller+0x13d/0x180
 [<ffffffff810030e4>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff815ce3ce>] ? restore_args+0x0/0x30
 [<ffffffff810495b0>] ? kthread+0x0/0xb0
 [<ffffffff810030e0>] ? kernel_thread_helper+0x0/0x10

*** Backtrace for ext4 ***

BUG: soft lockup - CPU#0 stuck for 61s! [flush-7:0:954]
irq event stamp: 112246
hardirqs last  enabled at (112245): [<ffffffff815b614e>] restore_args+0x0/0x30
hardirqs last disabled at (112246): [<ffffffff810022f8>] save_args+0x68/0x70
softirqs last  enabled at (112244): [<ffffffff81037477>]
__do_softirq+0xe7/0x130
softirqs last disabled at (112231): [<ffffffff810031da>] call_softirq+0x1a/0x30
CPU 0 
Pid: 954, comm: flush-7:0 Not tainted 2.6.35.6 #2 /Bochs
RIP: 0010:[<ffffffff8105d5a5>]  [<ffffffff8105d5a5>] lock_acquire+0x75/0x90
RSP: 0000:ffff88003e4434d0  EFLAGS: 00000246
RAX: 0000000000000001 RBX: ffff88003e443500 RCX: ffff88003fa9d0c8
RDX: ffff88003fa9d798 RSI: ffff88003fa9d7b8 RDI: 0000000000000246
RBP: ffffffff81002e0e R08: 0000000000000036 R09: 0000000000000000
R10: 0000000000000001 R11: ffff88003fa9d7a0 R12: 0000000000000036
R13: 0000000000000000 R14: 0000000000000001 R15: ffff88003fa9d7a0
FS:  0000000000000000(0000) GS:ffffffff81a1c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000f775a368 CR3: 000000003ead1000 CR4: 00000000000006b0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process flush-7:0 (pid: 954, threadinfo ffff88003e442000, task
ffff88003fa9d000)
Stack:
 0000000000000000 ffffffff8107fd60 ffffffff00000000 ffffea0000df44c0
<0> 0000000000000040 ffff88003f424e78 ffff88003e443540 ffffffff8107fda4
<0> ffffffff8107fd60 ffffffff810d6ef1 0000000000000103 ffff88003f424e70
Call Trace:
 [<ffffffff8107fd60>] ? find_get_page+0x0/0xc0
 [<ffffffff8107fda4>] ? find_get_page+0x44/0xc0
 [<ffffffff8107fd60>] ? find_get_page+0x0/0xc0
 [<ffffffff810d6ef1>] ? __find_get_block_slow+0x41/0x110
 [<ffffffff810817d5>] ? find_lock_page+0x25/0x80
 [<ffffffff81081dca>] ? find_or_create_page+0x3a/0xb0
 [<ffffffff810d753e>] ? __getblk+0xee/0x2f0
 [<ffffffff8119a7a2>] ? ext4_mb_init_cache+0x122/0xa30
 [<ffffffff8108027f>] ? add_to_page_cache_locked+0xbf/0x100
 [<ffffffff8119b18f>] ? ext4_mb_init_group+0xdf/0x2b0
 [<ffffffff8119b42c>] ? ext4_mb_good_group+0xcc/0x110
 [<ffffffff8119e611>] ? ext4_mb_regular_allocator+0x191/0x3e0
 [<ffffffff81198026>] ? ext4_mb_use_preallocated+0xf6/0x2c0
 [<ffffffff81197f60>] ? ext4_mb_use_preallocated+0x30/0x2c0
 [<ffffffff8105b8cd>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff8119eb3b>] ? ext4_mb_new_blocks+0x2db/0x3f0
 [<ffffffff81191d84>] ? ext4_ext_find_extent+0x2c4/0x320
 [<ffffffff8119453b>] ? ext4_ext_map_blocks+0x4bb/0x1aa0
 [<ffffffff8105b87d>] ? trace_hardirqs_on_caller+0x13d/0x180
 [<ffffffff8117d78b>] ? ext4_map_blocks+0xab/0x200
 [<ffffffff8117d7c1>] ? ext4_map_blocks+0xe1/0x200
 [<ffffffff8117eb27>] ? mpage_da_map_blocks+0xc7/0x420
 [<ffffffff8118ace0>] ? ext4_journal_start_sb+0xf0/0x120
 [<ffffffff8117f668>] ? ext4_da_writepages+0x2b8/0x560
 [<ffffffff810d122b>] ? writeback_inodes_wb+0xdb/0x1a0
 [<ffffffff8108821f>] ? do_writepages+0x1f/0x40
 [<ffffffff810d0024>] ? writeback_single_inode+0xe4/0x3d0
 [<ffffffff810d0809>] ? writeback_sb_inodes+0x199/0x2a0
 [<ffffffff810d11bb>] ? writeback_inodes_wb+0x6b/0x1a0
 [<ffffffff8102ad60>] ? T.944+0x0/0xd0
 [<ffffffff810d151b>] ? wb_writeback+0x22b/0x290
 [<ffffffff810d16ee>] ? wb_do_writeback+0x16e/0x180
 [<ffffffff810d174b>] ? bdi_writeback_task+0x4b/0x140
 [<ffffffff81093350>] ? bdi_start_fn+0x0/0xf0
 [<ffffffff810933d0>] ? bdi_start_fn+0x80/0xf0
 [<ffffffff81093350>] ? bdi_start_fn+0x0/0xf0
 [<ffffffff8104964e>] ? kthread+0x9e/0xb0
 [<ffffffff8105b87d>] ? trace_hardirqs_on_caller+0x13d/0x180
 [<ffffffff810030e4>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff815b614e>] ? restore_args+0x0/0x30
 [<ffffffff810495b0>] ? kthread+0x0/0xb0
 [<ffffffff810030e0>] ? kernel_thread_helper+0x0/0x10
Code: 44 24 10 00 00 00 00 48 83 f0 01 4c 89 54 24 08 41 89 c1 41 83 e1 01 e8
ca e5 ff ff c7 83 d4 06 00 00 00 00 00 00 4c 89 e7 57 9d <0f> 1f 44 00 00 48 83
c4 20 5b 41 5c c9 c3 66 66 66 66 2e 0f 1f 
Call Trace:
 [<ffffffff8107fd60>] ? find_get_page+0x0/0xc0
 [<ffffffff8107fda4>] ? find_get_page+0x44/0xc0
 [<ffffffff8107fd60>] ? find_get_page+0x0/0xc0
 [<ffffffff810d6ef1>] ? __find_get_block_slow+0x41/0x110
 [<ffffffff810817d5>] ? find_lock_page+0x25/0x80
 [<ffffffff81081dca>] ? find_or_create_page+0x3a/0xb0
 [<ffffffff810d753e>] ? __getblk+0xee/0x2f0
 [<ffffffff8119a7a2>] ? ext4_mb_init_cache+0x122/0xa30
 [<ffffffff8108027f>] ? add_to_page_cache_locked+0xbf/0x100
 [<ffffffff8119b18f>] ? ext4_mb_init_group+0xdf/0x2b0
 [<ffffffff8119b42c>] ? ext4_mb_good_group+0xcc/0x110
 [<ffffffff8119e611>] ? ext4_mb_regular_allocator+0x191/0x3e0
 [<ffffffff81198026>] ? ext4_mb_use_preallocated+0xf6/0x2c0
 [<ffffffff81197f60>] ? ext4_mb_use_preallocated+0x30/0x2c0
 [<ffffffff8105b8cd>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff8119eb3b>] ? ext4_mb_new_blocks+0x2db/0x3f0
 [<ffffffff81191d84>] ? ext4_ext_find_extent+0x2c4/0x320
 [<ffffffff8119453b>] ? ext4_ext_map_blocks+0x4bb/0x1aa0
 [<ffffffff8105b87d>] ? trace_hardirqs_on_caller+0x13d/0x180
 [<ffffffff8117d78b>] ? ext4_map_blocks+0xab/0x200
 [<ffffffff8117d7c1>] ? ext4_map_blocks+0xe1/0x200
 [<ffffffff8117eb27>] ? mpage_da_map_blocks+0xc7/0x420
 [<ffffffff8118ace0>] ? ext4_journal_start_sb+0xf0/0x120
 [<ffffffff8117f668>] ? ext4_da_writepages+0x2b8/0x560
 [<ffffffff810d122b>] ? writeback_inodes_wb+0xdb/0x1a0
 [<ffffffff8108821f>] ? do_writepages+0x1f/0x40
 [<ffffffff810d0024>] ? writeback_single_inode+0xe4/0x3d0
 [<ffffffff810d0809>] ? writeback_sb_inodes+0x199/0x2a0
 [<ffffffff810d11bb>] ? writeback_inodes_wb+0x6b/0x1a0
 [<ffffffff8102ad60>] ? T.944+0x0/0xd0
 [<ffffffff810d151b>] ? wb_writeback+0x22b/0x290
 [<ffffffff810d16ee>] ? wb_do_writeback+0x16e/0x180
 [<ffffffff810d174b>] ? bdi_writeback_task+0x4b/0x140
 [<ffffffff81093350>] ? bdi_start_fn+0x0/0xf0
 [<ffffffff810933d0>] ? bdi_start_fn+0x80/0xf0
 [<ffffffff81093350>] ? bdi_start_fn+0x0/0xf0
 [<ffffffff8104964e>] ? kthread+0x9e/0xb0
 [<ffffffff8105b87d>] ? trace_hardirqs_on_caller+0x13d/0x180
 [<ffffffff810030e4>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff815b614e>] ? restore_args+0x0/0x30
 [<ffffffff810495b0>] ? kthread+0x0/0xb0
 [<ffffffff810030e0>] ? kernel_thread_helper+0x0/0x10
BUG: soft lockup - CPU#0 stuck for 61s! [flush-7:0:954]
irq event stamp: 218554
hardirqs last  enabled at (218553): [<ffffffff815b614e>] restore_args+0x0/0x30
hardirqs last disabled at (218554): [<ffffffff810022f8>] save_args+0x68/0x70
softirqs last  enabled at (218552): [<ffffffff81037477>]
__do_softirq+0xe7/0x130
softirqs last disabled at (218539): [<ffffffff810031da>] call_softirq+0x1a/0x30
CPU 0 
Pid: 954, comm: flush-7:0 Not tainted 2.6.35.6 #2 /Bochs
RIP: 0010:[<ffffffff8105d91e>]  [<ffffffff8105d91e>] lock_release+0x3e/0x1b0
RSP: 0000:ffff88003e4434c8  EFLAGS: 00000246
RAX: ffff88003f59c478 RBX: ffff88003e443500 RCX: 0000000000000000
RDX: ffffffff8107fdd2 RSI: 0000000000000001 RDI: ffffffff81a28c30
RBP: ffffffff81002e0e R08: 0000000000000036 R09: 0000000000000000
R10: 0000000000000001 R11: ffff88003fa9d7a0 R12: ffffffff815b5542
R13: ffff88003e443500 R14: ffff88003f424e78 R15: 0000000000000040
FS:  0000000000000000(0000) GS:ffffffff81a1c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000f775a368 CR3: 000000003ead1000 CR4: 00000000000006b0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process flush-7:0 (pid: 954, threadinfo ffff88003e442000, task
ffff88003fa9d000)
Stack:
 0000000000000246 0000000000000000 0000000000000040 ffff88003f424e78
<0> ffffea0000df44c0 ffff88003f424e70 0000000000000103 ffff88003e443540
<0> ffffffff8107fdea ffffffff8107fd60 ffffffff810d6ef1 0000000000000001
Call Trace:
 [<ffffffff8107fdea>] ? find_get_page+0x8a/0xc0
 [<ffffffff8107fd60>] ? find_get_page+0x0/0xc0
 [<ffffffff810d6ef1>] ? __find_get_block_slow+0x41/0x110
 [<ffffffff810817d5>] ? find_lock_page+0x25/0x80
 [<ffffffff81081dca>] ? find_or_create_page+0x3a/0xb0
 [<ffffffff810d753e>] ? __getblk+0xee/0x2f0
 [<ffffffff8119a7a2>] ? ext4_mb_init_cache+0x122/0xa30
 [<ffffffff8108027f>] ? add_to_page_cache_locked+0xbf/0x100
 [<ffffffff8119b18f>] ? ext4_mb_init_group+0xdf/0x2b0
 [<ffffffff8119b42c>] ? ext4_mb_good_group+0xcc/0x110
 [<ffffffff8119e611>] ? ext4_mb_regular_allocator+0x191/0x3e0
 [<ffffffff81198026>] ? ext4_mb_use_preallocated+0xf6/0x2c0
 [<ffffffff81197f60>] ? ext4_mb_use_preallocated+0x30/0x2c0
 [<ffffffff8105b8cd>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff8119eb3b>] ? ext4_mb_new_blocks+0x2db/0x3f0
 [<ffffffff81191d84>] ? ext4_ext_find_extent+0x2c4/0x320
 [<ffffffff8119453b>] ? ext4_ext_map_blocks+0x4bb/0x1aa0
 [<ffffffff8105b87d>] ? trace_hardirqs_on_caller+0x13d/0x180
 [<ffffffff8117d78b>] ? ext4_map_blocks+0xab/0x200
 [<ffffffff8117d7c1>] ? ext4_map_blocks+0xe1/0x200
 [<ffffffff8117eb27>] ? mpage_da_map_blocks+0xc7/0x420
 [<ffffffff8118ace0>] ? ext4_journal_start_sb+0xf0/0x120
 [<ffffffff8117f668>] ? ext4_da_writepages+0x2b8/0x560
 [<ffffffff810d122b>] ? writeback_inodes_wb+0xdb/0x1a0
 [<ffffffff8108821f>] ? do_writepages+0x1f/0x40
 [<ffffffff810d0024>] ? writeback_single_inode+0xe4/0x3d0
 [<ffffffff810d0809>] ? writeback_sb_inodes+0x199/0x2a0
 [<ffffffff810d11bb>] ? writeback_inodes_wb+0x6b/0x1a0
 [<ffffffff8102ad60>] ? T.944+0x0/0xd0
 [<ffffffff810d151b>] ? wb_writeback+0x22b/0x290
 [<ffffffff810d16ee>] ? wb_do_writeback+0x16e/0x180
 [<ffffffff810d174b>] ? bdi_writeback_task+0x4b/0x140
 [<ffffffff81093350>] ? bdi_start_fn+0x0/0xf0
 [<ffffffff810933d0>] ? bdi_start_fn+0x80/0xf0
 [<ffffffff81093350>] ? bdi_start_fn+0x0/0xf0
 [<ffffffff8104964e>] ? kthread+0x9e/0xb0
 [<ffffffff8105b87d>] ? trace_hardirqs_on_caller+0x13d/0x180
 [<ffffffff810030e4>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff815b614e>] ? restore_args+0x0/0x30
 [<ffffffff810495b0>] ? kthread+0x0/0xb0
 [<ffffffff810030e0>] ? kernel_thread_helper+0x0/0x10
Code: f0 4c 89 7d f8 4c 89 6d e8 48 8b 1c 25 40 b0 a1 81 49 89 fc 44 8b 8b d4
06 00 00 41 89 f6 49 89 d7 45 85 c9 0f 85 89 00 00 00 9c <58> 0f 1f 44 00 00 49
89 c5 fa 66 0f 1f 44 00 00 c7 83 d4 06 00 
Call Trace:
 [<ffffffff8107fdea>] ? find_get_page+0x8a/0xc0
 [<ffffffff8107fd60>] ? find_get_page+0x0/0xc0
 [<ffffffff810d6ef1>] ? __find_get_block_slow+0x41/0x110
 [<ffffffff810817d5>] ? find_lock_page+0x25/0x80
 [<ffffffff81081dca>] ? find_or_create_page+0x3a/0xb0
 [<ffffffff810d753e>] ? __getblk+0xee/0x2f0
 [<ffffffff8119a7a2>] ? ext4_mb_init_cache+0x122/0xa30
 [<ffffffff8108027f>] ? add_to_page_cache_locked+0xbf/0x100
 [<ffffffff8119b18f>] ? ext4_mb_init_group+0xdf/0x2b0
 [<ffffffff8119b42c>] ? ext4_mb_good_group+0xcc/0x110
 [<ffffffff8119e611>] ? ext4_mb_regular_allocator+0x191/0x3e0
 [<ffffffff81198026>] ? ext4_mb_use_preallocated+0xf6/0x2c0
 [<ffffffff81197f60>] ? ext4_mb_use_preallocated+0x30/0x2c0
 [<ffffffff8105b8cd>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff8119eb3b>] ? ext4_mb_new_blocks+0x2db/0x3f0
 [<ffffffff81191d84>] ? ext4_ext_find_extent+0x2c4/0x320
 [<ffffffff8119453b>] ? ext4_ext_map_blocks+0x4bb/0x1aa0
 [<ffffffff8105b87d>] ? trace_hardirqs_on_caller+0x13d/0x180
 [<ffffffff8117d78b>] ? ext4_map_blocks+0xab/0x200
 [<ffffffff8117d7c1>] ? ext4_map_blocks+0xe1/0x200
 [<ffffffff8117eb27>] ? mpage_da_map_blocks+0xc7/0x420
 [<ffffffff8118ace0>] ? ext4_journal_start_sb+0xf0/0x120
 [<ffffffff8117f668>] ? ext4_da_writepages+0x2b8/0x560
 [<ffffffff810d122b>] ? writeback_inodes_wb+0xdb/0x1a0
 [<ffffffff8108821f>] ? do_writepages+0x1f/0x40
 [<ffffffff810d0024>] ? writeback_single_inode+0xe4/0x3d0
 [<ffffffff810d0809>] ? writeback_sb_inodes+0x199/0x2a0
 [<ffffffff810d11bb>] ? writeback_inodes_wb+0x6b/0x1a0
 [<ffffffff8102ad60>] ? T.944+0x0/0xd0
 [<ffffffff810d151b>] ? wb_writeback+0x22b/0x290
 [<ffffffff810d16ee>] ? wb_do_writeback+0x16e/0x180
 [<ffffffff810d174b>] ? bdi_writeback_task+0x4b/0x140
 [<ffffffff81093350>] ? bdi_start_fn+0x0/0xf0
 [<ffffffff810933d0>] ? bdi_start_fn+0x80/0xf0
 [<ffffffff81093350>] ? bdi_start_fn+0x0/0xf0
 [<ffffffff8104964e>] ? kthread+0x9e/0xb0
 [<ffffffff8105b87d>] ? trace_hardirqs_on_caller+0x13d/0x180
 [<ffffffff810030e4>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff815b614e>] ? restore_args+0x0/0x30
 [<ffffffff810495b0>] ? kthread+0x0/0xb0
 [<ffffffff810030e0>] ? kernel_thread_helper+0x0/0x10
BUG: soft lockup - CPU#0 stuck for 61s! [flush-7:0:954]
irq event stamp: 324872
hardirqs last  enabled at (324871): [<ffffffff815b614e>] restore_args+0x0/0x30
hardirqs last disabled at (324872): [<ffffffff810022f8>] save_args+0x68/0x70
softirqs last  enabled at (324870): [<ffffffff81037477>]
__do_softirq+0xe7/0x130
softirqs last disabled at (324857): [<ffffffff810031da>] call_softirq+0x1a/0x30
CPU 0 
Pid: 954, comm: flush-7:0 Not tainted 2.6.35.6 #2 /Bochs
RIP: 0010:[<ffffffff8107fdd0>]  [<ffffffff8107fdd0>] find_get_page+0x70/0xc0
RSP: 0000:ffff88003e443510  EFLAGS: 00000246
RAX: ffff88003f59c478 RBX: ffff88003e443540 RCX: 0000000000000000
RDX: ffffea0000df44bf RSI: 0000000000000040 RDI: ffffea0000df44c0
RBP: ffffffff81002e0e R08: 0000000000000036 R09: 0000000000000000
R10: 0000000000000001 R11: ffff88003fa9d7a0 R12: ffff88003f424e70
R13: ffff88003f424c90 R14: 0000000000000246 R15: ffff88003fa9d000
FS:  0000000000000000(0000) GS:ffffffff81a1c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000f775a368 CR3: 000000003ead1000 CR4: 00000000000006b0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process flush-7:0 (pid: 954, threadinfo ffff88003e442000, task
ffff88003fa9d000)
Stack:
 ffffffff8107fd60 ffffffff810d6ef1 ffffffff815b614e ffff88003f424e70
<0> 0000000000000040 0000000000000040 ffff88003e443570 ffffffff810817d5
<0> ffff88003e4435c0 0000000000000000 0000000000020058 0000000000000040
Call Trace:
 [<ffffffff8107fd60>] ? find_get_page+0x0/0xc0
 [<ffffffff810d6ef1>] ? __find_get_block_slow+0x41/0x110
 [<ffffffff815b614e>] ? restore_args+0x0/0x30
 [<ffffffff810817d5>] ? find_lock_page+0x25/0x80
 [<ffffffff81081dca>] ? find_or_create_page+0x3a/0xb0
 [<ffffffff810d753e>] ? __getblk+0xee/0x2f0
 [<ffffffff8119a7a2>] ? ext4_mb_init_cache+0x122/0xa30
 [<ffffffff8108027f>] ? add_to_page_cache_locked+0xbf/0x100
 [<ffffffff8119b18f>] ? ext4_mb_init_group+0xdf/0x2b0
 [<ffffffff8119b42c>] ? ext4_mb_good_group+0xcc/0x110
 [<ffffffff8119e611>] ? ext4_mb_regular_allocator+0x191/0x3e0
 [<ffffffff81198026>] ? ext4_mb_use_preallocated+0xf6/0x2c0
 [<ffffffff81197f60>] ? ext4_mb_use_preallocated+0x30/0x2c0
 [<ffffffff8105b8cd>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff8119eb3b>] ? ext4_mb_new_blocks+0x2db/0x3f0
 [<ffffffff81191d84>] ? ext4_ext_find_extent+0x2c4/0x320
 [<ffffffff8119453b>] ? ext4_ext_map_blocks+0x4bb/0x1aa0
 [<ffffffff8105b87d>] ? trace_hardirqs_on_caller+0x13d/0x180
 [<ffffffff8117d78b>] ? ext4_map_blocks+0xab/0x200
 [<ffffffff8117d7c1>] ? ext4_map_blocks+0xe1/0x200
 [<ffffffff8117eb27>] ? mpage_da_map_blocks+0xc7/0x420
 [<ffffffff8118ace0>] ? ext4_journal_start_sb+0xf0/0x120
 [<ffffffff8117f668>] ? ext4_da_writepages+0x2b8/0x560
 [<ffffffff810d122b>] ? writeback_inodes_wb+0xdb/0x1a0
 [<ffffffff8108821f>] ? do_writepages+0x1f/0x40
 [<ffffffff810d0024>] ? writeback_single_inode+0xe4/0x3d0
 [<ffffffff810d0809>] ? writeback_sb_inodes+0x199/0x2a0
 [<ffffffff810d11bb>] ? writeback_inodes_wb+0x6b/0x1a0
 [<ffffffff8102ad60>] ? T.944+0x0/0xd0
 [<ffffffff810d151b>] ? wb_writeback+0x22b/0x290
 [<ffffffff810d16ee>] ? wb_do_writeback+0x16e/0x180
 [<ffffffff810d174b>] ? bdi_writeback_task+0x4b/0x140
 [<ffffffff81093350>] ? bdi_start_fn+0x0/0xf0
 [<ffffffff810933d0>] ? bdi_start_fn+0x80/0xf0
 [<ffffffff81093350>] ? bdi_start_fn+0x0/0xf0
 [<ffffffff8104964e>] ? kthread+0x9e/0xb0
 [<ffffffff8105b87d>] ? trace_hardirqs_on_caller+0x13d/0x180
 [<ffffffff810030e4>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff815b614e>] ? restore_args+0x0/0x30
 [<ffffffff810495b0>] ? kthread+0x0/0xb0
 [<ffffffff810030e0>] ? kernel_thread_helper+0x0/0x10
Code: 89 de 4c 89 e7 e8 21 1f 33 00 48 85 c0 74 4c 48 8b 38 40 f6 c7 01 75 e7
48 8d 57 ff 49 89 fd 48 83 fa fd 77 da ff 47 08 48 3b 38 <75> 33 48 c7 c2 d2 fd
07 81 be 01 00 00 00 48 c7 c7 30 8c a2 81 
Call Trace:
 [<ffffffff8107fd60>] ? find_get_page+0x0/0xc0
 [<ffffffff810d6ef1>] ? __find_get_block_slow+0x41/0x110
 [<ffffffff815b614e>] ? restore_args+0x0/0x30
 [<ffffffff810817d5>] ? find_lock_page+0x25/0x80
 [<ffffffff81081dca>] ? find_or_create_page+0x3a/0xb0
 [<ffffffff810d753e>] ? __getblk+0xee/0x2f0
 [<ffffffff8119a7a2>] ? ext4_mb_init_cache+0x122/0xa30
 [<ffffffff8108027f>] ? add_to_page_cache_locked+0xbf/0x100
 [<ffffffff8119b18f>] ? ext4_mb_init_group+0xdf/0x2b0
 [<ffffffff8119b42c>] ? ext4_mb_good_group+0xcc/0x110
 [<ffffffff8119e611>] ? ext4_mb_regular_allocator+0x191/0x3e0
 [<ffffffff81198026>] ? ext4_mb_use_preallocated+0xf6/0x2c0
 [<ffffffff81197f60>] ? ext4_mb_use_preallocated+0x30/0x2c0
 [<ffffffff8105b8cd>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff8119eb3b>] ? ext4_mb_new_blocks+0x2db/0x3f0
 [<ffffffff81191d84>] ? ext4_ext_find_extent+0x2c4/0x320
 [<ffffffff8119453b>] ? ext4_ext_map_blocks+0x4bb/0x1aa0
 [<ffffffff8105b87d>] ? trace_hardirqs_on_caller+0x13d/0x180
 [<ffffffff8117d78b>] ? ext4_map_blocks+0xab/0x200
 [<ffffffff8117d7c1>] ? ext4_map_blocks+0xe1/0x200
 [<ffffffff8117eb27>] ? mpage_da_map_blocks+0xc7/0x420
 [<ffffffff8118ace0>] ? ext4_journal_start_sb+0xf0/0x120
 [<ffffffff8117f668>] ? ext4_da_writepages+0x2b8/0x560
 [<ffffffff810d122b>] ? writeback_inodes_wb+0xdb/0x1a0
 [<ffffffff8108821f>] ? do_writepages+0x1f/0x40
 [<ffffffff810d0024>] ? writeback_single_inode+0xe4/0x3d0
 [<ffffffff810d0809>] ? writeback_sb_inodes+0x199/0x2a0
 [<ffffffff810d11bb>] ? writeback_inodes_wb+0x6b/0x1a0
 [<ffffffff8102ad60>] ? T.944+0x0/0xd0
 [<ffffffff810d151b>] ? wb_writeback+0x22b/0x290
 [<ffffffff810d16ee>] ? wb_do_writeback+0x16e/0x180
 [<ffffffff810d174b>] ? bdi_writeback_task+0x4b/0x140
 [<ffffffff81093350>] ? bdi_start_fn+0x0/0xf0
 [<ffffffff810933d0>] ? bdi_start_fn+0x80/0xf0
 [<ffffffff81093350>] ? bdi_start_fn+0x0/0xf0
 [<ffffffff8104964e>] ? kthread+0x9e/0xb0
 [<ffffffff8105b87d>] ? trace_hardirqs_on_caller+0x13d/0x180
 [<ffffffff810030e4>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff815b614e>] ? restore_args+0x0/0x30
 [<ffffffff810495b0>] ? kthread+0x0/0xb0
 [<ffffffff810030e0>] ? kernel_thread_helper+0x0/0x10

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
