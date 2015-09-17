From: Andrey Konovalov <andreyknvl@google.com>
Subject: User-memory-access in ext4_orphan_del
Date: Thu, 17 Sep 2015 15:01:24 +0200
Message-ID: <CAAeHK+ww-PunDvAZqScLbFYiG=4jTt7cQTLEo+oDGzeQPY+oOg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Dmitry Vyukov <dvyukov@google.com>,
	Alexander Potapenko <glider@google.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi!

While fuzzing the kernel (d25ed277fbd) with KASAN and Trinity I got
the report below.

This report is followed by:
kernel BUG at fs/buffer.c:3025
BUG: KASan: use after free in mutex_optimistic_spin

Crash log is here:
https://gist.github.com/xairy/3b7fcf1cd2541c64c8d1

Here is another crash log that I got in a separate run (starts with
kernel BUG at fs/ext4/ext4.h:2610!), but it seems somewhat similar:
https://gist.github.com/xairy/6ab010c20eb437ec23af

==================================================================
BUG: KASan: user-memory-access on address dead000000000108
Write of size 8 by task rs:main Q:Reg/2999
CPU: 0 PID: 2999 Comm: rs:main Q:Reg Not tainted 4.3.0-rc1-kasan #9
Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2007
 ffff880034067990 ffff880034507a40 ffffffff814a3aac 0000000000000297
 ffff880034507a60 ffffffff812107a9 ffff8800340679d0 dead000000000200
 ffff880034507a98 ffffffff8120f1ca dead000000000108 ffff880034507a98
Call Trace:
 [<ffffffff814a3aac>] dump_stack+0x44/0x58 lib/dump_stack.c:15
 [<ffffffff812107a9>] kasan_report_user_access+0x89/0xb0 ??:0
 [<ffffffff8120f1ca>] __asan_store8+0x8a/0xa0 ??:0
 [<     inline     >] ? __list_del include/linux/list.h:89
 [<     inline     >] ? __list_del_entry include/linux/list.h:102
 [<     inline     >] ? list_del_init include/linux/list.h:145
 [<ffffffff812e8874>] ? ext4_orphan_del+0x114/0x3a0 fs/ext4/namei.c:2859
 [<     inline     >] __list_del include/linux/list.h:89
 [<     inline     >] __list_del_entry include/linux/list.h:102
 [<     inline     >] list_del_init include/linux/list.h:145
 [<ffffffff812e8874>] ext4_orphan_del+0x114/0x3a0 fs/ext4/namei.c:2859
 [<ffffffff812d89cc>] ext4_truncate+0x50c/0x640 fs/ext4/inode.c:3797
 [<ffffffff812d9248>] ext4_da_write_begin+0x228/0x3a0 fs/ext4/truncate.h:14
 [<ffffffff811a1e62>] generic_perform_write+0x112/0x2e0 mm/filemap.c:2476
 [<ffffffff811a49f3>] __generic_file_write_iter+0x253/0x2f0 mm/filemap.c:2622
 [<ffffffff81115e9a>] ? get_futex_key_refs.isra.12+0x1a/0x50 kernel/futex.c:399
 [<     inline     >] ? iov_iter_truncate include/linux/uio.h:136
 [<ffffffff811a236e>] ? generic_write_checks+0x12e/0x210 mm/filemap.c:2333
 [<ffffffff812c95ab>] ext4_file_write_iter+0x16b/0x5f0 file.c:0
 [<ffffffff811165fc>] ? futex_wake+0x8c/0x1d0 kernel/futex.c:611
 [<ffffffff814be772>] ? iov_iter_init+0x82/0xc0 ??:0
 [<ffffffff81217818>] __vfs_write+0x128/0x170 ??:0
 [<ffffffff812180ab>] vfs_write+0xeb/0x250 ??:0
 [<ffffffff81219283>] SyS_write+0x53/0xb0 ??:0
 [<ffffffff81d4ed62>] tracesys_phase2+0x84/0x89 arch/x86/entry/entry_64.S:269
