From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 66821] New: "BUG: soft lockup" in proc_fd_link, causing freeze
Date: Tue, 10 Dec 2013 17:01:34 +0000
Message-ID: <bug-66821-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:52506 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754073Ab3LJRBl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Dec 2013 12:01:41 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id CCD4D204D1
	for <linux-ext4@vger.kernel.org>; Tue, 10 Dec 2013 17:01:39 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id D3D7920529
	for <linux-ext4@vger.kernel.org>; Tue, 10 Dec 2013 17:01:34 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=66821

            Bug ID: 66821
           Summary: "BUG: soft lockup" in proc_fd_link, causing freeze
           Product: File System
           Version: 2.5
    Kernel Version: 3.13.0-rc3
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: andreas.reis@gmail.com
        Regression: No

Created attachment 118011
  --> https://bugzilla.kernel.org/attachment.cgi?id=118011&action=edit
dmesg output during progressing freeze

Getting this since a few days randomly either as immediate freeze or
progressing system freeze. I'm not sure if that's the same bug though (nor if I
put this report in the right product/component category, just guessing by the
trace).

It starts with
general protection fault: 0000 [#1] PREEMPT SMP
path_get+0x15/0x30
proc_fd_link+0x9e/0xf0
proc_pid_readlink+0x3f/0xe0
SyS_readlinkat+0xeb/0x130
system_call_fastpath+0x1a/0x1f

and becomes
BUG: soft lockup - CPU#5 stuck for 23s! [chrome-sandbox:11068]
proc_fd_link+0x69/0xf0
proc_pid_readlink+0x3f/0xe0
SyS_readlinkat+0xeb/0x130
system_call_fastpath+0x1a/0x1f

Notes: 
* This is based only on one dmesg output; I haven't yet gotten around to
compare that of different freezes.
* Kernel is self-compiled via the current sources (17b2112f) in Torvald's git;
distro is Arch.
* Always appears to happen after the system has run for a while, ie. not right
after boot.
* root is btrfs, home is ext4, var is reiserfs.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
