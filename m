From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43821] New: Possible ext4 bug
Date: Tue, 26 Jun 2012 06:32:29 +0000 (UTC)
Message-ID: <bug-43821-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:48661 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276Ab2FZGcd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Jun 2012 02:32:33 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 5AB2B20252
	for <linux-ext4@vger.kernel.org>; Tue, 26 Jun 2012 06:32:32 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 92ECF2020D
	for <linux-ext4@vger.kernel.org>; Tue, 26 Jun 2012 06:32:30 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=43821

           Summary: Possible ext4 bug
           Product: File System
           Version: 2.5
    Kernel Version: 3.2.12-gentoo
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: killian.de.volder@megasoft.be
        Regression: No


My computer has been running fine for a while with this kernel, but suddenly
this happened (once).

If more info is required, please ask, I'll do my best to provide all you need.

BUG: unable to handle kernel NULL pointer dereference at           (null)
IP: [<ffffffff811e986f>] ext4_mb_good_group+0x5f/0x130
PGD 21ee03067 PUD 21ee09067 PMD 0 
Oops: 0000 [#1] SMP 
CPU 1 
Modules linked in: nvidia(P) snd_emu10k1 snd_rawmidi snd_ac97_codec ac97_bus
snd_pcm snd_seq_device snd_timer snd_page_alloc snd_util_mem snd_hwdep snd
soundcore [last unloaded: nvidia]

Pid: 3119, comm: flush-252:2 Tainted: P           O 3.2.12-gentoo #2 Gigabyte
Technology Co., Ltd. GA-MA790X-UD3P/GA-MA790X-UD3P
RIP: 0010:[<ffffffff811e986f>]  [<ffffffff811e986f>]
ext4_mb_good_group+0x5f/0x130
RSP: 0018:ffff8802230016d0  EFLAGS: 00010293
RAX: ffff880222170c00 RBX: 00000000000003f0 RCX: 0000000000000070
RDX: 0000000000000000 RSI: ffff880225106000 RDI: ffff880226116400
RBP: ffff880224a6a088 R08: 0000000000000007 R09: 0000000000002238
R10: 0000000000000003 R11: 0000000000100000 R12: 0000000000000000
R13: 0000000000000000 R14: 00000000000003f0 R15: 0000000000000001
FS:  00007fdc09923720(0000) GS:ffff88022fc80000(0000) knlGS:00000000f6f21b70
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000222305000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process flush-252:2 (pid: 3119, threadinfo ffff880223000000, task
ffff880223f74500)
Stack:
 0000000000011200 ffff880224a6a088 00000000000003c0 ffff880224a6a088
 0000000000000000 00000000000003c0 ffff880226116400 ffffffff811ebd90
 0000000000000086 ffffffff81051484 ffff880226114400 0000000000000000
Call Trace:
 [<ffffffff811ebd90>] ? ext4_mb_regular_allocator+0x170/0x3c0
 [<ffffffff81051484>] ? gart_map_sg+0x404/0x440
 [<ffffffff811ed5aa>] ? ext4_mb_new_blocks+0x2ea/0x3e0
 [<ffffffff811f1eda>] ? ext4_alloc_branch+0x3aa/0x5a0
 [<ffffffff811f1b07>] ? ext4_get_branch+0x107/0x130
 [<ffffffff811f2b27>] ? ext4_ind_map_blocks+0x247/0x620
 [<ffffffff811cb53d>] ? ext4_map_blocks+0xed/0x2c0
 [<ffffffff811cf435>] ? mpage_da_map_and_submit+0xc5/0x470
 [<ffffffff811d9998>] ? ext4_journal_start_sb+0x68/0x160
 [<ffffffff811cfeab>] ? ext4_da_writepages+0x28b/0x470
 [<ffffffff8112dd6b>] ? writeback_single_inode+0x16b/0x350
 [<ffffffff8112e3b5>] ? writeback_sb_inodes+0x1e5/0x290
 [<ffffffff8112e4f6>] ? __writeback_inodes_wb+0x96/0xc0
 [<ffffffff8112e72b>] ? wb_writeback+0x20b/0x220
 [<ffffffff811229b1>] ? get_nr_inodes+0x41/0x60
 [<ffffffff8112eaca>] ? wb_do_writeback+0x1aa/0x1c0
 [<ffffffff8112eb62>] ? bdi_writeback_thread+0x82/0x150
 [<ffffffff8112eae0>] ? wb_do_writeback+0x1c0/0x1c0
 [<ffffffff8112eae0>] ? wb_do_writeback+0x1c0/0x1c0
 [<ffffffff81097146>] ? kthread+0x96/0xa0
 [<ffffffff8165cb34>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff810970b0>] ? kthread_worker_fn+0x120/0x120
 [<ffffffff8165cb30>] ? gs_change+0xb/0xb
Code: 28 02 00 00 44 8b a0 e0 02 00 00 41 d3 e8 48 8b 48 38 45 89 c0 4a 8b 04
c6 48 ff c9 21 d9 83 fa 03 4c 8b 2c c8 0f 87 c8 00 00 00 <49> 8b 45 00 a8 01 75
61 41 8b 45 14 41 8b 4d 18 85 c0 74 6d 85 
RIP  [<ffffffff811e986f>] ext4_mb_good_group+0x5f/0x130
 RSP <ffff8802230016d0>
CR2: 0000000000000000
---[ end trace 1e3ba02eddf7210a ]---

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
