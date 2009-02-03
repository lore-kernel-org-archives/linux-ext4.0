From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12624] New: umount hangs after fsstress with data=journal
Date: Tue,  3 Feb 2009 09:32:47 -0800 (PST)
Message-ID: <bug-12624-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42899 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752069AbZBCRdT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Feb 2009 12:33:19 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n13HWl5I001164
	for <linux-ext4@vger.kernel.org>; Tue, 3 Feb 2009 09:32:48 -0800
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12624

           Summary: umount hangs after fsstress with data=journal
           Product: File System
           Version: 2.5
     KernelVersion: 2.6.29-rc3-git3
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: aneesh.kumar@linux.vnet.ibm.com


[<c0498f7f>] inode_wait+0x8/0xc
[<c0499381>] clear_inode+0x4e/0xb9
[<c04997e1>] dispose_list+0x3c/0xc1
[<c0499adf>] invalidate_inodes+0xb3/0xc8
[<c048b9cc>] generic_shutdown_super+0x3c/0xc4
[<c048ba71>] kill_block_super+0x1d/0x31
[<c048bb2d>] deactivate_super+0x57/0x6a
[<c049c375>] mntput_no_expire+0xc2/0xf5
[<c049c84f>] sys_umount+0x284/0x2cf
[<c0403201>] sysenter_do_call+0x12/0x31
[<ffffffff>] 0xffffffff


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
