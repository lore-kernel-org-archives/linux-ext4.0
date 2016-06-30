From: =?utf-8?B?VG9tw6HFoQ==?= Trnka <ttrnka@mail.muni.cz>
Subject: Corrupted inode timestamps on v4.4+?
Date: Thu, 30 Jun 2016 13:35:18 +0200
Message-ID: <1690728.35imogO4tp@mintaka.ncbr.muni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from arethusa2.fi.muni.cz ([147.251.49.7]:57493 "EHLO
	arethusa2.fi.muni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbcF3Lnr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Jun 2016 07:43:47 -0400
Received: from mintaka.ncbr.muni.cz (mintaka.ncbr.muni.cz [147.251.90.24])
	by arethusa2.fi.muni.cz (Postfix) with ESMTPSA id 1843C1E0F12
	for <linux-ext4@vger.kernel.org>; Thu, 30 Jun 2016 13:35:19 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

I have noticed some files on my workstation home FS (ext4) having very=20
suspicious timestamp values. This has probably started happening in Apr=
il when=20
the machine was running v4.4.3, but the last occurence is from a week a=
go on=20
v4.5.6.

The corruption looks like nonsensical atime and/or mtime seconds values=
 (see=20
below). At the same time, the nanosecond portion of a corrupted time is=
 always=20
zero. In fact, the nanoseconds for mtime are all zeros for all of the a=
ffected=20
files, even if the seconds part of mtime looks OK.

I can't confidently claim this is an ext4 bug, but it seems likely (the=
re were=20
no HW failures, power cuts, oopses etc. and fsck found no errors). I wo=
uld be=20
glad to debug this further, but currently I have no idea how to reprodu=
ce the=20
corruption. Any hints are welcome.

Best regards,
Tom=C3=A1=C5=A1 Trnka

debugfs:  stat Administrace/pip/pip-krb5-storage.pcap =20
Inode: 38933641   Type: regular    Mode:  0644   Flags: 0x80000=20
Generation: 2251791665    Version: 0x00000000:00000001=20
User: 395845   Group:  2001   Size: 802806=20
=46ile ACL: 0    Directory ACL: 0=20
Links: 1   Blockcount: 1568=20
=46ragment:  Address: 0    Number: 0    Size: 0=20
ctime: 0x572335f2:32d79df0 -- Fri Apr 29 12:22:42 2016=20
atime: 0xf9b65000:00000000 -- Thu Oct  5 09:00:16 2102=20
mtime: 0x57233597:00000000 -- Fri Apr 29 12:21:11 2016=20
crtime: 0x572335f2:1d9f6f84 -- Fri Apr 29 12:22:42 2016=20
Size of extra inode fields: 32=20
Extended attributes stored in inode body: =20
 selinux =3D "unconfined_u:object_r:user_home_t:s0\000" (37)=20
EXTENTS:=20
(0-195):155943077-155943272=20

debugfs:  inode_dump Administrace/pip/pip-krb5-storage.pcap=20
0000  a481 450a f63f 0c00 0050 b6f9 f235 2357  ..E..?...P...5#W=20
0020  9735 2357 0000 0000 d107 0100 2006 0000  .5#W........ ...=20
0040  0000 0800 0100 0000 0af3 0100 0400 0000  ................=20
0060  0000 0000 0000 0000 c400 0000 a580 4b09  ..............K.=20
0100  0000 0000 0000 0000 0000 0000 0000 0000  ................=20
*=20
0140  0000 0000 319d 3786 0000 0000 0000 0000  ....1.7.........=20
0160  0000 0000 0000 0000 0600 0000 0000 0000  ................=20
0200  2000 0000 f09d d732 0000 0000 0000 0000   ......2........=20
0220  f235 2357 846f 9f1d 0000 0000 0000 0000  .5#W.o..........=20
0240  0000 02ea 0706 3400 0000 0000 2500 0000  ......4.....%...=20
0260  0000 0000 7365 6c69 6e75 7800 0000 0000  ....selinux.....=20
0300  0000 0000 0000 0000 0000 0000 0000 0000  ................=20
0320  0000 0000 0000 0000 756e 636f 6e66 696e  ........unconfin=20
0340  6564 5f75 3a6f 626a 6563 745f 723a 7573  ed_u:object_r:us=20
0360  6572 5f68 6f6d 655f 743a 7330 0000 0000  er_home_t:s0....=20

