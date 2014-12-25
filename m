From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89511] USB-storage mount error
Date: Thu, 25 Dec 2014 21:03:14 +0000
Message-ID: <bug-89511-13602-rrydBEYmgk@https.bugzilla.kernel.org/>
References: <bug-89511-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:37050 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957AbaLYVDT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Dec 2014 16:03:19 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 6C4BC201EF
	for <linux-ext4@vger.kernel.org>; Thu, 25 Dec 2014 21:03:17 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 8678A2013A
	for <linux-ext4@vger.kernel.org>; Thu, 25 Dec 2014 21:03:15 +0000 (UTC)
In-Reply-To: <bug-89511-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89511

--- Comment #25 from Alan Stern <stern@rowland.harvard.edu> ---
Here's part of your log for the iop32x system:

root@sv-hoge:~# dmesg -c
[73594.100132] usb 1-4: new high-speed USB device number 4 using ehci_hcd
[73594.270976] usb 1-4: New USB device found, idVendor=04bb, idProduct=0106
[73594.277738] usb 1-4: New USB device strings: Mfr=1, Product=2,
SerialNumber=3
[73594.285021] usb 1-4: Product: I-O DATA HDW-UE
[73594.289442] usb 1-4: Manufacturer: I-O DATA DEVICE,INC.
[73594.294712] usb 1-4: SerialNumber: 0000000015B4
[73594.334334] scsi4 : usb-storage 1-4:1.0
[73609.578027] scsi 4:0:0:0: Direct-Access     I-O DATA HDW-UE           0100
PQ: 0 ANSI: 2
[73609.652609] sd 4:0:0:0: [sdf] 1953546336 512-byte logical blocks: (1.00
TB/931 GiB)
[73609.671691] sd 4:0:0:0: Attached scsi generic sg5 type 0
[73609.691455] sd 4:0:0:0: [sdf] Write Protect is off
[73609.696318] sd 4:0:0:0: [sdf] Mode Sense: 53 00 00 08
[73609.710832] sd 4:0:0:0: [sdf] Write cache: enabled, read cache: enabled,
doesn't support DPO or FUA
[73609.950746]  sdf: sdf1
[73609.975400] sd 4:0:0:0: [sdf] Attached SCSI disk

Notice that the new disk is sdf.

root@sv-hoge:~# cat /sys/block/sdb/device/scsi_disk/*/cache_type
write back
root@sv-hoge:~# echo 'temporary write through' >
/sys/block/sdb/device/scsi_disk/*/cache_type
root@sv-hoge:~# cat /sys/block/sdb/device/scsi_disk/*/cache_type
write through

But you changed the cache type for sdb, not sdf!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
