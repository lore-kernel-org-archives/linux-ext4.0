From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 111961] New: ext4 umount - invalid opcode with PLEXTOR
 PX-128M6G-2242
Date: Fri, 05 Feb 2016 16:16:28 +0000
Message-ID: <bug-111961-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:53637 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925AbcBEQQf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Feb 2016 11:16:35 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 666B020389
	for <linux-ext4@vger.kernel.org>; Fri,  5 Feb 2016 16:16:34 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 5102020397
	for <linux-ext4@vger.kernel.org>; Fri,  5 Feb 2016 16:16:30 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=111961

            Bug ID: 111961
           Summary: ext4 umount - invalid opcode with PLEXTOR
                    PX-128M6G-2242
           Product: File System
           Version: 2.5
    Kernel Version: 4.4.1
          Hardware: Intel
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: info@dynpages.de
        Regression: No

Created attachment 202951
  --> https://bugzilla.kernel.org/attachment.cgi?id=202951&action=edit
journald

On shutdown system hangs and prints stack trace. After reboot I had to recover
my home partition with fsck, sector count was corrupted (didn't check on data
loss yet). I've attached journald log + hdd info.

My partitions are mounted with defaults + noatime flags. The ssd is tied to an
acer chromebook 11 C740 running arch linux (no Chromeos).

If you need any more info don't hesitate to ask.

best regards


Sebastian

---
hdparm info:

/dev/sda:

ATA device, with non-removable media
    Model Number:       PLEXTOR PX-128M6G-2242                  
    Serial Number:      P02539111451        
    Firmware Revision:  1.01    
    Transport:          Serial, ATA8-AST, SATA II Extensions, SATA Rev 2.6,
SATA Rev 3.0
Standards:
    Used: ATA/ATAPI-7 T13 1532D revision 4a 
    Supported: 8 7 6 5 & some of 8
Configuration:
    Logical        max    current
    cylinders    16383    16383
    heads        16    16
    sectors/track    63    63
    --
    CHS current addressable sectors:   16514064
    LBA    user addressable sectors:  250069680
    LBA48  user addressable sectors:  250069680
    Logical  Sector size:                   512 bytes
    Physical Sector size:                   512 bytes
    Logical Sector-0 offset:                  0 bytes
    device size with M = 1024*1024:      122104 MBytes
    device size with M = 1000*1000:      128035 MBytes (128 GB)
    cache/buffer size  = unknown
    Nominal Media Rotation Rate: Solid State Device
Capabilities:
    LBA, IORDY(can be disabled)
    Queue depth: 32
    Standby timer values: spec'd by Standard, no device specific minimum
    R/W multiple sector transfer: Max = 16    Current = 1
    DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 udma5 *udma6 
         Cycle time: min=120ns recommended=120ns
    PIO: pio0 pio1 pio2 pio3 pio4 
         Cycle time: no flow control=120ns  IORDY flow control=120ns
Commands/features:
    Enabled    Supported:
       *    SMART feature set
            Security Mode feature set
       *    Power Management feature set
       *    Write cache
       *    Look-ahead
       *    Host Protected Area feature set
       *    WRITE_BUFFER command
       *    READ_BUFFER command
       *    DOWNLOAD_MICROCODE
            SET_MAX security extension
       *    48-bit Address feature set
       *    Device Configuration Overlay feature set
       *    Mandatory FLUSH_CACHE
       *    FLUSH_CACHE_EXT
       *    SMART error logging
       *    SMART self-test
       *    General Purpose Logging feature set
       *    64-bit World wide name
       *    Segmented DOWNLOAD_MICROCODE
       *    Gen1 signaling speed (1.5Gb/s)
       *    Gen2 signaling speed (3.0Gb/s)
       *    Gen3 signaling speed (6.0Gb/s)
       *    Native Command Queueing (NCQ)
       *    Host-initiated interface power management
       *    Phy event counters
       *    DMA Setup Auto-Activate optimization
       *    Device-initiated interface power management
       *    Software settings preservation
       *    Device Sleep (DEVSLP)
       *    SMART Command Transport (SCT) feature set
       *    SCT Write Same (AC2)
       *    SCT Error Recovery Control (AC3)
       *    SCT Features Control (AC4)
       *    SCT Data Tables (AC5)
       *    Data Set Management TRIM supported (limit 8 blocks)
Security: 
        supported
    not    enabled
    not    locked
    not    frozen
    not    expired: security count
        supported: enhanced erase
    6min for SECURITY ERASE UNIT. 6min for ENHANCED SECURITY ERASE UNIT. 
Logical Unit WWN Device Identifier: 500230310063e763
    NAA        : 5
    IEEE OUI    : 002303
    Unique ID    : 10063e763
Device Sleep:
    DEVSLP Exit Timeout (DETO): 100 ms (drive)
    Minimum DEVSLP Assertion Time (MDAT): 10 ms (drive)
Checksum: correct

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
