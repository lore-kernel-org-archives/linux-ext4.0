From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12375] New: ext4_block_to_path block too big cause cpu to burn
Date: Wed,  7 Jan 2009 02:56:33 -0800 (PST)
Message-ID: <bug-12375-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43567 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752178AbZAGK5H (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Jan 2009 05:57:07 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n07AuXLP017839
	for <linux-ext4@vger.kernel.org>; Wed, 7 Jan 2009 02:56:35 -0800
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12375

           Summary: ext4_block_to_path block too big cause cpu to burn
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
Earliest failing kernel version: unknow
Distribution: ubuntu
Hardware Environment: dell optiplex 740
Software Environment:
Problem Description:
when mounting specially crafted ext4 image, after some few seconds (5s),
kern.log is filled with some data and cpu reaches 100%
Steps to reproduce:
bunzip the image file enclosed and mount the image with  mount -t ext4 -o loop
ext4.img /media/tmp

note: i also tried the 2.6.28-ext4-3 patch but it does not help

Regards,

David Maciejak
Fortinet's FortiGuard Global Security Research Team


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
