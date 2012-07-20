From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 44951] New: renaming socket in use does not update /proc/X/fd
Date: Fri, 20 Jul 2012 13:23:19 +0000 (UTC)
Message-ID: <bug-44951-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:32908 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753743Ab2GTNXW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Jul 2012 09:23:22 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 70CE220230
	for <linux-ext4@vger.kernel.org>; Fri, 20 Jul 2012 13:23:21 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 98C9720246
	for <linux-ext4@vger.kernel.org>; Fri, 20 Jul 2012 13:23:19 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=44951

           Summary: renaming socket in use does not update /proc/X/fd
           Product: File System
           Version: 2.5
    Kernel Version: 3.2.0-26 ubuntu
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: low
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: wolfgang@rohdewald.de
                CC: wolfgang@rohdewald.de
        Regression: No


normally, renaming a file in use updates its name in /proc/X/fd

but this does not work for sockets. And so fuser fails to tell me
about the process using the socket when renamed.

using ext4 of course

i5:~/.kajonggserver$ fuser socket
/home/wr/.kajonggserver/socket: 27557
i5:~/.kajonggserver$ l /proc/27557/fd/3
lrwx------ 1 wr wr 64 Jul 18 22:00 /proc/27557/fd/3 -> socket:[1344224]
i5:~/.kajonggserver$ mv socket X
i5:~/.kajonggserver$ fuser X
i5:[Exit 1 (SIGHUP)]~/.kajonggserver$ l /proc/27557/fd/3
lrwx------ 1 wr wr 64 Jul 18 22:00 /proc/27557/fd/3 -> socket:[1344224]


Linux i5 3.2.0-26-generic #41-Ubuntu SMP Thu Jun 14 17:49:24 UTC 2012 x86_64
x86_64 x86_64 GNU/Linux

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
