From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12829] New: kernel complains on ENOSPC
Date: Fri,  6 Mar 2009 14:33:05 -0800 (PST)
Message-ID: <bug-12829-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51296 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752121AbZCFWdl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Mar 2009 17:33:41 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n26MX62S031730
	for <linux-ext4@vger.kernel.org>; Fri, 6 Mar 2009 14:33:07 -0800
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12829

           Summary: kernel complains on ENOSPC
           Product: File System
           Version: 2.5
     KernelVersion: 2.6.29-rc6
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: sandeen@redhat.com


while copying a few very large files to ext4:

mpage_da_map_blocks block allocation failed for inode 12289 at logical offset
443072 with max blocks 1036 with error -28
This should not happen.!! Data will be lost
Total free blocks count 0
Free/Dirty block details
free_blocks=0
dirty_blocks=1179
Block reservation details
i_reserved_data_blocks=1174
i_reserved_meta_blocks=5
mpage_da_map_blocks block allocation failed for inode 12289 at logical offset
444108 with max blocks 138 with error -28
This should not happen.!! Data will be lost
Total free blocks count 0
Free/Dirty block details
free_blocks=0
dirty_blocks=1179
Block reservation details
i_reserved_data_blocks=1174
i_reserved_meta_blocks=5

haven't dug into it, but this is just ENOSPC; ext4 should be more graceful.

-Eric


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
