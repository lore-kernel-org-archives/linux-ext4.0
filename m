From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43023] New: Bad page map in process plugin-containe
Date: Sun, 1 Apr 2012 19:06:55 GMT
Message-ID: <bug-43023-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:35713 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776Ab2DATG4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Apr 2012 15:06:56 -0400
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q31J6txN022273
	for <linux-ext4@vger.kernel.org>; Sun, 1 Apr 2012 19:06:55 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=43023

           Summary: Bad page map in process plugin-containe
           Product: File System
           Version: 2.5
    Kernel Version: 3.3.0
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: harri@afaics.de
        Regression: No


Created an attachment (id=72784)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=72784)
log file

I got an error in /var/log/kern.log about a "Bad page map in process
plugin-containe". See attached log file.

I am using autofs to mount /dev/sdg1 to /misc/data1 when needed. When I tried
to rsync /misc/data1/somefile to another host I have got this error message.
The copy went fine, though. A fsck didn't show any problems, either.

Mount options (as shown in /proc/mounts):

/dev/sdg1 /misc/data1 ext4 rw,noatime,user_xattr,barrier=1,data=ordered 0 0

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
