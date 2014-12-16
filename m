From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89511] USB-storage mount error
Date: Tue, 16 Dec 2014 21:50:27 +0000
Message-ID: <bug-89511-13602-Ix6dqp3zRa@https.bugzilla.kernel.org/>
References: <bug-89511-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:59962 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049AbaLPVub (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Dec 2014 16:50:31 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id DCD9820A1E
	for <linux-ext4@vger.kernel.org>; Tue, 16 Dec 2014 21:50:29 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 519E6209DE
	for <linux-ext4@vger.kernel.org>; Tue, 16 Dec 2014 21:50:28 +0000 (UTC)
In-Reply-To: <bug-89511-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89511

--- Comment #7 from Alan Stern <stern@rowland.harvard.edu> ---
The information you want is here:

T:  Bus=02 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=480  MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=04bb ProdID=0109 Rev= 1.00
S:  Manufacturer=I-O DATA DEVICE INC.
S:  Product=I-O DATA HDZ-UES
S:  SerialNumber=0000000075A7
C:* #Ifs= 1 Cfg#= 1 Atr=c0 MxPwr= 98mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=08(stor.) Sub=06 Prot=50 Driver=usb-storage
E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=125us

The first line says that the device is attached to bus 2.  The dmesg log says
the same thing:

[   66.872687] usb 2-1: New USB device found, idVendor=04bb, idProduct=0109
[   66.872692] usb 2-1: New USB device strings: Mfr=1, Product=2,
SerialNumber=3
[   66.872694] usb 2-1: Product: I-O DATA HDZ-UES
[   66.872696] usb 2-1: Manufacturer: I-O DATA DEVICE INC.
[   66.872697] usb 2-1: SerialNumber: 0000000075A7
[   66.918835] usb-storage 2-1:1.0: USB Mass Storage device detected

The "2-1" means the device is attached to bus 2, port 1.  Therefore the file
you need to cat is /sys/kernel/debug/usb/usbmon/2u and you need to start the
cat before the device is plugged in.  Use ^C to stop the cat after the error
has occurred.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
