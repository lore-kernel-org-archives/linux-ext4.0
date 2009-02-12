From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12697] New: MAINLINE
Date: Thu, 12 Feb 2009 11:12:27 -0800 (PST)
Message-ID: <bug-12697-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51915 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754748AbZBLTMa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Feb 2009 14:12:30 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n1CJCSu4022365
	for <linux-ext4@vger.kernel.org>; Thu, 12 Feb 2009 11:12:29 -0800
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12697

           Summary: MAINLINE
           Product: File System
           Version: 2.5
     KernelVersion: 2.6.28-4
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: alexandre@ondainternet.com.br
                CC: alexandre@ondainternet.com.br


Running kernel 2.6.28-4 on a hp proliant with dual-core xeon running centos 5.2
64bits with custom kernel, getting this:


Call Trace:
 [<ffffffff802f8d6f>] ext4_da_writepages+0xcc/0x333
 [<ffffffff8026eb67>] do_writepages+0x20/0x2d
 [<ffffffff802aaf73>] __writeback_single_inode+0x147/0x285
 [<ffffffff80231948>] dequeue_task_fair+0x96/0x10d
 [<ffffffff8022a150>] __dequeue_entity+0x1c/0x32
 [<ffffffff802ab3f2>] generic_sync_sb_inodes+0x1bf/0x302
 [<ffffffff802ab82d>] writeback_inodes+0x56/0x9d
 [<ffffffff8026f469>] wb_kupdate+0x9e/0x10d
 [<ffffffff8026f812>] pdflush+0x0/0x1f8
 [<ffffffff8026f95e>] pdflush+0x14c/0x1f8
 [<ffffffff8026f3cb>] wb_kupdate+0x0/0x10d
 [<ffffffff80247232>] kthread+0x47/0x75
 [<ffffffff802309b4>] schedule_tail+0x28/0x60
 [<ffffffff8020cbe9>] child_rip+0xa/0x11
 [<ffffffff802471eb>] kthread+0x0/0x75
 [<ffffffff8020cbdf>] child_rip+0x0/0x11
ext4_da_writepages: jbd2_start: 1024 pages, ino 21705; err -30
Pid: 272, comm: pdflush Not tainted 2.6.28.4-onda #1
Call Trace:
 [<ffffffff802f8d6f>] ext4_da_writepages+0xcc/0x333
 [<ffffffff8026eb67>] do_writepages+0x20/0x2d
 [<ffffffff802aaf73>] __writeback_single_inode+0x147/0x285
 [<ffffffff80231948>] dequeue_task_fair+0x96/0x10d
 [<ffffffff8022a150>] __dequeue_entity+0x1c/0x32
 [<ffffffff802ab3f2>] generic_sync_sb_inodes+0x1bf/0x302
 [<ffffffff802ab82d>] writeback_inodes+0x56/0x9d
 [<ffffffff8026f469>] wb_kupdate+0x9e/0x10d
 [<ffffffff8026f812>] pdflush+0x0/0x1f8
 [<ffffffff8026f95e>] pdflush+0x14c/0x1f8
 [<ffffffff8026f3cb>] wb_kupdate+0x0/0x10d
 [<ffffffff80247232>] kthread+0x47/0x75
 [<ffffffff802309b4>] schedule_tail+0x28/0x60
 [<ffffffff8020cbe9>] child_rip+0xa/0x11
 [<ffffffff802471eb>] kthread+0x0/0x75
 [<ffffffff8020cbdf>] child_rip+0x0/0x11
ext4_da_writepages: jbd2_start: 1024 pages, ino 21705; err -30
Pid: 272, comm: pdflush Not tainted 2.6.28.4-onda #1
Call Trace:
 [<ffffffff802f8d6f>] ext4_da_writepages+0xcc/0x333
 [<ffffffff8026eb67>] do_writepages+0x20/0x2d
 [<ffffffff802aaf73>] __writeback_single_inode+0x147/0x285
 [<ffffffff80231948>] dequeue_task_fair+0x96/0x10d
 [<ffffffff802ab3f2>] generic_sync_sb_inodes+0x1bf/0x302
 [<ffffffff802ab82d>] writeback_inodes+0x56/0x9d
 [<ffffffff8026f469>] wb_kupdate+0x9e/0x10d
 [<ffffffff8026f812>] pdflush+0x0/0x1f8
 [<ffffffff8026f95e>] pdflush+0x14c/0x1f8
 [<ffffffff8026f3cb>] wb_kupdate+0x0/0x10d
 [<ffffffff80247232>] kthread+0x47/0x75
 [<ffffffff802309b4>] schedule_tail+0x28/0x60
 [<ffffffff8020cbe9>] child_rip+0xa/0x11
 [<ffffffff802471eb>] kthread+0x0/0x75
 [<ffffffff8020cbdf>] child_rip+0x0/0x11
