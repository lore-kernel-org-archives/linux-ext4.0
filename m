From: "Huang Weller (CM/ESW12-CN)" <Weller.Huang@cn.bosch.com>
Subject: ext4 filesystem bad extent error review
Date: Thu, 2 Jan 2014 12:59:52 +0800
Message-ID: <AE39A478622CF340ABEC2418D74074F61FC567864C@SGPMBX05.APAC.bosch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "Juergens Dirk (CM-AI/PJ-CF32)" <Dirk.Juergens@de.bosch.com>
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp6-v.fe.bosch.de ([139.15.237.11]:16106 "EHLO
	smtp6-v.fe.bosch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbaABFAL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Jan 2014 00:00:11 -0500
Received: from vsmta13.fe.internet.bosch.com (unknown [10.4.98.53])
	by imta24.fe.bosch.de (Postfix) with ESMTP id 7D0BDD80217
	for <linux-ext4@vger.kernel.org>; Thu,  2 Jan 2014 06:00:09 +0100 (CET)
Received: from vsgw12.fe.internet.bosch.com (vsgw12.fe.internet.bosch.com [10.4.98.14])
	by vsmta13.fe.internet.bosch.com (Postfix) with ESMTP id 666756008A8
	for <linux-ext4@vger.kernel.org>; Thu,  2 Jan 2014 06:00:09 +0100 (CET)
Received: from localhost (unknown [127.0.0.1])
	by IMSVA (Postfix) with SMTP id 6924822B2D1
	for <linux-ext4@vger.kernel.org>; Thu,  2 Jan 2014 06:00:09 +0100 (CET)
Received: from si-hub05.de.bosch.com (unknown [10.3.153.47])
	by vsgw12.fe.internet.bosch.com (Postfix) with ESMTP id 50435228540
	for <linux-ext4@vger.kernel.org>; Thu,  2 Jan 2014 06:00:05 +0100 (CET)
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



Hello ext4 maintainer,

We found below kinds of error several times, it happened in the kernel 3.5.7.23 which we reproduce this over four times.
And we also found this issue 1 times in the kernel 3.8.13.11, which it is harder to reproduce it than the version 3.5.7.23.
Our product is a embedded system which the main CPU is freescale i.MX6(ARM cortex A9) and our storage device is eMMC which is follow the jedec4.5 standard.

ERROR LOG:
EXT4-fs error (device mmcblk1p2): ext4_ext_check_inode:462: inode #2063: comm stability-1031.: bad header/extent: invalid extent entries - magic f30a, entries 1, max 4(4), depth 0(0)
 EXT4-fs error (device mmcblk1p2): ext4_ext_check_inode:462: inode #2063: comm stability-1031.: bad header/extent: invalid extent entries - magic f30a, entries 1, max 4(4), depth 0(0)
open /mmc/test2nd//hp000002c8q2y6kRgcAy  fail
File /mmc/test2nd//hp000002c8q2y6kRgcAy other ERROR(60)

When we try to use debugfs to parse the detail of this issue, we found it is caused by the corrupted meta data. We have two typical corrupted meta data happened in out failure cases. Please see the numbers with yellow background color in below log, the values in that area should not all ZERO.
CASE 1:
bash-3.2# dd if=/dev/mmcblk1p2 bs=4096 skip=569 count=4096 | hexdump -C
..
00000800  80 81 00 00 10 14 00 00  31 00 00 00 31 00 00 00  |........1...1...|
00000810  31 00 00 00 00 00 00 00  00 00 01 00 10 00 00 00  |1...............|
00000820  00 00 08 00 01 00 00 00  0a f3 01 00 04 00 00 00  |................|
00000830  00 00 00 00 00 00 00 00  02 00 00 00 00 00 00 00  |................|  => 0x83a - 0x83f should not be all ZERO
00000840  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000860  00 00 00 00 51 09 b8 14  00 00 00 00 00 00 00 00  |....Q...........|
00000870  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00000880  1c 00 00 00 e4 45 c3 23  e4 45 c3 23 e4 45 c3 23  |.....E.#.E.#.E.#|
00000890  31 00 00 00 e4 45 c3 23  00 00 00 00 00 00 00 00  |1....E.#........|
000008a0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|

CASE2:
bash-3.2# debugfs /dev/mmcblk1p1
debugfs 1.42.1 (17-Feb-2012)
debugfs:  dump_extents <393968>
Level Entries       Logical          Physical Length Flags
 0/ 0   1/  1     0 - 4294967295 1705492 - 4296672787      0
00000f00  80 81 00 00 10 14 00 00  2f a0 01 00 2f a0 01 00  |......../.../...|
00000f10  2f a0 01 00 00 00 00 00  00 00 01 00 10 00 00 00  |/...............|
00000f20  00 00 08 00 01 00 00 00  0a f3 01 00 04 00 00 00  |................|
00000f30  00 00 00 00 00 00 00 00  00 00 00 00 14 06 1a 00  |................|  => offset 0xf38-0xf39 should not be ZERO
00000f40  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000f60  00 00 00 00 25 bb 10 cd  00 00 00 00 00 00 00 00  |....%...........|
00000f70  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00000f80  1c 00 00 00 d8 95 6c cf  d8 95 6c cf d8 95 6c cf  |......l...l...l.|
00000f90  2f a0 01 00 d8 95 6c cf  00 00 00 00 00 00 00 00  |/.....l.........|
00000fa0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|


We did more test which we backup the journal blocks  before we mount the test partition.
Actually, before we mount the test partition, we use fsck.ext4 with -n option to verify whether there is any  bad extents issues available. The fsck.ext4 never found any such kind issue. And we can prove that the bad extents issue is happened after journaling replay.
We tried some different mount options, even mount the filesystem with journal_checksum, but the bad extents issue also happened.
Below log can proves that the journal block contain the bad extents contents:

bash-3.2#  debugfs -R "imap <2063>" /dev/mmcblk1p2
debugfs 1.42.1 (17-Feb-2012)
Inode 2063 is part of block group 0
        located at block 525, offset 0x0e00
bash-3.2#  debugfs -R "dump_extents <2063>" /dev/mmcblk1p2
debugfs 1.42.1 (17-Feb-2012)
Level Entries       Logical          Physical Length Flags
 0/ 0   1/  1     0 - 4294967295 1338882 - 4296306177      0
 
  dd if=/dev/mmcblk1p2 bs=4096 skip=525 count=4096 | hexdump -C
00000e00  80 81 00 00 10 14 00 00  37 00 00 00 37 00 00 00  |........7...7...|
00000e10  37 00 00 00 00 00 00 00  00 00 01 00 10 00 00 00  |7...............|
00000e20  00 00 08 00 01 00 00 00  0a f3 01 00 04 00 00 00  |................|
00000e30  00 00 00 00 00 00 00 00  00 00 00 00 02 6e 14 00  |.............n..| =>0xe38-0xe39 is zero which caused bad extent error
00000e40  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000e60  00 00 00 00 2b f2 c5 2b  00 00 00 00 00 00 00 00  |....+..+........|
00000e70  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00000e80  1c 00 00 00 d8 e5 e8 49  d8 e5 e8 49 d8 e5 e8 49  |.......I...I...I|
00000e90  37 00 00 00 d8 e5 e8 49  00 00 00 00 00 00 00 00  |7......I........|
00000ea0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|

==search the string "00 00 00 00 02 6e 14 00 " in the journal block which copyed before fs mounted.
bash-3.2# hexdump -C journal2.img | grep "00 00 00 00 02 6e 14 00"
00adce30  00 00 00 00 00 00 00 00  00 00 00 00 02 6e 14 00  |.............n..|

== found the same contents in journal block, dump that block. The contents is same as the bad block in the FS meta data.
bash-3.2# hexdump -C journal2.img -s 0xadce00 -n 1024
00adce00  80 81 00 00 10 14 00 00  37 00 00 00 37 00 00 00  |........7...7...|
00adce10  37 00 00 00 00 00 00 00  00 00 01 00 10 00 00 00  |7...............|
00adce20  00 00 08 00 01 00 00 00  0a f3 01 00 04 00 00 00  |................|
00adce30  00 00 00 00 00 00 00 00  00 00 00 00 02 6e 14 00  |.............n..|
00adce40  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00adce60  00 00 00 00 2b f2 c5 2b  00 00 00 00 00 00 00 00  |....+..+........|
00adce70  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00adce80  1c 00 00 00 d8 e5 e8 49  d8 e5 e8 49 d8 e5 e8 49  |.......I...I...I|
00adce90  37 00 00 00 d8 e5 e8 49  00 00 00 00 00 00 00 00  |7......I........|
00adcea0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|

==check whether the address 0xadce00 is include in the valid journal blocks.
bash-3.2# hexdump -C journal2.img | grep "c0 3b 39 98"
00000000  c0 3b 39 98 00 00 00 04  00 00 00 00 00 00 10 00  |.;9.............|
....
009c7000  c0 3b 39 98 00 00 00 01  00 00 1e 27 00 00 02 34  |.;9........'...4|
00a38000  c0 3b 39 98 00 00 00 02  00 00 1e 27 00 00 00 00  |.;9........'....|  => it is include in valid journal blocks.
00a39000  c0 3b 39 98 00 00 00 01  00 00 1e 28 00 00 01 7d  |.;9........(...}|
00b8e000  c0 3b 39 98 00 00 00 01  00 00 1e 28 00 00 02 a3  |.;9........(....|
00c6a000  c0 3b 39 98 00 00 00 02  00 00 1e 28 00 00 00 00  |.;9........(....|


We  searched such error on internet, there are some one also has such issue. But there is no solution.
This issue maybe not a big issue which it can be repaired by fsck.ext4 easily. But we have below questions:
1. whether this issue already been fixed in the latest kernel version?
2. based on the information I provided in this mail, can you help to solve this issue ?

many thanks.

Huang weiliang

Software Engineer (CM/ESW1-CN)
Bosch Automotive Products

