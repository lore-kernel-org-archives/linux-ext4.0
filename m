From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 24282] New: linux/ext2_fs.h uses defines from linux/fs.h
Date: Fri, 3 Dec 2010 12:55:37 GMT
Message-ID: <bug-24282-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:33578 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab0LCMzi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Dec 2010 07:55:38 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id oB3Ctbfe001671
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 3 Dec 2010 12:55:37 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=24282

           Summary: linux/ext2_fs.h uses defines from linux/fs.h
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.33.4
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext2
        AssignedTo: fs_ext2@kernel-bugs.osdl.org
        ReportedBy: sliwa@blue.cft.edu.pl
        Regression: No


An inline function from linux/ext2_fs.h does not compile without including
linux/fs.h.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
