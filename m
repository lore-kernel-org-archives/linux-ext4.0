From: syzbot <syzbot+2202a584a00fffd19fbf@syzkaller.appspotmail.com>
Subject: WARNING in ext4_put_io_end_defer
Date: Mon, 11 Jun 2018 10:53:02 -0700
Message-ID: <000000000000c98a37056e616b45@google.com>
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

HEAD commit:    1aaccb5fa0ea Merge tag 'rtc-4.18' of git://git.kernel.org/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=177a36af800000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fa9c20c48788d1c1
dashboard link: https://syzkaller.appspot.com/bug?extid=2202a584a00fffd19fbf
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+2202a584a00fffd19fbf@syzkaller.appspotmail.com

RAX: ffffffffffffffda RBX: 0000000020000500 RCX: 0000000000455867
RDX: 0000000000000000 RSI: 0000000000004c01 RDI: 0000000000000015
RBP: 0000000000000000 R08: 0000000020000200 R09: 0000000020000500
R10: 000000000010a034 R11: 0000000000000246 R12: 0000000000000014
R13: 0000000000000000 R14: 00000000004d2c08 R15: 0000000000000020
WARNING: CPU: 0 PID: 2416 at fs/ext4/page-io.c:206 ext4_add_complete_io  
fs/ext4/page-io.c:206 [inline]
WARNING: CPU: 0 PID: 2416 at fs/ext4/page-io.c:206  
ext4_put_io_end_defer+0x430/0x580 fs/ext4/page-io.c:269
Kernel panic - not syncing: panic_on_warn set ...

CPU: 0 PID: 2416 Comm: udevd Not tainted 4.17.0+ #95
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  <IRQ>
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1b9/0x294 lib/dump_stack.c:113
  panic+0x22f/0x4de kernel/panic.c:184
  __warn.cold.8+0x163/0x1b3 kernel/panic.c:536
  report_bug+0x252/0x2d0 lib/bug.c:186
  fixup_bug arch/x86/kernel/traps.c:178 [inline]
  do_error_trap+0x1fc/0x4d0 arch/x86/kernel/traps.c:296
  do_invalid_op+0x1b/0x20 arch/x86/kernel/traps.c:316
  invalid_op+0x14/0x20 arch/x86/entry/entry_64.S:992
RIP: 0010:ext4_add_complete_io fs/ext4/page-io.c:206 [inline]
RIP: 0010:ext4_put_io_end_defer+0x430/0x580 fs/ext4/page-io.c:269
Code: 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 59 01 00 00  
49 83 bf e0 02 00 00 00 0f 84 d9 fd ff ff e8 60 28 69 ff <0f> 0b e9 cd fd  
ff ff e8 94 4e a6 ff e9 89 fc ff ff 48 89 b5 20 ff
RSP: 0018:ffff8801dae07140 EFLAGS: 00010006
RAX: ffff8801cae8c780 RBX: 1ffff1003b5c0e2d RCX: ffffffff821111c6
RDX: 0000000000010000 RSI: ffffffff821114e0 RDI: ffff8801cc4347a0
RBP: ffff8801dae07230 R08: ffff8801cae8c780 R09: ffffed002f401fd9
R10: ffffed002f401fd9 R11: ffff88017a00fecf R12: ffff88017a00fea0
R13: ffff880175a9c970 R14: ffff8801dae07208 R15: ffff8801cc4344c0
  ext4_end_bio+0x234/0x6d0 fs/ext4/page-io.c:335
  bio_endio+0x51c/0x9c0 block/bio.c:1836
  req_bio_endio block/blk-core.c:281 [inline]
  blk_update_request+0x3aa/0xcb0 block/blk-core.c:3091
  scsi_end_request+0xd3/0x870 drivers/scsi/scsi_lib.c:672
  scsi_io_completion+0xcb2/0x1db0 drivers/scsi/scsi_lib.c:898
  scsi_finish_command+0x542/0x8d0 drivers/scsi/scsi.c:248
  scsi_softirq_done+0x3e2/0x4c0 drivers/scsi/scsi_lib.c:1687
  __blk_mq_complete_request block/blk-mq.c:583 [inline]
  blk_mq_complete_request+0x355/0x630 block/blk-mq.c:620
  scsi_mq_done+0xe2/0x430 drivers/scsi/scsi_lib.c:1998
  virtscsi_complete_cmd+0x573/0x740 drivers/scsi/virtio_scsi.c:207
  virtscsi_vq_done+0xc3/0x170 drivers/scsi/virtio_scsi.c:223
  virtscsi_req_done+0xa7/0xd0 drivers/scsi/virtio_scsi.c:238
  vring_interrupt+0x128/0x170 drivers/virtio/virtio_ring.c:950
  __handle_irq_event_percpu+0x1c0/0xad0 kernel/irq/handle.c:149
  handle_irq_event_percpu+0x98/0x1c0 kernel/irq/handle.c:189
  handle_irq_event+0xa7/0x135 kernel/irq/handle.c:206
  handle_edge_irq+0x20f/0x870 kernel/irq/chip.c:791
  generic_handle_irq_desc include/linux/irqdesc.h:159 [inline]
  handle_irq+0x18c/0x2e7 arch/x86/kernel/irq_64.c:77
  do_IRQ+0x78/0x190 arch/x86/kernel/irq.c:245
  common_interrupt+0xf/0xf arch/x86/entry/entry_64.S:642
  </IRQ>
