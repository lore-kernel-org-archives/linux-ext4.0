From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 92271] New: Provide a way to really delete files, please
Date: Thu, 29 Jan 2015 11:47:59 +0000
Message-ID: <bug-92271-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:59554 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941AbbA2LsD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 29 Jan 2015 06:48:03 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D88A820149
	for <linux-ext4@vger.kernel.org>; Thu, 29 Jan 2015 11:48:01 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 6FF6D201F4
	for <linux-ext4@vger.kernel.org>; Thu, 29 Jan 2015 11:47:59 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=92271

            Bug ID: 92271
           Summary: Provide a way to really delete files, please
           Product: File System
           Version: 2.5
    Kernel Version: All
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: holler@ahsoftware.de
        Regression: No

Filesystems should offer the user a way to really delete files by really
destroying the contents of a deleted file.

E.g. by overwriting the deleted content or by using "Secure trim".

See here for more elaborate flame:

https://lkml.org/lkml/2015/1/24/41

Thanks in advance.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
