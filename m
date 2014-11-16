From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 88321] New: WARNING: CPU: 1 PID: 6784 at fs/dcache.c:1318
 umount_check+0x77/0x7b()
Date: Sun, 16 Nov 2014 17:19:19 +0000
Message-ID: <bug-88321-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:59090 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755217AbaKPRTX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 16 Nov 2014 12:19:23 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 811BC20176
	for <linux-ext4@vger.kernel.org>; Sun, 16 Nov 2014 17:19:22 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id B44522014A
	for <linux-ext4@vger.kernel.org>; Sun, 16 Nov 2014 17:19:19 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=88321

            Bug ID: 88321
           Summary: WARNING: CPU: 1 PID: 6784 at fs/dcache.c:1318
                    umount_check+0x77/0x7b()
           Product: File System
           Version: 2.5
    Kernel Version: 3.17.1
          Hardware: Intel
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: dwayne@mun.ca
        Regression: No

Using a modified 3.17.1 kernel. Please see BUG 86661
(https://bugzilla.kernel.org/show_bug.cgi?id=86661) for the modifications
implemented. We recently encountered the following information from the kernel
ring buffer:

[Fri Oct 31 19:15:13 2014] WARNING: CPU: 1 PID: 6784 at fs/dcache.c:1318
umount_check+0x77/0x7b()
[Fri Oct 31 19:15:13 2014] Modules linked in:
[Fri Oct 31 19:15:13 2014] CPU: 1 PID: 6784 Comm: umount.nfs4 Not tainted
3.17.1-gentoo20141023m-00002-gbe4fcc3 #2
[Fri Oct 31 19:15:13 2014] Hardware name: System manufacturer System Product
Name/P6X58-E PRO, BIOS 0504    07/28/2011
[Fri Oct 31 19:15:13 2014]  0000000000000526 ffff88031c70fcc8 ffffffff81800a85
0000000000000000
[Fri Oct 31 19:15:13 2014]  0000000000000000 ffff88031c70fd08 ffffffff8103c4f3
ffff88031c70fd30
[Fri Oct 31 19:15:13 2014]  ffffffff81125a28 ffff880316e7d010 0000000000015c80
ffff880326786901
[Fri Oct 31 19:15:13 2014] Call Trace:
[Fri Oct 31 19:15:13 2014]  [<ffffffff81800a85>] dump_stack+0x46/0x58
[Fri Oct 31 19:15:13 2014]  [<ffffffff8103c4f3>] warn_slowpath_common+0x7c/0x96
[Fri Oct 31 19:15:13 2014]  [<ffffffff81125a28>] ? umount_check+0x77/0x7b
[Fri Oct 31 19:15:13 2014]  [<ffffffff8103c522>] warn_slowpath_null+0x15/0x17
[Fri Oct 31 19:15:13 2014]  [<ffffffff81125a28>] umount_check+0x77/0x7b
[Fri Oct 31 19:15:13 2014]  [<ffffffff811248c6>] d_walk+0x115/0x2d4
[Fri Oct 31 19:15:13 2014]  [<ffffffff81126484>] ? do_one_tree+0x22/0x36
[Fri Oct 31 19:15:13 2014]  [<ffffffff811259b1>] ?
d_instantiate_unique+0x68/0x68
[Fri Oct 31 19:15:13 2014]  [<ffffffff81126484>] do_one_tree+0x22/0x36
[Fri Oct 31 19:15:13 2014]  [<ffffffff8112697d>]
shrink_dcache_for_umount+0x59/0x6b
[Fri Oct 31 19:15:13 2014]  [<ffffffff8111537e>]
generic_shutdown_super+0x1e/0xed
[Fri Oct 31 19:15:13 2014]  [<ffffffff811154c0>] kill_anon_super+0xe/0x19
[Fri Oct 31 19:15:13 2014]  [<ffffffff8121e439>] nfs_kill_super+0x12/0x1e
[Fri Oct 31 19:15:13 2014]  [<ffffffff81115a02>]
deactivate_locked_super+0x36/0x4b
[Fri Oct 31 19:15:13 2014]  [<ffffffff811160f1>] deactivate_super+0x3a/0x3e
[Fri Oct 31 19:15:13 2014]  [<ffffffff8112d0d4>] mntput_no_expire+0x1b0/0x1d2
[Fri Oct 31 19:15:13 2014]  [<ffffffff8112e4b3>] ? SyS_umount+0x395/0x3aa
[Fri Oct 31 19:15:13 2014]  [<ffffffff8112e4b3>] SyS_umount+0x395/0x3aa
[Fri Oct 31 19:15:13 2014]  [<ffffffff81808412>] ?
system_call_fastpath+0x16/0x1b
[Fri Oct 31 19:15:13 2014]  [<ffffffff810f072a>] ? vm_munmap+0x4e/0x5e
[Fri Oct 31 19:15:13 2014]  [<ffffffff8112cf24>] ? mnt_get_count+0x53/0x53
[Fri Oct 31 19:15:13 2014]  [<ffffffff81808412>] system_call_fastpath+0x16/0x1b
[Fri Oct 31 19:15:13 2014] ---[ end trace f8d9e04a1786ebb6 ]---

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
