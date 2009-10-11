From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Sun, 11 Oct 2009 12:31:23 GMT
Message-ID: <200910111231.n9BCVNRb012586@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:55796 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbZJKMcA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 11 Oct 2009 08:32:00 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9BCVNiv012587
	for <linux-ext4@vger.kernel.org>; Sun, 11 Oct 2009 12:31:23 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #13 from Alexey Fisher <bug-track@fisher-privat.net>  2009-10-11 12:31:21 ---
Now i tryed to make this test clean as possible. 

1. start pc and after some time reset it or poweroff
2.after restart start kernel with option break=mount. it will not mount root fs
so use initrd instead.
3. mount root partition manually in reed only mode.
4. chroot 
5. fsck -y /dev/root >> fsck.log
6. fsck -y -f /dev/root >> fsck.log

on both kernel after krasch "fsck -y" will return:
=============================================================
fsck from util-linux-ng 2.16
/dev/mapper/zwerg_buntu-root_one: clean, 266498/1220608 files, 2444502/4882432
blocks

dmesg on mount will say this (looks like both kernel ak the same way):
=============================================================
[   32.797149] EXT3-fs: dm-0: couldn't mount because of unsupported optional
features (240).
[   32.808599] EXT4-fs (dm-0): INFO: recovery required on readonly filesystem
[   32.809755] EXT4-fs (dm-0): write access will be enabled during recovery
[   32.823038] EXT4-fs (dm-0): barriers enabled
[   33.014768] kjournald2 starting: pid 1166, dev dm-0:8, commit interval 5
seconds
[   33.014792] EXT4-fs (dm-0): delayed allocation enabled
[   33.014794] EXT4-fs: file extents enabled
[   33.014937] EXT4-fs: mballoc enabled
[   33.014954] EXT4-fs (dm-0): orphan cleanup on readonly fs
[   33.014958] EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode
131262
[   33.014994] EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode
131238
[   33.015004] EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode
131164
[   33.015014] EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode
131161
[   33.015023] EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode
131137
[   33.015032] EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode
131119
[   33.015041] EXT4-fs (dm-0): 6 orphan inodes deleted
[   33.015042] EXT4-fs (dm-0): recovery complete
[   33.397102] EXT4-fs (dm-0): mounted filesystem with ordered data mode

if force fsck "fsck -y -f .." on 2.6.31 kernel:
===========================================================
/dev/mapper/zwerg_buntu-root_one: clean, 266499/1220608 files, 2443934/4882432
blocks
fsck from util-linux-ng 2.16
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/dev/mapper/zwerg_buntu-root_one: 266499/1220608 files (0.7% non-contiguous),
2443934/4882432 blocks

on 2.6.32-rX:
===========================================================
/dev/mapper/zwerg_buntu-root_one: clean, 266474/1220608 files, 2444555/4882432
blocks
fsck from util-linux-ng 2.16
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Entry 'AB08-118C' in /media (32769) has deleted/unused inode 123461.  Clear?
yes

Entry 'mtab' in /var/lib/DeviceKit-disks (57430) has deleted/unused inode 393. 
Clear? yes

Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Unattached inode 407
Connect to /lost+found? yes

Inode 407 ref count is 2, should be 1.  Fix? yes

Inode 32769 ref count is 7, should be 6.  Fix? yes

Pass 5: Checking group summary information
Block bitmap differences:  -1606658 -1606772
Fix? yes

Free blocks count wrong for group #0 (9591, counted=9592).
Fix? yes

Free blocks count wrong (2437877, counted=2437878).
Fix? yes

Free inodes count wrong for group #15 (6623, counted=6624).
Fix? yes

Directories count wrong for group #15 (791, counted=790).
Fix? yes

Free inodes count wrong (954134, counted=954135).
Fix? yes


/dev/mapper/zwerg_buntu-root_one: ***** FILE SYSTEM WAS MODIFIED *****
/dev/mapper/zwerg_buntu-root_one: ***** REBOOT LINUX *****
/dev/mapper/zwerg_buntu-root_one: 266473/1220608 files (0.7% non-contiguous),
2444554/4882432 blocks

I i didn't get to reproduce it on kvm-qemu.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
