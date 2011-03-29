From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 32122] New: Kernel BUG on accessing intentionally corrupted
 filesystem
Date: Tue, 29 Mar 2011 10:48:20 GMT
Message-ID: <bug-32122-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:48268 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285Ab1C2KsV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Mar 2011 06:48:21 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p2TAmKLJ030647
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 29 Mar 2011 10:48:20 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=32122

           Summary: Kernel BUG on accessing intentionally corrupted
                    filesystem
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.38.2 + patch for #32082
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


Created an attachment (id=52432)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=52432)
Test ext4 file system (intentionally corrupted)

Accessing the attached (intentionally corrupted) ext4 filesystem causes a
kernel BUG at fs/ext4/extents.c:1943.

The kernel is vanilla 2.6.38.2 with the patch from #32082 comment 1 applied to
fix another (most likely entirely distinct) ext4 bug. I run the kernel under
KVM x86-64.

Steps to reproduce:

1. bunzip2 hdb.337.bz2
2. mount hdb.337 /mnt -t ext4 -o errors=continue
3. cd /mnt
4. cp -R doc doc2
[BUG]

Here's the output:

------------------------------------------------------------
fstest:~# mount /dev/vdb /mnt -t ext4 errors=continue
[   84.599961] EXT4-fs (vdb): mounted filesystem with ordered data mode. Opts:
errors=continue
fstest:~# cd /mnt
fstest:/mnt# ls
dev  doc  lost+found
fstest:/mnt# cp -R doc doc2
EXT4-fs error (device vdb): ext4_mb_generate_buddy:731: group 06074 blocks in
bitmap, 6075 in gd
EXT4-fs error (device vdb): ext4_mb_generate_buddy:731: group 11892 blocks in
bitmap, 1891 in gd
EXT4-fs error (device vdb): ext4_ext_check_inode:428: inode #1334: comm cp: bad
header/extent: invalid eh_entries - magic f30a, entries 32769, max 4(4), depth
0(0)
cp: cannot stat `doc/acpid/examples': Input/output error
------------[ cut here ]------------
kernel BUG at fs/ext4/extents.c:1943!
invalid opcode: 0000 [#1] 
last sysfs file: 
CPU 0 
Pid: 1851, comm: cp Not tainted 2.6.38.2 #4 Bochs Bochs
RIP: 0010:[<ffffffff811f68f1>]  [<ffffffff811f68f1>]
ext4_ext_put_in_cache+0x71/0x80
RSP: 0000:ffff880004c2f768  EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 000000000000087d
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8800050fe3b0
RBP: ffff880004c2f798 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 000000000000087d R12: 0000000000000000
R13: ffff8800050fe3b0 R14: ffff8800050fe260 R15: 000000000000087d
FS:  0000000000000000(0000) GS:ffffffff8221e000(0063) knlGS:00000000f7579700
CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
CR2: 00000000ffe67dac CR3: 0000000004c14000 CR4: 00000000000006b0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process cp (pid: 1851, threadinfo ffff880004c2e000, task ffff8800056d8ff0)
Stack:
 ffff8800050fe260 ffff880007aa9ba0 ffff880004c2f9a8 ffff8800050fe3b0
 ffff8800050fe260 ffff8800050fe26c ffff880004c2f928 ffffffff811f8983
 000000000000020a ffff88000577b6a8 ffff880004c2f838 0000000000000018
Call Trace:
 [<ffffffff811f8983>] ext4_ext_map_blocks+0x173/0x26e0
 [<ffffffff811d9272>] ext4_map_blocks+0x72/0x280
 [<ffffffff811d9520>] _ext4_get_block+0xa0/0x150
 [<ffffffff811d9611>] ext4_get_block+0x11/0x20
 [<ffffffff81126d4a>] do_mpage_readpage+0x43a/0x5b0
 [<ffffffff810b3c8a>] ? add_to_page_cache_locked+0xca/0x110
 [<ffffffff8112761c>] mpage_readpages+0xfc/0x160
 [<ffffffff811d9600>] ? ext4_get_block+0x0/0x20
 [<ffffffff811d9600>] ? ext4_get_block+0x0/0x20
 [<ffffffff811d4d08>] ext4_readpages+0x18/0x20
 [<ffffffff810bdcac>] __do_page_cache_readahead+0x19c/0x280
 [<ffffffff810bdbbd>] ? __do_page_cache_readahead+0xad/0x280
 [<ffffffff810bdfdc>] ra_submit+0x1c/0x20
 [<ffffffff810be0fd>] ondemand_readahead+0x11d/0x2c0
 [<ffffffff810be2ce>] page_cache_sync_readahead+0x2e/0x40
 [<ffffffff810b55e9>] generic_file_aio_read+0x4c9/0x6f0
 [<ffffffff810f1a72>] do_sync_read+0xd2/0x110
 [<ffffffff8153a6e3>] ? security_file_permission+0x93/0xb0
 [<ffffffff810f2192>] vfs_read+0xc2/0x180
 [<ffffffff810f252c>] sys_read+0x4c/0x90
 [<ffffffff81033642>] ia32_sysret+0x0/0x5
Code: 89 a5 b4 05 00 00 4d 89 bd a8 05 00 00 4c 89 f7 e8 75 a0 9e 00 48 8b 5d
d8 4c 8b 65 e0 4c 8b 6d e8 4c 8b 75 f0 4c 8b 7d f8 c9 c3 <0f> 0b 66 66 66 66 2e
0f 1f 84 00 00 00 00 00 55 31 c0 48 89 e5 
RIP  [<ffffffff811f68f1>] ext4_ext_put_in_cache+0x71/0x80
 RSP <ffff880004c2f768>
---[ end trace af6e1f4d49d6021f ]---
------------------------------------------------------------

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
