From: syzbot <syzbot+fe49aec75e221f9b093e@syzkaller.appspotmail.com>
Subject: possible deadlock in start_this_handle
Date: Fri, 07 Sep 2018 01:38:03 -0700
Message-ID: <000000000000005a89057543edbb@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
To: jack@suse.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tytso@mit.edu
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    ca16eb342ebe Merge tag 'for-linus-20180906' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=129e80ae400000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6c9564cd177daf0c
dashboard link: https://syzkaller.appspot.com/bug?extid=fe49aec75e221f9b093e
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+fe49aec75e221f9b093e@syzkaller.appspotmail.com

ISOFS: Unable to identify CD-ROM format.

======================================================
WARNING: possible circular locking dependency detected
4.19.0-rc2+ #2 Not tainted
------------------------------------------------------
kswapd0/1430 is trying to acquire lock:
0000000085a9412e (jbd2_handle){++++}, at: start_this_handle+0x589/0x1260  
fs/jbd2/transaction.c:383

but task is already holding lock:
00000000af99a839 (fs_reclaim){+.+.}, at: __page_frag_cache_refill  
mm/page_alloc.c:4476 [inline]
00000000af99a839 (fs_reclaim){+.+.}, at: __fs_reclaim_acquire+0x0/0x30  
mm/page_alloc.c:4505

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (fs_reclaim){+.+.}:
        __fs_reclaim_acquire mm/page_alloc.c:3728 [inline]
        fs_reclaim_acquire.part.98+0x24/0x30 mm/page_alloc.c:3739
        fs_reclaim_acquire+0x14/0x20 mm/page_alloc.c:3740
        slab_pre_alloc_hook mm/slab.h:418 [inline]
        slab_alloc mm/slab.c:3378 [inline]
        kmem_cache_alloc_trace+0x2d/0x730 mm/slab.c:3618
        kmalloc include/linux/slab.h:513 [inline]
        kzalloc include/linux/slab.h:707 [inline]
        smk_fetch.part.24+0x5a/0xf0 security/smack/smack_lsm.c:273
        smk_fetch security/smack/smack_lsm.c:3548 [inline]
        smack_d_instantiate+0x946/0xea0 security/smack/smack_lsm.c:3502
        security_d_instantiate+0x5c/0xf0 security/security.c:1287
        d_instantiate+0x5e/0xa0 fs/dcache.c:1870
        shmem_mknod+0x189/0x1f0 mm/shmem.c:2812
        vfs_mknod+0x447/0x800 fs/namei.c:3719
        handle_create+0x1ff/0x7c0 drivers/base/devtmpfs.c:211
        handle drivers/base/devtmpfs.c:374 [inline]
        devtmpfsd+0x27f/0x4c0 drivers/base/devtmpfs.c:400
        kthread+0x35a/0x420 kernel/kthread.c:246
        ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:413

-> #1 (&isp->smk_lock){+.+.}:
        __mutex_lock_common kernel/locking/mutex.c:925 [inline]
        __mutex_lock+0x171/0x1700 kernel/locking/mutex.c:1073
        mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1088
        smack_d_instantiate+0x130/0xea0 security/smack/smack_lsm.c:3369
        security_d_instantiate+0x5c/0xf0 security/security.c:1287
        d_instantiate_new+0x7e/0x160 fs/dcache.c:1889
        ext4_add_nondir+0x81/0x90 fs/ext4/namei.c:2415
        ext4_symlink+0x761/0x1170 fs/ext4/namei.c:3162
        vfs_symlink+0x37a/0x5d0 fs/namei.c:4127
        do_symlinkat+0x242/0x2d0 fs/namei.c:4154
        __do_sys_symlink fs/namei.c:4173 [inline]
        __se_sys_symlink fs/namei.c:4171 [inline]
        __x64_sys_symlink+0x59/0x80 fs/namei.c:4171
        do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
        entry_SYSCALL_64_after_hwframe+0x49/0xbe

