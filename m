From: Somchai Smythe <buraphalinuxserver@gmail.com>
Subject: (unknown)
Date: Sun, 17 Feb 2013 20:21:00 +0700
Message-ID: <CAFJqGkO3djXZHRxX0SUZ23EFvagYOEk=KUSkiHg2SgMu-QOLoQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ie0-f181.google.com ([209.85.223.181]:51433 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755870Ab3BQNVE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Feb 2013 08:21:04 -0500
Received: by mail-ie0-f181.google.com with SMTP id 17so6420850iea.12
        for <linux-ext4@vger.kernel.org>; Sun, 17 Feb 2013 05:21:01 -0800 (PST)
Subject: 
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

     I keep getting this (copied by hand):

e2fsck -v -f /dev/blsvg/tmp
e2fsck 1.42.7 (21-Jan-2013)
ext2fs_check_desc: Corrupt group descriptor: bad block for inode table
e2fsck: Group descriptor look bad... trying backup blocks...
/tmp: recovering journal
e2fsck: unable to set superblock flags on /tmp

/tmp: ********** WARNING: Filesystem still has errors **********

I thought '-f' would force things to get fixed.  Is there a 'force
harder' switch?  Since it is /tmp I can just run mke2fs again, but I
would like to know before I do that why e2fsck cannot fix this.  I can
still mount the filesystem and read files on it, but I'm afraid to
really use it.

I'm running vanilla 3.7.8 kernel on an amd64 virtual machine if it matters.

dumpe2fs 1.42.7 (21-Jan-2013)
Filesystem volume name:   /tmp
Last mounted on:          /tmp
Filesystem UUID:          3268058d-455f-4f65-a6ee-72e236e6bff5
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index
filetype extent flex_bg sparse_super large_file huge_file dir_nlink
extra_isize
Filesystem flags:         signed_directory_hash
Default mount options:    user_xattr acl
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              2719744
Block count:              2707456
Reserved block count:     67867
Free blocks:              1473632
Free inodes:              2620790
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      319
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         32768
Inode blocks per group:   2048
Flex block group size:    16
Filesystem created:       Sun Feb 17 06:26:55 2013
Last mount time:          Sun Feb 17 17:51:13 2013
Last write time:          Sun Feb 17 19:56:52 2013
Mount count:              2
Maximum mount count:      28
Last checked:             Sun Feb 17 12:41:00 2013
Check interval:           15552000 (6 months)
Next check after:         Fri Aug 16 12:41:00 2013
Lifetime writes:          16 GB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      75b881a3-6a2a-4006-ac6d-943b23c88b73
Journal backup:           inode blocks
Journal features:         journal_incompat_revoke
Journal size:             128M
Journal length:           32768
Journal sequence:         0x00000209
Journal start:            0


Group 0: (Blocks 0-32767)
  Primary superblock at 0, Group descriptors at 1-1
  Reserved GDT blocks at 2-320
  Block bitmap at 321 (+321), Inode bitmap at 337 (+337)
  Inode table at 353-2400 (+353)
  0 free blocks, 30516 free inodes, 131 directories
  Free blocks:
  Free inodes: 2251-2429, 2431-7853, 7855-32768
Group 1: (Blocks 32768-65535)
  Backup superblock at 32768, Group descriptors at 32769-32769
  Reserved GDT blocks at 32770-33088
  Block bitmap at 322 (bg #0 + 322), Inode bitmap at 338 (bg #0 + 338)
  Inode table at 2401-4448 (bg #0 + 2401)
  0 free blocks, 32766 free inodes, 2 directories
  Free blocks:
  Free inodes: 32769-56724, 56726-64383, 64385-65536
Group 2: (Blocks 65536-98303)
  Block bitmap at 323 (bg #0 + 323), Inode bitmap at 339 (bg #0 + 339)
  Inode table at 4449-6496 (bg #0 + 4449)
  0 free blocks, 32768 free inodes, 0 directories
  Free blocks:
  Free inodes: 65537-98304
Group 3: (Blocks 98304-131071)
  Backup superblock at 98304, Group descriptors at 98305-98305
  Reserved GDT blocks at 98306-98624
  Block bitmap at 324 (bg #0 + 324), Inode bitmap at 340 (bg #0 + 340)
  Inode table at 6497-8544 (bg #0 + 6497)
  0 free blocks, 32768 free inodes, 0 directories
  Free blocks:
  Free inodes: 98305-131072
Group 4: (Blocks 131072-163839)
  Block bitmap at 325 (bg #0 + 325), Inode bitmap at 341 (bg #0 + 341)
  Inode table at 8545-10592 (bg #0 + 8545)
  0 free blocks, 32768 free inodes, 0 directories
  Free blocks:
  Free inodes: 131073-163840
Group 5: (Blocks 163840-196607)
  Backup superblock at 163840, Group descriptors at 163841-163841
  Reserved GDT blocks at 163842-164160
  Block bitmap at 326 (bg #0 + 326), Inode bitmap at 342 (bg #0 + 342)
  Inode table at 10593-12640 (bg #0 + 10593)
  0 free blocks, 32768 free inodes, 0 directories
  Free blocks:
  Free inodes: 163841-196608
Group 6: (Blocks 196608-229375)
  Block bitmap at 327 (bg #0 + 327), Inode bitmap at 343 (bg #0 + 343)
  Inode table at 12641-14688 (bg #0 + 12641)
  0 free blocks, 32768 free inodes, 0 directories
  Free blocks:
  Free inodes: 196609-229376
Group 7: (Blocks 229376-262143)
  Backup superblock at 229376, Group descriptors at 229377-229377
  Reserved GDT blocks at 229378-229696
  Block bitmap at 328 (bg #0 + 328), Inode bitmap at 344 (bg #0 + 344)
  Inode table at 14689-16736 (bg #0 + 14689)
  0 free blocks, 32768 free inodes, 0 directories
  Free blocks:
  Free inodes: 229377-262144
Group 8: (Blocks 262144-294911)
  Block bitmap at 329 (bg #0 + 329), Inode bitmap at 345 (bg #0 + 345)
  Inode table at 16737-18784 (bg #0 + 16737)
  0 free blocks, 32768 free inodes, 0 directories
  Free blocks:
  Free inodes: 262145-294912
Group 9: (Blocks 294912-327679)
  Backup superblock at 294912, Group descriptors at 294913-294913
  Reserved GDT blocks at 294914-295232
  Block bitmap at 330 (bg #0 + 330), Inode bitmap at 346 (bg #0 + 346)
  Inode table at 18785-20832 (bg #0 + 18785)
  0 free blocks, 32768 free inodes, 0 directories
  Free blocks:
  Free inodes: 294913-327680
Group 10: (Blocks 327680-360447)
  Block bitmap at 331 (bg #0 + 331), Inode bitmap at 347 (bg #0 + 347)
  Inode table at 20833-22880 (bg #0 + 20833)
  0 free blocks, 32768 free inodes, 0 directories
  Free blocks:
  Free inodes: 327681-360448
Group 11: (Blocks 360448-393215)
  Block bitmap at 332 (bg #0 + 332), Inode bitmap at 348 (bg #0 + 348)
  Inode table at 22881-24928 (bg #0 + 22881)
  0 free blocks, 32768 free inodes, 0 directories
  Free blocks:
  Free inodes: 360449-393216
Group 12: (Blocks 393216-425983)
  Block bitmap at 333 (bg #0 + 333), Inode bitmap at 349 (bg #0 + 349)
  Inode table at 24929-26976 (bg #0 + 24929)
  0 free blocks, 32768 free inodes, 0 directories
  Free blocks:
  Free inodes: 393217-425984
Group 13: (Blocks 425984-458751)
  Block bitmap at 334 (bg #0 + 334), Inode bitmap at 350 (bg #0 + 350)
  Inode table at 26977-29024 (bg #0 + 26977)
  0 free blocks, 32768 free inodes, 0 directories
  Free blocks:
  Free inodes: 425985-458752
Group 14: (Blocks 458752-491519)
  Block bitmap at 335 (bg #0 + 335), Inode bitmap at 351 (bg #0 + 351)
  Inode table at 29025-31072 (bg #0 + 29025)
  0 free blocks, 32768 free inodes, 0 directories
  Free blocks:
  Free inodes: 458753-491520
Group 15: (Blocks 491520-524287)
  Block bitmap at 336 (bg #0 + 336), Inode bitmap at 352 (bg #0 + 352)
  Inode table at 33089-35136 (bg #1 + 321)
  0 free blocks, 32768 free inodes, 0 directories
  Free blocks:
  Free inodes: 491521-524288
Group 16: (Blocks 524288-557055)
  Block bitmap at 524288 (+0), Inode bitmap at 524304 (+16)
  Inode table at 524320-526367 (+32)
  0 free blocks, 0 free inodes, 2248 directories
  Free blocks:
  Free inodes:
Group 17: (Blocks 557056-589823)
  Block bitmap at 524289 (bg #16 + 1), Inode bitmap at 524305 (bg #16 + 17)
  Inode table at 526368-528415 (bg #16 + 2080)
  0 free blocks, 0 free inodes, 1640 directories
  Free blocks:
  Free inodes:
Group 18: (Blocks 589824-622591)
  Block bitmap at 524290 (bg #16 + 2), Inode bitmap at 524306 (bg #16 + 18)
  Inode table at 528416-530463 (bg #16 + 4128)
  0 free blocks, 31857 free inodes, 226 directories
  Free blocks:
  Free inodes: 590736-622592
Group 19: (Blocks 622592-655359)
  Block bitmap at 524291 (bg #16 + 3), Inode bitmap at 524307 (bg #16 + 19)
  Inode table at 530464-532511 (bg #16 + 6176)
  0 free blocks, 32768 free inodes, 0 directories
  Free blocks:
  Free inodes: 622593-655360
Group 20: (Blocks 655360-688127)
  Block bitmap at 524292 (bg #16 + 4), Inode bitmap at 524308 (bg #16 + 20)
  Inode table at 532512-534559 (bg #16 + 8224)
  0 free blocks, 32768 free inodes, 0 directories
  Free blocks:
  Free inodes: 655361-688128
Group 21: (Blocks 688128-720895)
  Block bitmap at 524293 (bg #16 + 5), Inode bitmap at 524309 (bg #16 + 21)
  Inode table at 534560-536607 (bg #16 + 10272)
  0 free blocks, 32768 free inodes, 0 directories
  Free blocks:
  Free inodes: 688129-720896
Group 22: (Blocks 720896-753663)
  Block bitmap at 524294 (bg #16 + 6), Inode bitmap at 524310 (bg #16 + 22)
  Inode table at 536608-538655 (bg #16 + 12320)
  0 free blocks, 32768 free inodes, 0 directories
  Free blocks:
  Free inodes: 720897-753664
Group 23: (Blocks 753664-786431)
  Block bitmap at 524295 (bg #16 + 7), Inode bitmap at 524311 (bg #16 + 23)
  Inode table at 538656-540703 (bg #16 + 14368)
  0 free blocks, 32768 free inodes, 0 directories
  Free blocks:
  Free inodes: 753665-786432
Group 24: (Blocks 786432-819199)
  Block bitmap at 524296 (bg #16 + 8), Inode bitmap at 524312 (bg #16 + 24)
  Inode table at 540704-542751 (bg #16 + 16416)
  0 free blocks, 32768 free inodes, 0 directories
  Free blocks:
  Free inodes: 786433-819200
Group 25: (Blocks 819200-851967)
  Backup superblock at 819200, Group descriptors at 819201-819201
  Reserved GDT blocks at 819202-819520
  Block bitmap at 524297 (bg #16 + 9), Inode bitmap at 524313 (bg #16 + 25)
  Inode table at 542752-544799 (bg #16 + 18464)
  0 free blocks, 32768 free inodes, 0 directories
  Free blocks:
  Free inodes: 819201-851968
Group 26: (Blocks 851968-884735)
  Block bitmap at 524298 (bg #16 + 10), Inode bitmap at 524314 (bg #16 + 26)
  Inode table at 544800-546847 (bg #16 + 20512)
  0 free blocks, 32768 free inodes, 0 directories
  Free blocks:
  Free inodes: 851969-884736
Group 27: (Blocks 884736-917503)
  Backup superblock at 884736, Group descriptors at 884737-884737
  Reserved GDT blocks at 884738-885056
  Block bitmap at 524299 (bg #16 + 11), Inode bitmap at 524315 (bg #16 + 27)
  Inode table at 546848-548895 (bg #16 + 22560)
  0 free blocks, 32768 free inodes, 0 directories
  Free blocks:
  Free inodes: 884737-917504
Group 28: (Blocks 917504-950271)
  Block bitmap at 524300 (bg #16 + 12), Inode bitmap at 524316 (bg #16 + 28)
  Inode table at 548896-550943 (bg #16 + 24608)
  0 free blocks, 32768 free inodes, 0 directories
  Free blocks:
  Free inodes: 917505-950272
Group 29: (Blocks 950272-983039)
  Block bitmap at 524301 (bg #16 + 13), Inode bitmap at 524317 (bg #16 + 29)
  Inode table at 550944-552991 (bg #16 + 26656)
  0 free blocks, 32768 free inodes, 0 directories
  Free blocks:
  Free inodes: 950273-983040
Group 30: (Blocks 983040-1015807)
  Block bitmap at 524302 (bg #16 + 14), Inode bitmap at 524318 (bg #16 + 30)
  Inode table at 552992-555039 (bg #16 + 28704)
  0 free blocks, 32768 free inodes, 0 directories
  Free blocks:
  Free inodes: 983041-1015808
Group 31: (Blocks 1015808-1048575)
  Block bitmap at 524303 (bg #16 + 15), Inode bitmap at 524319 (bg #16 + 31)
  Inode table at 555040-557087 (bg #16 + 30752)
  0 free blocks, 32768 free inodes, 0 directories
  Free blocks:
  Free inodes: 1015809-1048576
Group 32: (Blocks 1048576-1081343)
  Block bitmap at 1048576 (+0), Inode bitmap at 1048592 (+16)
  Inode table at 1048608-1050655 (+32)
  0 free blocks, 1176 free inodes, 2492 directories
  Free blocks:
  Free inodes: 1080169-1081344
Group 33: (Blocks 1081344-1114111)
  Block bitmap at 1048577 (bg #32 + 1), Inode bitmap at 1048593 (bg #32 + 17)
  Inode table at 1050656-1052703 (bg #32 + 2080)
  0 free blocks, 32673 free inodes, 95 directories
  Free blocks:
  Free inodes: 1081440-1114112
Group 34: (Blocks 1114112-1146879)
  Block bitmap at 1048578 (bg #32 + 2), Inode bitmap at 1048594 (bg #32 + 18)
  Inode table at 1052704-1054751 (bg #32 + 4128)
  0 free blocks, 32768 free inodes, 0 directories
  Free blocks:
  Free inodes: 1114113-1146880
Group 35: (Blocks 1146880-1179647)
  Block bitmap at 1048579 (bg #32 + 3), Inode bitmap at 1048595 (bg #32 + 19)
  Inode table at 1054752-1056799 (bg #32 + 6176)
  0 free blocks, 32768 free inodes, 0 directories
  Free blocks:
  Free inodes: 1146881-1179648
Group 36: (Blocks 1179648-1212415)
  Block bitmap at 1048580 (bg #32 + 4), Inode bitmap at 1048596 (bg #32 + 20)
  Inode table at 1056800-1058847 (bg #32 + 8224)
  0 free blocks, 32768 free inodes, 0 directories
  Free blocks:
  Free inodes: 1179649-1212416
Group 37: (Blocks 1212416-1245183)
  Block bitmap at 1048581 (bg #32 + 5), Inode bitmap at 1048597 (bg #32 + 21)
  Inode table at 1058848-1060895 (bg #32 + 10272)
  0 free blocks, 32768 free inodes, 0 directories
  Free blocks:
  Free inodes: 1212417-1245184
Group 38: (Blocks 1245184-1277951)
  Block bitmap at 1048582 (bg #32 + 6), Inode bitmap at 1048598 (bg #32 + 22)
  Inode table at 1060896-1062943 (bg #32 + 12320)
  0 free blocks, 32768 free inodes, 0 directories
  Free blocks:
  Free inodes: 1245185-1277952
Group 39: (Blocks 1277952-1310719)
  Block bitmap at 1048583 (bg #32 + 7), Inode bitmap at 1048599 (bg #32 + 23)
  Inode table at 1062944-1064991 (bg #32 + 14368)
  0 free blocks, 32768 free inodes, 0 directories
  Free blocks:
  Free inodes: 1277953-1310720
Group 40: (Blocks 1310720-1343487)
  Block bitmap at 1310720 (+0), Inode bitmap at 1310721 (+1)
  Inode table at 1310722-1312769 (+2)
  0 free blocks, 32768 free inodes, 0 directories
  Free blocks:
  Free inodes: 1310721-1343488
Group 41: (Blocks 1343488-1376255)
  Block bitmap at 1312770 (bg #40 + 2050), Inode bitmap at 1312771 (bg
#40 + 2051)
  Inode table at 1312772-1314819 (bg #40 + 2052)
  0 free blocks, 32768 free inodes, 0 directories
  Free blocks:
  Free inodes: 1343489-1376256
Group 42: (Blocks 1376256-1409023)
  Block bitmap at 1314820 (bg #40 + 4100), Inode bitmap at 1314821 (bg
#40 + 4101)
  Inode table at 1314822-1316869 (bg #40 + 4102)
  12288 free blocks, 32768 free inodes, 0 directories
  Free blocks: 1396736-1409023
  Free inodes: 1376257-1409024
Group 43: (Blocks 1409024-1441791)
  Block bitmap at 1409024 (+0), Inode bitmap at 1409029 (+5)
  Inode table at 1409034-1411081 (+10)
  22518 free blocks, 32768 free inodes, 0 directories
  Free blocks: 1419274-1441791
  Free inodes: 1409025-1441792
Group 44: (Blocks 1441792-1474559)
  Block bitmap at 1409025 (bg #43 + 1), Inode bitmap at 1409030 (bg #43 + 6)
  Inode table at 1411082-1413129 (bg #43 + 2058)
  32768 free blocks, 32768 free inodes, 0 directories
  Free blocks: 1441792-1474559
  Free inodes: 1441793-1474560
Group 45: (Blocks 1474560-1507327)
  Block bitmap at 1409026 (bg #43 + 2), Inode bitmap at 1409031 (bg #43 + 7)
  Inode table at 1413130-1415177 (bg #43 + 4106)
  32768 free blocks, 32768 free inodes, 0 directories
  Free blocks: 1474560-1507327
  Free inodes: 1474561-1507328
Group 46: (Blocks 1507328-1540095)
  Block bitmap at 1409027 (bg #43 + 3), Inode bitmap at 1409032 (bg #43 + 8)
  Inode table at 1415178-1417225 (bg #43 + 6154)
  32768 free blocks, 32768 free inodes, 0 directories
  Free blocks: 1507328-1540095
  Free inodes: 1507329-1540096
Group 47: (Blocks 1540096-1572863)
  Block bitmap at 1409028 (bg #43 + 4), Inode bitmap at 1409033 (bg #43 + 9)
  Inode table at 1417226-1419273 (bg #43 + 8202)
  32768 free blocks, 32768 free inodes, 0 directories
  Free blocks: 1540096-1572863
  Free inodes: 1540097-1572864
Group 48: (Blocks 1572864-1605631)
  Block bitmap at 1572864 (+0), Inode bitmap at 1572880 (+16)
  Inode table at 1572896-1574943 (+32)
  65504 free blocks, 32768 free inodes, 0 directories
  Free blocks:
  Free inodes: 1572865-1605632
Group 49: (Blocks 1605632-1638399)
  Backup superblock at 1605632, Group descriptors at 1605633-1605633
  Reserved GDT blocks at 1605634-1605952
  Block bitmap at 1572865 (bg #48 + 1), Inode bitmap at 1572881 (bg #48 + 17)
  Inode table at 1574944-1576991 (bg #48 + 2080)
  32447 free blocks, 32768 free inodes, 0 directories
  Free blocks: 1605953-1638399
  Free inodes: 1605633-1638400
Group 50: (Blocks 1638400-1671167)
  Block bitmap at 1572866 (bg #48 + 2), Inode bitmap at 1572882 (bg #48 + 18)
  Inode table at 1576992-1579039 (bg #48 + 4128)
  32768 free blocks, 32768 free inodes, 0 directories
  Free blocks: 1638400-1671167
  Free inodes: 1638401-1671168
Group 51: (Blocks 1671168-1703935)
  Block bitmap at 1572867 (bg #48 + 3), Inode bitmap at 1572883 (bg #48 + 19)
  Inode table at 1579040-1581087 (bg #48 + 6176)
  32768 free blocks, 32768 free inodes, 0 directories
  Free blocks: 1671168-1703935
  Free inodes: 1671169-1703936
Group 52: (Blocks 1703936-1736703)
  Block bitmap at 1572868 (bg #48 + 4), Inode bitmap at 1572884 (bg #48 + 20)
  Inode table at 1581088-1583135 (bg #48 + 8224)
  32768 free blocks, 32768 free inodes, 0 directories
  Free blocks: 1703936-1736703
  Free inodes: 1703937-1736704
Group 53: (Blocks 1736704-1769471)
  Block bitmap at 1572869 (bg #48 + 5), Inode bitmap at 1572885 (bg #48 + 21)
  Inode table at 1583136-1585183 (bg #48 + 10272)
  32768 free blocks, 32768 free inodes, 0 directories
  Free blocks: 1736704-1769471
  Free inodes: 1736705-1769472
Group 54: (Blocks 1769472-1802239)
  Block bitmap at 1572870 (bg #48 + 6), Inode bitmap at 1572886 (bg #48 + 22)
  Inode table at 1585184-1587231 (bg #48 + 12320)
  32768 free blocks, 32768 free inodes, 0 directories
  Free blocks: 1769472-1802239
  Free inodes: 1769473-1802240
Group 55: (Blocks 1802240-1835007)
  Block bitmap at 1572871 (bg #48 + 7), Inode bitmap at 1572887 (bg #48 + 23)
  Inode table at 1587232-1589279 (bg #48 + 14368)
  32768 free blocks, 32768 free inodes, 0 directories
  Free blocks: 1802240-1835007
  Free inodes: 1802241-1835008
Group 56: (Blocks 1835008-1867775)
  Block bitmap at 1572872 (bg #48 + 8), Inode bitmap at 1572888 (bg #48 + 24)
  Inode table at 1589280-1591327 (bg #48 + 16416)
  32768 free blocks, 32768 free inodes, 0 directories
  Free blocks: 1835008-1867775
  Free inodes: 1835009-1867776
Group 57: (Blocks 1867776-1900543)
  Block bitmap at 1572873 (bg #48 + 9), Inode bitmap at 1572889 (bg #48 + 25)
  Inode table at 1591328-1593375 (bg #48 + 18464)
  32768 free blocks, 32768 free inodes, 0 directories
  Free blocks: 1867776-1900543
  Free inodes: 1867777-1900544
Group 58: (Blocks 1900544-1933311)
  Block bitmap at 1572874 (bg #48 + 10), Inode bitmap at 1572890 (bg #48 + 26)
  Inode table at 1593376-1595423 (bg #48 + 20512)
  32768 free blocks, 32768 free inodes, 0 directories
  Free blocks: 1900544-1933311
  Free inodes: 1900545-1933312
Group 59: (Blocks 1933312-1966079)
  Block bitmap at 1572875 (bg #48 + 11), Inode bitmap at 1572891 (bg #48 + 27)
  Inode table at 1595424-1597471 (bg #48 + 22560)
  32768 free blocks, 32768 free inodes, 0 directories
  Free blocks: 1933312-1966079
  Free inodes: 1933313-1966080
Group 60: (Blocks 1966080-1998847)
  Block bitmap at 1572876 (bg #48 + 12), Inode bitmap at 1572892 (bg #48 + 28)
  Inode table at 1597472-1599519 (bg #48 + 24608)
  32768 free blocks, 32768 free inodes, 0 directories
  Free blocks: 1966080-1998847
  Free inodes: 1966081-1998848
Group 61: (Blocks 1998848-2031615)
  Block bitmap at 1572877 (bg #48 + 13), Inode bitmap at 1572893 (bg #48 + 29)
  Inode table at 1599520-1601567 (bg #48 + 26656)
  32768 free blocks, 32768 free inodes, 0 directories
  Free blocks: 1998848-2031615
  Free inodes: 1998849-2031616
Group 62: (Blocks 2031616-2064383)
  Block bitmap at 1572878 (bg #48 + 14), Inode bitmap at 1572894 (bg #48 + 30)
  Inode table at 1601568-1603615 (bg #48 + 28704)
  32768 free blocks, 32768 free inodes, 0 directories
  Free blocks: 2031616-2064383
  Free inodes: 2031617-2064384
Group 63: (Blocks 2064384-2097151)
  Block bitmap at 1572879 (bg #48 + 15), Inode bitmap at 1572895 (bg #48 + 31)
  Inode table at 1603616-1605663 (bg #48 + 30752)
  32768 free blocks, 32768 free inodes, 0 directories
  Free blocks: 2064384-2097151
  Free inodes: 2064385-2097152
Group 64: (Blocks 2097152-2129919)
  Block bitmap at 2097152 (+0), Inode bitmap at 2097168 (+16)
  Inode table at 2097184-2099231 (+32)
  2016 free blocks, 32768 free inodes, 0 directories
  Free blocks: 2127904-2129919
  Free inodes: 2097153-2129920
Group 65: (Blocks 2129920-2162687)
  Block bitmap at 2097153 (bg #64 + 1), Inode bitmap at 2097169 (bg #64 + 17)
  Inode table at 2099232-2101279 (bg #64 + 2080)
  30720 free blocks, 32768 free inodes, 0 directories
  Free blocks: 2129920-2162687
  Free inodes: 2129921-2162688
Group 66: (Blocks 2162688-2195455)
  Block bitmap at 2097154 (bg #64 + 2), Inode bitmap at 2097170 (bg #64 + 18)
  Inode table at 2101280-2103327 (bg #64 + 4128)
  32768 free blocks, 32768 free inodes, 0 directories
  Free blocks: 2162688-2195455
  Free inodes: 2162689-2195456
Group 67: (Blocks 2195456-2228223)
  Block bitmap at 2097155 (bg #64 + 3), Inode bitmap at 2097171 (bg #64 + 19)
  Inode table at 2103328-2105375 (bg #64 + 6176)
  32768 free blocks, 32768 free inodes, 0 directories
  Free blocks: 2195456-2228223
  Free inodes: 2195457-2228224
Group 68: (Blocks 2228224-2260991)
  Block bitmap at 2097156 (bg #64 + 4), Inode bitmap at 2097172 (bg #64 + 20)
  Inode table at 2105376-2107423 (bg #64 + 8224)
  32768 free blocks, 32768 free inodes, 0 directories
  Free blocks: 2228224-2260991
  Free inodes: 2228225-2260992
Group 69: (Blocks 2260992-2293759)
  Block bitmap at 2097157 (bg #64 + 5), Inode bitmap at 2097173 (bg #64 + 21)
  Inode table at 2107424-2109471 (bg #64 + 10272)
  32768 free blocks, 32768 free inodes, 0 directories
  Free blocks: 2260992-2293759
  Free inodes: 2260993-2293760
Group 70: (Blocks 2293760-2326527)
  Block bitmap at 2097158 (bg #64 + 6), Inode bitmap at 2097174 (bg #64 + 22)
  Inode table at 2109472-2111519 (bg #64 + 12320)
  32768 free blocks, 32768 free inodes, 0 directories
  Free blocks: 2293760-2326527
  Free inodes: 2293761-2326528
Group 71: (Blocks 2326528-2359295)
  Block bitmap at 2097159 (bg #64 + 7), Inode bitmap at 2097175 (bg #64 + 23)
  Inode table at 2111520-2113567 (bg #64 + 14368)
  32768 free blocks, 32768 free inodes, 0 directories
  Free blocks: 2326528-2359295
  Free inodes: 2326529-2359296
Group 72: (Blocks 2359296-2392063)
  Block bitmap at 2097160 (bg #64 + 8), Inode bitmap at 2097176 (bg #64 + 24)
  Inode table at 2113568-2115615 (bg #64 + 16416)
  32768 free blocks, 32768 free inodes, 0 directories
  Free blocks: 2359296-2392063
  Free inodes: 2359297-2392064
Group 73: (Blocks 2392064-2424831)
  Block bitmap at 2097161 (bg #64 + 9), Inode bitmap at 2097177 (bg #64 + 25)
  Inode table at 2115616-2117663 (bg #64 + 18464)
  32768 free blocks, 32768 free inodes, 0 directories
  Free blocks: 2392064-2424831
  Free inodes: 2392065-2424832
Group 74: (Blocks 2424832-2457599)
  Block bitmap at 2097162 (bg #64 + 10), Inode bitmap at 2097178 (bg #64 + 26)
  Inode table at 2117664-2119711 (bg #64 + 20512)
  32768 free blocks, 32768 free inodes, 0 directories
  Free blocks: 2424832-2457599
  Free inodes: 2424833-2457600
Group 75: (Blocks 2457600-2490367)
  Block bitmap at 2097163 (bg #64 + 11), Inode bitmap at 2097179 (bg #64 + 27)
  Inode table at 2119712-2121759 (bg #64 + 22560)
  32768 free blocks, 32768 free inodes, 0 directories
  Free blocks: 2457600-2490367
  Free inodes: 2457601-2490368
Group 76: (Blocks 2490368-2523135)
  Block bitmap at 2097164 (bg #64 + 12), Inode bitmap at 2097180 (bg #64 + 28)
  Inode table at 2121760-2123807 (bg #64 + 24608)
  32768 free blocks, 32768 free inodes, 0 directories
  Free blocks: 2490368-2523135
  Free inodes: 2490369-2523136
Group 77: (Blocks 2523136-2555903)
  Block bitmap at 2097165 (bg #64 + 13), Inode bitmap at 2097181 (bg #64 + 29)
  Inode table at 2123808-2125855 (bg #64 + 26656)
  32768 free blocks, 32768 free inodes, 0 directories
  Free blocks: 2523136-2555903
  Free inodes: 2523137-2555904
Group 78: (Blocks 2555904-2588671)
  Block bitmap at 2097166 (bg #64 + 14), Inode bitmap at 2097182 (bg #64 + 30)
  Inode table at 2125856-2127903 (bg #64 + 28704)
  32768 free blocks, 32768 free inodes, 0 directories
  Free blocks: 2555904-2588671
  Free inodes: 2555905-2588672
Group 79: (Blocks 2588672-2621439)
  Block bitmap at 2097167 (bg #64 + 15), Inode bitmap at 2097183 (bg #64 + 31)
  Inode table at 2129920-2131967 (bg #65 + 0)
  32768 free blocks, 32768 free inodes, 0 directories
  Free blocks: 2588672-2621439
  Free inodes: 2588673-2621440
Group 80: (Blocks 2621440-2654207)
  Block bitmap at 2621440 (+0), Inode bitmap at 2621443 (+3)
  Inode table at 2621446-2623493 (+6)
  26618 free blocks, 32768 free inodes, 0 directories
  Free blocks: 2627590-2654207
  Free inodes: 2621441-2654208
Group 81: (Blocks 2654208-2686975)
  Backup superblock at 2654208, Group descriptors at 2654209-2654209
  Reserved GDT blocks at 2654210-2654528
  Block bitmap at 2621441 (bg #80 + 1), Inode bitmap at 2621444 (bg #80 + 4)
  Inode table at 2623494-2625541 (bg #80 + 2054)
  32447 free blocks, 32768 free inodes, 0 directories
  Free blocks: 2654529-2686975
  Free inodes: 2654209-2686976
Group 82: (Blocks 2686976-2707455)
  Block bitmap at 2621442 (bg #80 + 2), Inode bitmap at 2621445 (bg #80 + 5)
  Inode table at 2625542-2627589 (bg #80 + 4102)
  20480 free blocks, 32768 free inodes, 0 directories
  Free blocks: 2686976-2707455
  Free inodes: 2686977-2719744

The /tmp is on a LVM which I had resized, and done a resize2fs online
and that's when
I had the trouble.  Basically I was compiling stuff and /tmp hit 100%,
so I did this:

lvextend -l +100%FREE /dev/blsvg/tmp
   (that added about 5GB to the existing 5GB giving a total of 10GB
for /dev/blsvg/tmp)
resize2fs /dev/blsvg/tmp
df -h
  (showed some size negative terrabytes, so I figured something bad happened)
umount /tmp
e2fsck -vfDC0 /dev/blsvg/tmp

That didn't work. so tried just

e2fsck -v -f /dev/blsvg/tmp

Still got the errors, so mounted /tmp again to copy off the files,
then unmounted and tried e2fsck without any luck.  So did the dumpe2fs
and sent this email.

The machine is in a QEMU 1.4 virtual machine if that matters, using
this command line:

qemu-system-x86_64 -enable-kvm -vga cirrus \
   -cpu Nehalem -smp 8,cores=4,threads=2,sockets=1 -m 8192 \
   -vnc :0,password,tls -monitor stdio -localtime \
   -usb -usbdevice mouse -usbdevice keyboard \
   -net nic,vlan=0,model=virtio,macaddr=DE:AD:BE:EF:24:22 \
   -net tap,ifname=tap0,script=/etc/qemu-ifup,downscript=/etc/qemu-ifdown \
   -name VM0 \
   -drive file=/dev/mapper/vmland-vmdisk0,if=virtio \
   -boot order=c,menu=on -nodefaults

The host machine also runs vanilla 3.7.8 kernel.  I'm sure I did
something stupid, but I was kind of hoping e2fsck could fix it.

JGH
