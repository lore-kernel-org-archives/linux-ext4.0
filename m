Return-Path: <SRS0=gW7+=OL=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:41224 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725788AbeLBVeR (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Dec 2018 16:34:17 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 628142A81F
        for <linux-ext4@vger.kernel.org>; Sun,  2 Dec 2018 21:34:13 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Sun, 02 Dec 2018 21:34:12 +0000
Message-ID: <bug-201685-13602-psqcKX4Bhr@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

Michel Roelofs (michel@michelroelofs.nl) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |michel@michelroelofs.nl

--- Comment #168 from Michel Roelofs (michel@michelroelofs.nl) ---
Hereby my experience that may be related:

[ 2451.982816] EXT4-fs error (device dm-1): ext4_iget:4831: inode #6029313:
comm ls: bad extra_isize 5 (inode size 256)
root@ster:/# debugfs -R 'ncheck 6029313' /dev/dm-1
debugfs 1.43.4 (31-Jan-2017)
Inode   Pathname
6029313 //sabnzb
ncheck: Inode checksum does not match inode while doing inode scan

root@ster:/# echo 2 > /proc/sys/vm/drop_caches
root@ster:/# debugfs -R 'ncheck 6029313' /dev/dm-1
debugfs 1.43.4 (31-Jan-2017)
Inode   Pathname
6029313 //sabnzb
ncheck: Inode checksum does not match inode while doing inode scan

root@ster:/#  echo 3 > /proc/sys/vm/drop_caches
root@ster:/# debugfs -R 'ncheck 6029313' /dev/dm-1
debugfs 1.43.4 (31-Jan-2017)
Inode   Pathname
6029313 //sabnzb

Kernel v4.19.5, CPU Intel Atom D525, Debian Linux 9.6, brand new WDC
WD40EFRX-68N32N0, gcc 6.3.0-18+deb9u1.

Also seen with an ext4 filesystem created on Nov 21 2018.

Also seen with earlier 4.19.0 kernel, and older WDC WD30EFRX-68A in same
computer.

Going back to v4.18.<latest> kernel solved the issues. No disk corruption shown
by e2fsck.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