-> #0 (jbd2_handle){++++}:
        lock_acquire+0x1e4/0x4f0 kernel/locking/lockdep.c:3901
        start_this_handle+0x5c0/0x1260 fs/jbd2/transaction.c:385
        jbd2__journal_start+0x3c9/0x9f0 fs/jbd2/transaction.c:439
        __ext4_journal_start_sb+0x18d/0x590 fs/ext4/ext4_jbd2.c:81
        __ext4_journal_start fs/ext4/ext4_jbd2.h:311 [inline]
        ext4_dirty_inode+0x62/0xc0 fs/ext4/inode.c:6021
        __mark_inode_dirty+0x760/0x1300 fs/fs-writeback.c:2129
        mark_inode_dirty_sync include/linux/fs.h:2072 [inline]
        iput+0x131/0xa00 fs/inode.c:1570
        dentry_unlink_inode+0x461/0x5e0 fs/dcache.c:374
        __dentry_kill+0x44c/0x7a0 fs/dcache.c:566
        shrink_dentry_list+0x322/0x7c0 fs/dcache.c:1079
        prune_dcache_sb+0x12f/0x1c0 fs/dcache.c:1171
        super_cache_scan+0x270/0x480 fs/super.c:102
        do_shrink_slab+0x4ba/0xbb0 mm/vmscan.c:536
        shrink_slab+0x389/0x8c0 mm/vmscan.c:686
        shrink_node+0x429/0x16a0 mm/vmscan.c:2735
        kswapd_shrink_node mm/vmscan.c:3457 [inline]
        balance_pgdat+0x7ca/0x1010 mm/vmscan.c:3567
        kswapd+0x82f/0x11e0 mm/vmscan.c:3789
        kthread+0x35a/0x420 kernel/kthread.c:246
        ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:413

other info that might help us debug this:

Chain exists of:
   jbd2_handle --> &isp->smk_lock --> fs_reclaim

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(fs_reclaim);
                                lock(&isp->smk_lock);
                                lock(fs_reclaim);
   lock(jbd2_handle);

  *** DEADLOCK ***

3 locks held by kswapd0/1430:
  #0: 00000000af99a839 (fs_reclaim){+.+.}, at: __page_frag_cache_refill  
mm/page_alloc.c:4476 [inline]
  #0: 00000000af99a839 (fs_reclaim){+.+.}, at: __fs_reclaim_acquire+0x0/0x30  
mm/page_alloc.c:4505
  #1: 000000003e78ad93 (shrinker_rwsem){++++}, at: shrink_slab+0x207/0x8c0  
mm/vmscan.c:676
  #2: 00000000e742ec1a (&type->s_umount_key#28){++++}, at:  
trylock_super+0x22/0x110 fs/super.c:412

stack backtrace:
CPU: 1 PID: 1430 Comm: kswapd0 Not tainted 4.19.0-rc2+ #2
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1c9/0x2b4 lib/dump_stack.c:113
  print_circular_bug.isra.34.cold.55+0x1bd/0x27d  
kernel/locking/lockdep.c:1222
  check_prev_add kernel/locking/lockdep.c:1862 [inline]
  check_prevs_add kernel/locking/lockdep.c:1975 [inline]
  validate_chain kernel/locking/lockdep.c:2416 [inline]
  __lock_acquire+0x3449/0x5020 kernel/locking/lockdep.c:3412
  lock_acquire+0x1e4/0x4f0 kernel/locking/lockdep.c:3901
  start_this_handle+0x5c0/0x1260 fs/jbd2/transaction.c:385
  jbd2__journal_start+0x3c9/0x9f0 fs/jbd2/transaction.c:439
  __ext4_journal_start_sb+0x18d/0x590 fs/ext4/ext4_jbd2.c:81
  __ext4_journal_start fs/ext4/ext4_jbd2.h:311 [inline]
  ext4_dirty_inode+0x62/0xc0 fs/ext4/inode.c:6021
  __mark_inode_dirty+0x760/0x1300 fs/fs-writeback.c:2129
  mark_inode_dirty_sync include/linux/fs.h:2072 [inline]
  iput+0x131/0xa00 fs/inode.c:1570
  dentry_unlink_inode+0x461/0x5e0 fs/dcache.c:374
  __dentry_kill+0x44c/0x7a0 fs/dcache.c:566
  shrink_dentry_list+0x322/0x7c0 fs/dcache.c:1079
  prune_dcache_sb+0x12f/0x1c0 fs/dcache.c:1171
  super_cache_scan+0x270/0x480 fs/super.c:102
  do_shrink_slab+0x4ba/0xbb0 mm/vmscan.c:536
  shrink_slab+0x389/0x8c0 mm/vmscan.c:686
  shrink_node+0x429/0x16a0 mm/vmscan.c:2735
  kswapd_shrink_node mm/vmscan.c:3457 [inline]
  balance_pgdat+0x7ca/0x1010 mm/vmscan.c:3567
  kswapd+0x82f/0x11e0 mm/vmscan.c:3789
  kthread+0x35a/0x420 kernel/kthread.c:246
  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:413
