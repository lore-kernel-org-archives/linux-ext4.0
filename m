From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 111891] New: access to file does not change access time to
 folders above up to /(root)
Date: Thu, 04 Feb 2016 14:42:42 +0000
Message-ID: <bug-111891-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:53379 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbcBDOmp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Feb 2016 09:42:45 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 20373203A0
	for <linux-ext4@vger.kernel.org>; Thu,  4 Feb 2016 14:42:44 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 8285E2038F
	for <linux-ext4@vger.kernel.org>; Thu,  4 Feb 2016 14:42:42 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=111891

            Bug ID: 111891
           Summary: access to file does not change access time to folders
                    above up to /(root)
           Product: File System
           Version: 2.5
    Kernel Version: 4.1.15
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: armin_mohring@web.de
        Regression: No

Ext4 with relatime mount option.

Access to file e.g.: /home/armin/documents/abc (file)
does lead into the following:

The access time of the /home directory is not changed, but should be.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
