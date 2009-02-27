From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12787] New: possible circular locking dependency
Date: Fri, 27 Feb 2009 09:11:40 -0800 (PST)
Message-ID: <bug-12787-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46383 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753484AbZB0RLo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Feb 2009 12:11:44 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n1RHBe5q018594
	for <linux-ext4@vger.kernel.org>; Fri, 27 Feb 2009 09:11:41 -0800
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12787

           Summary: possible circular locking dependency
           Product: File System
           Version: 2.5
     KernelVersion: 2.6.28.7
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: marko.kohtala@gmail.com


Latest working kernel version: 2.6.28.3
Earliest failing kernel version: have not bisected this
Distribution: debian unstable (but vanilla kernel.org kernel)
Hardware Environment: i686
Software Environment: 
Problem Description:
Kernel reports "BUG: sleeping function called from invalid context at
kernel/rwsem.c:21" and stack trace shows ext4_mb_load_buddy. Soon after [ INFO:
possible circular locking dependency detected ].

Feb 27 18:33:47 kohtala kernel: BUG: sleeping function called from invalid
context at kernel/rwsem.c:21
Feb 27 18:33:47 kohtala kernel: in_atomic(): 1, irqs_disabled(): 0, pid: 1028,
name: kjournald2
Feb 27 18:33:47 kohtala kernel: 1 lock held by kjournald2/1028:
Feb 27 18:33:47 kohtala kernel:  #0:  (&journal->j_list_lock){--..}, at:
[<c0207c2d>] jbd2_journal_commit_transaction+0xdcd/0x1340
Feb 27 18:33:47 kohtala kernel: Pid: 1028, comm: kjournald2 Not tainted
2.6.28.7 #8
Feb 27 18:33:47 kohtala kernel: Call Trace:
Feb 27 18:33:47 kohtala kernel:  [<c03cdae1>] ? printk+0x18/0x1a
Feb 27 18:33:47 kohtala kernel:  [<c011bbed>] __might_sleep+0x10d/0x130
Feb 27 18:33:47 kohtala kernel:  [<c03cf5d8>] down_read+0x18/0x60
Feb 27 18:33:47 kohtala kernel:  [<c01f4f10>] ext4_mb_load_buddy+0xa0/0x2c0
Feb 27 18:33:47 kohtala kernel:  [<c0146528>] ?
lock_release_non_nested+0x118/0x250
Feb 27 18:33:47 kohtala kernel:  [<c01f8d31>]
release_blocks_on_commit+0x41/0x210
Feb 27 18:33:47 kohtala kernel:  [<c0207c2d>] ?
jbd2_journal_commit_transaction+0xdcd/0x1340
Feb 27 18:33:47 kohtala kernel:  [<c0207ef1>] ?
jbd2_journal_commit_transaction+0x1091/0x1340
Feb 27 18:33:47 kohtala kernel:  [<c0207f07>]
jbd2_journal_commit_transaction+0x10a7/0x1340
Feb 27 18:33:47 kohtala kernel:  [<c020ba74>] kjournald2+0xb4/0x1f0
Feb 27 18:33:47 kohtala kernel:  [<c01357c0>] ?
autoremove_wake_function+0x0/0x40
Feb 27 18:33:47 kohtala kernel:  [<c020b9c0>] ? kjournald2+0x0/0x1f0
Feb 27 18:33:47 kohtala kernel:  [<c013554a>] kthread+0x3a/0x70
Feb 27 18:33:47 kohtala kernel:  [<c0135510>] ? kthread+0x0/0x70
Feb 27 18:33:47 kohtala kernel:  [<c01040af>] kernel_thread_helper+0x7/0x18
Feb 27 18:33:47 kohtala kernel: 
Feb 27 18:33:47 kohtala kernel:
=======================================================
Feb 27 18:33:47 kohtala kernel: [ INFO: possible circular locking dependency
detected ]
Feb 27 18:33:47 kohtala kernel: 2.6.28.7 #8
Feb 27 18:33:47 kohtala kernel:
-------------------------------------------------------
Feb 27 18:33:47 kohtala kernel: pdflush/273 is trying to acquire lock:
Feb 27 18:33:47 kohtala kernel:  (&journal->j_list_lock){--..}, at:
[<c02060f5>] do_get_write_access+0x4a5/0x5e0
Feb 27 18:33:47 kohtala kernel: 
Feb 27 18:33:47 kohtala kernel: but task is already holding lock:
Feb 27 18:33:47 kohtala kernel:  (&meta_group_info[i]->alloc_sem){----}, at:
[<c01f4f10>] ext4_mb_load_buddy+0xa0/0x2c0
Feb 27 18:33:47 kohtala kernel: 
Feb 27 18:33:47 kohtala kernel: which lock already depends on the new lock.
Feb 27 18:33:47 kohtala kernel: 
Feb 27 18:33:47 kohtala kernel: 
Feb 27 18:33:47 kohtala kernel: the existing dependency chain (in reverse
order) is:
Feb 27 18:33:47 kohtala kernel: 
Feb 27 18:33:47 kohtala kernel: -> #1 (&meta_group_info[i]->alloc_sem){----}:
Feb 27 18:33:47 kohtala kernel:        [<c0145cba>]
__lock_acquire+0x104a/0x1610
Feb 27 18:33:47 kohtala kernel:        [<c01462dc>] lock_acquire+0x5c/0x80
Feb 27 18:33:47 kohtala kernel:        [<c03cf602>] down_read+0x42/0x60
Feb 27 18:33:47 kohtala kernel:        [<c01f4f10>]
ext4_mb_load_buddy+0xa0/0x2c0
Feb 27 18:33:47 kohtala kernel:        [<c01f8d31>]
release_blocks_on_commit+0x41/0x210
Feb 27 18:33:47 kohtala kernel:        [<c0207f07>]
jbd2_journal_commit_transaction+0x10a7/0x1340
Feb 27 18:33:47 kohtala kernel:        [<c020ba74>] kjournald2+0xb4/0x1f0
Feb 27 18:33:47 kohtala kernel:        [<c013554a>] kthread+0x3a/0x70
Feb 27 18:33:47 kohtala kernel:        [<c01040af>]
kernel_thread_helper+0x7/0x18
Feb 27 18:33:47 kohtala kernel:        [<ffffffff>] 0xffffffff
Feb 27 18:33:47 kohtala kernel: 
Feb 27 18:33:47 kohtala kernel: -> #0 (&journal->j_list_lock){--..}:
Feb 27 18:33:47 kohtala kernel:        [<c0145e15>]
__lock_acquire+0x11a5/0x1610
Feb 27 18:33:47 kohtala kernel:        [<c01462dc>] lock_acquire+0x5c/0x80
Feb 27 18:33:47 kohtala kernel:        [<c03d07fd>] _spin_lock+0x3d/0x50
Feb 27 18:33:47 kohtala kernel:        [<c02060f5>]
do_get_write_access+0x4a5/0x5e0
Feb 27 18:33:47 kohtala kernel:        [<c0206253>]
jbd2_journal_get_write_access+0x23/0x40
Feb 27 18:33:47 kohtala kernel:        [<c01f212f>]
__ext4_journal_get_write_access+0x1f/0x50
Feb 27 18:33:47 kohtala kernel:        [<c01f58cf>]
ext4_mb_mark_diskspace_used+0x5f/0x460
Feb 27 18:33:47 kohtala kernel:        [<c01fac4c>]
ext4_mb_new_blocks+0x27c/0x410
Feb 27 18:33:47 kohtala kernel:        [<c01f1b1c>]
ext4_ext_get_blocks+0xa1c/0xed0
Feb 27 18:33:47 kohtala kernel:        [<c01e10f5>]
ext4_get_blocks_wrap+0x175/0x280
Feb 27 18:33:47 kohtala kernel:        [<c01e1449>]
ext4_da_get_block_write+0x59/0x240
Feb 27 18:33:47 kohtala kernel:        [<c01df399>]
mpage_da_map_blocks+0x69/0x610
Feb 27 18:33:47 kohtala kernel:        [<c01dfcb8>]
ext4_da_writepages+0x238/0x3a0
Feb 27 18:33:47 kohtala kernel:        [<c0160e8e>] do_writepages+0x2e/0x50
Feb 27 18:33:47 kohtala kernel:        [<c01996b1>]
__writeback_single_inode+0x81/0x310
Feb 27 18:33:47 kohtala kernel:        [<c0199e82>]
generic_sync_sb_inodes+0x2f2/0x390
Feb 27 18:33:47 kohtala kernel:        [<c019a0c6>] writeback_inodes+0x56/0xe0
Feb 27 18:33:47 kohtala kernel:        [<c0160fb3>] wb_kupdate+0x73/0xe0
Feb 27 18:33:47 kohtala kernel:        [<c016196a>] pdflush+0xea/0x1b0
Feb 27 18:33:47 kohtala kernel:        [<c013554a>] kthread+0x3a/0x70
Feb 27 18:33:47 kohtala kernel:        [<c01040af>]
kernel_thread_helper+0x7/0x18
Feb 27 18:33:47 kohtala kernel:        [<ffffffff>] 0xffffffff
Feb 27 18:33:47 kohtala kernel: 
Feb 27 18:33:47 kohtala kernel: other info that might help us debug this:
Feb 27 18:33:47 kohtala kernel: 
Feb 27 18:33:47 kohtala kernel: 5 locks held by pdflush/273:
Feb 27 18:33:47 kohtala kernel:  #0:  (&type->s_umount_key#15){----}, at:
[<c019a0b2>] writeback_inodes+0x42/0xe0
Feb 27 18:33:47 kohtala kernel:  #1:  (jbd2_handle){--..}, at: [<c0206bf3>]
jbd2_journal_start+0xb3/0x120
Feb 27 18:33:47 kohtala kernel:  #2:  (&ei->i_data_sem){----}, at: [<c01e1015>]
ext4_get_blocks_wrap+0x95/0x280
Feb 27 18:33:47 kohtala kernel:  #3:  (&lg->lg_mutex){--..}, at: [<c01f5ef6>]
ext4_mb_initialize_context+0x226/0x230
Feb 27 18:33:47 kohtala kernel:  #4:  (&meta_group_info[i]->alloc_sem){----},
at: [<c01f4f10>] ext4_mb_load_buddy+0xa0/0x2c0
Feb 27 18:33:47 kohtala kernel: 
Feb 27 18:33:47 kohtala kernel: stack backtrace:
Feb 27 18:33:47 kohtala kernel: Pid: 273, comm: pdflush Not tainted 2.6.28.7 #8
Feb 27 18:33:47 kohtala kernel: Call Trace:
Feb 27 18:33:47 kohtala kernel:  [<c03cdae1>] ? printk+0x18/0x1a
Feb 27 18:33:47 kohtala kernel:  [<c01448e0>] print_circular_bug_tail+0xb0/0xc0
Feb 27 18:33:47 kohtala kernel:  [<c0145e15>] __lock_acquire+0x11a5/0x1610
Feb 27 18:33:47 kohtala kernel:  [<c015f745>] ?
get_page_from_freelist+0x235/0x500
Feb 27 18:33:47 kohtala kernel:  [<c01462dc>] lock_acquire+0x5c/0x80
Feb 27 18:33:47 kohtala kernel:  [<c02060f5>] ? do_get_write_access+0x4a5/0x5e0
Feb 27 18:33:47 kohtala kernel:  [<c03d07fd>] _spin_lock+0x3d/0x50
Feb 27 18:33:47 kohtala kernel:  [<c02060f5>] ? do_get_write_access+0x4a5/0x5e0
Feb 27 18:33:47 kohtala kernel:  [<c02060f5>] do_get_write_access+0x4a5/0x5e0
Feb 27 18:33:47 kohtala kernel:  [<c0144365>] ?
trace_hardirqs_on_caller+0xf5/0x140
Feb 27 18:33:47 kohtala kernel:  [<c020ac9c>] ?
jbd2_journal_add_journal_head+0x19c/0x1f0
Feb 27 18:33:47 kohtala kernel:  [<c01443bb>] ? trace_hardirqs_on+0xb/0x10
Feb 27 18:33:47 kohtala kernel:  [<c0206253>]
jbd2_journal_get_write_access+0x23/0x40
Feb 27 18:33:47 kohtala kernel:  [<c01f212f>]
__ext4_journal_get_write_access+0x1f/0x50
Feb 27 18:33:47 kohtala kernel:  [<c01f58cf>]
ext4_mb_mark_diskspace_used+0x5f/0x460
Feb 27 18:33:47 kohtala kernel:  [<c01f6ee0>] ?
ext4_mb_new_group_pa+0x240/0x280
Feb 27 18:33:47 kohtala kernel:  [<c01fac4c>] ext4_mb_new_blocks+0x27c/0x410
Feb 27 18:33:47 kohtala kernel:  [<c01eef9d>] ?
ext4_ext_find_extent+0x25d/0x280
Feb 27 18:33:47 kohtala kernel:  [<c01f1b1c>] ext4_ext_get_blocks+0xa1c/0xed0
Feb 27 18:33:47 kohtala kernel:  [<c014492c>] ? check_usage+0x3c/0x380
Feb 27 18:33:47 kohtala kernel:  [<c014244a>] ? find_usage_backwards+0xea/0x130
Feb 27 18:33:47 kohtala kernel:  [<c01e1015>] ? ext4_get_blocks_wrap+0x95/0x280
Feb 27 18:33:47 kohtala kernel:  [<c01e10f5>] ext4_get_blocks_wrap+0x175/0x280
Feb 27 18:33:47 kohtala kernel:  [<c01e1449>]
ext4_da_get_block_write+0x59/0x240
Feb 27 18:33:47 kohtala kernel:  [<c01df399>] mpage_da_map_blocks+0x69/0x610
Feb 27 18:33:47 kohtala kernel:  [<c0159840>] ? find_get_pages_tag+0x0/0x110
Feb 27 18:33:47 kohtala kernel:  [<c01621c9>] ? pagevec_lookup_tag+0x29/0x40
Feb 27 18:33:47 kohtala kernel:  [<c0160b9a>] ? write_cache_pages+0xca/0x360
Feb 27 18:33:47 kohtala kernel:  [<c01dfef0>] ? __mpage_da_writepage+0x0/0x140
Feb 27 18:33:47 kohtala kernel:  [<c01dfcb8>] ext4_da_writepages+0x238/0x3a0
Feb 27 18:33:47 kohtala kernel:  [<c01e13f0>] ?
ext4_da_get_block_write+0x0/0x240
Feb 27 18:33:47 kohtala kernel:  [<c01dfa80>] ? ext4_da_writepages+0x0/0x3a0
Feb 27 18:33:47 kohtala kernel:  [<c0160e8e>] do_writepages+0x2e/0x50
Feb 27 18:33:47 kohtala kernel:  [<c01996b1>]
__writeback_single_inode+0x81/0x310
Feb 27 18:33:47 kohtala kernel:  [<c03d0804>] ? _spin_lock+0x44/0x50
Feb 27 18:33:47 kohtala kernel:  [<c0199e82>]
generic_sync_sb_inodes+0x2f2/0x390
Feb 27 18:33:47 kohtala kernel:  [<c019a0c6>] writeback_inodes+0x56/0xe0
Feb 27 18:33:47 kohtala kernel:  [<c0160fb3>] wb_kupdate+0x73/0xe0
Feb 27 18:33:47 kohtala kernel:  [<c0161880>] ? pdflush+0x0/0x1b0
Feb 27 18:33:47 kohtala kernel:  [<c016196a>] pdflush+0xea/0x1b0
Feb 27 18:33:47 kohtala kernel:  [<c0160f40>] ? wb_kupdate+0x0/0xe0
Feb 27 18:33:47 kohtala kernel:  [<c013554a>] kthread+0x3a/0x70
Feb 27 18:33:47 kohtala kernel:  [<c0135510>] ? kthread+0x0/0x70
Feb 27 18:33:47 kohtala kernel:  [<c01040af>] kernel_thread_helper+0x7/0x18

Steps to reproduce: Boot. Seems to occur every time. Rebooting to 2.6.28.3
compiled with same config removes the warning.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
