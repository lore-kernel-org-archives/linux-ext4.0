From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12424] New: ext4_da_writepages error while downloading a file w/firefox
Date: Sat, 10 Jan 2009 19:52:57 -0800 (PST)
Message-ID: <bug-12424-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60269 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751880AbZAKDxb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 10 Jan 2009 22:53:31 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0B3qvFR032042
	for <linux-ext4@vger.kernel.org>; Sat, 10 Jan 2009 19:52:58 -0800
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12424

           Summary: ext4_da_writepages error while downloading a file
                    w/firefox
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

I was downloading a file in firefox when my machine starting beeping and I
repeatedly had a stacktrace printed to a terminal (see photo).

Steps to reproduce:

This may or may not be related, but ever since I backed up and restored to a
new ext4 filesystem, I've had a lot of trouble downloading stuff with firefox.
Symptoms are I'll get to 100% completed download and then it hangs. The
directory contains the normal .part but firefox never moves it to the proper
name (i.e. whatever.part -> whatever). Most stuff still downloads ok, but I'd
estimate since I've gone ext3->ext4 this has happened ~5 times. Also, I'm
pretty sure when this happens the download isn't 100% correct. The one time I
checked the md5sum did not match.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
