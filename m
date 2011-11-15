From: Jan Engelhardt <jengelh@medozas.de>
Subject: ext4 offers less blocks than other fs
Date: Tue, 15 Nov 2011 20:51:18 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1111152031020.11901@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:49578 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757327Ab1KOTvT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Nov 2011 14:51:19 -0500
Received: from localhost (localhost [127.0.0.1])
	by seven.medozas.de (Postfix) with ESMTP id 14EF121A01DF
	for <linux-ext4@vger.kernel.org>; Tue, 15 Nov 2011 20:51:18 +0100 (CET)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi.


In moving away from some ntfs-3g filesystem to ext4 (migration of a 
Windows-esque fileserver), I see a rather steep metadata use with ext4 
such that moving the data was not completely possible. Per df:

Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/dm-5            1953514324 1952543856    970468 100% /mnt/old
/dev/mapper/data     1922858888 1922858880         0 100% /mnt/new
[attempted a rsync as root]

The blockdev size is just minimally different:
20:32 nas:~ # blockdev --getsize64 /dev/dm-5
2000398671872
20:32 nas:~ # blockdev --getsize64 /dev/dm-6
2000396836864

And there is a 29 GB(!) difference between 1953514324 and 1922858888,
so my question is: where is all of that going?

(e2fsprogs 1.41.14)
Filesystem volume name:   data
Last mounted on:          /mnt/new
Filesystem UUID:          807fec49-7a8a-3520-a648-be677475377c
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype
needs_recovery extent flex_bg sparse_super large_file huge_file uninit_bg
dir_nlink extra_isize
Filesystem flags:         signed_directory_hash 
Default mount options:    (none)
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              122101760
Block count:              488378134
Reserved block count:     24418906
Free blocks:              480664715
Free inodes:              122101749
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      907
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
Flex block group size:    16
Filesystem created:       Mon Nov 14 20:43:23 2011
Last mount time:          Mon Nov 14 20:43:55 2011
Last write time:          Mon Nov 14 20:43:55 2011
Mount count:              1
Maximum mount count:      26
Last checked:             Mon Nov 14 20:43:23 2011
Check interval:           15552000 (6 months)
Next check after:         Sat May 12 21:43:23 2012
Lifetime writes:          144 MB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      5e2619e2-7683-4589-b390-57e569444705
Journal backup:           inode blocks
Journal features:         (none)
Journal size:             128M
Journal length:           32768
Journal sequence:         0x00002751
Journal start:            4341
[Details about groups 0-14904 omitted.]
