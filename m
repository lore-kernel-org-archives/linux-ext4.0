Return-Path: <SRS0=VTDm=MG=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-io1-f71.google.com ([209.85.166.71]:57241 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728917AbeIXTVL (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Sep 2018 15:21:11 -0400
Received: by mail-io1-f71.google.com with SMTP id a3-v6so39046353iod.23
        for <linux-ext4@vger.kernel.org>; Mon, 24 Sep 2018 06:19:02 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 24 Sep 2018 06:19:02 -0700
Message-ID: <000000000000314dab05769dd5b6@google.com>
Subject: INFO: task hung in jbd2_journal_commit_transaction
From: syzbot <syzbot+0e7e90fff14568b11ebe@syzkaller.appspotmail.com>
To: jack@suse.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

syzbot found the following crash on:

HEAD commit:    46c163a036b4 Add linux-next specific files for 20180921
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1283fef1400000
kernel config:  https://syzkaller.appspot.com/x/.config?x=20ea07a946ad19d7
dashboard link: https://syzkaller.appspot.com/bug?extid=0e7e90fff14568b11ebe
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13d6792a400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1610b21a400000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+0e7e90fff14568b11ebe@syzkaller.appspotmail.com

INFO: task jbd2/sda1-8:3307 blocked for more than 140 seconds.
       Not tainted 4.19.0-rc4-next-20180921+ #77
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
jbd2/sda1-8     D18264  3307      2 0x80000000
Call Trace:
  context_switch kernel/sched/core.c:2830 [inline]
  __schedule+0x86c/0x1ed0 kernel/sched/core.c:3479
  schedule+0xfe/0x460 kernel/sched/core.c:3523
  jbd2_journal_commit_transaction+0xd38/0x89da fs/jbd2/commit.c:435
  kjournald2+0x26d/0xb30 fs/jbd2/journal.c:229
  kthread+0x35a/0x440 kernel/kthread.c:246
  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352

Showing all locks held in the system:
4 locks held by kworker/u4:2/28:
  #0: 00000000966b2f63 ((wq_completion)"writeback"){+.+.}, at:  
__write_once_size include/linux/compiler.h:215 [inline]
  #0: 00000000966b2f63 ((wq_completion)"writeback"){+.+.}, at:  
arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
  #0: 00000000966b2f63 ((wq_completion)"writeback"){+.+.}, at: atomic64_set  
include/asm-generic/atomic-instrumented.h:40 [inline]
  #0: 00000000966b2f63 ((wq_completion)"writeback"){+.+.}, at:  
atomic_long_set include/asm-generic/atomic-long.h:59 [inline]
  #0: 00000000966b2f63 ((wq_completion)"writeback"){+.+.}, at: set_work_data  
kernel/workqueue.c:617 [inline]
  #0: 00000000966b2f63 ((wq_completion)"writeback"){+.+.}, at:  
set_work_pool_and_clear_pending kernel/workqueue.c:644 [inline]
  #0: 00000000966b2f63 ((wq_completion)"writeback"){+.+.}, at:  
process_one_work+0xb43/0x1b80 kernel/workqueue.c:2124
  #1: 00000000544b3bff ((work_completion)(&(&wb->dwork)->work)){+.+.}, at:  
process_one_work+0xb9a/0x1b80 kernel/workqueue.c:2128
  #2: 000000008f6094aa (&fc->fs_type->s_umount_key#30){++++}, at:  
trylock_super+0x22/0x110 fs/super.c:411
  #3: 00000000e88adbe2 (&sbi->s_journal_flag_rwsem){.+.+}, at:  
do_writepages+0x9a/0x1a0 mm/page-writeback.c:2340
1 lock held by khungtaskd/983:
  #0: 000000004a02f480 (rcu_read_lock){....}, at:  
debug_show_all_locks+0xd0/0x424 kernel/locking/lockdep.c:4435
3 locks held by rs:main Q:Reg/5445:
  #0: 0000000076c9764a (&f->f_pos_lock){+.+.}, at: __fdget_pos+0x1bb/0x200  
fs/file.c:766
  #1: 000000004aae268a (sb_writers#5){.+.+}, at: file_start_write  
include/linux/fs.h:2784 [inline]
  #1: 000000004aae268a (sb_writers#5){.+.+}, at: vfs_write+0x42a/0x560  
fs/read_write.c:548
  #2: 0000000092898058 (&sb->s_type->i_mutex_key#12){+.+.}, at:  
inode_trylock include/linux/fs.h:770 [inline]
  #2: 0000000092898058 (&sb->s_type->i_mutex_key#12){+.+.}, at:  
ext4_file_write_iter+0x2a1/0x1420 fs/ext4/file.c:232
1 lock held by rsyslogd/5448:
  #0: 000000000182ebfe (&f->f_pos_lock){+.+.}, at: __fdget_pos+0x1bb/0x200  
fs/file.c:766
2 locks held by getty/5537:
  #0: 000000002db97c95 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x32/0x40 drivers/tty/tty_ldsem.c:353
  #1: 00000000c978bc9a (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x335/0x1ce0 drivers/tty/n_tty.c:2140
2 locks held by getty/5538:
  #0: 0000000026d5a3f0 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x32/0x40 drivers/tty/tty_ldsem.c:353
  #1: 00000000858cc8d0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x335/0x1ce0 drivers/tty/n_tty.c:2140
2 locks held by getty/5539:
  #0: 000000004b6a537d (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x32/0x40 drivers/tty/tty_ldsem.c:353
  #1: 0000000092120c7f (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x335/0x1ce0 drivers/tty/n_tty.c:2140
2 locks held by getty/5540:
  #0: 0000000032437300 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x32/0x40 drivers/tty/tty_ldsem.c:353
  #1: 00000000af9d3d4d (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x335/0x1ce0 drivers/tty/n_tty.c:2140
2 locks held by getty/5541:
  #0: 000000003cb32a3a (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x32/0x40 drivers/tty/tty_ldsem.c:353
  #1: 0000000089bab666 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x335/0x1ce0 drivers/tty/n_tty.c:2140
2 locks held by getty/5542:
  #0: 0000000084a4d130 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x32/0x40 drivers/tty/tty_ldsem.c:353
  #1: 00000000764db77e (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x335/0x1ce0 drivers/tty/n_tty.c:2140
2 locks held by getty/5543:
  #0: 00000000c92252aa (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x32/0x40 drivers/tty/tty_ldsem.c:353
  #1: 000000009cc43f77 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x335/0x1ce0 drivers/tty/n_tty.c:2140
6 locks held by syz-executor386/5564:

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 983 Comm: khungtaskd Not tainted 4.19.0-rc4-next-20180921+ #77
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1d3/0x2c4 lib/dump_stack.c:113
  nmi_cpu_backtrace.cold.4+0x63/0xa2 lib/nmi_backtrace.c:101
  nmi_trigger_cpumask_backtrace+0x1c2/0x22c lib/nmi_backtrace.c:62
  arch_trigger_cpumask_backtrace+0x14/0x20 arch/x86/kernel/apic/hw_nmi.c:38
  trigger_all_cpu_backtrace include/linux/nmi.h:144 [inline]
  check_hung_uninterruptible_tasks kernel/hung_task.c:204 [inline]
  watchdog+0xb39/0x1050 kernel/hung_task.c:265
  kthread+0x35a/0x440 kernel/kthread.c:246
  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352
Sending NMI from CPU 0 to CPUs 1:
INFO: NMI handler (nmi_cpu_backtrace_handler) took too long to run: 1.188  
msecs
NMI backtrace for cpu 1
CPU: 1 PID: 5564 Comm: syz-executor386 Not tainted  
4.19.0-rc4-next-20180921+ #77
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:ext4_ext_drop_refs+0xc0/0xf0 fs/ext4/extents.c:723
Code: 03 00 00 00 00 e8 70 31 6c ff 41 83 c4 01 44 89 f7 48 83 c3 30 44 89  
e6 e8 ed 31 6c ff 45 39 e6 7d a6 e8 53 31 6c ff 5b 41 5c <41> 5d 41 5e 41  
5f 5d c3 e8 a3 aa af ff e9 76 ff ff ff 48 89 df e8
RSP: 0018:ffff8801be77f198 EFLAGS: 00000293
RAX: ffff8801d8708580 RBX: ffff8801be363a80 RCX: ffffffff82111fd3
RDX: 0000000000000000 RSI: ffffffff82111fdd RDI: 0000000000000004
RBP: ffff8801be77f1b0 R08: ffff8801d8708580 R09: ffffed003b585b57
R10: ffffed003b585b57 R11: ffff8801dac2dabb R12: 0000000000008002
R13: 0000000000000000 R14: 0000000000000000 R15: dffffc0000000000
FS:  0000000000b12880(0000) GS:ffff8801dad00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffff600400 CR3: 00000001d8736000 CR4: 00000000001406e0
Call Trace:
  mext_check_coverage.constprop.13+0x27b/0x510 fs/ext4/move_extent.c:105
  move_extent_per_page fs/ext4/move_extent.c:323 [inline]
  ext4_move_extents+0x2784/0x3c20 fs/ext4/move_extent.c:669
  ext4_ioctl+0x314f/0x4210 fs/ext4/ioctl.c:799
  vfs_ioctl fs/ioctl.c:46 [inline]
  file_ioctl fs/ioctl.c:501 [inline]
  do_vfs_ioctl+0x1de/0x1720 fs/ioctl.c:685
  ksys_ioctl+0xa9/0xd0 fs/ioctl.c:702
  __do_sys_ioctl fs/ioctl.c:709 [inline]
  __se_sys_ioctl fs/ioctl.c:707 [inline]
  __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:707
  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x440169
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffe0bdc36e8 EFLAGS: 00000217 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440169
RDX: 0000000020000040 RSI: 00000000c028660f RDI: 0000000000000003
RBP: 00000000006ca018 R08: 00000000004002c8 R09: 00000000004002c8
R10: 00000000004002c8 R11: 0000000000000217 R12: 00000000004019f0
R13: 0000000000401a80 R14: 0000000000000000 R15: 0000000000000000


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with  
syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
