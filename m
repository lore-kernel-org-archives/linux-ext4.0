From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89511] USB-storage mount error
Date: Fri, 09 Jan 2015 20:56:23 +0000
Message-ID: <bug-89511-13602-EMM47juTPd@https.bugzilla.kernel.org/>
References: <bug-89511-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:44297 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757746AbbAIU41 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 9 Jan 2015 15:56:27 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 64D4C2064B
	for <linux-ext4@vger.kernel.org>; Fri,  9 Jan 2015 20:56:26 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 4EB162063B
	for <linux-ext4@vger.kernel.org>; Fri,  9 Jan 2015 20:56:24 +0000 (UTC)
In-Reply-To: <bug-89511-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89511

--- Comment #45 from Jun Itou <itou_jun@infoseek.jp> ---
(In reply to Alan Stern from comment #44)
> What happens if you unplug the drive while the computer is off and then plug
> it in after booting 3.2.62?

Because only this controller was different in the behavior after the boot, I
tried it in various ways.
It becomes "write back" even if I do plug in after a boot.
So movement becomes funny when I turn on the power supply of the HDD and do not
reset it.

I think that originally the bug that there was came to the front by a
correction after 6.2.63 from this phenomenon.

3.2.62 is a result when plug in assumed an HDD it during operation as follows.

root@sv-server:~# mount -t debugfs none_debugs /sys/kernel/debug
root@sv-server:~# dmesg -c
[  128.833831] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[  129.334896] usb 1-1: New USB device found, idVendor=04bb, idProduct=0106
[  129.334900] usb 1-1: New USB device strings: Mfr=1, Product=2,
SerialNumber=3
[  129.334902] usb 1-1: Product: I-O DATA HDW-UE
[  129.334903] usb 1-1: Manufacturer: I-O DATA DEVICE,INC.
[  129.334905] usb 1-1: SerialNumber: 0000000004EB
[  129.408145] Initializing USB Mass Storage driver...
[  129.409110] scsi3 : usb-storage 1-1:1.0
[  129.409270] usbcore: registered new interface driver usb-storage
[  129.409271] USB Mass Storage support registered.
[  136.595439] scsi 3:0:0:0: Direct-Access     I-O DATA HDW-UE           0100
PQ: 0 ANSI: 2
[  136.597840] sd 3:0:0:0: Attached scsi generic sg2 type 0
[  136.605850] sd 3:0:0:0: [sdb] 1953546336 512-byte logical blocks: (1.00
TB/931 GiB)
[  136.611429] sd 3:0:0:0: [sdb] Write Protect is off
[  136.611438] sd 3:0:0:0: [sdb] Mode Sense: 53 00 00 08
[  136.616835] sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled,
doesn't support DPO or FUA
[  136.652793]  sdb: sdb1
[  136.670708] sd 3:0:0:0: [sdb] Attached SCSI disk
root@sv-server:~# cat /sys/block/sdb/device/scsi_disk/*/cache_type
write back
root@sv-server:~#

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
