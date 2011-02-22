From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 29662] New: System freeze while rsyncing whole system from ext4
 to ext4 via USB 2.0
Date: Tue, 22 Feb 2011 13:46:26 GMT
Message-ID: <bug-29662-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:47427 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424Ab1BVNq1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Feb 2011 08:46:27 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p1MDkQam032281
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 22 Feb 2011 13:46:27 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=29662

           Summary: System freeze while rsyncing whole system from ext4 to
                    ext4 via USB 2.0
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.38-rc6
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: marc@osknowledge.org
        Regression: Yes


This morning I rsynced my system to an USB HDD via some scripts utilizing
rsync. The machine froze when a big file was transfered (updated on the backup
device). The host as well as the backup use ext4.

My machine froze with no logs at all. The system just stalled and anything
using the host disk was unusable. No new shell, no closing of running apps
(probably due to stalled config writes on exit).

acpid shutdown via power button worked but the init scripts suffered a lot of
problems. Finally (after some minutes) the disk could be unmounted by the init
script and the machine powered off.

I don't know what I could do to repeat that problem. I was unable to ssh in and
switch to vt1 as well.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
