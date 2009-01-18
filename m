From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12478] New: Infinite loop printing "__find_get_block_slow() failed." on accessing intentionally corrupted ext4 fs
Date: Sun, 18 Jan 2009 09:09:17 -0800 (PST)
Message-ID: <bug-12478-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37773 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759669AbZARRJq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 18 Jan 2009 12:09:46 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0IH9HwZ015457
	for <linux-ext4@vger.kernel.org>; Sun, 18 Jan 2009 09:09:18 -0800
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12478

           Summary: Infinite loop printing "__find_get_block_slow() failed."
                    on accessing intentionally corrupted ext4 fs
           Product: File System
           Version: 2.5
     KernelVersion: 2.6.29-rc2 + the patches for #12430
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: sliedes@cc.hut.fi


Hardware Environment: qemu x86
Software Environment: Minimal Debian sid/unstable
Problem Description:

Accessing the attached intentionally corrupted ext4 filesystem causes a
seemingly infinite (at least _very_ long) loop where kernel floods dmesg with
these messages:

[   67.126302] __find_get_block_slow() failed. block=4294967296, b_blocknr=0
[   67.126609] b_state=0x00000020, b_size=1024
[   67.126798] device blocksize: 1024
[   67.126972] __find_get_block_slow() failed. block=4294967296, b_blocknr=0
[   67.127244] b_state=0x00000020, b_size=1024
[   67.127415] device blocksize: 1024
[   67.127573] __find_get_block_slow() failed. block=4294967296, b_blocknr=0
[   67.127844] b_state=0x00000020, b_size=1024
... ad infinitum

Steps to reproduce:

1. bunzip2 the attached filesystem image
2. mount hdb.153 /mnt -t ext4 -o loop,errors=continue
3. rm -rf /mnt >&/dev/null


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
