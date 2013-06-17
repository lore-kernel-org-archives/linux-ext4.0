From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 59801] New: kernel BUG at /kernel/fs/ext4/extents.c:1996!
Date: Mon, 17 Jun 2013 02:20:38 +0000 (UTC)
Message-ID: <bug-59801-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:36775 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753215Ab3FQCUl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 16 Jun 2013 22:20:41 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id C371B20199
	for <linux-ext4@vger.kernel.org>; Mon, 17 Jun 2013 02:20:40 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 0C1582018E
	for <linux-ext4@vger.kernel.org>; Mon, 17 Jun 2013 02:20:39 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=59801

           Summary: kernel BUG at /kernel/fs/ext4/extents.c:1996!
           Product: File System
           Version: 2.5
    Kernel Version: 3.0.21
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: yang.yulin@zte.com.cn
        Regression: No


Is it data corrupted? this bug make the device reset again and again, if there
is a tool which can repair this error? I tried e2fsck, it didn't work.

Please help, thanks!

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
