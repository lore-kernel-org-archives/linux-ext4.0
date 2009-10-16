From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14422] New: EXT4 is corrupted after clean shutdown
Date: Fri, 16 Oct 2009 18:31:54 GMT
Message-ID: <bug-14422-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:46907 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931AbZJPSbt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Oct 2009 14:31:49 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9GIVsKX004118
	for <linux-ext4@vger.kernel.org>; Fri, 16 Oct 2009 18:31:54 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14422

           Summary: EXT4 is corrupted after clean shutdown
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.32-rc1 - rc5
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: d.okias@gmail.com
        Regression: Yes


HW: Toshiba a210-15j
OS: Ubuntu Karmic 9.10 - 64bit
Kernel: 2.6.32-rc1 - rc5

/dev/sda1 /boot 100M ext2
/dev/sda2 / 10G ext4
/dev/sda3 swap
/dev/sda4 /home 100G ext4

After clean shutdown is corrupted lastest used files (KDE configuration, dpkg
/var/cache ... ) on /dev/sda2 sometimes even /dev/sda4

It was repeated several times.

It's really similiar to
http://lkml.indiana.edu/hypermail/linux/kernel/0910.1/02661.html

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
