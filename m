From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12630] New: EXT3-fs error (device dm-1): ext3_new_block: Allocating block in system zone
Date: Wed,  4 Feb 2009 00:48:51 -0800 (PST)
Message-ID: <bug-12630-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41264 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751527AbZBDIsx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Feb 2009 03:48:53 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n148mpSm023086
	for <linux-ext4@vger.kernel.org>; Wed, 4 Feb 2009 00:48:52 -0800
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12630

           Summary: EXT3-fs error (device dm-1): ext3_new_block: Allocating
                    block in system zone
           Product: File System
           Version: 2.5
     KernelVersion: 2.6.28.2
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext3
        AssignedTo: fs_ext3@kernel-bugs.osdl.org
        ReportedBy: juris.krumins@ctco.lv


I'm experiencing problem with fs, reflected by the following errors:

...
EXT3-fs error (device dm-1): ext3_new_block: Allocating block in system zone -
blocks from 537690639, length 1
EXT3-fs error (device dm-1): ext3_new_block: Allocating block in system zone -
blocks from 537690640, length 1
EXT3-fs error (device dm-1): ext3_new_block: Allocating block in system zone -
blocks from 537690641, length 1
EXT3-fs error (device dm-1): ext3_new_block: Allocating block in system zone -
blocks from 537690642, length 1
EXT3-fs error (device dm-1): ext3_new_block: Allocating block in system zone -
blocks from 537690643, length 1
EXT3-fs error (device dm-1): ext3_new_block: Allocating block in system zone -
blocks from 537690644, length 1
EXT3-fs error (device dm-1): ext3_new_block: Allocating block in system zone -
blocks from 537690645, length 1
EXT3-fs error (device dm-1): ext3_new_block: Allocating block in system zone -
blocks from 537690646, length 1
EXT3-fs error (device dm-1): ext3_new_block: Allocating block in system zone -
blocks from 537690647, length 1
...

Distribution  - CentOS 5.2
Hardware used - IBM x3650 with ServerRAID10K raid controller and EXP3000 disk
bay (12 SATA disks, RAID0. Total LD size ~8TB).
Tested with different default centos kernels (kernel-2.6.18-92.el5,
kernel-2.6.18-92.1.22.el5), the same
error. Tested also with custom 2.6.28.2 kernel and different FS flags, no
changes.
Hardware used - IBM x3650 with ServerRAID10K raid controller and EXP3000 disk
bay (12 SATA disks, RAID0. Total LD size ~8TB).
Right now running test on 2.6.28.2 with different FS flags, partition sizes and
so on. More that that, dm-crypt module is used
for this partition. But I think it's not dm-crypt related issue.


Right now I'm trying to update mu e2fsprogs utulities and run tests. Still
running and it's seems like FS, created with new e2fsprogs,
 looks more stable.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
