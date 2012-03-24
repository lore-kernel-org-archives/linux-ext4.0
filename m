From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42986] New: ext2_fs.h requires undefined type umode_t
Date: Sat, 24 Mar 2012 13:23:00 GMT
Message-ID: <bug-42986-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:33361 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755710Ab2CXNXA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 24 Mar 2012 09:23:00 -0400
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q2ODN0tJ022888
	for <linux-ext4@vger.kernel.org>; Sat, 24 Mar 2012 13:23:00 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42986

           Summary: ext2_fs.h requires undefined type umode_t
           Product: File System
           Version: 2.5
    Kernel Version: 3.3
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext2
        AssignedTo: fs_ext2@kernel-bugs.osdl.org
        ReportedBy: allan@archlinux.org
        Regression: Yes


In the user-space headers:

/usr/include/linux/ext2_fs.h:178:41: error: unknown type name 'umode_t'

umode_t is not provided in userspace since commit 0583fcc9

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
