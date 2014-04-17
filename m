From: Contact <neitsab@ovh.fr>
Subject: Make huge files strictly contiguous (fallocate, bigalloc, e4defrag...)
Date: Thu, 17 Apr 2014 04:18:30 +0200
Message-ID: <534F39F6.2000208@ovh.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mo29.mail-out.ovh.net ([178.32.228.29]:34689 "EHLO
	mo29.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbaDQCZZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Apr 2014 22:25:25 -0400
Received: from he23.mail.ovh.net (he23.mail.ovh.net [5.135.56.55])
	by mo29.mail-out.ovh.net (Postfix) with ESMTP id 53FF2FF807B
	for <linux-ext4@vger.kernel.org>; Thu, 17 Apr 2014 04:18:31 +0200 (CEST)
Received: from [192.168.1.73] (unknown [109.190.83.66])
	by he23.mail.ovh.net (Postfix) with ESMTPSA id 3721F7F35
	for <linux-ext4@vger.kernel.org>; Thu, 17 Apr 2014 04:18:31 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi everybody,

I'm trying to create a multiboot medium using Easy2Boot on a 64 GB USB
key. Easy2Boot [1] is a "software" (well a collection of files really)
that relies on grub4dos [2] to work and thus requires payload files to
be strictly contiguous to do its trick. It's supposed to be set up once
and then one just has to add files to boot from to a folder to modify
the multiboot setup.

The ISO files I have are between 230 MB and 2 GB each. I divided my USB
drive into two partitions : first one, 16 GB ntfs formatted so that
grub4dos actually works (for some reasons it doesn't with ext4, plus I
want to be able to use it with other OS); second one 48 GB formatted as
ext4 with e2fsprogs version 1.42.9 from Archlinux. However when I try
to boot from those files I systematically get the "file not contiguous"
error in Easy2Boot.

Question is: is it possible to make huge files strictly contiguous on
ex4, and if yes how?


*******
Details
*******

I tried different mkfs.ext4 options so as to cater to my use case, but
to no avail. I tried pushing the inode_ratio to its maximum value (64
MB) and using fallocate besides regular copy:
# mkfs.ext4 -m 0 -L iso -i 67108864 -E root_owner=1000:100 /dev/sdc2
# fallocate -l 1235451904
/path/to/mounted/usb/folder/debian-live-7.2-amd64-gnome-desktop_fal.iso
# cp debian-live-7.2-amd64-gnome-desktop.iso
/path/to/folder/debian-live-7.2-amd64-gnome-desktop_fal.iso

But files aren't contiguous. e4defrag seems to confirm it:
# e4defrag -c '/run/media/neitsab/iso/_ISO'
<Fragmented files>                             now/best       size/ext
1. /run/media/neitsab/iso/_ISO/manjaro-gnome-0.8.9-x86_64.iso
                                                13/1         119378 KB
2. /run/media/neitsab/iso/_ISO/manjaro-gnome-0.8.9-x86_64_fal.iso
                                                13/1         119378 KB

Total/best extents                26/2
Average size per extent            119378 KB
Fragmentation score                0
[0-30 no problem: 31-55 a little bit fragmented: 56- needs defrag]
This directory (/run/media/neitsab/iso/_ISO) does not need defragmentation.
Done.

Then I tried to use bigalloc and clusters:
# mkfs.ext4 -m 0 -L iso -i 67108864 -O bigalloc -C 256M -E
root_owner=1000:100 /dev/sdc2
mke2fs 1.42.9 (28-Dec-2013)

Warning: the bigalloc feature is still under development
See https://ext4.wiki.kernel.org/index.php/Bigalloc for more information

warning: 53248 blocks unused.

Filesystem label=iso
OS type: Linux
Block size=4096 (log=2)
Cluster size=268435456 (log=18)
Stride=0 blocks, Stripe width=0 blocks
720 inodes, 11665408 blocks
0 blocks (0.00%) reserved for the super user
First data block=0
Root directory owner=1000:100
1 block group
2146959360 blocks per group, 32760 clusters per group
720 inodes per group

Allocating group tables: done
Writing inode tables: done
Creating journal (32768 blocks): done
Writing superblocks and filesystem accounting information: done

It took it some lengthy time to allocate the group tables, then regular
copy worked but fallocate hanged (process uninterruptible) and I had to
reboot the machine, which led me to a kernel panic mentionning
fallocate. The file copied via Nautilus still wasn't contiguous enough
for Easy2Boot.

So what's left? Is it at all possible to make completely contiguous
files on ext4? Not even on a fresh FS with plenty of free space?

Thanks for your comments!


[1] http://www.easy2boot.com/introduction/
[2] https://code.google.com/p/grub4dos-chenall/
