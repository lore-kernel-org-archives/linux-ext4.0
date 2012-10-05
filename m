From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 48431] New: ext4_fill_super() reports success even if
 ext4_mb_init() fails
Date: Fri,  5 Oct 2012 12:19:07 +0000 (UTC)
Message-ID: <bug-48431-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:56210 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932193Ab2JEMTM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Oct 2012 08:19:12 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 9E8C42045B
	for <linux-ext4@vger.kernel.org>; Fri,  5 Oct 2012 12:19:11 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 96BC220453
	for <linux-ext4@vger.kernel.org>; Fri,  5 Oct 2012 12:19:09 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=48431

           Summary: ext4_fill_super() reports success even if
                    ext4_mb_init() fails
           Product: File System
           Version: 2.5
    Kernel Version: 3.6
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: eugene.shatokhin@rosalab.ru
        Regression: No


Created an attachment (id=82361)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=82361)
The patch to fix the problem

If ext4_mb_init() called from ext4_fill_super() (fs/ext4/super.c:3980 in the
current ext4 git tree) fails and returns error code, ext4_fill_super() still
returns 0. 

This happens because the return value of ext4_mb_init() is not assigned to
'ret' in the error path. So the previous value of 'ret' (0) is returned from
ext4_fill_super().

This problem leads to a kernel oops in mount_fs() when the latter tries to
access the struct dentry that the mount() callback returns ("sb = root->d_sb;"
in fs/super.c:1180).

The problem has been revealed with the help of the fault simulation facilities
provided by KEDR Framework.

Attached is a trivial patch that fixes the problem.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
