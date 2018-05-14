From: syzbot <syzbot+45843822635038f93354@syzkaller.appspotmail.com>
Subject: INFO: task hung in ext4_direct_IO
Date: Mon, 14 May 2018 07:36:02 -0700
Message-ID: <000000000000a88a2e056c2b67a0@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
To: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tytso@mit.edu
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    66e1c94db3cd Merge branch 'x86-pti-for-linus' of git://git..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=148dc017800000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fcce42b221691ff9
dashboard link: https://syzkaller.appspot.com/bug?extid=45843822635038f93354
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+45843822635038f93354@syzkaller.appspotmail.com

INFO: task syz-executor6:7855 blocked for more than 120 seconds.
       Not tainted 4.17.0-rc4+ #46
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor6   D19384  7855   4549 0x00000004
Call Trace:
  context_switch kernel/sched/core.c:2859 [inline]
  __schedule+0x801/0x1e30 kernel/sched/core.c:3501
  schedule+0xef/0x430 kernel/sched/core.c:3545
  __rwsem_down_read_failed_common kernel/locking/rwsem-xadd.c:269 [inline]
  rwsem_down_read_failed+0x350/0x5e0 kernel/locking/rwsem-xadd.c:286
  call_rwsem_down_read_failed+0x18/0x30 arch/x86/lib/rwsem.S:94
  __down_read arch/x86/include/asm/rwsem.h:83 [inline]
  down_read+0xbd/0x1b0 kernel/locking/rwsem.c:26
  inode_lock_shared include/linux/fs.h:723 [inline]
  ext4_direct_IO_read fs/ext4/inode.c:3828 [inline]
  ext4_direct_IO+0x653/0x2110 fs/ext4/inode.c:3865
  generic_file_read_iter+0x510/0x2f00 mm/filemap.c:2341
  ext4_file_read_iter+0x18b/0x3c0 fs/ext4/file.c:77
  call_read_iter include/linux/fs.h:1778 [inline]
  generic_file_splice_read+0x552/0x910 fs/splice.c:307
  do_splice_to+0x12e/0x190 fs/splice.c:880
  splice_direct_to_actor+0x268/0x8d0 fs/splice.c:952
  do_splice_direct+0x2cc/0x400 fs/splice.c:1061
  do_sendfile+0x60f/0xe00 fs/read_write.c:1440
  __do_sys_sendfile64 fs/read_write.c:1495 [inline]
  __se_sys_sendfile64 fs/read_write.c:1487 [inline]
  __x64_sys_sendfile64+0x155/0x240 fs/read_write.c:1487
  do_syscall_64+0x1b1/0x800 arch/x86/entry/common.c:287
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x455979
RSP: 002b:00007f433652fc68 EFLAGS: 00000246 ORIG_RAX: 0000000000000028
RAX: ffffffffffffffda RBX: 00007f43365306d4 RCX: 0000000000455979
RDX: 0000000020000180 RSI: 0000000000000015 RDI: 000000000000001a
RBP: 000000000072c0b0 R08: 0000000000000000 R09: 0000000000000000
R10: 0020000000011ffe R11: 0000000000000246 R12: 00000000ffffffff
R13: 0000000000000579 R14: 00000000006fc3f8 R15: 0000000000000003

Showing all locks held in the system:
2 locks held by khungtaskd/892:
  #0: 00000000068c5076 (rcu_read_lock){....}, at:  
check_hung_uninterruptible_tasks kernel/hung_task.c:175 [inline]
  #0: 00000000068c5076 (rcu_read_lock){....}, at: watchdog+0x1ff/0xf60  
kernel/hung_task.c:249
  #1: 000000001ff4f1ee (tasklist_lock){.+.+}, at:  
debug_show_all_locks+0xde/0x34a kernel/locking/lockdep.c:4470
1 lock held by rsyslogd/4378:
  #0: 000000002f91cc37 (&f->f_pos_lock){+.+.}, at: __fdget_pos+0x1a9/0x1e0  
fs/file.c:766
2 locks held by getty/4468:
  #0: 000000002dc15303 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x37/0x40 drivers/tty/tty_ldsem.c:365
  #1: 00000000d6d05a90 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x321/0x1cc0 drivers/tty/n_tty.c:2131
2 locks held by getty/4469:
  #0: 0000000056014cd7 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x37/0x40 drivers/tty/tty_ldsem.c:365
  #1: 000000002e24c7bd (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x321/0x1cc0 drivers/tty/n_tty.c:2131
2 locks held by getty/4470:
  #0: 0000000064592345 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x37/0x40 drivers/tty/tty_ldsem.c:365
  #1: 00000000b1fec5aa (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x321/0x1cc0 drivers/tty/n_tty.c:2131
2 locks held by getty/4471:
  #0: 000000004ec951f3 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x37/0x40 drivers/tty/tty_ldsem.c:365
  #1: 00000000448836e6 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x321/0x1cc0 drivers/tty/n_tty.c:2131
2 locks held by getty/4472:
  #0: 00000000016ad281 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x37/0x40 drivers/tty/tty_ldsem.c:365
  #1: 000000003741a7c3 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x321/0x1cc0 drivers/tty/n_tty.c:2131
2 locks held by getty/4473:
  #0: 00000000716ec5e4 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x37/0x40 drivers/tty/tty_ldsem.c:365
  #1: 00000000290eabf3 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x321/0x1cc0 drivers/tty/n_tty.c:2131
2 locks held by getty/4474:
  #0: 0000000028994fb2 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x37/0x40 drivers/tty/tty_ldsem.c:365
  #1: 000000009d0fb4da (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x321/0x1cc0 drivers/tty/n_tty.c:2131
2 locks held by syz-executor6/7855:
  #0: 0000000035229bc9 (sb_writers#4){.+.+}, at: file_start_write  
include/linux/fs.h:2718 [inline]
  #0: 0000000035229bc9 (sb_writers#4){.+.+}, at: do_sendfile+0xb05/0xe00  
fs/read_write.c:1439
  #1: 00000000aa98361f (&sb->s_type->i_mutex_key#10){++++}, at:  
inode_lock_shared include/linux/fs.h:723 [inline]
  #1: 00000000aa98361f (&sb->s_type->i_mutex_key#10){++++}, at:  
ext4_direct_IO_read fs/ext4/inode.c:3828 [inline]
  #1: 00000000aa98361f (&sb->s_type->i_mutex_key#10){++++}, at:  
ext4_direct_IO+0x653/0x2110 fs/ext4/inode.c:3865

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 892 Comm: khungtaskd Not tainted 4.17.0-rc4+ #46
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1b9/0x294 lib/dump_stack.c:113
  nmi_cpu_backtrace.cold.4+0x19/0xce lib/nmi_backtrace.c:103
  nmi_trigger_cpumask_backtrace+0x151/0x192 lib/nmi_backtrace.c:62
  arch_trigger_cpumask_backtrace+0x14/0x20 arch/x86/kernel/apic/hw_nmi.c:38
  trigger_all_cpu_backtrace include/linux/nmi.h:138 [inline]
  check_hung_task kernel/hung_task.c:132 [inline]
  check_hung_uninterruptible_tasks kernel/hung_task.c:190 [inline]
  watchdog+0xc10/0xf60 kernel/hung_task.c:249
  kthread+0x345/0x410 kernel/kthread.c:240
  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:412
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0 skipped: idling at native_safe_halt+0x6/0x10  
arch/x86/include/asm/irqflags.h:54


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with  
syzbot.
