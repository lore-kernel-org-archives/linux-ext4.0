From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15391] New: EXT4_USE_FOR_EXT23 causes ext4 partition to be
 mounted as ext2
Date: Thu, 25 Feb 2010 03:05:29 GMT
Message-ID: <bug-15391-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:51013 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758729Ab0BYDFa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Feb 2010 22:05:30 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o1P35TfL015960
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 25 Feb 2010 03:05:29 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=15391

           Summary: EXT4_USE_FOR_EXT23 causes ext4 partition to be mounted
                    as ext2
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.33
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: alecm@gmx.com
        Regression: No


After setting "Use ext4 for ext2/ext3 file systems" and rebooting, my root
filesystem gets mounted as ext2. When the option is disabled, everything works
as expected.

Here are some relevant output:

$ grep ext[24] /etc/fstab
/dev/sda1       /boot  ext2    noauto,noatime      1 2
/dev/sda5       /      ext4    noatime             0 1

$ mount | grep ext[24]
/dev/root on / type ext2 (rw,noatime,barrier=1,data=ordered)
/dev/sda1 on /boot type ext2 (rw,noatime)

$ dmesg | grep -i ext[24]
EXT4-fs (sda5): mounted filesystem with ordered data mode
VFS: Mounted root (ext2 filesystem) readonly on device 259:131072.
EXT4-fs (sda1): mounted filesystem without journal

$ uname -a
Linux tux 2.6.33 #1 SMP PREEMPT Wed Feb 24 16:00:09 EST 2010 x86_64 Intel(R)
Core(TM)2 CPU T5300 @ 1.73GHz GenuineIntel GNU/Linux

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
