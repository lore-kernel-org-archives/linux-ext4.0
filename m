From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14300] New: BUG_ON crash w/ ext4
Date: Thu, 1 Oct 2009 22:19:30 GMT
Message-ID: <bug-14300-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:34223 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191AbZJAWT0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Oct 2009 18:19:26 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n91MJUak012524
	for <linux-ext4@vger.kernel.org>; Thu, 1 Oct 2009 22:19:30 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14300

           Summary: BUG_ON crash w/ ext4
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
        ReportedBy: rjw@sisk.pl
            Blocks: 14230
        Regression: Yes


Subject    : [Kernel BUG] ext4 for v2.6.32 round II
Submitter  : Markus Trippelsdorf <markus@trippelsdorf.de>
Date       : 2009-10-01 1:41
References : http://marc.info/?l=linux-kernel&m=125436130800340&w=4
Handled-By : Theodore Tso <tytso@mit.edu>
Patch      : http://patchwork.kernel.org/patch/50810/

This entry is being used for tracking a regression from 2.6.31.  Please don't
close it until the problem is fixed in the mainline.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
