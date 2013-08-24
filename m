From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60788] New: xfstest generic/068 failure - kernel BUG at
 fs/buffer.c:3005!
Date: Sat, 24 Aug 2013 19:02:59 +0000
Message-ID: <bug-60788-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:54968 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755360Ab3HXTDD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 24 Aug 2013 15:03:03 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 5D77D20256
	for <linux-ext4@vger.kernel.org>; Sat, 24 Aug 2013 19:03:01 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id BD3CC2024F
	for <linux-ext4@vger.kernel.org>; Sat, 24 Aug 2013 19:02:59 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=60788

            Bug ID: 60788
           Summary: xfstest generic/068 failure - kernel BUG at
                    fs/buffer.c:3005!
           Product: File System
           Version: 2.5
    Kernel Version: 3.11-rc6
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: enwlinux@gmail.com
        Regression: No

Created attachment 107298
  --> https://bugzilla.kernel.org/attachment.cgi?id=107298&action=edit
kernel trace with timestamps and system name trimmed

Xfstest generic/068 fails roughly 5% of the time when run on a 3.11-rc6 x86-64
KVM guest against a test filesystem mounted with the data=journal option.  The
failure is actually a test hang rather than an error exit.  When the hang
occurs, a kernel failure in reported in the log: "kernel BUG at
fs/buffer.c:3005!" (full trace attached).  Recovering from the bug requires
rebooting and restarting the guest.  It also occurs on a Pandaboard ES running
3.11-rc6 at about the same frequency of occurrence.

Some evidence suggests that running additional tests prior to generic/068
increases the occurrence rate.  Running generic/062 prior to 068 increased the
failure rate to 15% in set of 20 tests on the same KVM guest, for example. 
Also, my sense is that 068 fails more frequently than 15% of the time when
running the entire xfstests-bld data_journal test series from the top in normal
regression, but I've not yet tried to quantify this.

The same bug has been seen on both x86_64 and ARM in previous releases and
release candidates at least as far back as 3.8.  Jan Kara may have made the
most recent comments related to this and another similar bug:
http://www.spinics.net/lists/linux-ext4/msg36858.html (also, see bug id 60786).


Test system hardware configuration:
KVM x86_64 virtual machine (2 cores, 1 GB memory) on physical four core x86_64
Virtual system and test disk raw images located on two physical 147 GB SAS
disks
Test file systems located in three 5.66 GB virtual disks


Test system software configuration:

Mainline kernel 3.11-rc6 on Ubuntu 12.10 x86-64 base
e2fsprogs, master branch 93061ea0f4d9f94579d09480f17dd47169c82081
xfsprogs, master branch 1a78b0840afcfbe01c12e6af04659388d62efeea
xfstests, master branch 6fe0ad6fafd76ef3d5b01639f22b747f4a317b63
xfstests-bld, master branch 723c23e1b2756b911dbb50bbd08c0afa5b836e3b

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
