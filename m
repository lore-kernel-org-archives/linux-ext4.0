Return-Path: <SRS0=iZZ9=OM=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:58700 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725850AbeLCT4G (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Dec 2018 14:56:06 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 61F302B5ED
        for <linux-ext4@vger.kernel.org>; Mon,  3 Dec 2018 19:56:04 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Mon, 03 Dec 2018 19:56:02 +0000
Message-ID: <bug-201685-13602-PVGXVr9fzJ@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #208 from Guenter Roeck (linux@roeck-us.net) ---
Created attachment 279827
  --> https://bugzilla.kernel.org/attachment.cgi?id=279827&action=edit
Reproducer

To reproduce, run the attached script on each mounted file system. Also, run a
linux kernel build with as much parallelism as you dare. On top of that, run a
backup program such as borg. I don't know if this is all needed, but with all
that I am able to reproduce the problem quite reliably, for the most part
within a few minutes.

Typical log:

[  357.330900] EXT4-fs error (device sda1): ext4_iget:4795: inode #5519385:
comm borg: bad extra_isize 4752 (inode size 256)
[  357.351658] Aborting journal on device sda1-8.
[  357.355728] EXT4-fs error (device sda1) in ext4_reserve_inode_write:5805:
Journal has aborted
[  357.355745] EXT4-fs error (device sda1) in ext4_reserve_inode_write:5805:
Journal has aborted
[  357.365397] EXT4-fs (sda1): Remounting filesystem read-only
[  357.365942] EXT4-fs error (device sda1): ext4_iget:4795: inode #5519388:
comm borg: bad extra_isize 2128 (inode size 256)
[  357.366167] EXT4-fs error (device sda1): ext4_journal_check_start:61:
Detected aborted journal
[  357.371296] EXT4-fs error (device sda1): ext4_journal_check_start:61:
Detected aborted journal
[  357.375832] EXT4-fs error (device sda1): ext4_journal_check_start:61:
Detected aborted journal
[  357.382480] EXT4-fs error (device sda1): ext4_journal_check_start:61:
Detected aborted journal
[  357.382486] EXT4-fs (sda1): ext4_writepages: jbd2_start: 5114 pages, ino
5273647; err -30
[  357.384839] EXT4-fs error (device sda1): ext4_lookup:1578: inode #5513104:
comm borg: deleted inode referenced: 5519390
[  357.387331] EXT4-fs error (device sda1): ext4_iget:4795: inode #5519392:
comm borg: bad extra_isize 3 (inode size 256)
[  357.396557] EXT4-fs error (device sda1): ext4_journal_check_start:61:
Detected aborted journal
[  357.428824] EXT4-fs error (device sda1): ext4_journal_check_start:61:
Detected aborted journal
[  357.437008] EXT4-fs error (device sda1) in ext4_dirty_inode:5989: Journal
has aborted
[  357.441953] EXT4-fs error (device sda1) in ext4_dirty_inode:5989: Journal
has aborted

As you can see, it took just about six minutes after boot to see the problem.
Kernel version in this case is v4.19.6 with the five patches per #99 reverted.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
