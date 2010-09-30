From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 19362] New: WARNING: at fs/fs-writeback.c:87
 __mark_inode_dirty+0x1f2/0x230()
Date: Thu, 30 Sep 2010 13:09:40 GMT
Message-ID: <bug-19362-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:37531 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556Ab0I3NJn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Sep 2010 09:09:43 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id o8UD9edn018856
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 30 Sep 2010 13:09:40 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=19362

           Summary: WARNING: at fs/fs-writeback.c:87
                    __mark_inode_dirty+0x1f2/0x230()
           Product: File System
           Version: 2.5
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: trenn@suse.de
        Regression: No


Happens for some time already in latest mainline kernel.
I'll attach relevant dmesg and /etc/mtab parts.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
