From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12534] New: ext4 extent structure backwards
Date: Sat, 24 Jan 2009 01:31:39 -0800 (PST)
Message-ID: <bug-12534-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43293 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750957AbZAXJbm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 24 Jan 2009 04:31:42 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0O9Vdln013796
	for <linux-ext4@vger.kernel.org>; Sat, 24 Jan 2009 01:31:40 -0800
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12534

           Summary: ext4 extent structure backwards
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

I was figuring out ext4 with hexedit (don't ask), and I noticed that the extent
structure is backwards.  It's defined in ext4_extents.h with this order:

block(32-bit), len(16), start_hi(16), start_lo(32)

Here's what I see (including 12 byte header):

0A F3 01 00  04 00 00 00  00 00 00 00
00 00 00 00  01 00 00 00  3E 17 13 00
(another 36 bytes of zeros)

You can see that the block is 0x13173e, len is 1, and start is 0.  (The
header's just fine, and only says that there is 1 extent and there can be no
more than 4 extents.)


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
