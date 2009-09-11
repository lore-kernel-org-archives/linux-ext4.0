From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14156] New: Running fsstress "fsx" on ext4 filesystem gives
 dirty metadata buffer warning message
Date: Fri, 11 Sep 2009 04:59:43 GMT
Message-ID: <bug-14156-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:40236 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbZIKE7k (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Sep 2009 00:59:40 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n8B4xha0028093
	for <linux-ext4@vger.kernel.org>; Fri, 11 Sep 2009 04:59:43 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14156

           Summary: Running fsstress "fsx" on ext4 filesystem gives dirty
                    metadata buffer warning message
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.31-rc8
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: mbeeraka@in.ibm.com
                CC: amitarora@in.ibm.com
        Regression: No


Here is the warning message from 'dmesg':

Sep 7 12:49:57 mx3755a kernel: JBD: Spotted dirty metadata buffer (dev = sdb5,
blocknr = 41444). There's a risk of filesystem corruption in case of system
crash.
Sep  7 12:49:57 mx3755a kernel: JBD: Spotted dirty metadata buffer (dev = sdb5,
blocknr = 41445). There's a risk of filesystem corruption in case of system
crash.


More information can be found in IBM bugzilla# 55868

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
