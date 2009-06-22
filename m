From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13604] New: cascade of "mpage_da_map_blocks block allocation
 failed" errors
Date: Mon, 22 Jun 2009 20:25:32 GMT
Message-ID: <bug-13604-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:59043 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbZFVUZ3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Jun 2009 16:25:29 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n5MKPW3G008026
	for <linux-ext4@vger.kernel.org>; Mon, 22 Jun 2009 20:25:32 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13604

           Summary: cascade of "mpage_da_map_blocks block allocation
                    failed" errors
           Product: File System
           Version: 2.5
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: bernie@codewiz.org
        Regression: No


While qemu was writing on a qcow2 image -- presumably a sparse, mmaped() file
--
the home partition filled up to the reserved block limit, and the kernel
started issuing a cascade of errors, making the system very unresponsive
for 30 seconds.

Eventually, the qemu process was killed with a SIGSEGV, but the system
was still unusable because every process attempting to read/write on /home
would lockup in an uninterruptable sleep state.

This is kernel-2.6.30-1.fc12.x86_64.

---cut---
Jun 22 20:49:03 localhost kernel: mpage_da_map_blocks block allocation failed
for inode 528965 at logical offset 607602 with max blocks 5 with error -28
Jun 22 20:49:03 localhost kernel: This should not happen.!! Data will be lost
Jun 22 20:49:03 localhost kernel: Total free blocks count 0
Jun 22 20:49:03 localhost kernel: Free/Dirty block details
Jun 22 20:49:03 localhost kernel: free_blocks=134303
Jun 22 20:49:03 localhost kernel: dirty_blocks=52621
Jun 22 20:49:03 localhost kernel: Block reservation details
Jun 22 20:49:03 localhost kernel: i_reserved_data_blocks=52465
Jun 22 20:49:03 localhost kernel: i_reserved_meta_blocks=156
Jun 22 20:49:03 localhost kernel: mpage_da_map_blocks block allocation failed
for inode 528965 at logical offset 608030 with max blocks 8 with error -28
Jun 22 20:49:03 localhost kernel: This should not happen.!! Data will be lost
Jun 22 20:49:03 localhost kernel: Total free blocks count 0
Jun 22 20:49:03 localhost kernel: Free/Dirty block details
Jun 22 20:49:03 localhost kernel: free_blocks=134303
Jun 22 20:49:03 localhost kernel: dirty_blocks=52621
Jun 22 20:49:03 localhost kernel: Block reservation details
Jun 22 20:49:03 localhost kernel: i_reserved_data_blocks=52465
Jun 22 20:49:03 localhost kernel: i_reserved_meta_blocks=156
Jun 22 20:49:09 localhost kernel: mpage_da_map_blocks block allocation failed
for inode 125287 at logical offset 4 with max blocks 1 with error -28
Jun 22 20:49:09 localhost kernel: This should not happen.!! Data will be lost
Jun 22 20:49:09 localhost kernel: Total free blocks count 0
Jun 22 20:49:09 localhost kernel: Free/Dirty block details
Jun 22 20:49:09 localhost kernel: free_blocks=134303
Jun 22 20:49:09 localhost kernel: dirty_blocks=52624
Jun 22 20:49:09 localhost kernel: Block reservation details
Jun 22 20:49:09 localhost kernel: i_reserved_data_blocks=1
Jun 22 20:49:09 localhost kernel: i_reserved_meta_blocks=2
Jun 22 20:52:36 localhost libvirtd: 20:52:36.573: warning :
qemudDispatchSignalEvent:362 : Shutting down on signal 15
---cut---

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
