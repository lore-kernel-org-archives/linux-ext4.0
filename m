From: "Pocas, Jamie" <Jamie.Pocas@emc.com>
Subject: RE: resize2fs stuck in ext4_group_extend with 100% CPU Utilization
 With Small Volumes
Date: Tue, 22 Sep 2015 17:26:57 -0400
Message-ID: <06724CF51D6BC94E9BEE7A8A8CB82A6740FE22BCDF@MX01A.corp.emc.com>
References: <06724CF51D6BC94E9BEE7A8A8CB82A6740FE22BCBA@MX01A.corp.emc.com>
 <20150922202058.GB3318@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailuogwdur.emc.com ([128.221.224.79]:50068 "EHLO
	mailuogwdur.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934741AbbIVV1N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Sep 2015 17:27:13 -0400
In-Reply-To: <20150922202058.GB3318@thunk.org>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Theodore,

I am not sure if you had a chance to see my reply to Eric yet. I can see you are using the same general approach that Eric was using. The key difference from what I am doing again seems to be that I am resizing the underlying disk *while the filesystem is mounted*. Instead you both are using truncate to grow the disk while the filesystem is not currently mounted, and then mounting it. So maybe there is some fundamental cleanup or fixup that happens during the subsequent mount that doesn't happen if you grow the disk while the filesystem is already online. With the test example, you can do this using 'losetup -c' to force reread the size of the underlying file. I can understand why a disk should not shrink while the filesystem is mounted, but in my case I am growing it so the existing FS st
 ructure should be unharmed.

Your script works -- caveat I had to fix some line wrap issues probably due to my email client, but it was pretty clear what your intention was.
Here's my modification to your script that reproduces the issue.

#!/bin/bash

FS=/tmp/foo.img

cp /dev/null $FS
mke2fs -t ext4 -O uninit_bg -E nodiscard,lazy_itable_init=1 -Fq $FS 100M

DEV=$(losetup -j $FS | awk -F: '{print $1}')
if test -z "$DEV"
then
    losetup -f $FS
    DEV=$(losetup -j $FS | awk -F: '{print $1}')
fi

if test -z "$DEV"
then
    echo "Can't create loop device for $FS"
else
    echo "Using loop device $DEV"
    CLEANUP_LOOP=yes
fi

#e2fsck -p $DEV # Not sure if this needs to be commented out. I will have to reboot to find out though.
mkdir /tmp/mnt$$
mount $DEV /tmp/mnt$$
# Grow the backing file *AFTER* we are mounted
truncate -s 1G $FS
# Tell loopback device to rescan the size
losetup -c $DEV
resize2fs -p $DEV 1G
umount /tmp/mnt$$
e2fsck -fy $DEV

if test "$CLEANUP_LOOP" = "yes"
then
    losetup -d $DEV
fi
rmdir /tmp/mnt$$

## END OF SCRIPT

Execution looks like this

$ sudo ./repro.sh 
[sudo] password for jpocas: 
Using loop device /dev/loop0
resize2fs 1.42.9 (28-Dec-2013)
Filesystem at /dev/loop0 is mounted on /tmp/mnt5715; on-line resizing required
old_desc_blocks = 1, new_desc_blocks = 8
## SPINNING 100% CPU!

-----Original Message-----
From: Theodore Ts'o [mailto:tytso@mit.edu] 
Sent: Tuesday, September 22, 2015 4:21 PM
To: Pocas, Jamie
Cc: linux-ext4@vger.kernel.org
Subject: Re: resize2fs stuck in ext4_group_extend with 100% CPU Utilization With Small Volumes

On Tue, Sep 22, 2015 at 03:12:53PM -0400, Pocas, Jamie wrote:
> 
> I have a very reproducible spin in resize2fs (x86_64) on both CentOS
> 6 latest rpms and CentOS 7. It will peg one core at 100%. This happens 
> with both e2fsprogs version 1.41.12 on CentOS 6 w/ latest
> 2.6.32 kernel rpm installed and e2fsprogs version 1.42.9 on CentOS 7 
> with latest 3.10 kernel rpm installed. The key to reproducing this 
> seems to be when creating small filesystems. For example if I create 
> an ext4 filesystem on a 100MiB disk (or file), and then increase the 
> size of the underlying disk (or file) to say 1GiB, it will spin and 
> consume 100% CPU and not finish even after hours (it should take a few 
> seconds).

I can't reproduce the problem using a 3.10.88 kernel using e2fsprogs
1.42.12-1.1 as shipped with Debian x86_64 jessie 8.2 release image.
(As found on Google Compute Engine, but it should be the same no matter what you're using.)

I've attached the repro script I'm using.

The kernel config I'm using is here:

https://git.kernel.org/cgit/fs/ext2/xfstests-bld.git/tree/kernel-configs/ext4-x86_64-config-3.10


I also tried reproducing it on CentOS 6.7 as shipped by Google Compute
Engine:

[root@centos-test tytso]# cat /etc/centos-release CentOS release 6.7 (Final) [root@centos-test tytso]# uname -a Linux centos-test 2.6.32-573.3.1.el6.x86_64 #1 SMP Thu Aug 13 22:55:16 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux [root@centos-test tytso]# rpm -q e2fsprogs
e2fsprogs-1.41.12-22.el6.x86_64

And I can't reproduce it there either.

Can you take a look at my repro script and see if it fails for you?
And if it doesn't, can you adjust it until it does reproduce for you?

Thanks,

						- Ted

#!/bin/bash

FS=/tmp/foo.img

cp /dev/null $FS
mke2fs -t ext4 -O uninit_bg -E nodiscard,lazy_itable_init=1 -Fq $FS 100M truncate -s 1G $FS 

DEV=$(losetup -j $FS | awk -F: '{print $1}') if test -z "$DEV"
then
    losetup -f $FS
    DEV=$(losetup -j $FS | awk -F: '{print $1}') fi if test -z "$DEV"
then
    echo "Can't create loop device for $FS"
else
    echo "Using loop device $DEV"
    CLEANUP_LOOP=yes
fi

e2fsck -p $DEV
mkdir /tmp/mnt$$
mount $DEV /tmp/mnt$$
resize2fs -p $DEV 1G
umount /tmp/mnt$$
e2fsck -fy $DEV

if test "$CLEANUP_LOOP" = "yes"
then
    losetup -d $DEV
fi
rmdir /tmp/mnt$$
    

