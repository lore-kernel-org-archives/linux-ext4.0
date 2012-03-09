From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42895] New: jbd2 makes all system unresponsive
Date: Fri, 9 Mar 2012 10:42:57 GMT
Message-ID: <bug-42895-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:40081 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590Ab2CIKm5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Mar 2012 05:42:57 -0500
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q29AgvZx014804
	for <linux-ext4@vger.kernel.org>; Fri, 9 Mar 2012 10:42:57 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42895

           Summary: jbd2 makes all system unresponsive
           Product: File System
           Version: 2.5
    Kernel Version: 3.2.9
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext3
        AssignedTo: fs_ext3@kernel-bugs.osdl.org
        ReportedBy: fabio.varesano@gmail.com
        Regression: No


I'm experiencing system performance problems when using ext3. It seems that on
any read from the disk, jbd2 process are making lot of additional IO and
consuming CPU resulting in system unresponsiveness and slow down.

Some more info:

mount http://sprunge.us/PMAV

uname -a
  Linux gamma 3.2.9-1-ARCH #1 SMP PREEMPT Thu Mar 1 09:31:13 CET 2012 x86_64
Intel(R) Core(TM) i5-2410M CPU @ 2.30GHz GenuineIntel GNU/Linux

Let me know additional details you need.

Thanks,

Fabio Varesano

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
