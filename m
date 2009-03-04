From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12815] New: JBD: barrier-based sync failed on dm-1:8 - disabling barriers  -- and then hang
Date: Tue,  3 Mar 2009 21:08:47 -0800 (PST)
Message-ID: <bug-12815-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35849 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750717AbZCDFJV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Mar 2009 00:09:21 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n2458mX4032648
	for <linux-ext4@vger.kernel.org>; Tue, 3 Mar 2009 21:08:49 -0800
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12815

           Summary: JBD: barrier-based sync failed on dm-1:8 - disabling
                    barriers  -- and then hang
           Product: File System
           Version: 2.5
     KernelVersion: 2.6.28
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: joey@kitenet.net


Latest working kernel version: none
Earliest failing kernel version: 2.6.28.1
Distribution: Debian unstable
Hardware Environment: Thecus N2100 (arm), two 1 TB SATA drives
Software Environment: /home is an ext4 filesystem on an LVM of the two drives
Problem Description:

This has happened at least three times since I converted the filesystem from
ext3 to ext4 two days ago. All processes accessing the filesystem go into
uninterruptable sleep. The system does not crash. On one occasion, the problem
cleared itself up after a few minutes and processes resumed running. On the
other two, I hard-reset the machine after 8 hours, and half an hour,
respectively.

The only thing in the log is this:

JBD: barrier-based sync failed on dm-1:8 - disabling barriers

It was never logged in the month before switching to ext4, and has been logged
seven times in the past two days. I have not matched up all seven  times
exactly with the hangs, but some of them match up very well.

Steps to reproduce:

Unsure, but heavy disk load does not seem to help; at one point rtorrent was
hashing a large file when the hang occurred.

This may be a duplicate of bug 12679 -- at least, the symtoms as described are
the same, and the backtrace obtained there shows a hang in
jbd2_journal_commit_transaction, which calls the function from which my message
originates.


I am running a Debian kernel, not mainline. Apologies, but I don't have a head
on this machine.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