==================================================================
general protection fault: 0000 [#1] SMP KASAN
Modules linked in:
CPU: 0 PID: 2999 Comm: rs:main Q:Reg Not tainted 4.3.0-rc1-kasan #9
Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2007
task: ffff880033d75940 ti: ffff880034500000 task.ti: ffff880034500000
RIP: 0010:[<ffffffff812e887b>]  [<ffffffff812e887b>] ext4_orphan_del+0x11b/0x3a0
RSP: 0018:ffff880034507aa8  EFLAGS: 00010297
RAX: dead000000000100 RBX: ffff8800340679d0 RCX: 0000000000000042
RDX: 1ffffffff04a6bd0 RSI: 0000000000000297 RDI: dead000000000200
RBP: ffff880034507b30 R08: 000000000000003d R09: 000000000000003d
R10: ffffffff824c057b R11: 3d3d3d3d3d3d3d3d R12: dead000000000200
R13: ffff880034ac40c0 R14: 0000000000000000 R15: ffff880034067990
FS:  00007f8731819700(0000) GS:ffff880036400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fffc6cbdfc8 CR3: 0000000032b96000 CR4: 00000000000006f0
DR0: 00007f0dd31d7000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
Stack:
 ffff8800340679f8 ffff880034ac42d0 dead000000000200 ffff880034067910
 dead000000000100 ffff880034216b80 ffff8800341f9238 0000000000000b00
 ffff880000000002 ffff8800341f9238 0000000000000b00 ffff880000000002
Call Trace:
 [<ffffffff812d89cc>] ext4_truncate+0x50c/0x640 fs/ext4/inode.c:3797
 [<ffffffff812d9248>] ext4_da_write_begin+0x228/0x3a0 fs/ext4/truncate.h:14
 [<ffffffff811a1e62>] generic_perform_write+0x112/0x2e0 mm/filemap.c:2476
 [<ffffffff811a49f3>] __generic_file_write_iter+0x253/0x2f0 mm/filemap.c:2622
 [<ffffffff81115e9a>] ? get_futex_key_refs.isra.12+0x1a/0x50 kernel/futex.c:399
 [<     inline     >] ? iov_iter_truncate include/linux/uio.h:136
 [<ffffffff811a236e>] ? generic_write_checks+0x12e/0x210 mm/filemap.c:2333
 [<ffffffff812c95ab>] ext4_file_write_iter+0x16b/0x5f0 file.c:0
 [<ffffffff811165fc>] ? futex_wake+0x8c/0x1d0 kernel/futex.c:611
 [<ffffffff814be772>] ? iov_iter_init+0x82/0xc0 ??:0
 [<ffffffff81217818>] __vfs_write+0x128/0x170 ??:0
 [<ffffffff812180ab>] vfs_write+0xeb/0x250 ??:0
 [<ffffffff81219283>] SyS_write+0x53/0xb0 ??:0
 [<ffffffff81d4ed62>] tracesys_phase2+0x84/0x89 arch/x86/entry/entry_64.S:269
Code: ff 48 8b 43 c0 49 8d 7c 24 08 48 89 45 98 e8 9d 6c f2 ff 48 8b
45 98 4c 8b 63 c8 48 8d 78 08 e8 cc 68 f2 ff 48 8b 45 98 4c 89 e7 <4c>
89 60 08 e8 bc 68 f2 ff 48 8b 45 98 45 85 f6 49 89 04 24 4c
RIP  [<     inline     >] __list_del include/linux/list.h:90
RIP  [<     inline     >] __list_del_entry include/linux/list.h:102
RIP  [<     inline     >] list_del_init include/linux/list.h:145
RIP  [<ffffffff812e887b>] ext4_orphan_del+0x11b/0x3a0 fs/ext4/namei.c:2859
 RSP <ffff880034507aa8>
---[ end trace 73c806d9f233bae7 ]---
