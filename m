From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 32442] New: Higher Priority CPU-bound Processes Cause
 Filesystem Lockup
Date: Fri, 1 Apr 2011 16:06:08 GMT
Message-ID: <bug-32442-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:43771 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757798Ab1DAQGJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Apr 2011 12:06:09 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p31G68om004094
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 1 Apr 2011 16:06:08 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=32442

           Summary: Higher Priority CPU-bound Processes Cause Filesystem
                    Lockup
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.37.3
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext3
        AssignedTo: fs_ext3@kernel-bugs.osdl.org
        ReportedBy: dmoldenhauer@sxpanalytics.com
        Regression: No


Created an attachment (id=52972)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=52972)
test program (tar gz)

There seems to be a problem somewhere between scheduling and filesystems where
a CPU-bound compute process (no file I/O) with higher-than-normal priority
(such as SCHED_RR 1 (-2)) that is running on cpuX will cause a default priority
process that is running on cpuY to block indefinitely on file access (such as
write(fd,...)).  Not only does this process block on file access, but every
process in the system that tries to access any file on the same volume will
also be blocked indefinitely until the higher-than-normal-priority process is
either killed or is temporarily put to sleep. Access to files on other volumes
remains unaffected (works fine while the volume in question is "locked up").

It seems that if the higher-than-normal-priority process is changed to run at
default priority, the system does not lock up. The odd part about this all is
that this higher-than-normal-priority process doesn't do any file I/O at all,
yet changing its priority can cause a lockup of the entire filesystem. My guess
is that there is some filesystem-specific work that has to be done in the
background, and that it's attempting to do so at normal priority, and never
getting a chance to since the user process would preempt it.

We first noticed the behavior with production software, and I have been able to
create a test utility that reproduces the lockup. The source for the test
program is attached (we've ran it on recent Intel and AMD-based servers with 8
to 48 cores - with similar lockups on all).

The test utility fork()'s into two processes, one process runs at minimum
SCHED_FIFO priority and just does "math", while the other process runs at
default priority and attempts file write()'s. Each process is bound to a unique
CPU.

Problem was first noticed on 2.6.29.6, has happened on 2.6.33.7, and is very
reproducible on 2.6.37.3 (vanilla).

(the attached test is nice enough to sleep every 10 seconds (for 2 seconds) to
give you a chance to kill it)

I can provide additional information if needed.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
