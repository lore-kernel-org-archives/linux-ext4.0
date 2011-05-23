From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 35562] New: ext4 regression in 2.6.39
Date: Mon, 23 May 2011 14:05:08 GMT
Message-ID: <bug-35562-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:35237 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433Ab1EWOFJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 May 2011 10:05:09 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p4NE58jb029011
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 23 May 2011 14:05:08 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=35562

           Summary: ext4 regression in 2.6.39
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.39
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: arthur@psw.ro
                CC: hussam@visp.net.lb
        Regression: Yes



Hussam Al-Tayeb <hussam@visp.net.lb> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |hussam@visp.net.lb


Created an attachment (id=58932)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=58932)
kernel.log

System is Archlinux x64 which just received kernel 2.6.39 in testing repos.

The attached call traces are recorded in kernel.log while I was downloading
with ktorrent (max speed 2.5 MB/s).

I have little to no experience in producing a good bugzilla report but if more
info is needed just ask and I'll do my best.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
