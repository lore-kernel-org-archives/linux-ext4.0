From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Online resize issue with 3.13.5 & 3.15.6
Date: Sun, 20 Jul 2014 19:26:19 +0800
Message-ID: <53CBA75B.2030102@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns3.fnarfbargle.com ([103.4.17.7]:35068 "EHLO
	ns3.fnarfbargle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbaGTLwA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 20 Jul 2014 07:52:00 -0400
Received: from srv
	([10.8.0.1] helo=srv.home ident=heh11082)
	by ns3.fnarfbargle.com with esmtp (Exim 4.80)
	(envelope-from <lists2009@fnarfbargle.com>)
	id 1X8pFm-0004eS-Cl
	for linux-ext4@vger.kernel.org; Sun, 20 Jul 2014 21:26:06 +1000
Received: from bkmac.home ([192.168.2.87])
	by srv.home with esmtp (Exim 4.80)
	(envelope-from <lists2009@fnarfbargle.com>)
	id 1X8pFz-0002qm-5V
	for linux-ext4@vger.kernel.org; Sun, 20 Jul 2014 19:26:19 +0800
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

G'day all,

Machine was running 3.13.5. x86_64.

I had a 12 device (2TB) RAID-6 formatted ext4. I added 2 drives to its 
underlying md and restriped it (no issues). After the restripe I 
attempted an online resize using ext2progs 1.42.5 (Debian stable). This 
failed with a message about the size not fitting into 32 bits so I 
compiled 1.42.11 and tried again.

This resulted in a message I no longer have access to that indicated 
that something went wrong. I attempted it a couple more times (how dumb 
am I?) The resulting parts of dmesg are :

Jul 20 17:20:13 srv kernel: [11893469.381692] EXT4-fs (md0): resizing 
filesystem from 4883458240 to 5860149888 blocks
Jul 20 17:20:23 srv kernel: [11893479.597505] EXT4-fs (md0): resized to 
5128585216 blocks

Jul 20 17:20:43 srv kernel: [11893499.681961] EXT4-fs (md0): resized to 
5525995520 blocks
Jul 20 17:20:53 srv kernel: [11893509.762719] EXT4-fs (md0): resized to 
5641863168 blocks
Jul 20 17:21:02 srv kernel: [11893517.869988] EXT4-fs warning (device 
md0): verify_reserved_gdb:705: reserved GDT 2769 missing grp 177147 
(5804755665)
Jul 20 17:21:02 srv kernel: [11893517.906663] EXT4-fs (md0): resized 
filesystem to 5860149888
Jul 20 17:21:08 srv kernel: [11893523.795964] EXT4-fs warning (device 
md0): ext4_group_extend:1712: can't shrink FS - resize aborted
Jul 20 17:21:17 srv kernel: [11893533.224440] EXT4-fs (md0): resizing 
filesystem from 5804916736 to 5860149888 blocks
Jul 20 17:21:17 srv kernel: [11893533.261982] EXT4-fs warning (device 
md0): verify_reserved_gdb:705: reserved GDT 2769 missing grp 177147 
(5804755665)
Jul 20 17:21:17 srv kernel: [11893533.300352] EXT4-fs (md0): resized 
filesystem to 5860149888
Jul 20 17:21:17 srv kernel: [11893533.636745] EXT4-fs warning (device 
md0): ext4_group_extend:1712: can't shrink FS - resize aborted

Jul 20 17:23:11 srv kernel: [11893647.253580] EXT4-fs (md0): resizing 
filesystem from 5804916736 to 5860149888 blocks
Jul 20 17:23:11 srv kernel: [11893647.291562] EXT4-fs warning (device 
md0): verify_reserved_gdb:705: reserved GDT 2769 missing grp 177147 
(5804755665)
Jul 20 17:23:11 srv kernel: [11893647.330267] EXT4-fs (md0): resized 
filesystem to 5860149888
Jul 20 17:23:12 srv kernel: [11893647.675745] EXT4-fs warning (device 
md0): ext4_group_extend:1712: can't shrink FS - resize aborted


At this point I thought it best to reboot the machine, so I upgraded to 
3.15.6 and brought it up in single user mode. The filesystem passed fsck 
with a message about an uninitialised block group and no other errors. 
I've since repeated the fsck several times and it is clean.

The issue is it locks up resize2fs hard (just spins on one core). Once 
it starts spinning there is no strace, so it's chasing its tail.

This is the current state of the fs.

root@srv:/s# dumpe2fs -h /dev/md0
dumpe2fs 1.42.11 (09-Jul-2014)
Filesystem volume name:   <none>
Last mounted on:          /s/src
Filesystem UUID:          99566e8e-e66d-4351-9675-0b3a549e2ba5
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index 
filetype extent 64bit flex_bg sparse_super large_file huge_file 
uninit_bg dir_nlink extra_isize
Filesystem flags:         signed_directory_hash
Default mount options:    user_xattr acl
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              362807296
Block count:              5804916736
Reserved block count:     0
Free blocks:              1407676872
Free inodes:              358800089
First block:              0
Block size:               4096
Fragment size:            4096
Group descriptor size:    64
Reserved GDT blocks:      585
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         2048
Inode blocks per group:   128
RAID stride:              32
RAID stripe width:        320
Flex block group size:    16
Filesystem created:       Wed Jul 31 15:02:47 2013
Last mount time:          Sun Jul 20 17:41:16 2014
Last write time:          Sun Jul 20 18:48:00 2014
Mount count:              0
Maximum mount count:      -1
Last checked:             Sun Jul 20 18:48:00 2014
Check interval:           0 (<none>)
Lifetime writes:          4088 GB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:	          256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      c08e3b0a-2c23-4b0f-b2d6-9bb8f26e0b48
Journal backup:           inode blocks
Journal features:         journal_incompat_revoke journal_64bit
Journal size:             128M
Journal length:           32768
Journal sequence:         0x00229921
Journal start:            0

root@srv:/s# mdadm --detail /dev/md0
/dev/md0:
         Version : 1.2
   Creation Time : Wed Jul 31 15:02:11 2013
      Raid Level : raid6
      Array Size : 23440599552 (22354.70 GiB 24003.17 GB)
   Used Dev Size : 1953383296 (1862.89 GiB 2000.26 GB)
    Raid Devices : 14
   Total Devices : 14
     Persistence : Superblock is persistent

   Intent Bitmap : Internal

     Update Time : Sun Jul 20 18:54:56 2014
           State : active
  Active Devices : 14
Working Devices : 14
  Failed Devices : 0
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 128K

            Name : srv:0  (local to host srv)
            UUID : a66b7f8a:dcf6b939:c14a87af:b21fcedf
          Events : 303231

     Number   Major   Minor   RaidDevice State
        0       8       64        0      active sync   /dev/sde
        1       8      144        1      active sync   /dev/sdj
        2       8      160        2      active sync   /dev/sdk
       14       8      176        3      active sync   /dev/sdl
        4       8      192        4      active sync   /dev/sdm
        5       8      224        5      active sync   /dev/sdo
        6       8      208        6      active sync   /dev/sdn
        7      65        0        7      active sync   /dev/sdq
        8      65       16        8      active sync   /dev/sdr
        9      65       48        9      active sync   /dev/sdt
       13      65      112       10      active sync   /dev/sdx
       12       8       32       11      active sync   /dev/sdc
       16      65       32       12      active sync   /dev/sds
       15       8      240       13      active sync   /dev/sdp

The filesystem looks clean, everything is accessible and though this is 
a production box, no business critical elements are on this array so we 
can live without it mounted if someone can give me some stuff to try.

Regards,
Brad
