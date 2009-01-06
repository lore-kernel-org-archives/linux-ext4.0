From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12370] New: kernel BUG at fs/jbd2/journal.c:1108
Date: Tue,  6 Jan 2009 03:14:19 -0800 (PST)
Message-ID: <bug-12370-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37573 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751323AbZAFLOu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Jan 2009 06:14:50 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n06BEKbV024381
	for <linux-ext4@vger.kernel.org>; Tue, 6 Jan 2009 03:14:21 -0800
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12370

           Summary: kernel BUG at fs/jbd2/journal.c:1108
           Product: File System
           Version: 2.5
     KernelVersion: 2.6.28
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: dmaciejak@fortinet.com


Latest working kernel version: none
Earliest failing kernel version: unkwown
Distribution: ubuntu
Hardware Environment: dell optiplex 740
Software Environment:
Problem Description:
on mounting a specially crafted ext4 image the kernel oops, mount command gives
me a seg fault.
Steps to reproduce:
Mount the image provided with the following command:
mount -t ext4  -o loop ext4.212.img /media/tmp

Regards,

David Maciejak
Fortinet's FortiGuard Global Security Research Team


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
