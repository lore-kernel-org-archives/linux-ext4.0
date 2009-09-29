From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14256] New: kernel BUG at fs/ext3/super.c:435
Date: Tue, 29 Sep 2009 21:48:34 GMT
Message-ID: <bug-14256-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:47390 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbZI2Vsa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Sep 2009 17:48:30 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n8TLmYvW009764
	for <linux-ext4@vger.kernel.org>; Tue, 29 Sep 2009 21:48:34 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14256

           Summary: kernel BUG at fs/ext3/super.c:435
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.31
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext3
        AssignedTo: fs_ext3@kernel-bugs.osdl.org
        ReportedBy: rjw@sisk.pl
            Blocks: 13615
        Regression: Yes


Subject    : [2.6.31] kernel BUG at fs/ext3/super.c:435
Submitter  : Mikael Pettersson <mikpe@it.uu.se>
Date       : 2009-09-21 7:29
References : http://marc.info/?l=linux-kernel&m=125351816109264&w=4

This entry is being used for tracking a regression from 2.6.30.  Please don't
close it until the problem is fixed in the mainline.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
