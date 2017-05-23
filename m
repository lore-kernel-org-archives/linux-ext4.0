From: Marc Thomas <marc@dragonfly.plus.com>
Subject: Re: e2fsck bug? - Sparse files corrupt after "e2fsck -E bmap2extent".
Date: Tue, 23 May 2017 18:41:48 +0100
Message-ID: <67373dc3-46e1-33e5-ea6f-940b82ad86b6@dragonfly.plus.com>
References: <a7a4fc1f-c1d9-bd69-cc2a-1a8094931e6d@dragonfly.plus.com>
 <20170523154152.glfcx7aryt5x4otj@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from avasout01.plus.net ([84.93.230.227]:53766 "EHLO
        avasout01.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752497AbdEWRta (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 23 May 2017 13:49:30 -0400
In-Reply-To: <20170523154152.glfcx7aryt5x4otj@thunk.org>
Content-Language: en-GB
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

Firstly, thank-you for taking the time to look into this.

I have modified your script with a "test-case" which fails for me every
time, as I noticed there is a file created by a Linux kernel build which
exhibits the problem (arch/x86/realmode/rm/realmode.bin) I think any
kernel version 3.10.x on x86_64 ought to work. I've also included a few
extra steps which I'm doing as part of the ext3 to ext4 conversion, and
added the "-b" (binary) flag to md5sum.

Here's the script. I'm not sure if it counts as a "simple" repro! :)


----- cut here -----
#!/bin/bash

rm -f /tmp/foo.img
mke2fs -t ext3 -Fq /tmp/foo.img 5G
mount -o loop /tmp/foo.img /mnt
dd if=/etc/motd of=/mnt/test bs=4k >& /dev/null
dd if=/etc/motd of=/mnt/test conv=notrunc seek=32 bs=4k >& /dev/null
dd if=/etc/motd of=/mnt/test2 bs=4k >& /dev/null
dd if=/etc/motd of=/mnt/test2 conv=notrunc seek=1024 bs=4k >& /dev/null
md5sum -b /mnt/test* > /mnt/MD5SUMS
lsattr /mnt/test*
( cd /mnt
xz -dc ~marc/LinuxStuff/Linux4.x/linux-4.11.1.tar.xz | tar xvf -
cd linux-4.11.1
make defconfig
time make -j 15 ) > /dev/null 2>&1
md5sum -b /mnt/linux-4.11.1/arch/x86/realmode/rm/realmode.bin >>
/mnt/MD5SUMS
lsattr /mnt/linux-4.11.1/arch/x86/realmode/rm/realmode.bin
umount /mnt
tune2fs -O extents,uninit_bg,dir_index /tmp/foo.img
e2fsck -fy /tmp/foo.img
e2fsck -fy -E bmap2extent /tmp/foo.img
mount -o loop /tmp/foo.img /mnt
md5sum -c /mnt/MD5SUMS
lsattr /mnt/test*
lsattr /mnt/linux-4.11.1/arch/x86/realmode/rm/realmode.bin
umount /mnt
----- cut here -----


The output of the script is:

time ./marc2.sh
------------------- /mnt/test
------------------- /mnt/test2
------------------- /mnt/linux-4.11.1/arch/x86/realmode/rm/realmode.bin
tune2fs 1.43.4 (31-Jan-2017)
e2fsck 1.43.4 (31-Jan-2017)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/tmp/foo.img: 71184/327680 files (6.4% non-contiguous), 338237/1310720
blocks
e2fsck 1.43.4 (31-Jan-2017)
Pass 1: Checking inodes, blocks, and sizes
Pass 1E: Optimizing extent trees
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information

/tmp/foo.img: ***** FILE SYSTEM WAS MODIFIED *****
/tmp/foo.img: 71184/327680 files (6.4% non-contiguous), 334994/1310720
blocks
/mnt/test: OK
/mnt/test2: OK
/mnt/linux-4.11.1/arch/x86/realmode/rm/realmode.bin: FAILED
md5sum: WARNING: 1 computed checksum did NOT match
--------------e---- /mnt/test
--------------e---- /mnt/test2
--------------e---- /mnt/linux-4.11.1/arch/x86/realmode/rm/realmode.bin

real    1m46.829s
user    17m41.611s
sys     1m39.268s

Thanks & Kind Regards,
Marc
