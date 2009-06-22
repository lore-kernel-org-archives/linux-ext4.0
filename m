From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13603] New: Fallocate and DirectIO
Date: Mon, 22 Jun 2009 16:47:18 GMT
Message-ID: <bug-13603-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:33339 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335AbZFVQrS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Jun 2009 12:47:18 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n5MGlITx031323
	for <linux-ext4@vger.kernel.org>; Mon, 22 Jun 2009 16:47:18 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13603

           Summary: Fallocate and DirectIO
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
        ReportedBy: aneesh.kumar@linux.vnet.ibm.com
        Regression: No


Have a kernel.org bugzilla entry to track the bug.

http://article.gmane.org/gmane.comp.file-systems.ext4/13762

I noticed yesterday that a write to fallocate
space via directIO results in fallback to buffer_IO. ie the userspace
pages get copied to the page cache and then call a sync.

I guess this defeat the purpose of using directIO. May be we should
consider this a high priority bug.

-aneesh

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
