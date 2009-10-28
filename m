From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14497] New: system blocked on "sync" command issued.
Date: Wed, 28 Oct 2009 03:28:30 GMT
Message-ID: <bug-14497-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:47377 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757212AbZJ1D20 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Oct 2009 23:28:26 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9S3SVJW015424
	for <linux-ext4@vger.kernel.org>; Wed, 28 Oct 2009 03:28:31 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14497

           Summary: system blocked on "sync" command issued.
           Product: File System
           Version: 2.5
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: htmldeveloper@gmail.com
        Regression: Yes


Seemed like ext4 FS error has resulted in the harddisk not being able to be
mounted properly second time round.

First I plugged in the thumbdrive and then followed by the USB harddisk:

usb 2-1: new high speed USB device using ehci_hcd and address 2
usb 2-1: New USB device found, idVendor=0930, idProduct=6545
usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 2-1: Product: TransMemory     
usb 2-1: Manufacturer: TOSHIBA 
usb 2-1: SerialNumber: 5B84080000C8
usb 2-1: configuration #1 chosen from 1 choice
Initializing USB Mass Storage driver...
scsi2 : SCSI emulation for USB Mass Storage devices
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usb-storage: device found at 2
usb-storage: waiting for device to settle before scanning
usb-storage: device scan complete
scsi 2:0:0:0: Direct-Access     TOSHIBA  TransMemory      PMAP PQ: 0 ANSI: 0
CCS
sd 2:0:0:0: Attached scsi generic sg2 type 0
sd 2:0:0:0: [sdb] 7823360 512-byte logical blocks: (4.00 GB/3.73 GiB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 23 00 00 00
sd 2:0:0:0: [sdb] Assuming drive cache: write through
sd 2:0:0:0: [sdb] Assuming drive cache: write through
 sdb: sdb1
sd 2:0:0:0: [sdb] Assuming drive cache: write through
sd 2:0:0:0: [sdb] Attached SCSI removable disk
usb 2-2: new high speed USB device using ehci_hcd and address 3
usb 2-2: New USB device found, idVendor=0d49, idProduct=7350
usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 2-2: Product: OneTouch        
usb 2-2: Manufacturer: Maxtor  
usb 2-2: SerialNumber: 2HAPXD2T    
usb 2-2: configuration #1 chosen from 1 choice
scsi3 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 3
usb-storage: waiting for device to settle before scanning
usb-storage: device scan complete
scsi 3:0:0:0: Direct-Access     Maxtor   OneTouch         0125 PQ: 0 ANSI: 4
sd 3:0:0:0: Attached scsi generic sg3 type 0
sd 3:0:0:0: [sdc] 625142448 512-byte logical blocks: (320 GB/298 GiB)
sd 3:0:0:0: [sdc] Write Protect is off
sd 3:0:0:0: [sdc] Mode Sense: 2d 08 00 00
sd 3:0:0:0: [sdc] Assuming drive cache: write through
sd 3:0:0:0: [sdc] Assuming drive cache: write through
 sdc: sdc1 sdc2 sdc3 sdc4 < sdc5 sdc6 >
sd 3:0:0:0: [sdc] Assuming drive cache: write through
sd 3:0:0:0: [sdc] Attached SCSI disk
kjournald starting.  Commit interval 5 seconds
EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
EXT3 FS on sdc2, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
kjournald starting.  Commit interval 5 seconds
EXT3-fs warning: mounting fs with errors, running e2fsck is recommended
EXT3 FS on sdc1, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
EXT4-fs (sdc5): warning: maximal mount count reached, running e2fsck is
recommended
EXT4-fs (sdc5): mounted filesystem with ordered data mode
kjournald starting.  Commit interval 5 seconds
EXT3-fs warning: mounting fs with errors, running e2fsck is recommended
EXT3 FS on sdc3, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
usb 2-2: USB disconnect, address 3
JBD2: I/O error detected when updating journal superblock for sdc5-8.
EXT4-fs (sdc5): previous I/O error to superblock detected
usb 2-2: new high speed USB device using ehci_hcd and address 4
usb 2-2: New USB device found, idVendor=0d49, idProduct=7350
usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 2-2: Product: OneTouch        
usb 2-2: Manufacturer: Maxtor  
usb 2-2: SerialNumber: 2HAPXD2T    
usb 2-2: configuration #1 chosen from 1 choice
scsi4 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 4
usb-storage: waiting for device to settle before scanning
usb-storage: device scan complete
scsi 4:0:0:0: Direct-Access     Maxtor   OneTouch         0125 PQ: 0 ANSI: 4
sd 4:0:0:0: Attached scsi generic sg3 type 0
sd 4:0:0:0: [sdd] 625142448 512-byte logical blocks: (320 GB/298 GiB)
sd 4:0:0:0: [sdd] Write Protect is off
sd 4:0:0:0: [sdd] Mode Sense: 2d 08 00 00
sd 4:0:0:0: [sdd] Assuming drive cache: write through
sd 4:0:0:0: [sdd] Assuming drive cache: write through
 sdd: sdd1 sdd2 sdd3 sdd4 < sdd5 sdd6 >
sd 4:0:0:0: [sdd] Assuming drive cache: write through
sd 4:0:0:0: [sdd] Attached SCSI disk
INFO: task umount:6076 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
umount        D ffff880001c97340     0  6076   6071 0x00000080
 ffff8800986e9be8 0000000000000082 ffff8800986e9b58 ffffffff810538f5
 ffff8800986e9c38 0000000000010f08 ffff8800986e9fd8 0000000000017340
 ffff8800986e9fd8 0000000000017340 ffff8800a87a2e40 ffff8800bbfdae40
Call Trace:
 [<ffffffff810538f5>] ? update_curr+0xd8/0x164
 [<ffffffff810396fe>] ? default_spin_lock_flags+0x1c/0x36
 [<ffffffff811533f1>] bdi_sched_wait+0x21/0x39
 [<ffffffff814c884f>] __wait_on_bit+0x5b/0xa3
 [<ffffffff811533d0>] ? bdi_sched_wait+0x0/0x39
 [<ffffffff811533d0>] ? bdi_sched_wait+0x0/0x39
 [<ffffffff814c8915>] out_of_line_wait_on_bit+0x7e/0x9f
 [<ffffffff810864db>] ? wake_bit_function+0x0/0x56
 [<ffffffff811531bf>] wait_on_bit+0x2d/0x49
 [<ffffffff81153496>] sync_inodes_sb+0x8d/0x183
 [<ffffffff81157cdb>] __sync_filesystem+0x5f/0xa0
 [<ffffffff81157f63>] sync_filesystem+0x5a/0x77
 [<ffffffff811347f8>] generic_shutdown_super+0x3a/0x107
 [<ffffffff811348ff>] kill_block_super+0x3a/0x68
 [<ffffffff811351ec>] deactivate_super+0x82/0xb2
 [<ffffffff8114d065>] mntput_no_expire+0xdc/0x12f
 [<ffffffff8114686e>] ? dput+0x58/0x174
 [<ffffffff8114d715>] sys_umount+0x2d6/0x31b
 [<ffffffff810130f2>] system_call_fastpath+0x16/0x1b
INFO: task umount:6076 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
umount        D ffff880001c97340     0  6076   6071 0x00000080
 ffff8800986e9be8 0000000000000082 ffff8800986e9b58 ffffffff810538f5
 ffff8800986e9c38 0000000000010f08 ffff8800986e9fd8 0000000000017340
 ffff8800986e9fd8 0000000000017340 ffff8800a87a2e40 ffff8800bbfdae40
Call Trace:
 [<ffffffff810538f5>] ? update_curr+0xd8/0x164
 [<ffffffff810396fe>] ? default_spin_lock_flags+0x1c/0x36
 [<ffffffff811533f1>] bdi_sched_wait+0x21/0x39
 [<ffffffff814c884f>] __wait_on_bit+0x5b/0xa3
 [<ffffffff811533d0>] ? bdi_sched_wait+0x0/0x39
 [<ffffffff811533d0>] ? bdi_sched_wait+0x0/0x39
 [<ffffffff814c8915>] out_of_line_wait_on_bit+0x7e/0x9f
 [<ffffffff810864db>] ? wake_bit_function+0x0/0x56
 [<ffffffff811531bf>] wait_on_bit+0x2d/0x49
 [<ffffffff81153496>] sync_inodes_sb+0x8d/0x183
 [<ffffffff81157cdb>] __sync_filesystem+0x5f/0xa0
 [<ffffffff81157f63>] sync_filesystem+0x5a/0x77
 [<ffffffff811347f8>] generic_shutdown_super+0x3a/0x107
 [<ffffffff811348ff>] kill_block_super+0x3a/0x68
 [<ffffffff811351ec>] deactivate_super+0x82/0xb2
 [<ffffffff8114d065>] mntput_no_expire+0xdc/0x12f
 [<ffffffff8114686e>] ? dput+0x58/0x174
 [<ffffffff8114d715>] sys_umount+0x2d6/0x31b
 [<ffffffff810130f2>] system_call_fastpath+0x16/0x1b

INFO: task umount:6076 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
umount        D ffff880001c97340     0  6076   6071 0x00000080
 ffff8800986e9be8 0000000000000082 ffff8800986e9b58 ffffffff810538f5
 ffff8800986e9c38 0000000000010f08 ffff8800986e9fd8 0000000000017340
 ffff8800986e9fd8 0000000000017340 ffff8800a87a2e40 ffff8800bbfdae40
Call Trace:
 [<ffffffff810538f5>] ? update_curr+0xd8/0x164
 [<ffffffff810396fe>] ? default_spin_lock_flags+0x1c/0x36
 [<ffffffff811533f1>] bdi_sched_wait+0x21/0x39
 [<ffffffff814c884f>] __wait_on_bit+0x5b/0xa3
 [<ffffffff811533d0>] ? bdi_sched_wait+0x0/0x39
 [<ffffffff811533d0>] ? bdi_sched_wait+0x0/0x39
 [<ffffffff814c8915>] out_of_line_wait_on_bit+0x7e/0x9f
 [<ffffffff810864db>] ? wake_bit_function+0x0/0x56
 [<ffffffff811531bf>] wait_on_bit+0x2d/0x49
 [<ffffffff81153496>] sync_inodes_sb+0x8d/0x183
 [<ffffffff81157cdb>] __sync_filesystem+0x5f/0xa0
 [<ffffffff81157f63>] sync_filesystem+0x5a/0x77
 [<ffffffff811347f8>] generic_shutdown_super+0x3a/0x107
 [<ffffffff811348ff>] kill_block_super+0x3a/0x68
 [<ffffffff811351ec>] deactivate_super+0x82/0xb2
 [<ffffffff8114d065>] mntput_no_expire+0xdc/0x12f
 [<ffffffff8114686e>] ? dput+0x58/0x174
 [<ffffffff8114d715>] sys_umount+0x2d6/0x31b
 [<ffffffff810130f2>] system_call_fastpath+0x16/0x1b
INFO: task umount:6076 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
umount        D ffff880001c97340     0  6076   6071 0x00000080
 ffff8800986e9be8 0000000000000082 ffff8800986e9b58 ffffffff810538f5
 ffff8800986e9c38 0000000000010f08 ffff8800986e9fd8 0000000000017340
 ffff8800986e9fd8 0000000000017340 ffff8800a87a2e40 ffff8800bbfdae40
Call Trace:
 [<ffffffff810538f5>] ? update_curr+0xd8/0x164
 [<ffffffff810396fe>] ? default_spin_lock_flags+0x1c/0x36
 [<ffffffff811533f1>] bdi_sched_wait+0x21/0x39
 [<ffffffff814c884f>] __wait_on_bit+0x5b/0xa3
 [<ffffffff811533d0>] ? bdi_sched_wait+0x0/0x39
 [<ffffffff811533d0>] ? bdi_sched_wait+0x0/0x39
 [<ffffffff814c8915>] out_of_line_wait_on_bit+0x7e/0x9f
 [<ffffffff810864db>] ? wake_bit_function+0x0/0x56
 [<ffffffff811531bf>] wait_on_bit+0x2d/0x49
 [<ffffffff81153496>] sync_inodes_sb+0x8d/0x183
 [<ffffffff81157cdb>] __sync_filesystem+0x5f/0xa0
 [<ffffffff81157f63>] sync_filesystem+0x5a/0x77
 [<ffffffff811347f8>] generic_shutdown_super+0x3a/0x107
 [<ffffffff811348ff>] kill_block_super+0x3a/0x68
 [<ffffffff811351ec>] deactivate_super+0x82/0xb2
 [<ffffffff8114d065>] mntput_no_expire+0xdc/0x12f
 [<ffffffff8114686e>] ? dput+0x58/0x174
 [<ffffffff8114d715>] sys_umount+0x2d6/0x31b
 [<ffffffff810130f2>] system_call_fastpath+0x16/0x1b

Doing a "top" indicate no hung task:

 2544 root      40   0  173m  59m 8824 S  7.9  2.0   7:26.67 Xorg               
    1 root      40   0  4084  864  620 S  0.0  0.0   0:00.88 init               
    2 root      40   0     0    0    0 S  0.0  0.0   0:00.00 kthreadd           
    3 root      RT   0     0    0    0 S  0.0  0.0   0:00.00 migration/0        
    4 root      20   0     0    0    0 S  0.0  0.0   0:00.02 ksoftirqd/0        
    5 root      RT   0     0    0    0 S  0.0  0.0   0:00.00 watchdog/0         
    6 root      RT   0     0    0    0 S  0.0  0.0   0:00.00 migration/1        
    7 root      20   0     0    0    0 S  0.0  0.0   0:01.36 ksoftirqd/1        
    8 root      RT   0     0    0    0 S  0.0  0.0   0:00.00 watchdog/1         
    9 root      20   0     0    0    0 S  0.0  0.0   0:00.24 events/0           
   10 root      20   0     0    0    0 S  0.0  0.0   0:00.51 events/1           
   11 root      20   0     0    0    0 S  0.0  0.0   0:00.02 khelper            
   17 root      20   0     0    0    0 S  0.0  0.0   0:00.00 async/mgr          
  150 root      20   0     0    0    0 S  0.0  0.0   0:00.00 sync_supers        
  152 root      20   0     0    0    0 S  0.0  0.0   0:00.11 bdi-default        
  153 root      20   0     0    0    0 S  0.0  0.0   0:00.00 kintegrityd/0      
  154 root      20   0     0    0    0 S  0.0  0.0   0:00.00 kintegrityd/1      
  156 root      20   0     0    0    0 S  0.0  0.0   0:00.02 kblockd/0          
  157 root      20   0     0    0    0 S  0.0  0.0   0:00.28 kblockd/1          
  159 root      20   0     0    0    0 S  0.0  0.0   0:00.00 kacpid             
  160 root      20   0     0    0    0 S  0.0  0.0   0:00.01 kacpi_notify       
  161 root      20   0     0    0    0 S  0.0  0.0   0:00.00 kacpi_hotplug      
  295 root      20   0     0    0    0 S  0.0  0.0   0:02.53 ata/0              

Issuing a "sync" will block, and thus cannot dismount any drive, and during
system shutdown, it will again block on "Halting system"....a hard powerdown is
thus necessary.

Can anyone helped diagnose the error?

Some info:


Fedora Core 10, linus-git tree (latest):

git describe
v2.6.32-rc5-81-g964fe08

and the configuration of the "/dev/sdc":

fdisk -l /dev/sdc

Disk /dev/sdc: 320.0 GB, 320072933376 bytes
255 heads, 63 sectors/track, 38913 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x0d87fdb3

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1               1        4864    39070048+  83  Linux
/dev/sdc2            4865        9728    39070080   83  Linux
/dev/sdc3            9729       19455    78132127+  83  Linux
/dev/sdc4           19456       38913   156296385    5  Extended
/dev/sdc5           19456       29899    83891398+  83  Linux
/dev/sdc6           29900       31205    10490413+  83  Linux

where /dev/sdc5 is ext4 and the rest are ext3 or vfat.

Upon reboot, no dmesg error are also issued when mounted, and I can also copy
files from /dev/sdc5 to other directories without any dmesg error.   So not
sure how to reproduce the error.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
