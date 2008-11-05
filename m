From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11960] New: Oops in ext4_mb_poll_new_transaction
Date: Wed,  5 Nov 2008 09:34:08 -0800 (PST)
Message-ID: <bug-11960-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56610 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753229AbYKERek (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Nov 2008 12:34:40 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mA5HY8qL026158
	for <linux-ext4@vger.kernel.org>; Wed, 5 Nov 2008 09:34:09 -0800
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=11960

           Summary: Oops in ext4_mb_poll_new_transaction
           Product: File System
           Version: 2.5
     KernelVersion: 2.6.27
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: kelly@newdream.net


Distribution: Debian Etch
Hardware Environment: Supermicro server, quad core intel xeon cpu, 4 gigs of
ram, 8 gigs of swap, two 3ware 9690SA raid cards+BBU.
Software Environment: Debian etch 64-bit os with these drivers/firmware:

3ware 9000 Storage Controller device driver for Linux v2.26.02.011.
3w-9xxx: scsi1: Firmware FH9X 4.06.00.004, BIOS BE9X 4.05.00.015, Ports: 128.

Kernel checked out from ext4 git repository -stable branch.

Problem Description: Kernel produced oops trying to mount an ext4 filesystem
after a hard reset was performed on the machine. fsck.ext4 repaired the
filesystem and it then mounted cleanly.

Steps to reproduce: Have not tried to reproduce. System was under I/O load from
multiple rsync processes reading from the network at around a total of
25-50mbps when it was hard reset. System rebooted but did not mount the
filesystem, instead producing the oops listed.

EXT4-fs: barriers enabled
kjournald2 starting.  Commit interval 5 seconds
EXT4 FS on sdb1, internal journal on sdb1:8
ext4_orphan_cleanup: deleting unreferenced inode 394924522
BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
IP: [<ffffffff802f91c8>] ext4_mb_poll_new_transaction+0x6e/0xe3
PGD 1291db067 PUD 129fce067 PMD 0
Oops: 0002 [1] SMP
CPU 5
Pid: 4884, comm: mount Not tainted 2.6.27 #1
RIP: 0010:[<ffffffff802f91c8>]  [<ffffffff802f91c8>]
ext4_mb_poll_new_transaction+0x6e/0xe3
RSP: 0018:ffff880128a6d888  EFLAGS: 00010207
RAX: ffff8801288ee1e0 RBX: ffff8801288ec000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8801288ee1d0
RBP: ffff8801229193d8 R08: 0000000000000001 R09: ffff880128a6d9a0
R10: 000000005e2829ed R11: 0000000000000002 R12: ffff8801291b2000
R13: 0000000000000001 R14: 0000000000000001 R15: 0000000000000001
FS:  00007f8f321546d0(0000) GS:ffff88012fb080c0(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000008 CR3: 000000012915c000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process mount (pid: 4884, threadinfo ffff880128a6c000, task ffff88012ec4d410)
Stack:  000000005e2829ed ffff8801291b2000 ffff8801229107e0 ffffffff802fa3ba
ffff88012e60fce0 ffff880128a6d9a0 000000012e615800 ffff8801229107e0
ffff8801229193d8 ffffffff802792ab 0000000000000050 0000000000000292
Call Trace:
[<ffffffff802fa3ba>] ? ext4_mb_free_blocks+0x46/0x5b1
[<ffffffff802792ab>] ? cache_alloc_refill+0xeb/0x1e6
[<ffffffff803073bc>] ? insert_revoke_hash+0x89/0xad
[<ffffffff802ded31>] ? ext4_free_blocks+0x71/0xc5
[<ffffffff802f3c6e>] ? ext4_ext_truncate+0x3fd/0x860
[<ffffffff80303f9a>] ? do_get_write_access+0x38a/0x3d0
[<ffffffff802e4a81>] ? ext4_truncate+0x67/0x4e2
[<ffffffff80304cda>] ? jbd2_journal_dirty_metadata+0xcc/0xe3
[<ffffffff802f4e9a>] ? __ext4_journal_dirty_metadata+0x1e/0x46
[<ffffffff802e228a>] ? ext4_mark_iloc_dirty+0x45e/0x4e3
[<ffffffff802e291f>] ? ext4_mark_inode_dirty+0x159/0x16c
[<ffffffff802e6d8c>] ? ext4_delete_inode+0x103/0x1c2
[<ffffffff802e6c89>] ? ext4_delete_inode+0x0/0x1c2
[<ffffffff8028fa9a>] ? generic_delete_inode+0xb0/0x124
[<ffffffff802eee27>] ? ext4_fill_super+0x1850/0x1b53
[<ffffffff8027ee98>] ? set_bdev_super+0x0/0xf
[<ffffffff802ed5d7>] ? ext4_fill_super+0x0/0x1b53
[<ffffffff8027feff>] ? get_sb_bdev+0xf8/0x145
[<ffffffff8027f92a>] ? vfs_kern_mount+0x93/0x11b
[<ffffffff8027fa05>] ? do_kern_mount+0x43/0xdc
[<ffffffff80294293>] ? do_new_mount+0x5b/0x94
[<ffffffff80294489>] ? do_mount+0x1bd/0x1ea
[<ffffffff80291f82>] ? copy_mount_options+0xcc/0x12b
[<ffffffff80294540>] ? sys_mount+0x8a/0xda
[<ffffffff8020bdcb>] ? system_call_fastpath+0x16/0x1b


Code: 8b b3 d0 21 00 00 48 8d bb d0 21 00 00 48 39 fe 74 2f 48 8b 57 08 48 8b
8b e0 21 00 00 48 8d 83 e0 21 048 89 0a 48 89 51 08 48 89 bb d0 21 00 00 48 89
7f
RIP  [<ffffffff802f91c8>] ext4_mb_poll_new_transaction+0x6e/0xe3
RSP <ffff880128a6d888>
CR2: 0000000000000008
---[ end trace 72945378fb356467 ]---


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
