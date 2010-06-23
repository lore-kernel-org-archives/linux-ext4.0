From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16278] New: lvm snapshot causes deadlock in 2.6.35
Date: Wed, 23 Jun 2010 16:55:42 GMT
Message-ID: <bug-16278-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:58647 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab0FWQzn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Jun 2010 12:55:43 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o5NGtg38023231
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 23 Jun 2010 16:55:42 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16278

           Summary: lvm snapshot causes deadlock in 2.6.35
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.35-rc[123]
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: psusi@cfl.rr.com
        Regression: Yes


Copying from: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/595489

Attempting to snapshot the root lv causes a deadlock in 2.6.35 when it suspends
the root lv device to replace the table. The lvcreate -n snap -s -L 1g lv/root
command hangs, can not be killed, and no further IO is possible, and the system
must be hard booted with magic-sysrq.

Narrowed down cause to commit 6b0310fbf087ad6: "ext4: don't return to userspace
after freezing the fs with a mutex held".  After reversing this change, the
problem goes away.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
