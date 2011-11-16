From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: ext4 offers less blocks than other fs
Date: Wed, 16 Nov 2011 09:43:33 +0800
Message-ID: <CAGBYx2Yr6yGmQ8c=34CCW=v0g5-MBFhN3ztyd_p+qEBer1NyCg@mail.gmail.com>
References: <alpine.LNX.2.01.1111152031020.11901@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49430 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932828Ab1KPBne convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Nov 2011 20:43:34 -0500
Received: by eye27 with SMTP id 27so6393755eye.19
        for <linux-ext4@vger.kernel.org>; Tue, 15 Nov 2011 17:43:33 -0800 (PST)
In-Reply-To: <alpine.LNX.2.01.1111152031020.11901@frira.zrqbmnf.qr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 16, 2011 at 3:51 AM, Jan Engelhardt <jengelh@medozas.de> wr=
ote:
> Hi.
>
>
> In moving away from some ntfs-3g filesystem to ext4 (migration of a
> Windows-esque fileserver), I see a rather steep metadata use with ext=
4
> such that moving the data was not completely possible. Per df:
>
> Filesystem =A0 =A0 =A0 =A0 =A0 1K-blocks =A0 =A0 =A0Used Available Us=
e% Mounted on
> /dev/dm-5 =A0 =A0 =A0 =A0 =A0 =A01953514324 1952543856 =A0 =A0970468 =
100% /mnt/old
> /dev/mapper/data =A0 =A0 1922858888 1922858880 =A0 =A0 =A0 =A0 0 100%=
 /mnt/new
> [attempted a rsync as root]
>
> The blockdev size is just minimally different:
> 20:32 nas:~ # blockdev --getsize64 /dev/dm-5
> 2000398671872
> 20:32 nas:~ # blockdev --getsize64 /dev/dm-6
> 2000396836864
>
> And there is a 29 GB(!) difference between 1953514324 and 1922858888,
> so my question is: where is all of that going?
>
> (e2fsprogs 1.41.14)
> Filesystem volume name: =A0 data
> Last mounted on: =A0 =A0 =A0 =A0 =A0/mnt/new
> Filesystem UUID: =A0 =A0 =A0 =A0 =A0807fec49-7a8a-3520-a648-be6774753=
77c
> Filesystem magic number: =A00xEF53
> Filesystem revision #: =A0 =A01 (dynamic)
> Filesystem features: =A0 =A0 =A0has_journal ext_attr resize_inode dir=
_index filetype
> needs_recovery extent flex_bg sparse_super large_file huge_file unini=
t_bg
> dir_nlink extra_isize
> Filesystem flags: =A0 =A0 =A0 =A0 signed_directory_hash
> Default mount options: =A0 =A0(none)
> Filesystem state: =A0 =A0 =A0 =A0 clean
> Errors behavior: =A0 =A0 =A0 =A0 =A0Continue
> Filesystem OS type: =A0 =A0 =A0 Linux
> Inode count: =A0 =A0 =A0 =A0 =A0 =A0 =A0122101760
> Block count: =A0 =A0 =A0 =A0 =A0 =A0 =A0488378134
> Reserved block count: =A0 =A0 24418906
> Free blocks: =A0 =A0 =A0 =A0 =A0 =A0 =A0480664715
> Free inodes: =A0 =A0 =A0 =A0 =A0 =A0 =A0122101749
> First block: =A0 =A0 =A0 =A0 =A0 =A0 =A00
> Block size: =A0 =A0 =A0 =A0 =A0 =A0 =A0 4096
> Fragment size: =A0 =A0 =A0 =A0 =A0 =A04096
> Reserved GDT blocks: =A0 =A0 =A0907
> Blocks per group: =A0 =A0 =A0 =A0 32768
> Fragments per group: =A0 =A0 =A032768
> Inodes per group: =A0 =A0 =A0 =A0 8192
> Inode blocks per group: =A0 512
> Flex block group size: =A0 =A016
> Filesystem created: =A0 =A0 =A0 Mon Nov 14 20:43:23 2011
> Last mount time: =A0 =A0 =A0 =A0 =A0Mon Nov 14 20:43:55 2011
> Last write time: =A0 =A0 =A0 =A0 =A0Mon Nov 14 20:43:55 2011
> Mount count: =A0 =A0 =A0 =A0 =A0 =A0 =A01
> Maximum mount count: =A0 =A0 =A026
> Last checked: =A0 =A0 =A0 =A0 =A0 =A0 Mon Nov 14 20:43:23 2011
> Check interval: =A0 =A0 =A0 =A0 =A0 15552000 (6 months)
> Next check after: =A0 =A0 =A0 =A0 Sat May 12 21:43:23 2012
> Lifetime writes: =A0 =A0 =A0 =A0 =A0144 MB
> Reserved blocks uid: =A0 =A0 =A00 (user root)
> Reserved blocks gid: =A0 =A0 =A00 (group root)
> First inode: =A0 =A0 =A0 =A0 =A0 =A0 =A011
> Inode size: =A0 =A0 =A0 =A0 =A0 =A0 =A0 256
> Required extra isize: =A0 =A0 28
> Desired extra isize: =A0 =A0 =A028
> Journal inode: =A0 =A0 =A0 =A0 =A0 =A08
> Default directory hash: =A0 half_md4
> Directory Hash Seed: =A0 =A0 =A05e2619e2-7683-4589-b390-57e569444705
> Journal backup: =A0 =A0 =A0 =A0 =A0 inode blocks
> Journal features: =A0 =A0 =A0 =A0 (none)
> Journal size: =A0 =A0 =A0 =A0 =A0 =A0 128M
> Journal length: =A0 =A0 =A0 =A0 =A0 32768
> Journal sequence: =A0 =A0 =A0 =A0 0x00002751
> Journal start: =A0 =A0 =A0 =A0 =A0 =A04341
> [Details about groups 0-14904 omitted.]
Hi,

The system metadata can be calculated.

The inode blocks per group is 512, besides there are 1 block bitmap
block and 1 inode bitmap block per group.  The above filesystem has
488378134 blocks, thus there are 14905 block groups.  So the group
tables (inode table, inode bitmap, block bitmap) take up  7661170
blocks. In addition, journal uses 32768 blocks and group descriptor
uses some blocks.

Yongqiang.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
