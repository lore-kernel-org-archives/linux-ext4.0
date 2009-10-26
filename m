From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14472] New: EXT4 corruption
Date: Mon, 26 Oct 2009 16:52:41 GMT
Message-ID: <bug-14472-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:53776 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847AbZJZQwh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Oct 2009 12:52:37 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9QGqfQ2026109
	for <linux-ext4@vger.kernel.org>; Mon, 26 Oct 2009 16:52:41 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14472

           Summary: EXT4 corruption
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.32-rc4
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


Subject    : [2.6.32-rc4] + EXT4 corruption
Submitter  : Shawn Starr <shawn.starr@rogers.com>
Date       : 2009-10-13 2:07
References : http://marc.info/?l=linux-kernel&m=125539997508256&w=4
Handled-By : Theodore Tso <tytso@mit.edu>
Notify-Also : Andy Lutomirski <luto@mit.edu>

This entry is being used for tracking a regression from 2.6.31.  Please don't
close it until the problem is fixed in the mainline.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
