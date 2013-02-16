From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 53951] New: race condition on mounting local disks with autofs
Date: Sat, 16 Feb 2013 15:55:41 +0000 (UTC)
Message-ID: <bug-53951-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:51153 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753406Ab3BPPzq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 16 Feb 2013 10:55:46 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 790E7201AB
	for <linux-ext4@vger.kernel.org>; Sat, 16 Feb 2013 15:55:45 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id B1435201B1
	for <linux-ext4@vger.kernel.org>; Sat, 16 Feb 2013 15:55:42 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=53951

           Summary: race condition on mounting local disks with autofs
           Product: File System
           Version: 2.5
    Kernel Version: 3.7.7
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: harri@afaics.de
        Regression: No


I am using autofs to mount a local disk to /misc/data6 on request. Problem: It
seems that the first access silently fails, if the disk is not yet mounted.


Below is an example. Before running it I had umounted /misc/data6 and restarted
autofs.

% find /misc/data6 | wc -l; find /misc/data6 | wc -l
18
find: `/misc/data6/lost+found': Permission denied
358


As you can see, the first "find" sees just a subset of the directory entries.
The second "find" stumbles over lost+found (as expected) and finds all entries.

Kernel is 3.7.7. There is no error message in kernel.log, only a line to
mention the mount:

EXT4-fs (sdd1): mounted filesystem with ordered data mode. Opts: (null)


/etc/auto.master:
/misc   /etc/auto.misc

/etc/auto.misc:
data1   -fstype=auto,noatime    :/dev/disk/by-label/data1
data2   -fstype=auto,noatime    :/dev/disk/by-label/data2
data3   -fstype=auto,noatime    :/dev/disk/by-label/data3
data4   -fstype=auto,noatime    :/dev/disk/by-label/data4
data5   -fstype=auto,noatime    :/dev/disk/by-label/data5
data6   -fstype=auto,noatime    :/dev/disk/by-label/data6
data7   -fstype=auto,noatime    :/dev/disk/by-label/data7
data8   -fstype=auto,noatime    :/dev/disk/by-label/data8


The problem is reproducible, as it seems. Please mail if I can help to track
this down.

Regards
Harri

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
