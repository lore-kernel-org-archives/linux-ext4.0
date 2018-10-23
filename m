Return-Path: <SRS0=2u2A=ND=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-io1-f70.google.com ([209.85.166.70]:57079 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728601AbeJWSEl (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Oct 2018 14:04:41 -0400
Received: by mail-io1-f70.google.com with SMTP id q7-v6so502303ioh.23
        for <linux-ext4@vger.kernel.org>; Tue, 23 Oct 2018 02:42:03 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 23 Oct 2018 02:42:03 -0700
In-Reply-To: <000000000000bfd4270578abe88b@google.com>
Message-ID: <0000000000009bcd4a0578e22ebd@google.com>
Subject: Re: possible deadlock in flush_workqueue (2)
From: syzbot <syzbot+a50c7541a4a55cd49b02@syzkaller.appspotmail.com>
To: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

syzbot has found a reproducer for the following crash on:

HEAD commit:    ca9eb48fe01f Merge tag 'regulator-v5.0' of git://git.kerne..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11a60939400000
kernel config:  https://syzkaller.appspot.com/x/.config?x=963b24abf3f7c2d8
dashboard link: https://syzkaller.appspot.com/bug?extid=a50c7541a4a55cd49b02
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12097f03400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10b55ac5400000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+a50c7541a4a55cd49b02@syzkaller.appspotmail.com


======================================================
WARNING: possible circular locking dependency detected
syz-executor460 (5381) used greatest stack depth: 13176 bytes left
4.19.0+ #298 Not tainted
------------------------------------------------------
syz-executor460/5379 is trying to acquire lock:
00000000cba2efd5 ((wq_completion)"dio/%s"sb->s_id){+.+.}, at:  
flush_workqueue+0x2db/0x1e10 kernel/workqueue.c:2652

but task is already holding lock:
00000000a7636398 (&sb->s_type->i_mutex_key#10){+.+.}, at: inode_trylock  
include/linux/fs.h:758 [inline]
00000000a7636398 (&sb->s_type->i_mutex_key#10){+.+.}, at:  
ext4_file_write_iter+0x2a1/0x1420 fs/ext4/file.c:232

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&sb->s_type->i_mutex_key#10){+.+.}:
        down_write+0x8a/0x130 kernel/locking/rwsem.c:70
        inode_lock include/linux/fs.h:738 [inline]
        __generic_file_fsync+0xb5/0x200 fs/libfs.c:981
        ext4_sync_file+0xa4f/0x1510 fs/ext4/fsync.c:120
        vfs_fsync_range+0x140/0x220 fs/sync.c:197
        generic_write_sync include/linux/fs.h:2732 [inline]
        dio_complete+0x75c/0x9e0 fs/direct-io.c:329
        dio_aio_complete_work+0x20/0x30 fs/direct-io.c:341
        process_one_work+0xc90/0x1c40 kernel/workqueue.c:2153
        worker_thread+0x17f/0x1390 kernel/workqueue.c:2296
        kthread+0x35a/0x420 kernel/kthread.c:246
        ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:413

-> #1 ((work_completion)(&dio->complete_work)){+.+.}:
        process_one_work+0xc0a/0x1c40 kernel/workqueue.c:2129
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

1 lock held by syz-executor460/5379:
  #0: 00000000a7636398 (&sb->s_type->i_mutex_key#10){+.+.}, at:  
inode_trylock include/linux/fs.h:758 [inline]
  #0: 00000000a7636398 (&sb->s_type->i_mutex_key#10){+.+.}, at:  
ext4_file_write_iter+0x2a1/0x1420 fs/ext4/file.c:232

stack backtrace:
CPU: 1 PID: 5379 Comm: syz-executor460 Not tainted 4.19.0+ #298
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1c4/0x2b6 lib/dump_stack.c:113
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
RIP: 0033:0x4469b9
Code: e8 dc e6 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 4b 07 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fbd534a7da8 EFLAGS: 00000246 ORIG_RAX: 00000000000000d1
RAX: ffffffffffffffda RBX: 00000000006dcc48 RCX: 00000000004469b9
RDX: 0000000020000540 RSI: 0000000000000008 RDI: 00007fbd53487000
RBP: 00000000006dcc40 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006dcc4c
R13: 8000000000044000 R14: 00007fbd534a89c0 R15: 00000000006dcd4c
Page cache invalidation failure on direct I/O.  Possible data corruption  
due to collision with buffered I/O!
File: /root/syzkaller.jTMKK3/1/bus PID: 14 Comm: kworker/0:1
Page cache invalidation failure on direct I/O.  Possible data corruption  
due to collision with buffered I/O!
File: /root/syzkaller.jTMKK3/3/bus PID: 14 Comm: kworker/0:1
Page cache invalidation failure on direct I/O.  Possible data corruption  
due to collision with buffered I/O!
File: /root/syzkaller.itrSF4/4/bus PID: 5 Comm: kworker/0:0
Page cache invalidation failure on direct I/O.  Possible data corruption  
due to collision with buffered I/O!
File: /root/syzkaller.itrSF4/5/bus PID: 5 Comm: kworker/0:0
Page cache invalidation failure on direct I/O.  Possible data corruption  
due to collision with buffered I/O!
File: /root/syzkaller.qGPxI4/5/bus PID: 14 Comm: kworker/0:1
Page cache invalidation failure on direct I/O.  Possible data corruption  
due to collision with buffered I/O!
File: /root/syzkaller.qGPxI4/6/bus PID: 5 Comm: kworker/0:0
Page cache invalidation failure on direct I/O.  Possible data corruption  
due to collision with buffered I/O!
File: /root/syzkaller.FhXGz4/9/bus PID: 14 Comm: kworker/0:1
Page cache invalidation failure on direct I/O.  Possible data corruption  
due to collision with buffered I/O!
File: /root/syzkaller.itrSF4/9/bus PID: 5394 Comm: kworker/0:4
Page cache invalidation failure on direct I/O.  Possible data corruption  
due to collision with buffered I/O!
File: /root/syzkaller.FhXGz4/10/bus PID: 5394 Comm: kworker/0:4
Page cache invalidation failure on direct I/O.  Possible data corruption  
due to collision with buffered I/O!
File: /root/syzkaller.qGPxI4/9/bus PID: 5394 Comm: kworker/0:4
