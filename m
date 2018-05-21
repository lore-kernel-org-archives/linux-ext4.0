From: syzbot <syzbot+9a44753ac327c557796a@syzkaller.appspotmail.com>
Subject: Re: WARNING in ext4_set_page_dirty
Date: Sun, 20 May 2018 23:07:02 -0700
Message-ID: <0000000000003a8d73056cb11ca3@google.com>
References: <089e0825cec8180a2b0568c4ee1d@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
To: adilger.kernel@dilger.ca, jack@suse.cz, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tytso@mit.edu
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <089e0825cec8180a2b0568c4ee1d@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    771c577c23ba Linux 4.17-rc6
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=108c9f37800000
kernel config:  https://syzkaller.appspot.com/x/.config?x=982e2df1b9e60b02
dashboard link: https://syzkaller.appspot.com/bug?extid=9a44753ac327c557796a
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
syzkaller repro:https://syzkaller.appspot.com/x/repro.syz?x=1655584f800000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15134357800000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+9a44753ac327c557796a@syzkaller.appspotmail.com

WARNING: CPU: 0 PID: 4577 at fs/ext4/inode.c:3894  
ext4_set_page_dirty+0x28d/0x330 fs/ext4/inode.c:3894
Kernel panic - not syncing: panic_on_warn set ...

CPU: 0 PID: 4577 Comm: syz-executor342 Not tainted 4.17.0-rc6+ #61
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1b9/0x294 lib/dump_stack.c:113
  panic+0x22f/0x4de kernel/panic.c:184
  __warn.cold.8+0x163/0x1b3 kernel/panic.c:536
  report_bug+0x252/0x2d0 lib/bug.c:186
  fixup_bug arch/x86/kernel/traps.c:178 [inline]
  do_error_trap+0x1de/0x490 arch/x86/kernel/traps.c:296
  do_invalid_op+0x1b/0x20 arch/x86/kernel/traps.c:315
  invalid_op+0x14/0x20 arch/x86/entry/entry_64.S:992
RIP: 0010:ext4_set_page_dirty+0x28d/0x330 fs/ext4/inode.c:3894
RSP: 0018:ffff8801b38fe2a0 EFLAGS: 00010293
RAX: ffff8801aca16680 RBX: 1ffff1003671fc56 RCX: ffffffff82052441
RDX: 0000000000000000 RSI: ffffffff8205248d RDI: 0000000000000007
RBP: ffff8801b38fe378 R08: ffff8801aca16680 R09: 0000000000000006
R10: ffff8801aca16680 R11: 0000000000000000 R12: ffffea0007007f40
R13: 0000000000000000 R14: ffff8801b38fe350 R15: ffffea0007007f60
  set_page_dirty+0x35f/0x6d0 mm/page-writeback.c:2566
  set_page_dirty_lock+0x115/0x180 mm/page-writeback.c:2591
  dio_bio_complete+0x599/0x870 fs/direct-io.c:559
  dio_await_completion fs/direct-io.c:580 [inline]
  do_blockdev_direct_IO+0x4153/0x9e90 fs/direct-io.c:1388
  __blockdev_direct_IO+0x9d/0xc6 fs/direct-io.c:1417
  ext4_direct_IO_read fs/ext4/inode.c:3833 [inline]
  ext4_direct_IO+0xf90/0x2110 fs/ext4/inode.c:3865
  generic_file_read_iter+0x510/0x2f00 mm/filemap.c:2341
  ext4_file_read_iter+0x18b/0x3c0 fs/ext4/file.c:77
  call_read_iter include/linux/fs.h:1778 [inline]
  new_sync_read fs/read_write.c:406 [inline]
  __vfs_read+0x696/0xa50 fs/read_write.c:418
  vfs_read+0x17f/0x3d0 fs/read_write.c:452
  ksys_pread64+0x174/0x1a0 fs/read_write.c:626
  __do_sys_pread64 fs/read_write.c:636 [inline]
  __se_sys_pread64 fs/read_write.c:633 [inline]
  __x64_sys_pread64+0x97/0xf0 fs/read_write.c:633
  do_syscall_64+0x1b1/0x800 arch/x86/entry/common.c:287
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x445c09
RSP: 002b:00007f4eead2ad18 EFLAGS: 00000246 ORIG_RAX: 0000000000000011
RAX: ffffffffffffffda RBX: 00000000006dac74 RCX: 0000000000445c09
RDX: 00000000fffffd80 RSI: 0000000020002000 RDI: 0000000000000073
RBP: 0000000000000000 R08: 65732f636f72702f R09: 65732f636f72702f
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006dac70
R13: 00007f4eead2ad20 R14: 2e64657473757274 R15: 000000000000000b
Dumping ftrace buffer:
    (ftrace buffer empty)
Kernel Offset: disabled
Rebooting in 86400 seconds..
