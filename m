From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14696] New: EXT4-fs error (device dm-3):
 ext4_mb_release_inode_pa: free 777, pa_free 778
Date: Thu, 26 Nov 2009 11:32:12 GMT
Message-ID: <bug-14696-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:34082 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbZKZLcG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 26 Nov 2009 06:32:06 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nAQBWCer019188
	for <linux-ext4@vger.kernel.org>; Thu, 26 Nov 2009 11:32:12 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14696

           Summary: EXT4-fs error (device dm-3): ext4_mb_release_inode_pa:
                    free 777, pa_free 778
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.30.8
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: olel@ans.pl
        Regression: No


Two hours ago my database server stopped working. I turned out to be a problem
with ext4:

pa ffff88063643bd00: logic 1024, phys. 2677760, len 1024
EXT4-fs error (device dm-3): ext4_mb_release_inode_pa: free 777, pa_free 778
Aborting journal on device dm-3:8.
Remounting filesystem read-only

The problem was fixed by:

# fsck /dev/VG0/sql
fsck from util-linux-ng 2.16.1
e2fsck 1.41.9 (22-Aug-2009)
/dev/mapper/VG0-sql_tmp: recovering journal
/dev/mapper/VG0-sql_tmp contains a file system with errors, check forced.
Pass 1: Checking inodes, blocks, and sizes
Deleted inode 66 has zero dtime.  Fix<y>? yes

Inodes that were part of a corrupted orphan linked list found.  Fix<y>? yes

Inode 67 was part of the orphaned inode list.  FIXED.
Inode 68 was part of the orphaned inode list.  FIXED.
Inode 69 was part of the orphaned inode list.  FIXED.
Inode 2975 was part of the orphaned inode list.  FIXED.
Deleted inode 3731 has zero dtime.  Fix<y>? yes

Inode 3732 was part of the orphaned inode list.  FIXED.
Inode 3733 was part of the orphaned inode list.  FIXED.
Inode 3734 was part of the orphaned inode list.  FIXED.
Inode 3735 was part of the orphaned inode list.  FIXED.
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Block bitmap differences:  -2678117
Fix<y>? yes

Inode bitmap differences:  -(66--69) -2975 -(3731--3735)
Fix<y>? yes

Free inodes count wrong for group #0 (4457, counted=4467).
Fix<y>? yes

Free inodes count wrong (2093400, counted=2093410).
Fix<y>? yes


/dev/mapper/VG0-sql_tmp: ***** FILE SYSTEM WAS MODIFIED *****
/dev/mapper/VG0-sql_tmp: 3742/2097152 files (19.4% non-contiguous),
963461/8388608 blocks

Before I started the fsck I had made a copy of that fs, so I'm still able to
provide a dump if necessary.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
