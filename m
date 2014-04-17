From: Devrin Talen <dct23@cornell.edu>
Subject: ext4 filesystem corruption across partitions
Date: Thu, 17 Apr 2014 11:05:23 -0400
Message-ID: <1397747123.6833.24.camel@luigi>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fallback-out2.mxes.net ([216.86.168.191]:36069 "EHLO
	fallback-in2.mxes.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751786AbaDQPQS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Apr 2014 11:16:18 -0400
Received: from mxout-07.mxes.net (mxout-07.mxes.net [216.86.168.182])
	by fallback-in1.mxes.net (Postfix) with ESMTP id 8FCFE2FD7A8
	for <linux-ext4@vger.kernel.org>; Thu, 17 Apr 2014 11:06:25 -0400 (EDT)
Received: from [192.168.0.100] (unknown [174.47.212.34])
	(using SSLv3 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by smtp.mxes.net (Postfix) with ESMTPSA id EFDB022E259
	for <linux-ext4@vger.kernel.org>; Thu, 17 Apr 2014 11:05:23 -0400 (EDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

I'm debugging an issue on my platform.  In short, I can corrupt an ext4
filesystem on one partition by writing a file on a different one.  I'm
suspecting something is off either with my partition table or filesystem
parameters, but I'm such an ext4 beginner that I thought I'd start here
to get some help in where to look.

If I run this (which writes a relatively large file to partition 12):

    dd if=/dev/zero of=/cache/goingtodie bs=4096 count=120000

Then (after rebooting) I'll get an ext4 error like this on partition 13:

        EXT4-fs error (device mmcblk0p13): ext4_readdir:214: inode
        #102545: block 426479: comm er.ServerThread:
        path /data/app-private: bad entry in directory: rec_len is
        smaller than minimal - offset=0(0), inode=0, rec_len=0, na0
        
My android system runs a slightly modified 3.0.31 kernel with 4GB eMMC
as the block device.  My partition table is set up as such (located in
the first 34 blocks):

lba size = 512
lba_start      partition_size          name
=========  ======================  ==============
       34         97280(     95K)  environment
      224         16384(     16K)  crypto
      256        393216(    384K)  xloader
     1024        524288(    512K)  bootloader
     2048        524288(    512K)  device_info
     3072        524288(    512K)  bootloader2
     4096        524288(    512K)  misc
     5120       8388608(      8M)  recovery
    21504       8388608(      8M)  boot
    37888      16777216(     16M)  efs
    70656    1073741824(   1024M)  system
  2167808     536870912(    512M)  cache
  3216384    2195193856(   2093M)  userdata
=========  ======================  ==============

The two filesystems in question are the cache and userdata partitions.
These are created with the following make_ext4fs[1] commands and then
flashed to eMMC:

% make_ext4fs -s -L cache -l 536870912 cache.img cache
Creating filesystem with parameters:
    Size: 536870912
    Block size: 4096
    Blocks per group: 32768
    Inodes per group: 8192
    Inode size: 256
    Journal blocks: 2048
    Label: cache
    Blocks: 131072
    Block groups: 4
    Reserved block group size: 31
Created filesystem with 11/32768 inodes and 4206/131072 blocks

% make_ext4fs -s -l 2143744K -a data userdata.img data/
Creating filesystem with parameters:
    Size: 2195193856
    Block size: 4096
    Blocks per group: 32768
    Inodes per group: 7888
    Inode size: 256
    Journal blocks: 8374
    Label:
    Blocks: 535936
    Block groups: 17
    Reserved block group size: 135
Created filesystem with 11/134096 inodes and 17614/535936 blocks

Any help is very much appreciated.  Does anyone see anything amiss, or
that I should try looking into?  If there's any more information that's
needed just let me know.  Or if you think there's a better mailing list
for me to take this to, I can do that too.

[1]:
https://android.googlesource.com/platform/system/extras/+/fb109b894a5fc2891e49ec8e81c0dda171b45b7f/ext4_utils/make_ext4fs_main.c

-- 
Devrin Talen <dct23@cornell.edu>

