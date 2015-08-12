From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 102751] New: infinite loop in jbd2_journal_destroy()
Date: Wed, 12 Aug 2015 22:38:22 +0000
Message-ID: <bug-102751-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:53197 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746AbbHLWi0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Aug 2015 18:38:26 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 91492206D5
	for <linux-ext4@vger.kernel.org>; Wed, 12 Aug 2015 22:38:25 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id AF055205EC
	for <linux-ext4@vger.kernel.org>; Wed, 12 Aug 2015 22:38:23 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=102751

            Bug ID: 102751
           Summary: infinite loop in jbd2_journal_destroy()
           Product: File System
           Version: 2.5
    Kernel Version: 4.1.5
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: mihai.dontu@gmail.com
        Regression: No

While watching a video from a removable disk (USB), the connecting cable failed
(too much use) and I had to unplug it. I noticed, however, that vlc has started
consuming 100% CPU time while being zombie. An Alt+SysReq+l showed this:

NMI backtrace for cpu 2
CPU: 2 PID: 17378 Comm: vlc Tainted: G           O    4.1.5-gentoo #1
Hardware name: Dell Inc. Latitude E7440/07F3F4, BIOS A15 05/19/2015
task: ffff88029d050000 ti: ffff8802cd80c000 task.ti: ffff8802cd80c000
RIP: 0010:[<ffffffff8cec3320>]  [<ffffffff8cec3320>] mutex_unlock+0x10/0x20
RSP: 0018:ffff8802cd80fcd0  EFLAGS: 00000202
RAX: 00000000fffffffb RBX: ffff880084068000 RCX: 0000000000000000
RDX: 0000000080000001 RSI: 0000000000000000 RDI: ffff8800840680e8
RBP: ffff8802cd80fd38 R08: 000000000000000a R09: 00000000000004b0
R10: 0000000000017e98 R11: 00000000000004b0 R12: ffff880084068398
R13: ffff8800840680e8 R14: ffff8802cd80fcf0 R15: ffff8800840680a0
FS:  00007fa8ac663700(0000) GS:ffff88041eb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f5b3e946000 CR3: 000000000d80d000 CR4: 00000000001426e0
Stack:
 ffffffff8c3d1318 ffff880200000000 ffff88029d050000 ffffffff8c179cc0
 ffff8802cd80fcf0 ffff8802cd80fcf0 0000000028b119c8 ffff88015d99c400
 ffff88008406c000 ffff880185940400 ffff880084068800 ffff88029d050000
Call Trace:
 [<ffffffff8c3d1318>] ? jbd2_journal_destroy+0x138/0x240
 [<ffffffff8c179cc0>] ? wake_atomic_t_function+0x60/0x60
 [<ffffffff8c38f0e7>] ext4_put_super+0x67/0x360
 [<ffffffff8c29d726>] generic_shutdown_super+0x76/0x100
 [<ffffffff8c29dae7>] kill_block_super+0x27/0x80
 [<ffffffff8c29de59>] deactivate_locked_super+0x49/0x80
 [<ffffffff8c29e2cc>] deactivate_super+0x6c/0x80
 [<ffffffff8c2bc033>] cleanup_mnt+0x43/0xa0
 [<ffffffff8c2bc0e2>] __cleanup_mnt+0x12/0x20
 [<ffffffff8c153804>] task_work_run+0xd4/0xf0
 [<ffffffff8c139174>] do_exit+0x2f4/0xb90
 [<ffffffff8c1d381c>] ? __audit_syscall_entry+0xac/0x100
 [<ffffffff8c05f745>] ? do_audit_syscall_entry+0x55/0x80
 [<ffffffff8c139a9b>] do_group_exit+0x3b/0xb0
 [<ffffffff8c139b24>] SyS_exit_group+0x14/0x20
 [<ffffffff8cec59db>] system_call_fastpath+0x16/0x6e
Code: ff 4c 89 e7 e8 d2 1e 00 00 5b 41 5c 5d c3 0f 1f 00 66 2e 0f 1f 84 00 00
00 00 00 0f 1f 44 00 00 48 c7 47 18 00 00 00 00 f0 ff 07 <7f> 0a 55 48 89 e5 e8
95 ff ff ff 5d c3 0f 1f 00 0f 1f 44 00 00

and perf top (first 9 lines):

  18.08%  [kernel]  [k] _raw_spin_lock
  17.97%  [kernel]  [k] mutex_lock
  15.36%  [kernel]  [k] mutex_unlock
  10.89%  [kernel]  [k] _raw_spin_unlock
   6.49%  [kernel]  [k] jbd2_log_do_checkpoint
   6.16%  [kernel]  [k] preempt_count_add
   4.53%  [kernel]  [k] jbd2_cleanup_journal_tail
   3.96%  [kernel]  [k] preempt_count_sub
   3.21%  [kernel]  [k] jbd2_journal_destroy

Looking at the code it would seem that I've hit a race in:

  while (journal->j_checkpoint_transactions != NULL) { ... }

because it's waiting for a transaction that cannot take place:

Buffer I/O error on dev dm-1, logical block 243826688, lost sync page write
JBD2: Error -5 detected when updating journal superblock for dm-1-8.
Aborting journal on device dm-1-8.
Buffer I/O error on dev dm-1, logical block 243826688, lost sync page write
JBD2: Error -5 detected when updating journal superblock for dm-1-8.

Maybe the loop should be abandoned on jbd2_log_do_checkpoint() error?

The USB failure happened several times before, but I've never seen vlc get
stuck. This also means that I'm unlikely to be able to reproduce this. :-(

One more detail: the ext4 filesystem sits on top a LUKS device.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
