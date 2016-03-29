From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 115491] New: ext4_mb_generate_buddy, filesystem remounted
 read-only
Date: Tue, 29 Mar 2016 15:13:58 +0000
Message-ID: <bug-115491-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:32786 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756765AbcC2POD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Mar 2016 11:14:03 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D15E6201B9
	for <linux-ext4@vger.kernel.org>; Tue, 29 Mar 2016 15:14:00 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 3E70720306
	for <linux-ext4@vger.kernel.org>; Tue, 29 Mar 2016 15:13:59 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=115491

            Bug ID: 115491
           Summary: ext4_mb_generate_buddy, filesystem remounted read-only
           Product: File System
           Version: 2.5
    Kernel Version: 3.16.0-30
          Hardware: PPC-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: ebatewell@us.ibm.com
        Regression: No

Similar to bug 104571 (https://bugzilla.kernel.org/show_bug.cgi?id=104571), we
have observed this. Excerpt from dmesg:

[86808.174336] EXT4-fs (sda2): error count since last fsck: 12
[86808.174345] EXT4-fs (sda2): initial error at time 1458455103:
ext4_mb_generate_buddy:757
[86808.174347] EXT4-fs (sda2): last error at time 1458572059:
ext4_remount:4849: inode 8524962: block 34112270
[94597.670282] [sched_delayed] sched: RT throttling activated
[173315.491461] EXT4-fs (sda2): error count since last fsck: 12
[173315.491468] EXT4-fs (sda2): initial error at time 1458455103:
ext4_mb_generate_buddy:757
[173315.491470] EXT4-fs (sda2): last error at time 1458572059:
ext4_remount:4849: inode 8524962: block 34112270
[190512.378738] rsync[85653]: unhandled signal 11 at 00003fffe48d0000 nip
00003fff972fd054 lr 00003fff972f6560 code 30001
[212232.198189] rsync[88408]: unhandled signal 11 at 00003fffeb8f0000 nip
00003fffa475d054 lr 00003fffa4756560 code 30001
[226392.672509] rsync[90221]: unhandled signal 11 at 00003fffc6460000 nip
00003fff983cd054 lr 00003fff983c6560 code 30001
[227413.044157] rsync[90355]: unhandled signal 11 at 00003fffe93f0000 nip
00003fff7831d054 lr 00003fff78316560 code 30001
[241933.061143] rsync[92307]: unhandled signal 11 at 00003ffff9e70000 nip
00003fffb430d054 lr 00003fffb4306560 code 30001
[247565.478035] EXT4-fs error (device sda2): ext4_mb_generate_buddy:757: group
2003, block bitmap and bg descriptor inconsistent: 146 vs 145 free clusters
[247565.478052] Aborting journal on device sda2-8.
[247565.482212] EXT4-fs (sda2): Remounting filesystem read-only
[247565.513031] EXT4-fs error (device sda2): ext4_journal_check_start:56:
[247565.513034] EXT4-fs error (device sda2): ext4_journal_check_start:56:
[247565.513038] EXT4-fs error (device sda2): ext4_journal_check_start:56:
Detected aborted journal
[247565.513039] Detected aborted journal
[247565.513051] EXT4-fs error (device sda2): ext4_journal_check_start:56:
Detected aborted journal
[247565.513056] Detected aborted journal
[247565.513080] EXT4-fs error (device sda2): ext4_journal_check_start:56:
Detected aborted journal

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
