From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 39072] New: jbd2 writes on disk every few seconds
Date: Sat, 9 Jul 2011 15:12:48 GMT
Message-ID: <bug-39072-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:56884 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875Ab1GIPMt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 9 Jul 2011 11:12:49 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.4) with ESMTP id p69FCmbT014396
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 9 Jul 2011 15:12:48 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=39072

           Summary: jbd2 writes on disk every few seconds
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.39.2 arch
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: marcin2006@gmail.com
        Regression: Yes


If I don't specify in /etc/fstab some large commit value, jbd2 is killing my
disk, I think even more frequently than default 5 seconds. Mount says:
/dev/sda6 on / type ext4 (rw,noatime,user_xattr,acl,barrier=1,data=ordered)
In iotop jbd2 constantly appears on top and sysctl vm.block_dump=1, dmesg |
grep -e READ -e WRITE shows that jdb2 is writting on the disk every few seconds
and only jdb2. I have IBM ThinkPad x30 here, but simmilar thing happens on my
PC. I guess it should not write to disk if there isn't really anything to
write. It is impossible to spin-down the HDD.

I have a minimal archlinux system here with xfce, running from failsafe entry
from GRUB, while pursuing this problem I have killed X, killed all daemons,
swapoff, unloaded acpi modules, usb modules and other - nothing helps.

I'm not even sure what logs should I attach as people are complaining on
different configurations for a year, it's all there:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/607560
https://bbs.archlinux.org/viewtopic.php?id=113516&p=1

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
