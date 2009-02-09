From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12679] New: 2.6.28.4 ext4 fs hang, load 22 and up, may be firefox/apps stuck on sync_page
Date: Mon,  9 Feb 2009 07:52:43 -0800 (PST)
Message-ID: <bug-12679-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59954 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754885AbZBIPxS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Feb 2009 10:53:18 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n19FqhSR024329
	for <linux-ext4@vger.kernel.org>; Mon, 9 Feb 2009 07:52:44 -0800
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12679

           Summary: 2.6.28.4 ext4 fs hang, load 22 and up, may be
                    firefox/apps stuck on sync_page
           Product: File System
           Version: 2.5
     KernelVersion: 2.6.28.4
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: sec@dschroeder.info


Latest working kernel version: ?
Earliest failing kernel version: ?
Distribution: Gentoo
Hardware Environment: Desktop, Athlon X2 5050e, 4GB Ram, mcp55, hd103ui
Software Environment: amd64 gentoo linux,kernel.org 2.6.28.4, e2fsprogs 1.41.4
Problem Description: using the system, applications accessing the "faulty"
filesystem hang, load increases to 23.00, dmesg is nothing special, top shows
two cores in nearly 100% wait 

Steps to reproduce: dont know yet


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
