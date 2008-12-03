From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12151] New: Unexplained fsck errors on a ext4 filesystem
Date: Wed,  3 Dec 2008 13:38:32 -0800 (PST)
Message-ID: <bug-12151-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60239 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751568AbYLCViy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Dec 2008 16:38:54 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mB3LcW6u031517
	for <linux-ext4@vger.kernel.org>; Wed, 3 Dec 2008 13:38:33 -0800
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12151

           Summary: Unexplained fsck errors on a ext4 filesystem
           Product: File System
           Version: 2.5
     KernelVersion: kernel-2.6.27.5-117.fc10.x86_64
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: kernel-bugzilla@cygnusx-1.org


Distribution: Fedora 10
Hardware Environment: 

Processor:
Q6600 2.4ghz

Memory:
4gb

dmidecode:
Manufacturer: ASUSTeK Computer INC.
Product Name: P5B-Deluxe

lspci:
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
00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 1
(rev 02)
00:1c.2 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 3
(rev 02)
00:1c.4 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 5
(rev 02)
00:1c.5 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 6
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
00:1f.2 SATA controller: Intel Corporation 82801HR/HO/HH (ICH8R/DO/DH) 6 port
SATA AHCI Controller (rev 02)
00:1f.3 SMBus: Intel Corporation 82801H (ICH8 Family) SMBus Controller (rev 02)
02:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8056 PCI-E
Gigabit Ethernet Controller (rev 12)
03:00.0 SATA controller: JMicron Technologies, Inc. JMicron 20360/20363 AHCI
Controller (rev 02)
03:00.1 IDE interface: JMicron Technologies, Inc. JMicron 20360/20363 AHCI
Controller (rev 02)
04:00.0 Ethernet controller: Intel Corporation 82572EI Gigabit Ethernet
Controller (Copper) (rev 06)
06:01.0 Multimedia audio controller: Creative Labs SB Audigy (rev 04)
06:01.1 Input device controller: Creative Labs SB Audigy Game Port (rev 04)
06:01.2 FireWire (IEEE 1394): Creative Labs SB Audigy FireWire Port (rev 04)
06:02.0 Ethernet controller: Lite-On Communications Inc LNE100TX (rev 20)
06:03.0 FireWire (IEEE 1394): Texas Instruments TSB43AB22/A IEEE-1394a-2000
Controller (PHY/Link)
06:04.0 Ethernet controller: Marvell Technology Group Ltd. 88E8001 Gigabit
Ethernet Controller (rev 14)


Software Environment:
e2fsprogs-1.41.3-2.fc10.x86_64
rsync-3.0.4-0.fc10.x86_64

Problem Description:
I rebooted and received the errors below from fsck. The nature of the errors
suggest to me a race condition or off by one bug. In all but one case the
problem is the count being off by one. In the one exception the count is off by
two.

I didn't receive complaints from fsck on previous reboots after the creation of
the filesystem. The shutdown before the startup that resulted in these errors
seemed to have gone normally.

I do remember rsync complaining about at least mpc1211 during the rsync that
copied the data across the network from another system. I don't remember the
complaint.

Most of the files on the filesystem are video files in the 100mb+ range. There
are also other large files like isos, virtualization images, etc. All the files
complained about are really small files.

The underlying layers are Linux software raid5 running on 6 1tb hard drives.
Other arrays using the same drives are raid1 and raid10.

mkfs command used to make the filesystem:
mkfs.ext4 -j -b 4096 -i 524288 -m 0 -E stride=256 -O extents /dev/md3

Other messages that may relate:

EXT4-fs: barriers enabled
EXT4-fs: barriers enabled
EXT4-fs: barriers enabled
JBD: barrier-based sync failed on md1:8 - disabling barriers
JBD: barrier-based sync failed on md2:8 - disabling barriers
JBD: barrier-based sync failed on md3:8 - disabling barriers

df -h output:
/dev/md1               32G  5.3G   25G  18% /
/dev/md0              198M   14M  174M   8% /boot
/dev/md2              288G   60G  229G  21% /home
/dev/md3              4.1T  2.3T  1.8T  56% /home/data



An automatic fsck check on boot started, and saw errors.

Group descriptor 374 has invalid unused inodes count 1
Group descriptor 375 has invalid unused inodes count 1
Group descriptor 588 has invalid unused inodes count 1
Group descriptor 940 has invalid unused inodes count 1
Group descriptor 1230 has invalid unused inodes count 1
Group descriptor 1486 has invalid unused inodes count 1
Group descriptor 1834 has invalid unused inodes count 1
Group descriptor 2444 has invalid unused inodes count 1
Group descriptor 2854 has invalid unused inodes count 1
Group descriptor 3066 has invalid unused inodes count 1
Group descriptor 3210 has invalid unused inodes count 1
Group descriptor 3933 has invalid unused inodes count 1
Group descriptor 4656 has invalid unused inodes count 1
Extended attribute block 12255232 has reference count 3 should be 1

Pass 1
Extended attribute block 12255232 has reference count 3 should be 1

