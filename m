From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16233] New: Fwd: [2.6.34] INFO: task rsync:20019 blocked for
 more than 120 seconds.
Date: Wed, 16 Jun 2010 20:15:50 GMT
Message-ID: <bug-16233-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:54526 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932155Ab0FPUPw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Jun 2010 16:15:52 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o5GKFoIJ002769
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 16 Jun 2010 20:15:50 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16233

           Summary: Fwd: [2.6.34] INFO: task rsync:20019 blocked for more
                    than 120 seconds.
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.34
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: maciej.rutecki@gmail.com
                CC: rjw@sisk.pl, maciej.rutecki@gmail.com
        Regression: Yes


Subject    : Fwd: [2.6.34] INFO: task rsync:20019 blocked for more than 120
seconds.
Submitter  : Jan De Luyck <mailinglists+linuxkernel_20080830@kcore.org>
Date       : 2010-06-14 19:49
Message-ID : AANLkTimutyh3WIALv3NIxA8Xt5JtU6tp4EWOnuSqhdyD@mail.gmail.com
References : http://marc.info/?l=linux-kernel&m=127654498016377&w=2

This entry is being used for tracking a regression from 2.6.33.  Please don't
close it until the problem is fixed in the mainline.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
