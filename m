From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 45631] New: Caught 32-bit read from uninitialized memory in
 ext4_da_get_block_prep
Date: Sun,  5 Aug 2012 21:35:23 +0000 (UTC)
Message-ID: <bug-45631-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:34729 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914Ab2HEVf1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 5 Aug 2012 17:35:27 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E7DCD201D3
	for <linux-ext4@vger.kernel.org>; Sun,  5 Aug 2012 21:35:25 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 55E3F201CB
	for <linux-ext4@vger.kernel.org>; Sun,  5 Aug 2012 21:35:24 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=45631

           Summary: Caught 32-bit read from uninitialized memory in
                    ext4_da_get_block_prep
           Product: File System
           Version: 2.5
    Kernel Version: 3.6-rc1
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: casteyde.christian@free.fr
        Regression: Yes


Created an attachment (id=76841)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=76841)
Kernel config file used.

Kernel 3.6-rc1
Slackware 64 current (gcc 4.7.0)
Core i7, 6GB

Since 3.6-rc1, I get the following warning when booting with debug options
(check memory use):
WARNING: kmemcheck: Caught 32-bit read from uninitialized memory
(ffff8801b6a6d950)
ffffffff000000000000000000000000002c0400000000001c00000000000000
 i i i i i i i i i i i i i i i i u u u u i i i i i i u u u u u u
                                 ^
Pid: 7839, comm: kdm Not tainted 3.6.0-rc1 #1 Acer Aspire 7750G/JE70_HR
RIP: 0010:[<ffffffff811b3093>]  [<ffffffff811b3093>]
ext4_da_get_block_prep+0x243/0x2b0
RSP: 0018:ffff8801c29eb958  EFLAGS: 00010282
RAX: 0000000000000000 RBX: ffff8801b6a6d4d0 RCX: 0000000000000000
RDX: ffffffff811b3085 RSI: ffff8801b6a6d9e8 RDI: 0000000000000001
RBP: ffff8801c29eb9d8 R08: ffffffff820f4660 R09: ffffffff820c5ce0
R10: 0000000000000001 R11: 0000000000000000 R12: ffff8801a9606d00
R13: ffff8801c1109800 R14: 0000000000000000 R15: 0000000000000000
FS:  00007fd6e5908740(0000) GS:ffff8801c7e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffff8801c6be0dd0 CR3: 00000001c29da000 CR4: 00000000000407f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
 [<ffffffff8116efc1>] __block_write_begin+0x1b1/0x540
 [<ffffffff811b62f1>] ext4_da_write_begin+0xc1/0x1a0
 [<ffffffff810f4c09>] generic_file_buffered_write+0x119/0x2a0
 [<ffffffff810f6c3c>] __generic_file_aio_write+0x1bc/0x3c0
 [<ffffffff810f6ec5>] generic_file_aio_write+0x85/0x110
 [<ffffffff811afb24>] ext4_file_write+0xa4/0x4b0
 [<ffffffff8113d2a7>] do_sync_write+0xa7/0xe0
 [<ffffffff8113daf6>] vfs_write+0xa6/0x160
 [<ffffffff8113ddf8>] sys_write+0x48/0xa0
 [<ffffffff817e1aa2>] system_call_fastpath+0x16/0x1b
 [<ffffffffffffffff>] 0xffffffffffffffff

In gdb, I get the following:
(gdb) l *0xffffffff811b3093
0xffffffff811b3093 is in ext4_da_get_block_prep (fs/ext4/inode.c:1217).
1212            /*
1213             * ext4_calc_metadata_amount() has side effects, which we have
1214             * to be prepared undo if we fail to claim space.
1215             */
1216            save_len = ei->i_da_metadata_calc_len;
1217            save_last_lblock = ei->i_da_metadata_calc_last_lblock;
1218            md_needed = EXT4_NUM_B2C(sbi,
1219                                     ext4_calc_metadata_amount(inode,
lblock));
1220            trace_ext4_da_reserve_space(inode, md_needed);
1221

This is new to 3.6-rc1, hence a regression.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
