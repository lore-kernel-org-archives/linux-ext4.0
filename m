From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 186551] New: mkfs.ext4 tries to discard sector beyond the end
 of the device
Date: Tue, 01 Nov 2016 17:30:21 +0000
Message-ID: <bug-186551-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:49238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751317AbcKARaY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 1 Nov 2016 13:30:24 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id D30A720386
        for <linux-ext4@vger.kernel.org>; Tue,  1 Nov 2016 17:30:22 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id BC2ED2024F
        for <linux-ext4@vger.kernel.org>; Tue,  1 Nov 2016 17:30:21 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=186551

            Bug ID: 186551
           Summary: mkfs.ext4 tries to discard sector beyond the end of
                    the device
           Product: File System
           Version: 2.5
    Kernel Version: 3.10.0-327.36.3.el7.x86_64
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: tom@vincze.org
        Regression: No

800GB Intel P3700 SSD has 195,352,576 4k sectors, but mkfs.ext4 tried to
discard sector 1,530,955,776 that is beyond the end of the device.

# mkfs.ext4 /dev/nvme0n1p1
mke2fs 1.42.9 (28-Dec-2013)
Discarding device blocks: failed - Input/output error
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
Stride=0 blocks, Stripe width=0 blocks
48840704 inodes, 195352576 blocks
9767628 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=2344615936
5962 block groups
32768 blocks per group, 32768 fragments per group
8192 inodes per group
Superblock backups stored on blocks: 
    32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208, 
    4096000, 7962624, 11239424, 20480000, 23887872, 71663616, 78675968, 
    102400000

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (32768 blocks): done
Writing superblocks and filesystem accounting information: done     

[61825.159172] blk_update_request: I/O error, dev nvme0n1, sector 1530955776

# parted /dev/nvme0n1 "unit s" "print"
Model: Unknown (unknown)
Disk /dev/nvme0n1: 195353046s
Sector size (logical/physical): 4096B/4096B
Partition Table: gpt
Disk Flags: 

Number  Start  End         Size        File system  Name     Flags
 1      256s   195352831s  195352576s               primary

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
