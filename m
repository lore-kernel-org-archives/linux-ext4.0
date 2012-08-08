From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 45741] New: ext4 scans all disk when calling fallocate after
 mount on 99% full volume.
Date: Wed,  8 Aug 2012 16:42:47 +0000 (UTC)
Message-ID: <bug-45741-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:55563 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758837Ab2HHQmu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 8 Aug 2012 12:42:50 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 0879320228
	for <linux-ext4@vger.kernel.org>; Wed,  8 Aug 2012 16:42:49 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id EFB492021B
	for <linux-ext4@vger.kernel.org>; Wed,  8 Aug 2012 16:42:47 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=45741

           Summary: ext4 scans all disk when calling fallocate after mount
                    on 99% full volume.
           Product: File System
           Version: 2.5
    Kernel Version: 3.2.0-23-generic
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: mirek@me.com
        Regression: No


Created an attachment (id=77131)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=77131)
block io graph

It seems I can reproduce this problem every time.

After filling up 55TB EXT4 volume (0-50MB fallocated only files; 10% of them
were being deleted to fragment space more) to 99% full I've run into a problem
where the whole system freezes for ~5 minutes, to reproduce:

1) unmount filesystem
2) mount filesystem
3) fallocate a file

It seem that every time the system freezes for about 5 minutes.

Initially I thought the disk was doing nothing, but in fact the os seems to
scan the whole disk before continuing (graph attached) - it looks like it's
reading every single inode before proceeding with fallocate?

Kernel logs the same thing every time:

Aug  8 17:05:09 XXX kernel: [189400.847170] INFO: task jbd2/sdc1-8:18852
blocked for more than 120 seconds.
Aug  8 17:05:09 XXX kernel: [189400.847561] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug  8 17:05:09 XXX kernel: [189400.868909] jbd2/sdc1-8     D ffffffff81806240 
   0 18852      2 0x00000000
Aug  8 17:05:09 XXX kernel: [189400.868915]  ffff8801a1e33ce0 0000000000000046
ffff8801a1e33c80 ffffffff811a86ce
Aug  8 17:05:09 XXX kernel: [189400.868920]  ffff8801a1e33fd8 ffff8801a1e33fd8
ffff8801a1e33fd8 0000000000013780
Aug  8 17:05:09 XXX kernel: [189400.868925]  ffffffff81c0d020 ffff8802320ec4d0
ffff8801a1e33cf0 ffff8801a1e33df8
Aug  8 17:05:09 XXX kernel: [189400.868929] Call Trace:
Aug  8 17:05:09 XXX kernel: [189400.868940]  [<ffffffff811a86ce>] ?
__wait_on_buffer+0x2e/0x30
Aug  8 17:05:09 XXX kernel: [189400.868947]  [<ffffffff8165a55f>]
schedule+0x3f/0x60
Aug  8 17:05:09 XXX kernel: [189400.868955]  [<ffffffff8126052a>]
jbd2_journal_commit_transaction+0x18a/0x1240
Aug  8 17:05:09 XXX kernel: [189400.868962]  [<ffffffff8165c6fe>] ?
_raw_spin_lock_irqsave+0x2e/0x40
Aug  8 17:05:09 XXX kernel: [189400.868970]  [<ffffffff81077198>] ?
lock_timer_base.isra.29+0x38/0x70
Aug  8 17:05:09 XXX kernel: [189400.868976]  [<ffffffff8108aec0>] ?
add_wait_queue+0x60/0x60
Aug  8 17:05:09 XXX kernel: [189400.868982]  [<ffffffff812652ab>]
kjournald2+0xbb/0x220
Aug  8 17:05:09 XXX kernel: [189400.868988]  [<ffffffff8108aec0>] ?
add_wait_queue+0x60/0x60
Aug  8 17:05:09 XXX kernel: [189400.868993]  [<ffffffff812651f0>] ?
commit_timeout+0x10/0x10
Aug  8 17:05:09 XXX kernel: [189400.868999]  [<ffffffff8108a42c>]
kthread+0x8c/0xa0
Aug  8 17:05:09 XXX kernel: [189400.869005]  [<ffffffff81666bf4>]
kernel_thread_helper+0x4/0x10
Aug  8 17:05:09 XXX kernel: [189400.869011]  [<ffffffff8108a3a0>] ?
flush_kthread_worker+0xa0/0xa0
Aug  8 17:05:09 XXX kernel: [189400.869016]  [<ffffffff81666bf0>] ?
gs_change+0x13/0x13

Is this normal?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
