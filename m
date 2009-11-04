From: fabian-buettner@gmx.de
Subject: Corrupt superblocks
Date: Wed, 4 Nov 2009 19:39:57 +0100
Message-ID: <200911041939.57795.fabian-buettner@gmx.de>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:37858 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752374AbZKDSjy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Nov 2009 13:39:54 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

After updating my gentoo machine (new udev, lvm2) and rebooting, my initrd was 
broken (i had CONFIG_SYSFS_DEPRECATED and CONFIG_SYSFS_DEPRECATEDV2 activated) 
and the new udev didn't like these settings.
So I received a warning regarding this issue. Unfortunately I had set the init 
bootparameter to init=/sbin/bootchartd. And when i was returning from getting 
a cup of coffee. Bootchartd was spamming my console telling me: No space left 
on the device (or similar). When i was seeing this i had instantly a VERY bad 
feeling about what was going on there.

So i put in the rescuecd, chrooted into my old system, built a new kernel 
without these deprecated options, rebooted again.

This time fsck.ext4 was telling me: No such file or directory while trying to 
open /dev/vg/root, the superblock could not be read.

That's the story how I managed to corrupt my superblock and probably also it's 
backups.
I have run e2fsck -b for several times (with different superblock backup 
locations), also did a fsck manually and got spammed by a LOT of "Group 
descriptor checksum is invalid" warnings, but the fsck.ext4 error message 
remained.

For now I have set my filesystem in /etc/fstab to 0 0, but i REALLY want to get 
this fixed. 

So i googled around and found this thread: 
http://markmail.org/message/3w5tbyaiho7os4fr where some guy as a similar 
problem. 
Theodore Tso asked him to execute several commands, which i did too.
It would be great if someone with more experience than me could check those 
files, unfortunately they are huge.
Here is the link to the three logs:
http://www.file-upload.net/download-1989316/dumpe2fsfab.tar.gz.html

Thanks in advance,
fabian
