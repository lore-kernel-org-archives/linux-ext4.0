From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89511] USB-storage mount error
Date: Fri, 09 Jan 2015 13:46:28 +0000
Message-ID: <bug-89511-13602-nu43cnQMSg@https.bugzilla.kernel.org/>
References: <bug-89511-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:48103 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756671AbbAINqd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 9 Jan 2015 08:46:33 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 529D8205DA
	for <linux-ext4@vger.kernel.org>; Fri,  9 Jan 2015 13:46:31 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 4C38E205BC
	for <linux-ext4@vger.kernel.org>; Fri,  9 Jan 2015 13:46:29 +0000 (UTC)
In-Reply-To: <bug-89511-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89511

--- Comment #43 from Jun Itou <itou_jun@infoseek.jp> ---
When even 3.2.62 reboots an HDD in power supply on, it is "write through".
It only becomes "write back" when I reset an HDD.
Will it be that a bug of the material came to the front?
Only a controller of D8927GC-002 becomes "write back" when I initialize it, is
it the thing which it is not possible for in "write through" at the time of
recognition somehow?

root@sv-server:~# uname -a
Linux sv-server 3.2.62 #1 SMP Fri Jan 9 19:06:10 JST 2015 x86_64 GNU/Linux
root@sv-server:~# cat /sys/block/sdb/device/scsi_disk/*/cache_type
write through
root@sv-server:~# udevadm info --query=path --name=/dev/sdb
/devices/pci0000:00/0000:00:11.0/0000:02:03.0/usb1/1-1/1-1:1.0/host3/target3:0:0/3:0:0:0/block/sdb
root@sv-server:~# echo -n "1-1" > /sys/bus/usb/drivers/usb/unbind
root@sv-server:~# echo -n "1-1" > /sys/bus/usb/drivers/usb/bind
root@sv-server:~# cat /sys/block/sdb/device/scsi_disk/*/cache_type
write back

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
