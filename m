From: Justin Brown <justin.brown@fandingo.org>
Subject: Fsck.ext4: Memory Allocation Failed
Date: Mon, 31 Mar 2014 15:49:29 -0500
Message-ID: <CAKZK7uwTp2cMoWLiWZSa5UfZ2dCxRaB7KLZ0PtVVSqimp=tLJA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:49719 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbaCaUta (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 31 Mar 2014 16:49:30 -0400
Received: by mail-ie0-f178.google.com with SMTP id lx4so8328183iec.9
        for <linux-ext4@vger.kernel.org>; Mon, 31 Mar 2014 13:49:30 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I'm trying to recover a corrupted Ext4 file system using a Fedora 20
live CD (Linux 3.11.10 and e2fsprogs 1.42.8). The system in question
is a 16 core Opteron with 8GiB of memory and has a matching 8GiB swap
device. The file system 224GiB, so it's nothing particularly large.

The problem is that memory use spirals out of control and ultimately
exhausts all 16GiB of memory. I'm unsure how to proceed with recovery.
Could someone provide some guidance?


File system information:
---------------------------------

dumpe2fs 1.42.8 (20-Jun-2013)
Filesystem volume name:   <none>
Last mounted on:          <not available>
Filesystem UUID:          e2fc7d51-0822-45cc-90f1-b013c713ddc5
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index
filetype extent flex_bg sparse_super large_file huge_file uninit_bg
dir_nlink extra_isize
Filesystem flags:         signed_directory_hash
Default mount options:    user_xattr acl
Filesystem state:         not clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              14712832
Block count:              58834944
Reserved block count:     2941747
Free blocks:              57863651
Free inodes:              14712821
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      1009
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
Flex block group size:    16
Filesystem created:       Tue Jul 16 07:57:23 2013
Last mount time:          n/a
Last write time:          Mon Mar 31 11:27:58 2014
Mount count:              0
Maximum mount count:      -1
Last checked:             Tue Jul 16 07:57:23 2013
Check interval:           0 (<none>)
Lifetime writes:          133 MB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:          256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      7d7657d1-e6ac-4e1d-a3ba-d68db97b278a
Journal backup:           inode blocks
Journal features:         journal_incompat_revoke
Journal size:             128M
Journal length:           32768
Journal sequence:         0x003782f5
Journal start:            0


Fsck Output:
-----------------

e2fsck -vy /dev/vg/root
e2fsck 1.42.8 (20-Jun-2013)
One or more block group descriptor checksums are invalid.  Fix? yes

Group descriptor 0 checksum is 0x0000, should be 0xf2d7.  FIXED.
Group descriptor 1 checksum is 0x0000, should be 0x8ffe.  FIXED.
Group descriptor 2 checksum is 0x0000, should be 0x79e8.  FIXED.
Group descriptor 3 checksum is 0x0000, should be 0xf920.  FIXED.
Group descriptor 4 checksum is 0x0000, should be 0x33be.  FIXED.
Group descriptor 5 checksum is 0x0000, should be 0x8c94.  FIXED.
Group descriptor 6 checksum is 0x0000, should be 0xeb90.  FIXED.
Group descriptor 7 checksum is 0x0000, should be 0x149c.  FIXED.
Group descriptor 8 checksum is 0x0000, should be 0x3600.  FIXED.
Group descriptor 9 checksum is 0x0000, should be 0x892a.  FIXED.
[ 132 additional group descriptor checksums fixed omitted. ]
Group descriptor 952 checksum is 0x0000, should be 0xad0b.  FIXED.
Group descriptor 953 checksum is 0x0000, should be 0x0dd0.  FIXED.
Group descriptor 954 checksum is 0x0000, should be 0xacbe.  FIXED.
Group descriptor 955 checksum is 0x0000, should be 0x0c65.  FIXED.
Group descriptor 956 checksum is 0x5e20, should be 0xae61.  FIXED.

/dev/vg/root contains a file system with errors, check forced.
Resize inode not valid.  Recreate? yes

Pass 1: Checking inodes, blocks, and sizes
Inode 14109880 has illegal block(s).  Clear? yes

Illegal block #0 (3925875673) in inode 14109880.  CLEARED.
Illegal block #2 (85326080) in inode 14109880.  CLEARED.
Illegal block #3 (2516589529) in inode 14109880.  CLEARED.
Illegal block #5 (3641317099) in inode 14109880.  CLEARED.
Illegal block #6 (394723355) in inode 14109880.  CLEARED.
Illegal block #7 (2986344453) in inode 14109880.  CLEARED.
Illegal block #8 (3640903191) in inode 14109880.  CLEARED.
Illegal block #9 (463536155) in inode 14109880.  CLEARED.
Illegal block #11 (1275199487) in inode 14109880.  CLEARED.
Illegal double indirect block (2181366192) in inode 14109880.  CLEARED.
Illegal block #563086348 (4294967295) in inode 14109880.  CLEARED.
Error storing directory block information (inode=14109880, block=0,
num=471166008): Memory allocation failed

/dev/vg/root: ***** FILE SYSTEM WAS MODIFIED *****
e2fsck: aborted

/dev/vg/root: ***** FILE SYSTEM WAS MODIFIED *****


I watched memory utilization while e2fsck was running, and it actually
does use all system memory. It's not some other error. There are no
kernel or system messages logged during this time, which means that
e2fsck itself is aborting and is not being terminated by the OOM.

I also created an image of this array, and used kpartx to run a fsck
on different hardware (same software versions), and I encountered the
same problem, including the block numbers.


Thanks,

Justin
