From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42723] New: EXT4-fs error: ext4_mb_generate_buddy
Date: Fri, 3 Feb 2012 23:10:46 GMT
Message-ID: <bug-42723-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:34457 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828Ab2BCXKq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Feb 2012 18:10:46 -0500
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q13NAkiL018984
	for <linux-ext4@vger.kernel.org>; Fri, 3 Feb 2012 23:10:46 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42723

               URL: http://comments.gmane.org/gmane.comp.file-systems.ext4
                    /30090
           Summary: EXT4-fs error: ext4_mb_generate_buddy
           Product: File System
           Version: 2.5
    Kernel Version: 3.2, 3.2.2, 3.3-rc1
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: wimpy@yeti.dk
        Regression: Yes


Repeated or even reproducible occurrences of
EXT4-fs error: ext4_mb_generate_buddy

Last known good version: 3.1.5

More info on the above URL; possible trigger in the last message.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
