From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14936] New: kernel BUG at fs/ext4/inode.c:1063 if attempted to
 use non-ext4 partition with ext4
Date: Tue, 29 Dec 2009 13:01:11 GMT
Message-ID: <bug-14936-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:51503 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbZL2NBM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Dec 2009 08:01:12 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id nBTD1B3c015932
	for <linux-ext4@vger.kernel.org>; Tue, 29 Dec 2009 13:01:11 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14936

           Summary: kernel BUG at fs/ext4/inode.c:1063 if attempted to use
                    non-ext4 partition with ext4
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.33-rc2
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: rjw@sisk.pl
            Blocks: 14885
        Regression: Yes


Subject    : 2.6.33-rc2 allergic to amanda?
Submitter  : Gene Heskett <gene.heskett@verizon.net>
Date       : 2009-12-26 14:13
References : http://marc.info/?l=linux-kernel&m=126183682330809&w=4
Notify-Also : okias <d.okias@gmail.com>
Notify-Also : Dmitry Torokhov <dmitry.torokhov@gmail.com>

This entry is being used for tracking a regression from 2.6.32.  Please don't
close it until the problem is fixed in the mainline.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
