From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13992] New: ext3 data=ordered in fstab prevents booting
Date: Sun, 16 Aug 2009 00:46:13 GMT
Message-ID: <bug-13992-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:60937 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814AbZHPAqM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 15 Aug 2009 20:46:12 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n7G0kD1m017339
	for <linux-ext4@vger.kernel.org>; Sun, 16 Aug 2009 00:46:13 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13992

           Summary: ext3 data=ordered in fstab prevents booting
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.30.4
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext3
        AssignedTo: fs_ext3@kernel-bugs.osdl.org
        ReportedBy: rogerx@sdf.lonestar.org
        Regression: No


I ran into a problem when, when setting CONFIG_EXT3_DEFAULTS_TO_ORDERED=n, the
system will not complete booting when data=ordered is set on the root
filesystem within /etc/fstab.

(Can't remember the exact debug output as I've been muddling over possible
e100.c system freezes.)


Some work quick hacks that may help resolve are, fsck the filesystem and
removing the filesystem option from the /etc/fstab file.


This will likely occur with people upgrading from 2.6.29 to 2.6.30 with the
data=ordered filesystem option set in fstab.

(I personally like a more stable filesystem, so I've set
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y due a more severe bug I was tracking down in
2.6.30 concerning e100.c)

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
