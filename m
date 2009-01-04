From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12354] New: Advisory: Debian's current initramdisk scripts break with an ext4 root
Date: Sat,  3 Jan 2009 23:02:15 -0800 (PST)
Message-ID: <bug-12354-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43150 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750764AbZADHCr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 4 Jan 2009 02:02:47 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0472Fbg019972
	for <linux-ext4@vger.kernel.org>; Sat, 3 Jan 2009 23:02:16 -0800
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12354

           Summary: Advisory: Debian's current initramdisk scripts break
                    with an ext4 root
           Product: File System
           Version: 2.5
     KernelVersion: 2.6.28
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: enhancement
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: jimsantelmo@gmail.com


This is just a heads-up to hopefully save other people some time. I'm running
2.6.28 with debian/unstable, finally converted the root to ext4, and discovered
that Debian with an initrd can't boot it because the initrd scripts apparently
decide it is an ext3 filesystem with unsupported features. Not that they report
this: instead you get an ENODEV message that had me convinced ext4 wasn't
registering itself or some other such weirdness. Works fine if you use a
"rootfstype=ext4" kernel boot parameter, or no initrd.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
