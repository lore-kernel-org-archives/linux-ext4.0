From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 113781] New: kernel 4.4.1-2-ARCH, 4.4.3-1-ARCH and Fake RAID
 array setup
Date: Sat, 05 Mar 2016 13:57:05 +0000
Message-ID: <bug-113781-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:33197 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148AbcCEN5K (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 5 Mar 2016 08:57:10 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id DA3D62022A
	for <linux-ext4@vger.kernel.org>; Sat,  5 Mar 2016 13:57:07 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id D52CF20253
	for <linux-ext4@vger.kernel.org>; Sat,  5 Mar 2016 13:57:05 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=113781

            Bug ID: 113781
           Summary: kernel 4.4.1-2-ARCH, 4.4.3-1-ARCH and Fake RAID array
                    setup
           Product: File System
           Version: 2.5
    Kernel Version: 4.4.1-2-ARCH, 4.4.3-1-ARCH
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: hasecomp@aim.com
        Regression: No

Unfortunately, I am not 100% sure that this is a kernel problem, but after you
read this post, I hope you understand why I assigned this bug report to the
Linux kernel. A search on "RAID" through the bug database did not result in
anything comparable with the Fake RAID problem described here.

First the symptoms, afterwards detailed explanation of the software and
hardware used. Below, it always concerns PC configurations with a so-called
"Fake RAID array", with 2 disks connected in a RAID 0 setup.

PC 1.

Immediately after Linux kernel 4.4.1-2-x86_64 ARCH had been installed on
2016-02-03, no Fake RAID disks were recognised anymore. When you start dmraid,
under kernel 4.4.1-2 you get a message something like "No block devices", under
kernel 4.4.3-1 you get the message "No raid disks". Downgrade to the previously
working kernel 4.3.3-3-x86_64 ARCH made the PC run again. According to fsck
filesystems are still OK.

PC 2.

A fairly heavily used PC at the time. Around 2016-02-03 Linux kernel
4.4.1-2-x86_64 ARCH was one of the updates. It took approximately 2 to 3 weeks
until the disks were suddenly hopelessly screwed up. It is impossible to do
anything with these disks; I will have to reformat them again and for safety's
sake I will also repartition them again one day. Power supply has been taken
off these disks and temporarily a third (single) disk has been installed with a
Linux system (kernel 4.4.1-2-x86_64 ARCH, in the meantime 4.4.3-1-x86_64 ARCH).
PC runs fine, admittedly only for a few days now, but my faith in Linux and/or
the hardware would be unbearably shaken if this configuration would fail in the
near or further future. 

PC 3.

Around 2016-02-03 Linux kernel 4.4.1-2-x86_64 ARCH was among updates. At the
time, this system was rarely used. Having seen the problems with the other 2
PC's, I downgraded the kernel to 4.3.3-3-x86_64 ARCH. According to fsck the
filesystems are still OK. 

Downgrading the kernel is of course not a permanent solution.

Software.

For approximately 3 years now, I use the Archlinux distribution on my PCs.
Archlinux has no versions, it has "rolling updates". So far, I never had
problems with this distribution.

Besides the kernel, from the dependency tree, here are some of the Archlinux
packages that maybe relevant in the context of Fake RAID, together with their
installation dates (installation dates are taken from the file date in the
package cache).

- dmraid: version 1.0.0.rc16.3-10-x86_64, since october 2013.
- device-mapper: version 2.02.141-1-x86_64, since 2016-01-25.
- thin-provisioning-tools: version 0.6.0-2-x86_64, since 2016-01-24.

All filesystems are eventually ext4, the home directory is encrypted with Luks.

Hardware.

Not clear if it helps, but here is the hardware, relevant in this context, of
the PCs mentioned above.

PC 1 (since January 2009).

Motherboard: Asus M3A78-T.
CPU: AMD Phenom X4 9850.
Storage controller: AMD 750 with Promise (Fake) RAID firmware.
Magnetic disks (2*): Western Digital Cavair Blue WD3200AAKS.

PC 2 (since April 2012).

Motherboard: Asus F1A75-V PRO.
CPU: AMD A8 3850.
Storage controller: AMD A75 FCH with Promise (Fake) RAID firmware.
Magnetic disks (2*): Western Digital WD5000AAKX Blue.

PC 3 (since August 2010).
Motherboard: Asus M4A89GTD Pro/USB3.
CPU: AMD Phenom II X4 965.
Storage controller: AMD 850 with Promise (Fake) RAID firmware.
Magnetic disks (2*): Western Digital WD5000AAKS.

If I can help by supplying more data, please let me know. From the disks on PCs
1 and 3 I can read data in a "normal" way. From the disks on PC 2 I'm not so
sure. Most likely, I can still read data such as a superblock (or what is left
of it) with dd from a live CD, but in that case you would have to specify
precisely on which disk and where I can find the data, as well as how much data
you want.

Kind regards,
Andre Hasekamp.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