debugfs:  stat tmp/RDP-log.csv =20
Inode: 39191637   Type: regular    Mode:  0755   Flags: 0x80000=20
Generation: 2606527817    Version: 0x00000000:00000001=20
User: 395845   Group:  2001   Size: 749186=20
=46ile ACL: 166150131    Directory ACL: 0=20
Links: 1   Blockcount: 1472=20
=46ragment:  Address: 0    Number: 0    Size: 0=20
ctime: 0x53c77ea3:78c876a4 -- Thu Jul 17 09:43:31 2014=20
atime: 0x5773d316:494a0854 -- Wed Jun 29 15:54:30 2016=20
mtime: 0x987df1f8:00000000 -- Fri Jan 27 01:06:16 2051=20
crtime: 0x53c77ea0:4e193034 -- Thu Jul 17 09:43:28 2014=20
Size of extra inode fields: 32=20
EXTENTS:=20
(0-182):11657216-11657398=20

debugfs:  inode_dump tmp/RDP-log.csv=20
0000  ed81 450a 826e 0b00 16d3 7357 a37e c753  ..E..n....sW.~.S=20
0020  f8f1 7d98 0000 0000 d107 0100 c005 0000  ..}.............=20
0040  0000 0800 0100 0000 0af3 0100 0400 0000  ................=20
0060  0000 0000 0000 0000 b700 0000 00e0 b100  ................=20
0100  0000 0000 0000 0000 0000 0000 0000 0000  ................=20
*=20
0140  0000 0000 4975 5c9b f33f e709 0000 0000  ....Iu\..?......=20
0160  0000 0000 0000 0000 0600 0000 0000 0000  ................=20
0200  2000 0000 a476 c878 0000 0000 5408 4a49   ....v.x....T.JI=20
0220  a07e c753 3430 194e 0000 0000 0000 0000  .~.S40.N........=20
0240  0000 0000 0000 0000 0000 0000 0000 0000  ................=20
*=20

debugfs:  stat openmpi/kraken16.xml =20
Inode: 48117428   Type: regular    Mode:  0640   Flags: 0x80000=20
Generation: 3888286010    Version: 0x00000000:00000001=20
User: 395845   Group:  2001   Size: 32693=20
=46ile ACL: 0    Directory ACL: 0=20
Links: 1   Blockcount: 64=20
=46ragment:  Address: 0    Number: 0    Size: 0=20
ctime: 0x5763eb3c:45901c0c -- Fri Jun 17 14:21:16 2016=20
atime: 0x82779900:00000000 -- Fri May 13 07:07:12 2039=20
mtime: 0x5763eb07:00000000 -- Fri Jun 17 14:20:23 2016=20
crtime: 0x5763eb3c:42b3ae24 -- Fri Jun 17 14:21:16 2016=20
Size of extra inode fields: 32=20
Extended attributes stored in inode body: =20
 selinux =3D "unconfined_u:object_r:user_home_t:s0\000" (37)=20
EXTENTS:=20
(0-7):192521632-192521639

debugfs:  inode_dump openmpi/kraken16.xml =20
0000  a081 450a b57f 0000 0099 7782 3ceb 6357  ..E.......w.<.cW=20
0020  07eb 6357 0000 0000 d107 0100 4000 0000  ..cW........@...=20
0040  0000 0800 0100 0000 0af3 0100 0400 0000  ................=20
0060  0000 0000 0000 0000 0800 0000 a0a5 790b  ..............y.=20
0100  0000 0000 0000 0000 0000 0000 0000 0000  ................=20
*=20
0140  0000 0000 3a89 c2e7 0000 0000 0000 0000  ....:...........=20
0160  0000 0000 0000 0000 0600 0000 0000 0000  ................=20
0200  2000 0000 0c1c 9045 0000 0000 0000 0000   ......E........=20
0220  3ceb 6357 24ae b342 0000 0000 0000 0000  <.cW$..B........=20
0240  0000 02ea 0706 3400 0000 0000 2500 0000  ......4.....%...=20
0260  0000 0000 7365 6c69 6e75 7800 0000 0000  ....selinux.....=20
0300  0000 0000 0000 0000 0000 0000 0000 0000  ................=20
0320  0000 0000 0000 0000 756e 636f 6e66 696e  ........unconfin=20
0340  6564 5f75 3a6f 626a 6563 745f 723a 7573  ed_u:object_r:us=20
0360  6572 5f68 6f6d 655f 743a 7330 0000 0000  er_home_t:s0....


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
