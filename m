From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16401] New: 2.6.35-r5 ext3 corruptions
Date: Thu, 15 Jul 2010 17:44:19 GMT
Message-ID: <bug-16401-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:34266 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933810Ab0GORoV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Jul 2010 13:44:21 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o6FHiKJq028404
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 15 Jul 2010 17:44:20 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16401

           Summary: 2.6.35-r5 ext3 corruptions
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.35-rc5
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext3
        AssignedTo: fs_ext3@kernel-bugs.osdl.org
        ReportedBy: maciej.rutecki@gmail.com
                CC: rjw@sisk.pl, maciej.rutecki@gmail.com,
                    david@fromorbit.com
        Regression: Yes


Subject    : 2.6.35-r5 ext3 corruptions
Submitter  : Dave Chinner <david@fromorbit.com>
Date       : 2010-07-15 10:57
Message-ID : 20100715105745.GI30737@dastard
References : http://marc.info/?l=linux-kernel&m=127919148825845&w=2

This entry is being used for tracking a regression from 2.6.34.  Please don't
close it until the problem is fixed in the mainline.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
