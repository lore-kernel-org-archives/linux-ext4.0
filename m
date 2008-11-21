From: <Solofo.Ramangalahy@bull.net>
Subject: [RFC 0/2] ext4: zero uninitialized inode tables
Date: Fri, 21 Nov 2008 11:23:09 +0100
Message-ID: <20081121102309.182113793@bull.net>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:57577 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373AbYKUKjT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Nov 2008 05:39:19 -0500
Received: from localhost (localhost [127.0.0.1])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 6A98E1A1C30
	for <linux-ext4@vger.kernel.org>; Fri, 21 Nov 2008 11:39:18 +0100 (CET)
Received: from ecfrec.frec.bull.fr ([127.0.0.1])
 by localhost (ecfrec.frec.bull.fr [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 05275-09 for <linux-ext4@vger.kernel.org>;
 Fri, 21 Nov 2008 11:39:14 +0100 (CET)
Received: from cyclope.frec.bull.fr (cyclope.frec.bull.fr [129.183.4.9])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id D57901A1C23
	for <linux-ext4@vger.kernel.org>; Fri, 21 Nov 2008 11:39:14 +0100 (CET)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The time to format a filesystem is mostly linear with filesystem size.

Exact time spent on formating depends on hardware and software, but
this is mainly explained by the zeroing of some blocks (inode, block
bitmaps and inodes tables).
While the mkfs time can be considered negligible (for example compared
to RAID formatting of disk arrays), it is significant compared
to the formating time of others filesystems.
This is noticeable when conducting performance comparison tests, or
testing involving multiple formatting of the same device.
This may become prohibitive for large disks (arrays).

For some measurements, see:
http://www.bullopensource.org/ext4/20080909-mkfs-speed-lazy_itable_init/
http://www.bullopensource.org/ext4/20080911-mkfs-speed-lazy_itable_init/
http://www.bullopensource.org/ext4/20080912-mkfs-speed-lazy_itable_init/
so far it is under one hour, further measurements would be needed,
like for 16TB filesystems.

It is possible to skip the initialization of the inode tables blocks
with the mkfs option "lazy_itable_init" (mkfs.ext4(8)).
However, this option is not safe with respect to fsck, as there is no
way to distinguish between an unitialized block filled with old bits
and a corrupted one.
(The use of lazy_itable_init could be considered safe in the case where
the blocks of the disk, in particular those used by the inode tables,
are prefilled with zeros.)

These patches (try to) initialize the inode tables after mount via a
kernel thread launched by module loading. The goal is to find a
tradeoff between speed and safety.

Apart from use in testing, another use case could be a distribution
installation: since device size rises faster than system size, the
percentage of the formating time during the installation will
increase. Since the system will use a fragment of the full device (say
10GB for system installation on a 1TB disk), it would not be strictly
necessary to initialize all the inode tables before starting the
installation, for example for the home partition.

So far, I've only been able to initialize some small filesystems with
this code (using 2.6.28-rc4).
For example, like this:

. dd if=/dev/zero of=/tmp/ext4fs.img bs=1M count=1024
. losetup /dev/loop0 /tmp/ext4fs.img
. mkfs.ext4 -O^resize_inode -Elazy_itable_init /dev/loop0
. mount /dev/loop0 /mnt/test-ext4
. [dumpe2fs /dev/loop0]
. modprobe ext4_itable_init
. [dumpe2fs /dev/loop0  # here check the ITABLE_ZEROED]
. umount /mnt/test-ext4
. [dumpe2fs /dev/loop0]
. [fsck /dev/loop0]

But I also hitted several bugs and managed to somehow screw up my
machine. So be _extremly_ careful if ever you try the code!

TODO:
. fix the resize inode case
. fix the observed soft lockup
. decide whether to keep it a module.
  If not, decide how/when run the kernel thread
. initialize some blocks (for example the non-empty ones) at mount
  time, or somewhere else.
. non-empty group case
. feature interactions? (for example inode zeroing vs. resize)
. multiple threads (based on cpu/disks)
. other ?

