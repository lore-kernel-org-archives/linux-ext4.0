From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60676] New: Stat system call gives permission denied to root
 for links under a sticky bit
Date: Thu, 01 Aug 2013 15:02:36 +0000
Message-ID: <bug-60676-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:46422 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755737Ab3HAPCo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 Aug 2013 11:02:44 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D6AC62035A
	for <linux-ext4@vger.kernel.org>; Thu,  1 Aug 2013 15:02:42 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 032752035D
	for <linux-ext4@vger.kernel.org>; Thu,  1 Aug 2013 15:02:37 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=60676

            Bug ID: 60676
           Summary: Stat system call gives permission denied to root for
                    links under a sticky bit
           Product: File System
           Version: 2.5
    Kernel Version: 3.5.0
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: jck@videk.com
        Regression: No

If a directory has a sticky bit set, root cannot use anything that makes the
stat system call on any of the links there.

Example:
> $ ls -ld /tmp/
> drwxrwxrwt 17 root root 4825088 Aug  1 10:50 /tmp/
> $ mkdir /tmp/testdir
> $ touch /tmp/testdir/testfile
> $ ln -s /tmp/testdir/ /tmp/testlink
> $ ls /tmp/testlink/
> testfile
> $ su
> # ls /tmp/testlink
ls: cannot access /tmp/testlink: Permission denied
> # ls /tmp/testdir
> testfile

I can see how having root blindly follow links in a sticky directory could be a
bad idea, but this goes against the behavior described by the man pages.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
