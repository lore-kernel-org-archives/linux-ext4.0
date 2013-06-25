From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60121] New: -next and -mm: kmemleak reports 6 leaks in
 ext4_mount paths
Date: Tue, 25 Jun 2013 18:25:04 +0000 (UTC)
Message-ID: <bug-60121-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:35693 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005Ab3FYSZJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Jun 2013 14:25:09 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 8E80D20396
	for <linux-ext4@vger.kernel.org>; Tue, 25 Jun 2013 18:25:07 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 6DCF32038B
	for <linux-ext4@vger.kernel.org>; Tue, 25 Jun 2013 18:25:05 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=60121

           Summary: -next and -mm: kmemleak reports 6 leaks in ext4_mount
                    paths
           Product: File System
           Version: 2.5
    Kernel Version: v3.10-rc6-684-g9dcc58c
          Platform: All
        OS/Version: Linux
              Tree: -mm
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: jmesmon@gmail.com
        Regression: Yes


Created an attachment (id=106021)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=106021)
.config

In next-20130624, next-20130625 and mmotm (v3.10-rc6-684-g9dcc58c), kmemleak
complains about some ext4_mount related allocations.

----
# cat /sys/kernel/debug/kmemleak 
unreferenced object 0xffff880002a6dd80 (size 256):
  comm "swapper/0", pid 1, jiffies 4294892475 (age 33.128s)
  hex dump (first 32 bytes):
    00 00 00 00 ad 4e ad de ff ff ff ff 00 00 00 00  .....N..........
    ff ff ff ff ff ff ff ff 0c 0d 36 82 ff ff ff ff  ..........6.....
  backtrace:
    [<ffffffff813adfc1>] kmemleak_alloc+0x21/0x50
    [<ffffffff810e7b43>] __kmalloc+0x103/0x460
    [<ffffffff810cdd81>] list_lru_init+0x21/0xb0
    [<ffffffff810f36b5>] sget+0x305/0x670
    [<ffffffff810f463a>] mount_bdev+0xba/0x1e0
    [<ffffffff81175460>] ext4_mount+0x10/0x20
    [<ffffffff810f4950>] mount_fs+0x10/0xc0
    [<ffffffff81111c5a>] vfs_kern_mount+0x5a/0xf0
    [<ffffffff811133ca>] do_mount+0x1da/0x9d0
    [<ffffffff81113c3e>] SyS_mount+0x7e/0xc0
    [<ffffffff8184c245>] mount_block_root+0x104/0x223
    [<ffffffff8184c455>] mount_root+0xf1/0xfa
    [<ffffffff8184c58e>] prepare_namespace+0x130/0x168
    [<ffffffff8184bff8>] kernel_init_freeable+0x185/0x192
    [<ffffffff813ab7f9>] kernel_init+0x9/0x180
    [<ffffffff813c963c>] ret_from_fork+0x7c/0xb0
unreferenced object 0xffff880002a6d980 (size 256):
  comm "swapper/0", pid 1, jiffies 4294892475 (age 33.128s)
  hex dump (first 32 bytes):
    00 00 00 00 ad 4e ad de ff ff ff ff 00 00 00 00  .....N..........
    ff ff ff ff ff ff ff ff 0c 0d 36 82 ff ff ff ff  ..........6.....
  backtrace:
    [<ffffffff813adfc1>] kmemleak_alloc+0x21/0x50
    [<ffffffff810e7b43>] __kmalloc+0x103/0x460
    [<ffffffff810cdd81>] list_lru_init+0x21/0xb0
    [<ffffffff810f36c9>] sget+0x319/0x670
    [<ffffffff810f463a>] mount_bdev+0xba/0x1e0
    [<ffffffff81175460>] ext4_mount+0x10/0x20
    [<ffffffff810f4950>] mount_fs+0x10/0xc0
    [<ffffffff81111c5a>] vfs_kern_mount+0x5a/0xf0
    [<ffffffff811133ca>] do_mount+0x1da/0x9d0
    [<ffffffff81113c3e>] SyS_mount+0x7e/0xc0
    [<ffffffff8184c245>] mount_block_root+0x104/0x223
    [<ffffffff8184c455>] mount_root+0xf1/0xfa
    [<ffffffff8184c58e>] prepare_namespace+0x130/0x168
    [<ffffffff8184bff8>] kernel_init_freeable+0x185/0x192
    [<ffffffff813ab7f9>] kernel_init+0x9/0x180
    [<ffffffff813c963c>] ret_from_fork+0x7c/0xb0
unreferenced object 0xffff880002a7a7a0 (size 32):
  comm "swapper/0", pid 1, jiffies 4294892475 (age 33.128s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff813adfc1>] kmemleak_alloc+0x21/0x50
    [<ffffffff810e7b43>] __kmalloc+0x103/0x460
    [<ffffffff810c091e>] register_shrinker+0x7e/0xa0
    [<ffffffff810f394e>] sget+0x59e/0x670
    [<ffffffff810f463a>] mount_bdev+0xba/0x1e0
    [<ffffffff81175460>] ext4_mount+0x10/0x20
    [<ffffffff810f4950>] mount_fs+0x10/0xc0
    [<ffffffff81111c5a>] vfs_kern_mount+0x5a/0xf0
    [<ffffffff811133ca>] do_mount+0x1da/0x9d0
    [<ffffffff81113c3e>] SyS_mount+0x7e/0xc0
    [<ffffffff8184c245>] mount_block_root+0x104/0x223
    [<ffffffff8184c455>] mount_root+0xf1/0xfa
    [<ffffffff8184c58e>] prepare_namespace+0x130/0x168
    [<ffffffff8184bff8>] kernel_init_freeable+0x185/0x192
    [<ffffffff813ab7f9>] kernel_init+0x9/0x180
    [<ffffffff813c963c>] ret_from_fork+0x7c/0xb0
