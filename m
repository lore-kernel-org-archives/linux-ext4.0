From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 118511] New: Corruption of VM qcow2 image file on EXT4 with
 crypto enabled
Date: Thu, 19 May 2016 14:50:42 +0000
Message-ID: <bug-118511-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:39061 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754636AbcESOur (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 May 2016 10:50:47 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 5EDED20376
	for <linux-ext4@vger.kernel.org>; Thu, 19 May 2016 14:50:45 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id B23CD20361
	for <linux-ext4@vger.kernel.org>; Thu, 19 May 2016 14:50:42 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=118511

            Bug ID: 118511
           Summary: Corruption of VM qcow2 image file on EXT4 with crypto
                    enabled
           Product: File System
           Version: 2.5
    Kernel Version: 4.5.3
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: ass3mbler@gmail.com
        Regression: No

Created attachment 216801
  --> https://bugzilla.kernel.org/attachment.cgi?id=216801&action=edit
Hypervisro kernel config file

Hello,

I have experienced two times in 48 hours a file system corruption on a QCOW2
image file running a linux Guest.

My configuration is the following:

Hypervisor:  
  - Gentoo Linux with a pure kernel 4.5.3, compiled manually.
  - QEMU 2.8.0 + KVM
  - /dev/md4, raid 1 with two identical partitions (/dev/sda4 and /dev/sdb4),
ext4
  - /dev/md4 is mounted under /mnt/md4 and it contains a single dir
/mnt/md4/kvm, encrypted  
  - after de-encrypting the /mnt/md4/kvm dir, it's bind-mounted in /kvm (mount
--bind /mnt/md4/ /kvm)
  - nothing else is actually running on the hypervisor, only an openssh server

Guest:
  - Gentoo Linux with a pure kernel 4.5.4, compiled manually
  - virtio drivers for disk, networking etc.
  - the whole image of the guest is a 250GB QCOW2 file, stored under
/kvm/xxx.qcow2 in the hypervisor's filesystem
  - the root partition is /dev/sda2 (about 230GB), EXT3

I'm running this configuration successfully on many other (even very busy)
deployments without any problem, the only difference in this installation is
the encrypted /mnt/md4/kvm directory on the hypervisor.

For two times in the lasts 48h I've found the root filesystem of the guest
(/dev/sda2) remounted in read-only mode after a detected write problem. Here is
the log from dmesg:

[[Guest]]
[208323.124266] blk_update_request: critical target error, dev sda, sector
231060144
[208323.124540] Aborting journal on device sda2-8.
[208323.729847] EXT4-fs error (device sda2): ext4_journal_check_start:56:
Detected aborted journal
[208323.729855] EXT4-fs (sda2): Remounting filesystem read-only
[208323.740861] EXT4-fs error (device sda2): ext4_journal_check_start:56:
Detected aborted journal
[208323.772340] EXT4-fs error (device sda2): ext4_journal_check_start:56:
Detected aborted journal
[208323.772346] EXT4-fs error (device sda2): ext4_journal_check_start:56:
Detected aborted journal
[208323.773233] EXT4-fs error (device sda2): ext4_journal_check_start:56:
Detected aborted journal


At the same time, on the hypervisor dmesg i have only this line:

[[Hypervisor]]
[596477.535490] ext4_bio_write_page: ret = -12

After that, I have to perform a reboot of the Guest. I've started the guest
from a gentoo iso and performed a fsck on the root (/dev/sda2) partition. This
is the output:

e2fsck 1.42.13 (17-May-2015)
/dev/sda2: recovering journal
/dev/sda2 contains a file system with errors, check forced.
Pass 1: Checking inodes, blocks, and sizes
Deleted inode 5709828 has zero dtime. Fix<y>? yes
Inodes that were part of a corrupted orphan linked list found. Fix<y>? yes
Inode 5709829 was part of the orphaned inode list. FIXED.
Inode 5709830 was part of the orphaned inode list. FIXED.
Inode 5709831 was part of the orphaned inode list. FIXED.
Inode 5709832 was part of the orphaned inode list. FIXED.
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Free blocks count wrong (25234981, counted=22539957).
Fix<y>? yes
Inode bitmap differences: -(5709828--5709832)
Fix<y>? yes
Free inodes count wrong for group #697 (8175, counted=8180).
Fix<y>? yes
Free inodes count wrong (11008395, counted=10993791).
Fix<y>? yes
/dev/sda2: ***** FILE SYSTEM WAS MODIFIED *****
/dev/sda2: 3424129/14417920 files (3.9% non-contiguous), 35131723/57671680
block

I attach the .config of the Hypervisor kernel.

Thank you in advance and best regards,

Andrew

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
