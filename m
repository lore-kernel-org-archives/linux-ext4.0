From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 63981] New: Bad: Buffer I/O errors make disk unusable
Date: Mon, 28 Oct 2013 19:38:44 +0000
Message-ID: <bug-63981-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:34106 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754833Ab3J1Tis (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Oct 2013 15:38:48 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 1548520395
	for <linux-ext4@vger.kernel.org>; Mon, 28 Oct 2013 19:38:47 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 653E72039A
	for <linux-ext4@vger.kernel.org>; Mon, 28 Oct 2013 19:38:45 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=63981

            Bug ID: 63981
           Summary: Bad: Buffer I/O errors make disk unusable
           Product: File System
           Version: 2.5
    Kernel Version: 3.12.0-rc6
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: scalg1@bfh.ch
        Regression: No

Created attachment 112591
  --> https://bugzilla.kernel.org/attachment.cgi?id=112591&action=edit
dmesg of the errors causing the problem

When I use my laptop, suddenly the SSD disk become unusable. The disk is
mounted in read-only mode and the only way to get it work again is to reboot.
During the reboot, the file system check, fixes the errors and I can use the
laptop for some hours after that the problem appear again.

This problem is difficult to reproduce because there are no precise steps to
perform in order to cause the I/O errors showed by the attached dmesg. 

I had the same problem using kernel 3.11.5 and 3.10.6. I use a
Sony VAIO pro (Sony Corporation SVP1321C5E/VAIO, BIOS R1040V7 09/09/2013).

============================

Information about my system:

bash-4.2# cat /proc/scsi/scsi 
Attached devices:
Host: scsi3 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: SAMSUNG MZNTD256 Rev: DXT2
  Type:   Direct-Access                    ANSI  SCSI revision: 05

========================================

/etc/fstab

/dev/sda1        /                ext4        defaults         1   1
/dev/sda2        /home/      ext4        defaults         1   2
/dev/sda3        /media/hd1       ext4        defaults         1   2
#/dev/cdrom      /mnt/cdrom       auto       
noauto,owner,ro,comment=x-gvfs-show 0   0
/dev/fd0         /mnt/floppy      auto        noauto,owner     0   0
devpts           /dev/pts         devpts      gid=5,mode=620   0   0
proc             /proc            proc        defaults         0   0
tmpfs            /dev/shm         tmpfs       defaults         0   0
tmpfs            /tmp             tmpfs defaults,noatime,nodiratime,mode=1777 
0   0
tmpfs            /var/spool       tmpfs defaults,noatime,nodiratime,mode=1777 
0   0
tmpfs            /var/tmp         tmpfs defaults,noatime,nodiratime,mode=1777 
0   0

/proc/version

Linux version 3.12.0-rc6 (root@darkstar) (gcc version 4.8.1 (GCC) ) #1 SMP Sun
Oct 27 19:02:16 CET 2013


Attached you will find the relevant part of dmesg.

Thanks for your help.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
