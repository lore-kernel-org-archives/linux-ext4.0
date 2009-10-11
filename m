From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14370] New: ext4 corruptions
Date: Sun, 11 Oct 2009 20:05:46 GMT
Message-ID: <bug-14370-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:46009 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbZJKUGX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 11 Oct 2009 16:06:23 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9BK5kWj002891
	for <linux-ext4@vger.kernel.org>; Sun, 11 Oct 2009 20:05:46 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14370

           Summary: ext4 corruptions
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.32-rc[1-3]
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: rjw@sisk.pl
            Blocks: 14230
        Regression: Yes


Subject    : ext4 corruptions
Submitter  : Alexey Fisher <bug-track@fisher-privat.net>
Date       : 2009-10-09 19:20
References : http://marc.info/?l=linux-kernel&m=125511643504864&w=4
Notify-Also : Theodore Tso <tytso@mit.edu>
Notify-Also : Eric Sandeen <sandeen@redhat.com>

This entry is being used for tracking a regression from 2.6.31.  Please don't
close it until the problem is fixed in the mainline.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
