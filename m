From: Mark Ballard <markjballard@googlemail.com>
Subject: Corrupted superblock? But disk still mounts.
Date: Mon, 18 Aug 2014 19:14:19 +0100
Message-ID: <CAMJSjjuRj5-VNs0TeoMEvrozyeJVQH+BUxsBaqO07WH9eKD88w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vc0-f172.google.com ([209.85.220.172]:42476 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbaHRSOU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Aug 2014 14:14:20 -0400
Received: by mail-vc0-f172.google.com with SMTP id im17so6260462vcb.3
        for <linux-ext4@vger.kernel.org>; Mon, 18 Aug 2014 11:14:19 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

=46ound bad superblock when trying to rename partition using e2label.

The same problem has prevented me using dumpe2fs, e2fsck and fsck to
try and resolve the problem.

But I can still mount the disk and use it.

The disk is encrypted. It is not the boot disk. The OS - Xubuntu - has
gone helicopter a few times, spiraling out with disk crunching that
locks up the machine for so long that I have been faced with no choice
but to switch it off at the wall. That is not likely to do with this
hick disk being discussed here, but it does mean the hick disk has
been knocked out a few times.

---------------------------------------------

Here's what happens when I attempt to rename:

# e2label /dev/sdb1
e2label: Bad magic number in super-block while trying to open /dev/sdb1
Couldn't find valid filesystem superblock.

Two other partitions on the same disk accepted the rename command.
fdisk -l gives output consistent with normal conditions. The disk is
not using LVM.

---------------------------------------------

Here's what happens when I try and run the disk utilities:

# dumpe2fs /dev/sdb1 | grep =E2=80=93i superblock
grep: superblock: No such file or directory
dumpe2fs 1.42.9 (4-Feb-2014)
dumpe2fs: Bad magic number in super-block while trying to open /dev/sdb=
1

# e2fsck /dev/sdb1
e2fsck 1.42.9 (4-Feb-2014)
ext2fs_open2: Bad magic number in super-block
e2fsck: Superblock invalid, trying backup blocks...
e2fsck: Bad magic number in super-block while trying to open /dev/sdb1

The superblock could not be read or does not describe a valid ext2/ext3=
/ext4
filesystem.  If the device is valid and it really contains an ext2/ext3=
/ext4
filesystem (and not swap or ufs or something else), then the superblock
is corrupt, and you might try running e2fsck with an alternate superblo=
ck:
    e2fsck -b 8193 <device>
 or
    e2fsck -b 32768 <device>

# blockdev --getbsz /dev/sdb1
4096

# e2fsck -b 32768 /dev/sdb1
e2fsck 1.42.9 (4-Feb-2014)
e2fsck: Bad magic number in super-block while trying to open /dev/sdb1

The superblock could not be read or does not describe a valid ext2/ext3=
/ext4
filesystem.  If the device is valid and it really contains an ext2/ext3=
/ext4
filesystem (and not swap or ufs or something else), then the superblock
is corrupt, and you might try running e2fsck with an alternate superblo=
ck:
    e2fsck -b 8193 <device>
 or
    e2fsck -b 32768 <device>

# fsck.ext4 -v /dev/sdb1
e2fsck 1.42.9 (4-Feb-2014)
ext2fs_open2: Bad magic number in super-block
fsck.ext4: Superblock invalid, trying backup blocks...
fsck.ext4: Bad magic number in super-block while trying to open /dev/sd=
b1

The superblock could not be read or does not describe a valid ext2/ext3=
/ext4
filesystem.  If the device is valid and it really contains an ext2/ext3=
/ext4
filesystem (and not swap or ufs or something else), then the superblock
is corrupt, and you might try running e2fsck with an alternate superblo=
ck:
    e2fsck -b 8193 <device>
 or
    e2fsck -b 32768 <device>

------------------------------

mke2fs -n listed 14 backup superblocks, running each of through e2fsck
produced the same error bar one:

e2fsck 1.42.9 (4-Feb-2014)
e2fsck: Bad magic number in super-block while trying to open /dev/sdb1

The superblock could not be read or does not describe a valid ext2/ext3=
/ext4
filesystem.  If the device is valid and it really contains an ext2/ext3=
/ext4
filesystem (and not swap or ufs or something else), then the superblock
is corrupt, and you might try running e2fsck with an alternate superblo=
ck:
    e2fsck -b 8193 <device>
 or
    e2fsck -b 32768 <device>

One of the backups gave this with e2fsck:

e2fsck 1.42.9 (4-Feb-2014)
e2fsck: Attempt to read block from filesystem resulted in short read
while trying to open /dev/sdb1
Could this be a zero-length partition?

----------------------------

Mark Ballard
=46reelance journalist
twitter.com/markjballard
Best tel: +44(0)1474 566 118
Mob  tel: +44(0)79 827 00815
markjballard@googlemail.com
-----------------------------------------------------------------------=
----
-----------------------------------------------------------------------=
----
Public Sector IT Blog:
http://www.computerweekly.com/blogs/public-sector/
-----------------------------------------------------------------------=
----
RSS updates:
http://www.computerweekly.com/blogs/public-sector/atom.xml
-----------------------------------------------------------------------=
-----
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
