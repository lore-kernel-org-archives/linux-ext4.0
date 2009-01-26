From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12543] New: ext4_da_writepages error in 2.6.28.1 after a disk error
Date: Mon, 26 Jan 2009 08:56:40 -0800 (PST)
Message-ID: <bug-12543-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54373 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751457AbZAZQ5b (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Jan 2009 11:57:31 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0QGueOY024216
	for <linux-ext4@vger.kernel.org>; Mon, 26 Jan 2009 08:56:41 -0800
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12543

           Summary: ext4_da_writepages error in 2.6.28.1 after a disk error
           Product: File System
           Version: 2.5
     KernelVersion: 2.6.28.1
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: abaptist@cleversafe.com


Distribution: 
custom stripped down kernel parameters

Hardware Environment: 
4 disk SATA system -

Software Environment:
Problem Description:
While running tests over the weekend one of the drives reported errors "Buffer
I/O error on device". After this error, a series of "emerg" level stack traces
were printed with the following stack:
Jan 26 15:06:13 qwchi-mbxss-pd52.cleversafelabs.com kernel: Pid: 13486, comm:
pdflush Not tainted 2.6.28.1.cs.1 #1

Jan 26 15:06:13 qwchi-mbxss-pd52.cleversafelabs.com kernel: Call Trace:

Jan 26 15:06:13 qwchi-mbxss-pd52.cleversafelabs.com kernel:  [<c10e9168>]
ext4_da_writepages+0x2d8/0x310

Jan 26 15:06:13 qwchi-mbxss-pd52.cleversafelabs.com kernel:  [<c12d5b0b>]
schedule+0x22b/0x880

Jan 26 15:06:13 qwchi-mbxss-pd52.cleversafelabs.com kernel:  [<c10626ab>]
do_writepages+0x2b/0x50

Jan 26 15:06:13 qwchi-mbxss-pd52.cleversafelabs.com kernel:  [<c109ccb9>]
__writeback_single_inode+0x89/0x300

Jan 26 15:06:13 qwchi-mbxss-pd52.cleversafelabs.com kernel:  [<c109d2ee>]
generic_sync_sb_inodes+0x1ce/0x2b0

Jan 26 15:06:13 qwchi-mbxss-pd52.cleversafelabs.com kernel:  [<c109d738>]
writeback_inodes+0x88/0xb0

Jan 26 15:06:13 qwchi-mbxss-pd52.cleversafelabs.com kernel:  [<c10630f4>]
wb_kupdate+0x84/0xf0

Jan 26 15:06:13 qwchi-mbxss-pd52.cleversafelabs.com kernel:  [<c1063520>]
pdflush+0x0/0x1a0

Jan 26 15:06:13 qwchi-mbxss-pd52.cleversafelabs.com kernel:  [<c106360b>]
pdflush+0xeb/0x1a0

Jan 26 15:06:13 qwchi-mbxss-pd52.cleversafelabs.com kernel:  [<c1063070>]
wb_kupdate+0x0/0xf0

Jan 26 15:06:13 qwchi-mbxss-pd52.cleversafelabs.com kernel:  [<c1039b42>]
kthread+0x42/0x70

Jan 26 15:06:13 qwchi-mbxss-pd52.cleversafelabs.com kernel:  [<c1039b00>]
kthread+0x0/0x70

Jan 26 15:06:13 qwchi-mbxss-pd52.cleversafelabs.com kernel:  [<c1004aab>]
kernel_thread_helper+0x7/0x1c

Steps to reproduce:
The syslog before these errors started was the following:
Jan 26 08:12:21 qwchi-mbxss-pd52.cleversafelabs.com kernel: Buffer I/O error on
device sdd1, logical block 121667584

Jan 26 08:12:21 qwchi-mbxss-pd52.cleversafelabs.com kernel: lost page write due
to I/O error on sdd1

Jan 26 08:12:21 qwchi-mbxss-pd52.cleversafelabs.com kernel: ext4_abort called.

Jan 26 08:12:21 qwchi-mbxss-pd52.cleversafelabs.com kernel: EXT4-fs error
(device sdd1): ext4_journal_start_sb: Detected aborted journal

Jan 26 08:12:21 qwchi-mbxss-pd52.cleversafelabs.com kernel: Remounting
filesystem read-only

Jan 26 08:12:21 qwchi-mbxss-pd52.cleversafelabs.com kernel: EXT4-fs error
(device sdd1) in ext4_delete_inode: Journal has aborted

Jan 26 08:12:21 qwchi-mbxss-pd52.cleversafelabs.com kernel: EXT4-fs error
(device sdd1) in ext4_create: IO failure

Jan 26 08:12:21 qwchi-mbxss-pd52.cleversafelabs.com kernel: JBD2: I/O error
detected when updating journal superblock for sdd1:8.

Jan 26 08:12:21 qwchi-mbxss-pd52.cleversafelabs.com kernel: lost page write due
to I/O error on sdd1

Jan 26 08:12:21 qwchi-mbxss-pd52.cleversafelabs.com kernel: sd 3:0:0:0: [sdd]
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK

Jan 26 08:12:21 qwchi-mbxss-pd52.cleversafelabs.com kernel: end_request: I/O
error, dev sdd, sector 26623


One note is that the filesystem was NOT remounted read-only even though it
claimed to be (at least by looking at mount).


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
