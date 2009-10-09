From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] New: Bad corruption with 2.6.32-rc1 and upwards
Date: Fri, 9 Oct 2009 15:42:17 GMT
Message-ID: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:54872 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932110AbZJIPmx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Oct 2009 11:42:53 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n99FgHdA027340
	for <linux-ext4@vger.kernel.org>; Fri, 9 Oct 2009 15:42:17 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354

           Summary: Bad corruption with 2.6.32-rc1 and upwards
           Product: File System
           Version: 2.5
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: zecke@selfish.org
        Regression: No


I don't know how to reproduce but I'm seeing the following issues with
2.6.32-rcX since the "BUG_ON with page buffers has been fixed" on a daily
basis.

- Clean shutdown
- Reboot -> fs turns into ro mode
- Reboot -> fsck. I see blocks assigned to two inodes and many lost+found of
files touched close before the shutdown or during the shutdown. This requires
to go through the 1B, 1C, 1D pass on fsck.


I'm not sure how to reproduce and how to properly report it to be of use for
anyone. I'm seeing ext4 corruption on a daily basis though.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
