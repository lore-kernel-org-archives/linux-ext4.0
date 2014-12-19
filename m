From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89511] USB-storage mount error
Date: Fri, 19 Dec 2014 08:36:58 +0000
Message-ID: <bug-89511-13602-Jge4UIgF1Q@https.bugzilla.kernel.org/>
References: <bug-89511-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:42420 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821AbaLSIhE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Dec 2014 03:37:04 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A10B72013A
	for <linux-ext4@vger.kernel.org>; Fri, 19 Dec 2014 08:37:02 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id DD13A20138
	for <linux-ext4@vger.kernel.org>; Fri, 19 Dec 2014 08:36:58 +0000 (UTC)
In-Reply-To: <bug-89511-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89511

--- Comment #8 from Jun Itou <itou_jun@infoseek.jp> ---
Linux sv-server 3.2.0-4-amd64 #1 SMP Debian 3.2.63-2+deb7u2 x86_64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
Last login: Fri Dec 19 15:49:19 2014
root@sv-server:~# uname -a
Linux sv-server 3.2.0-4-amd64 #1 SMP Debian 3.2.63-2+deb7u2 x86_64 GNU/Linux
root@sv-server:~# dmesg
[  645.276542] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[  645.796524] usb 1-1: New USB device found, idVendor=04bb, idProduct=0109
[  645.796527] usb 1-1: New USB device strings: Mfr=1, Product=2,
SerialNumber=3
[  645.796529] usb 1-1: Product: I-O DATA HDZ-UES
[  645.796531] usb 1-1: Manufacturer: I-O DATA DEVICE INC.
[  645.796532] usb 1-1: SerialNumber: 0000000042A4
[  645.882473] Initializing USB Mass Storage driver...
[  645.883167] scsi3 : usb-storage 1-1:1.0
[  645.883322] usbcore: registered new interface driver usb-storage
[  645.883324] USB Mass Storage support registered.
[  646.884168] scsi 3:0:0:0: Direct-Access     I-O DATA HDZ-UE1.0TS      6706
PQ: 0 ANSI: 0 CCS
[  646.887386] sd 3:0:0:0: Attached scsi generic sg2 type 0
[  646.889095] sd 3:0:0:0: [sdb] 1953588672 512-byte logical blocks: (1.00
TB/931 GiB)
[  646.894571] sd 3:0:0:0: [sdb] Write Protect is off
[  646.894573] sd 3:0:0:0: [sdb] Mode Sense: 34 00 00 00
[  646.900113] sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled,
doesn't support DPO or FUA
[  646.930078]  sdb: sdb1
[  646.955000] sd 3:0:0:0: [sdb] Attached SCSI disk
[  662.278480] EXT4-fs warning (device sdb1): ext4_clear_journal_err:4372:
Filesystem error recorded from previous mount: IO failure
[  662.278483] EXT4-fs warning (device sdb1): ext4_clear_journal_err:4373:
Marking fs in need of filesystem check.
[  662.282419] EXT4-fs (sdb1): warning: mounting fs with errors, running e2fsck
is recommended
[  662.338997] EXT4-fs (sdb1): recovery complete
[  662.340632] EXT4-fs (sdb1): mounted filesystem with ordered data mode. Opts:
(null)
[  663.594301] end_request: I/O error, dev sdb, sector 0
[  669.228566] end_request: I/O error, dev sdb, sector 973342744
[  669.228815] Aborting journal on device sdb1-8.
[  669.291432] EXT4-fs error (device sdb1): ext4_journal_start_sb:327: Detected
aborted journal
[  669.291752] EXT4-fs (sdb1): Remounting filesystem read-only
[  962.263034] EXT4-fs (sdb1): error count since last fsck: 5
[  962.263041] EXT4-fs (sdb1): initial error at time 1418959480:
ext4_journal_check_start:56
[  962.263044] EXT4-fs (sdb1): last error at time 1418971964:
ext4_journal_start_sb:327
root@sv-server:~# mount -t debugfs none_debugs /sys/kernel/debug
root@sv-server:~# modprobe usbmon
root@sv-server:~# ls /sys/kernel/debug/usb/usbmon
0s  0u  1s  1t  1u  2s  2t  2u
root@sv-server:~# cat /sys/kernel/debug/usb/devices

T:  Bus=02 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12   MxCh= 2
B:  Alloc=  0/900 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1d6b ProdID=0001 Rev= 3.02
S:  Manufacturer=Linux 3.2.0-4-amd64 uhci_hcd
S:  Product=UHCI Host Controller
S:  SerialNumber=0000:02:00.0
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=255ms

T:  Bus=02 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=12   MxCh= 0
D:  Ver= 1.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
P:  Vendor=0e0f ProdID=0003 Rev= 1.03
S:  Manufacturer=VMware
S:  Product=VMware Virtual USB Mouse
C:* #Ifs= 1 Cfg#= 1 Atr=c0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=01 Prot=02 Driver=usbhid
E:  Ad=81(I) Atr=03(Int.) MxPS=   8 Ivl=1ms

T:  Bus=02 Lev=01 Prnt=01 Port=01 Cnt=02 Dev#=  3 Spd=12   MxCh= 7
D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
P:  Vendor=0e0f ProdID=0002 Rev= 1.00
S:  Product=VMware Virtual USB Hub
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   1 Ivl=255ms

T:  Bus=01 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=480  MxCh= 6
B:  Alloc=  0/800 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 2.00 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1d6b ProdID=0002 Rev= 3.02
S:  Manufacturer=Linux 3.2.0-4-amd64 ehci_hcd
S:  Product=EHCI Host Controller
S:  SerialNumber=0000:02:03.0
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=256ms

T:  Bus=01 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=480  MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=04bb ProdID=0109 Rev= 1.00
S:  Manufacturer=I-O DATA DEVICE INC.
S:  Product=I-O DATA HDZ-UES
S:  SerialNumber=0000000042A4
C:* #Ifs= 1 Cfg#= 1 Atr=c0 MxPwr= 98mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=08(stor.) Sub=06 Prot=50 Driver=usb-storage
E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=125us
root@sv-server:~# lsusb
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 002 Device 002: ID 0e0f:0003 VMware, Inc. Virtual Mouse
Bus 002 Device 003: ID 0e0f:0002 VMware, Inc. Virtual USB Hub
Bus 001 Device 002: ID 04bb:0109 I-O Data Device, Inc.
root@sv-server:~# cat /sys/kernel/debug/usb/usbmon/1u > 1.mon.out
^C
root@sv-server:~# cat /sys/kernel/debug/usb/usbmon/1u > 1.mon.out

Message from syslogd@sv-server at Dec 19 17:26:46 ...
 kernel:[ 6298.057033] journal commit I/O error
^C
root@sv-server:~# cat /sys/kernel/debug/usb/usbmon/0u > 0.mon.out

Message from syslogd@sv-server at Dec 19 17:28:18 ...
 kernel:[ 6390.384914] journal commit I/O error
^C

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
