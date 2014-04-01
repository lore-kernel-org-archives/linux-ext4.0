From: Eric Whitney <enwlinux@gmail.com>
Subject: xfstest generic/020 failure on nojournal in ext4 dev branch
Date: Tue, 1 Apr 2014 17:20:43 -0400
Message-ID: <20140401212043.GA2165@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qa0-f50.google.com ([209.85.216.50]:63444 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbaDAVUs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Apr 2014 17:20:48 -0400
Received: by mail-qa0-f50.google.com with SMTP id o15so10300195qap.9
        for <linux-ext4@vger.kernel.org>; Tue, 01 Apr 2014 14:20:47 -0700 (PDT)
Received: from wallace (c-75-67-250-69.hsd1.nh.comcast.net. [75.67.250.69])
        by mx.google.com with ESMTPSA id g18sm17881910qaa.11.2014.04.01.14.20.46
        for <linux-ext4@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Tue, 01 Apr 2014 14:20:46 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I'm seeing a problem in the dev branch when running xfstests on a non-journaled
filesystem.  (All the other xfstests-bld scenarios are looking good in
comparison with my 3.14 baseline.)

The test in question is generic/020, and it simply causes a BUG (null pointer
dereference) that stops the test run.  Tip of my dev branch is 2c74cd642a.
The last commits on there look like possible candidates given the stack trace.

Eric


BUG: unable to handle kernel NULL pointer dereference at 0000000000000020
IP: [<ffffffff8120531d>] mb_cache_entry_find_first+0x4d/0xb0
PGD 78cf7067 PUD 7512c067 PMD 0
Oops: 0000 [#1] SMP
Modules linked in: kvm_intel kvm microcode psmouse serio_raw virtio_balloon i2c_piix4
CPU: 1 PID: 23821 Comm: attr Not tainted 3.14.0-rc2-dev+ #1
Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
task: ffff88007a4820e0 ti: ffff880075022000 task.ti: ffff880075022000
RIP: 0010:[<ffffffff8120531d>]  [<ffffffff8120531d>] mb_cache_entry_find_first+0x4d/0xb0
RSP: 0018:ffff880075023b30  EFLAGS: 00010202
RAX: 0000000000000000 RBX: fffc7167da5e4252 RCX: 0000000000000040
RDX: 00000000e3a64252 RSI: 4000000000000000 RDI: 0000000000000000
RBP: ffff880075023b38 R08: 1dec7167da5e4252 R09: ffff88007cc28b00
R10: 1290000000000000 R11: 00038e9909480000 R12: 0000000000000000
R13: ffff880075023be8 R14: ffff880074505000 R15: ffff88007760a970
FS:  00007f4fdb0ed740(0000) GS:ffff88007fd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000020 CR3: 0000000078cca000 CR4: 00000000000006e0
Stack:
 ffff880075023c08 ffff880075023bc8 ffffffff8128dbec 0000000000000000
 ffff880075023c08 ffff880075023ba8 e3a642528128d164 ffff880074505000
 ffff88005394e000 ffff88007760a970 0000000000000000 0000000000000001
Call Trace:
 [<ffffffff8128dbec>] ext4_xattr_block_set+0x21c/0x940
 [<ffffffff8128ee68>] ext4_xattr_set_handle+0x328/0x470
 [<ffffffff8128f093>] ext4_xattr_set+0xe3/0x130
 [<ffffffff8128fa02>] ext4_xattr_user_set+0x42/0x50
 [<ffffffff811ccda5>] generic_setxattr+0x65/0x80
 [<ffffffff811cd5b3>] __vfs_setxattr_noperm+0x63/0x1b0
 [<ffffffff8131192e>] ? evm_inode_setxattr+0xe/0x10
 [<ffffffff811cd7b5>] vfs_setxattr+0xb5/0xc0
 [<ffffffff811cd8de>] setxattr+0x11e/0x1b0
 [<ffffffff811c8324>] ? mnt_want_write+0x24/0x50
 [<ffffffff811a9315>] ? __sb_start_write+0xe5/0x190
 [<ffffffff811c8324>] ? mnt_want_write+0x24/0x50
 [<ffffffff811c8324>] ? mnt_want_write+0x24/0x50
 [<ffffffff811cdc4f>] SyS_lsetxattr+0x8f/0xd0
 [<ffffffff816dcbd2>] system_call_fastpath+0x16/0x1b
Code: 36 49 c1 e2 33 4c 29 db 48 89 c6 48 89 c1 49 01 d8 48 c1 e6 3d 48 c1 e1 39 4d 29 d0 48 c1 e0 3f 49 01 f0 49 29 c8 b9 40 00 00 00 <2b> 4f 20 4c 01 c0 48 d3 e8 48 8b 4f 38 89 c0 48 8d 34\

RIP  [<ffffffff8120531d>] mb_cache_entry_find_first+0x4d/0xb0
 RSP <ffff880075023b30>
CR2: 0000000000000020
---[ end trace 60f350cf998b7d0e ]---

