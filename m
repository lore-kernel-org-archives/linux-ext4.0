From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15420] New: EXT4_USE_FOR_EXT23 causes wrong free space
 calculation on ext2 and ext3
Date: Mon, 1 Mar 2010 18:18:34 GMT
Message-ID: <bug-15420-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:34603 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab0CASSh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Mar 2010 13:18:37 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o21IIYh0026044
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 1 Mar 2010 18:18:35 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=15420

           Summary: EXT4_USE_FOR_EXT23 causes wrong free space calculation
                    on ext2 and ext3
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.33
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: thomas@archlinux.org
        Regression: No


When enabling the EXT4_USE_FOR_EXT23 option in 2.6.33. The free space
calculation on ext2 and ext3 becomes incorrect. Steps to reproduce:

1) Create ext2 or ext3 file system with mkfs
2) Mount it on a kernel with EXT4_USE_FOR_EXT23 enabled
3) Launch "watch -n1 df -h /path/to/mountpoint" in another terminal
4) Download a file with wget

The "used space" on the ext2/3 will now increase by about 500MB per second.
Once you stop the download and type "sync" (or wait for a while), the values
shown for free/used space return to expected values. This is always
reproducible.

We can reproduce this on x86_32 and x86_64 with the Arch Linux distribution
kernel, as well as my own personal Core2-optimized 64 Bit kernel.

.config x86_32:
http://repos.archlinux.org/wsvn/packages/kernel26/trunk/config?rev=70484
.config x86_64:
http://repos.archlinux.org/wsvn/packages/kernel26/trunk/config.x86_64?rev=70484

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
