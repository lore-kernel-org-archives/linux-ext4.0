From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 17872] New: ext4 does not honour chattr +s attribute
Date: Mon, 6 Sep 2010 02:35:16 GMT
Message-ID: <bug-17872-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:37184 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563Ab0IFCfR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 5 Sep 2010 22:35:17 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id o862ZGio002114
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 6 Sep 2010 02:35:16 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=17872

           Summary: ext4 does not honour chattr +s attribute
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.34
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: enhancement
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: usedonlytosignup@gmail.com
        Regression: No


According to the man page setting this attribute will cause the files blocks to
be zero'd if it is deleted. It says it does this for ext2 and ext3 and does not
mention ext4, so I've marked it as "enhancement" though I think this is really
a bug.

Because it doesn't zero the blocks.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
