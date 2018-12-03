Return-Path: <SRS0=iZZ9=OM=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:54168 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725903AbeLCVUb (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Dec 2018 16:20:31 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 993CC2B31C
        for <linux-ext4@vger.kernel.org>; Mon,  3 Dec 2018 21:20:30 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Mon, 03 Dec 2018 21:20:09 +0000
Message-ID: <bug-201685-13602-uROQRxta21@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #211 from Michel Roelofs (michel@michelroelofs.nl) ---
When I ran updatedb on 4.19.6, RETPOLINE disabled, I triggered within 2 minutes
the following errors (which I never saw with 4.14.x and older):
[  117.180537] BTRFS error (device dm-8): bad tree block start, want 614367232
have 23591879
[  117.222142] BTRFS info (device dm-8): read error corrected: ino 0 off
614367232 (dev /dev/mapper/linux-lxc sector 1216320)

And ~20 minutes later (while again running updatedb and compiling the kernel):
[ 1328.804705] EXT4-fs error (device dm-1): ext4_iget:4851: inode #7606807:
comm updatedb: checksum invalid

With debugfs I located the file of that inode, then I did an ls on it:
root@ster:# ls -l /home//michel/src/linux/linux/drivers/firmware/efi/test/
ls: cannot access '/home//michel/src/linux/linux/drivers/firmware/efi/test/':
Bad message
(reproduces)

Dropping dentry and inode cache (echo 2 > /proc/sys/vm/drop_caches) didn't
resolve this, but dropping all caches (echo 3 > /proc/sys/vm/drop_caches) did.

Both a simple 'ls' and also 'debugfs -R 'ncheck <inode>' did show errors, which
were resolved by the 'echo 3 > /proc/sys/vm/drop_caches'. See my comment #168
for 4.19.5.

My next step is to try without SMP. Does anybody have suggestions what else I
can try, or where I should look? What information to share?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
