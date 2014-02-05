From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 70091] New: mutex_unlock is missed in function
 (swap_inode_boot_loader) in file (linux-3.13/fs/ext4/ioctl.c)
Date: Wed, 05 Feb 2014 19:36:43 +0000
Message-ID: <bug-70091-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:38448 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440AbaBETgq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 5 Feb 2014 14:36:46 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 86AFE2016C
	for <linux-ext4@vger.kernel.org>; Wed,  5 Feb 2014 19:36:45 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 0AD0620154
	for <linux-ext4@vger.kernel.org>; Wed,  5 Feb 2014 19:36:44 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=70091

            Bug ID: 70091
           Summary: mutex_unlock is missed in function
                    (swap_inode_boot_loader) in file
                    (linux-3.13/fs/ext4/ioctl.c)
           Product: File System
           Version: 2.5
    Kernel Version: 3.13
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: atamrawi@iastate.edu
        Regression: No

In function (swap_inode_boot_loader) in file (linux-3.13/fs/ext4/ioctl.c):

The structures: (inode->i_mutex) and (inode_bl->i_mutex) gets successfully
locked at line (133) by (lock_two_nondirectories(inode, inode_bl), but both are
not unlocked when the function returns after line (147), however they got
unlocked only at line (208) by (unlock_two_nondirectories(inode, inode_bl)).

A possible solution is to call (unlock_two_nondirectories(inode, inode_bl))
before line (147).

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
