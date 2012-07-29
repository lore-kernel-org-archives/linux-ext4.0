From: =?iso-8859-1?Q?Arne_H=FCggenberg?= <hueggenberg@sportsandbytes.de>
Subject: resize2fs > 16TB questions
Date: Sun, 29 Jul 2012 17:24:35 +0200
Message-ID: <2019C80F-7D05-44FD-89AE-829E3A97053A@sportsandbytes.de>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail2.sportsandbytes.de ([87.193.191.13]:42539 "EHLO
	mail2.sportsandbytes.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab2G2PbT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 29 Jul 2012 11:31:19 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello List,

im trying to resize a ext4 fs to > 16TB.

Having had a look at the e2fsprogs 1.42.x release notes i thought that, with the online resize ioctl having been merged in Kernel 3.3, this should be possible.

But so far i have had no success achieving this:

~ # uname -a
Linux 3.3.8-gentoo #1 SMP Fri Jul 27 16:13:25 CEST 2012 x86_64 Intel(R) Xeon(R) CPU E5620 @ 2.40GHz GenuineIntel GNU/Linux

~ # tune2fs -l /dev/vg0/lvol1
tune2fs 1.42.4 (12-June-2012)
Filesystem volume name:   <none>
Last mounted on:          /home/filestore_extern_1
Filesystem UUID:          8fba4f1b-5311-4c9b-b8bf-def4957dc1bd
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype needs_recovery extent 64bit flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
Filesystem flags:         signed_directory_hash 
Default mount options:    user_xattr acl
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              521011200
Block count:              4168089600
Reserved block count:     191127425
Free blocks:              2195165566
Free inodes:              520937830
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      60
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         4096
Inode blocks per group:   256
RAID stride:              16
RAID stripe width:        160
Flex block group size:    16
Filesystem created:       Fri Jul 27 17:16:24 2012
Last mount time:          Sun Jul 29 15:22:23 2012
Last write time:          Sun Jul 29 15:22:23 2012
Mount count:              6
Maximum mount count:      -1
Last checked:             Fri Jul 27 17:16:24 2012
Check interval:           0 (<none>)
Lifetime writes:          7485 GB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:	          256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      ef2ec72a-750b-4822-bd8d-9117faadeaee
Journal backup:           inode blocks


~ # vgdisplay
  --- Volume group ---
  VG Name               vg0
  System ID             
  Format                lvm2
  Metadata Areas        2
  Metadata Sequence No  4
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                1
  Open LV               1
  Max PV                0
  Cur PV                2
  Act PV                2
  VG Size               18.18 TiB
  PE Size               4.00 MiB
  Total PE              4766718
  Alloc PE / Size       4766718 / 18.18 TiB
  Free  PE / Size       0 / 0   
  VG UUID               q6p5LG-pi1P-pAcI-fSsv-vFI7-6sAA-eabaBH
   
~ # lvdisplay
  --- Logical volume ---
  LV Name                /dev/vg0/lvol1
  VG Name                vg0
  LV UUID                7OF1do-HqZD-FGSN-chJF-rPYC-x1Ty-vGCZlc
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                18.18 TiB
  Current LE             4766718
  Segments               2
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           254:1

 ~ # resize2fs /dev/vg0/lvol1
resize2fs 1.42.4 (12-June-2012)
resize2fs: New size too large to be expressed in 32 bits


Any advice on how to proceed would be welcome.

Regards,
Arne






