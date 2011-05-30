From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 36262] New: ext3 umount: BUG: unable to handle kernel paging
 request
Date: Mon, 30 May 2011 15:16:34 GMT
Message-ID: <bug-36262-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:52200 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757210Ab1E3PQe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 May 2011 11:16:34 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p4UFGYJH030721
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 30 May 2011 15:16:34 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=36262

           Summary: ext3 umount: BUG: unable to handle kernel paging
                    request
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.39
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext3
        AssignedTo: fs_ext3@kernel-bugs.osdl.org
        ReportedBy: rl@hellgate.ch
        Regression: No


Created an attachment (id=60122)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=60122)
BUG screenshot

Umounting a USB disk using ext3 resulted in this kernel bug (screenshot
attached).

Only happened once.

The machine has 8 GB RAM. To the best of my knowledge, it was rather lightly
loaded; most of the memory use at the time was probably disk cache.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
