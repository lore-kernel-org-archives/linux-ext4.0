Return-Path: <SRS0=PkuD=NH=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-io1-f72.google.com ([209.85.166.72]:44521 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728520AbeJ0Twl (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 27 Oct 2018 15:52:41 -0400
Received: by mail-io1-f72.google.com with SMTP id s15-v6so3410525iob.11
        for <linux-ext4@vger.kernel.org>; Sat, 27 Oct 2018 04:12:04 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 27 Oct 2018 04:12:03 -0700
Message-ID: <000000000000dd0a16057933e7d6@google.com>
Subject: INFO: task hung in ext4_map_blocks
From: syzbot <syzbot+b620151161795bd74a60@syzkaller.appspotmail.com>
To: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

syzbot found the following crash on:

HEAD commit:    638820d8da8e Merge branch 'next-general' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10c8d0eb400000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f9a456324fcc850a
dashboard link: https://syzkaller.appspot.com/bug?extid=b620151161795bd74a60
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15ede44d400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1452e9cb400000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+b620151161795bd74a60@syzkaller.appspotmail.com

audit: type=1800 audit(1540407533.329:30): pid=5235 uid=0 auid=4294967295  
ses=4294967295 subj==unconfined op=collect_data cause=failed(directio)  
comm="startpar" name="rmnologin" dev="sda1" ino=2423 res=0
INFO: task kworker/u4:0:7 blocked for more than 140 seconds.
       Not tainted 4.19.0+ #301
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/u4:0    D13168     7      2 0x80000000
Workqueue: writeback wb_workfn (flush-8:0)
Call Trace:
  context_switch kernel/sched/core.c:2826 [inline]
  __schedule+0x8cf/0x21d0 kernel/sched/core.c:3474
  schedule+0xfe/0x460 kernel/sched/core.c:3518
  __rwsem_down_write_failed_common+0xc9a/0x15e0  
kernel/locking/rwsem-xadd.c:577
  rwsem_down_write_failed+0xe/0x10 kernel/locking/rwsem-xadd.c:606
  call_rwsem_down_write_failed+0x17/0x30 arch/x86/lib/rwsem.S:117
  __down_write arch/x86/include/asm/rwsem.h:142 [inline]
  down_write+0xa5/0x130 kernel/locking/rwsem.c:72
  ext4_map_blocks+0x88f/0x1b40 fs/ext4/inode.c:629
  mpage_map_one_extent fs/ext4/inode.c:2450 [inline]
  mpage_map_and_submit_extent fs/ext4/inode.c:2503 [inline]
  ext4_writepages+0x2595/0x4130 fs/ext4/inode.c:2854
  do_writepages+0x9a/0x1a0 mm/page-writeback.c:2340
  __writeback_single_inode+0x20a/0x1620 fs/fs-writeback.c:1323
  writeback_sb_inodes+0x71f/0x11d0 fs/fs-writeback.c:1587
  __writeback_inodes_wb+0x1b9/0x340 fs/fs-writeback.c:1656
  wb_writeback+0xa73/0xfc0 fs/fs-writeback.c:1765
  wb_check_old_data_flush fs/fs-writeback.c:1867 [inline]
  wb_do_writeback fs/fs-writeback.c:1920 [inline]
  wb_workfn+0x1008/0x1790 fs/fs-writeback.c:1949
  process_one_work+0xc90/0x1c40 kernel/workqueue.c:2153
  worker_thread+0x17f/0x1390 kernel/workqueue.c:2296
  kthread+0x35a/0x420 kernel/kthread.c:246
  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:350

Showing all locks held in the system:
5 locks held by kworker/u4:0/7:
  #0: 00000000ce3fc1c2 ((wq_completion)"writeback"){+.+.}, at:  
__write_once_size include/linux/compiler.h:206 [inline]
  #0: 00000000ce3fc1c2 ((wq_completion)"writeback"){+.+.}, at:  
arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
  #0: 00000000ce3fc1c2 ((wq_completion)"writeback"){+.+.}, at: atomic64_set  
include/asm-generic/atomic-instrumented.h:40 [inline]
  #0: 00000000ce3fc1c2 ((wq_completion)"writeback"){+.+.}, at:  
atomic_long_set include/asm-generic/atomic-long.h:59 [inline]
  #0: 00000000ce3fc1c2 ((wq_completion)"writeback"){+.+.}, at: set_work_data  
kernel/workqueue.c:617 [inline]
  #0: 00000000ce3fc1c2 ((wq_completion)"writeback"){+.+.}, at:  
set_work_pool_and_clear_pending kernel/workqueue.c:644 [inline]
  #0: 00000000ce3fc1c2 ((wq_completion)"writeback"){+.+.}, at:  
process_one_work+0xb43/0x1c40 kernel/workqueue.c:2124
  #1: 00000000d6c9c988 ((work_completion)(&(&wb->dwork)->work)){+.+.}, at:  
process_one_work+0xb9a/0x1c40 kernel/workqueue.c:2128
  #2: 00000000a32f172a (&type->s_umount_key#30){++++}, at:  
trylock_super+0x22/0x110 fs/super.c:412
  #3: 000000004f496d2d (&sbi->s_journal_flag_rwsem){.+.+}, at:  
do_writepages+0x9a/0x1a0 mm/page-writeback.c:2340
  #4: 00000000abe2b30d (&ei->i_data_sem){++++}, at:  
ext4_map_blocks+0x88f/0x1b40 fs/ext4/inode.c:629
1 lock held by khungtaskd/980:
  #0: 000000004d289beb (rcu_read_lock){....}, at:  
debug_show_all_locks+0xd0/0x424 kernel/locking/lockdep.c:4379
1 lock held by rsyslogd/5273:
  #0: 00000000bce88f8b (&f->f_pos_lock){+.+.}, at: __fdget_pos+0x1bb/0x200  
fs/file.c:766
2 locks held by getty/5363:
  #0: 00000000bc7d06fd (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x32/0x40 drivers/tty/tty_ldsem.c:353
  #1: 000000005dc6654d (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x335/0x1ce0 drivers/tty/n_tty.c:2140
2 locks held by getty/5364:
  #0: 00000000b74b0737 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x32/0x40 drivers/tty/tty_ldsem.c:353
  #1: 000000000d7c9596 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x335/0x1ce0 drivers/tty/n_tty.c:2140
2 locks held by getty/5365:
  #0: 000000002db01519 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x32/0x40 drivers/tty/tty_ldsem.c:353
  #1: 00000000feac9e10 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x335/0x1ce0 drivers/tty/n_tty.c:2140
2 locks held by getty/5366:
  #0: 00000000fa7b9c5d (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x32/0x40 drivers/tty/tty_ldsem.c:353
  #1: 0000000029958494 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x335/0x1ce0 drivers/tty/n_tty.c:2140
2 locks held by getty/5367:
  #0: 00000000c8499234 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x32/0x40 drivers/tty/tty_ldsem.c:353
  #1: 000000008773936c (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x335/0x1ce0 drivers/tty/n_tty.c:2140
2 locks held by getty/5368:
  #0: 000000004165be65 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x32/0x40 drivers/tty/tty_ldsem.c:353
  #1: 0000000089cba62d (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x335/0x1ce0 drivers/tty/n_tty.c:2140
2 locks held by getty/5369:
  #0: 00000000f3f983f2 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x32/0x40 drivers/tty/tty_ldsem.c:353
  #1: 00000000c8e059da (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x335/0x1ce0 drivers/tty/n_tty.c:2140
5 locks held by syz-executor827/5390:

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 980 Comm: khungtaskd Not tainted 4.19.0+ #301
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x244/0x39d lib/dump_stack.c:113
  nmi_cpu_backtrace.cold.1+0x5c/0xa1 lib/nmi_backtrace.c:101
  nmi_trigger_cpumask_backtrace+0x1b3/0x1ed lib/nmi_backtrace.c:62
  arch_trigger_cpumask_backtrace+0x14/0x20 arch/x86/kernel/apic/hw_nmi.c:38
  trigger_all_cpu_backtrace include/linux/nmi.h:144 [inline]
  check_hung_uninterruptible_tasks kernel/hung_task.c:204 [inline]
  watchdog+0xb3e/0x1050 kernel/hung_task.c:265
  kthread+0x35a/0x420 kernel/kthread.c:246
  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:350
Sending NMI from CPU 0 to CPUs 1:
INFO: NMI handler (nmi_cpu_backtrace_handler) took too long to run: 1.137  
msecs
NMI backtrace for cpu 1
CPU: 1 PID: 5390 Comm: syz-executor827 Not tainted 4.19.0+ #301
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:get_ext_path fs/ext4/move_extent.c:40 [inline]
RIP: 0010:mext_check_coverage.constprop.13+0x174/0x510  
fs/ext4/move_extent.c:98
Code: 49 83 7c 24 10 00 0f 84 e4 01 00 00 e8 f5 2f 60 ff 48 8b 95 70 ff ff  
ff 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 80 3c 02 00 <0f> 85 e3 02 00  
00 4c 89 fa 48 89 5d 98 48 b8 00 00 00 00 00 fc ff
RSP: 0018:ffff8801d7fcf1c0 EFLAGS: 00000246
RAX: dffffc0000000000 RBX: ffff8801d963a880 RCX: ffffffff821f5a82
RDX: 1ffff1003aff9e41 RSI: ffffffff821f591b RDI: ffff8801d963a890
RBP: ffff8801d7fcf270 R08: ffff8801d7d66400 R09: ffffed003b5e5b57
R10: ffffed003b5e5b57 R11: ffff8801daf2dabb R12: ffff8801d963a880
R13: 00000000f6986ac0 R14: ffff8801b73411f0 R15: ffff8801d7fcf3e0
FS:  0000000001fef880(0000) GS:ffff8801daf00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffff600400 CR3: 00000001d93df000 CR4: 00000000001406e0
Call Trace:
  move_extent_per_page fs/ext4/move_extent.c:323 [inline]
  ext4_move_extents+0x2784/0x3c20 fs/ext4/move_extent.c:669
  ext4_ioctl+0x3154/0x4210 fs/ext4/ioctl.c:799
  vfs_ioctl fs/ioctl.c:46 [inline]
  file_ioctl fs/ioctl.c:501 [inline]
  do_vfs_ioctl+0x1de/0x1720 fs/ioctl.c:685
  ksys_ioctl+0xa9/0xd0 fs/ioctl.c:702
  __do_sys_ioctl fs/ioctl.c:709 [inline]
  __se_sys_ioctl fs/ioctl.c:707 [inline]
  __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:707
  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4401d9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffe954e8808 EFLAGS: 00000217 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 00000000004401d9
RDX: 0000000020000040 RSI: 00000000c028660f RDI: 0000000000000003
RBP: 00000000006ca018 R08: 00000000004002c8 R09: 00000000004002c8
R10: 00000000004002c8 R11: 0000000000000217 R12: 0000000000401a60
R13: 0000000000401af0 R14: 0000000000000000 R15: 0000000000000000


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with  
syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
