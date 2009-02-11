From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12686] New: kernel oops __ticket_spin_lock
Date: Wed, 11 Feb 2009 02:54:08 -0800 (PST)
Message-ID: <bug-12686-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35128 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754337AbZBKKyL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Feb 2009 05:54:11 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n1BAs9WG006304
	for <linux-ext4@vger.kernel.org>; Wed, 11 Feb 2009 02:54:10 -0800
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12686

           Summary: kernel oops __ticket_spin_lock
           Product: File System
           Version: 2.5
     KernelVersion: 2.6.29-rc4
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: dmaciejak@fortinet.com


Latest working kernel version: NA
Earliest failing kernel version: NA
Distribution: Ubuntu
Hardware Environment: Dell Optiplex 740
Software Environment: NA

Hi,

playing around with crafted ext4 fs raised a kernel oops (see attached extract
from kern.log)

Steps to reproduce:
*gunzip the poc enclosed
*mount -t ext4 ext4.poc.img /media/here -o loop
*touch /media/here/test

Regards,

David Maciejak
Fortinet's FortiGuard Global Security Research Team


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
