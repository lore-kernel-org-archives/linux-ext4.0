From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42763] New: directory access hangs without error
Date: Mon, 13 Feb 2012 03:41:28 GMT
Message-ID: <bug-42763-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:53595 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540Ab2BMDl3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 12 Feb 2012 22:41:29 -0500
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q1D3fS66008142
	for <linux-ext4@vger.kernel.org>; Mon, 13 Feb 2012 03:41:28 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42763

           Summary: directory access hangs without error
           Product: File System
           Version: 2.5
    Kernel Version: 3.2.5
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: ebuddington@wesleyan.edu
        Regression: No


Kernel 3.2.5
ext4 over RAID-6

I have a specific directory that freezes all processes that try to getdents()
or open() a new file. In some cases, the kernel gives  me "blocked for more
than 120 seconds" messages, often reporting that the process is stuck in
ext4_getblk.

I have found no errors, however. The stuck processes stay stuck forever (at
least hours), and dmesg shows no complaints about RAID, filesystem, or anything
else. Full reads of the RAID devices work without hanging, and drive self-tests
pass.

Other processes are able to access other parts of the filesystem normally; this
is not a system-wide or fs-wide hang.

Rebooting and fscking made the directory accessible again, but now there is a
different directory exhibiting the problem (unknown whether it had the problem
before the fsck/reboot)

This particular problem exhibited itself for the first time after tests of my
multi-threaded 'du' that beat the filesystem with a few dozen threads
simultaneously.

Given that this seems to very reproducible, I have many opportunities to poke
at a hung process, query the filesystem, or recompile the kernel in any way
that would be helpful; I just don't know to approach it from here.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
