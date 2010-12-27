From: Con Kolivas <kernel@kolivas.org>
Subject: Regular ext4 error warning with HD in USB dock
Date: Tue, 28 Dec 2010 09:53:45 +1100
Message-ID: <201012280953.46149.kernel@kolivas.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-usb@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi all

Since I moved my internal HD into a USB dock externally and mount the ext4 
filesystem on it, I regularly get the following errors after it has been 
mounted for a while (see timecode). It doesn't seem to matter which recent 
kernel I use. 


[1048401.773270] EXT4-fs (sde8): mounted filesystem with writeback data mode. 
Opts: (null)
[1048702.736011] EXT4-fs (sde8): error count: 3
[1048702.736016] EXT4-fs (sde8): initial error at 1289053677: 
ext4_journal_start_sb:251
[1048702.736018] EXT4-fs (sde8): last error at 1289080948: ext4_put_super:719

I've forced an fs check numerous times but nothing comes up. There was only 
one occasion where the filesystem mounted RO but that was months ago and has 
since been fine.

This does not appear to cause any actual problems and happens it seems at 
_precisely_ the moment the hard drive decides to go into sleep mode as I hear 
it spin down. hdparm is unable to extract details from the hard drive when it 
is plugged into the usb dock.



The options used on this are as follows:
tune2fs 1.41.12 (17-May-2010)
Filesystem volume name:   backup
Last mounted on:          /media/backup
Filesystem UUID:          4eff5eb7-89fb-4db1-8cfd-f09db598a00b
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype 
needs_recovery extent flex_bg sparse_super large_file huge_file uninit_bg 
dir_nlink extra_isize
Filesystem flags:         signed_directory_hash 
Default mount options:    journal_data_writeback
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              22593536
Block count:              90355576
Reserved block count:     0
Free blocks:              30330219
Free inodes:              21828725
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      1002
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
Flex block group size:    16
Filesystem created:       Fri Jun 19 22:38:36 2009
Last mount time:          Tue Dec 28 09:36:34 2010
Last write time:          Tue Dec 28 09:36:34 2010
Mount count:              8
Maximum mount count:      -1
Last checked:             Sun Dec 19 21:50:05 2010
Check interval:           0 (<none>)
Lifetime writes:          1992 GB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      5cdfe619-0de5-4bcd-85d2-5fa5f4f13da7
Journal backup:           inode blocks


lsusb 
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 007 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 002 Device 008: ID 046d:c70a Logitech, Inc. MX5000 Cordless Desktop
Bus 002 Device 007: ID 046d:c70e Logitech, Inc. MX1000 Bluetooth Laser Mouse
Bus 002 Device 006: ID 0424:2228 Standard Microsystems Corp. 9-in-2 Card 
Reader
Bus 002 Device 005: ID 046d:0b02 Logitech, Inc. BT Mini-Receiver (HID proxy 
mode)
Bus 002 Device 004: ID 04b8:012c Seiko Epson Corp. Perfection V350 (GT-F700)
Bus 002 Device 003: ID 0424:2602 Standard Microsystems Corp. USB 2.0 Hub
Bus 002 Device 002: ID 0424:2514 Standard Microsystems Corp. USB 2.0 Hub
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 001 Device 003: ID 1759:5000 LucidPort Technology, Inc. 
Bus 001 Device 002: ID 1058:1100 Western Digital Technologies, Inc. 
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

lspci 
00:00.0 Host bridge: Intel Corporation 82P965/G965 Memory Controller Hub (rev 
02)
00:01.0 PCI bridge: Intel Corporation 82P965/G965 PCI Express Root Port (rev 
02)
00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI 
Controller #4 (rev 02)
00:1a.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI 
Controller #5 (rev 02)
00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI 
Controller #2 (rev 02)
00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio 
Controller (rev 02)
00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 1 
(rev 02)
00:1c.3 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 4 
(rev 02)
00:1c.4 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 5 
(rev 02)
00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI 
Controller #1 (rev 02)
00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI 
Controller #2 (rev 02)
00:1d.2 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI 
Controller #3 (rev 02)
00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI 
Controller #1 (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev f2)
00:1f.0 ISA bridge: Intel Corporation 82801HB/HR (ICH8/R) LPC Interface 
Controller (rev 02)
00:1f.2 SATA controller: Intel Corporation 82801HB (ICH8) 4 port SATA AHCI 
Controller (rev 02)
00:1f.3 SMBus: Intel Corporation 82801H (ICH8 Family) SMBus Controller (rev 
02)
01:00.0 VGA compatible controller: nVidia Corporation G96 [GeForce 9400 GT] 
(rev a1)
02:00.0 SATA controller: JMicron Technology Corp. JMB362/JMB363 Serial ATA 
Controller (rev 02)
02:00.1 IDE interface: JMicron Technology Corp. JMB362/JMB363 Serial ATA 
Controller (rev 02)
03:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI 
Express Gigabit Ethernet controller (rev 01)
05:02.0 Multimedia video controller: Brooktree Corporation Bt878 Video Capture 
(rev 11)
05:02.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture (rev 
11)


Pointers would be appreciated, even if it's just "it's harmless, ignore it".

Thanks,
Con
-- 
-ck
