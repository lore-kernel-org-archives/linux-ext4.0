From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 193431] 512 byte inodes + inline_data + journal_data ==
 segfaults/buserrors in userspace mmap
Date: Sun, 29 Jan 2017 22:21:22 +0000
Message-ID: <bug-193431-13602-Kp96vbuOoT@https.bugzilla.kernel.org/>
References: <bug-193431-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:59174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750775AbdA2WWM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 29 Jan 2017 17:22:12 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 626B0202C8
        for <linux-ext4@vger.kernel.org>; Sun, 29 Jan 2017 22:21:26 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id 00ED8202E5
        for <linux-ext4@vger.kernel.org>; Sun, 29 Jan 2017 22:21:22 +0000 (UTC)
In-Reply-To: <bug-193431-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=193431

Christian Kujau <lists@nerdbynature.de> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |lists@nerdbynature.de

--- Comment #1 from Christian Kujau <lists@nerdbynature.de> ---
I don't think this has anything to do with the underlying file system but
should be reported against the "libc-bin" package. The "ln" command above
creates a dead symlink and the same segfault happens when the symlink points to
/tmp/foo (tmpfs) or some other non-existant location. Running through strace
suggests some kind of programming logic error in localedef instead.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
