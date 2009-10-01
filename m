From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14287] New: ext4: fixpoint divide exception at ext4_fill_super
Date: Thu, 1 Oct 2009 05:58:35 GMT
Message-ID: <bug-14287-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:53824 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbZJAF6b (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Oct 2009 01:58:31 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n915wZUI020833
	for <linux-ext4@vger.kernel.org>; Thu, 1 Oct 2009 05:58:35 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14287

           Summary: ext4: fixpoint divide exception at ext4_fill_super
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.32-rc1, 2.6.31
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: rnsastry@linux.vnet.ibm.com
        Regression: No


Found kernel bug - fixpoint divide exception
While working with fsfuzzer

Environment: 2.6.31 and 2.6.32-rc1
Architecture: s390 and ppc64

------------[ cut here ]------------
Kernel BUG at 000003e00429d934 [verbose debug info unavailable]
fixpoint divide exception: 0009 [#1] SMP
Modules linked in: ext4 jbd2 crc16 loop autofs4 lockd sunrpc ipv6 qeth_l2 qeth
q
dio vmur ccwgroup dm_round_robin dm_multipath scsi_dh sd_mod scsi_mod multipath
dm_snapshot dm_zero dm_mirror dm_region_hash dm_log dm_mod dasd_fba_mod
dasd_eck
d_mod dasd_mod ext3 jbd
CPU: 2 Not tainted 2.6.31-rc6 #1
Process mount (pid: 2675, task: 000000003ed06038, ksp: 0000000036217920)
Krnl PSW : 0704200180000000 000003e00429d934 (ext4_fill_super+0x1478/0x2908
[ext
4])
           R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:2 PM:0 EA:3
Krnl GPRS: 0000000000000100 0000000000000100 0000000000000006 000000002fc61800
           0000000000000000 0000000000000100 000000002fc61800 000000002fc61800
           000000003143a800 00000000000000e0 0000000000000000 000000003eb0d800
           000003e00427c000 000003e0042b8958 000003e00429d87c 0000000036217b10
Krnl Code: 000003e00429d928: b9160050           llgfr   %r5,%r0
           000003e00429d92c: a7490000           lghi    %r4,0
           000003e00429d930: b987004a           dlgr    %r4,%r10
          >000003e00429d934: b91600a5           llgfr   %r10,%r5
           000003e00429d938: a53f80d0           llill   %r3,32976
           000003e00429d93c: a7ad000c           mghi    %r10,12
           000003e00429d940: b904002a           lgr     %r2,%r10
           000003e00429d944: 1895               lr      %r9,%r5
Call Trace:
([<000003e00429d87c>] ext4_fill_super+0x13c0/0x2908 [ext4])
 [<00000000000f46f2>] get_sb_bdev+0x13e/0x19c
 [<000003e00429230e>] ext4_get_sb+0x2e/0x40 [ext4]
 [<00000000000f3f98>] vfs_kern_mount+0xc0/0x168
 [<00000000000f40ac>] do_kern_mount+0x58/0x114
 [<000000000010e558>] do_mount+0x798/0x830
 [<000000000010e6a0>] SyS_mount+0xb0/0x100
 [<00000000000266be>] sysc_noemu+0x10/0x16
 [<0000004e53f234e2>] 0x4e53f234e2
Last Breaking-Event-Address:
 [<000003e00429d8d8>] ext4_fill_super+0x141c/0x2908 [ext4]

---[ end trace b5563edf9c0c9b52 ]--- 

2.6.32-rc1 stack trace

------------[ cut here ]------------
Kernel BUG at 000003e0024d6b52 [verbose debug info unavailable]
fixpoint divide exception: 0009 [#1] SMP
Modules linked in: ext4 jbd2 crc16 autofs4 lockd sunrpc ipv6 loop qeth_l2 qeth
vmur qdio ccwgroup dm_round_robin dm_multipath scsi_dh sd_mod scsi_mod
multipath dm_snapshot dm_zero dm_mirror dm_region_hash dm_log dm_mod
dasd_fba_mod dasd_eckd_mod dasd_mod ext3 jbd
CPU: 2 Not tainted 2.6.32-rc2 #1
Process mount (pid: 2752, task: 00000000233e47c0, ksp: 00000000233a3910)
Krnl PSW : 0704200180000000 000003e0024d6b52 (ext4_fill_super+0x1506/0x29c0
[ext4])
           R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:2 PM:0 EA:3
Krnl GPRS: 0000000e00000100 0000000000000100 0000000000000006 00000000200ad000
           0000000000000000 0000000000000100 00000000200ad000 00000000200ad000
           00000000200ae000 000000001ab6d800 0000000000000000 00000000000000e0
           000003e0024b3000 000003e0024f2d28 000003e0024d6ab8 00000000233a3b00
Krnl Code: 000003e0024d6b46: b9160050           llgfr   %r5,%r0
           000003e0024d6b4a: a7490000           lghi    %r4,0
           000003e0024d6b4e: b987004a           dlgr    %r4,%r10
          >000003e0024d6b52: b91600b5           llgfr   %r11,%r5
           000003e0024d6b56: a53f80d0           llill   %r3,32976
           000003e0024d6b5a: a7bd000c           mghi    %r11,12
           000003e0024d6b5e: b904002b           lgr     %r2,%r11
           000003e0024d6b62: 18a5               lr      %r10,%r5
Call Trace:
([<000003e0024d6ab8>] ext4_fill_super+0x146c/0x29c0 [ext4])
 [<0000000000111ed8>] get_sb_bdev+0x158/0x1b4
 [<000003e0024cbe16>] ext4_get_sb+0x2e/0x40 [ext4]
 [<00000000001119ac>] vfs_kern_mount+0xc0/0x19c
 [<0000000000111af4>] do_kern_mount+0x58/0x114
 [<000000000012d760>] do_mount+0x7b4/0x84c
 [<000000000012d89c>] SyS_mount+0xa4/0xec
 [<0000000000027f5a>] sysc_tracego+0xe/0x14
 [<0000004e53f234e2>] 0x4e53f234e2
Last Breaking-Event-Address:
 [<000003e0024d6afa>] ext4_fill_super+0x14ae/0x29c0 [ext4]

---[ end trace b8c3330dd3812f17 ]---

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
