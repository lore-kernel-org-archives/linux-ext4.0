From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89511] USB-storage mount error
Date: Wed, 10 Dec 2014 22:51:36 +0000
Message-ID: <bug-89511-13602-FDLQn9Psaj@https.bugzilla.kernel.org/>
References: <bug-89511-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:45624 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933447AbaLJWvl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Dec 2014 17:51:41 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 5852A201C8
	for <linux-ext4@vger.kernel.org>; Wed, 10 Dec 2014 22:51:38 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 31E182012B
	for <linux-ext4@vger.kernel.org>; Wed, 10 Dec 2014 22:51:37 +0000 (UTC)
In-Reply-To: <bug-89511-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=3D89511

--- Comment #3 from Jun Itou <itou_jun@infoseek.jp> ---
Because it occurs in Debian7.7 and Fedora20, I think this symptom to be=
 a
problem of kernel.
I confirm that I do the same operation in the following devices and rea=
ppear.

 I-O DATA HDZ-UE2.0TS
 I-O DATA HDZ-UE1.0TS
 I-O DATA HDZ-UE1.0TS
 I-O DATA HDW-UE

I was as follows in Fedora20.

[root@localhost ~]# uname -a
Linux localhost.localdomain 3.17.4-200.fc20.i686+PAE #1 SMP Fri Nov 21 =
23:45:26
UTC 2014 i686 i686 i386 GNU/Linux
[root@localhost ~]# fdisk /dev/sdc

Welcome to fdisk (util-linux 2.24.2).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.


=E3=82=B3=E3=83=9E=E3=83=B3=E3=83=89 (m =E3=81=A7=E3=83=98=E3=83=AB=E3=83=
=97): p
Disk /dev/sdc: 931.5 GiB, 1000215724032 bytes, 1953546336 sectors
Units: sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x79ccabc6

=E3=83=87=E3=83=90=E3=82=A4=E3=82=B9  =E3=83=96=E3=83=BC=E3=83=88 Start=
 =E6=9C=80=E5=BE=8C=E3=81=8B=E3=82=89    Blocks  Id System
/dev/sdc1         2048 1953546335 976772144  83 Linux

=E3=82=B3=E3=83=9E=E3=83=B3=E3=83=89 (m =E3=81=A7=E3=83=98=E3=83=AB=E3=83=
=97): d

Selected partition 1
Partition 1 has been deleted.

=E3=82=B3=E3=83=9E=E3=83=B3=E3=83=89 (m =E3=81=A7=E3=83=98=E3=83=AB=E3=83=
=97): p
Disk /dev/sdc: 931.5 GiB, 1000215724032 bytes, 1953546336 sectors
Units: sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x79ccabc6


=E3=82=B3=E3=83=9E=E3=83=B3=E3=83=89 (m =E3=81=A7=E3=83=98=E3=83=AB=E3=83=
=97): n

Partition type:
   p   primary (0 primary, 0 extended, 4 free)
   e   extended
Select (default p):=20

Using default response p.
=E3=83=91=E3=83=BC=E3=83=86=E3=82=A3=E3=82=B7=E3=83=A7=E3=83=B3=E7=95=AA=
=E5=8F=B7 (1-4, default 1):=20
=46irst sector (2048-1953546335, default 2048):=20
Last sector, +sectors or +size{K,M,G,T,P} (2048-1953546335, default
1953546335):=20

Created a new partition 1 of type 'Linux' and of size 931.5 GiB.

=E3=82=B3=E3=83=9E=E3=83=B3=E3=83=89 (m =E3=81=A7=E3=83=98=E3=83=AB=E3=83=
=97): p
Disk /dev/sdc: 931.5 GiB, 1000215724032 bytes, 1953546336 sectors
Units: sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x79ccabc6

=E3=83=87=E3=83=90=E3=82=A4=E3=82=B9  =E3=83=96=E3=83=BC=E3=83=88 Start=
 =E6=9C=80=E5=BE=8C=E3=81=8B=E3=82=89    Blocks  Id System
/dev/sdc1         2048 1953546335 976772144  83 Linux

=E3=82=B3=E3=83=9E=E3=83=B3=E3=83=89 (m =E3=81=A7=E3=83=98=E3=83=AB=E3=83=
=97): w

