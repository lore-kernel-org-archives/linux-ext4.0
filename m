From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16019] New: Resume from hibernate corrupts ext4
Date: Thu, 20 May 2010 22:49:47 GMT
Message-ID: <bug-16019-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:37860 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002Ab0ETWts (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 May 2010 18:49:48 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o4KMnlZX026473
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 20 May 2010 22:49:47 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16019

           Summary: Resume from hibernate corrupts ext4
           Product: Power Management
           Version: 2.5
    Kernel Version: 2.6.33.4-95
          Platform: All
        OS/Version: Linux
              Tree: Fedora
            Status: NEW
          Severity: high
          Priority: P1
         Component: Hibernation/Suspend
        AssignedTo: power-management_other@kernel-bugs.osdl.org
        ReportedBy: lowe@brown.edu
                CC: fs_ext4@kernel-bugs.osdl.org
        Regression: No


Overview: System appears to hibernate successfully. Upon resume at first sight
all seems well until one discovers it is no longer possible to write to disk.

Steps to reproduce:

1) Hibernate system to disk. (Note suspend to ram seems to work ok).

2) Resume from disk.

3) System starts up ok, but disk seems to be mounted read only. Sometimes
resume just fails and system auto reboots itself and fixes the ext4 disk
errors.

4) Rebooting seems to fix the disk issues.

Expected result:
Resume from hibernate should work ok.

System info: Fedora 13 kernel  2.6.33.4-95.fc13.x86_64
Dell Latitude D630, 2G ram, 4G swap

Attached log messages from suspend/resume cycle. 

First ext4 error is

May 20 06:28:41 trillian kernel: EXT4-fs error (device dm-0):
ext4_mb_generate_buddy: EXT4-fs: group 26: 1161 blocks in bitmap, 1149 in gd
May 20 06:28:41 trillian kernel: JBD: Spotted dirty metadata buffer (dev =
dm-0, blocknr = 0). There's a risk of filesystem corruption in case of system
crash.

then it ends with lots of

May 20 06:50:20 trillian kernel: EXT4-fs error (device dm-0): mb_free_blocks:
double-free of inode 0's block 872631(bit 20663 in group 26)
May 20 06:50:20 trillian kernel: EXT4-fs error (device dm-0): mb_free_blocks:
double-free of inode 0's block 872632(bit 20664 in group 26)

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching someone on the CC list of the bug.
