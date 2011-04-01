From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 32482] New: "htree_dirblock_to_tree:586: inode 260099: block
 1056737" message after every boot
Date: Fri, 1 Apr 2011 21:29:58 GMT
Message-ID: <bug-32482-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:54417 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756306Ab1DAV37 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Apr 2011 17:29:59 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p31LTxZM029452
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 1 Apr 2011 21:29:59 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=32482

           Summary: "htree_dirblock_to_tree:586: inode 260099: block
                    1056737" message after every boot
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.38.2
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: egokillsall@gmail.com
        Regression: No


Created an attachment (id=53012)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=53012)
kernel .config

Hello!

After each system boot this message pops:

kernel: EXT4-fs (sda10): error count: 5
kernel: EXT4-fs (sda10): initial error at 1301325048:
htree_dirblock_to_tree:586: inode 260099: block 1056737
kernel: EXT4-fs (sda10): last error at 1301325083: htree_dirblock_to_tree:586:
inode 260099: block 1056737

Strange thing is that the message pops 5 minutes right after everything settle.
It is clearly visible in the attached syslog. The machine is a Fujitsu-Siemens
Lifebook C1020, the OS is Debian Testing. sda10 is the last ~7GB partition on
the 120GB disk.
This is almost a fresh install, up since a week or such and the message was
there right since with the install, with the default kernel 2.6.32.5.
Tried to boot with acpi disabled, without 'lapic' (as it needs anyway to enable
it) and removing most of the modules right after booting, tried in recovery
mode, single mode, but no luck. The message just comes after 5 mins. But what
is waiting for 5 mins then tries to tamper like from 'outside' with a mounted
file system?
The thing should be kernel (and/or Bios) related as it seems, maybe something
with the well reputed Via chipset? (Irony)
Any help would be much appreciated.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
