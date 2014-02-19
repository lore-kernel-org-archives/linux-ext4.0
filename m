From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 70831] New: Bind mount doesn't allow to trash files and
 directories
Date: Wed, 19 Feb 2014 11:02:43 +0000
Message-ID: <bug-70831-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:50005 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527AbaBSLCr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Feb 2014 06:02:47 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id F1FE6201D5
	for <linux-ext4@vger.kernel.org>; Wed, 19 Feb 2014 11:02:45 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 3A502201CD
	for <linux-ext4@vger.kernel.org>; Wed, 19 Feb 2014 11:02:44 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=70831

            Bug ID: 70831
           Summary: Bind mount doesn't allow to trash files and
                    directories
           Product: File System
           Version: 2.5
    Kernel Version: Debian 3.11.8-1
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: dbz.gml@gmail.com
        Regression: No

Hello.

I've asked a question here
(https://unix.stackexchange.com/questions/115757/bind-mount-unable-to-delete-files-to-trash)
about strange situation with deleting files from bind-mounted directories.
Someone Ricky Beam supposed this is a kernel issue.

This is a quote of his words:
[QUOTE]
This is a linux kernel issue. It's not looking at the true super-block of the
source and destination filesystems:

17926 rename("d1/foo", "d2/foo")        = -1 EXDEV (Invalid cross-device link)
Looks like the issue is in do_rename() (fs/namei.c):

    error = -EXDEV;
    if (oldnd.mnt != newnd.mnt)
            goto exit2;
*sigh*
[/QUOTE]

Could you please take a look at this issue and confirm or disprove this is a
kernel issue?
Thank you very much!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
