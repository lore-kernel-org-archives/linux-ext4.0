From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13369] New: kernel BUG at fs/ext4/inode.c:3123
Date: Sat, 23 May 2009 12:04:52 GMT
Message-ID: <bug-13369-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:40453 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbZEWMEw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 23 May 2009 08:04:52 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n4NC4qWw022391
	for <linux-ext4@vger.kernel.org>; Sat, 23 May 2009 12:04:52 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13369

           Summary: kernel BUG at fs/ext4/inode.c:3123
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.30-rc6
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: ckom26@gmail.com
        Regression: No


Being haunted by a consistent bug in 2.6.29.[234] that kept pdflush stuck at
100% cpu, I fetched and compiled 2.6.30-rc6. Now, I keep getting "kernel BUG at
fs/ext4/inode.c:3123!" (usually when I fire up ktorrent). In the attached
kernel logs you can see 2 different occurences of the bug.

A nearby single core cpu, low end box has not exhibited a single bug or
corruption for 3 months now, since I've converted to ext4, so I tried the
"nosmp" kernel boot parameter on the dual core laptop in question. Lo and
behold, the bug didn't rear its ugly head.

All partitions are mounted with "nodelalloc".

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