RIP: 0010:arch_local_irq_restore arch/x86/include/asm/paravirt.h:783  
[inline]
RIP: 0010:__raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:160  
[inline]
RIP: 0010:_raw_spin_unlock_irqrestore+0xa1/0xc0  
kernel/locking/spinlock.c:184
Code: 68 a8 f1 88 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c  
02 00 75 21 48 83 3d fe dd 6e 01 00 74 0e 48 89 df 57 9d <0f> 1f 44 00 00  
eb bb 0f 0b 0f 0b e8 1f 99 34 fa eb 97 e8 18 99 34
RSP: 0018:ffff8801cae97980 EFLAGS: 00000286 ORIG_RAX: ffffffffffffffda
RAX: dffffc0000000000 RBX: 0000000000000286 RCX: 0000000000000000
RDX: 1ffffffff11e350d RSI: 0000000000000001 RDI: 0000000000000286
RBP: ffff8801cae97990 R08: ffffed003950c819 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff8801ca8640c0
R13: 0000000000000000 R14: ffff8801cae97ba8 R15: ffff8801caae1918
  spin_unlock_irqrestore include/linux/spinlock.h:365 [inline]
  ep_poll+0x357/0x11d0 fs/eventpoll.c:1824
  do_epoll_wait+0x1b0/0x200 fs/eventpoll.c:2190
  __do_sys_epoll_wait fs/eventpoll.c:2200 [inline]
  __se_sys_epoll_wait fs/eventpoll.c:2197 [inline]
  __x64_sys_epoll_wait+0x97/0xf0 fs/eventpoll.c:2197
  do_syscall_64+0x1b1/0x800 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x7fbecd751943
Code: 00 31 d2 48 29 c2 64 89 11 48 83 c8 ff eb ea 90 90 90 90 90 90 90 90  
83 3d b5 dc 2a 00 00 75 13 49 89 ca b8 e8 00 00 00 0f 05 <48> 3d 01 f0 ff  
ff 73 34 c3 48 83 ec 08 e8 3b c4 00 00 48 89 04 24
RSP: 002b:00007fffb1bb2698 EFLAGS: 00000246 ORIG_RAX: 00000000000000e8
RAX: ffffffffffffffda RBX: 0000000000000bb8 RCX: 00007fbecd751943
RDX: 0000000000000008 RSI: 00007fffb1bb2790 RDI: 000000000000000a
RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000001
R10: 0000000000000bb8 R11: 0000000000000246 R12: 0000000000000003
R13: 0000000000000000 R14: 0000000002569010 R15: 0000000002563250
Dumping ftrace buffer:
    (ftrace buffer empty)
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with  
syzbot.
