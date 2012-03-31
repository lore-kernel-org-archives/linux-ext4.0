From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43017] New: Freezing on poweroff (kworker, swapper)
Date: Sat, 31 Mar 2012 00:53:20 GMT
Message-ID: <bug-43017-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:59768 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758527Ab2CaAxV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Mar 2012 20:53:21 -0400
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q2V0rK7E009823
	for <linux-ext4@vger.kernel.org>; Sat, 31 Mar 2012 00:53:20 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=43017

               URL: http://bugzilla.redhat.com/show_bug.cgi?id=782266
           Summary: Freezing on poweroff (kworker, swapper)
           Product: File System
           Version: 2.5
    Kernel Version: 3.3
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: fry.kun@gmail.com
        Regression: Yes


Using Fedora 16's kernel 3.3.0-4.fc16 I'm intermittently seeing freezing during
poweroff/reboot process. SysRq key works and killing all existing processes
continues the poweroff process (see traces in related Fedora bug). The bug had
been appearing for me in Fedora's builds of 3.1 and now again in 3.3. Currently
running on 3.2.10-3.fc16; none of the 3.2 builds seem to have this problem.

Apologies if this is the wrong place for this bug, but nobody is responding
from Fedora/Redhat...

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