ISOFS: Unable to identify CD-ROM format.
ISOFS: Unable to identify CD-ROM format.
ISOFS: Unable to identify CD-ROM format.
REISERFS warning (device loop4): super-6502 reiserfs_getopt: unknown mount  
option "
esize="
ISOFS: Unable to identify CD-ROM format.
ISOFS: Unable to identify CD-ROM format.
ISOFS: Unable to identify CD-ROM format.
REISERFS warning (device loop4): super-6502 reiserfs_getopt: unknown mount  
option "
esize="
ISOFS: Unable to identify CD-ROM format.
FAULT_FLAG_ALLOW_RETRY missing 30
CPU: 1 PID: 323 Comm: syz-executor0 Not tainted 4.19.0-rc2+ #2
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1c9/0x2b4 lib/dump_stack.c:113
  handle_userfault.cold.33+0x43/0x52 fs/userfaultfd.c:432
  do_anonymous_page mm/memory.c:3164 [inline]
  handle_pte_fault mm/memory.c:3981 [inline]
  __handle_mm_fault+0x389e/0x4350 mm/memory.c:4107
  handle_mm_fault+0x53e/0xc80 mm/memory.c:4144
  __do_page_fault+0x620/0xe50 arch/x86/mm/fault.c:1395
  do_page_fault+0xf6/0x7a4 arch/x86/mm/fault.c:1470
  page_fault+0x1e/0x30 arch/x86/entry/entry_64.S:1161
RIP: 0010:copy_user_generic_unrolled+0x86/0xc0  
arch/x86/lib/copy_user_64.S:65
Code: 4c 8b 5e 38 4c 89 47 20 4c 89 4f 28 4c 89 57 30 4c 89 5f 38 48 8d 76  
40 48 8d 7f 40 ff c9 75 b6 89 d1 83 e2 07 c1 e9 03 74 12 <4c> 8b 06 4c 89  
07 48 8d 76 08 48 8d 7f 08 ff c9 75 ee 21 d2 74 10
RSP: 0018:ffff880164f67700 EFLAGS: 00010203
RAX: 0000000000000004 RBX: 000000000000000c RCX: 0000000000000001
RDX: 0000000000000004 RSI: 0000000020013ff4 RDI: ffff8801c49a14a0
RBP: ffff880164f67738 R08: ffffed0038934296 R09: ffffed0038934294
R10: ffffed0038934295 R11: 0000000000000003 R12: 0000000020014000
R13: 0000000020013ff4 R14: ffff8801c49a14a0 R15: 00007ffffffff000
  copy_from_user include/linux/uaccess.h:147 [inline]
  ip_options_get_from_user+0x8d/0xf0 net/ipv4/ip_options.c:537
  do_ip_setsockopt.isra.13+0x1ba6/0x3e70 net/ipv4/ip_sockglue.c:655
  ip_setsockopt+0x4c/0x140 net/ipv4/ip_sockglue.c:1249
  tcp_setsockopt+0x93/0xe0 net/ipv4/tcp.c:3062
  sock_common_setsockopt+0x9a/0xe0 net/core/sock.c:3038
  __sys_setsockopt+0x1c5/0x3b0 net/socket.c:1900
  __do_sys_setsockopt net/socket.c:1911 [inline]
  __se_sys_setsockopt net/socket.c:1908 [inline]
  __x64_sys_setsockopt+0xbe/0x150 net/socket.c:1908
  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x457099
