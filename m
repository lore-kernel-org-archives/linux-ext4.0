From: syzbot <syzbot+ef7ef285f528e7ccbbcc@syzkaller.appspotmail.com>
Subject: INFO: task hung in ext4_file_write_iter
Date: Mon, 07 May 2018 08:46:02 -0700
Message-ID: <0000000000001fb048056b9f9138@google.com>
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

HEAD commit:    701e39d05119 Merge tag 'for-linus' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=133b4be7800000
kernel config:  https://syzkaller.appspot.com/x/.config?x=889265cebaf9bda1
dashboard link: https://syzkaller.appspot.com/bug?extid=ef7ef285f528e7ccbbcc
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+ef7ef285f528e7ccbbcc@syzkaller.appspotmail.com

INFO: task syz-executor4:9599 blocked for more than 120 seconds.
       Not tainted 4.17.0-rc3+ #36
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor4   D20392  9599   4593 0x00000004
Call Trace:
  context_switch kernel/sched/core.c:2848 [inline]
  __schedule+0x801/0x1e30 kernel/sched/core.c:3490
  schedule+0xef/0x430 kernel/sched/core.c:3549
  __rwsem_down_write_failed_common+0x919/0x15d0  
kernel/locking/rwsem-xadd.c:566
  rwsem_down_write_failed+0xe/0x10 kernel/locking/rwsem-xadd.c:595
  call_rwsem_down_write_failed+0x17/0x30 arch/x86/lib/rwsem.S:117
  __down_write arch/x86/include/asm/rwsem.h:142 [inline]
  down_write+0xa2/0x120 kernel/locking/rwsem.c:72
  inode_lock include/linux/fs.h:713 [inline]
  ext4_file_write_iter+0x303/0x1420 fs/ext4/file.c:235
  call_write_iter include/linux/fs.h:1784 [inline]
  new_sync_write fs/read_write.c:474 [inline]
  __vfs_write+0x64d/0x960 fs/read_write.c:487
  vfs_write+0x1f8/0x560 fs/read_write.c:549
  ksys_pwrite64+0x174/0x1a0 fs/read_write.c:652
  __do_sys_pwrite64 fs/read_write.c:662 [inline]
  __se_sys_pwrite64 fs/read_write.c:659 [inline]
  __x64_sys_pwrite64+0x97/0xf0 fs/read_write.c:659
  do_syscall_64+0x1b1/0x800 arch/x86/entry/common.c:287
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x455979
RSP: 002b:00007f9966448c68 EFLAGS: 00000246 ORIG_RAX: 0000000000000012
RAX: ffffffffffffffda RBX: 00007f99664496d4 RCX: 0000000000455979
RDX: 000000007e39d7f0 RSI: 0000000020000000 RDI: 0000000000000014
RBP: 000000000072bea0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 00000000000004d2 R14: 00000000006fb450 R15: 0000000000000000

Showing all locks held in the system:
2 locks held by khungtaskd/892:
  #0: 00000000a327422a (rcu_read_lock){....}, at:  
check_hung_uninterruptible_tasks kernel/hung_task.c:175 [inline]
  #0: 00000000a327422a (rcu_read_lock){....}, at: watchdog+0x1ff/0xf60  
kernel/hung_task.c:249
  #1: 000000006ac4652a (tasklist_lock){.+.+}, at:  
debug_show_all_locks+0xde/0x34a kernel/locking/lockdep.c:4470
2 locks held by getty/4517:
  #0: 000000006226c432 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x37/0x40 drivers/tty/tty_ldsem.c:365
  #1: 0000000011818b9b (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x321/0x1cc0 drivers/tty/n_tty.c:2131
2 locks held by getty/4518:
  #0: 000000004ece233d (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x37/0x40 drivers/tty/tty_ldsem.c:365
  #1: 000000001a207854 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x321/0x1cc0 drivers/tty/n_tty.c:2131
2 locks held by getty/4519:
  #0: 00000000cfe6a8f6 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x37/0x40 drivers/tty/tty_ldsem.c:365
  #1: 00000000aec0bd4b (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x321/0x1cc0 drivers/tty/n_tty.c:2131
2 locks held by getty/4520:
  #0: 00000000acce626b (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x37/0x40 drivers/tty/tty_ldsem.c:365
  #1: 0000000028af0e0c (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x321/0x1cc0 drivers/tty/n_tty.c:2131
2 locks held by getty/4521:
  #0: 00000000a35a889c (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x37/0x40 drivers/tty/tty_ldsem.c:365
  #1: 0000000091d6649a (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x321/0x1cc0 drivers/tty/n_tty.c:2131
2 locks held by getty/4522:
  #0: 00000000978c6904 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x37/0x40 drivers/tty/tty_ldsem.c:365
  #1: 0000000018a94478 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x321/0x1cc0 drivers/tty/n_tty.c:2131
2 locks held by getty/25579:
  #0: 0000000017c5a368 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x37/0x40 drivers/tty/tty_ldsem.c:365
  #1: 0000000002f355d6 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x321/0x1cc0 drivers/tty/n_tty.c:2131
2 locks held by syz-executor4/9599:
  #0: 00000000560b168a (sb_writers#4){.+.+}, at: file_start_write  
include/linux/fs.h:2718 [inline]
  #0: 00000000560b168a (sb_writers#4){.+.+}, at: vfs_write+0x452/0x560  
fs/read_write.c:548
  #1: 000000001f46dc22 (&sb->s_type->i_mutex_key#10){++++}, at: inode_lock  
