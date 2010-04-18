From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15806] New: Kernel Panic or Kernel becomes unstable with
 encrypted drives (TrueCrypt)
Date: Sun, 18 Apr 2010 11:15:53 GMT
Message-ID: <bug-15806-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:59060 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756909Ab0DRLQA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 18 Apr 2010 07:16:00 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o3IBFtwC023614
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sun, 18 Apr 2010 11:15:55 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15806

           Summary: Kernel Panic or Kernel becomes unstable with encrypted
                    drives (TrueCrypt)
           Product: File System
           Version: 2.5
    Kernel Version: linux kernel 2.6.34-999-generic (Ubuntu mainline
                    Kernel)
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: no-spam@spamfence.net
        Regression: No


Created an attachment (id=26040)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=26040)
Includes kern.log, linux-image.crash-log and file with system information

* Overview: More detailed restatement of summary.
I have 2 encrypted drives, the Kernel becomes unstable or I get Kernel Panic
when I'm using one of this drives. This means, if I try to copy files from one
encrypted drive to another I get in the most cases Kernel Panic after a short
time. 
If accessing more than one application files from an encrypted drive, I get
often the message that the system might become unstable and I need to reboot
because I can't access the encrypted drive any more. The same when I try to
force a file system check with fsck, I get every time the message that the
system might become unstable. 


* Steps to Reproduce: Minimized, easy-to-follow steps that will trigger the
bug. Include any special setup steps.
The easiest way to reproduce is to check the file system with fsck:
1) Mount the volume with the TrueCrypt GUI (check under "Filesystem: Do not
mount")
2) Force file check with "sudo fsck -f /dev/mapper/truecrypt1"
3) After a short while I get a new icon in the tray with the message "Your
system might become unstable now and might need to be restarted."


* Actual Results: What the application did after performing the above steps.
The Kernel becomes unstable (Your system might become unstable now and might
need to be restarted.) and I can't access the drive until reboot. 


* Expected Results: What the application should have done, were the bug not
present.
fsck should check the mapped drive and should fix errors if any. 


* Build Date & Platform: Date and platform of the build in which you first
encountered the bug.
I'm running Ubuntu 10.04 beta with mainline Kernel. 


* Additional Builds and Platforms: Whether or not the bug takes place on other
platforms (or browsers, if applicable).
The last Kernel without problems was 2.6.28.8 (Ubuntu 9.04), all newer Kernels
crashing my system. 


* Additional Information: Any other useful information.
I'm using TrueCrypt 6.3a, AES Encryption and the drives are formatted with
ext4.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