Code: fd b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f20d1b5ec78 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 00007f20d1b5f6d4 RCX: 0000000000457099
RDX: 0000000000000004 RSI: 0900000000000000 RDI: 0000000000000006
RBP: 00000000009300a0 R08: 000000000000000c R09: 0000000000000000
R10: 0000000020013ff4 R11: 0000000000000246 R12: 00000000ffffffff
R13: 00000000004d58c8 R14: 00000000004c982a R15: 0000000000000000
ISOFS: Unable to identify CD-ROM format.
REISERFS warning (device loop4): super-6502 reiserfs_getopt: unknown mount  
option "%esize="
ISOFS: Unable to identify CD-ROM format.
ISOFS: Unable to identify CD-ROM format.
REISERFS warning (device loop4): super-6502 reiserfs_getopt: unknown mount  
option "%esize="
ISOFS: Unable to identify CD-ROM format.
REISERFS warning (device loop4): super-6502 reiserfs_getopt: unknown mount  
option "xesize="
ISOFS: Unable to identify CD-ROM format.
ISOFS: Unable to identify CD-ROM format.
ISOFS: Unable to identify CD-ROM format.
REISERFS warning (device loop4): super-6502 reiserfs_getopt: unknown mount  
option "xesize="
ISOFS: Unable to identify CD-ROM format.
ISOFS: Unable to identify CD-ROM format.
ISOFS: Unable to identify CD-ROM format.
ISOFS: Unable to identify CD-ROM format.
FAULT_FLAG_ALLOW_RETRY missing 30
CPU: 0 PID: 480 Comm: syz-executor0 Not tainted 4.19.0-rc2+ #2
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1c9/0x2b4 lib/dump_stack.c:113
  handle_userfault.cold.33+0x43/0x52 fs/userfaultfd.c:432
  do_anonymous_page mm/memory.c:3164 [inline]
  handle_pte_fault mm/memory.c:3981 [inline]
  __handle_mm_fault+0x389e/0x4350 mm/memory.c:4107
  handle_mm_fault+0x53e/0xc80 mm/memory.c:4144
ISOFS: Unable to identify CD-ROM format.
  __do_page_fault+0x620/0xe50 arch/x86/mm/fault.c:1395
  do_page_fault+0xf6/0x7a4 arch/x86/mm/fault.c:1470
ISOFS: Unable to identify CD-ROM format.
  page_fault+0x1e/0x30 arch/x86/entry/entry_64.S:1161
RIP: 0010:copy_user_generic_unrolled+0x86/0xc0  
arch/x86/lib/copy_user_64.S:65
Code: 4c 8b 5e 38 4c 89 47 20 4c 89 4f 28 4c 89 57 30 4c 89 5f 38 48 8d 76  
40 48 8d 7f 40 ff c9 75 b6 89 d1 83 e2 07 c1 e9 03 74 12 <4c> 8b 06 4c 89  
07 48 8d 76 08 48 8d 7f 08 ff c9 75 ee 21 d2 74 10
RSP: 0018:ffff880166f67700 EFLAGS: 00010203
RAX: 0000000000000004 RBX: 000000000000000c RCX: 0000000000000001
RDX: 0000000000000004 RSI: 0000000020013ff4 RDI: ffff8801c04690a0
RBP: ffff880166f67738 R08: ffffed003808d216 R09: ffffed003808d214
R10: ffffed003808d215 R11: 0000000000000003 R12: 0000000020014000
R13: 0000000020013ff4 R14: ffff8801c04690a0 R15: 00007ffffffff000
  copy_from_user include/linux/uaccess.h:147 [inline]
  ip_options_get_from_user+0x8d/0xf0 net/ipv4/ip_options.c:537
  do_ip_setsockopt.isra.13+0x1ba6/0x3e70 net/ipv4/ip_sockglue.c:655
ISOFS: Unable to identify CD-ROM format.
  ip_setsockopt+0x4c/0x140 net/ipv4/ip_sockglue.c:1249
  tcp_setsockopt+0x93/0xe0 net/ipv4/tcp.c:3062
  sock_common_setsockopt+0x9a/0xe0 net/core/sock.c:3038
  __sys_setsockopt+0x1c5/0x3b0 net/socket.c:1900
  __do_sys_setsockopt net/socket.c:1911 [inline]
  __se_sys_setsockopt net/socket.c:1908 [inline]
  __x64_sys_setsockopt+0xbe/0x150 net/socket.c:1908
  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x457099
