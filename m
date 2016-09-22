From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 172741] New: create year being set as 2014 and not 2016
Date: Thu, 22 Sep 2016 23:15:48 +0000
Message-ID: <bug-172741-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:56636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753466AbcIVXPw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 22 Sep 2016 19:15:52 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 521732041E
        for <linux-ext4@vger.kernel.org>; Thu, 22 Sep 2016 23:15:51 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id 46836203F1
        for <linux-ext4@vger.kernel.org>; Thu, 22 Sep 2016 23:15:49 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=172741

            Bug ID: 172741
           Summary: create year being set as 2014 and not 2016
           Product: File System
           Version: 2.5
    Kernel Version: 4.7 x86_64
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: westlake2012@videotron.ca
        Regression: No

There's a bug with ext4 on the new 4.7 kernel -- rare but it happened here on
an ext4 mountpoint (/home /dev/md1   ext4  rw,relatime,data=ordered)

when a new file was created, the "create time" was not properly set.(2014 was
written as the create year instead of 2016)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
