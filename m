From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15666] New: e2fsck -fD on ext4 breaks
Date: Thu, 1 Apr 2010 10:36:07 GMT
Message-ID: <bug-15666-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:42281 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754987Ab0DAKgK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Apr 2010 06:36:10 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o31Aa8WT027762
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 1 Apr 2010 10:36:08 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15666

           Summary: e2fsck -fD on ext4 breaks
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.32.10
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: khcha.n.el@gmail.com
        Regression: No


i did a e2fsck -fD on a ext4 filesystem, later a e2fsck -f complains a bunch of
errors. if i e2fsck -fy would end up a bunch of files go into lost+found or
simply lose trace.

Step to reproduce:
1. prepare a ext4 file system (dd if=/dev/zero of=test_ext4.img bs=1M
count=1000 && mkfs.ext4 test_ext4.img)
2. mount it (mount -t ext4 -o rw,loop test_ext4.img /mnt/tmp)
3. put some files on it, it seems to me that tiny files would cause the issue
(cp -r /home/$USER/.gconf /mnt/tmp)
4. un mount it (umount /mnt/tmp)
5. e2fsck -f test_ext4.img  all good
6. e2fsck -fD test_ext4.img seems fine
7. e2fsck -f test_ext4.img here comes trouble...

Components version:
Distro: Archlinux
Architecture: x86_64

kernel 2.6.32.10
e2fsck 1.41.10 (10-Feb-2009)
    Using EXT2FS Library version 1.41.10, 10-Feb-2009

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
