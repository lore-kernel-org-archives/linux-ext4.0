From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 198301] New: ext4 fails to create symlink if target length is
 greater than block size (but smaller than PATH_MAX)
Date: Thu, 28 Dec 2017 15:34:27 +0000
Message-ID: <bug-198301-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:46020 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932135AbdL1Pe3 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 28 Dec 2017 10:34:29 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 02B1D2D7EB
        for <linux-ext4@vger.kernel.org>; Thu, 28 Dec 2017 15:34:29 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=198301

            Bug ID: 198301
           Summary: ext4 fails to create symlink if target length is
                    greater than block size (but smaller than PATH_MAX)
           Product: File System
           Version: 2.5
    Kernel Version: Confirmed in 4.4.103 & 4.10.0
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: ernst@pleiszenburg.de
        Regression: No

If the block size of an ext4 file system is smaller than PATH_MAX, ext4 will
fail to create symlinks to targets with names longer than block size minus one.

Expected result: Symlinks with targets up to a length of PATH_MAX - 1 can be
created.

Actual result: Symlinks with targets up to a length of block size - 1 can be
created. If block size smaller than PATH_MAX, creating symlinks with targets
equal or greater than block size and smaller than PATH_MAX will fail with
ENAMETOOLONG. 

The strange side effect of this bug is that one can not link to every file in a
file system with a block size of e.g. 1k while PATH_MAX is 4k.

For reference, the original test & discussion which triggered this bug:
https://github.com/pjd/pjdfstest/issues/24

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
