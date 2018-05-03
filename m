From: syzbot <syzbot+1e470567330b7ad711d5@syzkaller.appspotmail.com>
Subject: KASAN: use-after-free Read in ext4_data_block_valid
Date: Thu, 03 May 2018 00:38:02 -0700
Message-ID: <0000000000008631d3056b4848e1@google.com>
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

HEAD commit:    6da6c0db5316 Linux v4.17-rc3
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?id=5004455753809920
kernel config:   
https://syzkaller.appspot.com/x/.config?id=6493557782959164711
dashboard link: https://syzkaller.appspot.com/bug?extid=1e470567330b7ad711d5
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+1e470567330b7ad711d5@syzkaller.appspotmail.com

EXT4-fs (sda1): re-mounted. Opts: noblock_validity,
==================================================================
BUG: KASAN: use-after-free in ext4_data_block_valid+0x2df/0x340  
fs/ext4/block_validity.c:211
Read of size 8 at addr ffff8801cc464750 by task sh/17001

CPU: 0 PID: 17001 Comm: sh Not tainted 4.17.0-rc3+ #25
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1b9/0x294 lib/dump_stack.c:113
  print_address_description+0x6c/0x20b mm/kasan/report.c:256
  kasan_report_error mm/kasan/report.c:354 [inline]
  kasan_report.cold.7+0x242/0x2fe mm/kasan/report.c:412
  __asan_report_load8_noabort+0x14/0x20 mm/kasan/report.c:433
  ext4_data_block_valid+0x2df/0x340 fs/ext4/block_validity.c:211
  __check_block_validity.constprop.78+0xc1/0x200 fs/ext4/inode.c:402
  ext4_map_blocks+0x100b/0x1b40 fs/ext4/inode.c:592
  ext4_getblk+0x4d5/0x600 fs/ext4/inode.c:966
  ext4_bread_batch+0x7f/0x450 fs/ext4/inode.c:1036
  ext4_find_entry+0xd2a/0x1b50 fs/ext4/namei.c:1424
  ext4_lookup+0x149/0x730 fs/ext4/namei.c:1556
  lookup_open+0x71d/0x1b40 fs/namei.c:3165
  do_last fs/namei.c:3277 [inline]
  path_openat+0x2211/0x4e20 fs/namei.c:3501
  do_filp_open+0x249/0x350 fs/namei.c:3535
  do_open_execat+0x1f6/0x650 fs/exec.c:854
  do_execveat_common.isra.34+0x920/0x2590 fs/exec.c:1755
  do_execve fs/exec.c:1862 [inline]
  __do_sys_execve fs/exec.c:1943 [inline]
  __se_sys_execve fs/exec.c:1938 [inline]
  __x64_sys_execve+0x8d/0xb0 fs/exec.c:1938
  do_syscall_64+0x1b1/0x800 arch/x86/entry/common.c:287
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x7f06cf7c3207
RSP: 002b:00007ffdedae6df8 EFLAGS: 00000202 ORIG_RAX: 000000000000003b
RAX: ffffffffffffffda RBX: 000000000061c3e8 RCX: 00007f06cf7c3207
RDX: 00000000021a51d0 RSI: 000000000061c3e8 RDI: 00000000021a51e8
RBP: 00000000021a51e8 R08: 000000000061c370 R09: 00007f06cf83aa00
R10: 0000000000000000 R11: 0000000000000202 R12: 00000000021a51d0
R13: 00000000021a51d0 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 1:
  save_stack+0x43/0xd0 mm/kasan/kasan.c:448
  set_track mm/kasan/kasan.c:460 [inline]
  kasan_kmalloc+0xc4/0xe0 mm/kasan/kasan.c:553
  kasan_slab_alloc+0x12/0x20 mm/kasan/kasan.c:490
  kmem_cache_alloc+0x12e/0x760 mm/slab.c:3554
  add_system_zone+0x2e8/0x5f0 fs/ext4/block_validity.c:85
  ext4_setup_system_zone+0x208/0x520 fs/ext4/block_validity.c:169
  ext4_fill_super+0x790d/0xd810 fs/ext4/super.c:4257
  mount_bdev+0x30c/0x3e0 fs/super.c:1164
  ext4_mount+0x34/0x40 fs/ext4/super.c:5740
  mount_fs+0xae/0x328 fs/super.c:1267
  vfs_kern_mount.part.34+0xd4/0x4d0 fs/namespace.c:1037
  vfs_kern_mount fs/namespace.c:1027 [inline]
  do_new_mount fs/namespace.c:2518 [inline]
  do_mount+0x564/0x3070 fs/namespace.c:2848
  ksys_mount+0x12d/0x140 fs/namespace.c:3064
  do_mount_root+0x35/0x1d3 init/do_mounts.c:366
  mount_block_root+0x3d1/0x71f init/do_mounts.c:395
  mount_root+0x2c8/0x2fb init/do_mounts.c:540
  prepare_namespace+0x26c/0x2ab init/do_mounts.c:599
  kernel_init_freeable+0x570/0x58e init/main.c:1146
  kernel_init+0x11/0x1b3 init/main.c:1053
  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:412

Freed by task 16987:
  save_stack+0x43/0xd0 mm/kasan/kasan.c:448
  set_track mm/kasan/kasan.c:460 [inline]
  __kasan_slab_free+0x11a/0x170 mm/kasan/kasan.c:521
  kasan_slab_free+0xe/0x10 mm/kasan/kasan.c:528
  __cache_free mm/slab.c:3498 [inline]
  kmem_cache_free+0x86/0x2d0 mm/slab.c:3756
  ext4_release_system_zone+0x7c/0x110 fs/ext4/block_validity.c:187
  ext4_setup_system_zone+0x3ef/0x520 fs/ext4/block_validity.c:151
  ext4_remount+0x1420/0x2480 fs/ext4/super.c:5192
  do_remount_sb+0x348/0x790 fs/super.c:875
  do_remount fs/namespace.c:2339 [inline]
  do_mount+0x1445/0x3070 fs/namespace.c:2839
  ksys_mount+0x12d/0x140 fs/namespace.c:3064
  __do_sys_mount fs/namespace.c:3078 [inline]
  __se_sys_mount fs/namespace.c:3075 [inline]
  __x64_sys_mount+0xbe/0x150 fs/namespace.c:3075
  do_syscall_64+0x1b1/0x800 arch/x86/entry/common.c:287
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff8801cc464738
  which belongs to the cache ext4_system_zone of size 40
The buggy address is located 24 bytes inside of
  40-byte region [ffff8801cc464738, ffff8801cc464760)
The buggy address belongs to the page:
page:ffffea0007311900 count:1 mapcount:0 mapping:ffff8801cc464000  
index:0xffff8801cc464fb9
flags: 0x2fffc0000000100(slab)
raw: 02fffc0000000100 ffff8801cc464000 ffff8801cc464fb9 0000000100000007
raw: ffff8801d3e24b38 ffff8801d3e24b38 ffff8801d3e23080 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff8801cc464600: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff8801cc464680: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> ffff8801cc464700: fc fc fc fc fc fc fc fb fb fb fb fb fc fc fb fb
                                                  ^
  ffff8801cc464780: fb fb fb fc fc fb fb fb fb fb fc fc fb fb fb fb
  ffff8801cc464800: fb fc fc fb fb fb fb fb fc fc fb fb fb fb fb fc
==================================================================


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
