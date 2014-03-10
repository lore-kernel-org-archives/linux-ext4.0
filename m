From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 71791] New: Unlinking a file that was moved to another folder
 but still open by other process blocks either process (not always
 reproducible)
Date: Mon, 10 Mar 2014 14:01:44 +0000
Message-ID: <bug-71791-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:47644 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752628AbaCJOBr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Mar 2014 10:01:47 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 99DAF20251
	for <linux-ext4@vger.kernel.org>; Mon, 10 Mar 2014 14:01:46 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 8106020257
	for <linux-ext4@vger.kernel.org>; Mon, 10 Mar 2014 14:01:44 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=71791

            Bug ID: 71791
           Summary: Unlinking a file that was moved to another folder but
                    still open by other process blocks either process (not
                    always reproducible)
           Product: File System
           Version: 2.5
    Kernel Version: 3.12.9
          Hardware: All
                OS: Linux
              Tree: PREEMPT_RT
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: edpeur@gmail.com
        Regression: No

Either the rm process or more rarely the process that has the file open will
block when a file that was moved to other folder is unlinked while still open
by other process. This is not always reproducible, but like 20% reproducible.

Here is the most common trace:

[27600.716129] INFO: task rm:28925 blocked for more than 120 seconds.
[27600.716139]       Tainted: G        W    3.12-1-rt-amd64 #1
[27600.716142] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[27600.716147] rm              D ffff88007eb8a5f0     0 28925  28924 0x00000004
[27600.716159]  ffff88007eb8a280 0000000000000086 ffff88004542bfd8
ffff88004542bfd8
[27600.716162]  ffff88004542bfd8 ffff88004542bfd8 ffff88007eb8a280
ffff88007eb8a280
[27600.716165]  0000000000000002 ffffffff81123410 ffff88004542bd50
ffff88004542bdb8
[27600.716172] Call Trace:
[27600.716185]  [<ffffffff81123410>] ? wait_on_page_read+0x60/0x60
[27600.716190]  [<ffffffff814aecb1>] ? schedule+0x21/0x90
[27600.716194]  [<ffffffff814aeda3>] ? io_schedule+0x83/0xd0
[27600.716197]  [<ffffffff81123415>] ? sleep_on_page+0x5/0x10
[27600.716201]  [<ffffffff814ad594>] ? __wait_on_bit+0x54/0x80
[27600.716204]  [<ffffffff8112322f>] ? wait_on_page_bit+0x7f/0x90
[27600.716209]  [<ffffffff81082050>] ? wake_atomic_t_function+0x30/0x30
[27600.716213]  [<ffffffff81130795>] ? pagevec_lookup+0x15/0x20
[27600.716217]  [<ffffffff8113284b>] ? truncate_inode_pages_range+0x26b/0x490
[27600.716265]  [<ffffffffa02f944d>] ? ext4_evict_inode+0x13d/0x540 [ext4]
[27600.716270]  [<ffffffff8119e055>] ? evict+0xb5/0x1b0
[27600.716279]  [<ffffffff8119180b>] ? do_unlinkat+0x19b/0x250
[27600.716282]  [<ffffffff81090140>] ? migrate_enable+0xa0/0x1e0
[27600.716286]  [<ffffffff811c3795>] ? fsnotify_find_inode_mark+0x65/0x90
[27600.716288]  [<ffffffff811c4d64>] ? dnotify_flush+0x34/0x110
[27600.716291]  [<ffffffff814b7ab9>] ? system_call_fastpath+0x16/0x1b

And this trace has only happened once:

[49440.736350] INFO: task mplayer:30035 blocked for more than 120 seconds.
[49440.736360]       Tainted: G        W    3.12-1-rt-amd64 #1
[49440.736362] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[49440.736365] mplayer         D ffff88001d4dd9b0     0 30035  23580 0x00000000
[49440.736375]  ffff88001d4dd640 0000000000000086 ffff88003e31bfd8
ffff88003e31bfd8
[49440.736377]  ffff88003e31bfd8 ffff88003e31bfd8 ffff88001d4dd640
ffff88001d4dd640
[49440.736379]  0000000000000002 ffffffff81123410 ffff88003e31bd40
ffff88003e31bda0
[49440.736383] Call Trace:
[49440.736396]  [<ffffffff81123410>] ? wait_on_page_read+0x60/0x60
[49440.736400]  [<ffffffff814aecb1>] ? schedule+0x21/0x90
[49440.736403]  [<ffffffff814aeda3>] ? io_schedule+0x83/0xd0
[49440.736405]  [<ffffffff81123415>] ? sleep_on_page+0x5/0x10
[49440.736407]  [<ffffffff814ad594>] ? __wait_on_bit+0x54/0x80
[49440.736409]  [<ffffffff8112322f>] ? wait_on_page_bit+0x7f/0x90
[49440.736412]  [<ffffffff81082050>] ? wake_atomic_t_function+0x30/0x30
[49440.736416]  [<ffffffff81130795>] ? pagevec_lookup+0x15/0x20
[49440.736419]  [<ffffffff8113284b>] ? truncate_inode_pages_range+0x26b/0x490
[49440.736491]  [<ffffffffa031944d>] ? ext4_evict_inode+0x13d/0x540 [ext4]
[49440.736495]  [<ffffffff8119e055>] ? evict+0xb5/0x1b0
[49440.736497]  [<ffffffff8119a2b8>] ? dentry_kill+0x218/0x270
[49440.736499]  [<ffffffff8119a374>] ? dput+0x64/0x110
[49440.736502]  [<ffffffff811857fb>] ? __fput+0x13b/0x200
[49440.736505]  [<ffffffff8107e077>] ? task_work_run+0x97/0xd0
[49440.736510]  [<ffffffff810149e1>] ? do_notify_resume+0x81/0xe0
[49440.736513]  [<ffffffff814b7d76>] ? int_signal+0x12/0x17

This is the kernel used:
http://ftp.debian.org/debian/pool/main/l/linux/linux-image-3.12-1-rt-amd64_3.12.9-1_amd64.deb

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
