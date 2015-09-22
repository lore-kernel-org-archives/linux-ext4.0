From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: resize2fs stuck in ext4_group_extend with 100% CPU Utilization
 With Small Volumes
Date: Tue, 22 Sep 2015 16:20:58 -0400
Message-ID: <20150922202058.GB3318@thunk.org>
References: <06724CF51D6BC94E9BEE7A8A8CB82A6740FE22BCBA@MX01A.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Pocas, Jamie" <Jamie.Pocas@emc.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37297 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759655AbbIVUVB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Sep 2015 16:21:01 -0400
Content-Disposition: inline
In-Reply-To: <06724CF51D6BC94E9BEE7A8A8CB82A6740FE22BCBA@MX01A.corp.emc.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 22, 2015 at 03:12:53PM -0400, Pocas, Jamie wrote:
> 
> I have a very reproducible spin in resize2fs (x86_64) on both CentOS
> 6 latest rpms and CentOS 7. It will peg one core at 100%. This
> happens with both e2fsprogs version 1.41.12 on CentOS 6 w/ latest
> 2.6.32 kernel rpm installed and e2fsprogs version 1.42.9 on CentOS 7
> with latest 3.10 kernel rpm installed. The key to reproducing this
> seems to be when creating small filesystems. For example if I create
> an ext4 filesystem on a 100MiB disk (or file), and then increase the
> size of the underlying disk (or file) to say 1GiB, it will spin and
> consume 100% CPU and not finish even after hours (it should take a
> few seconds).

I can't reproduce the problem using a 3.10.88 kernel using e2fsprogs
1.42.12-1.1 as shipped with Debian x86_64 jessie 8.2 release image.
(As found on Google Compute Engine, but it should be the same no
matter what you're using.)

I've attached the repro script I'm using.

The kernel config I'm using is here:

https://git.kernel.org/cgit/fs/ext2/xfstests-bld.git/tree/kernel-configs/ext4-x86_64-config-3.10


I also tried reproducing it on CentOS 6.7 as shipped by Google Compute
Engine:

[root@centos-test tytso]# cat /etc/centos-release
CentOS release 6.7 (Final)
[root@centos-test tytso]# uname -a
Linux centos-test 2.6.32-573.3.1.el6.x86_64 #1 SMP Thu Aug 13 22:55:16 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
[root@centos-test tytso]# rpm -q e2fsprogs
e2fsprogs-1.41.12-22.el6.x86_64

And I can't reproduce it there either.

Can you take a look at my repro script and see if it fails for you?
And if it doesn't, can you adjust it until it does reproduce for you?

Thanks,

						- Ted

#!/bin/bash

FS=/tmp/foo.img

cp /dev/null $FS
mke2fs -t ext4 -O uninit_bg -E nodiscard,lazy_itable_init=1 -Fq $FS 100M
truncate -s 1G $FS 

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
    

