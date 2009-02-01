From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12603] New: firefox downloads hang on ext4; fine on ext3
Date: Sun,  1 Feb 2009 14:32:20 -0800 (PST)
Message-ID: <bug-12603-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48846 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753704AbZBAWck (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Feb 2009 17:32:40 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n11MWKu3026785
	for <linux-ext4@vger.kernel.org>; Sun, 1 Feb 2009 14:32:22 -0800
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12603

           Summary: firefox downloads hang on ext4; fine on ext3
           Product: File System
           Version: 2.5
     KernelVersion: 2.6.27.10
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: avery@shadypixel.com


Distribution:

Debian testing/unstable

Software Environment:

Kernel is actually from http://wiki.debian.org/DebianKernel. Version is
2.6.27-1~experimental.1~snapshot.12516, which appears to be based on 2.6.27.10.

Problem Description:

I mentioned this in my last bug report
(http://bugzilla.kernel.org/show_bug.cgi?id=12424), but it seems that was
something unrelated (I think). My firefox downloads have been hanging off and
on since reformatting ext3->ext4. I've finally found a way to reproduce this
100% of the time.

Steps:
1.) download large file to folder on ext4 fs
2.) close all firefox windows except the download manager before download
completes
3.) download will hang at nearly 100%

This happens every single time. If I keep another firefox window open (beside
the downloads mini-window), the download always completes successfully. If I do
the same steps except save the file to an ext3 fs, it always works.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