Code: fd b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f20d1b5ec78 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 00007f20d1b5f6d4 RCX: 0000000000457099
RDX: 0000000000000004 RSI: 0200000000000000 RDI: 0000000000000006
RBP: 00000000009300a0 R08: 000000000000000c R09: 0000000000000000
R10: 0000000020013ff4 R11: 0000000000000246 R12: 00000000ffffffff
R13: 00000000004d58c8 R14: 00000000004c982a R15: 0000000000000000
ISOFS: Unable to identify CD-ROM format.
REISERFS warning (device loop4): super-6502 reiserfs_getopt: unknown mount  
option "r%size="
REISERFS warning (device loop4): super-6502 reiserfs_getopt: unknown mount  
option "r%size="
ISOFS: Unable to identify CD-ROM format.
ISOFS: Unable to identify CD-ROM format.
ISOFS: Unable to identify CD-ROM format.
ISOFS: Unable to identify CD-ROM format.
ISOFS: Unable to identify CD-ROM format.
ISOFS: Unable to identify CD-ROM format.
REISERFS warning (device loop4): super-6502 reiserfs_getopt: unknown mount  
option "rxsize="
ISOFS: Unable to identify CD-ROM format.
FAULT_FLAG_ALLOW_RETRY missing 30
CPU: 0 PID: 618 Comm: syz-executor0 Not tainted 4.19.0-rc2+ #2
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1c9/0x2b4 lib/dump_stack.c:113
  handle_userfault.cold.33+0x43/0x52 fs/userfaultfd.c:432
  do_anonymous_page mm/memory.c:3164 [inline]
  handle_pte_fault mm/memory.c:3981 [inline]
  __handle_mm_fault+0x389e/0x4350 mm/memory.c:4107
ISOFS: Unable to identify CD-ROM format.
  handle_mm_fault+0x53e/0xc80 mm/memory.c:4144
  __do_page_fault+0x620/0xe50 arch/x86/mm/fault.c:1395
ISOFS: Unable to identify CD-ROM format.
  do_page_fault+0xf6/0x7a4 arch/x86/mm/fault.c:1470
  page_fault+0x1e/0x30 arch/x86/entry/entry_64.S:1161
RIP: 0010:copy_user_generic_unrolled+0x86/0xc0  
arch/x86/lib/copy_user_64.S:65
Code: 4c 8b 5e 38 4c 89 47 20 4c 89 4f 28 4c 89 57 30 4c 89 5f 38 48 8d 76  
40 48 8d 7f 40 ff c9 75 b6 89 d1 83 e2 07 c1 e9 03 74 12 <4c> 8b 06 4c 89  
07 48 8d 76 08 48 8d 7f 08 ff c9 75 ee 21 d2 74 10
RSP: 0018:ffff880166f87700 EFLAGS: 00010203
RAX: 0000000000000004 RBX: 000000000000000c RCX: 0000000000000001
RDX: 0000000000000004 RSI: 0000000020013ff4 RDI: ffff8800136c75a0
RBP: ffff880166f87738 R08: ffffed00026d8eb6 R09: ffffed00026d8eb4
R10: ffffed00026d8eb5 R11: 0000000000000003 R12: 0000000020014000
R13: 0000000020013ff4 R14: ffff8800136c75a0 R15: 00007ffffffff000
  copy_from_user include/linux/uaccess.h:147 [inline]
  ip_options_get_from_user+0x8d/0xf0 net/ipv4/ip_options.c:537
  do_ip_setsockopt.isra.13+0x1ba6/0x3e70 net/ipv4/ip_sockglue.c:655
  ip_setsockopt+0x4c/0x140 net/ipv4/ip_sockglue.c:1249
  tcp_setsockopt+0x93/0xe0 net/ipv4/tcp.c:3062
  sock_common_setsockopt+0x9a/0xe0 net/core/sock.c:3038
  __sys_setsockopt+0x1c5/0x3b0 net/socket.c:1900
