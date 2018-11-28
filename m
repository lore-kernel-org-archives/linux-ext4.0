Return-Path: <SRS0=QVqk=OH=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:46680 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725799AbeK2Hpr (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 29 Nov 2018 02:45:47 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 089082D97E
        for <linux-ext4@vger.kernel.org>; Wed, 28 Nov 2018 20:42:53 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Wed, 28 Nov 2018 20:42:51 +0000
Message-ID: <bug-201685-13602-VuKNIMsk7O@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

Laurent Bonnaud (L.Bonnaud@laposte.net) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |L.Bonnaud@laposte.net

--- Comment #67 from Laurent Bonnaud (L.Bonnaud@laposte.net) ---
I am also experiencing ext4 corruptions with 4.19.x kernels.

One way to trigger this bug that works almost every time on my system is to
backup the whole FS with BorgBackup using this command:

nice -19 ionice -c3 borg create -v --stats --list --filter=AME
--one-file-system --exclude-caches --compression zstd --progress
my-server:/borg-backup::'{hostname}-{now:%Y-%m-%d_%H:%M}' /

Here are kernel messages:

[  916.082499] EXT4-fs error (device sda1): ext4_iget:4831: inode #6318098:
comm borg: bad extra_isize 35466 (inode size 256)
[  916.093908] Aborting journal on device sda1-8.
[  916.096417] EXT4-fs (sda1): Remounting filesystem read-only
[  916.096799] EXT4-fs error (device sda1): ext4_iget:4831: inode #6318101:
comm borg: bad extra_isize 35466 (inode size 256)
[  916.101544] EXT4-fs error (device sda1): ext4_iget:4831: inode #6318103:
comm borg: bad extra_isize 35466 (inode size 256)
[  916.106531] EXT4-fs error (device sda1): ext4_iget:4831: inode #6318107:
comm borg: bad extra_isize 35466 (inode size 256)
[  916.111039] EXT4-fs error (device sda1): ext4_iget:4831: inode #6318110:
comm borg: bad extra_isize 35466 (inode size 256)
[  916.115763] EXT4-fs error (device sda1): ext4_iget:4831: inode #6318112:
comm borg: bad extra_isize 35466 (inode size 256)

If there is some interest, I can provide more details, but in another bug
report since this one is already loaded with attached files.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
