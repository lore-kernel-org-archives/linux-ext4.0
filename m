From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 51431] New: ext4_mb_generate_buddy self ext4 errors
Date: Sat,  8 Dec 2012 11:41:26 +0000 (UTC)
Message-ID: <bug-51431-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:44820 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291Ab2LHLl2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 8 Dec 2012 06:41:28 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id CCCB0201A1
	for <linux-ext4@vger.kernel.org>; Sat,  8 Dec 2012 11:41:27 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 373F32019C
	for <linux-ext4@vger.kernel.org>; Sat,  8 Dec 2012 11:41:26 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=51431

           Summary: ext4_mb_generate_buddy self ext4 errors
           Product: File System
           Version: 2.5
    Kernel Version: 3.0.54-1
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: zakrzewskim@wp.pl
        Regression: No


I'm getting ext4 errors in dmesg even if I unmount partition then make e4fsck
-fy -C0 /dev/md2.

I looks like this parition is mounted with no errors:

EXT4-fs (md2): mounted filesystem with ordered data mode. Opts:
usrjquota=aquota.user,grpjquota=aquota.group,usrquota,grpquota,jqfmt=vfsv0

then after few hours it shows itself:

EXT4-fs (md2): error count: 7
EXT4-fs (md2): initial error at 1354656587: ext4_mb_generate_buddy:736 EXT4-fs
(md2): last error at 1354664617: ext4_ext_split:929: inode 97911179

So far no other issues. 

Disks are fine. SMART ok. RAM checked with memtest and ok.

Partition mounted like this:

/dev/md2 /home ext4
rw,noatime,nodiratime,usrjquota=aquota.user,grpjquota=aquota.group,usrquota,grpquota,jqfmt=vfsv0
0 0

/dev/md2 2,7T 1,8T 885G 68% /home

md2 : active raid1 sdd3[2] sdc3[0]
      2914280100 blocks super 1.0 [2/2] [UU]

It happens only on 2x 3 TB RAID1 array.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