ISOFS: Unable to identify CD-ROM format.
  __do_sys_setsockopt net/socket.c:1911 [inline]
  __se_sys_setsockopt net/socket.c:1908 [inline]
  __x64_sys_setsockopt+0xbe/0x150 net/socket.c:1908
  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x457099
Code: fd b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f20d1b5ec78 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 00007f20d1b5f6d4 RCX: 0000000000457099
RDX: 0000000000000004 RSI: 6000000000000000 RDI: 0000000000000006
RBP: 00000000009300a0 R08: 000000000000000c R09: 0000000000000000
R10: 0000000020013ff4 R11: 0000000000000246 R12: 00000000ffffffff
R13: 00000000004d58c8 R14: 00000000004c982a R15: 0000000000000000
ISOFS: Unable to identify CD-ROM format.
REISERFS warning (device loop4): super-6502 reiserfs_getopt: unknown mount  
option "rxsize="
ISOFS: Unable to identify CD-ROM format.
ISOFS: Unable to identify CD-ROM format.
ISOFS: Unable to identify CD-ROM format.
isofs_fill_super: bread failed, dev=loop6, iso_blknum=32, block=64
ISOFS: Unable to identify CD-ROM format.
REISERFS warning (device loop4): super-6502 reiserfs_getopt: unknown mount  
option "r
size="
ISOFS: Unable to identify CD-ROM format.
FAULT_FLAG_ALLOW_RETRY missing 30
CPU: 0 PID: 728 Comm: syz-executor0 Not tainted 4.19.0-rc2+ #2
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1c9/0x2b4 lib/dump_stack.c:113
  handle_userfault.cold.33+0x43/0x52 fs/userfaultfd.c:432
ISOFS: Unable to identify CD-ROM format.
  do_anonymous_page mm/memory.c:3164 [inline]
  handle_pte_fault mm/memory.c:3981 [inline]
  __handle_mm_fault+0x389e/0x4350 mm/memory.c:4107
  handle_mm_fault+0x53e/0xc80 mm/memory.c:4144
  __do_page_fault+0x620/0xe50 arch/x86/mm/fault.c:1395
  do_page_fault+0xf6/0x7a4 arch/x86/mm/fault.c:1470
ISOFS: Unable to identify CD-ROM format.
  page_fault+0x1e/0x30 arch/x86/entry/entry_64.S:1161
RIP: 0010:copy_user_generic_unrolled+0x86/0xc0  
arch/x86/lib/copy_user_64.S:65
Code: 4c 8b 5e 38 4c 89 47 20 4c 89 4f 28 4c 89 57 30 4c 89 5f 38 48 8d 76  
40 48 8d 7f 40 ff c9 75 b6 89 d1 83 e2 07 c1 e9 03 74 12 <4c> 8b 06 4c 89  
07 48 8d 76 08 48 8d 7f 08 ff c9 75 ee 21 d2 74 10
RSP: 0018:ffff88015ba57700 EFLAGS: 00010203
RAX: 0000000000000004 RBX: 000000000000000c RCX: 0000000000000001
RDX: 0000000000000004 RSI: 0000000020013ff4 RDI: ffff8801d7f72220
RBP: ffff88015ba57738 R08: ffffed003afee446 R09: ffffed003afee444
R10: ffffed003afee445 R11: 0000000000000003 R12: 0000000020014000
R13: 0000000020013ff4 R14: ffff8801d7f72220 R15: 00007ffffffff000
  copy_from_user include/linux/uaccess.h:147 [inline]
  ip_options_get_from_user+0x8d/0xf0 net/ipv4/ip_options.c:537
  do_ip_setsockopt.isra.13+0x1ba6/0x3e70 net/ipv4/ip_sockglue.c:655
  ip_setsockopt+0x4c/0x140 net/ipv4/ip_sockglue.c:1249
  tcp_setsockopt+0x93/0xe0 net/ipv4/tcp.c:3062
  sock_common_setsockopt+0x9a/0xe0 net/core/sock.c:3038
  __sys_setsockopt+0x1c5/0x3b0 net/socket.c:1900
  __do_sys_setsockopt net/socket.c:1911 [inline]
  __se_sys_setsockopt net/socket.c:1908 [inline]
  __x64_sys_setsockopt+0xbe/0x150 net/socket.c:1908
  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x457099
