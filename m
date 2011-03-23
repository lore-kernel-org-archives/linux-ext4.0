From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 31742] New: got a "kernel BUG at fs/dcache.c:440!"
Date: Wed, 23 Mar 2011 15:14:31 GMT
Message-ID: <bug-31742-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:57721 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932997Ab1CWPOc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Mar 2011 11:14:32 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p2NFEVJt011184
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 23 Mar 2011 15:14:31 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=31742

           Summary: got a "kernel BUG at fs/dcache.c:440!"
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
        ReportedBy: ruediger@blueboot.org
        Regression: No


While traversing /usr with a python script, i got a message saying "kernel
BUG". Its the first time i got something like this in the last 12 years using
linux, so i guessed, i should report it. The message is attached as a jpeg.

so long
Mathias

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
