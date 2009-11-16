From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14619] New: ext3/jbd oops in journal_start
Date: Mon, 16 Nov 2009 21:22:41 GMT
Message-ID: <bug-14619-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:47500 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbZKPVWf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Nov 2009 16:22:35 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nAGLMfns016806
	for <linux-ext4@vger.kernel.org>; Mon, 16 Nov 2009 21:22:41 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14619

           Summary: ext3/jbd oops in journal_start
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.32-rc3
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext3
        AssignedTo: fs_ext3@kernel-bugs.osdl.org
        ReportedBy: rjw@sisk.pl
            Blocks: 14230
        Regression: Yes


Subject    : ext3/jbd oops in journal_start
Submitter  : Sage Weil <sage@newdream.net>
Date       : 2009-10-31 6:14
References : http://marc.info/?l=linux-kernel&m=125696970418300&w=4
Notify-Also : Dmitry Monakhov <rjevskiy@gmail.com>
Notify-Also : Chris Mason <chris.mason@oracle.com>

This entry is being used for tracking a regression from 2.6.31.  Please don't
close it until the problem is fixed in the mainline.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
