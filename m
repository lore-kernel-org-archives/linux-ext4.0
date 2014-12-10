From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89511] USB-storage mount error
Date: Wed, 10 Dec 2014 22:33:54 +0000
Message-ID: <bug-89511-13602-4qE24D1CZT@https.bugzilla.kernel.org/>
References: <bug-89511-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:44786 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932724AbaLJWd6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Dec 2014 17:33:58 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id EE3AD201C7
	for <linux-ext4@vger.kernel.org>; Wed, 10 Dec 2014 22:33:56 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 012542017D
	for <linux-ext4@vger.kernel.org>; Wed, 10 Dec 2014 22:33:55 +0000 (UTC)
In-Reply-To: <bug-89511-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89511

--- Comment #2 from Jun Itou <itou_jun@infoseek.jp> ---
(In reply to Alan from comment #1)
> Are you configuration options for the two kernels exactly the same ?
 Yes.

> Can you try with a more modern kernel base (3.16+) ?
 I did the following tries.
 A partition and the practice of the format are gone with ver.3.2.62.
 Each environment is the same.

root@sv-server:~# uname -a
Linux sv-server 3.18.0 #1 SMP Wed Dec 10 09:05:25 JST 2014 x86_64 GNU/Linux
root@sv-server:~# mount /dev/sdb1 /mnt/usb1
mount: wrong fs type, bad option, bad superblock on /dev/sdb1,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

root@sv-server:~# dmesg
[  133.987321] usb 2-1: new high-speed USB device number 2 using ehci-pci
[  134.521663] usb 2-1: New USB device found, idVendor=04bb, idProduct=0109
[  134.521668] usb 2-1: New USB device strings: Mfr=1, Product=2,
SerialNumber=3
[  134.521671] usb 2-1: Product: I-O DATA HDZ-UES
[  134.521672] usb 2-1: Manufacturer: I-O DATA DEVICE INC.
[  134.521674] usb 2-1: SerialNumber: 0000000075A7
[  134.746148] usb-storage 2-1:1.0: USB Mass Storage device detected
[  134.746260] scsi host3: usb-storage 2-1:1.0
[  134.746422] usbcore: registered new interface driver usb-storage
[  135.748525] scsi 3:0:0:0: Direct-Access     I-O DATA HDZ-UE2.0TS      6706
PQ: 0 ANSI: 0 CCS
[  135.749165] sd 3:0:0:0: Attached scsi generic sg2 type 0
[  135.752517] sd 3:0:0:0: [sdb] 3907092672 512-byte logical blocks: (2.00
TB/1.81 TiB)
[  135.758532] sd 3:0:0:0: [sdb] Write Protect is off
[  135.758536] sd 3:0:0:0: [sdb] Mode Sense: 34 00 00 00
[  135.763999] sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled,
doesn't support DPO or FUA
[  135.784529]  sdb: sdb1
[  135.801515] sd 3:0:0:0: [sdb] Attached SCSI disk
[  195.009482] blk_update_request: critical target error, dev sdb, sector 0
[  195.009758] JBD2: recovery failed
[  195.009766] EXT4-fs (sdb1): error loading journal

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
