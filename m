From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15906] New: serious performance regression in "umount" on ext4
 over LVM
Date: Tue, 4 May 2010 20:36:59 GMT
Message-ID: <bug-15906-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:41910 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933729Ab0EDUhB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 May 2010 16:37:01 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o44Kaxhb009630
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 4 May 2010 20:36:59 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15906

           Summary: serious performance regression in "umount" on ext4
                    over LVM
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
        ReportedBy: kees@outflux.net
        Regression: Yes


As root, if /tmp is on an LV (or possibly even without this):

cd /tmp
dd if=/dev/zero of=test.ext4 bs=1 count=1 seek=1G
mkfs.ext4 -F test.ext4
mkdir -p /mnt/test
mount -o loop test.ext4 /mnt/test
echo $(seq 65536) | (cd /mnt/test; xargs touch)
time umount /mnt/test

Prior to 2.6.32, this took a second or so.  Now it takes over a minute.

Reproduced in both Ubuntu 10.04 (2.6.32) and Fedora 12 (2.6.33).
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/543617

The current Ubuntu work-around is only useful on an otherwise idle system.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