ext4_da_writepages: jbd2_start: 1024 pages, ino 21705; err -30
Pid: 272, comm: pdflush Not tainted 2.6.28.4-onda #1
Call Trace:
 [<ffffffff802f8d6f>] ext4_da_writepages+0xcc/0x333
 [<ffffffff8026eb67>] do_writepages+0x20/0x2d
 [<ffffffff802aaf73>] __writeback_single_inode+0x147/0x285
 [<ffffffff80231948>] dequeue_task_fair+0x96/0x10d
 [<ffffffff802ab3f2>] generic_sync_sb_inodes+0x1bf/0x302
 [<ffffffff802ab82d>] writeback_inodes+0x56/0x9d
 [<ffffffff8026f469>] wb_kupdate+0x9e/0x10d
 [<ffffffff8026f812>] pdflush+0x0/0x1f8
 [<ffffffff8026f95e>] pdflush+0x14c/0x1f8
 [<ffffffff8026f3cb>] wb_kupdate+0x0/0x10d
 [<ffffffff80247232>] kthread+0x47/0x75
 [<ffffffff802309b4>] schedule_tail+0x28/0x60
 [<ffffffff8020cbe9>] child_rip+0xa/0x11
 [<ffffffff802471eb>] kthread+0x0/0x75
 [<ffffffff8020cbdf>] child_rip+0x0/0x11
ext4_da_writepages: jbd2_start: 1024 pages, ino 21705; err -30
Pid: 272, comm: pdflush Not tainted 2.6.28.4-onda #1
Call Trace:
 [<ffffffff802f8d6f>] ext4_da_writepages+0xcc/0x333
 [<ffffffff8026eb67>] do_writepages+0x20/0x2d
 [<ffffffff802aaf73>] __writeback_single_inode+0x147/0x285
 [<ffffffff80231948>] dequeue_task_fair+0x96/0x10d
 [<ffffffff802ab3f2>] generic_sync_sb_inodes+0x1bf/0x302
 [<ffffffff802ab82d>] writeback_inodes+0x56/0x9d
 [<ffffffff8026f469>] wb_kupdate+0x9e/0x10d
 [<ffffffff8026f812>] pdflush+0x0/0x1f8
 [<ffffffff8026f95e>] pdflush+0x14c/0x1f8
 [<ffffffff8026f3cb>] wb_kupdate+0x0/0x10d
 [<ffffffff80247232>] kthread+0x47/0x75
 [<ffffffff802309b4>] schedule_tail+0x28/0x60
 [<ffffffff8020cbe9>] child_rip+0xa/0x11
 [<ffffffff802471eb>] kthread+0x0/0x75
 [<ffffffff8020cbdf>] child_rip+0x0/0x11
ext4_da_writepages: jbd2_start: 1024 pages, ino 21705; err -30
Pid: 272, comm: pdflush Not tainted 2.6.28.4-onda #1
Call Trace:
 [<ffffffff802f8d6f>] ext4_da_writepages+0xcc/0x333
 [<ffffffff8026eb67>] do_writepages+0x20/0x2d
 [<ffffffff802aaf73>] __writeback_single_inode+0x147/0x285
 [<ffffffff80231948>] dequeue_task_fair+0x96/0x10d
 [<ffffffff802ab3f2>] generic_sync_sb_inodes+0x1bf/0x302
 [<ffffffff802ab82d>] writeback_inodes+0x56/0x9d
 [<ffffffff8026f469>] wb_kupdate+0x9e/0x10d
 [<ffffffff8026f812>] pdflush+0x0/0x1f8
 [<ffffffff8026f95e>] pdflush+0x14c/0x1f8
 [<ffffffff8026f3cb>] wb_kupdate+0x0/0x10d
 [<ffffffff80247232>] kthread+0x47/0x75
 [<ffffffff802309b4>] schedule_tail+0x28/0x60
 [<ffffffff8020cbe9>] child_rip+0xa/0x11
 [<ffffffff802471eb>] kthread+0x0/0x75
 [<ffffffff8020cbdf>] child_rip+0x0/0x11


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
