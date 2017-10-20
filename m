From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 197335] New: Inode exhaustion should be logged to dmesg
Date: Fri, 20 Oct 2017 19:11:30 +0000
Message-ID: <bug-197335-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:57704 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751028AbdJTTLb (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 20 Oct 2017 15:11:31 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 741CE28F40
        for <linux-ext4@vger.kernel.org>; Fri, 20 Oct 2017 19:11:31 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=197335

            Bug ID: 197335
           Summary: Inode exhaustion should be logged to dmesg
           Product: File System
           Version: 2.5
    Kernel Version: 4.14.0-rc1
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: enhancement
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: teamathena.nitc@gmail.com
        Regression: No

Problem: If the system runs out of inodes, the error messages show "No space on
disk". This is misleading to the user as the disk may still have space. Logging
to dmesg can help the user correctly identify the problem.

Bug #1665833 from https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1665833


My server just became unusable, because it ran out of inodes (something that
shouldn't happen on a relatively normal installation). The root-cause was a
misbehaving CRM program creating way too many session files and never deleting
them. However, while debugging, it would have been really really helpful if
there were something in the logfiles. But it just failed silently: the lack of
any error message makes diagnosing this error condition 100x harder than it
should be. We get messages about being out of disk-space, but that's not
helpful, especially when "df -h" shows it not to be true.

So, the bug report/feature request is this: when the kernel cannot create a new
file due to a shortage of inodes, it should emit a message to that effect, at
least in dmesg (and ideally also to syslog).

[For anyone else who chances upon this bug report, you can tell if you have run
out of inodes with "df -i", and you can find the offending directories with:
"find / -xdev -size +100k -type d" ]

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
