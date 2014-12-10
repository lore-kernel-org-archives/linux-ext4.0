From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89511] New: USB-storage mount error
Date: Wed, 10 Dec 2014 02:35:49 +0000
Message-ID: <bug-89511-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:44923 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752651AbaLJCfy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Dec 2014 21:35:54 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D9D01200FF
	for <linux-ext4@vger.kernel.org>; Wed, 10 Dec 2014 02:35:51 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 79DA22010C
	for <linux-ext4@vger.kernel.org>; Wed, 10 Dec 2014 02:35:49 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89511

            Bug ID: 89511
           Summary: USB-storage mount error
           Product: File System
           Version: 2.5
    Kernel Version: 3.2.63
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: itou_jun@infoseek.jp
        Regression: No

When my USB-storage does mount, it becomes the error.
It occurs from ver.3.2.63 and does not occur in ver.3.2.62.
I ride below dmesg.
It reappears in this series of io data by all means.
I confirmed that hardware did not have a problem.
The following changed kernel in menu in the same environment and tested it.
Because a write is not done to become the read only, please help me.
Even ext3 format occurs.
I doubt file system.
Thank you.

=== Linux sv-server 3.2.62 #1 SMP Mon Dec 8 16:11:25 JST 2014 x86_64 GNU/Linux
===
[   35.262592] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[   35.799983] usb 1-1: New USB device found, idVendor=04bb, idProduct=0109
[   35.799986] usb 1-1: New USB device strings: Mfr=1, Product=2,
SerialNumber=3
[   35.799988] usb 1-1: Product: I-O DATA HDZ-UES
[   35.799990] usb 1-1: Manufacturer: I-O DATA DEVICE INC.
[   35.799991] usb 1-1: SerialNumber: 0000000075A7
[   35.842500] Initializing USB Mass Storage driver...
[   35.842674] scsi3 : usb-storage 1-1:1.0
[   35.842796] usbcore: registered new interface driver usb-storage
[   35.842798] USB Mass Storage support registered.
[   36.849383] scsi 3:0:0:0: Direct-Access     I-O DATA HDZ-UE2.0TS      6706
PQ: 0 ANSI: 0 CCS
[   36.851340] sd 3:0:0:0: Attached scsi generic sg2 type 0
[   36.854356] sd 3:0:0:0: [sdb] 3907092672 512-byte logical blocks: (2.00
TB/1.81 TiB)
[   36.859815] sd 3:0:0:0: [sdb] Write Protect is off
[   36.859819] sd 3:0:0:0: [sdb] Mode Sense: 34 00 00 00
[   36.865795] sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled,
doesn't support DPO or FUA
[   36.887806]  sdb: sdb1
[   36.906185] sd 3:0:0:0: [sdb] Attached SCSI disk
[   76.056522] EXT4-fs (sdb1): mounted filesystem with ordered data mode. Opts:
(null)

=== Linux sv-server 3.2.63 #1 SMP Mon Dec 8 18:22:55 JST 2014 x86_64 GNU/Linux
===
[   34.436890] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[   34.918885] usb 1-1: New USB device found, idVendor=04bb, idProduct=0109
[   34.918888] usb 1-1: New USB device strings: Mfr=1, Product=2,
SerialNumber=3
[   34.918890] usb 1-1: Product: I-O DATA HDZ-UES
[   34.918891] usb 1-1: Manufacturer: I-O DATA DEVICE INC.
[   34.918893] usb 1-1: SerialNumber: 0000000075A7
[   35.008643] Initializing USB Mass Storage driver...
[   35.008951] scsi3 : usb-storage 1-1:1.0
[   35.009086] usbcore: registered new interface driver usb-storage
[   35.009087] USB Mass Storage support registered.
[   36.009158] scsi 3:0:0:0: Direct-Access     I-O DATA HDZ-UE2.0TS      6706
PQ: 0 ANSI: 0 CCS
[   36.010859] sd 3:0:0:0: Attached scsi generic sg2 type 0
[   36.015660] sd 3:0:0:0: [sdb] 3907092672 512-byte logical blocks: (2.00
TB/1.81 TiB)
[   36.021098] sd 3:0:0:0: [sdb] Write Protect is off
[   36.021100] sd 3:0:0:0: [sdb] Mode Sense: 34 00 00 00
[   36.026572] sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled,
doesn't support DPO or FUA
[   36.052046]  sdb: sdb1
[   36.076457] sd 3:0:0:0: [sdb] Attached SCSI disk
[   57.285934] EXT4-fs (sdb1): mounted filesystem with ordered data mode. Opts:
(null)
[   57.418428] end_request: I/O error, dev sdb, sector 0

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
