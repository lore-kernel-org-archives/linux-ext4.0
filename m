From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15025] New: Oops in ext4 driver
Date: Sun, 10 Jan 2010 13:09:59 GMT
Message-ID: <bug-15025-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:35111 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997Ab0AJNKA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 10 Jan 2010 08:10:00 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0AD9xTX016342
	for <linux-ext4@vger.kernel.org>; Sun, 10 Jan 2010 13:09:59 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=15025

           Summary: Oops in ext4 driver
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.33-rc3
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: sgunderson@bigfoot.com
        Regression: Yes


This may or may not be related to my previous bug report (15018); it's from the
same machine against the same filesystem. My kernel oopsed on me today:

[141480.485154] ------------[ cut here ]------------
[141480.489001] kernel BUG at fs/jbd2/transaction.c:1027!
[141480.489001] invalid opcode: 0000 [#1] SMP 
[141480.489001] last sysfs file:
/sys/devices/system/cpu/cpu3/cache/index2/shared_cpu_map
[141480.489001] CPU 2 
[141480.489001] Pid: 28573, comm: rsync Not tainted 2.6.33-rc3 #2
C2SBC-Q/C2SBC-Q
[141480.489001] RIP: 0010:[<ffffffffa022f6d8>]  [<ffffffffa022f6d8>]
jbd2_journal_dirty_metadata+0x69/0x100 [jbd2]
[141480.489001] RSP: 0018:ffff88022ead11c8  EFLAGS: 00010246
[141480.489001] RAX: 0000000000000000 RBX: ffff880090f054a8 RCX:
ffff880160c88540
[141480.489001] RDX: ffff8801655f44c0 RSI: ffff880160c88540 RDI:
ffff880038a0ce70
[141480.489001] RBP: ffff88022ead11f8 R08: ffff880160c88540 R09:
ffff88022ead1178
[141480.489001] R10: 0000000000000000 R11: ffffffffa0280b60 R12:
ffff8802272e1828
[141480.489001] R13: ffff880160c88540 R14: ffff880038a0ce70 R15:
ffff88023e9c7800
[141480.489001] FS:  00007fd4064996e0(0000) GS:ffff880028300000(0000)
knlGS:0000000000000000
[141480.489001] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[141480.489001] CR2: 00000000004a2071 CR3: 000000010670f000 CR4:
00000000000006e0
[141480.489001] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[141480.489001] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[141480.489001] Process rsync (pid: 28573, threadinfo ffff88022ead0000, task
ffff88016fc927c0)
[141480.489001] Stack:
[141480.489001]  ffffffffa027f890 ffff880090f054a8 ffff880160c88540
ffff880038a0ce70
[141480.489001] <0> ffffffffa027f890 ffff88022ead1300 ffff88022ead1228
ffffffffa0272aa0
[141480.489001] <0> 000000000000000e 0000000000000000 000000000000000e
0000000000000001
[141480.489001] Call Trace:
[141480.489001]  [<ffffffffa0272aa0>] __ext4_handle_dirty_metadata+0xcc/0xd7
[ext4]
[141480.645267]  [<ffffffffa0255285>] ext4_ind_get_blocks+0x78d/0x910 [ext4]
[141480.645267]  [<ffffffff81303833>] ? __down_write_nested+0x1a/0xc5
[141480.645267]  [<ffffffffa0255573>] ext4_get_blocks+0x16b/0x3ef [ext4]
[141480.645267]  [<ffffffff8102b165>] ? select_task_rq_fair+0x4ce/0x89b
[141480.645267]  [<ffffffffa0255cc4>] mpage_da_map_blocks+0xb4/0x613 [ext4]
[141480.645267]  [<ffffffff8102be86>] ? enqueue_task_fair+0x3f/0x82
[141480.645267]  [<ffffffff81024676>] ? enqueue_task+0x5b/0x66
[141480.645267]  [<ffffffff81024785>] ? activate_task+0x28/0x31
[141480.645267]  [<ffffffff8115fef1>] ? cpumask_next_and+0x2b/0x3c
[141480.645267]  [<ffffffff81163802>] ?
radix_tree_gang_lookup_tag_slot+0x85/0xaa
[141480.645267]  [<ffffffffa02569bb>] mpage_add_bh_to_extent+0x94/0xab [ext4]
[141480.645267]  [<ffffffff810a3078>] ? __dec_zone_page_state+0x1e/0x20
[141480.645267]  [<ffffffffa0256ad7>] __mpage_da_writepage+0x105/0x14d [ext4]
[141480.645267]  [<ffffffff81097a7b>] write_cache_pages+0x1ee/0x2f3
[141480.645267]  [<ffffffffa02569d2>] ? __mpage_da_writepage+0x0/0x14d [ext4]
[141480.645267]  [<ffffffffa0256701>] ext4_da_writepages+0x4de/0x704 [ext4]
[141480.645267]  [<ffffffff81301829>] ? schedule+0x632/0xba3
[141480.645267]  [<ffffffff81097bc1>] do_writepages+0x1c/0x25
[141480.645267]  [<ffffffff810dabac>] writeback_single_inode+0xea/0x2df
[141480.645267]  [<ffffffff810dae48>] write_inode_now+0x78/0xba
[141480.645267]  [<ffffffffa0255b2d>] ext4_da_get_block_prep+0x28b/0x36e [ext4]
[141480.645267]  [<ffffffff810e1b69>] __block_prepare_write+0x1f3/0x3c0
[141480.645267]  [<ffffffffa02558a2>] ? ext4_da_get_block_prep+0x0/0x36e [ext4]
[141480.645267]  [<ffffffff810e1eb1>] block_write_begin+0x80/0xcf
[141480.645267]  [<ffffffffa02587be>] ext4_da_write_begin+0x196/0x218 [ext4]
[141480.645267]  [<ffffffffa02558a2>] ? ext4_da_get_block_prep+0x0/0x36e [ext4]
[141480.645267]  [<ffffffff810911c1>] ?
iov_iter_copy_from_user_atomic+0x84/0xf6
[141480.645267]  [<ffffffff8109133f>] generic_file_buffered_write+0x10c/0x230
[141480.645267]  [<ffffffffa025375b>] ? ext4_dirty_inode+0x40/0x45 [ext4]
[141480.645267]  [<ffffffff81092b9c>] __generic_file_aio_write+0x347/0x37b
[141480.645267]  [<ffffffff81302709>] ? __mutex_lock_slowpath+0x22d/0x23c
[141480.645267]  [<ffffffff81092c2b>] generic_file_aio_write+0x5b/0xa2
[141480.645267]  [<ffffffffa024fa93>] ext4_file_write+0x8e/0x97 [ext4]
[141480.645267]  [<ffffffff810bfbc8>] do_sync_write+0xc0/0x106
[141480.645267]  [<ffffffff810cdb68>] ? poll_select_copy_remaining+0xc5/0xe9
[141480.645267]  [<ffffffff81125b50>] ? security_file_permission+0x11/0x13
[141480.645267]  [<ffffffff810c04df>] vfs_write+0xae/0x14a
[141480.645267]  [<ffffffff810c063f>] sys_write+0x47/0x6e
[141480.645267]  [<ffffffff81001feb>] system_call_fastpath+0x16/0x1b
[141480.645267] Code: 00 40 00 75 f3 f0 41 0f ba 6d 00 16 19 c0 85 c0 75 e8 41
83 7c 24 10 00 75 1b 41 c7 44 24 10 01 00 00 00 41 8b 46 08 85 c0 7f 04 <0f> 0b
eb fe ff c8 41 89 46 08 49 39 54 24 28 75 12 41 83 7c 24 
[141480.645267] RIP  [<ffffffffa022f6d8>]
jbd2_journal_dirty_metadata+0x69/0x100 [jbd2]
[141480.645267]  RSP <ffff88022ead11c8>
[141480.937330] ---[ end trace 4eacf5860ca2410a ]---

Note that the file system was fsck-ed before last mount, so it should be okay
unless ext4 ate it itself somehow.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
