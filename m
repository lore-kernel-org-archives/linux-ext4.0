From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 111801] New: mount fails silently if mount point is "busy"
Date: Wed, 03 Feb 2016 14:53:26 +0000
Message-ID: <bug-111801-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:42773 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745AbcBCOxd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Feb 2016 09:53:33 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 4F6E0201FA
	for <linux-ext4@vger.kernel.org>; Wed,  3 Feb 2016 14:53:32 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id AC3852027D
	for <linux-ext4@vger.kernel.org>; Wed,  3 Feb 2016 14:53:26 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=111801

            Bug ID: 111801
           Summary: mount fails silently if mount point is "busy"
           Product: File System
           Version: 2.5
    Kernel Version: all, back to 2.6.11, at least, including the latest
                    raspbian, Ubuntu 14.04.3.LTS, as well as Fedora Cor 16
                    and even SuSE 9.3 (kernel 2.6..11, c. 2006)
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: diemkae@gmail.com
        Regression: No

Attempt to mount a extX, vfat, CIFS, etc. filesystem to a mount point that is
"busy" fails silently but appears to "work" in that "df" indicates the
filesystem is mounted to that mount point (per /etc/fstab), and it appears to
be normal in /etc/mtab, yet the partition files do not appear in the mount
point directory and if were are any files in the (root FS) mount point
directory, they are still accessible)!

As illustrated in the example below, the failed mount can be remedied by
umounting the partition, cd'ing to $HOME (to make the mount point not busy),
then remounting the partition, the mount point then contains the files from the
partition. 

Example: illustrates (under Raspbian, on a Raspbery Pi) how to reproduce a
silent failure when vfat partition mounted to a busy mount point (made only
busy because shell CWD is the mount point directory):

Script started on Wed 03 Feb 2016 07:41:27 AM EST
root@raspi2:/# df
Filesystem        1K-blocks      Used Available Use% Mounted on
/dev/root          15186900   6421400   8098164  45% /
devtmpfs             469752         0    469752   0% /dev
tmpfs                 94816       404     94412   1% /run
tmpfs                  5120         0      5120   0% /run/lock
tmpfs                189620         0    189620   0% /run/shm
//nas2/export.dmk 961301000 338699164 573747452  38% /media/nas1.dmk
/dev/mmcblk0p1        57288     20304     36984  36% /boot
root@raspi2:/# ls /boot
bcm2708-rpi-b.dtb       config.txt     issue.txt         overlays
bcm2708-rpi-b-plus.dtb  COPYING.linux  kernel7.img       start_cd.elf
bcm2708-rpi-cm.dtb      fixup_cd.dat   kernel.img        start_db.elf
bcm2709-rpi-2-b.dtb     fixup.dat      LICENCE.broadcom  start.elf
bootcode.bin            fixup_db.dat   LICENSE.oracle    start_x.elf
cmdline.txt             fixup_x.dat    origCmdline.txt   whereAmI
root@raspi2:/# more /boot/whereAmI
this is on the SD card.
root@raspi2:/#
root@raspi2:/# umount /boot
root@raspi2:/# df
Filesystem        1K-blocks      Used Available Use% Mounted on
/dev/root          15186900   6421400   8098164  45% /
devtmpfs             469752         0    469752   0% /dev
tmpfs                 94816       404     94412   1% /run
tmpfs                  5120         0      5120   0% /run/lock
tmpfs                189620         0    189620   0% /run/shm
//nas2/export.dmk 961301000 338699164 573747452  38% /media/nas1.dmk
root@raspi2:/# ls /boot
whereAmI
root@raspi2:/# more /boot/whereAmI
this is in the root fs /boot directory
root@raspi2:/# mount /boot
root@raspi2:/# df
Filesystem        1K-blocks      Used Available Use% Mounted on
/dev/root          15186900   6421400   8098164  45% /
devtmpfs             469752         0    469752   0% /dev
tmpfs                 94816       404     94412   1% /run
tmpfs                  5120         0      5120   0% /run/lock
tmpfs                189620         0    189620   0% /run/shm
//nas2/export.dmk 961301000 338699164 573747452  38% /media/nas1.dmk
/dev/mmcblk0p1        57288     20304     36984  36% /boot
root@raspi2:/# ls /boot
bcm2708-rpi-b.dtb       config.txt     issue.txt         overlays
bcm2708-rpi-b-plus.dtb  COPYING.linux  kernel7.img       start_cd.elf
bcm2708-rpi-cm.dtb      fixup_cd.dat   kernel.img        start_db.elf
bcm2709-rpi-2-b.dtb     fixup.dat      LICENCE.broadcom  start.elf
bootcode.bin            fixup_db.dat   LICENSE.oracle    start_x.elf
cmdline.txt             fixup_x.dat    origCmdline.txt   whereAmI
root@raspi2:/# more /boot/whereAmI
this is on the SD card.
root@raspi2:/#
Script done on Wed 03 Feb 2016 07:42:34 AM EST

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
