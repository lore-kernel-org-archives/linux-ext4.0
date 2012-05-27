From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43305] New: Deleting a folder with 500 000 small files causes
 deadlock in start_this_handle.irsa.7
Date: Sun, 27 May 2012 20:44:29 +0000 (UTC)
Message-ID: <bug-43305-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:37387 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752745Ab2E0Uob (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 27 May 2012 16:44:31 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 38E65202DA
	for <linux-ext4@vger.kernel.org>; Sun, 27 May 2012 20:44:30 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id 616F720287
	for <linux-ext4@vger.kernel.org>; Sun, 27 May 2012 20:44:29 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=43305

           Summary: Deleting a folder with 500 000 small files causes
                    deadlock in start_this_handle.irsa.7
           Product: File System
           Version: 2.5
    Kernel Version: 3.2.0-24-generic-pae
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: aigarius@gmail.com
        Regression: No


As part of unrelated software experiment I created a folder with 500 000 small
files (10-15 bytes of content in each) and when I tried to then delete this
folder I ran into trouble - when I ran rm against files in that folder (either
the whole folder or individually or in batches) one of the rm commands would
invariably hang in Uninterruptible sleep in function start_this_handle.irsa.7
and this would block any other writes to that filesystem causing messages like
this in the kernel logs:

[  480.617348] INFO: task bounce:4006 blocked for more than 120 seconds.
[  480.617350] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[  480.617353] bounce          D ef39dec0     0  4006   1685 0x00000000
[  480.617357]  ef39df10 00000086 00000000 ef39dec0 c10f6526 f7570ca0 c1930e00
c1930e00
[  480.617365]  cd507544 00000052 f78c7e00 df428000 f7570ca0 ef39df2c c10f65c5
00000001
[  480.617372]  0000000e 00000001 d5af5a68 ef39dee0 ef39dee4 00000001 ef39deec
c1036578
[  480.617379] Call Trace:
[  480.617382]  [<c10f6526>] ? wait_on_page_bit+0x86/0x90
[  480.617386]  [<c10f65c5>] ? filemap_fdatawait_range+0x95/0x160
[  480.617391]  [<c1036578>] ? default_spin_lock_flags+0x8/0x10
[  480.617395]  [<c15a819d>] ? _raw_spin_lock_irqsave+0x2d/0x40
[  480.617399]  [<c15a65a5>] schedule+0x35/0x50
[  480.617403]  [<c12175e5>] jbd2_log_wait_commit+0x95/0x100
[  480.617408]  [<c1079e90>] ? add_wait_queue+0x50/0x50
[  480.617412]  [<c11c81f5>] ext4_sync_file+0x1f5/0x2b0
[  480.617416]  [<c11c8000>] ? ext4_flush_completed_IO+0xa0/0xa0
[  480.617421]  [<c116cf83>] vfs_fsync+0x33/0x50
[  480.617425]  [<c116d2d6>] sys_fsync+0x26/0x50
[  480.617429]  [<c15af35f>] sysenter_do_call+0x12/0x28

If a signal of SIGKILL or SIGTERM is sent to the specific rm process that is in
that function, then after up to 30 seconds the process would die and the
filesystem would continue function and all hung operations would complete. The
rm process does delete some files before the deadlock occurs, but after the
wchan of the rm process changes to start_this_handle.irsa.7 no more files are
deleted.

Rebooting the machine and forcing a fsck does not change the outcome.

This is on a PCIX type SSD drive.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
