From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16227] New: Mount command sees partition 2 and partition 7 as
 same partition
Date: Wed, 16 Jun 2010 16:29:06 GMT
Message-ID: <bug-16227-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:33874 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759178Ab0FPQ3J (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Jun 2010 12:29:09 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o5GGT7Du014357
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 16 Jun 2010 16:29:07 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16227

               URL: http://bugs.centos.org/view.php?id=3601
           Summary: Mount command sees partition 2 and partition 7 as same
                    partition
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.18-164.6.1.el5
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext3
        AssignedTo: fs_ext3@kernel-bugs.osdl.org
        ReportedBy: eugene.blanchard@sait.ca
        Regression: No


When mounting multiple partitions, partition 7 sees partition 2 instead of
partition 7. Partition scheme is as follows:

/dev/hda1 /boot
/dev/hda2 /
/dev/hda3 swap
/dev/hda4 extended partition
/dev/hda5 / (copy of /dev/hda2)
/dev/hda6 / (copy of /dev/hda2)
/dev/hda7 / (copy of /dev/hda2)

After copying /dev/hda2 to each partition using Gparted, I boot to /dev/hda2
and mount /dev/hda5, /dev/hda6 and /dev/hda7 to /mnt/p5, /mnt/p6, /mnt/p7
respectively. /mnt/p5 and /mnt/p6 work as expected.

Here's the problem: /mnt/p7 - any modifications to it's files, modifies
/dev/hda2 partition's files and vice versa. 

I have reproduced this across several different machines: HP DL360s, PCs, etc..
using PATA, SATA and SCSI drives. 

If I only mount p7, then partition p7 works as expected. This bug is originally
documented in the CentOS bug tracker listed in the URL.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
