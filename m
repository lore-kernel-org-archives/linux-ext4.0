Return-Path: <SRS0=48F3=M5=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:33002 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727013AbeJQUwO (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 17 Oct 2018 16:52:14 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 1E5582AFAE
        for <linux-ext4@vger.kernel.org>; Wed, 17 Oct 2018 12:56:38 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201461] New: ext4 journal stalls write system call
Date: Wed, 17 Oct 2018 12:56:38 +0000
Message-ID: <bug-201461-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201461

            Bug ID: 201461
           Summary: ext4 journal stalls write system call
           Product: File System
           Version: 2.5
    Kernel Version: 3.10.0-229.el7.x86_64
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: zhenbianshu@foxmail.com
        Regression: No

I am using CentOS 7.1.1503 with kernel linux 3.10.0-229.el7.x86_64, ext4 file
system with ordered journal mode, and delalloc enabled.

When my app writes logs to a file continually (about 6M/s), I can find the
write system call stalled for 100-700 ms occasionally, When I disable ext4's
journal feature, or set the journal mode to writeback, or disable delay
allocate, the stalling disappears. When I set linux's writeback more frequent,
dirty page expire time shorter, the problem reduced. 

I printed the process's stack when stalling happends, I got this:


[<ffffffff812e31f4>] call_rwsem_down_read_failed+0x14/0x30
[<ffffffffa0195854>] ext4_da_get_block_prep+0x1a4/0x4b0 [ext4]
[<ffffffff811fbe17>] __block_write_begin+0x1a7/0x490
[<ffffffffa019b71c>] ext4_da_write_begin+0x15c/0x340 [ext4]
[<ffffffff8115685e>] generic_file_buffered_write+0x11e/0x290
[<ffffffff811589c5>] __generic_file_aio_write+0x1d5/0x3e0
[<ffffffff81158c2d>] generic_file_aio_write+0x5d/0xc0
[<ffffffffa0190b75>] ext4_file_write+0xb5/0x460 [ext4]
[<ffffffff811c64cd>] do_sync_write+0x8d/0xd0
[<ffffffff811c6c6d>] vfs_write+0xbd/0x1e0
[<ffffffff811c76b8>] SyS_write+0x58/0xb0
[<ffffffff81614a29>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff


I read the source code of linux kernel, and found that
call_rwsem_down_read_failed will call rwsem_down_read_failed which will keep
waiting for rw_semaphore.

I think the reason is that metadata journal flushing must wait for related
dirty pages flushed, when dirty pages flushing took long time, the journal
blocked, and journal commit has this inode's rw_semaphore, write system call to
this inode is stalled.

I really hope I can find evidence to prove it.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
