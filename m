From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 197069] New: systemd service with ProtectHome=yes causes ELOOP
 when accessing /home
Date: Thu, 28 Sep 2017 20:17:05 +0000
Message-ID: <bug-197069-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:47106 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751641AbdI1URW (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 28 Sep 2017 16:17:22 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 58C0329737
        for <linux-ext4@vger.kernel.org>; Thu, 28 Sep 2017 20:17:22 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=197069

            Bug ID: 197069
           Summary: systemd service with ProtectHome=yes causes ELOOP when
                    accessing /home
           Product: File System
           Version: 2.5
    Kernel Version: kernel-lt 4.4 and 4.9 series
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: xxjack12xx@gmail.com
        Regression: No

Description of problem:
Having ProtectHome=yes in any service file causes a symlinked or autofs mounted
/home directory to return ELOOP
ls: cannot open directory /home: Too many levels of symbolic links

Version-Release number of selected component (if applicable):
Red Hat 7.0+

How reproducible:
1. Start a service with ProtectHome=yes
2. Start autofs with /home automounted
3. Access to /home returns ELOOP
ls: cannot open directory /home: Too many levels of symbolic links

Additional info:
This Fedora bug report describes the issue.
https://bugzilla.redhat.com/show_bug.cgi?id=1444223

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
