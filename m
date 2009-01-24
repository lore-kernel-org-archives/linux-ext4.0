From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12533] New: with extents, ext4 block count wrong
Date: Sat, 24 Jan 2009 01:18:52 -0800 (PST)
Message-ID: <bug-12533-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51730 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751017AbZAXJTO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 24 Jan 2009 04:19:14 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0O9Iq0O009391
	for <linux-ext4@vger.kernel.org>; Sat, 24 Jan 2009 01:18:53 -0800
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12533

           Summary: with extents, ext4 block count wrong
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
        ReportedBy: markus@cs.wisc.edu


Latest working kernel version: 2.6.28
Earliest failing kernel version: 2.6.28
Distribution: Gentoo
Hardware Environment: i686
Block size: 4096

I'm trying to recover from a massive data loss with ext4 (root directory
erased), so I'm looking at lots of hexedit output.  Here's one thing that looks
quite wrong:

ED 41 E8 03  00 10 00 00  16 81 73 49  16 81 73 49
16 81 73 49  00 00 00 00  E8 03 03 00  08 00 00 00
00 00 08 00  02 00 00 00  0A F3 01 00  04 00 00 00
00 00 00 00  00 00 00 00  01 00 00 00  3E 17 13 00
00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00
00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00
00 00 00 00  61 27 09 0B  00 00 00 00  00 00 00 00
00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00

The 4 in the second byte indicates this is a directory.  The second word says
the file size is 4096 bytes, the same as the block size.  The eight word says
there are eight blocks.  Last, the extent header has one extent (second half of
the 11th word), and this one extent has a block count of 1 (first half of 15th
word).

The directory contains a single directory.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
