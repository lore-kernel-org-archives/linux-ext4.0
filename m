Return-Path: <SRS0=ZxZh=OA=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:37962 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730328AbeKVEwc (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 21 Nov 2018 23:52:32 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 3E2C02C470
        for <linux-ext4@vger.kernel.org>; Wed, 21 Nov 2018 18:17:06 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Wed, 21 Nov 2018 18:17:05 +0000
Message-ID: <bug-201685-13602-xIX4jR99dl@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #13 from Jimmy.Jazz@gmx.net ---
(In reply to Theodore Tso from comment #11)
> Thanks Jimmy for your report.  Can you specify what sort of LVM devices are
> you using?  

Standard lvm linear volumes on top of a full /dev/md0p5 pv partition
on both machines with respectively kernel 4.19.2 and 4.20.0-rc3

> 
> I just noticed that my .config file for my GCE testing has
> CONFIG_SCSI_MQ_DEFAULT set to "no", which means I'm not using the new
> block-mq data path.   So perhaps this is a MQ specific bug?   (Checking...
> hmm, my laptop running 4.19.0 plus the ext4 commits landing in 4.20-rc2+ is
> *also* using CONFIG_SCSI_MQ_DEFAULT=n.)   And Kconfig recommends that
> SCSI_MQ_DEFAULT be defaulted to y.

CONFIG_SCSI_MQ_DEFAULT=y on both machines
CONFIG_DM_MQ_DEFAULT is not set

> This is why having people include their Kernel configs, and what devices
> they use is so important.

sorry it was an oversight. See attachments.

server with kernel 4.19.2
# smartctl -i /dev/sdb                                                 
smartctl 6.6 2017-11-05 r4594 [x86_64-linux-4.19.2-radeon] (local build)

=== START OF INFORMATION SECTION ===
Device Model:     MKNSSDRE512GB
Serial Number:    MK15090210005157A
LU WWN Device Id: 5 888914 10005157a
Firmware Version: N1007C
User Capacity:    512 110 190 592 bytes [512 GB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    Solid State Device
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ACS-2 (minor revision not indicated)
SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Wed Nov 21 19:02:07 2018 CET
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

# smartctl -i /dev/sda                                                 
smartctl 6.6 2017-11-05 r4594 [x86_64-linux-4.19.2-radeon] (local build)

=== START OF INFORMATION SECTION ===
Device Model:     MKNSSDRE512GB
Serial Number:    MK150902100051556
LU WWN Device Id: 5 888914 100051556
Firmware Version: N1007C
User Capacity:    512 110 190 592 bytes [512 GB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    Solid State Device
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ACS-2 (minor revision not indicated)
SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Wed Nov 21 19:04:01 2018 CET
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

server with 4.20.0-rc3

# smartctl -i /dev/sda                                                
=== START OF INFORMATION SECTION ===
Model Family:     HGST Travelstar 7K1000
Device Model:     HGST HTS721010A9E630
Serial Number:    JR10004M0BD4YF
LU WWN Device Id: 5 000cca 8a8c52dba
Firmware Version: JB0OA3J0
User Capacity:    1 000 204 886 016 bytes [1,00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    7200 rpm
Form Factor:      2.5 inches
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS T13/1699-D revision 6
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Wed Nov 21 19:02:21 2018 CET
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

I do periodic backup and the strange is dm-7 is only accessed read only and it
just triggered ext4-iget failures.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
