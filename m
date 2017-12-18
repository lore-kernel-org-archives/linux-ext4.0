From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 198187] New: jbd2_log_wait_commit hangs
Date: Mon, 18 Dec 2017 12:56:48 +0000
Message-ID: <bug-198187-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:45514 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1759476AbdLRM4u (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 18 Dec 2017 07:56:50 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 32A1528EA4
        for <linux-ext4@vger.kernel.org>; Mon, 18 Dec 2017 12:56:50 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=198187

            Bug ID: 198187
           Summary: jbd2_log_wait_commit hangs
           Product: File System
           Version: 2.5
    Kernel Version: >=4.13
          Hardware: Intel
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: lav@yar.ru
        Regression: No

sometimes, a process stucks in jbd2_log_wait_commit wait state. After that, any
"sync" and probably fsync calls stuck too. The symptom is LA growing to insane
values. On one server the most common stuck process is logrotate in a lxc
container. I could not log in to two other affected servers. Another few
servers at my disposal do not exhibit this behaviour. There is no disk related
messages in the log or dmesg. Nothing suspicious at all in the log. Graceful
reboot hangs too.

The problem started with 4.13.8 and did not occur in 4.12.8.

Here is the dnf history info after which the problem started to occur:
    Erase    kernel-4.12.8-200.fc25.i686              @updates/25
    Install  kernel-4.13.8-100.fc25.i686              @updates/25

kernel downgrade fixes the problem.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
