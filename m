From: Christian Kujau <lists@nerdbynature.de>
Subject: e2fsck: Device or resource busy
Date: Mon, 2 Jun 2008 20:29:24 +0200 (CEST)
Message-ID: <alpine.DEB.1.10.0806021951460.6160@sheep.housecafe.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.188]:60342 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbYFBS30 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Jun 2008 14:29:26 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi there,

I'm trying to repair a severely damaged ext4 partition. Actually, I don't 
care any more for the data, I just wanted to see how far I could get, 
because the "damage" here is: the partition was 1/3 of a RAID-0 setup :)

So, if you're interested, read on. If not, please ignore this one...

So, after trying to (forcefully) repair an image of the parition[0], I'm 
getting this now:

--------------------------------------------------------------
# losetup /dev/loop1 /mnt/cifs/backup/sdb2.img 
# losetup -a
/dev/loop1: [0013]:1715743 (/mnt/cifs/backup/sdb2.img)

# file -s /dev/loop1
/dev/loop1: , 44.1 kHz, Stereo

# /opt/e2fsprogs/sbin/e2fsck /dev/loop1
e2fsck 1.41-WIP (27-Apr-2008)
/opt/e2fsprogs/sbin/e2fsck: Superblock invalid, trying backup blocks...
/opt/e2fsprogs/sbin/e2fsck: Bad magic number in super-block while trying to open /dev/loop1

The superblock could not be read or does not describe a correct ext2
filesystem.  If the device is valid and it really contains an ext2
filesystem (and not swap or ufs or something else), then the superblock
is corrupt, and you might try running e2fsck with an alternate superblock:
     e2fsck -b 8193 <device>

# /opt/e2fsprogs/sbin/e2fsck -b 8193 /dev/loop1
e2fsck 1.41-WIP (27-Apr-2008)
/opt/e2fsprogs/sbin/e2fsck: Device or resource busy while trying to open /dev/loop1
Filesystem mounted or opened exclusively by another program?

# losetup -a
/dev/loop1: [0013]:1715743 (/mnt/cifs/backup/sdb2.img)

# lsof -ln | grep loop
loop1      5065        0  cwd       DIR        8,5       4096          2 /
loop1      5065        0  rtd       DIR        8,5       4096          2 /
loop1      5065        0  txt   unknown                                  /proc/5065/exe
--------------------------------------------------------------

Does anyone have an idea why it says "Device or resource busy" as soon as 
I specify an alternate superblock? Details and strace:
http://nerdbynature.de/bits/e2fsprogs.pu/sdb2/2008-06-02/


Thanks,
Christian.

[0] http://nerdbynature.de/bits/e2fsprogs.pu/sdb2/2008-05-25/
-- 
BOFH excuse #47:

Complete Transient Lockout
