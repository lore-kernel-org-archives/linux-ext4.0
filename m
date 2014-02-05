From: Eric Whitney <enwlinux@gmail.com>
Subject: 3.14-rc1 regression - xfstests failures on bigalloc
Date: Wed, 5 Feb 2014 13:47:11 -0500
Message-ID: <20140205184705.GA2157@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qa0-f52.google.com ([209.85.216.52]:64420 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbaBESr0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Feb 2014 13:47:26 -0500
Received: by mail-qa0-f52.google.com with SMTP id j15so1169181qaq.39
        for <linux-ext4@vger.kernel.org>; Wed, 05 Feb 2014 10:47:25 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I'm seeing a number of xfstests failures while running on a test file system
created with the bigalloc feature (xfstest-bld's bigalloc scenario).  This
is a regression since 3.13 final.

For example, generic/013 fails at high frequency (>80% of trials) when
e2fsck discovers file system damage after the core fsstress workload
completes:

_check_generic filesystem: filesystem on /dev/vdd is inconsistent
*** fsck.ext4 output ***
fsck 1.43-WIP (28-Dec-2013)
e2fsck 1.43-WIP (28-Dec-2013)
Pass 1: Checking inodes, blocks, and sizes
Inode 318, i_blocks is 896, should be 1024.  Fix? no

Inode 852, i_blocks is 1024, should be 1152.  Fix? no


Running additional passes to resolve blocks claimed by more than one inode...
Pass 1B: Rescanning for multiply-claimed blocks
Multiply-claimed block(s) in inode 828: 610640 610641 610642 610643 610644 610645 610646 610647 610648 610649 610650 610651 610652 610653 610654 610655
Multiply-claimed block(s) in inode 852: 610650 610651 610652 610653 610654 610655
Pass 1C: Scanning directories for inodes with multiply-claimed blocks
Pass 1D: Reconciling multiply-claimed blocks
(There are 2 inodes containing multiply-claimed blocks.)

File /fsstress.3033.2/p5/d3XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/d19XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/d55X/f50XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX (inode #828, mod time Wed Feb  5 13:10:07 2014) 
  has 1 multiply-claimed block(s), shared with 1 file(s):
	/fsstress.3033.2/p0/d2X/f2b (inode #852, mod time Wed Feb  5 13:10:07 2014)
Clone multiply-claimed blocks? no

Delete file? no

File /fsstress.3033.2/p0/d2X/f2b (inode #852, mod time Wed Feb  5 13:10:07 2014) 
  has 1 multiply-claimed block(s), shared with 1 file(s):
	/fsstress.3033.2/p5/d3XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/d19XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/d55X/f50XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX (inode #828, mod time Wed Feb  5 13:10:07 2014)
Clone multiply-claimed blocks? no

Delete file? no

Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Block bitmap differences:  +574112 +643936
Fix? no


/dev/vdd: ********** WARNING: Filesystem still has errors **********

/dev/vdd: 3880/86400 files (13.0% non-contiguous), 176096/1382400 blocks
*** end fsck.ext4 output
*** mount output ***
/dev/vda1 on / type ext4 (rw,errors=remount-ro)
proc on /proc type proc (rw,noexec,nosuid,nodev)
sysfs on /sys type sysfs (rw,noexec,nosuid,nodev)
none on /sys/fs/cgroup type tmpfs (rw)
none on /sys/fs/fuse/connections type fusectl (rw)
none on /sys/kernel/debug type debugfs (rw)
none on /sys/kernel/security type securityfs (rw)
udev on /dev type devtmpfs (rw,mode=0755)
devpts on /dev/pts type devpts (rw,noexec,nosuid,gid=5,mode=0620)
tmpfs on /run type tmpfs (rw,noexec,nosuid,size=10%,mode=0755)
none on /run/lock type tmpfs (rw,noexec,nosuid,nodev,size=5242880)
none on /run/shm type tmpfs (rw,nosuid,nodev)
none on /run/user type tmpfs (rw,noexec,nosuid,nodev,size=104857600,mode=0755)
none on /sys/fs/pstore type pstore (rw)
systemd on /sys/fs/cgroup/systemd type cgroup (rw,noexec,nosuid,nodev,none,name=systemd)
/dev/vdc on /vdc type ext4 (rw,acl,user_xattr,block_validity)


I've also seen generic/068 and generic/075 fail, but have not tried to go
further into the test sequence.

Reverting 9cb00419fa (ext4: enable punch hole for bigalloc) on 3.14-rc1
eliminates the regressions.  It's clear this patch isn't the root cause, but
presumably it's exposing some code paths we haven't been exercising.

Separately (I think), I'm seeing the following in dmesg during bigalloc runs
from time to time.  Although this sometimes appears when generic/013 is run,
it generally doesn't, and sometimes appears when tests do not fail:

EXT4-fs error (device vdd): mb_free_blocks:1433: group 1, block 573360:freeing already freed block (bit 3067); block bitmap corrupt.
EXT4-fs error (device vdd): ext4_mb_generate_buddy:756: group 1, 28570 clusters in bitmap, 28571 in gd; block bitmap corrupt.

This is new in 3.14-rc1, and does not disappear when reverting 9cb00419fa.  I
haven't had a chance to bisect that yet;  I'm currently working on some
other bug fixes.

Thanks,
Eric
