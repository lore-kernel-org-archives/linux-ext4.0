From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 93491] New: Kernel crashes every 10 minutes. Computer stalls
Date: Thu, 19 Feb 2015 10:03:31 +0000
Message-ID: <bug-93491-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:52169 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323AbbBSKDd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Feb 2015 05:03:33 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 6038D202B4
	for <linux-ext4@vger.kernel.org>; Thu, 19 Feb 2015 10:03:32 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 8D71F20295
	for <linux-ext4@vger.kernel.org>; Thu, 19 Feb 2015 10:03:31 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=93491

            Bug ID: 93491
           Summary: Kernel crashes every 10 minutes. Computer stalls
           Product: File System
           Version: 2.5
    Kernel Version: 3.18.7-200.fc21.x86_64
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: ionut.radu@gmail.com
        Regression: No

Created attachment 167541
  --> https://bugzilla.kernel.org/attachment.cgi?id=167541&action=edit
abrt message

With the latest kernel, there are crashes every 10 minutes and computer stalls.
After reboot ABRT displays : 
kernel BUG at fs/ext4/mballoc.c:3272!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