include/linux/fs.h:713 [inline]
  #1: 000000001f46dc22 (&sb->s_type->i_mutex_key#10){++++}, at:  
ext4_file_write_iter+0x303/0x1420 fs/ext4/file.c:235
2 locks held by syz-executor2/9654:
  #0: 00000000560b168a (sb_writers#4){.+.+}, at: file_start_write  
include/linux/fs.h:2718 [inline]
  #0: 00000000560b168a (sb_writers#4){.+.+}, at: vfs_writev+0x293/0x330  
fs/read_write.c:1003
  #1: 000000001f46dc22 (&sb->s_type->i_mutex_key#10){++++}, at: inode_lock  
include/linux/fs.h:713 [inline]
  #1: 000000001f46dc22 (&sb->s_type->i_mutex_key#10){++++}, at:  
ext4_file_write_iter+0x303/0x1420 fs/ext4/file.c:235
3 locks held by syz-executor2/9656:
  #0: 000000000f96ff50 (&f->f_pos_lock){+.+.}, at: __fdget_pos+0x1a9/0x1e0  
fs/file.c:766
  #1: 00000000560b168a (sb_writers#4){.+.+}, at: file_start_write  
include/linux/fs.h:2718 [inline]
  #1: 00000000560b168a (sb_writers#4){.+.+}, at: vfs_writev+0x293/0x330  
fs/read_write.c:1003
  #2: 000000001f46dc22 (&sb->s_type->i_mutex_key#10){++++}, at: inode_lock  
include/linux/fs.h:713 [inline]
  #2: 000000001f46dc22 (&sb->s_type->i_mutex_key#10){++++}, at:  
ext4_file_write_iter+0x303/0x1420 fs/ext4/file.c:235
2 locks held by syz-executor2/9657:
  #0: 00000000560b168a (sb_writers#4){.+.+}, at: sb_start_write  
include/linux/fs.h:1550 [inline]
  #0: 00000000560b168a (sb_writers#4){.+.+}, at:  
do_sys_ftruncate+0x290/0x560 fs/open.c:200
  #1: 000000001f46dc22 (&sb->s_type->i_mutex_key#10){++++}, at: inode_lock  
include/linux/fs.h:713 [inline]
  #1: 000000001f46dc22 (&sb->s_type->i_mutex_key#10){++++}, at:  
do_truncate+0x197/0x2a0 fs/open.c:61

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 892 Comm: khungtaskd Not tainted 4.17.0-rc3+ #36
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
  kthread+0x345/0x410 kernel/kthread.c:238
  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:412
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 9628 Comm: syz-executor2 Not tainted 4.17.0-rc3+ #36
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:__sanitizer_cov_trace_pc+0x1/0x50 kernel/kcov.c:94
RSP: 0018:ffff88018b8f6c70 EFLAGS: 00000286
RAX: 0000000000000002 RBX: ffff8801d4f3ab78 RCX: ffffffff8768d06f
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000007
RBP: ffff88018b8f6f20 R08: ffff8801b1d902c0 R09: ffffed003b5c46c2
R10: ffffed003b5c46c2 R11: ffff8801dae23613 R12: ffffed003171edb7
R13: 0000000000000031 R14: 0000000000000000 R15: ffff8801d4f3a9c0
FS:  00007f605caa9700(0000) GS:ffff8801dae00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffff600400 CR3: 000000018bec8000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  find_get_entries+0x858/0x1020 mm/filemap.c:1636
  pagevec_lookup_entries+0x3a/0x80 mm/swap.c:947
  truncate_inode_pages_range+0x36c/0x25a0 mm/truncate.c:331
  truncate_inode_pages mm/truncate.c:478 [inline]
  truncate_pagecache+0x66/0x90 mm/truncate.c:801
  ext4_setattr+0x1bfb/0x2ac0 fs/ext4/inode.c:5530
  notify_change+0xbef/0x10c0 fs/attr.c:313
  do_truncate+0x1a4/0x2a0 fs/open.c:63
  do_sys_ftruncate+0x492/0x560 fs/open.c:205
  __do_sys_ftruncate fs/open.c:215 [inline]
  __se_sys_ftruncate fs/open.c:213 [inline]
  __x64_sys_ftruncate+0x59/0x80 fs/open.c:213
  do_syscall_64+0x1b1/0x800 arch/x86/entry/common.c:287
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x455979
RSP: 002b:00007f605caa8c68 EFLAGS: 00000246 ORIG_RAX: 000000000000004d
RAX: ffffffffffffffda RBX: 00007f605caa96d4 RCX: 0000000000455979
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000017
RBP: 000000000072bea0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 00000000000000a2 R14: 00000000006f4fd0 R15: 0000000000000000
Code: 14 dd 28 00 00 00 4d 39 d0 72 1b 49 83 c1 01 4a 89 7c 10 e0 4a 89 74  
10 e8 4a 89 54 10 f0 4a 89 4c d8 20 4c 89 08 5d c3 66 90 55 <65> 48 8b 04  
25 c0 ed 01 00 65 8b 15 0f b0 88 7e 48 89 e5 81 e2
INFO: NMI handler (nmi_cpu_backtrace_handler) took too long to run: 1.159  
msecs


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report.
If you forgot to add the Reported-by tag, once the fix for this bug is  
merged
into any tree, please reply to this email with:
#syz fix: exact-commit-title
To mark this as a duplicate of another syzbot report, please reply with:
#syz dup: exact-subject-of-another-report
If it's a one-off invalid bug report, please reply with:
#syz invalid
Note: if the crash happens again, it will cause creation of a new bug  
report.
Note: all commands must start from beginning of the line in the email body.
