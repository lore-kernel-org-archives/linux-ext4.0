From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60786] New: xfstest generic/068 failure - kernel BUG at
 fs/jbd2/transaction.c:2143!
Date: Fri, 23 Aug 2013 23:51:09 +0000
Message-ID: <bug-60786-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:39340 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755274Ab3HWXvM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 23 Aug 2013 19:51:12 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 5BBE6202B3
	for <linux-ext4@vger.kernel.org>; Fri, 23 Aug 2013 23:51:11 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 924C920299
	for <linux-ext4@vger.kernel.org>; Fri, 23 Aug 2013 23:51:09 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=60786

            Bug ID: 60786
           Summary: xfstest generic/068 failure - kernel BUG at
                    fs/jbd2/transaction.c:2143!
           Product: File System
           Version: 2.5
    Kernel Version: 3.11-rc6
          Hardware: ARM
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: enwlinux@gmail.com
        Regression: No

Created attachment 107296
  --> https://bugzilla.kernel.org/attachment.cgi?id=107296&action=edit
kernel trace from Pandaboard running 3.11-rc6

Xfstest generic/068 fails roughly 40% of the time when run on a Pandaboard ES
(ARM) against a test filesystem mounted with the data=journal option.  In this
case, an assertion fails in the kernel: "kernel BUG at
fs/jbd2/transaction.c:2143!" (full trace attached).  This is a long-standing
bug which may have become more visible in recent releases;  it's now become a
notable annoyance during routine regression testing.  Recovering from the bug
requires rebooting and power-cycling the Pandaboard.

The same bug has been seen on x86-64 in previous releases / release candidates,
but appears to occur at much lower frequency.  It did not occur once in 20
trials on an x86-64 KVM guest configured similarly to the Pandaboard test
system running 3.11-rc6 (although another BUG, reported separately, did).

It looks like Jan Kara may have made the most recent comments related to this
and another similar bug: http://www.spinics.net/lists/linux-ext4/msg36858.html.
(Note that the statement currently at line 2143 in transaction.c was at line
1986 in 3.8.)

Test system hardware configuration:

Pandaboard ES (2 core TI OMAP4 ARM CPU, 1 GB memory)
1 TB Western Digital SATA III disk in USB2-attached external enclosure
Test file systems located in three 5.37 GB partitions on USB-attached disk


Test system software configuration:

Mainline kernel 3.11-rc6 on Ubuntu 12.10 base
e2fsprogs, master branch 93061ea0f4d9f94579d09480f17dd47169c82081
xfsprogs, master branch 20526770e76013587c6148fef9e30ac85332fa65
xfstests, master branch 54d6adf7c98500a177f0507c5905ed6dfb2fa888
xfstests-bld, master branch 723c23e1b2756b911dbb50bbd08c0afa5b836e3b

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
