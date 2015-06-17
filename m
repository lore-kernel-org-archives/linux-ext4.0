From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89511] USB-storage mount error
Date: Wed, 17 Jun 2015 17:54:29 +0000
Message-ID: <bug-89511-13602-F8pLiI9GhE@https.bugzilla.kernel.org/>
References: <bug-89511-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:57084 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442AbbFQRyd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Jun 2015 13:54:33 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 9B4D320876
	for <linux-ext4@vger.kernel.org>; Wed, 17 Jun 2015 17:54:31 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id ED7D920861
	for <linux-ext4@vger.kernel.org>; Wed, 17 Jun 2015 17:54:29 +0000 (UTC)
In-Reply-To: <bug-89511-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89511

--- Comment #63 from Markus Rathgeb <maggu2810@gmail.com> ---
Created attachment 180211
  --> https://bugzilla.kernel.org/attachment.cgi?id=180211&action=edit
linux-4.0.5-gentoo-fix-some-synchronized-cache-broken-scsi-devices.patch

Thank you! It is working now.


Jun 17 19:49:14 m3800 kernel: usb 1-3: new high-speed USB device number 7 using
xhci_hcd
Jun 17 19:49:14 m3800 kernel: usb 1-3: New USB device found, idVendor=04cf,
idProduct=8818
Jun 17 19:49:14 m3800 kernel: usb 1-3: New USB device strings: Mfr=1,
Product=2, SerialNumber=3
Jun 17 19:49:14 m3800 kernel: usb 1-3: Product: USB Mass Storage Device
Jun 17 19:49:14 m3800 kernel: usb 1-3: Manufacturer: Myson Century, Inc.
Jun 17 19:49:14 m3800 kernel: usb 1-3: SerialNumber: 100
Jun 17 19:49:14 m3800 kernel: usb-storage 1-3:1.0: USB Mass Storage device
detected
Jun 17 19:49:14 m3800 kernel: usb-storage 1-3:1.0: Quirks match for vid 04cf
pid 8818: 10000000
Jun 17 19:49:14 m3800 kernel: scsi host7: usb-storage 1-3:1.0
Jun 17 19:49:15 m3800 kernel: scsi 7:0:0:0: Direct-Access     SAMSUNG  MP0804H 
        UE10 PQ: 0 ANSI: 0 CCS
Jun 17 19:49:15 m3800 kernel: sd 7:0:0:0: Attached scsi generic sg1 type 0
Jun 17 19:49:15 m3800 kernel: sd 7:0:0:0: [sdb] 156368016 512-byte logical
blocks: (80.0 GB/74.5 GiB)
Jun 17 19:49:15 m3800 kernel: sd 7:0:0:0: [sdb] Write Protect is off
Jun 17 19:49:15 m3800 kernel: sd 7:0:0:0: [sdb] Mode Sense: 00 14 00 00
Jun 17 19:49:15 m3800 kernel:  sdb: sdb1 sdb2
Jun 17 19:49:15 m3800 kernel: sd 7:0:0:0: [sdb] Attached SCSI disk


# cat /sys/block/sdb/device/scsi_disk/*/cache_type
write through


Would be great to get that upstream.
I have to change the magic number of the flag.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