The partition table has been altered.
Calling ioctl() to re-read partition table.
/dev/sdc: close device failed: =E9=81=A0=E9=9A=94I/O=E3=82=A8=E3=83=A9=E3=
=83=BC=E3=81=A7=E3=81=99

[root@localhost ~]# dmesg
[11378.635292]  sdb: sdb1
[11378.644515] end_request: critical target error, dev sdb, sector 0
[11505.048965]  sdc: sdc1
[11505.070962] end_request: critical target error, dev sdc, sector 0
[12323.199222] usb 1-2: USB disconnect, device number 3
[12323.204864] sd 4:0:0:0: [sdc] Synchronizing SCSI cache
[12323.204969] sd 4:0:0:0: [sdc] =20
[12323.205036] Result: hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVER_OK
[12328.983064] usb 1-2: new high-speed USB device number 4 using ehci-p=
ci
[12329.254305] usb 1-2: New USB device found, idVendor=3D04bb, idProduc=
t=3D0106
[12329.254310] usb 1-2: New USB device strings: Mfr=3D1, Product=3D2,
SerialNumber=3D3
[12329.254312] usb 1-2: Product: I-O DATA HDW-UE
[12329.254317] usb 1-2: Manufacturer: I-O DATA DEVICE,INC.
[12329.254319] usb 1-2: SerialNumber: 0000000015B4
[12329.256556] usb-storage 1-2:1.0: USB Mass Storage device detected
[12329.256668] scsi host5: usb-storage 1-2:1.0
[12330.306516] usb 1-1: USB disconnect, device number 2
[12330.311660] sd 3:0:0:0: [sdb] Synchronizing SCSI cache
[12330.311947] sd 3:0:0:0: [sdb] =20
[12330.311959] Result: hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVER_OK
[12335.938510] usb 1-1: new high-speed USB device number 5 using ehci-p=
ci
[12336.197402] usb 1-1: New USB device found, idVendor=3D04bb, idProduc=
t=3D0109
[12336.197408] usb 1-1: New USB device strings: Mfr=3D1, Product=3D2,
SerialNumber=3D3
[12336.197411] usb 1-1: Product: I-O DATA HDZ-UES
[12336.197413] usb 1-1: Manufacturer: I-O DATA DEVICE INC.
[12336.197416] usb 1-1: SerialNumber: 0000000042A4
[12336.200728] usb-storage 1-1:1.0: USB Mass Storage device detected
[12336.202401] scsi host6: usb-storage 1-1:1.0
[12338.413255] scsi 5:0:0:0: Direct-Access     I-O DATA HDW-UE         =
  0100
PQ: 0 ANSI: 2
[12338.414954] sd 5:0:0:0: Attached scsi generic sg2 type 0
[12338.418619] sd 5:0:0:0: [sdb] 1953546336 512-byte logical blocks: (1=
=2E00
TB/931 GiB)
[12338.424650] sd 5:0:0:0: [sdb] Write Protect is off
[12338.424654] sd 5:0:0:0: [sdb] Mode Sense: 53 00 00 08
[12338.430284] sd 5:0:0:0: [sdb] Write cache: enabled, read cache: enab=
led,
doesn't support DPO or FUA
[12338.457232]  sdb: sdb1
[12338.476721] sd 5:0:0:0: [sdb] Attached SCSI disk
[12338.739881] scsi 6:0:0:0: Direct-Access     I-O DATA HDZ-UE1.0TS    =
  6706
PQ: 0 ANSI: 0 CCS
[12338.740452] sd 6:0:0:0: Attached scsi generic sg3 type 0
[12338.743802] sd 6:0:0:0: [sdc] 1953588672 512-byte logical blocks: (1=
=2E00
TB/931 GiB)
[12338.750306] sd 6:0:0:0: [sdc] Write Protect is off
[12338.750310] sd 6:0:0:0: [sdc] Mode Sense: 34 00 00 00
[12338.757360] sd 6:0:0:0: [sdc] Write cache: enabled, read cache: enab=
led,
doesn't support DPO or FUA
[12338.786386]  sdc: sdc1
[12338.807891] sd 6:0:0:0: [sdc] Attached SCSI disk
[root@localhost ~]# unamae -a
Linux localhost.localdomain 3.17.4-200.fc20.i686+PAE #1 SMP Fri Nov 21 =
23:45:26
UTC 2014 i686 i686 i386 GNU/Linux
[root@localhost ~]# halt

--=20
You are receiving this mail because:
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
