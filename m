From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 41502] New: cfq-iosched: a regression
Date: Sun, 21 Aug 2011 18:49:07 GMT
Message-ID: <bug-41502-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:37739 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab1HUStI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 21 Aug 2011 14:49:08 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.4) with ESMTP id p7LIn7hc007533
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sun, 21 Aug 2011 18:49:07 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=41502

           Summary: cfq-iosched: a regression
           Product: File System
           Version: 2.5
    Kernel Version: 3.1-rc1
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext3
        AssignedTo: fs_ext3@kernel-bugs.osdl.org
        ReportedBy: maciej.rutecki@gmail.com
                CC: shaohua.li@intel.com, rjw@sisk.pl,
                    maciej.rutecki@gmail.com
        Regression: Yes


Subject    : cfq-iosched: a regression
Submitter  : Shaohua Li <shaohua.li@intel.com>
Date       : 2011-08-16 2:47
Message-ID : 1313462826.27321.22.camel@sli10-conroe
References : http://marc.info/?l=linux-kernel&m=131346279329911&w=2

This entry is being used for tracking a regression from 3.0. Please don't
close it until the problem is fixed in the mainline.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
