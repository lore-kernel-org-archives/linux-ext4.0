From: Yan Rui <rui.yan@gmail.com>
Subject: delayed block allocation failed with error -28
Date: Tue, 11 Mar 2014 00:09:47 +0800
Message-ID: <CAPoEN5nYGBG6VNYuN2bROjvF41=so56uSTwB-=PAyAczD99jeQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Yan Rui <rui.yan@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:34855 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411AbaCJQJs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Mar 2014 12:09:48 -0400
Received: by mail-pa0-f51.google.com with SMTP id kq14so7418493pab.24
        for <linux-ext4@vger.kernel.org>; Mon, 10 Mar 2014 09:09:47 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

/var/log/message says below and no hardware related issues found.

Mar 10 16:20:56 d02 auditd[4056]: Audit daemon rotating log files
Mar 10 16:25:13 d02 kernel: EXT4-fs (sda): delayed block allocation
failed for inode 47579238 at logical offset 395 with max blocks 1654
with error -28
Mar 10 16:25:13 d02 kernel:
Mar 10 16:25:13 d02 kernel: This should not happen!!  Data will be lost
Mar 10 16:25:13 d02 kernel: Total free blocks count 0
Mar 10 16:25:13 d02 kernel: Free/Dirty block details
Mar 10 16:25:13 d02 kernel: free_blocks=0
Mar 10 16:25:13 d02 kernel: dirty_blocks=-4294772779
Mar 10 16:25:13 d02 kernel: Block reservation details
Mar 10 16:25:13 d02 kernel: i_reserved_data_blocks=1654
Mar 10 16:25:13 d02 kernel: i_reserved_meta_blocks=7
Mar 10 16:25:13 d02 kernel: EXT4-fs (sda): delayed block allocation
failed for inode 58851678 at logical offset 0 with max blocks 2048
with error -28
Mar 10 16:25:13 d02 kernel:
Mar 10 16:25:13 d02 kernel: This should not happen!!  Data will be lost
Mar 10 16:25:13 d02 kernel: Total free blocks count 0
Mar 10 16:25:13 d02 kernel: Free/Dirty block details
Mar 10 16:25:13 d02 kernel: free_blocks=0
Mar 10 16:25:13 d02 kernel: dirty_blocks=-4294772779
Mar 10 16:25:13 d02 kernel: Block reservation details
Mar 10 16:25:13 d02 kernel: i_reserved_data_blocks=2049
Mar 10 16:25:13 d02 kernel: i_reserved_meta_blocks=7

[root@d02 ~]# uname -a
Linux d02 2.6.32-358.11.1.el6.x86_64 #1 SMP Wed Jun 12 03:34:52 UTC
2013 x86_64 x86_64 x86_64 GNU/Linux

[root@d02 ~]# tune2fs -l /dev/sda
tune2fs 1.41.12 (17-May-2010)
Filesystem volume name:   <none>
Last mounted on:          /data/5aacbdff-697f-4b70-9b55-f912d41f57da
Filesystem UUID:          5aacbdff-697f-4b70-9b55-f912d41f57da
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index
filetype needs_recovery extent flex_bg sparse_super large_file
huge_file uninit_bg dir_nlink extra_isize
Filesystem flags:         signed_directory_hash
Default mount options:    (none)
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              183148544
Block count:              732566646
Reserved block count:     0
Free blocks:              41810477
Free inodes:              182809495
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      849
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
Flex block group size:    16
Filesystem created:       Fri Jul  5 10:11:15 2013
Last mount time:          Mon Jan 27 06:09:43 2014
Last write time:          Mon Jan 27 06:09:43 2014
Mount count:              18
Maximum mount count:      20
Last checked:             Fri Jul  5 10:11:15 2013
Check interval:           15552000 (6 months)
Next check after:         Wed Jan  1 10:11:15 2014
Lifetime writes:          6275 GB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      e0d65199-15d8-4c39-aeeb-1d6cf3c6aebf
Journal backup:           inode blocks

The number of dirty_blocks looks weird,  is it a known bug?

Regards,
Rui
