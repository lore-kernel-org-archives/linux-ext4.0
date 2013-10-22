From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 63471] New: Please add a "quit" command to the e2fsck
 interactive mode
Date: Tue, 22 Oct 2013 07:16:05 +0000
Message-ID: <bug-63471-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:59916 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268Ab3JVHQJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Oct 2013 03:16:09 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id EFFC52046B
	for <linux-ext4@vger.kernel.org>; Tue, 22 Oct 2013 07:16:07 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id CA4BE20458
	for <linux-ext4@vger.kernel.org>; Tue, 22 Oct 2013 07:16:05 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=63471

            Bug ID: 63471
           Summary: Please add a "quit" command to the e2fsck interactive
                    mode
           Product: File System
           Version: 2.5
    Kernel Version: 3.11.6
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: enhancement
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: unforgettableid@gmail.com
                CC: tytso@mit.edu
        Regression: No

Some users don't know whether or not it is safe to exit e2fsck using Ctrl+C.

It would be great if you could please add a "quit" command to the e2fsck
interactive mode. The "quit" command should quit e2fsck, leaving users
confident that they didn't cause any extra damage to the filesystem by quitting
early.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
