From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15231] New: BUG: soft lockup - CPU#3 stuck for 61s
Date: Fri, 5 Feb 2010 09:38:19 GMT
Message-ID: <bug-15231-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:58588 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932865Ab0BEJiV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Feb 2010 04:38:21 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o159cJAq005422
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 5 Feb 2010 09:38:20 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=15231

           Summary: BUG: soft lockup - CPU#3 stuck for 61s
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.32.7
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: franco@fugro-fsi.com.au
        Regression: No


We recently deployed 9 NFS servers running Linux kernel 2.6.32.7. Each server
exports 4 13TB EXT4 filesystems. During the first 24 hous of testing using
simple sequential reads and writes, 2 of the 9 systems hung with "BUG: soft
lockup - CPU#3 stuck for 61s".

We downgraded the kernel version to 2.6.32.2 and have not had the same problem
after a further 24 hours of testing.

Message file attached.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
