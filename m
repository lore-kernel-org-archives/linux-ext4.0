From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 103421] New: kernel panic during system resume
Date: Mon, 24 Aug 2015 10:35:23 +0000
Message-ID: <bug-103421-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:56018 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752649AbbHXKf0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Aug 2015 06:35:26 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 1C4D32071C
	for <linux-ext4@vger.kernel.org>; Mon, 24 Aug 2015 10:35:25 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 937672070C
	for <linux-ext4@vger.kernel.org>; Mon, 24 Aug 2015 10:35:23 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=103421

            Bug ID: 103421
           Summary: kernel panic during system resume
           Product: File System
           Version: 2.5
    Kernel Version: kernel-4.1.5-200.fc22.x86_64
          Hardware: x86-64
                OS: Linux
              Tree: Fedora
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: kparal@redhat.com
        Regression: No

Created attachment 185621
  --> https://bugzilla.kernel.org/attachment.cgi?id=185621&action=edit
kernel panic screenshot

This kernel panic appeared on my screen during system resume. I'm using Fedora
22. I contains many ext4 words, so I assumed it could be related to it. I had
to hard reboot the system, not even sysrq worked (IIRC). I can't easily
reproduce it.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