unreferenced object 0xffff88000692b1c0 (size 256):
  comm "swapper/0", pid 1, jiffies 4294892648 (age 32.500s)
  hex dump (first 32 bytes):
    00 00 00 00 ad 4e ad de ff ff ff ff 00 00 00 00  .....N..........
    ff ff ff ff ff ff ff ff 0c 0d 36 82 ff ff ff ff  ..........6.....
  backtrace:
    [<ffffffff813adfc1>] kmemleak_alloc+0x21/0x50
    [<ffffffff810e7b43>] __kmalloc+0x103/0x460
    [<ffffffff810cdd81>] list_lru_init+0x21/0xb0
    [<ffffffff810f36b5>] sget+0x305/0x670
    [<ffffffff810f463a>] mount_bdev+0xba/0x1e0
    [<ffffffff81175460>] ext4_mount+0x10/0x20
    [<ffffffff810f4950>] mount_fs+0x10/0xc0
    [<ffffffff81111c5a>] vfs_kern_mount+0x5a/0xf0
    [<ffffffff811133ca>] do_mount+0x1da/0x9d0
    [<ffffffff81113c3e>] SyS_mount+0x7e/0xc0
    [<ffffffff8184c245>] mount_block_root+0x104/0x223
    [<ffffffff8184c455>] mount_root+0xf1/0xfa
    [<ffffffff8184c58e>] prepare_namespace+0x130/0x168
    [<ffffffff8184bff8>] kernel_init_freeable+0x185/0x192
    [<ffffffff813ab7f9>] kernel_init+0x9/0x180
    [<ffffffff813c963c>] ret_from_fork+0x7c/0xb0
unreferenced object 0xffff88000692b2c0 (size 256):
  comm "swapper/0", pid 1, jiffies 4294892648 (age 32.500s)
  hex dump (first 32 bytes):
    00 00 00 00 ad 4e ad de ff ff ff ff 00 00 00 00  .....N..........
    ff ff ff ff ff ff ff ff 0c 0d 36 82 ff ff ff ff  ..........6.....
  backtrace:
    [<ffffffff813adfc1>] kmemleak_alloc+0x21/0x50
    [<ffffffff810e7b43>] __kmalloc+0x103/0x460
    [<ffffffff810cdd81>] list_lru_init+0x21/0xb0
    [<ffffffff810f36c9>] sget+0x319/0x670
    [<ffffffff810f463a>] mount_bdev+0xba/0x1e0
    [<ffffffff81175460>] ext4_mount+0x10/0x20
    [<ffffffff810f4950>] mount_fs+0x10/0xc0
    [<ffffffff81111c5a>] vfs_kern_mount+0x5a/0xf0
    [<ffffffff811133ca>] do_mount+0x1da/0x9d0
    [<ffffffff81113c3e>] SyS_mount+0x7e/0xc0
    [<ffffffff8184c245>] mount_block_root+0x104/0x223
    [<ffffffff8184c455>] mount_root+0xf1/0xfa
    [<ffffffff8184c58e>] prepare_namespace+0x130/0x168
    [<ffffffff8184bff8>] kernel_init_freeable+0x185/0x192
    [<ffffffff813ab7f9>] kernel_init+0x9/0x180
    [<ffffffff813c963c>] ret_from_fork+0x7c/0xb0
unreferenced object 0xffff880006916780 (size 32):
  comm "swapper/0", pid 1, jiffies 4294892648 (age 32.500s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff813adfc1>] kmemleak_alloc+0x21/0x50
    [<ffffffff810e7b43>] __kmalloc+0x103/0x460
    [<ffffffff810c091e>] register_shrinker+0x7e/0xa0
    [<ffffffff810f394e>] sget+0x59e/0x670
    [<ffffffff810f463a>] mount_bdev+0xba/0x1e0
    [<ffffffff81175460>] ext4_mount+0x10/0x20
    [<ffffffff810f4950>] mount_fs+0x10/0xc0
    [<ffffffff81111c5a>] vfs_kern_mount+0x5a/0xf0
    [<ffffffff811133ca>] do_mount+0x1da/0x9d0
    [<ffffffff81113c3e>] SyS_mount+0x7e/0xc0
    [<ffffffff8184c245>] mount_block_root+0x104/0x223
    [<ffffffff8184c455>] mount_root+0xf1/0xfa
    [<ffffffff8184c58e>] prepare_namespace+0x130/0x168
    [<ffffffff8184bff8>] kernel_init_freeable+0x185/0x192
    [<ffffffff813ab7f9>] kernel_init+0x9/0x180
    [<ffffffff813c963c>] ret_from_fork+0x7c/0xb0
#

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
