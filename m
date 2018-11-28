Return-Path: <SRS0=QVqk=OH=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:43004 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728181AbeK2D3D (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 28 Nov 2018 22:29:03 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 408302DA39
        for <linux-ext4@vger.kernel.org>; Wed, 28 Nov 2018 16:26:50 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Wed, 28 Nov 2018 16:26:50 +0000
Message-ID: <bug-201685-13602-eRWxpD6Ed8@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

Néstor A. Marchesini (nestorm_des@hotmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |nestorm_des@hotmail.com

--- Comment #65 from Néstor A. Marchesini (nestorm_des@hotmail.com) ---
Hi.
My distro is gentoo testing, I also use 4 partitions raid1 ,are two discs of
1T WD black that have never failed.
These raid1 partitions use mdadm with metadata 0.90.

$ lsblk /dev/md*
RM RO MODEL NAME LABEL      FSTYPE MOUNTPOINT   SIZE PHY-SEC LOG-SEC MODE      
 0  0       md0  GentooBoot ext4                128M     512     512 brw-rw----
 0  0       md1  GentooSwap swap   [SWAP]         4G     512     512 brw-rw----
 0  0       md2  GentooRaiz ext4   /             50G     512     512 brw-rw----
 0  0       md3  GentooHome ext4   /home      877,4G     512     512 brw-rw----

Effectively from 4.19.0 I started to have problems with the boot, the system
always closed perfectly unmount all the partitions, but when booting the next
time I fall in fsck and end in recovery console, ignoring these errors, restart
again and I choose the kernel 4.18.20 and it does not fall in fsck, it also
does
not detect any error in the ext4 partitions.
Sometimes these errors trigger the resynchronization of the partition that fsck
detects false positives, I see it with $ cat /proc/mdstat
For now I will continue using 4.18.20, the faults I have been doing since
4.19.0
4.19.1 4.19.2 4.19.3 4.19.4 and 4.19.5, given that this is something from the
4.19.x branch

$ uname -a
Linux pc-user 4.18.20-gentoo #1 SMP PREEMPT Sat Nov 24 14:39:41

$ eselect kernel list 
Available kernel symlink targets:
  [1]   linux-4.18.20-gentoo
  [2]   linux-4.19.4-gentoo
  [3]   linux-4.19.5-gentoo *

Regards

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
