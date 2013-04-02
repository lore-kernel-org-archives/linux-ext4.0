From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 56091] New: kernel oops when copying data to ext4 fs
Date: Tue,  2 Apr 2013 09:38:30 +0000 (UTC)
Message-ID: <bug-56091-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:51654 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759611Ab3DBJif (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Apr 2013 05:38:35 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 566D920418
	for <linux-ext4@vger.kernel.org>; Tue,  2 Apr 2013 09:38:33 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id AF96720416
	for <linux-ext4@vger.kernel.org>; Tue,  2 Apr 2013 09:38:30 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=56091

           Summary: kernel oops when copying data to ext4 fs
           Product: File System
           Version: 2.5
    Kernel Version: 3.8.5
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: dmaciejak@fortinet.com
        Regression: No


Hi,

i am doing some filesystems testing (aka fuzzing), got this issue on vanilla
3.8.5:

Apr  2 11:20:15 linux kernel: [  214.925737] JBD2: Spotted dirty metadata
buffer (dev = loop0, blocknr = 0). There's a risk of filesystem corruption in
case of system crash.
Apr  2 11:20:15 linux kernel: [  214.925778] EXT4-fs error (device loop0):
ext4_mb_mark_diskspace_used:2781: comm cp: Allocating blocks 7643-7644 which
overlap fs metadata
Apr  2 11:20:15 linux kernel: [  214.944861] EXT4-fs error (device loop0):
ext4_mb_mark_diskspace_used:2781: comm cp: Allocating blocks 7646-7647 which
overlap fs metadata
Apr  2 11:20:15 linux kernel: [  214.963965] EXT4-fs error (device loop0):
ext4_mb_mark_diskspace_used:2781: comm cp: Allocating blocks 26555-26556 which
overlap fs metadata
Apr  2 11:20:15 linux kernel: [  214.983102] EXT4-fs error (device loop0):
ext4_mb_mark_diskspace_used:2781: comm cp: Allocating blocks 7640-7641 which
overlap fs metadata
Apr  2 11:20:15 linux kernel: [  215.002272] EXT4-fs error (device loop0):
ext4_mb_mark_diskspace_used:2781: comm cp: Allocating blocks 26553-26554 which
overlap fs metadata
Apr  2 11:20:15 linux kernel: [  215.021448] EXT4-fs error (device loop0):
ext4_mb_mark_diskspace_used:2781: comm cp: Allocating blocks 26559-26560 which
overlap fs metadata
Apr  2 11:20:15 linux kernel: [  215.040668] EXT4-fs error (device loop0):
ext4_mb_mark_diskspace_used:2781: comm cp: Allocating blocks 7644-7645 which
overlap fs metadata
Apr  2 11:20:15 linux kernel: [  215.059921] EXT4-fs error (device loop0):
ext4_mb_mark_diskspace_used:2781: comm cp: Allocating blocks 7647-7648 which
overlap fs metadata

Apr  2 11:22:43 linux kernel: [  362.827503] INFO: task jbd2/loop0-8:1853
blocked for more than 120 seconds.
Apr  2 11:22:43 linux kernel: [  362.837075] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Apr  2 11:22:43 linux kernel: [  362.846633] jbd2/loop0-8    D ffff880227233f00
    0  1853      2 0x00000000
Apr  2 11:22:43 linux kernel: [  362.846637]  ffff8802087c5c88 0000000000000046
ffff880206795c00 ffff8802087c5fd8
Apr  2 11:22:43 linux kernel: [  362.846641]  ffff8802087c5fd8 ffff8802087c5fd8
ffff880225d49700 ffff880206795c00
Apr  2 11:22:43 linux kernel: [  362.846644]  ffff8802087c5c98 ffff8802087c5d80
ffff8802080970e0 ffff8802087c5d68
Apr  2 11:22:43 linux kernel: [  362.846654] Call Trace:
Apr  2 11:22:43 linux kernel: [  362.846663]  [<ffffffff816b4db9>]
schedule+0x29/0x70
Apr  2 11:22:43 linux kernel: [  362.846669]  [<ffffffff8127fea1>]
jbd2_journal_commit_transaction+0x211/0x1930
Apr  2 11:22:43 linux kernel: [  362.846676]  [<ffffffff8101358e>] ?
__switch_to+0x13e/0x4a0
Apr  2 11:22:43 linux kernel: [  362.846686]  [<ffffffff810999c0>] ?
idle_balance+0x1b0/0x300
Apr  2 11:22:43 linux kernel: [  362.846689]  [<ffffffff8107e080>] ?
finish_wait+0x80/0x80
Apr  2 11:22:43 linux kernel: [  362.846694]  [<ffffffff816b5fde>] ?
_raw_spin_lock_irqsave+0x2e/0x40
Apr  2 11:22:43 linux kernel: [  362.846702]  [<ffffffff81069baf>] ?
try_to_del_timer_sync+0x4f/0x70
Apr  2 11:22:43 linux kernel: [  362.846707]  [<ffffffff81285f6d>]
kjournald2+0xbd/0x240
Apr  2 11:22:43 linux kernel: [  362.846710]  [<ffffffff8107e080>] ?
finish_wait+0x80/0x80
Apr  2 11:22:43 linux kernel: [  362.846713]  [<ffffffff81285eb0>] ?
jbd2_journal_release_jbd_inode+0x130/0x130
Apr  2 11:22:43 linux kernel: [  362.846716]  [<ffffffff8107d730>]
kthread+0xc0/0xd0
Apr  2 11:22:43 linux kernel: [  362.846719]  [<ffffffff8107d670>] ?
kthread_create_on_node+0x130/0x130
Apr  2 11:22:43 linux kernel: [  362.846723]  [<ffffffff816be5ac>]
ret_from_fork+0x7c/0xb0
Apr  2 11:22:43 linux kernel: [  362.846733]  [<ffffffff8107d670>] ?
kthread_create_on_node+0x130/0x130



how to reproduce:

*you need* to be root to issue the cmds below

mkdir /media/test
gunzip ext4.poc.img.gz
mount -t ext4 -o loop ext4.poc.img /media/test/
ls -alR /media/test
cp /etc/passwd /media/test/INSTALL


Copy will never return, CPU is reaching 100% and call trace is written some
minutes after.
Hope this help.


best regards,

David Maciejak
Fortinet's FortiGuard Labs

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