Pass 2
Entry '..' in ??? (314882) has incorrent filetype (was 2, should be 1).
Entry 'txdps.tex' in
/backup/home/backup/11-26-2006/home/backup/12-3-2005/usr/share/texmf/tex/generic/texdraw
(453383) has incorrect filetype (was 1, should be 2).
Entry 'mpc1211' in
/backup/home/backup/11-26/2006/home/backup/12-3-2005/usr/src/kernels/2.6.14-1.1637_FC4-x86_64/arch/sh/boards
(469489) is a link to directory /home/backup/home/backup/11-26-2006/home/backup
/12-3-2005/usr/share/texmf/tex/generic/texdraw/txdps.tex (469505).
Entry 'gencfg.c' in /backup/home/builder/mozilla/nsprpub/pr/include (995609)
has an incorrect filetype (was 1, should be 2).
Entry 'CVS' in
/backup/home/builder/mozilla/toolkit/themes/pinstripe/mozapps/extentions
(1006847) in a link to directory
/backup/home/builder/mozilla/nsprpub/pr/include/gencfg.c (1006849).
Entry 'lost+found' in /video/movies (181) has incorrect filetype (was 2, should
be 1).
Entry 'text_italic.png' in
/backup/home/backup/11-26-2006/usr/share/icons/crystalsvg/16x16/actions
(613940) has incorrect filetype (was 1, should be 2).
Entry 'ko' in /backup/home/backup/11-26-2006/usr/share/local (621673) is a link
to directory
/backup/home/backup/11-26-2006/usr/share/icons/crystalsvg/16x16/actions/text_italic.png
(625665).

Pass 3
Unconnected directory inode 314882 (???)
'..' in
/backup/home/backup/11-26-2006/home/backup/12-3-2005/usr/share/texmf/tex/generic/texdraw/txdps.tex
(469505) is
/backup/home/backup/11-26-2006/home/backup/12-3-2005/usr/src/kernels/2.6.14-1.1637_FC4-x
86_64/arch/sh/boards (469489), should be
/backup/home/backup/11-26-2006/home/backup/12-3-2005/usr/share/texmf/tex/generic/texdraw
(453383).
'..' in
/backup/home/backup/11-26-2006/usr/share/icons/crystalsvg/16x16/actions/text_italic.png
(625665) is /backup/home/backup/11-26-2006/usr/share/locale (621673), should be
/backup/home/backup/11-26-2006/
usr/share/icons/crystalsvg/16x16/actions (613940).
'..' in /backup/home/builder/mozilla/nsprpub/pr/include/gencfg.c (1006849) is
/backup/home/builder/mozilla/toolkit/themes/pinstripe/mozapps/extensions
(1006847), should be /backup/home/builder/mozilla/nsprpu
b/pr/include (995609).

Pass 4
Inode 181 ref count is 12, should be 11.
Inode 82141 ref is 1, should be 2.
Inode 95745 ref count is 1, should be 2.
Inode 96001 ref count is 1, should be 2.
Inode 150529 ref count is 1, should be 2.
Inode 240641 ref count is 1, should be 2.
Inode 314016 ref count is 347, should be 346.
Inode 314881 ref count is 0, should be 2.
Inode 314882 ref count is 3, should be 2.
Inode 380416 ref count is 4, should be 3.
Inode 380417 ref count is 1, should be 2.
Inode 730596 ref count is 14, should be 13.
Inode 730625 ref count is 1, should be 2.
Inode 730723 ref count is 284, should be 283.
Inode 784897 ref count is 1, should be 2.
Inode 821761 ref count is 1, should be 2.
Inode 1191927 ref count is 7, should be 6.
Inode 1191937 ref count is 1, should be 2.

Pass 5
Block bitmap differences: -40304640 -48693248 -59540393 -79796520 -93519872
-105185280 -(128714059--128714061) -152568096
Free blocks count wrong for group #1230 (1845, counted=1846).
Free blocks count wrong for group #1486 (1851, counted=1852).
Free blocks count wrong for group #1817 (910, counted=911).
Free blocks count wrong for group #2454 (1149, counted=1150)
Free blocks count wrong for group #3210 (1845, counted=1846).
Free blocks count wrong for group #3928 (31706, counted=31709).
Free blocks count wrong for group #4656 (1540, counted=1541).
Free blocks count wrong (494216298, counted=494216308).
Free inodes count wrong for group #374 (0, counted=1).
Free inodes count wrong for group #375 (0, counted=1).
Free inodes count wrong for group #588 (0, counted=1).
Free inodes count wrong for group #940 (0, counted=1).
Free inodes count wrong for group #1230 (0, counted=1).
Directories count wrong for group #1230 (194, counted=193).
Free inodes count wrong for group #1486 (0, counted=1).
Directories count wrong for group #1486 (197, counted=196).
Free inodes count wrong for group #1834 (0, counted=1).
Free inodes count wrong for group #2444 (0, counted=1).
Free inodes count wrong for group #2854 (0, counted=1).
Directories count wrong for group #2854 (67, counted=66).
Free inodes count wrong for group #3066 (0, counted=1).
Free inodes count wrong for group #3210 (0, counted=1).
Directories count wrong for group #3210 (201, counted=200).
Free inodes count wrong for group #3933 (0, counted=1).
Free inodes count wrong for group #4656 (0, counted=1).
Directories count wrong for group #4656 (104, counted=103).
Free inodes count wrong (6899829, counted=6899842).


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
