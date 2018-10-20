Return-Path: <SRS0=ulrH=NA=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-it1-f200.google.com ([209.85.166.200]:36359 "EHLO
        mail-it1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727594AbeJUBIJ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 20 Oct 2018 21:08:09 -0400
Received: by mail-it1-f200.google.com with SMTP id p125-v6so7496353itg.1
        for <linux-ext4@vger.kernel.org>; Sat, 20 Oct 2018 09:57:03 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 20 Oct 2018 09:57:03 -0700
Message-ID: <000000000000bfd4270578abe88b@google.com>
Subject: possible deadlock in flush_workqueue (2)
From: syzbot <syzbot+a50c7541a4a55cd49b02@syzkaller.appspotmail.com>
To: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

syzbot found the following crash on:

HEAD commit:    91b15613ce7f Merge git://git.kernel.org/pub/scm/linux/kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10114109400000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b3f55cb3dfcc6c33
dashboard link: https://syzkaller.appspot.com/bug?extid=a50c7541a4a55cd49b02
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=159c1de9400000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+a50c7541a4a55cd49b02@syzkaller.appspotmail.com

8021q: adding VLAN 0 to HW filter on device team0
8021q: adding VLAN 0 to HW filter on device team0
8021q: adding VLAN 0 to HW filter on device team0

======================================================
WARNING: possible circular locking dependency detected
4.19.0-rc8+ #291 Not tainted
------------------------------------------------------
syz-executor1/6832 is trying to acquire lock:
000000007d4a82f2 ((wq_completion)"dio/%s"sb->s_id){+.+.}, at:  
flush_workqueue+0x2db/0x1e10 kernel/workqueue.c:2652

but task is already holding lock:
00000000e2da6d71 (&sb->s_type->i_mutex_key#10){+.+.}, at: inode_trylock  
include/linux/fs.h:758 [inline]
00000000e2da6d71 (&sb->s_type->i_mutex_key#10){+.+.}, at:  
ext4_file_write_iter+0x2a1/0x1420 fs/ext4/file.c:232

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:
kobject: 'loop2' (00000000a99f8b0a): kobject_uevent_env

-> #2 (&sb->s_type->i_mutex_key#10){+.+.}:
        down_write+0x8a/0x130 kernel/locking/rwsem.c:70
        inode_lock include/linux/fs.h:738 [inline]
        __generic_file_fsync+0xb5/0x200 fs/libfs.c:981
        ext4_sync_file+0xa4f/0x1510 fs/ext4/fsync.c:120
        vfs_fsync_range+0x140/0x220 fs/sync.c:197
kobject: 'loop2' (00000000a99f8b0a): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
        generic_write_sync include/linux/fs.h:2732 [inline]
        dio_complete+0x75c/0x9e0 fs/direct-io.c:329
        dio_aio_complete_work+0x20/0x30 fs/direct-io.c:341
        process_one_work+0xc90/0x1b90 kernel/workqueue.c:2153
kobject: 'loop0' (0000000088c9da71): kobject_uevent_env
        worker_thread+0x17f/0x1390 kernel/workqueue.c:2296
        kthread+0x35a/0x420 kernel/kthread.c:246
kobject: 'loop0' (0000000088c9da71): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
        ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:413

-> #1 ((work_completion)(&dio->complete_work)){+.+.}:
        process_one_work+0xc0a/0x1b90 kernel/workqueue.c:2129
        worker_thread+0x17f/0x1390 kernel/workqueue.c:2296
        kthread+0x35a/0x420 kernel/kthread.c:246
        ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:413

-> #0 ((wq_completion)"dio/%s"sb->s_id){+.+.}:
        lock_acquire+0x1ed/0x520 kernel/locking/lockdep.c:3900
        flush_workqueue+0x30a/0x1e10 kernel/workqueue.c:2655
        drain_workqueue+0x2a9/0x640 kernel/workqueue.c:2820
        destroy_workqueue+0xc6/0x9c0 kernel/workqueue.c:4155
        sb_init_dio_done_wq+0x74/0x90 fs/direct-io.c:634
        do_blockdev_direct_IO+0x12ea/0x9d70 fs/direct-io.c:1283
        __blockdev_direct_IO+0x9d/0xc6 fs/direct-io.c:1417
kobject: 'loop4' (00000000d7ab4dab): kobject_uevent_env
        ext4_direct_IO_write fs/ext4/inode.c:3743 [inline]
        ext4_direct_IO+0xae8/0x2230 fs/ext4/inode.c:3870
        generic_file_direct_write+0x275/0x4b0 mm/filemap.c:3042
        __generic_file_write_iter+0x2ff/0x630 mm/filemap.c:3221
        ext4_file_write_iter+0x390/0x1420 fs/ext4/file.c:266
        call_write_iter include/linux/fs.h:1808 [inline]
        aio_write+0x3b1/0x610 fs/aio.c:1561
        io_submit_one+0xaa1/0xf80 fs/aio.c:1835
kobject: 'loop4' (00000000d7ab4dab): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
        __do_sys_io_submit fs/aio.c:1916 [inline]
        __se_sys_io_submit fs/aio.c:1887 [inline]
        __x64_sys_io_submit+0x1b7/0x580 fs/aio.c:1887
        do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
        entry_SYSCALL_64_after_hwframe+0x49/0xbe

other info that might help us debug this:

Chain exists of:
   (wq_completion)"dio/%s"sb->s_id -->  
(work_completion)(&dio->complete_work) --> &sb->s_type->i_mutex_key#10

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(&sb->s_type->i_mutex_key#10);
                                lock((work_completion)(&dio->complete_work));
                                lock(&sb->s_type->i_mutex_key#10);
   lock((wq_completion)"dio/%s"sb->s_id);

  *** DEADLOCK ***

1 lock held by syz-executor1/6832:
  #0: 00000000e2da6d71 (&sb->s_type->i_mutex_key#10){+.+.}, at:  
inode_trylock include/linux/fs.h:758 [inline]
  #0: 00000000e2da6d71 (&sb->s_type->i_mutex_key#10){+.+.}, at:  
ext4_file_write_iter+0x2a1/0x1420 fs/ext4/file.c:232

stack backtrace:
CPU: 1 PID: 6832 Comm: syz-executor1 Not tainted 4.19.0-rc8+ #291
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1c4/0x2b4 lib/dump_stack.c:113
  print_circular_bug.isra.33.cold.54+0x1bd/0x27d  
kernel/locking/lockdep.c:1221
  check_prev_add kernel/locking/lockdep.c:1861 [inline]
  check_prevs_add kernel/locking/lockdep.c:1974 [inline]
  validate_chain kernel/locking/lockdep.c:2415 [inline]
  __lock_acquire+0x33e4/0x4ec0 kernel/locking/lockdep.c:3411
  lock_acquire+0x1ed/0x520 kernel/locking/lockdep.c:3900
  flush_workqueue+0x30a/0x1e10 kernel/workqueue.c:2655
  drain_workqueue+0x2a9/0x640 kernel/workqueue.c:2820
  destroy_workqueue+0xc6/0x9c0 kernel/workqueue.c:4155
  sb_init_dio_done_wq+0x74/0x90 fs/direct-io.c:634
  do_blockdev_direct_IO+0x12ea/0x9d70 fs/direct-io.c:1283
  __blockdev_direct_IO+0x9d/0xc6 fs/direct-io.c:1417
  ext4_direct_IO_write fs/ext4/inode.c:3743 [inline]
  ext4_direct_IO+0xae8/0x2230 fs/ext4/inode.c:3870
  generic_file_direct_write+0x275/0x4b0 mm/filemap.c:3042
  __generic_file_write_iter+0x2ff/0x630 mm/filemap.c:3221
  ext4_file_write_iter+0x390/0x1420 fs/ext4/file.c:266
  call_write_iter include/linux/fs.h:1808 [inline]
  aio_write+0x3b1/0x610 fs/aio.c:1561
  io_submit_one+0xaa1/0xf80 fs/aio.c:1835
  __do_sys_io_submit fs/aio.c:1916 [inline]
  __se_sys_io_submit fs/aio.c:1887 [inline]
  __x64_sys_io_submit+0x1b7/0x580 fs/aio.c:1887
  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x457569
Code: fd b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f7d19a51c78 EFLAGS: 00000246 ORIG_RAX: 00000000000000d1
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000457569
RDX: 0000000020000540 RSI: 0000000000000008 RDI: 00007f7d19a31000
RBP: 000000000072bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f7d19a526d4
R13: 00000000004be72d R14: 00000000004ce380 R15: 00000000ffffffff
kobject: 'loop3' (00000000037f642c): kobject_uevent_env
kobject: 'loop3' (00000000037f642c): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop2' (00000000a99f8b0a): kobject_uevent_env
kobject: 'loop2' (00000000a99f8b0a): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop5' (00000000373a5938): kobject_uevent_env
kobject: 'loop5' (00000000373a5938): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop4' (00000000d7ab4dab): kobject_uevent_env
kobject: 'loop4' (00000000d7ab4dab): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop1' (0000000020356063): kobject_uevent_env
kobject: 'loop1' (0000000020356063): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop0' (0000000088c9da71): kobject_uevent_env
kobject: 'loop0' (0000000088c9da71): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'loop3' (00000000037f642c): kobject_uevent_env
kobject: 'loop3' (00000000037f642c): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop5' (00000000373a5938): kobject_uevent_env
kobject: 'loop5' (00000000373a5938): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop1' (0000000020356063): kobject_uevent_env
kobject: 'loop1' (0000000020356063): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop0' (0000000088c9da71): kobject_uevent_env
kobject: 'loop0' (0000000088c9da71): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'loop4' (00000000d7ab4dab): kobject_uevent_env
kobject: 'loop4' (00000000d7ab4dab): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop2' (00000000a99f8b0a): kobject_uevent_env
kobject: 'loop2' (00000000a99f8b0a): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop3' (00000000037f642c): kobject_uevent_env
kobject: 'loop3' (00000000037f642c): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop4' (00000000d7ab4dab): kobject_uevent_env
kobject: 'loop4' (00000000d7ab4dab): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop0' (0000000088c9da71): kobject_uevent_env
kobject: 'loop0' (0000000088c9da71): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'loop1' (0000000020356063): kobject_uevent_env
kobject: 'loop1' (0000000020356063): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop2' (00000000a99f8b0a): kobject_uevent_env
kobject: 'loop2' (00000000a99f8b0a): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop3' (00000000037f642c): kobject_uevent_env
kobject: 'loop3' (00000000037f642c): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop5' (00000000373a5938): kobject_uevent_env
kobject: 'loop5' (00000000373a5938): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop1' (0000000020356063): kobject_uevent_env
kobject: 'loop1' (0000000020356063): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop0' (0000000088c9da71): kobject_uevent_env
kobject: 'loop0' (0000000088c9da71): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'loop4' (00000000d7ab4dab): kobject_uevent_env
kobject: 'loop4' (00000000d7ab4dab): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop2' (00000000a99f8b0a): kobject_uevent_env
kobject: 'loop2' (00000000a99f8b0a): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop5' (00000000373a5938): kobject_uevent_env
kobject: 'loop5' (00000000373a5938): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop3' (00000000037f642c): kobject_uevent_env
kobject: 'loop3' (00000000037f642c): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop2' (00000000a99f8b0a): kobject_uevent_env
kobject: 'loop2' (00000000a99f8b0a): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop4' (00000000d7ab4dab): kobject_uevent_env
kobject: 'loop4' (00000000d7ab4dab): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop1' (0000000020356063): kobject_uevent_env
kobject: 'loop1' (0000000020356063): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop3' (00000000037f642c): kobject_uevent_env
kobject: 'loop3' (00000000037f642c): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop4' (00000000d7ab4dab): kobject_uevent_env
kobject: 'loop4' (00000000d7ab4dab): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop2' (00000000a99f8b0a): kobject_uevent_env
kobject: 'loop2' (00000000a99f8b0a): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop0' (0000000088c9da71): kobject_uevent_env
kobject: 'loop0' (0000000088c9da71): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
syz-executor3 (6993) used greatest stack depth: 14648 bytes left
kobject: 'loop3' (00000000037f642c): kobject_uevent_env
kobject: 'loop3' (00000000037f642c): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop5' (00000000373a5938): kobject_uevent_env
kobject: 'loop5' (00000000373a5938): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop2' (00000000a99f8b0a): kobject_uevent_env
kobject: 'loop2' (00000000a99f8b0a): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop1' (0000000020356063): kobject_uevent_env
kobject: 'loop1' (0000000020356063): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop5' (00000000373a5938): kobject_uevent_env
kobject: 'loop5' (00000000373a5938): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop0' (0000000088c9da71): kobject_uevent_env
kobject: 'loop0' (0000000088c9da71): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'loop1' (0000000020356063): kobject_uevent_env
kobject: 'loop1' (0000000020356063): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop5' (00000000373a5938): kobject_uevent_env
kobject: 'loop5' (00000000373a5938): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop0' (0000000088c9da71): kobject_uevent_env
kobject: 'loop0' (0000000088c9da71): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'loop3' (00000000037f642c): kobject_uevent_env
kobject: 'loop3' (00000000037f642c): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop1' (0000000020356063): kobject_uevent_env
kobject: 'loop1' (0000000020356063): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop4' (00000000d7ab4dab): kobject_uevent_env
kobject: 'loop4' (00000000d7ab4dab): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop5' (00000000373a5938): kobject_uevent_env
kobject: 'loop5' (00000000373a5938): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop0' (0000000088c9da71): kobject_uevent_env
kobject: 'loop0' (0000000088c9da71): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
Page cache invalidation failure on direct I/O.  Possible data corruption  
due to collision with buffered I/O!
kobject: 'loop3' (00000000037f642c): kobject_uevent_env
File: /root/syzkaller-testdir701396558/syzkaller.CThVT5/11/bus PID: 14  
Comm: kworker/0:1
kobject: 'loop3' (00000000037f642c): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop2' (00000000a99f8b0a): kobject_uevent_env
kobject: 'loop2' (00000000a99f8b0a): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop4' (00000000d7ab4dab): kobject_uevent_env
kobject: 'loop4' (00000000d7ab4dab): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop5' (00000000373a5938): kobject_uevent_env
kobject: 'loop5' (00000000373a5938): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop0' (0000000088c9da71): kobject_uevent_env
kobject: 'loop0' (0000000088c9da71): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'loop1' (0000000020356063): kobject_uevent_env
kobject: 'loop1' (0000000020356063): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop3' (00000000037f642c): kobject_uevent_env
kobject: 'loop3' (00000000037f642c): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop2' (00000000a99f8b0a): kobject_uevent_env
kobject: 'loop2' (00000000a99f8b0a): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop5' (00000000373a5938): kobject_uevent_env
kobject: 'loop5' (00000000373a5938): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop4' (00000000d7ab4dab): kobject_uevent_env
kobject: 'loop4' (00000000d7ab4dab): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop0' (0000000088c9da71): kobject_uevent_env
kobject: 'loop0' (0000000088c9da71): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'loop1' (0000000020356063): kobject_uevent_env
kobject: 'loop1' (0000000020356063): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop4' (00000000d7ab4dab): kobject_uevent_env
kobject: 'loop4' (00000000d7ab4dab): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop2' (00000000a99f8b0a): kobject_uevent_env
kobject: 'loop2' (00000000a99f8b0a): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop3' (00000000037f642c): kobject_uevent_env
kobject: 'loop3' (00000000037f642c): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop0' (0000000088c9da71): kobject_uevent_env
kobject: 'loop0' (0000000088c9da71): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'loop1' (0000000020356063): kobject_uevent_env
kobject: 'loop1' (0000000020356063): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop5' (00000000373a5938): kobject_uevent_env
kobject: 'loop5' (00000000373a5938): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop3' (00000000037f642c): kobject_uevent_env
kobject: 'loop3' (00000000037f642c): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop4' (00000000d7ab4dab): kobject_uevent_env
kobject: 'loop4' (00000000d7ab4dab): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop0' (0000000088c9da71): kobject_uevent_env
kobject: 'loop0' (0000000088c9da71): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'loop1' (0000000020356063): kobject_uevent_env
kobject: 'loop1' (0000000020356063): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop2' (00000000a99f8b0a): kobject_uevent_env
kobject: 'loop2' (00000000a99f8b0a): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop3' (00000000037f642c): kobject_uevent_env
kobject: 'loop3' (00000000037f642c): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop5' (00000000373a5938): kobject_uevent_env
kobject: 'loop5' (00000000373a5938): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop0' (0000000088c9da71): kobject_uevent_env
kobject: 'loop0' (0000000088c9da71): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'loop4' (00000000d7ab4dab): kobject_uevent_env
kobject: 'loop4' (00000000d7ab4dab): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop2' (00000000a99f8b0a): kobject_uevent_env
kobject: 'loop2' (00000000a99f8b0a): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop0' (0000000088c9da71): kobject_uevent_env
kobject: 'loop0' (0000000088c9da71): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'loop5' (00000000373a5938): kobject_uevent_env
kobject: 'loop5' (00000000373a5938): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop1' (0000000020356063): kobject_uevent_env
kobject: 'loop1' (0000000020356063): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop4' (00000000d7ab4dab): kobject_uevent_env
kobject: 'loop4' (00000000d7ab4dab): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop3' (00000000037f642c): kobject_uevent_env
kobject: 'loop3' (00000000037f642c): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop5' (00000000373a5938): kobject_uevent_env
kobject: 'loop5' (00000000373a5938): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop2' (00000000a99f8b0a): kobject_uevent_env
kobject: 'loop2' (00000000a99f8b0a): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop0' (0000000088c9da71): kobject_uevent_env
kobject: 'loop0' (0000000088c9da71): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'loop1' (0000000020356063): kobject_uevent_env
kobject: 'loop1' (0000000020356063): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop3' (00000000037f642c): kobject_uevent_env
kobject: 'loop3' (00000000037f642c): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop5' (00000000373a5938): kobject_uevent_env
kobject: 'loop5' (00000000373a5938): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop2' (00000000a99f8b0a): kobject_uevent_env
kobject: 'loop2' (00000000a99f8b0a): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop1' (0000000020356063): kobject_uevent_env
kobject: 'loop1' (0000000020356063): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop4' (00000000d7ab4dab): kobject_uevent_env
kobject: 'loop4' (00000000d7ab4dab): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop0' (0000000088c9da71): kobject_uevent_env
kobject: 'loop0' (0000000088c9da71): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'loop5' (00000000373a5938): kobject_uevent_env
kobject: 'loop5' (00000000373a5938): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop4' (00000000d7ab4dab): kobject_uevent_env
kobject: 'loop4' (00000000d7ab4dab): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop2' (00000000a99f8b0a): kobject_uevent_env
kobject: 'loop2' (00000000a99f8b0a): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop3' (00000000037f642c): kobject_uevent_env
kobject: 'loop3' (00000000037f642c): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop4' (00000000d7ab4dab): kobject_uevent_env
kobject: 'loop4' (00000000d7ab4dab): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop0' (0000000088c9da71): kobject_uevent_env
kobject: 'loop0' (0000000088c9da71): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'loop2' (00000000a99f8b0a): kobject_uevent_env
kobject: 'loop2' (00000000a99f8b0a): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop4' (00000000d7ab4dab): kobject_uevent_env
kobject: 'loop4' (00000000d7ab4dab): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop0' (0000000088c9da71): kobject_uevent_env
kobject: 'loop0' (0000000088c9da71): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
Page cache invalidation failure on direct I/O.  Possible data corruption  
due to collision with buffered I/O!
File: /root/syzkaller-testdir446226321/syzkaller.6kf3D2/23/bus PID: 14  
Comm: kworker/0:1
kobject: 'loop1' (0000000020356063): kobject_uevent_env
kobject: 'loop1' (0000000020356063): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop4' (00000000d7ab4dab): kobject_uevent_env
kobject: 'loop4' (00000000d7ab4dab): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop2' (00000000a99f8b0a): kobject_uevent_env
kobject: 'loop2' (00000000a99f8b0a): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop3' (00000000037f642c): kobject_uevent_env
kobject: 'loop3' (00000000037f642c): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop5' (00000000373a5938): kobject_uevent_env
kobject: 'loop5' (00000000373a5938): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop1' (0000000020356063): kobject_uevent_env
kobject: 'loop1' (0000000020356063): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop2' (00000000a99f8b0a): kobject_uevent_env
kobject: 'loop2' (00000000a99f8b0a): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
syz-executor5 (7484) used greatest stack depth: 12280 bytes left
kobject: 'loop1' (0000000020356063): kobject_uevent_env
kobject: 'loop1' (0000000020356063): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop0' (0000000088c9da71): kobject_uevent_env
kobject: 'loop0' (0000000088c9da71): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'loop3' (00000000037f642c): kobject_uevent_env
kobject: 'loop3' (00000000037f642c): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop5' (00000000373a5938): kobject_uevent_env
kobject: 'loop5' (00000000373a5938): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop0' (0000000088c9da71): kobject_uevent_env
kobject: 'loop0' (0000000088c9da71): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'loop4' (00000000d7ab4dab): kobject_uevent_env
kobject: 'loop4' (00000000d7ab4dab): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop2' (00000000a99f8b0a): kobject_uevent_env
kobject: 'loop2' (00000000a99f8b0a): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop1' (0000000020356063): kobject_uevent_env
kobject: 'loop1' (0000000020356063): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop3' (00000000037f642c): kobject_uevent_env
kobject: 'loop3' (00000000037f642c): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop5' (00000000373a5938): kobject_uevent_env
kobject: 'loop5' (00000000373a5938): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop1' (0000000020356063): kobject_uevent_env
kobject: 'loop1' (0000000020356063): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop3' (00000000037f642c): kobject_uevent_env
kobject: 'loop3' (00000000037f642c): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop4' (00000000d7ab4dab): kobject_uevent_env
kobject: 'loop4' (00000000d7ab4dab): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop0' (0000000088c9da71): kobject_uevent_env
kobject: 'loop0' (0000000088c9da71): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'loop5' (00000000373a5938): kobject_uevent_env
kobject: 'loop5' (00000000373a5938): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop4' (00000000d7ab4dab): kobject_uevent_env
kobject: 'loop4' (00000000d7ab4dab): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop2' (00000000a99f8b0a): kobject_uevent_env
kobject: 'loop2' (00000000a99f8b0a): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop0' (0000000088c9da71): kobject_uevent_env
kobject: 'loop0' (0000000088c9da71): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'loop1' (0000000020356063): kobject_uevent_env
kobject: 'loop1' (0000000020356063): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop4' (00000000d7ab4dab): kobject_uevent_env
kobject: 'loop4' (00000000d7ab4dab): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop3' (00000000037f642c): kobject_uevent_env
kobject: 'loop3' (00000000037f642c): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop0' (0000000088c9da71): kobject_uevent_env
kobject: 'loop0' (0000000088c9da71): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'loop2' (00000000a99f8b0a): kobject_uevent_env
kobject: 'loop2' (00000000a99f8b0a): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop5' (00000000373a5938): kobject_uevent_env
kobject: 'loop5' (00000000373a5938): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop4' (00000000d7ab4dab): kobject_uevent_env
kobject: 'loop4' (00000000d7ab4dab): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop2' (00000000a99f8b0a): kobject_uevent_env
kobject: 'loop2' (00000000a99f8b0a): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop1' (0000000020356063): kobject_uevent_env
kobject: 'loop1' (0000000020356063): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop0' (0000000088c9da71): kobject_uevent_env
kobject: 'loop0' (0000000088c9da71): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'loop5' (00000000373a5938): kobject_uevent_env
kobject: 'loop5' (00000000373a5938): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop2' (00000000a99f8b0a): kobject_uevent_env
kobject: 'loop2' (00000000a99f8b0a): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop1' (0000000020356063): kobject_uevent_env
kobject: 'loop1' (0000000020356063): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop0' (0000000088c9da71): kobject_uevent_env
kobject: 'loop0' (0000000088c9da71): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'loop3' (00000000037f642c): kobject_uevent_env
kobject: 'loop3' (00000000037f642c): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop5' (00000000373a5938): kobject_uevent_env
kobject: 'loop5' (00000000373a5938): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop4' (00000000d7ab4dab): kobject_uevent_env
kobject: 'loop4' (00000000d7ab4dab): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop2' (00000000a99f8b0a): kobject_uevent_env
kobject: 'loop2' (00000000a99f8b0a): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop3' (00000000037f642c): kobject_uevent_env
kobject: 'loop3' (00000000037f642c): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop1' (0000000020356063): kobject_uevent_env
kobject: 'loop1' (0000000020356063): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop4' (00000000d7ab4dab): kobject_uevent_env
kobject: 'loop4' (00000000d7ab4dab): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop2' (00000000a99f8b0a): kobject_uevent_env
kobject: 'loop2' (00000000a99f8b0a): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop5' (00000000373a5938): kobject_uevent_env
kobject: 'loop5' (00000000373a5938): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop0' (0000000088c9da71): kobject_uevent_env
kobject: 'loop0' (0000000088c9da71): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'loop3' (00000000037f642c): kobject_uevent_env
kobject: 'loop3' (00000000037f642c): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop1' (0000000020356063): kobject_uevent_env
kobject: 'loop1' (0000000020356063): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop5' (00000000373a5938): kobject_uevent_env
kobject: 'loop5' (00000000373a5938): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop4' (00000000d7ab4dab): kobject_uevent_env
kobject: 'loop4' (00000000d7ab4dab): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop3' (00000000037f642c): kobject_uevent_env
kobject: 'loop3' (00000000037f642c): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop1' (0000000020356063): kobject_uevent_env
kobject: 'loop1' (0000000020356063): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop2' (00000000a99f8b0a): kobject_uevent_env
kobject: 'loop2' (00000000a99f8b0a): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop4' (00000000d7ab4dab): kobject_uevent_env
kobject: 'loop4' (00000000d7ab4dab): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop5' (00000000373a5938): kobject_uevent_env
kobject: 'loop5' (00000000373a5938): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop3' (00000000037f642c): kobject_uevent_env
kobject: 'loop3' (00000000037f642c): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop0' (0000000088c9da71): kobject_uevent_env
kobject: 'loop0' (0000000088c9da71): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'loop2' (00000000a99f8b0a): kobject_uevent_env
kobject: 'loop2' (00000000a99f8b0a): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop5' (00000000373a5938): kobject_uevent_env
kobject: 'loop5' (00000000373a5938): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop3' (00000000037f642c): kobject_uevent_env
kobject: 'loop3' (00000000037f642c): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop0' (0000000088c9da71): kobject_uevent_env
kobject: 'loop0' (0000000088c9da71): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'loop1' (0000000020356063): kobject_uevent_env
kobject: 'loop1' (0000000020356063): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
Page cache invalidation failure on direct I/O.  Possible data corruption  
due to collision with buffered I/O!
kobject: 'loop2' (00000000a99f8b0a): kobject_uevent_env
File: /root/syzkaller-testdir749472085/syzkaller.cOi3p9/41/bus PID: 5692  
Comm: kworker/0:4
kobject: 'loop2' (00000000a99f8b0a): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop1' (0000000020356063): kobject_uevent_env
kobject: 'loop1' (0000000020356063): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop0' (0000000088c9da71): kobject_uevent_env
kobject: 'loop0' (0000000088c9da71): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'loop5' (00000000373a5938): kobject_uevent_env
kobject: 'loop5' (00000000373a5938): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop4' (00000000d7ab4dab): kobject_uevent_env
kobject: 'loop4' (00000000d7ab4dab): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop2' (00000000a99f8b0a): kobject_uevent_env
kobject: 'loop2' (00000000a99f8b0a): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop1' (0000000020356063): kobject_uevent_env
kobject: 'loop1' (0000000020356063): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop3' (00000000037f642c): kobject_uevent_env
kobject: 'loop3' (00000000037f642c): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop5' (00000000373a5938): kobject_uevent_env
kobject: 'loop5' (00000000373a5938): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop4' (00000000d7ab4dab): kobject_uevent_env
kobject: 'loop4' (00000000d7ab4dab): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop2' (00000000a99f8b0a): kobject_uevent_env
kobject: 'loop2' (00000000a99f8b0a): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop1' (0000000020356063): kobject_uevent_env
kobject: 'loop1' (0000000020356063): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop3' (00000000037f642c): kobject_uevent_env
kobject: 'loop3' (00000000037f642c): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop5' (00000000373a5938): kobject_uevent_env
kobject: 'loop5' (00000000373a5938): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop4' (00000000d7ab4dab): kobject_uevent_env
kobject: 'loop4' (00000000d7ab4dab): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop0' (0000000088c9da71): kobject_uevent_env
kobject: 'loop0' (0000000088c9da71): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'loop5' (00000000373a5938): kobject_uevent_env
kobject: 'loop5' (00000000373a5938): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop4' (00000000d7ab4dab): kobject_uevent_env
kobject: 'loop4' (00000000d7ab4dab): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop3' (00000000037f642c): kobject_uevent_env
kobject: 'loop3' (00000000037f642c): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop1' (0000000020356063): kobject_uevent_env
kobject: 'loop1' (0000000020356063): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop2' (00000000a99f8b0a): kobject_uevent_env
kobject: 'loop2' (00000000a99f8b0a): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop0' (0000000088c9da71): kobject_uevent_env
kobject: 'loop0' (0000000088c9da71): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'loop4' (00000000d7ab4dab): kobject_uevent_env
kobject: 'loop4' (00000000d7ab4dab): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop3' (00000000037f642c): kobject_uevent_env
kobject: 'loop3' (00000000037f642c): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop2' (00000000a99f8b0a): kobject_uevent_env
kobject: 'loop2' (00000000a99f8b0a): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop1' (0000000020356063): kobject_uevent_env
kobject: 'loop1' (0000000020356063): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop0' (0000000088c9da71): kobject_uevent_env
kobject: 'loop0' (0000000088c9da71): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'loop5' (00000000373a5938): kobject_uevent_env
kobject: 'loop5' (00000000373a5938): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop4' (00000000d7ab4dab): kobject_uevent_env
kobject: 'loop4' (00000000d7ab4dab): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop3' (00000000037f642c): kobject_uevent_env
kobject: 'loop3' (00000000037f642c): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop1' (0000000020356063): kobject_uevent_env
kobject: 'loop1' (0000000020356063): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop0' (0000000088c9da71): kobject_uevent_env
kobject: 'loop0' (0000000088c9da71): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'loop5' (00000000373a5938): kobject_uevent_env
kobject: 'loop5' (00000000373a5938): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop4' (00000000d7ab4dab): kobject_uevent_env
kobject: 'loop4' (00000000d7ab4dab): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop3' (00000000037f642c): kobject_uevent_env
kobject: 'loop3' (00000000037f642c): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop2' (00000000a99f8b0a): kobject_uevent_env
kobject: 'loop2' (00000000a99f8b0a): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop4' (00000000d7ab4dab): kobject_uevent_env
kobject: 'loop4' (00000000d7ab4dab): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop5' (00000000373a5938): kobject_uevent_env
kobject: 'loop5' (00000000373a5938): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop3' (00000000037f642c): kobject_uevent_env
kobject: 'loop3' (00000000037f642c): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop1' (0000000020356063): kobject_uevent_env
kobject: 'loop1' (0000000020356063): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop0' (0000000088c9da71): kobject_uevent_env
kobject: 'loop0' (0000000088c9da71): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'loop2' (00000000a99f8b0a): kobject_uevent_env
kobject: 'loop2' (00000000a99f8b0a): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop4' (00000000d7ab4dab): kobject_uevent_env
kobject: 'loop4' (00000000d7ab4dab): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop3' (00000000037f642c): kobject_uevent_env
kobject: 'loop3' (00000000037f642c): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop0' (0000000088c9da71): kobject_uevent_env
kobject: 'loop0' (0000000088c9da71): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'loop1' (0000000020356063): kobject_uevent_env
kobject: 'loop1' (0000000020356063): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop4' (00000000d7ab4dab): kobject_uevent_env
kobject: 'loop4' (00000000d7ab4dab): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop0' (0000000088c9da71): kobject_uevent_env
kobject: 'loop0' (0000000088c9da71): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'loop5' (00000000373a5938): kobject_uevent_env
kobject: 'loop5' (00000000373a5938): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop2' (00000000a99f8b0a): kobject_uevent_env
kobject: 'loop2' (00000000a99f8b0a): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop4' (00000000d7ab4dab): kobject_uevent_env
kobject: 'loop4' (00000000d7ab4dab): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop3' (00000000037f642c): kobject_uevent_env
kobject: 'loop3' (00000000037f642c): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop0' (0000000088c9da71): kobject_uevent_env
kobject: 'loop0' (0000000088c9da71): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'loop5' (00000000373a5938): kobject_uevent_env
kobject: 'loop5' (00000000373a5938): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop2' (00000000a99f8b0a): kobject_uevent_env
kobject: 'loop2' (00000000a99f8b0a): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop3' (00000000037f642c): kobject_uevent_env
kobject: 'loop3' (00000000037f642c): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop4' (00000000d7ab4dab): kobject_uevent_env
kobject: 'loop4' (00000000d7ab4dab): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop1' (0000000020356063): kobject_uevent_env
kobject: 'loop1' (0000000020356063): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop5' (00000000373a5938): kobject_uevent_env
kobject: 'loop5' (00000000373a5938): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop0' (0000000088c9da71): kobject_uevent_env
kobject: 'loop0' (0000000088c9da71): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'loop4' (00000000d7ab4dab): kobject_uevent_env
kobject: 'loop4' (00000000d7ab4dab): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop2' (00000000a99f8b0a): kobject_uevent_env
kobject: 'loop2' (00000000a99f8b0a): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop3' (00000000037f642c): kobject_uevent_env
kobject: 'loop3' (00000000037f642c): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop1' (0000000020356063): kobject_uevent_env
kobject: 'loop1' (0000000020356063): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop2' (00000000a99f8b0a): kobject_uevent_env
kobject: 'loop2' (00000000a99f8b0a): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop4' (00000000d7ab4dab): kobject_uevent_env
kobject: 'loop4' (00000000d7ab4dab): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop0' (0000000088c9da71): kobject_uevent_env
kobject: 'loop0' (0000000088c9da71): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'loop5' (00000000373a5938): kobject_uevent_env
kobject: 'loop5' (00000000373a5938): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop1' (0000000020356063): kobject_uevent_env
kobject: 'loop1' (0000000020356063): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop2' (00000000a99f8b0a): kobject_uevent_env
kobject: 'loop2' (00000000a99f8b0a): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop3' (00000000037f642c): kobject_uevent_env
kobject: 'loop3' (00000000037f642c): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop0' (0000000088c9da71): kobject_uevent_env
kobject: 'loop0' (0000000088c9da71): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'loop5' (00000000373a5938): kobject_uevent_env
kobject: 'loop5' (00000000373a5938): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop1' (0000000020356063): kobject_uevent_env
kobject: 'loop1' (0000000020356063): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop3' (00000000037f642c): kobject_uevent_env
kobject: 'loop3' (00000000037f642c): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop4' (00000000d7ab4dab): kobject_uevent_env
kobject: 'loop4' (00000000d7ab4dab): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop0' (0000000088c9da71): kobject_uevent_env
kobject: 'loop0' (0000000088c9da71): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'loop3' (00000000037f642c): kobject_uevent_env
kobject: 'loop3' (00000000037f642c): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop5' (00000000373a5938): kobject_uevent_env
kobject: 'loop5' (00000000373a5938): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop4' (00000000d7ab4dab): kobject_uevent_env
kobject: 'loop4' (00000000d7ab4dab): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop1' (0000000020356063): kobject_uevent_env
kobject: 'loop1' (0000000020356063): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop0' (0000000088c9da71): kobject_uevent_env
kobject: 'loop0' (0000000088c9da71): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'loop5' (00000000373a5938): kobject_uevent_env
kobject: 'loop5' (00000000373a5938): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop4' (00000000d7ab4dab): kobject_uevent_env
kobject: 'loop4' (00000000d7ab4dab): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop2' (00000000a99f8b0a): kobject_uevent_env
kobject: 'loop2' (00000000a99f8b0a): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop1' (0000000020356063): kobject_uevent_env
kobject: 'loop1' (0000000020356063): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop0' (0000000088c9da71): kobject_uevent_env
kobject: 'loop0' (0000000088c9da71): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'loop4' (00000000d7ab4dab): kobject_uevent_env
kobject: 'loop4' (00000000d7ab4dab): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop5' (00000000373a5938): kobject_uevent_env
kobject: 'loop5' (00000000373a5938): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop2' (00000000a99f8b0a): kobject_uevent_env
kobject: 'loop2' (00000000a99f8b0a): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop0' (0000000088c9da71): kobject_uevent_env
kobject: 'loop0' (0000000088c9da71): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'loop3' (00000000037f642c): kobject_uevent_env
kobject: 'loop3' (00000000037f642c): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop5' (00000000373a5938): kobject_uevent_env
kobject: 'loop5' (00000000373a5938): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop2' (00000000a99f8b0a): kobject_uevent_env
kobject: 'loop2' (00000000a99f8b0a): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop0' (0000000088c9da71): kobject_uevent_env
kobject: 'loop0' (0000000088c9da71): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'loop3' (00000000037f642c): kobject_uevent_env
kobject: 'loop3' (00000000037f642c): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop1' (0000000020356063): kobject_uevent_env
kobject: 'loop1' (0000000020356063): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop2' (00000000a99f8b0a): kobject_uevent_env
kobject: 'loop2' (00000000a99f8b0a): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop5' (00000000373a5938): kobject_uevent_env
kobject: 'loop5' (00000000373a5938): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop0' (0000000088c9da71): kobject_uevent_env
kobject: 'loop0' (0000000088c9da71): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'loop1' (0000000020356063): kobject_uevent_env
kobject: 'loop1' (0000000020356063): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop3' (00000000037f642c): kobject_uevent_env
kobject: 'loop3' (00000000037f642c): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop0' (0000000088c9da71): kobject_uevent_env
kobject: 'loop0' (0000000088c9da71): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'loop4' (00000000d7ab4dab): kobject_uevent_env
kobject: 'loop4' (00000000d7ab4dab): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop5' (00000000373a5938): kobject_uevent_env
kobject: 'loop5' (00000000373a5938): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
Page cache invalidation failure on direct I/O.  Possible data corruption  
due to collision with buffered I/O!
kobject: 'loop3' (00000000037f642c): kobject_uevent_env
File: /root/syzkaller-testdir625100220/syzkaller.kNEfa4/64/bus PID: 7011  
Comm: kworker/0:5
kobject: 'loop3' (00000000037f642c): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop1' (0000000020356063): kobject_uevent_env
kobject: 'loop1' (0000000020356063): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop0' (0000000088c9da71): kobject_uevent_env
kobject: 'loop0' (0000000088c9da71): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'loop4' (00000000d7ab4dab): kobject_uevent_env
kobject: 'loop4' (00000000d7ab4dab): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop3' (00000000037f642c): kobject_uevent_env
kobject: 'loop3' (00000000037f642c): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop1' (0000000020356063): kobject_uevent_env
kobject: 'loop1' (0000000020356063): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop2' (00000000a99f8b0a): kobject_uevent_env
kobject: 'loop2' (00000000a99f8b0a): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop4' (00000000d7ab4dab): kobject_uevent_env
kobject: 'loop4' (00000000d7ab4dab): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop0' (0000000088c9da71): kobject_uevent_env
kobject: 'loop0' (0000000088c9da71): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'loop3' (00000000037f642c): kobject_uevent_env
kobject: 'loop3' (00000000037f642c): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop1' (0000000020356063): kobject_uevent_env
kobject: 'loop1' (0000000020356063): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop2' (00000000a99f8b0a): kobject_uevent_env
kobject: 'loop2' (00000000a99f8b0a): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop4' (00000000d7ab4dab): kobject_uevent_env
kobject: 'loop4' (00000000d7ab4dab): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop3' (00000000037f642c): kobject_uevent_env
kobject: 'loop3' (00000000037f642c): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop5' (00000000373a5938): kobject_uevent_env
kobject: 'loop5' (00000000373a5938): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop1' (0000000020356063): kobject_uevent_env
kobject: 'loop1' (0000000020356063): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop2' (00000000a99f8b0a): kobject_uevent_env
kobject: 'loop2' (00000000a99f8b0a): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop4' (00000000d7ab4dab): kobject_uevent_env
kobject: 'loop4' (00000000d7ab4dab): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop5' (00000000373a5938): kobject_uevent_env
kobject: 'loop5' (00000000373a5938): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop3' (00000000037f642c): kobject_uevent_env
kobject: 'loop3' (00000000037f642c): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop0' (0000000088c9da71): kobject_uevent_env
kobject: 'loop0' (0000000088c9da71): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'loop2' (00000000a99f8b0a): kobject_uevent_env
kobject: 'loop2' (00000000a99f8b0a): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop0' (0000000088c9da71): kobject_uevent_env
kobject: 'loop0' (0000000088c9da71): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'loop4' (00000000d7ab4dab): kobject_uevent_env
kobject: 'loop4' (00000000d7ab4dab): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop5' (00000000373a5938): kobject_uevent_env
kobject: 'loop5' (00000000373a5938): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop1' (0000000020356063): kobject_uevent_env
kobject: 'loop1' (0000000020356063): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop3' (00000000037f642c): kobject_uevent_env
kobject: 'loop3' (00000000037f642c): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop0' (0000000088c9da71): kobject_uevent_env
kobject: 'loop0' (0000000088c9da71): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'loop1' (0000000020356063): kobject_uevent_env
kobject: 'loop1' (0000000020356063): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop5' (00000000373a5938): kobject_uevent_env
kobject: 'loop5' (00000000373a5938): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop2' (00000000a99f8b0a): kobject_uevent_env
kobject: 'loop2' (00000000a99f8b0a): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop4' (00000000d7ab4dab): kobject_uevent_env
kobject: 'loop4' (00000000d7ab4dab): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop1' (0000000020356063): kobject_uevent_env
kobject: 'loop1' (0000000020356063): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop5' (00000000373a5938): kobject_uevent_env
kobject: 'loop5' (00000000373a5938): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop4' (00000000d7ab4dab): kobject_uevent_env
kobject: 'loop4' (00000000d7ab4dab): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop1' (0000000020356063): kobject_uevent_env
kobject: 'loop1' (0000000020356063): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop3' (00000000037f642c): kobject_uevent_env
kobject: 'loop3' (00000000037f642c): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop4' (00000000d7ab4dab): kobject_uevent_env
kobject: 'loop4' (00000000d7ab4dab): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop5' (00000000373a5938): kobject_uevent_env
kobject: 'loop5' (00000000373a5938): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop2' (00000000a99f8b0a): kobject_uevent_env
kobject: 'loop2' (00000000a99f8b0a): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop0' (0000000088c9da71): kobject_uevent_env
kobject: 'loop0' (0000000088c9da71): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'loop4' (00000000d7ab4dab): kobject_uevent_env
kobject: 'loop4' (00000000d7ab4dab): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop3' (00000000037f642c): kobject_uevent_env
kobject: 'loop3' (00000000037f642c): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop1' (0000000020356063): kobject_uevent_env
kobject: 'loop1' (0000000020356063): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop2' (00000000a99f8b0a): kobject_uevent_env
kobject: 'loop2' (00000000a99f8b0a): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop0' (0000000088c9da71): kobject_uevent_env
kobject: 'loop0' (0000000088c9da71): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'loop3' (00000000037f642c): kobject_uevent_env
kobject: 'loop3' (00000000037f642c): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop5' (00000000373a5938): kobject_uevent_env


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with  
syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
