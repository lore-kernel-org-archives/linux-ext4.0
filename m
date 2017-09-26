From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 197045] New: renameat2 rename_noreplace
Date: Tue, 26 Sep 2017 16:27:28 +0000
Message-ID: <bug-197045-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:51656 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S966562AbdIZQ1a (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 26 Sep 2017 12:27:30 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 89ACA20223
        for <linux-ext4@vger.kernel.org>; Tue, 26 Sep 2017 16:27:29 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=197045

            Bug ID: 197045
           Summary: renameat2 rename_noreplace
           Product: File System
           Version: 2.5
    Kernel Version: 4.4.0, 4.11.0
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: martin@salbaba.co.at
        Regression: No

on ext4 renameat2 fails in conjunction with RENAME_NOREPLACE, if the target
file is not present

renameat2(AT_FDCWD, "rename-test-a", AT_FDCWD, "rename-test-c",
RENAME_NOREPLACE) = -1 EINVAL (Invalid argument)

if the target file is present, functionality is ok

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
