From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 70091] mutex_unlock is missed in function
 (swap_inode_boot_loader) in file (linux-3.13/fs/ext4/ioctl.c)
Date: Sun, 30 Mar 2014 19:51:52 +0000
Message-ID: <bug-70091-13602-SujqfMuJLm@https.bugzilla.kernel.org/>
References: <bug-70091-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:35474 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620AbaC3Tv6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 30 Mar 2014 15:51:58 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id EEA9420364
	for <linux-ext4@vger.kernel.org>; Sun, 30 Mar 2014 19:51:57 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 61B8B20377
	for <linux-ext4@vger.kernel.org>; Sun, 30 Mar 2014 19:51:52 +0000 (UTC)
In-Reply-To: <bug-70091-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=70091

Conrad Meyer <cse.cem@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |cse.cem@gmail.com

--- Comment #1 from Conrad Meyer <cse.cem@gmail.com> ---
This was fixed in 30d29b119ef01776e0a301444ab24defe8d8bef3

Author: Zheng Liu <wenqing.lz@taobao.com>
Date:   Wed Feb 12 11:48:31 2014 -0500

    ext4: fix error paths in swap_inode_boot_loader()

    In swap_inode_boot_loader() we forgot to release ->i_mutex and resume
    unlocked dio for inode and inode_bl if there is an error starting the
    journal handle.  This commit fixes this issue.

In merge commit 805937cf45f9a9933e6b8e5c6660406e977a9a23

Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue Feb 18 10:04:09 2014 -0800

    Merge tag 'ext4_for_linus_stable' of
git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4

    ...

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
