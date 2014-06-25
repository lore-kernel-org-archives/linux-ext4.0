From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 41962] New: fs/jbd2/transaction.c:1113 and fs/buffer.c:2915
Date: Wed, 25 Jun 2014 16:11:27 +0000
Message-ID: <bug-41962-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:35113 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756887AbaFYQLa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Jun 2014 12:11:30 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 5DD0620395
	for <linux-ext4@vger.kernel.org>; Wed, 25 Jun 2014 16:11:28 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 56F9320386
	for <linux-ext4@vger.kernel.org>; Wed, 25 Jun 2014 16:11:27 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=41962

            Bug ID: 41962
           Summary: fs/jbd2/transaction.c:1113 and fs/buffer.c:2915
           Product: File System
           Version: 2.5
    Kernel Version: 3.0.3
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: lasse-kernel-bug-2011@mail.plastictree.net
                CC: xerofoify@gmail.com
        Regression: No
                CC: xerofoify@gmail.com

Created attachment 70802
  --> https://bugzilla.kernel.org/attachment.cgi?id=70802&action=edit
dmesg

Certain filesystem usage leads to one of the two errors visible in dmesg output
(see attachment). The system needs a reboot after that.

I have also tested with olders kernel versions, including 2.6.38.8. Same there
(at least for the first of the two errors).

Strangely, the only filesystem usage scheme that triggers those errors are two
parallel processes of the bup backup system <https://github.com/apenwarr/bup>.
They run fine for some time (several minutes, sometimes longer), then the bug
message appears in the logs, and the system stops working correctly.

I am using an encrypted LVM.

--- Comment #1 from xerofoify@gmail.com ---
Please test this bug against a newer kernel to see if it's fixed.
Cheers Nick

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
