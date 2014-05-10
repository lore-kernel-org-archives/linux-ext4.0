From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 75881] New: lazyinit failure on new mdadm raid5 & encrypted
 array
Date: Sat, 10 May 2014 18:47:17 +0000
Message-ID: <bug-75881-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:44904 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029AbaEJSrU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 10 May 2014 14:47:20 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 57A672017E
	for <linux-ext4@vger.kernel.org>; Sat, 10 May 2014 18:47:19 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 4D561201BC
	for <linux-ext4@vger.kernel.org>; Sat, 10 May 2014 18:47:17 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=75881

            Bug ID: 75881
           Summary: lazyinit failure on new mdadm raid5 & encrypted array
           Product: File System
           Version: 2.5
    Kernel Version: 3.13.10
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: thomas_reardon@hotmail.com
        Regression: No

Created attachment 135751
  --> https://bugzilla.kernel.org/attachment.cgi?id=135751&action=edit
kernel log, ext4 fs params

ext4 lazyinit fails with corruption when competing with mdadm raid5
reconstruction.  In the _default_ scenario, mdadm doesn't initialize a new
raid5 array but rather leaves the last drives as a rebuilding spare, rather
than a full initialization.

Adding to the load, the volume was an encrypted LUKS volume (at
/dev/mapper/private)

So the order of events:
1) create new 4x4TB RAID5 array via mdadm.  volume is started degraded and
starts rebuilding while allowing access.
2) layer new encrypted LUKS volume: /dev/md1 -> /dev/mapper/private
3) create EXT4 volume with 64bit,sparse_super2,
4) mount volume with journal_async_commit
5) a slow rsync is started in background, averaging 5MB/s

Please see attached

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
