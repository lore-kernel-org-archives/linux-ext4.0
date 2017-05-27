From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 195893] New: Blocksize changing +1 / bad geometry /
Date: Sat, 27 May 2017 09:10:00 +0000
Message-ID: <bug-195893-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:50300 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755096AbdE0JKK (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 27 May 2017 05:10:10 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id B8040284A8
        for <linux-ext4@vger.kernel.org>; Sat, 27 May 2017 09:10:09 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=195893

            Bug ID: 195893
           Summary: Blocksize changing +1 / bad geometry /
           Product: File System
           Version: 2.5
    Kernel Version: 4.9.0-2-amd64 #1 SMP Debian 4.9.18-1 (2017-03-30)
                    x86_64 GNU/Linux
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: 189840BSGMKUQECR@directbox.com
        Regression: No

I am handling a lot of disks. 

Lately, I have a lot of disks that linux refuses to mount, because the ext4
filesystem is exceeding the physical disk size.

Setup:
The disks have been installd while installed natively(sata) in laptops and are
formatted with ext4. The disks have been removed from the original laptops and
are connected via USB3-Docking Station to a Lenovo W520 running Debian. Some of
them are encrypted with LUKS and some are unencrypted. Both are affected. 


Using fsck.ext4, I get a message like:

The filesystem size (according to the superblock) is 113445126 blocks
The physical size of the device is 113445125 blocks
Either the superblock or the partition table is likely to be corrupt!


First I thought it may have been a problem when using dd to write to a smaller
disk. But now it happened to a disk I used 5 Minutes ago without any issues.
I accidentally disconnected the cable. And got the fault.

Disks of different vendors and size are affected. I use different USB3-Docking
Stations. I am not sure but I think there were at least one disk affected
having no partition table (just ext4 on the raw disk).

I cannot yet reproduce the fault. But I have already had more than 15 disks
with this issue over the past 6 months.

Symptoms:
The disk does not mount
The partition exceeds the physical size by exactly 1 block.

Additional information:

hdparm /dev/sdd 

/dev/sdd:
 HDIO_DRIVE_CMD(identify) failed: Invalid argument
 readonly      =  0 (off)
 readahead     = 256 (on)
 geometry      = 60801/255/63, sectors = 976773165, start = 0



dmesg:
[611569.085740] usb 2-2: new SuperSpeed USB device number 45 using xhci_hcd
[611569.115972] usb 2-2: New USB device found, idVendor=1234, idProduct=5678
[611569.115984] usb 2-2: New USB device strings: Mfr=1, Product=2,
SerialNumber=3
[611569.115990] usb 2-2: Product: VLI Product String
[611569.115995] usb 2-2: Manufacturer: VLI manufacture String
[611569.115999] usb 2-2: SerialNumber: XXXXXXREMOVEDXXXXXXX
[611569.116953] usb-storage 2-2:1.0: USB Mass Storage device detected
[611569.117157] scsi host7: usb-storage 2-2:1.0
[611572.830469] scsi 7:0:0:0: Direct-Access     ST950042 0AS              0002
PQ: 0 ANSI: 2
[611572.831076] sd 7:0:0:0: Attached scsi generic sg2 type 0
[611572.834528] sd 7:0:0:0: [sdd] 976773165 512-byte logical blocks: (500
GB/466 GiB)
[611572.835013] sd 7:0:0:0: [sdd] Write Protect is off
[611572.835016] sd 7:0:0:0: [sdd] Mode Sense: 03 00 00 00
[611572.835539] sd 7:0:0:0: [sdd] No Caching mode page found
[611572.835546] sd 7:0:0:0: [sdd] Assuming drive cache: write through
[611572.878044]  sdd: sdd1 sdd2 sdd3
[611572.878147] sdd: p3 size 907565104 extends beyond EOD, enabling native
capacity
[611572.894730]  sdd: sdd1 sdd2 sdd3
[611572.894821] sdd: p3 size 907565104 extends beyond EOD, truncated
[611573.935026] sd 7:0:0:0: [sdd] Attached SCSI disk
[611628.215491] EXT4-fs (dm-0): bad geometry: block count 113445126 exceeds
size of device (113445125 blocks)
[611726.355560] EXT4-fs (dm-0): mounted filesystem with ordered data mode.
Opts: (null)


Workaround - fix: 
fsck.ext4 /dev/sdd3
- press "n" to ignore different physical size
- most times no more errors show up

resize2fs /dev/sdd3
mount /dev/sdd3 /mnt/disk3

Now the device is fixed. And can be used again. 
As far as I can see there is no data loss.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
