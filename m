From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89511] USB-storage mount error
Date: Fri, 12 Dec 2014 13:01:21 +0000
Message-ID: <bug-89511-13602-E6CHOLGBty@https.bugzilla.kernel.org/>
References: <bug-89511-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:57380 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967589AbaLLNBm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Dec 2014 08:01:42 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 9C8232020E
	for <linux-ext4@vger.kernel.org>; Fri, 12 Dec 2014 13:01:37 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 1802520172
	for <linux-ext4@vger.kernel.org>; Fri, 12 Dec 2014 13:01:22 +0000 (UTC)
In-Reply-To: <bug-89511-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=3D89511

--- Comment #6 from Jun Itou <itou_jun@infoseek.jp> ---
(In reply to Alan Stern from comment #5)
> Please attach a usbmon trace showing what happens when the device is =
plugged
> in and the problem occurs (see Documentation/usb/usbmon.txt for
> instructions).

Is it all right in the following?

root@sv-server:~# dmesg
[   66.354400] usb 2-1: new high-speed USB device number 2 using ehci-p=
ci
[   66.872687] usb 2-1: New USB device found, idVendor=3D04bb, idProduc=
t=3D0109
[   66.872692] usb 2-1: New USB device strings: Mfr=3D1, Product=3D2,
SerialNumber=3D3
[   66.872694] usb 2-1: Product: I-O DATA HDZ-UES
[   66.872696] usb 2-1: Manufacturer: I-O DATA DEVICE INC.
[   66.872697] usb 2-1: SerialNumber: 0000000075A7
[   66.918835] usb-storage 2-1:1.0: USB Mass Storage device detected
[   66.919257] scsi host3: usb-storage 2-1:1.0
[   66.919415] usbcore: registered new interface driver usb-storage
[   67.922875] scsi 3:0:0:0: Direct-Access     I-O DATA HDZ-UE2.0TS    =
  6706
PQ: 0 ANSI: 0 CCS
[   67.923683] sd 3:0:0:0: Attached scsi generic sg2 type 0
[   67.926839] sd 3:0:0:0: [sdb] 3907092672 512-byte logical blocks: (2=
=2E00
TB/1.81 TiB)
[   67.932319] sd 3:0:0:0: [sdb] Write Protect is off
[   67.932322] sd 3:0:0:0: [sdb] Mode Sense: 34 00 00 00
[   67.937843] sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enab=
led,
doesn't support DPO or FUA
[   67.966004]  sdb: sdb1
[   67.983869] sd 3:0:0:0: [sdb] Attached SCSI disk
[  115.117040] blk_update_request: critical target error, dev sdb, sect=
or 0
[  115.117374] JBD2: recovery failed
[  115.117381] EXT4-fs (sdb1): error loading journal
root@sv-server:~# mount -t debugfs none_debugs /sys/kernel/debug
root@sv-server:~# modprobe usbmon
root@sv-server:~# ls /sys/kernel/debug/usb/usbmon
0s  0u  1s  1t  1u  2s  2t  2u
root@sv-server:~# ls /sys/kernel
boot_params  debug  fscache  fscaps  iommu_groups  kexec_crash_loaded=20
kexec_crash_size  kexec_loaded  mm  notes  profiling  rcu_expedited  se=
curity=20
uevent_helper  uevent_seqnum  vmcoreinfo
root@sv-server:~# cat /proc/bus/usb/devices
cat: /proc/bus/usb/devices: =E3=81=9D=E3=81=AE=E3=82=88=E3=81=86=E3=81=AA=
=E3=83=95=E3=82=A1=E3=82=A4=E3=83=AB=E3=82=84=E3=83=87=E3=82=A3=E3=83=AC=
=E3=82=AF=E3=83=88=E3=83=AA=E3=81=AF=E3=81=82=E3=82=8A=E3=81=BE=E3=81=9B=
=E3=82=93
root@sv-server:~# cat /sys/kernel/debug/usb/devices

T:  Bus=3D02 Lev=3D00 Prnt=3D00 Port=3D00 Cnt=3D00 Dev#=3D  1 Spd=3D480=
  MxCh=3D 6
B:  Alloc=3D  0/800 us ( 0%), #Int=3D  0, #Iso=3D  0
D:  Ver=3D 2.00 Cls=3D09(hub  ) Sub=3D00 Prot=3D00 MxPS=3D64 #Cfgs=3D  =
1
P:  Vendor=3D1d6b ProdID=3D0002 Rev=3D 3.18
S:  Manufacturer=3DLinux 3.18.0 ehci_hcd
S:  Product=3DEHCI Host Controller
S:  SerialNumber=3D0000:02:03.0
C:* #Ifs=3D 1 Cfg#=3D 1 Atr=3De0 MxPwr=3D  0mA
I:* If#=3D 0 Alt=3D 0 #EPs=3D 1 Cls=3D09(hub  ) Sub=3D00 Prot=3D00 Driv=
er=3Dhub
E:  Ad=3D81(I) Atr=3D03(Int.) MxPS=3D   4 Ivl=3D256ms

T:  Bus=3D02 Lev=3D01 Prnt=3D01 Port=3D00 Cnt=3D01 Dev#=3D  2 Spd=3D480=
  MxCh=3D 0
D:  Ver=3D 2.00 Cls=3D00(>ifc ) Sub=3D00 Prot=3D00 MxPS=3D64 #Cfgs=3D  =
1
P:  Vendor=3D04bb ProdID=3D0109 Rev=3D 1.00
S:  Manufacturer=3DI-O DATA DEVICE INC.
S:  Product=3DI-O DATA HDZ-UES
S:  SerialNumber=3D0000000075A7
C:* #Ifs=3D 1 Cfg#=3D 1 Atr=3Dc0 MxPwr=3D 98mA
I:* If#=3D 0 Alt=3D 0 #EPs=3D 2 Cls=3D08(stor.) Sub=3D06 Prot=3D50 Driv=
er=3Dusb-storage
E:  Ad=3D81(I) Atr=3D02(Bulk) MxPS=3D 512 Ivl=3D0ms
E:  Ad=3D02(O) Atr=3D02(Bulk) MxPS=3D 512 Ivl=3D125us

T:  Bus=3D01 Lev=3D00 Prnt=3D00 Port=3D00 Cnt=3D00 Dev#=3D  1 Spd=3D12 =
  MxCh=3D 2
B:  Alloc=3D  0/900 us ( 0%), #Int=3D  0, #Iso=3D  0
D:  Ver=3D 1.10 Cls=3D09(hub  ) Sub=3D00 Prot=3D00 MxPS=3D64 #Cfgs=3D  =
1
P:  Vendor=3D1d6b ProdID=3D0001 Rev=3D 3.18
S:  Manufacturer=3DLinux 3.18.0 uhci_hcd
S:  Product=3DUHCI Host Controller
S:  SerialNumber=3D0000:02:00.0
C:* #Ifs=3D 1 Cfg#=3D 1 Atr=3De0 MxPwr=3D  0mA
I:* If#=3D 0 Alt=3D 0 #EPs=3D 1 Cls=3D09(hub  ) Sub=3D00 Prot=3D00 Driv=
er=3Dhub
E:  Ad=3D81(I) Atr=3D03(Int.) MxPS=3D   2 Ivl=3D255ms

T:  Bus=3D01 Lev=3D01 Prnt=3D01 Port=3D00 Cnt=3D01 Dev#=3D  2 Spd=3D12 =
  MxCh=3D 0
D:  Ver=3D 1.10 Cls=3D00(>ifc ) Sub=3D00 Prot=3D00 MxPS=3D 8 #Cfgs=3D  =
1
P:  Vendor=3D0e0f ProdID=3D0003 Rev=3D 1.03
S:  Manufacturer=3DVMware
S:  Product=3DVMware Virtual USB Mouse
C:* #Ifs=3D 1 Cfg#=3D 1 Atr=3Dc0 MxPwr=3D  0mA
I:* If#=3D 0 Alt=3D 0 #EPs=3D 1 Cls=3D03(HID  ) Sub=3D01 Prot=3D02 Driv=
er=3Dusbhid
E:  Ad=3D81(I) Atr=3D03(Int.) MxPS=3D   8 Ivl=3D1ms

T:  Bus=3D01 Lev=3D01 Prnt=3D01 Port=3D01 Cnt=3D02 Dev#=3D  3 Spd=3D12 =
  MxCh=3D 7
D:  Ver=3D 1.10 Cls=3D09(hub  ) Sub=3D00 Prot=3D00 MxPS=3D 8 #Cfgs=3D  =
1
P:  Vendor=3D0e0f ProdID=3D0002 Rev=3D 1.00
S:  Product=3DVMware Virtual USB Hub
C:* #Ifs=3D 1 Cfg#=3D 1 Atr=3De0 MxPwr=3D  0mA
I:* If#=3D 0 Alt=3D 0 #EPs=3D 1 Cls=3D09(hub  ) Sub=3D00 Prot=3D00 Driv=
er=3Dhub
E:  Ad=3D81(I) Atr=3D03(Int.) MxPS=3D   1 Ivl=3D255ms
root@sv-server:~# cat /sys/kernel/debug/usb/usbmon/3u
cat: /sys/kernel/debug/usb/usbmon/3u: =E3=81=9D=E3=81=AE=E3=82=88=E3=81=
=86=E3=81=AA=E3=83=95=E3=82=A1=E3=82=A4=E3=83=AB=E3=82=84=E3=83=87=E3=82=
=A3=E3=83=AC=E3=82=AF=E3=83=88=E3=83=AA=E3=81=AF=E3=81=82=E3=82=8A=E3=81=
=BE=E3=81=9B=E3=82=93
root@sv-server:~# cat /sys/kernel/debug/usb/usbmon/0u
^C

--=20
You are receiving this mail because:
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
