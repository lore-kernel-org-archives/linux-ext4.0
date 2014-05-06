From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 75621] New: Permission denied trying to touch a file; happens
 randomly; both ext3 and GPFS
Date: Tue, 06 May 2014 18:45:11 +0000
Message-ID: <bug-75621-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:49881 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242AbaEFSpP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 May 2014 14:45:15 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 0535E20268
	for <linux-ext4@vger.kernel.org>; Tue,  6 May 2014 18:45:14 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 3B93E20260
	for <linux-ext4@vger.kernel.org>; Tue,  6 May 2014 18:45:12 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=75621

            Bug ID: 75621
           Summary: Permission denied trying to touch a file; happens
                    randomly; both ext3 and GPFS
           Product: File System
           Version: 2.5
    Kernel Version: 3.0.13-0.27
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext3
          Assignee: fs_ext3@kernel-bugs.osdl.org
          Reporter: phillip.l.viana@gmail.com
        Regression: No

Hi,

I am running a benchmark against DB2 in my cluster with several ext3 (SSD) and
GPFS file systems. After running the benchmark for around two days I noticed
that one of the nodes rebooted and that was due to an error touching a file.
The file was being touched by one of the HA monitors of Tivoli System
Automation.

I immediately tried to reproduce the error by touching the file again manually.
I touched the file a few times successfully, then out of the blue I got a
"Permission denied" error. Right after that I kept touching the file and got no
error message.

CPU utilization and I/O utilization were NOT at their peaks. 

This error keeps happening randomly and therefore it is difficult to reproduce.
It has happened both on a GPFS file system and an ext3 file system. Also I
don't have much information on the internals of this problem.

Do you have suggestions on how to instrument/debug/monitor the error so that I
can move on with the investigation and bring more info to this bug report?

Thanks

Phil

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
