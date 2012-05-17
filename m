From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43260] New: ftruncate locks up when used with direct IO on ext4
Date: Thu, 17 May 2012 23:31:10 +0000 (UTC)
Message-ID: <bug-43260-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:38119 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761133Ab2EQXbO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 May 2012 19:31:14 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E3920205E1
	for <linux-ext4@vger.kernel.org>; Thu, 17 May 2012 23:31:12 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id EC938205CF
	for <linux-ext4@vger.kernel.org>; Thu, 17 May 2012 23:31:10 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=43260

           Summary: ftruncate locks up when used with direct IO on ext4
           Product: File System
           Version: 2.5
    Kernel Version: all above 3.1-rc3
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: ivan@rethinkdb.com
                CC: tytso@mit.edu
        Regression: No


Created an attachment (id=73323)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=73323)
Test program to reproduce the lock up

Calling ftruncate shortly after submitting a lot of direct IO requests on a
file located on ext4 filesystem causes the ftruncate syscall to lock up. Using
other filesystems, e.g. xfs, does not exhibit this behavior.

This problem can be reproduced on all kernel versions above 3.1-rc3 (3.1-rc3
itself is fine), e.g. on v3.2.14 -- the kernel that is used in the latest
Ubuntu LTS release.

The attached program can be used to reproduce the problem. It is possible to
reproduce the problem by running the program on a temporary ext4 filesystem
inside UML, it is also advisable to do so since other syscalls accessing the
file system may lock up as well after starting the program.

I was able to bisect the problem to this commit:
8c0bec2151a47906bf779c6715a10ce04453ab77.

If you plan to be building the user-mode linux kernel for this range of kernel
commits, you may need to apply the changes from commit
e5f0bdc7840bdb791247cb98dfc1dab6ea6c7da4 which fix the building problem for
ARCH=um.

Keywords: ext4, ftruncate, direct IO, dio
Architecture: amd64 (but likely is architecture-independent)

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
