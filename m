From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 112631] New: Cannot open encrypted Luks root filesystem
Date: Wed, 17 Feb 2016 20:08:29 +0000
Message-ID: <bug-112631-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:44242 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965545AbcBQUIc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Feb 2016 15:08:32 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 5900620398
	for <linux-ext4@vger.kernel.org>; Wed, 17 Feb 2016 20:08:31 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id E7F55203B1
	for <linux-ext4@vger.kernel.org>; Wed, 17 Feb 2016 20:08:29 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=112631

            Bug ID: 112631
           Summary: Cannot open encrypted Luks root filesystem
           Product: File System
           Version: 2.5
    Kernel Version: 4.1.18
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: alex.theoto@gmail.com
        Regression: No

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