ISOFS: Unable to identify CD-ROM format.
Code: fd b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f20d1b5ec78 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 00007f20d1b5f6d4 RCX: 0000000000457099
RDX: 0000000000000004 RSI: ffffffff00000000 RDI: 0000000000000006
RBP: 00000000009300a0 R08: 000000000000000c R09: 0000000000000000
R10: 0000000020013ff4 R11: 0000000000000246 R12: 00000000ffffffff
R13: 00000000004d58c8 R14: 00000000004c982a R15: 0000000000000000
ISOFS: Unable to identify CD-ROM format.
REISERFS warning (device loop4): super-6502 reiserfs_getopt: unknown mount  
option "r
size="
ISOFS: Unable to identify CD-ROM format.
ISOFS: Unable to identify CD-ROM format.
REISERFS warning (device loop4): super-6502 reiserfs_getopt: unknown mount  
option "reaize="
ISOFS: Unable to identify CD-ROM format.
REISERFS warning (device loop4): super-6502 reiserfs_getopt: unknown mount  
option "reaize="
ISOFS: Unable to identify CD-ROM format.
ISOFS: Unable to identify CD-ROM format.
ISOFS: Unable to identify CD-ROM format.
REISERFS warning (device loop4): super-6502 reiserfs_getopt: unknown mount  
option "rezize="
REISERFS warning (device loop4): super-6502 reiserfs_getopt: unknown mount  
option "rezize="
ISOFS: Unable to identify CD-ROM format.
ISOFS: Unable to identify CD-ROM format.
ISOFS: Unable to identify CD-ROM format.
ISOFS: Unable to identify CD-ROM format.
FAULT_FLAG_ALLOW_RETRY missing 30
CPU: 0 PID: 938 Comm: syz-executor0 Not tainted 4.19.0-rc2+ #2
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1c9/0x2b4 lib/dump_stack.c:113
  handle_userfault.cold.33+0x43/0x52 fs/userfaultfd.c:432
  do_anonymous_page mm/memory.c:3164 [inline]
  handle_pte_fault mm/memory.c:3981 [inline]
  __handle_mm_fault+0x389e/0x4350 mm/memory.c:4107
  handle_mm_fault+0x53e/0xc80 mm/memory.c:4144
  __do_page_fault+0x620/0xe50 arch/x86/mm/fault.c:1395
  do_page_fault+0xf6/0x7a4 arch/x86/mm/fault.c:1470
  page_fault+0x1e/0x30 arch/x86/entry/entry_64.S:1161
RIP: 0010:copy_user_generic_unrolled+0x86/0xc0  
arch/x86/lib/copy_user_64.S:65
Code: 4c 8b 5e 38 4c 89 47 20 4c 89 4f 28 4c 89 57 30 4c 89 5f 38 48 8d 76  
40 48 8d 7f 40 ff c9 75 b6 89 d1 83 e2 07 c1 e9 03 74 12 <4c> 8b 06 4c 89  
07 48 8d 76 08 48 8d 7f 08 ff c9 75 ee 21 d2 74 10
RSP: 0018:ffff88001c8ff700 EFLAGS: 00010203
RAX: 0000000000000004 RBX: 000000000000000c RCX: 0000000000000001
RDX: 0000000000000004 RSI: 0000000020013ff4 RDI: ffff880164d4e1a0
RBP: ffff88001c8ff738 R08: ffffed002c9a9c36 R09: ffffed002c9a9c34
R10: ffffed002c9a9c35 R11: 0000000000000003 R12: 0000000020014000
R13: 0000000020013ff4 R14: ffff880164d4e1a0 R15: 00007ffffffff000
  copy_from_user include/linux/uaccess.h:147 [inline]
  ip_options_get_from_user+0x8d/0xf0 net/ipv4/ip_options.c:537
  do_ip_setsockopt.isra.13+0x1ba6/0x3e70 net/ipv4/ip_sockglue.c:655
  ip_setsockopt+0x4c/0x140 net/ipv4/ip_sockglue.c:1249
  tcp_setsockopt+0x93/0xe0 net/ipv4/tcp.c:3062
  sock_common_setsockopt+0x9a/0xe0 net/core/sock.c:3038
  __sys_setsockopt+0x1c5/0x3b0 net/socket.c:1900
  __do_sys_setsockopt net/socket.c:1911 [inline]
  __se_sys_setsockopt net/socket.c:1908 [inline]
  __x64_sys_setsockopt+0xbe/0x150 net/socket.c:1908
  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x457099
