From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 119481] New: UBSAN: Undefined behaviour in
 /home/vitti/1tb/vitti/rpmbuild/SOURCES/linux-4.5/fs/ext4/mballoc.c:2612
Date: Thu, 02 Jun 2016 04:40:35 +0000
Message-ID: <bug-119481-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:41053 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744AbcFBEki (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Jun 2016 00:40:38 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 48DBA203AB
	for <linux-ext4@vger.kernel.org>; Thu,  2 Jun 2016 04:40:37 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 845D1203A4
	for <linux-ext4@vger.kernel.org>; Thu,  2 Jun 2016 04:40:35 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=119481

            Bug ID: 119481
           Summary: UBSAN: Undefined behaviour in
                    /home/vitti/1tb/vitti/rpmbuild/SOURCES/linux-4.5/fs/ex
                    t4/mballoc.c:2612
           Product: File System
           Version: 2.5
    Kernel Version: 4.5.5
          Hardware: x86-64
                OS: Linux
              Tree: Fedora
            Status: NEW
          Severity: low
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: zeccav@gmail.com
        Regression: No

At boot time I get the following:

Jun 02 06:01:26 nero21 kernel:
================================================================================
Jun 02 06:01:26 nero21 kernel: UBSAN: Undefined behaviour in
/home/vitti/1tb/vitti/rpmbuild/SOURCES/linux-4.5/fs/ext4/mballoc.c:2612:15
Jun 02 06:01:26 nero21 kernel: shift exponent 4294967295 is too large for
32-bit type 'int'
Jun 02 06:01:26 nero21 kernel: CPU: 0 PID: 754 Comm: mount Not tainted 4.5.5 #1
Jun 02 06:01:26 nero21 kernel: Hardware name: To Be Filled By O.E.M. To Be
Filled By O.E.M./H81M-DGS R2.0, BIOS P1.30 07/02/2014
Jun 02 06:01:26 nero21 kernel:  0000000000000000 000000000b2c65d9
ffff8803ffae7b18 ffffffff820d38ba
Jun 02 06:01:26 nero21 kernel:  00000000fffffff3 000000000b2c65d9
ffff8803ffae7b40 ffffffff87f8c73e
Jun 02 06:01:26 nero21 kernel:  ffff8803ffae7b30 ffffffff8215e6a4
00000000ffffffff ffff8803ffae7bc0
Jun 02 06:01:26 nero21 kernel: Call Trace:
Jun 02 06:01:26 nero21 kernel:  [<ffffffff820d38ba>] dump_stack+0x74/0xaf
Jun 02 06:01:26 nero21 kernel:  [<ffffffff8215e6a4>] ubsan_epilogue+0xd/0x3b
Jun 02 06:01:26 nero21 kernel:  [<ffffffff8215eff5>]
__ubsan_handle_shift_out_of_bounds+0xf9/0x14b
Jun 02 06:01:26 nero21 kernel:  [<ffffffff8142261f>] ?
kmem_cache_create+0x11a/0x2b9
Jun 02 06:01:26 nero21 kernel:  [<ffffffff816d13ea>] ext4_mb_init+0x83c/0xaa4
Jun 02 06:01:26 nero21 kernel:  [<ffffffff816d6109>] ?
ext4_setup_system_zone+0x1a1/0x339
Jun 02 06:01:26 nero21 kernel:  [<ffffffff816a52a5>]
ext4_fill_super+0x401e/0x4e2b
Jun 02 06:01:26 nero21 kernel:  [<ffffffff820eb296>] ? snprintf+0x49/0x68
Jun 02 06:01:26 nero21 kernel:  [<ffffffff816a1287>] ?
ext4_calculate_overhead+0x90e/0x90e
Jun 02 06:01:26 nero21 kernel:  [<ffffffff814d7f9f>] mount_bdev+0x18e/0x1e3
Jun 02 06:01:26 nero21 kernel:  [<ffffffff816a1287>] ?
ext4_calculate_overhead+0x90e/0x90e
Jun 02 06:01:26 nero21 kernel:  [<ffffffff8167e035>] ext4_mount+0x15/0x17
Jun 02 06:01:26 nero21 kernel:  [<ffffffff814d825e>] mount_fs+0x4b/0x1d1
Jun 02 06:01:26 nero21 kernel:  [<ffffffff81508b1b>] vfs_kern_mount+0x6c/0x18d
Jun 02 06:01:26 nero21 kernel:  [<ffffffff8150a804>] do_mount+0x298/0x168c
Jun 02 06:01:26 nero21 kernel:  [<ffffffff814d9d90>] ? vfs_fstatat+0x66/0xc0
Jun 02 06:01:26 nero21 kernel:  [<ffffffff814126e2>] ? strndup_user+0x4e/0x88
Jun 02 06:01:26 nero21 kernel:  [<ffffffff8141265b>] ? memdup_user+0x3b/0x74
Jun 02 06:01:26 nero21 kernel:  [<ffffffff8150c13b>] SyS_mount+0x83/0xd0
Jun 02 06:01:26 nero21 kernel:  [<ffffffff865aa3ee>]
entry_SYSCALL_64_fastpath+0x12/0x71
Jun 02 06:01:26 nero21 kernel:
================================================================================

mballoc.c:2612 is "offset += 1 << (sb->s_blocksize_bits - i);"

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
