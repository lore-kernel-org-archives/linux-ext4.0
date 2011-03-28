From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 32082] New: ext4: oops when mounting intentionally corrupted
 filesystem
Date: Mon, 28 Mar 2011 23:12:00 GMT
Message-ID: <bug-32082-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:48694 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402Ab1C1XMB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Mar 2011 19:12:01 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p2SNC0Kj010768
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 28 Mar 2011 23:12:00 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=32082

           Summary: ext4: oops when mounting intentionally corrupted
                    filesystem
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.38.2
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: sliedes@cc.hut.fi
        Regression: No


Created an attachment (id=52392)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=52392)
Test ext4 file system (intentionally corrupted)

Mounting the attached (intentionally corrupted) ext4 filesystem image causes a
kernel OOPS (under KVM, vanilla 2.6.38.2, x86-64)

Steps to reproduce:

1. bunzip2 hdb.41.bz2
2. mount hdb.41 /mnt -t ext4 -o errors=continue
[oops]

Here's the dmesg output after issuing the mount command:

------------------------------------------------------------
------------[ cut here ]------------
kernel BUG at kernel/timer.c:659!
invalid opcode: 0000 [#1] 
last sysfs file: 
CPU 0 
Pid: 2639, comm: mount Not tainted 2.6.38.2 #3 Bochs Bochs
RIP: 0010:[<ffffffff81054983>]  [<ffffffff81054983>] mod_timer+0x1d3/0x250
RSP: 0000:ffff880003757ac8  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff880003d83500 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 000000010148cdae RDI: ffff880003d83500
RBP: ffff880003757b08 R08: 0000000000000000 R09: 0000000004000000
R10: 0000000000000000 R11: 0000000000000000 R12: 000000010148cdae
R13: 000000010148cdae R14: ffffffff81c23b05 R15: ffffffff81efa148
FS:  0000000000000000(0000) GS:ffffffff8221e000(0063) knlGS:00000000f7587960
CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
CR2: 000000000856d000 CR3: 000000000376e000 CR4: 00000000000006b0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process mount (pid: 2639, threadinfo ffff880003756000, task ffff88000556ef90)
Stack:
 0000000000000002 0000000000000002 ffff880004490208 0000000000000000
 ffff8800076e7400 ffff880003d81000 0000000000001385 ffffffff81c23b05
 ffff880003757b38 ffffffff811e9b5a ffff880003d81000 0000000000000000
Call Trace:
 [<ffffffff811e9b5a>] __save_error_info+0x9a/0x110
 [<ffffffff811ee7f1>] save_error_info+0x11/0x30
 [<ffffffff811efc31>] ext4_error_inode+0x61/0x110
 [<ffffffff8111d5b6>] ? __wait_on_buffer+0x26/0x30
 [<ffffffff811d4710>] ? __ext4_get_inode_loc+0x1e0/0x400
 [<ffffffff811d69f4>] ext4_iget+0x714/0x830
 [<ffffffff81074188>] ? debug_mutex_init+0x38/0x50
 [<ffffffff811f28d4>] ext4_fill_super+0x1664/0x2890
 [<ffffffff81078d0d>] ? trace_hardirqs_on_caller+0x13d/0x180
 [<ffffffff810f4f37>] mount_bdev+0x1a7/0x1f0
 [<ffffffff811f1270>] ? ext4_fill_super+0x0/0x2890
 [<ffffffff811e82f0>] ext4_mount+0x10/0x20
 [<ffffffff810f52d8>] vfs_kern_mount+0x88/0x280
 [<ffffffff810f56df>] do_kern_mount+0x4f/0x100
 [<ffffffff811102fb>] do_mount+0x3db/0x810
 [<ffffffff8110fe40>] ? copy_mount_options+0xf0/0x190
 [<ffffffff8113729f>] compat_sys_mount+0x12f/0x280
 [<ffffffff81033642>] ia32_sysret+0x0/0x5
Code: 50 48 e9 04 ff ff ff 90 4d 89 e5 49 29 c5 49 c1 ed 08 4d 01 e5 e9 80 fe
ff ff 66 0f 1f 44 00 00 41 bd 01 00 00 00 e9 48 ff ff ff <0f> 0b 49 89 c6 e9 1d
ff ff ff 4c 8b 35 0c 8e 2c 01 4d 85 f6 0f 
RIP  [<ffffffff81054983>] mod_timer+0x1d3/0x250
 RSP <ffff880003757ac8>
---[ end trace 1b18f0361c17f387 ]---
./runtest: line 35:  2639 Segmentation fault      mount $HDB /mnt -t ext4 -o
errors=continue
------------------------------------------------------------

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
