From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12551] New: end_request: I/O error, dev cciss/c0d0, sector 87435720
Date: Tue, 27 Jan 2009 06:51:58 -0800 (PST)
Message-ID: <bug-12551-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56916 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751020AbZA0OwU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Jan 2009 09:52:20 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0REpwVv015086
	for <linux-ext4@vger.kernel.org>; Tue, 27 Jan 2009 06:51:59 -0800
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12551

           Summary: end_request: I/O error, dev cciss/c0d0, sector 87435720
           Product: File System
           Version: 2.5
     KernelVersion: 2.6.29-rc2-git3
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: ralf.hildebrandt@charite.de


Latest working kernel version: 2.6.28.1
Earliest failing kernel version: 2.6.29-rc2-git3
Distribution: Debian/testing
Hardware Environment:
Software Environment:
Problem Description:

Steps to reproduce:

With 2.6.29-rc2-git3, I suddenly get:

[   73.306279] ip_tables: (C) 2000-2006 Netfilter Core Team
[   80.047614] end_request: I/O error, dev cciss/c0d0, sector 52257960
[   80.047689] JBD: barrier-based sync failed on cciss!c0d0p8:8 - disabling
barriers
[   80.089865] end_request: I/O error, dev cciss/c0d0, sector 87435720
[   80.089931] JBD: barrier-based sync failed on cciss!c0d0p9:8 - disabling
barriers
[   80.141581] end_request: I/O error, dev cciss/c0d0, sector 105586480
[   80.141643] JBD: barrier-based sync failed on cciss!c0d0p10:8 - disabling
barriers

With 2.6.28.1 I didn't get those.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
