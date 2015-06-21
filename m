From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89511] USB-storage mount error
Date: Sun, 21 Jun 2015 08:59:21 +0000
Message-ID: <bug-89511-13602-MgzssKS1hn@https.bugzilla.kernel.org/>
References: <bug-89511-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:45926 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752302AbbFUI71 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Jun 2015 04:59:27 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D496C20702
	for <linux-ext4@vger.kernel.org>; Sun, 21 Jun 2015 08:59:25 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id EA8AB206DD
	for <linux-ext4@vger.kernel.org>; Sun, 21 Jun 2015 08:59:22 +0000 (UTC)
In-Reply-To: <bug-89511-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89511

--- Comment #66 from Matt <vickm78@hotmail.com> ---
Success! The patch, as is, allowed me to mount and write to my device without
any further commands. Test system: Debian Stable (Jessie) on kernel 3.16.0

dmesg extract, no errors appearing after creating a new file on the drive:

usb-storage 2-2:1.0: USB Mass Storage device detected
[ 1058.208203] usb-storage 2-2:1.0: Quirks match for vid 0bc2 pid 3332: 8000000
[ 1058.208238] scsi6 : usb-storage 2-2:1.0
[ 1058.208397] usbcore: registered new interface driver usb-storage
[ 1059.208931] scsi 6:0:0:0: Direct-Access     Seagate  External         SG12
PQ: 0 ANSI: 4
[ 1059.209348] sd 6:0:0:0: Attached scsi generic sg3 type 0
[ 1059.209805] sd 6:0:0:0: [sdc] 732566642 4096-byte logical blocks: (3.00
TB/2.72 TiB)
[ 1059.210542] sd 6:0:0:0: [sdc] Write Protect is off
[ 1059.210548] sd 6:0:0:0: [sdc] Mode Sense: 1c 00 00 00
[ 1059.211414] sd 6:0:0:0: [sdc] 732566642 4096-byte logical blocks: (3.00
TB/2.72 TiB)
[ 1059.236569]  sdc: sdc1
[ 1059.237668] sd 6:0:0:0: [sdc] 732566642 4096-byte logical blocks: (3.00
TB/2.72 TiB)
[ 1059.238421] sd 6:0:0:0: [sdc] Attached SCSI disk

Thank you!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
