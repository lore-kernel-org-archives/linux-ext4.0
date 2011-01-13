From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 26642] New: Automatically clean dirty bit on
 ext2/ext4-without-journal file systems
Date: Thu, 13 Jan 2011 15:18:25 GMT
Message-ID: <bug-26642-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:44611 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756871Ab1AMPS0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Jan 2011 10:18:26 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p0DFIPDK000521
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 13 Jan 2011 15:18:25 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=26642

           Summary: Automatically clean dirty bit on
                    ext2/ext4-without-journal file systems
           Product: File System
           Version: 2.5
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: enhancement
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: t.artem@mailcity.com
        Regression: No


In ext2/journalless ext4 if you forget to umount the FS before
rebooting/powering down PC you'll have to run fsck on a next boot. That's
obvious.

However we can easily avoid fsck'ing if we clean the dirty bit about a certain
timeout (I suggest a configurable 300 seconds value) and only after dirty
buffers have been flushed to the disk. If we write to the disk again, then this
bit should be set again, of course.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
