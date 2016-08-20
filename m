From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 88321] WARNING: CPU: 1 PID: 6784 at fs/dcache.c:1318
 umount_check+0x77/0x7b()
Date: Sat, 20 Aug 2016 23:06:37 +0000
Message-ID: <bug-88321-13602-yesOWJ8D4b@https.bugzilla.kernel.org/>
References: <bug-88321-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:40572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752154AbcHTXGl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 20 Aug 2016 19:06:41 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id F2C3220259
        for <linux-ext4@vger.kernel.org>; Sat, 20 Aug 2016 23:06:39 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id 264812024C
        for <linux-ext4@vger.kernel.org>; Sat, 20 Aug 2016 23:06:38 +0000 (UTC)
In-Reply-To: <bug-88321-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=88321

ingvarthorvald@gmail.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |ingvarthorvald@gmail.com

--- Comment #3 from ingvarthorvald@gmail.com ---
See if you can reproduce this on a newer kernel. Seems that this was fixed
somewhere as the call to kill_anon_super no longer shows up in nfs_kill_super.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
