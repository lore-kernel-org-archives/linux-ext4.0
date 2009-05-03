From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13230] New: unexplained fsck error with ext4 on software raid
 10
Date: Sun, 3 May 2009 12:54:51 GMT
Message-ID: <bug-13230-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:46747 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbZECMyv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 3 May 2009 08:54:51 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n43Cspt8020223
	for <linux-ext4@vger.kernel.org>; Sun, 3 May 2009 12:54:51 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13230

           Summary: unexplained fsck error with ext4 on software raid 10
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.29.2
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: flo@dotbox.org
        Regression: No


Distribution: Archlinux

Hardware Environment: 

Processor: Intel(R) Atom(TM) CPU  330 @ 1.60GHz (Dual-Core)
Memory: 2GB

lspci:
00:00.0 Host bridge: Intel Corporation 82945G/GZ/P/PL Memory Controller Hub
(rev 02)
00:02.0 VGA compatible controller: Intel Corporation 82945G/GZ Integrated
Graphics Controller (rev 02)
00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 1
(rev 01)
00:1c.2 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 3
(rev 01)
00:1c.3 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 4
(rev 01)
00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI
Controller #1 (rev 01)
00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI
Controller #2 (rev 01)
00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI
Controller #3 (rev 01)
00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI
Controller #4 (rev 01)
00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI
Controller (rev 01)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev e1)
00:1f.0 ISA bridge: Intel Corporation 82801GB/GR (ICH7 Family) LPC Interface
Bridge (rev 01)
00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE Controller
(rev 01)
00:1f.2 IDE interface: Intel Corporation 82801GB/GR/GH (ICH7 Family) SATA IDE
Controller (rev 01)
00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 01)
01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI
Express Gigabit Ethernet controller (rev 02)
04:00.0 Mass storage controller: Promise Technology, Inc. PDC40718 (SATA 300
TX4) (rev 02)


Software:
e2fsprogs-1.41.5-2

Problem description:

I have a linux software raid10 using four discs (SAMSUNG HD103SI 1TB Sata)
created with the following command:
mdadm --create /dev/md0 --assume-clean --chunk=128 --level=raid10
--raid-devices=4 --spare-devices=0 --layout=f2 /dev/sdb1 /dev/sdc1 /dev/sdd1
/dev/sde1

On this md0 i created a ext4 filesystem using:
mkfs.ext4 -O large_file,dir_index,sparse_super -E stride=32,stripe-width=128 -b
4096 /dev/md0

After doing some load on the disks, coping some files and so on, i rebooted the
machine. I tried to mount the filesystem after the reboot manualy, but i
couldnt, i was advised to run fsck, which gives me errors:

[root@hal9000 ~]# fsck /dev/md0
fsck 1.41.5 (23-Apr-2009)
e2fsck 1.41.5 (23-Apr-2009)
fsck.ext4: Group descriptors look bad... trying backup blocks...
Group descriptor 0 checksum is invalid.  Fix<y>? yes
Group descriptor 1 checksum is invalid.  Fix<y>? yes
Group descriptor 2 checksum is invalid.  Fix<y>? yes
Group descriptor 3 checksum is invalid.  Fix<y>? yes
Group descriptor 4 checksum is invalid.  Fix<y>? yes
Group descriptor ... checksum is invalid.  Fix<y>? yes
Group descriptor 14904 checksum is invalid.  Fix? yes

/dev/md0 contains a file system with errors, check forced.
Resize inode not valid.  Recreate? yes

Pass 1: Checking inodes, blocks, and sizes
Inode 83425 is in use, but has dtime set.  Fix? yes

Inode 83425 has imagic flag set.  Clear? yes

Inode 83425 has a extra size (24906) which is invalid
Fix? yes

Inode 83426 is in use, but has dtime set.  Fix? yes

Inode 83426 has imagic flag set.  Clear? yes

Inode 83426 has a extra size (15123) which is invalid
Fix? yes

Inode 83426 has compression flag set on filesystem without compression support.
 Clear? yes

Error while reading over extent tree in inode 83426: Corrupt extent header
Clear inode? yes

Inode 83426, i_blocks is 2892048078, should be 0.  Fix? yes

Inode 83427 is in use, but has dtime set.  Fix? yes

Inode 83427 has a extra size (30948) which is invalid
Fix? yes

Inode 83427 has compression flag set on filesystem without compression support.
 Clear? yes

Inode 83427, i_size is 6852659100897434679, should be 0.  Fix? yes

Inode 83427, i_blocks is 24634205603455, should be 0.  Fix? yes

Inode 83428 is in use, but has dtime set.  Fix? yes

Inode 83428 has imagic flag set.  Clear? yes

Inode 83428 has a extra size (10145) which is invalid
Fix? yes

Inode 83428 has INDEX_FL flag set but is not a directory.
Clear HTree index? yes

Inode 83428, i_size is 4063880120011657287, should be 0.  Fix? yes

......



Inode 83432 has INDEX_FL flag set but is not a directory.
Clear HTree index? yes

Inode 83432, i_size is 10651702139991005323, should be 0.  Fix? yes

Inode 83432, i_blocks is 75253109187231, should be 0.  Fix? yes

Inode 83436 has compression flag set on filesystem without compression support.
 Clear? yes

Inode 83436 has INDEX_FL flag set but is not a directory.
Clear HTree index? yes

Inode 83436, i_size is 1452293747930507946, should be 0.  Fix? yes

Inode 83436, i_blocks is 225351860648724, should be 0.  Fix? yes

Inode 83437 has compression flag set on filesystem without compression support.
 Clear? yes

Inode 83437, i_size is 10409160169330118727, should be 0.  Fix? yes

Inode 83437, i_blocks is 52103229380007, should be 0.  Fix? yes

Inode 83440 has compression flag set on filesystem without compression support.
 Clear? yes

Inode 83440 has a bad extended attribute block 258978553.  Clear? yes

Inode 83440, i_size is 16993295139261714503, should be 0.  Fix? yes

Inode 83440, i_blocks is 267701257729082, should be 0.  Fix? yes

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
