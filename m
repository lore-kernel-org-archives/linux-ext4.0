From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16227] Mount command sees partition 2 and partition 7 as same
 partition
Date: Thu, 17 Jun 2010 16:59:16 GMT
Message-ID: <201006171659.o5HGxGV3014792@demeter.kernel.org>
References: <bug-16227-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:50246 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933084Ab0FQQ7R (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Jun 2010 12:59:17 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o5HGxGGm014793
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 17 Jun 2010 16:59:16 GMT
In-Reply-To: <bug-16227-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16227





--- Comment #3 from Eugene Blanchard <eugene.blanchard@sait.ca>  2010-06-17 16:59:00 ---
Using 7 partitions, this bug is reproduceable using SATA, PATA and SCSI drives
on multiple servers. I first ran into this in 2009-05-01 and posted to the
CentOS bug tracker. Today, I reloaded my server configuration and went to 9
partitions using the exact same documented procedure and all partitions
functioned properly without interaction as noted in this bug report. This bug
may only pertain to 7 partitions and the interaction between the primary
partition 2 and the logical partition 7.

fdisk -l /dev/cciss/c0d0

Disk /dev/cciss/c0d0: 72.8 GB, 72833679360 bytes
255 heads, 63 sectors/track, 8854 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

           Device Boot      Start         End      Blocks   Id  System
/dev/cciss/c0d0p1   *           1          13      104391   83  Linux
/dev/cciss/c0d0p2              14         905     7164990   83  Linux
/dev/cciss/c0d0p3            8758        8854      779152+  82  Linux swap /
Solaris
/dev/cciss/c0d0p4             906        8757    63071190    5  Extended
/dev/cciss/c0d0p5             906        1798     7172991   83  Linux
/dev/cciss/c0d0p6            1799        2691     7172991   83  Linux
/dev/cciss/c0d0p7            2692        3584     7172991   83  Linux

cat /proc/mounts
rootfs / rootfs rw 0 0
/dev/root / ext3 rw,data=ordered 0 0
/dev /dev tmpfs rw 0 0
/proc /proc proc rw 0 0
/sys /sys sysfs rw 0 0
/proc/bus/usb /proc/bus/usb usbfs rw 0 0
devpts /dev/pts devpts rw 0 0
/dev/cciss/c0d0p1 /boot ext3 rw,data=ordered 0 0
tmpfs /dev/shm tmpfs rw 0 0
none /proc/sys/fs/binfmt_misc binfmt_misc rw 0 0
/etc/auto.misc /misc autofs
rw,fd=7,pgrp=2909,timeout=300,minproto=5,maxproto=5,indirect 0 0
-hosts /net autofs
rw,fd=13,pgrp=2909,timeout=300,minproto=5,maxproto=5,indirect 0 0

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