Code: fd b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f20d1b5ec78 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 00007f20d1b5f6d4 RCX: 0000000000457099
RDX: 0000000000000004 RSI: 2000000000000000 RDI: 0000000000000006
RBP: 00000000009300a0 R08: 000000000000000c R09: 0000000000000000
R10: 0000000020013ff4 R11: 0000000000000246 R12: 00000000ffffffff
R13: 00000000004d58c8 R14: 00000000004c982a R15: 0000000000000000
ISOFS: Unable to identify CD-ROM format.
REISERFS warning (device loop4): super-6502 reiserfs_getopt: unknown mount  
option "rexize="
ISOFS: Unable to identify CD-ROM format.
REISERFS warning (device loop4): super-6502 reiserfs_getopt: unknown mount  
option "rexize="
ISOFS: Unable to identify CD-ROM format.
ISOFS: Unable to identify CD-ROM format.
ISOFS: Unable to identify CD-ROM format.
ISOFS: Unable to identify CD-ROM format.
ISOFS: Unable to identify CD-ROM format.
ISOFS: Unable to identify CD-ROM format.
REISERFS warning (device loop4): super-6502 reiserfs_getopt: unknown mount  
option "re-ize="
ISOFS: Unable to identify CD-ROM format.
REISERFS warning (device loop4): super-6502 reiserfs_getopt: unknown mount  
option "re-ize="
ISOFS: Unable to identify CD-ROM format.
ISOFS: Unable to identify CD-ROM format.
ISOFS: Unable to identify CD-ROM format.
ISOFS: Unable to identify CD-ROM format.
REISERFS warning (device loop4): super-6502 reiserfs_getopt: unknown mount  
option "reuize="
ISOFS: Unable to identify CD-ROM format.
ISOFS: Unable to identify CD-ROM format.
ISOFS: Unable to identify CD-ROM format.
ISOFS: Unable to identify CD-ROM format.
ISOFS: Unable to identify CD-ROM format.
REISERFS warning (device loop4): super-6502 reiserfs_getopt: unknown mount  
option "re
ize="
REISERFS warning (device loop4): super-6502 reiserfs_getopt: unknown mount  
option "re
ize="
ISOFS: Unable to identify CD-ROM format.
ISOFS: Unable to identify CD-ROM format.
ISOFS: Unable to identify CD-ROM format.
ISOFS: Unable to identify CD-ROM format.
REISERFS warning (device loop4): super-6502 reiserfs_getopt: unknown mount  
option "rehize="
ISOFS: Unable to identify CD-ROM format.
ISOFS: Unable to identify CD-ROM format.
ISOFS: Unable to identify CD-ROM format.
REISERFS warning (device loop4): super-6502 reiserfs_getopt: unknown mount  
option "rehize="
ISOFS: Unable to identify CD-ROM format.
ISOFS: Unable to identify CD-ROM format.
ISOFS: Unable to identify CD-ROM format.
ISOFS: Unable to identify CD-ROM format.
ISOFS: Unable to identify CD-ROM format.
REISERFS warning (device loop4): super-6502 reiserfs_getopt: unknown mount  
option "reyize="
ISOFS: Unable to identify CD-ROM format.
REISERFS warning (device loop4): super-6502 reiserfs_getopt: unknown mount  
option "reyize="
ISOFS: Unable to identify CD-ROM format.
FAULT_FLAG_ALLOW_RETRY missing 30
CPU: 1 PID: 1343 Comm: syz-executor0 Not tainted 4.19.0-rc2+ #2


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with  
syzbot.
