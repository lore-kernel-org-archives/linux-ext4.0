From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42694] New: lvcreate: lock held when returning to user space
Date: Mon, 30 Jan 2012 14:07:42 GMT
Message-ID: <bug-42694-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:51957 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541Ab2A3OHm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Jan 2012 09:07:42 -0500
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q0UE7g5c008073
	for <linux-ext4@vger.kernel.org>; Mon, 30 Jan 2012 14:07:42 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42694

           Summary: lvcreate: lock held when returning to user space
           Product: File System
           Version: 2.5
    Kernel Version: 3.2.2
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext3
        AssignedTo: fs_ext3@kernel-bugs.osdl.org
        ReportedBy: ryan@tau.solarneutrino.net
        Regression: No


I got this with 3.2.2, creating a snapshot of an ext3 filesystem on lvm.

Let me know if you need more information.

lvcreate: sending ioctl 1261 to a partition!

================================================
[ BUG: lock held when returning to user space! ]
------------------------------------------------
lvcreate/23845 is leaving the kernel with locks still held!
1 lock held by lvcreate/23845:
 #0:  (&journal->j_barrier){+.+...}, at: [<ffffffff8110a60a>]
journal_lock_updates+0xdc/0xeb

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
