From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13201] New: kernel BUG at fs/ext4/extents.c:2737
Date: Tue, 28 Apr 2009 09:28:06 GMT
Message-ID: <bug-13201-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:41829 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120AbZD1J2I (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Apr 2009 05:28:08 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n3S9S6Yf023705
	for <linux-ext4@vger.kernel.org>; Tue, 28 Apr 2009 09:28:06 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13201

           Summary: kernel BUG at fs/ext4/extents.c:2737
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.29.1
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: franco@fugro-fsi.com.au
        Regression: No


I got this while testing ext4 on an external RAID system. The system has 4
identical RAID systems each with a single 13TB filesystem. Only one of the 4
failed the test which was to simply write 8GB files until the disk fills up.

The complete messages file is attached.

Apr 25 01:59:38 echo19 kernel: EXT4-fs error (device dm-2):
__ext4_get_inode_loc: unable to read inode block - inode=761860,
block=3612686232
Apr 25 01:59:38 echo19 kernel: EXT4-fs error (device dm-2) in
ext4_reserve_inode_write: IO failure
Apr 25 01:59:38 echo19 kernel: mpage_da_map_blocks block allocation failed for
inode 761860 at logical offset 699276 with max blocks 1024 with error -5
Apr 25 01:59:38 echo19 kernel: This should not happen.!! Data will be lost
Apr 25 01:59:38 echo19 kernel: ------------[ cut here ]------------
Apr 25 01:59:38 echo19 kernel: kernel BUG at fs/ext4/extents.c:2737!

The filesystem was totally inaccessible so I reset the system. On reboot, the
filesystem couldn't be mounted - bad superblock.

I ran fsck a few times before I could remount the filesystem, all the
directories were lost but the test files were intact in lost+found.

I can't see any errors anywhere that might indicate that this is a hardware
problem but these are brand new systems using SAS host connections which we
haven't used before.

I've remade the broken filesystem and restarted the test on this and 11 other
identical filesystems, I'll let you know if the problem reoccurs.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
