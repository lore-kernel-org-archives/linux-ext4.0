From: syzbot <syzbot+f8d6f8386ceacdbfff57@syzkaller.appspotmail.com>
Subject: KASAN: slab-out-of-bounds Write in __ext4_expand_extra_isize
Date: Mon, 03 Sep 2018 02:24:03 -0700
Message-ID: <00000000000029554c0574f41ae4@google.com>
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

HEAD commit:    a880148cb2af Add linux-next specific files for 20180831
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=135f5e0a400000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a059d319ef7d83f6
dashboard link: https://syzkaller.appspot.com/bug?extid=f8d6f8386ceacdbfff57
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+f8d6f8386ceacdbfff57@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in memset include/linux/string.h:330 [inline]
BUG: KASAN: slab-out-of-bounds in __ext4_expand_extra_isize+0x178/0x240  
fs/ext4/inode.c:5863
Write of size 167772160 at addr ffff8801c3a03480 by task syz-executor1/27592
BUG: unable to handle kernel paging request at ffff8801d7ff9da8

PGD a5e9067
CPU: 0 PID: 27592 Comm: syz-executor1 Not tainted 4.19.0-rc1-next-20180831+  
#53
P4D a5e9067 PUD 1d9ea8063
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
PMD 1c6294063
Call Trace:
PTE 0
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1c9/0x2b4 lib/dump_stack.c:113
Oops: 0000 [#1] SMP KASAN
CPU: 1 PID: 27610 Comm: syz-executor2 Not tainted 4.19.0-rc1-next-20180831+  
#53
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:lookup_object lib/debugobjects.c:157 [inline]
RIP: 0010:debug_object_deactivate+0x19b/0x450 lib/debugobjects.c:543
  print_address_description+0x6c/0x20b mm/kasan/report.c:256
Code: 00 00 48 85 db 74 46 48 b8 00 00 00 00 00 fc ff df 48 8d 7b 18 41 83  
c7 01 48 89 fe 48 c1 ee 03 80 3c 06 00 0f 85 04 02 00 00 <48> 3b 53 18 0f  
84 53 01 00 00 48 89 de 48 c1 ee 03 80 3c 06 00 0f
RSP: 0018:ffff8801db107a90 EFLAGS: 00010046
  kasan_report_error mm/kasan/report.c:354 [inline]
  kasan_report.cold.7+0x242/0x30d mm/kasan/report.c:412
RAX: dffffc0000000000 RBX: ffff8801d7ff9d90 RCX: ffffffff8160b0d1
  check_memory_region_inline mm/kasan/kasan.c:260 [inline]
  check_memory_region+0x13e/0x1b0 mm/kasan/kasan.c:267
RDX: ffff8801db1265a0 RSI: 1ffff1003afff3b5 RDI: ffff8801d7ff9da8
  memset+0x23/0x40 mm/kasan/kasan.c:285
RBP: ffff8801db107b48 R08: fffffbfff13a35da R09: fffffbfff13a35d9
  memset include/linux/string.h:330 [inline]
  __ext4_expand_extra_isize+0x178/0x240 fs/ext4/inode.c:5863
R10: fffffbfff13a35d9 R11: ffffffff89d1aecb R12: 1ffff1003b620f54
  ext4_try_to_expand_extra_isize fs/ext4/inode.c:5915 [inline]
  ext4_mark_inode_dirty+0x88f/0xab0 fs/ext4/inode.c:5991
R13: ffffffff89d1aec8 R14: ffffffff881a1ea0 R15: 000000000000000b
FS:  0000000001368940(0000) GS:ffff8801db100000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff8801d7ff9da8 CR3: 00000001cc9bc000 CR4: 00000000001406e0
Call Trace:
  <IRQ>
  debug_hrtimer_deactivate kernel/time/hrtimer.c:421 [inline]
  debug_deactivate kernel/time/hrtimer.c:471 [inline]
  __run_hrtimer kernel/time/hrtimer.c:1368 [inline]
  __hrtimer_run_queues+0x2b6/0xff0 kernel/time/hrtimer.c:1460
  ext4_dirty_inode+0x97/0xc0 fs/ext4/inode.c:6025
  __mark_inode_dirty+0x760/0x1300 fs/fs-writeback.c:2129
  hrtimer_interrupt+0x2f3/0x750 kernel/time/hrtimer.c:1518
  local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1029 [inline]
  smp_apic_timer_interrupt+0x16d/0x6a0 arch/x86/kernel/apic/apic.c:1054
  mark_inode_dirty_sync include/linux/fs.h:2088 [inline]
  dquot_free_space include/linux/quotaops.h:373 [inline]
  dquot_free_block include/linux/quotaops.h:383 [inline]
  ext4_free_blocks+0x1828/0x2980 fs/ext4/mballoc.c:4919
  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:867
  </IRQ>
RIP: 0010:memset_erms+0x9/0x10 arch/x86/lib/memset_64.S:65
Code: c1 e9 03 40 0f b6 f6 48 b8 01 01 01 01 01 01 01 01 48 0f af c6 f3 48  
ab 89 d1 f3 aa 4c 89 c8 c3 90 49 89 f9 40 88 f0 48 89 d1 <f3> aa 4c 89 c8  
c3 90 49 89 fa 40 0f b6 ce 48 b8 01 01 01 01 01 01
RSP: 0018:ffff88018874f3c0 EFLAGS: 00010282
  ORIG_RAX: ffffffffffffff13
RAX: 0000000000000000 RBX: ffff8801c3a03580 RCX: 0000000007677c40
RDX: 000000000a000000 RSI: 0000000000000000 RDI: ffff8801c638b940
  ext4_remove_blocks fs/ext4/extents.c:2561 [inline]
  ext4_ext_rm_leaf fs/ext4/extents.c:2717 [inline]
  ext4_ext_remove_space+0x2372/0x49e0 fs/ext4/extents.c:2950
RBP: ffff88018874f3e0 R08: ffffed0038780008 R09: ffff8801c3a03580
R10: ffffed0039b406af R11: ffff8801cda0357f R12: 000000000a000000
R13: 0000000000000000 R14: ffff8801c3a03580 R15: 000000000a000000
  memset include/linux/string.h:330 [inline]
  __ext4_expand_extra_isize+0x178/0x240 fs/ext4/inode.c:5863
  ext4_try_to_expand_extra_isize fs/ext4/inode.c:5915 [inline]
  ext4_mark_inode_dirty+0x88f/0xab0 fs/ext4/inode.c:5991
  ext4_ext_tree_init+0x105/0x140 fs/ext4/extents.c:856
  __ext4_new_inode+0x5433/0x64e0 fs/ext4/ialloc.c:1169
  ext4_ext_truncate+0x1d1/0x220 fs/ext4/extents.c:4644
  ext4_truncate+0xe8d/0x1550 fs/ext4/inode.c:4500
  ext4_setattr+0x1821/0x2850 fs/ext4/inode.c:5606
  notify_change+0xbde/0x1110 fs/attr.c:334
  do_truncate+0x1ac/0x2b0 fs/open.c:63
  handle_truncate fs/namei.c:3008 [inline]
  do_last fs/namei.c:3424 [inline]
  path_openat+0x34e3/0x5340 fs/namei.c:3534
  ext4_symlink+0x4d6/0x1170 fs/ext4/namei.c:3093
  vfs_symlink+0x37a/0x5d0 fs/namei.c:4127
  do_symlinkat+0x242/0x2d0 fs/namei.c:4154
  __do_sys_symlink fs/namei.c:4173 [inline]
  __se_sys_symlink fs/namei.c:4171 [inline]
  __x64_sys_symlink+0x59/0x80 fs/namei.c:4171
  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
  do_filp_open+0x255/0x380 fs/namei.c:3564
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x456dc7
  do_sys_open+0x584/0x720 fs/open.c:1063
Code: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 <00> 00 00 00 00  
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
RSP: 002b:00007ffea49403a8 EFLAGS: 00000202
  ORIG_RAX: 0000000000000058
RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 0000000000456dc7
  __do_sys_openat fs/open.c:1090 [inline]
  __se_sys_openat fs/open.c:1084 [inline]
  __x64_sys_openat+0x9d/0x100 fs/open.c:1084
RDX: 00007ffea49403f7 RSI: 00000000004c280c RDI: 00007ffea49403e0
  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000017
R10: 0000000000000075 R11: 0000000000000202 R12: 000000000000000d
R13: 0000000000089efb R14: 000000000000014c R15: badc0ffeebadface
Modules linked in:
Dumping ftrace buffer:
    (ftrace buffer empty)
CR2: ffff8801d7ff9da8
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
---[ end trace 5682ca918272dd25 ]---
RIP: 0033:0x457099
RIP: 0010:lookup_object lib/debugobjects.c:157 [inline]
RIP: 0010:debug_object_deactivate+0x19b/0x450 lib/debugobjects.c:543
Code: fd b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00
Code: 00 00 48 85 db 74 46 48 b8 00 00 00 00 00 fc ff df 48 8d 7b 18 41 83  
c7 01 48 89 fe 48 c1 ee 03 80 3c 06 00 0f 85 04 02 00 00 <48> 3b 53 18 0f  
84 53 01 00 00 48 89 de 48 c1 ee 03 80 3c 06 00 0f
RSP: 002b:00007f6a539afc78 EFLAGS: 00000246
RSP: 0018:ffff8801db107a90 EFLAGS: 00010046
  ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 00007f6a539b06d4 RCX: 0000000000457099
RAX: dffffc0000000000 RBX: ffff8801d7ff9d90 RCX: ffffffff8160b0d1
RDX: 0000000000002761 RSI: 0000000020000200 RDI: ffffffffffffffff
RDX: ffff8801db1265a0 RSI: 1ffff1003afff3b5 RDI: ffff8801d7ff9da8
RBP: 00000000009300a0 R08: 0000000000000000 R09: 0000000000000000
RBP: ffff8801db107b48 R08: fffffbfff13a35da R09: fffffbfff13a35d9
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R10: fffffbfff13a35d9 R11: ffffffff89d1aecb R12: 1ffff1003b620f54
R13: 00000000004d3318 R14: 00000000004c819c R15: 0000000000000000
R13: ffffffff89d1aec8 R14: ffffffff881a1ea0 R15: 000000000000000b

FS:  0000000001368940(0000) GS:ffff8801db100000(0000) knlGS:0000000000000000
The buggy address belongs to the page:
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
page:ffffea00070e80c0 count:2 mapcount:0 mapping:ffff8801cd439658  
index:0x4ab
CR2: ffff8801d7ff9da8 CR3: 00000001cc9bc000 CR4: 00000000001406e0


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with  
syzbot.
