From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15252] New: ext4 triggers warning about high order allocations
Date: Sun, 7 Feb 2010 21:30:23 GMT
Message-ID: <bug-15252-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:33977 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837Ab0BGVaY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 7 Feb 2010 16:30:24 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o17LUNNo006624
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sun, 7 Feb 2010 21:30:23 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=15252

           Summary: ext4 triggers warning about high order allocations
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.33-rc6
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


Subject    : 2.6.33-rc6: ext4 triggers warning about high order allocations
Submitter  : "Michael S. Tsirkin" <mst@redhat.com>
Date       : 2010-02-03 6:08
Message-ID : 20100203060854.GA12489@redhat.com
References : http://marc.info/?l=linux-kernel&m=126517754421586&w=4
Handled-By : Eric Sandeen <sandeen@redhat.com>
Patch      : http://marc.info/?l=linux-ext4&m=126523161410367&w=2

This entry is being used for tracking a regression from 2.6.32.  Please don't
close it until the problem is fixed in the mainline.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
