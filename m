From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 95571] New: ext4 fs corruption on power-cut while running
 fsstress
Date: Wed, 25 Mar 2015 15:18:28 +0000
Message-ID: <bug-95571-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:47451 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753662AbbCYPSa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Mar 2015 11:18:30 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 8CA1F2037D
	for <linux-ext4@vger.kernel.org>; Wed, 25 Mar 2015 15:18:29 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id BC9BE20379
	for <linux-ext4@vger.kernel.org>; Wed, 25 Mar 2015 15:18:28 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=95571

            Bug ID: 95571
           Summary: ext4 fs corruption on power-cut while running fsstress
           Product: File System
           Version: 2.5
    Kernel Version: 4.0.0-rc3
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: ionut.trandafir12@gmail.com
        Regression: No

Created attachment 172361
  --> https://bugzilla.kernel.org/attachment.cgi?id=172361&action=edit
ext4 fs corruption at power cut

I'm using an Ubuntu-13.10 VM for this testing. Kernel 4.0.0-rc3 compiled from
git and e2fsprogs 1.42.12.
The steps I run:
 # mkfs.ext4 /dev/sdb1
 # mount -t ext4 -o defaults,barrier=1,noatime /dev/sdb1 /mnt
 # fsstress -w -X -d /mnt/fsstress -l 0 -n 100 -p 100 -s urandom
Let it run for 10 sec and then poweroff the virtual machine:
 $ vboxmanage controlvm Ubuntu-13.10-server poweroff
After reboot, I run:
 # fsck.ext4 -vpf /dev/sdb1
This fails with exit code 4, 2 out of 10 runs. The fail log is attached.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
