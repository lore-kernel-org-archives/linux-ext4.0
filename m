From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 48301] New: Kernel panic when try delete really big file
 (3,3TB)
Date: Thu,  4 Oct 2012 05:43:46 +0000 (UTC)
Message-ID: <bug-48301-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:35525 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754042Ab2JDFnu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Oct 2012 01:43:50 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 43792202CA
	for <linux-ext4@vger.kernel.org>; Thu,  4 Oct 2012 05:43:49 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 7EA00202C6
	for <linux-ext4@vger.kernel.org>; Thu,  4 Oct 2012 05:43:47 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=48301

           Summary: Kernel panic when try delete really big file (3,3TB)
           Product: File System
           Version: 2.5
    Kernel Version: 3.4.9
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: zdenek@zdvorak.eu
        Regression: No


I try test filesystem ext4 mounted as / on RAID5 (4*2TB).
Create about 3,3TB file by "ddrescue /dev/zero /mnt/zero-file
after that try delete this file "rm /mnt/zero-file"....

system print bugtrace and after that not respond, unable to reboot. 
After manual restart, unable to boot (kernel panic when try mount / ).

Solved by boot actual systemrescueCD and after 1 minutes filesystem
successfully mounted, after next manual restart, standard os boot ok.

Sorry for english.

Thanks
Zdvori

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
